const assert = require("node:assert/strict")
const test = require("node:test")

const environment = require("./environment.js")

const repository = "chenrui333/homebrew-tap"

const bottleCommitEmail = "1589480+BrewTestBot@users.noreply.github.com"
const authorCommit = {
  message: "watchfiles 1.3.1",
  author: {email: "rui@chenrui.dev"},
  committer: {email: "rui@chenrui.dev"},
}
const bottleCommit = {
  message: "watchfiles: update 1.3.1 bottle.",
  author: {email: bottleCommitEmail},
  committer: {email: bottleCommitEmail},
}

async function runEnvironment({
  formulaFile,
  eventName = "pull_request",
  formulaDetect = {testing_formulae: "watchfiles", added_formulae: "", deleted_formulae: ""},
  labels = [],
  headSha = "a".repeat(40),
  commitStatuses = {},
  headRef = "change-formula",
  headRepository = repository,
  headCommit = authorCommit,
  publication = [],
}) {
  const outputs = new Map()
  const apiCalls = []
  const sleeps = []
  // Each pulls.get advances to the next published PR state; the payload state comes first.
  let current = {labels, commitStatuses, headSha}
  const listCommitStatusesForRef = async ({ref}) => {
    apiCalls.push("repos.listCommitStatusesForRef")
    return current.commitStatuses[ref] ?? []
  }
  const github = {
    rest: {
      git: {
        getCommit: async ({commit_sha}) => {
          apiCalls.push("git.getCommit")
          assert.equal(commit_sha, headSha)
          return {data: headCommit}
        },
      },
      pulls: {
        get: async () => {
          apiCalls.push("pulls.get")
          if (publication.length) current = {...current, ...publication.shift()}
          return {data: {labels: current.labels.map((name) => ({name})), head: {sha: current.headSha}}}
        },
        listFiles: async () => {
          apiCalls.push("pulls.listFiles")
          return {data: formulaFile ? [{filename: formulaFile}] : []}
        },
      },
      repos: {listCommitStatusesForRef},
    },
    paginate: async (method, params) => {
      if (method === listCommitStatusesForRef) return listCommitStatusesForRef(params)
      apiCalls.push("paginate")
      return formulaFile ? [{filename: formulaFile}] : []
    },
  }
  const context = {
    eventName,
    issue: {number: 1},
    repo: {owner: repository.split("/")[0], repo: repository.split("/")[1]},
    payload: {pull_request: {head: {sha: headSha, ref: headRef, repo: {full_name: headRepository}}, labels: labels.map((name) => ({name}))}},
  }
  const core = {
    setOutput: (name, value) => outputs.set(name, value),
  }

  await environment({github, context, core}, formulaDetect, {
    sleep: async (ms) => { sleeps.push(ms) },
    publication_wait_ms: 30_000,
    publication_poll_ms: 10_000,
  })
  return {outputs, apiCalls, sleeps}
}

async function buildMatrix(formulaFile, eventName = "pull_request") {
  const {outputs} = await runEnvironment({formulaFile, eventName})
  return JSON.parse(outputs.get("build-matrix")).map(({runner}) => runner)
}

test("generates the supported cross-platform formula matrix", async () => {
  assert.deepEqual(await buildMatrix("Formula/w/watchfiles.rb"), [
    "macos-26",
    "macos-15",
    "ubuntu-24.04",
    "ubuntu-24.04-arm",
  ])
})

test("generates the supported macOS-only formula matrix", async () => {
  assert.deepEqual(await buildMatrix("Formula/c/ctxmv.rb"), [
    "macos-26",
    "macos-15",
  ])
})

test("generates the supported Linux-only formula matrix", async () => {
  assert.deepEqual(await buildMatrix("Formula/w/wild.rb"), [
    "ubuntu-24.04",
    "ubuntu-24.04-arm",
  ])
})

test("does not generate obsolete formula macOS runners", async () => {
  const matrices = await Promise.all([
    buildMatrix("Formula/w/watchfiles.rb"),
    buildMatrix("Formula/c/ctxmv.rb"),
    buildMatrix("Formula/w/wild.rb"),
  ])
  const runners = matrices.flat()

  assert.equal(runners.includes("macos-14"), false)
  assert.equal(runners.includes("macos-15-intel"), false)
})

test("merge_group avoids PR APIs and uses the full supported formula matrix", async () => {
  const {outputs, apiCalls} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
    eventName: "merge_group",
    formulaDetect: {
      testing_formulae: "watchfiles",
      added_formulae: "",
      deleted_formulae: "",
    },
  })

  assert.deepEqual(apiCalls, [])
  assert.deepEqual(JSON.parse(outputs.get("build-matrix")).map(({runner}) => runner), [
    "macos-26",
    "macos-15",
    "ubuntu-24.04",
    "ubuntu-24.04-arm",
  ])
  assert.match(outputs.get("test-bot-formulae-args"), /--testing-formulae=watchfiles/)
})

test("merge_group with no detected formulae is syntax-only", async () => {
  const {outputs, apiCalls} = await runEnvironment({
    eventName: "merge_group",
    formulaDetect: {
      testing_formulae: "",
      added_formulae: "",
      deleted_formulae: "",
    },
  })

  assert.deepEqual(apiCalls, [])
  assert.equal(outputs.get("syntax-only"), "true")
})

test("pull request with no detected formulae does not build the full tap", async () => {
  const {outputs} = await runEnvironment({
    formulaDetect: {
      testing_formulae: "",
      added_formulae: "",
      deleted_formulae: "",
    },
  })

  assert.equal(outputs.get("syntax-only"), "true")
})

test("push keeps the non-PR full formula matrix behavior", async () => {
  const {outputs, apiCalls} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
    eventName: "push",
  })

  assert.deepEqual(apiCalls, [])
  assert.deepEqual(JSON.parse(outputs.get("build-matrix")).map(({runner}) => runner), [
    "macos-26",
    "macos-15",
    "ubuntu-24.04",
    "ubuntu-24.04-arm",
  ])
})

function publishedStatus({state = "success", login = "github-actions[bot]", context = "homebrew-tap/published-bottle-head"} = {}) {
  return {context, state, creator: {login}}
}

async function publishedBottleRun({headSha = "a".repeat(40), commitStatuses}) {
  const {outputs, apiCalls} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
    labels: ["CI-published-bottle-commits"],
    headSha,
    commitStatuses,
  })
  return {syntaxOnly: outputs.get("syntax-only"), apiCalls}
}

test("a published-bottle status on the pull request head makes it syntax-only", async () => {
  const headSha = "a".repeat(40)
  const {syntaxOnly, apiCalls} = await publishedBottleRun({headSha, commitStatuses: {[headSha]: [publishedStatus()]}})

  assert.equal(syntaxOnly, "true")
  assert.equal(apiCalls.includes("repos.listCommitStatusesForRef"), true)
})

test("a published-bottle status on an older commit does not skip a newer pull request head", async () => {
  const {syntaxOnly} = await publishedBottleRun({
    headSha: "b".repeat(40),
    commitStatuses: {["a".repeat(40)]: [publishedStatus()]},
  })

  assert.equal(syntaxOnly, "false")
})

for (const [name, status] of [
  ["another creator", publishedStatus({login: "chenrui333"})],
  ["a pending state", publishedStatus({state: "pending"})],
  ["a failure state", publishedStatus({state: "failure"})],
  ["another context", publishedStatus({context: "homebrew-tap/other"})],
]) {
  test(`a published-bottle status with ${name} does not skip the pull request head`, async () => {
    const headSha = "a".repeat(40)
    const {syntaxOnly} = await publishedBottleRun({headSha, commitStatuses: {[headSha]: [status]}})

    assert.equal(syntaxOnly, "false")
  })
}

test("a newer non-success bot status supersedes an older published-bottle status", async () => {
  const headSha = "a".repeat(40)
  const {syntaxOnly} = await publishedBottleRun({
    headSha,
    commitStatuses: {[headSha]: [publishedStatus({state: "error"}), publishedStatus()]},
  })

  assert.equal(syntaxOnly, "false")
})

test("a published-bottle status is ignored without the published-bottle label", async () => {
  const headSha = "a".repeat(40)
  const {outputs, apiCalls} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
    headSha,
    commitStatuses: {[headSha]: [publishedStatus()]},
  })

  assert.equal(outputs.get("syntax-only"), "false")
  assert.equal(apiCalls.includes("repos.listCommitStatusesForRef"), false)
})

async function bottleHeadRun({headCommit = bottleCommit, labels = [], commitStatuses = {}, publication = []} = {}) {
  const {outputs, apiCalls, sleeps} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
    headCommit,
    labels,
    commitStatuses,
    publication,
  })
  return {syntaxOnly: outputs.get("syntax-only"), apiCalls, sleeps}
}

const published = (headSha = "a".repeat(40)) =>
  ({labels: ["CI-published-bottle-commits"], commitStatuses: {[headSha]: [publishedStatus()]}})

test("a bottle commit head waits for publication to be recorded and then is syntax-only", async () => {
  const {syntaxOnly, sleeps} = await bottleHeadRun({publication: [{}, published()]})

  assert.equal(syntaxOnly, "true")
  assert.deepEqual(sleeps, [10_000, 10_000])
})

test("a bottle commit head re-reads labels instead of trusting the stale event payload", async () => {
  const headSha = "a".repeat(40)
  const {syntaxOnly} = await bottleHeadRun({
    commitStatuses: {[headSha]: [publishedStatus()]},
    publication: [{labels: ["CI-published-bottle-commits"]}],
  })

  assert.equal(syntaxOnly, "true")
})

test("a bottle commit head with an existing label still waits for its own published status", async () => {
  const {syntaxOnly, sleeps} = await bottleHeadRun({
    labels: ["CI-published-bottle-commits"],
    publication: [published()],
  })

  assert.equal(syntaxOnly, "true")
  assert.deepEqual(sleeps, [10_000])
})

for (const [name, state] of [
  ["is never recorded", {}],
  ["is labeled without a head status", {labels: ["CI-published-bottle-commits"]}],
  ["has a status but no label", {commitStatuses: {["a".repeat(40)]: [publishedStatus()]}}],
  ["has a status only on another commit", published("b".repeat(40))],
]) {
  test(`a bottle commit head whose publication ${name} falls back to the full build after the wait`, async () => {
    const {syntaxOnly, sleeps} = await bottleHeadRun({publication: [state]})

    assert.equal(syntaxOnly, "false")
    assert.deepEqual(sleeps, [10_000, 10_000, 10_000])
  })
}

test("a bottle commit head stops waiting when the pull request head moves", async () => {
  const newerHead = "b".repeat(40)
  const {syntaxOnly, sleeps} = await bottleHeadRun({publication: [{...published(newerHead), headSha: newerHead}]})

  assert.equal(syntaxOnly, "false")
  assert.deepEqual(sleeps, [10_000])
})

for (const [name, headCommit] of [
  ["an ordinary formula commit", authorCommit],
  ["a bottle subject from another author", {...bottleCommit, author: {email: "rui@chenrui.dev"}}],
  ["a bottle subject from another committer", {...bottleCommit, committer: {email: "rui@chenrui.dev"}}],
  ["a bottle-like subject with extra text", {...bottleCommit, message: "watchfiles: update 1.3.1 bottle.\n\nCo-authored-by: someone"}],
]) {
  test(`${name} does not wait for bottle publication`, async () => {
    const {syntaxOnly, apiCalls, sleeps} = await bottleHeadRun({headCommit, publication: [published()]})

    assert.equal(syntaxOnly, "false")
    assert.deepEqual(sleeps, [])
    assert.equal(apiCalls.includes("pulls.get"), false)
  })
}

test("a pull request already skipping builds does not inspect the head commit", async () => {
  const {outputs, apiCalls} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
    labels: ["CI-syntax-only"],
    headCommit: bottleCommit,
  })

  assert.equal(outputs.get("syntax-only"), "true")
  assert.deepEqual(apiCalls.filter((call) => call !== "paginate"), [])
})

test("ordinary pull requests still run the formula build path", async () => {
  const {outputs} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
  })

  assert.equal(outputs.get("syntax-only"), "false")
})

test("same-repository autobump pull requests disable matrix fail-fast before the label is applied", async () => {
  const {outputs} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
    headRef: "bump-watchfiles-1.3.1",
  })

  assert.equal(outputs.get("fail-fast"), "false")
})

test("autobump pull requests from forks keep the default matrix fail-fast", async () => {
  const {outputs} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
    headRef: "bump-watchfiles-1.3.1",
    headRepository: "fork/homebrew-tap",
  })

  assert.equal(outputs.get("fail-fast"), "true")
})

test("pull request labels come from the event payload without a pull request API lookup", async () => {
  const {apiCalls} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
    labels: ["CI-no-fail-fast"],
  })

  assert.equal(apiCalls.includes("pulls.get"), false)
})
