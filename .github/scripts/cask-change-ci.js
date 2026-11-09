const { execFile } = require("node:child_process")
const { mkdtemp, writeFile, rm } = require("node:fs/promises")
const { tmpdir } = require("node:os")
const { join } = require("node:path")
const { promisify } = require("node:util")
const { validateCaskChange } = require("./cask-change-policy")

const execute = promisify(execFile)
const PROCESS_OPTIONS = { timeout: 60_000, killSignal: "SIGKILL", maxBuffer: 1024 * 1024 }

// Deliberately support GitHub release/archive downloads only. Display names,
// homepages and lookalike hosts cannot establish a migration's upstream identity.
function githubRepositoryIdentity(value) {
  let url
  try { url = new URL(value) } catch { throw new Error("Unsupported upstream download URL") }
  if (url.protocol !== "https:" || url.hostname !== "github.com" || url.port || url.username || url.password) {
    throw new Error("Upstream identity requires a GitHub download URL")
  }
  const [, owner, repository, ...download] = url.pathname.split("/")
  if (!/^[a-z0-9-]+$/i.test(owner || "") || !/^[a-z0-9_.-]+$/i.test(repository || "") ||
      [".", ".."].includes(repository) ||
      !((download[0] === "releases" && download[1] === "download" && download.length >= 4) ||
        (download[0] === "archive" && download.length >= 2))) {
    throw new Error("Unsupported GitHub repository download URL")
  }
  return `${owner}/${repository}`.toLowerCase()
}

const INSPECTOR = `require "json"
require "cask/cask_loader"

baseline_path, old_name, tap_name = ARGV
raise "Missing cask route arguments" unless ARGV.length == 3
tap = Tap.fetch(tap_name)
raise "Cask tap is not the checked-out PR" unless tap.path.realpath == Pathname.pwd.realpath

# Only the immutable merge-base recipe is staged. No head recipe is copied into
# the baseline and no trust store, tap registration or installation is changed.
baseline = Cask::CaskLoader::FromContentLoader.new(File.read(baseline_path), tap: tap).load(config: nil)
resolved = Cask::CaskLoader.load(old_name)
snapshot = lambda do |cask|
  {
    token: cask.token,
    tap: cask.tap&.name,
    url: cask.url.to_s,
    version: cask.version.to_s,
    sha256: cask.sha256.to_s,
    artifacts: cask.artifacts_list,
  }
end
puts JSON.generate(baseline: snapshot.call(baseline), resolved: snapshot.call(resolved))
`

async function inspectCaskRoute({ change, tap }) {
  const staging = await mkdtemp(join(tmpdir(), "cask-route-ci-"))
  try {
    const baseline = join(staging, "baseline.rb")
    const inspector = join(staging, "inspect.rb")
    await writeFile(baseline, change.baseSource, { mode: 0o600 })
    await writeFile(inspector, INSPECTOR, { mode: 0o600 })
    const { stdout } = await execute("brew", ["ruby", inspector, baseline, `${tap}/${change.oldToken}`, tap], {
      ...PROCESS_OPTIONS,
      env: {
        ...process.env,
        HOMEBREW_NO_AUTO_UPDATE: "1",
        HOMEBREW_NO_INSTALL_FROM_API: "1",
        HOMEBREW_NO_ANALYTICS: "1",
      },
    })
    return JSON.parse(stdout)
  } finally {
    await rm(staging, { recursive: true, force: true })
  }
}

async function checkoutHead() {
  const { stdout } = await execute("git", ["rev-parse", "HEAD"], PROCESS_OPTIONS)
  return stdout.trim()
}

function validateRouteMetadata(change, tap, metadata) {
  const { baseline, resolved } = metadata || {}
  if (!baseline || baseline.token !== change.oldToken || baseline.tap !== tap) {
    throw new Error("Merge-base cask metadata does not match the original token and tap")
  }
  const expectedTap = change.kind === "migration" ? "homebrew/cask" : tap
  if (!resolved || resolved.tap !== expectedTap || resolved.token !== change.token) {
    throw new Error("Fully qualified old cask name did not resolve to the expected tap and token")
  }
  if (change.kind === "migration") {
    if (githubRepositoryIdentity(baseline.url) !== githubRepositoryIdentity(resolved.url)) {
      throw new Error("Core migration download URLs identify different GitHub repositories")
    }
  } else {
    for (const field of ["url", "version", "sha256", "artifacts"]) {
      if (baseline[field] === undefined || JSON.stringify(baseline[field]) !== JSON.stringify(resolved[field])) {
        throw new Error(`Cask rename changed package metadata: ${field}`)
      }
    }
  }
}

async function withBoundCaskChange({
  github, context, core, readCheckoutHead = checkoutHead,
}, validate) {
  if (context.eventName !== "pull_request") return
  const eventPr = context.payload.pull_request
  const expectedHead = eventPr?.head?.sha
  if (!/^[a-f0-9]{40}$/i.test(expectedHead || "")) throw new Error("Missing event PR head")
  const expectedCheckout = context.sha
  if (!/^[a-f0-9]{40}$/i.test(expectedCheckout || "")) throw new Error("Missing event checkout revision")
  const { owner, repo } = context.repo
  const params = { owner, repo, pull_number: eventPr.number }
  const boundPr = async () => {
    const { data: pr } = await github.rest.pulls.get(params)
    if (pr.head.sha !== expectedHead || pr.base.ref !== eventPr.base.ref ||
        pr.head.repo?.full_name !== eventPr.head.repo?.full_name) {
      throw new Error("PR head or base changed during cask route validation; rerun current-head CI")
    }
    return pr
  }
  // pull_request checkout uses GitHub's event merge commit, not the source head.
  const assertCheckout = async () => {
    if (await readCheckoutHead() !== expectedCheckout) throw new Error("Checkout does not match the event merge commit")
  }
  await assertCheckout()
  const pr = await boundPr()
  const files = await github.paginate(github.rest.pulls.listFiles, { ...params, per_page: 100 })
  if (files.length !== pr.changed_files) throw new Error("Incomplete PR changed-file metadata")
  await boundPr()
  const change = await validateCaskChange({ github, owner, repo, pr, files })
  if (!change.eligible) throw new Error(change.reason)
  const tap = `${owner}/${repo.replace(/^homebrew-/, "")}`.toLowerCase()
  await validate(change, tap)
  await assertCheckout()
  await boundPr()
  core.info(`Cask change policy passed: ${change.kind}`)
  return change
}

async function validateCaskChangeCI(options) {
  const inspect = options.inspect || inspectCaskRoute
  return withBoundCaskChange(options, async (change, tap) => {
    if (change.kind === "migration" || (change.kind === "rename" && options.verifyRename !== false)) {
      validateRouteMetadata(change, tap, await inspect({ change, tap }))
    }
  })
}

async function validateCaskChangeMatrix(options) {
  return withBoundCaskChange(options, async (change, tap) => {
    if (change.kind !== "rename") return
    // Syntax jobs have no cask-scoped trust. The existing per-cask jobs must
    // perform native alias verification, and conclusion requires their success.
    const verifiedJob = Array.isArray(options.matrix) && options.matrix.some(job =>
      job?.tap === tap && job?.cask?.token === change.token &&
      job.cask.path === `./${change.newPath}`)
    if (!verifiedJob) {
      throw new Error("Rename requires a native cask verification job; syntax-only or unsupported-runner renames cannot qualify")
    }
  })
}

module.exports = { validateCaskChangeCI, validateCaskChangeMatrix, githubRepositoryIdentity }
