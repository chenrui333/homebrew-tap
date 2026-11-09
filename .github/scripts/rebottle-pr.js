const { createHash } = require("node:crypto")

const SHA = /^[a-f0-9]{40}$/i
const TOKEN = /^[a-z0-9][a-z0-9+@._-]*$/

function dispatch(context) {
  if (context.eventName !== "workflow_dispatch" || context.ref !== "refs/heads/main") {
    throw new Error("Rebottle requests must use the main workflow")
  }
  if (!Number.isSafeInteger(context.runId) || context.runId <= 0) throw new Error("Invalid run identity")
  return context.repo
}

function tree(data) {
  if (!data || data.truncated !== false || !Array.isArray(data.tree) || !SHA.test(data.sha || "")) {
    throw new Error("Incomplete immutable repository tree")
  }
  return data
}

function recipe(entries, token) {
  const matches = entries.filter(entry => typeof entry.path === "string" &&
    entry.path.startsWith("Formula/") && entry.path.split("/").at(-1) === `${token}.rb`)
  if (matches.length !== 1) throw new Error("Select exactly one formula in this tap")
  const entry = matches[0]
  if (entry.path.split("/").some(part => !part || part === "." || part === "..") ||
      entry.type !== "blob" || !["100644", "100755"].includes(entry.mode) || !SHA.test(entry.sha || "")) {
    throw new Error("The selected formula must be a regular Git source file")
  }
  return entry
}

async function existingPull(github, repository, path) {
  const pulls = await github.paginate(github.rest.pulls.list, { ...repository, state: "open", per_page: 100 })
  for (const pull of pulls) {
    const files = await github.paginate(github.rest.pulls.listFiles, {
      ...repository, pull_number: pull.number, per_page: 100,
    })
    if (files.some(file => file.filename === path)) return pull
  }
  return null
}

async function planRebottle({ github, context }) {
  const repository = dispatch(context)
  if (!SHA.test(context.sha || "")) throw new Error("Missing immutable dispatch revision")
  const tap = `${repository.owner}/${repository.repo.replace(/^homebrew-/, "")}`
  const input = context.payload.inputs?.formula?.trim()
  const token = input?.startsWith(`${tap}/`) ? input.slice(tap.length + 1) : input
  if (!TOKEN.test(token || "")) throw new Error("Select one bare formula or a formula qualified by this tap")
  const { data } = await github.rest.git.getTree({ ...repository, tree_sha: context.sha, recursive: "1" })
  const selected = recipe(tree(data).tree, token)
  const prior = await existingPull(github, repository, selected.path)
  if (prior) return { kind: "existing", number: prior.number, url: prior.html_url }
  return {
    kind: "new", token, path: selected.path, sourceSha: selected.sha,
    qualifiedFormula: `${tap}/${token}`,
  }
}

function blob(source) {
  const bytes = Buffer.from(source, "utf8")
  return createHash("sha1").update(`blob ${bytes.length}\0`).update(bytes).digest("hex")
}

async function sourceAt(github, repository, path, ref) {
  const { data } = await github.rest.repos.getContent({ ...repository, path, ref })
  if (data.type !== "file" || data.path !== path || data.encoding !== "base64" || typeof data.content !== "string") {
    throw new Error("Invalid formula contents response")
  }
  const bytes = Buffer.from(data.content, "base64")
  const source = bytes.toString("utf8")
  if (data.size !== bytes.length || !Buffer.from(source, "utf8").equals(bytes) || blob(source) !== data.sha) {
    throw new Error("Formula source does not match its immutable Git blob")
  }
  return { source, sha: data.sha }
}

function revisionOnly(before, after) {
  if (typeof after !== "string") throw new Error("Missing rebuilt formula source")
  const revisions = source => [...source.matchAll(/^  revision (\d+)\r?$/gm)]
  const old = revisions(before), next = revisions(after)
  if (old.length > 1 || next.length !== 1 ||
      BigInt(next[0][1]) !== (old.length ? BigInt(old[0][1]) : 0n) + 1n ||
      before.replace(/^  revision \d+\r?\n/m, "") !== after.replace(/^  revision \d+\r?\n/m, "")) {
    throw new Error("Rebottle may change only the selected formula revision by one; preserve bottles and all other source")
  }
}

async function publishRebottle({ github, context, plan, content }) {
  const repository = dispatch(context)
  if (plan?.kind !== "new" || !TOKEN.test(plan.token || "") || !SHA.test(plan.sourceSha || "")) {
    throw new Error("Invalid rebuild plan")
  }
  const prior = await existingPull(github, repository, plan.path)
  if (prior) return { kind: "existing", number: prior.number, url: prior.html_url }

  const { data: main } = await github.rest.git.getRef({ ...repository, ref: "heads/main" })
  const base = main.object.sha
  if (!SHA.test(base || "")) throw new Error("Invalid main revision")
  const { data: inventory } = await github.rest.git.getTree({ ...repository, tree_sha: base, recursive: "1" })
  const current = recipe(tree(inventory).tree, plan.token)
  if (current.path !== plan.path || current.sha !== plan.sourceSha) {
    throw new Error("The selected formula changed on main; dispatch a fresh rebuild instead of overwriting it")
  }
  const original = await sourceAt(github, repository, current.path, base)
  if (original.sha !== plan.sourceSha) throw new Error("Formula contents changed after source selection")
  revisionOnly(original.source, content)

  const branch = `automation/rebottle/${plan.token}-rebuild`
  const subject = `${plan.token}: revision bump`
  if (subject.length > 50) throw new Error("Formula name exceeds the commit subject limit")
  const { data: rebuiltTree } = await github.rest.git.createTree({
    ...repository, base_tree: inventory.sha,
    tree: [{ path: current.path, mode: current.mode, type: "blob", content }],
  })
  const { data: commit } = await github.rest.git.createCommit({
    ...repository, tree: rebuiltTree.sha, parents: [base],
    message: `${subject}\n\nSigned-off-by: Rui Chen <rui@chenrui.dev>`,
  })
  let expectedHead = commit.sha
  try {
    await github.rest.git.createRef({ ...repository, ref: `refs/heads/${branch}`, sha: expectedHead })
  } catch (error) {
    if (error.status !== 422) throw error
    const { data: existing } = await github.rest.git.getRef({ ...repository, ref: `heads/${branch}` })
    const { data: ancestry } = await github.rest.repos.compareCommitsWithBasehead({
      ...repository, basehead: `${existing.object.sha}...${base}`,
    })
    if (["ahead", "identical"].includes(ancestry.status)) {
      // Fast-forward only: never force a bot branch or discard concurrent work.
      await github.rest.git.updateRef({ ...repository, ref: `heads/${branch}`, sha: expectedHead, force: false })
    } else {
      const { data: changes } = await github.rest.repos.compareCommitsWithBasehead({
        ...repository, basehead: `${base}...${existing.object.sha}`,
      })
      const files = changes.files
      const existingSource = await sourceAt(github, repository, current.path, existing.object.sha)
      if (!Array.isArray(files) || files.length !== 1 || files[0].filename !== current.path ||
          files[0].status !== "modified" || existingSource.source !== content) {
        throw new Error("Existing rebuild branch contains different work; leaving it untouched")
      }
      expectedHead = existing.object.sha
    }
  }

  let pull
  try {
    const { data } = await github.rest.pulls.create({
      ...repository, head: branch, base: "main", title: subject,
      body: "Rebuild requested through the normal source-test, pr-pull and formula-merge workflows.",
    })
    pull = data
  } catch (error) {
    if (error.status !== 422) throw error
    const pulls = await github.paginate(github.rest.pulls.list, {
      ...repository, state: "open", head: `${repository.owner}:${branch}`, base: "main", per_page: 100,
    })
    pull = pulls.find(candidate => candidate.head.sha === expectedHead)
    if (!pull) throw error
  }
  if (pull.head.sha !== expectedHead) throw new Error("Rebuild branch advanced; retain the PR for review, do not overwrite it")
  await github.rest.issues.addLabels({ ...repository, issue_number: pull.number, labels: ["CI-no-fail-fast"] })
  return { kind: "created", number: pull.number, url: pull.html_url }
}

module.exports = { planRebottle, publishRebottle }
