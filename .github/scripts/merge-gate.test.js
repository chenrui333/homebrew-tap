const assert = require("node:assert/strict")
const test = require("node:test")

const {
  aggregateCheckRuns,
  classifyChangedFiles,
  determineRequirements,
  pollCheckRuns,
} = require("./merge-gate.js")

const repository = "chenrui333/homebrew-tap"

function requirementsFor(eventName, files = []) {
  const apiCalls = []
  const github = {
    rest: {pulls: {listFiles: async () => {
      apiCalls.push("pulls.listFiles")
      return {data: files.map((filename) => ({filename}))}
    }}},
    paginate: async () => files.map((filename) => ({filename})),
  }
  const context = {
    eventName,
    issue: {number: 11000},
    repo: {owner: repository.split("/")[0], repo: repository.split("/")[1]},
  }
  return determineRequirements({github, context}).then((result) => ({result, apiCalls}))
}

test("classifies formula, cask, mixed, and unrelated paths", () => {
  assert.deepEqual(classifyChangedFiles(["Formula/a/example.rb"]), {formula: true, cask: false})
  assert.deepEqual(classifyChangedFiles([".github/workflows/tests.yml"]), {formula: true, cask: false})
  assert.deepEqual(classifyChangedFiles([".github/scripts/environment.js"]), {formula: true, cask: false})
  assert.deepEqual(classifyChangedFiles(["Casks/example.rb"]), {formula: false, cask: true})
  assert.deepEqual(classifyChangedFiles([".github/workflows/cask-tests.yml"]), {formula: false, cask: true})
  assert.deepEqual(classifyChangedFiles(["Formula/a/example.rb", "Casks/example.rb"]), {formula: true, cask: true})
  assert.deepEqual(classifyChangedFiles(["README.md", "docs/ci.md"]), {formula: false, cask: false})
})

test("pull requests require only the relevant domain conclusions", async () => {
  await assert.doesNotReject(async () => {
    const formula = await requirementsFor("pull_request", ["Formula/a/example.rb"])
    assert.deepEqual(formula.result.expectedChecks, ["formula-conclusion"])
    assert.equal(formula.result.actionlint, false)

    const cask = await requirementsFor("pull_request", ["Casks/example.rb"])
    assert.deepEqual(cask.result.expectedChecks, ["cask-conclusion"])

    const mixed = await requirementsFor("pull_request", ["Formula/a/example.rb", "Casks/example.rb"])
    assert.deepEqual(mixed.result.expectedChecks, ["formula-conclusion", "cask-conclusion"])

    const other = await requirementsFor("pull_request", ["README.md"])
    assert.deepEqual(other.result.expectedChecks, [])
  })
})

test("workflow changes require actionlint and formula CI when appropriate", async () => {
  const formulaWorkflow = await requirementsFor("pull_request", [".github/workflows/tests.yml"])
  assert.deepEqual(formulaWorkflow.result.expectedChecks, ["formula-conclusion"])
  assert.equal(formulaWorkflow.result.actionlint, true)

  const otherWorkflow = await requirementsFor("pull_request", [".github/workflows/merge-gate.yml"])
  assert.deepEqual(otherWorkflow.result.expectedChecks, [])
  assert.equal(otherWorkflow.result.actionlint, true)
})

test("merge_group requires both domain conclusions without PR API access", async () => {
  const {result, apiCalls} = await requirementsFor("merge_group")
  assert.deepEqual(result.expectedChecks, ["formula-conclusion", "cask-conclusion"])
  assert.equal(result.actionlint, true)
  assert.deepEqual(apiCalls, [])
})

test("missing or pending checks wait", () => {
  assert.equal(aggregateCheckRuns([], ["formula-conclusion"]).state, "waiting")
  assert.equal(aggregateCheckRuns([
    {id: 1, name: "formula-conclusion", status: "in_progress"},
  ], ["formula-conclusion"]).state, "waiting")
})

test("all expected checks must succeed", () => {
  const checks = [
    {id: 1, name: "formula-conclusion", status: "completed", conclusion: "success"},
    {id: 2, name: "cask-conclusion", status: "completed", conclusion: "success"},
  ]
  assert.equal(aggregateCheckRuns(checks, ["formula-conclusion", "cask-conclusion"]).state, "ready")
  assert.equal(aggregateCheckRuns([
    ...checks.slice(0, 1),
    {id: 3, name: "cask-conclusion", status: "completed", conclusion: "failure"},
  ], ["formula-conclusion", "cask-conclusion"]).state, "failed")
})

test("newer reruns supersede older results", () => {
  const oldFailure = {id: 10, name: "formula-conclusion", status: "completed", conclusion: "failure"}
  const newerSuccess = {id: 11, name: "formula-conclusion", status: "completed", conclusion: "success"}
  assert.equal(aggregateCheckRuns([oldFailure, newerSuccess], ["formula-conclusion"]).state, "ready")

  const oldSuccess = {
    id: 20,
    name: "formula-conclusion",
    status: "completed",
    conclusion: "success",
    started_at: "2026-09-21T19:00:00Z",
  }
  const newerPending = {id: 21, name: "formula-conclusion", status: "queued", conclusion: null, started_at: null}
  assert.equal(aggregateCheckRuns([oldSuccess, newerPending], ["formula-conclusion"]).state, "waiting")
})

test("polling waits for checks to appear and then returns success", async () => {
  const responses = [
    {data: {check_runs: []}},
    {data: {check_runs: [{id: 4, name: "formula-conclusion", status: "completed", conclusion: "success"}]}},
  ]
  let calls = 0
  let observedRef
  const result = await pollCheckRuns({
    context: {repo: {owner: "chenrui333", repo: "homebrew-tap"}, sha: "a".repeat(40)},
    sha: "b".repeat(40),
    expectedChecks: ["formula-conclusion"],
    github: {rest: {checks: {listForRef: async ({ref}) => {
      observedRef = ref
      return responses[calls++]
    }}}},
    sleep: async () => {},
    timeoutMs: 1_000,
  })
  assert.equal(result.state, "ready")
  assert.equal(calls, 2)
  assert.equal(observedRef, "b".repeat(40))
})
