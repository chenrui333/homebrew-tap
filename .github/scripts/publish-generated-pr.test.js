const assert = require("node:assert/strict")
const { chmodSync, mkdtempSync, readFileSync, rmSync, writeFileSync } = require("node:fs")
const { tmpdir } = require("node:os")
const { join } = require("node:path")
const { spawnSync } = require("node:child_process")
const test = require("node:test")

const helper = join(__dirname, "publish-generated-pr.sh")
const repository = "example/homebrew-tap"
const branch = "automation/test-generated-pr"

function run(command, args, options = {}) {
  const result = spawnSync(command, args, { encoding: "utf8", ...options })
  assert.equal(result.status, 0, `${command} ${args.join(" ")} failed:\n${result.stderr}`)
  return result.stdout.trim()
}

function git(directory, ...args) {
  return run("git", ["-C", directory, ...args])
}

function commit(directory, message) {
  git(directory, "add", "generated.txt")
  git(directory, "commit", "-m", message)
  return git(directory, "rev-parse", "HEAD")
}

function setup({ mainContent, branchContent = null, workingContent = mainContent, openPr = false }) {
  const root = mkdtempSync(join(tmpdir(), "publish-generated-pr-"))
  const remote = join(root, "remote.git")
  const seed = join(root, "seed")
  const work = join(root, "work")
  const fakeBin = join(root, "bin")
  const stateFile = join(root, "gh-state.json")

  run("git", ["init", "--bare", remote])
  run("git", ["init", seed])
  git(seed, "config", "user.name", "test")
  git(seed, "config", "user.email", "test@example.invalid")
  git(seed, "remote", "add", "origin", remote)
  writeFileSync(join(seed, "generated.txt"), `${mainContent}\n`)
  const mainSha = commit(seed, "main")
  git(seed, "branch", "-M", "main")
  git(seed, "push", "origin", "HEAD:refs/heads/main")

  let remoteSha = ""
  if (branchContent !== null) {
    git(seed, "checkout", "-b", branch)
    writeFileSync(join(seed, "generated.txt"), `${branchContent}\n`)
    remoteSha = commit(seed, "automation branch")
    git(seed, "push", "origin", `HEAD:refs/heads/${branch}`)
    git(seed, "checkout", "main")
  }

  run("git", ["clone", "--branch", "main", remote, work])
  git(work, "config", "user.name", "test")
  git(work, "config", "user.email", "test@example.invalid")
  git(work, "checkout", "-B", branch, "origin/main")
  writeFileSync(join(work, "generated.txt"), `${workingContent}\n`)

  writeFileSync(stateFile, JSON.stringify({
    branch,
    number: 7,
    open: openPr,
    repo: repository,
    edited: false,
  }))
  run("mkdir", ["-p", fakeBin])
  const fakeGh = join(fakeBin, "gh")
  writeFileSync(fakeGh, `#!/usr/bin/env node
const fs = require("node:fs")
const stateFile = process.env.FAKE_GH_STATE
const state = JSON.parse(fs.readFileSync(stateFile, "utf8"))
const args = process.argv.slice(2)
const value = (name) => args[args.indexOf(name) + 1]

if (args[0] !== "pr") process.exit(2)
if (args[1] === "list") {
  if (state.open) console.log([state.number, state.branch, state.repo].join("\\t"))
} else if (args[1] === "create") {
  state.open = true
  state.branch = value("--head")
  fs.writeFileSync(stateFile, JSON.stringify(state))
} else if (args[1] === "edit") {
  state.edited = true
  fs.writeFileSync(stateFile, JSON.stringify(state))
} else if (args[1] === "close") {
  state.open = false
  fs.writeFileSync(stateFile, JSON.stringify(state))
} else {
  process.exit(2)
}
`)
  chmodSync(fakeGh, 0o755)

  return { mainSha, remote, remoteSha, root, seed, stateFile, work }
}

function runPublish(scenario, remoteSha = scenario.remoteSha) {
  const outputFile = join(scenario.root, "github-output")
  const env = {
    ...process.env,
    BASE_SHA: scenario.mainSha,
    BRANCH: branch,
    COMMIT_MESSAGE: "chore: generated update",
    GH_TOKEN: "test-token",
    GITHUB_OUTPUT: outputFile,
    GITHUB_REPOSITORY: repository,
    FAKE_GH_STATE: scenario.stateFile,
    PATH: `${join(scenario.root, "bin")}:${process.env.PATH}`,
    PR_BODY: "Generated test PR",
    PR_TITLE: "chore: generated update",
    REMOTE_SHA: remoteSha,
  }
  return spawnSync("bash", [helper, "publish", "generated.txt"], {
    cwd: scenario.work,
    encoding: "utf8",
    env,
  })
}

function cleanup(scenario) {
  rmSync(scenario.root, { recursive: true, force: true, maxRetries: 3, retryDelay: 50 })
}

function state(scenario) {
  return JSON.parse(readFileSync(scenario.stateFile, "utf8"))
}

function remoteBranch(scenario) {
  return git(scenario.remote, "rev-parse", `refs/heads/${branch}`)
}

test("rejects main and non-automation branches before any git operation", () => {
  for (const invalidBranch of ["main", "feature/generated-pr"]) {
    const result = spawnSync("bash", [helper, "prepare"], {
      encoding: "utf8",
      env: { ...process.env, BRANCH: invalidBranch },
    })
    assert.notEqual(result.status, 0)
    assert.match(result.stderr, /Refusing/)
  }
})

test("creates a PR when the generated branch does not exist", () => {
  const scenario = setup({ mainContent: "old", workingContent: "new" })
  try {
    const result = runPublish(scenario, "")
    assert.equal(result.status, 0, `${result.stderr}\nremote=${run("git", ["ls-remote", "--heads", scenario.remote, `refs/heads/${branch}`])}\nexpected=${scenario.remoteSha}`)
    assert.equal(state(scenario).open, true)
    assert.equal(git(scenario.remote, "show", `refs/heads/${branch}:generated.txt`), "new")
  } finally {
    cleanup(scenario)
  }
})

test("refreshes the existing PR branch instead of creating another PR", () => {
  const scenario = setup({ mainContent: "main", branchContent: "old", workingContent: "new", openPr: true })
  try {
    const result = runPublish(scenario)
    assert.equal(result.status, 0, `${result.stderr}\nremote=${run("git", ["ls-remote", "--heads", scenario.remote, `refs/heads/${branch}`])}\nexpected=${scenario.remoteSha}`)
    assert.equal(state(scenario).edited, true)
    assert.equal(git(scenario.remote, "show", `refs/heads/${branch}:generated.txt`), "new")
  } finally {
    cleanup(scenario)
  }
})

test("force-with-lease refuses a branch changed after observation", () => {
  const scenario = setup({ mainContent: "main", branchContent: "old", workingContent: "new" })
  try {
    const observedSha = scenario.remoteSha
    git(scenario.seed, "checkout", branch)
    writeFileSync(join(scenario.seed, "generated.txt"), "concurrent\n")
    commit(scenario.seed, "concurrent update")
    git(scenario.seed, "push", "origin", "HEAD:refs/heads/" + branch)

    const result = runPublish(scenario, observedSha)
    assert.notEqual(result.status, 0)
    assert.equal(remoteBranch(scenario), git(scenario.seed, "rev-parse", "HEAD"))
  } finally {
    cleanup(scenario)
  }
})

test("does not create a branch or PR when output is unchanged", () => {
  const scenario = setup({ mainContent: "same" })
  try {
    const result = runPublish(scenario, "")
    assert.equal(result.status, 0, result.stderr)
    assert.equal(state(scenario).open, false)
    assert.equal(run("git", ["ls-remote", "--heads", scenario.remote, `refs/heads/${branch}`]), "")
  } finally {
    cleanup(scenario)
  }
})

test("closes and deletes a stale generated PR when output is current", () => {
  const scenario = setup({ mainContent: "new", branchContent: "old", openPr: true })
  try {
    const result = runPublish(scenario)
    assert.equal(result.status, 0, result.stderr)
    assert.equal(state(scenario).open, false)
    assert.equal(run("git", ["ls-remote", "--heads", scenario.remote, `refs/heads/${branch}`]), "")
  } finally {
    cleanup(scenario)
  }
})
