const assert = require("node:assert/strict")
const test = require("node:test")
const { mergeQualifiedCask } = require("./qualified-cask-merge")

function fixture() {
  const state = {
    pr: {
      number: 7, state: "open", draft: false, base: { ref: "main" }, user: { type: "User" },
      head: { sha: "qualified-head", repo: { full_name: "example/tap" } },
      labels: [{ name: "pr-cask-merge" }],
    },
    files: ["Casks/d/demo.rb"],
    checks: [
      { id: 1, name: "cask-conclusion", status: "completed", conclusion: "success" },
      { id: 2, name: "Spell Check", status: "completed", conclusion: "success" },
      { id: 3, name: "cask-merge", status: "in_progress", conclusion: null },
    ],
    statuses: [], failures: [], mergedHead: null, reads: 0, clock: 0,
    mergeError: null,
    afterChecks: () => {}, onSleep: () => {},
    context: {
      repo: { owner: "example", repo: "tap" },
      payload: { pull_request: { number: 7, head: { sha: "qualified-head" } } },
    },
  }
  const listFiles = async () => {}
  const listForRef = async () => {}
  const list = async () => {}
  const github = {
    paginate: async route => {
      if (route === listFiles) return state.files.map(filename => ({ filename }))
      if (route === listForRef) return structuredClone(state.checks)
      if (route === list) return [structuredClone(state.pr)]
      throw new Error("Unexpected pagination route")
    },
    rest: {
      pulls: {
        get: async () => {
          state.reads++
          return { data: structuredClone(state.pr) }
        },
        listFiles,
        list,
        merge: async ({ sha }) => {
          if (state.mergeError) throw state.mergeError
          if (sha !== state.pr.head.sha) throw new Error("Head changed")
          state.pr.state = "closed"
          state.mergedHead = sha
          return { data: { merged: true } }
        },
      },
      checks: { listForRef },
      repos: {
        getCombinedStatusForRef: async () => {
          const response = { data: { statuses: structuredClone(state.statuses) } }
          state.afterChecks()
          return response
        },
      },
    },
  }
  const run = () => mergeQualifiedCask({
    github,
    context: state.context,
    core: { info: () => {}, setFailed: message => state.failures.push(message) },
    now: () => state.clock,
    timeoutMs: 10,
    intervalMs: 10,
    sleep: async () => { state.clock += 10; state.onSleep() },
  })
  return { state, run }
}

test("merges a fully qualified cask head without requiring native auto-merge", async () => {
  const { state, run } = fixture()
  state.files.push(".typos.toml")
  await run()
  assert.equal(state.pr.state, "closed")
  assert.equal(state.mergedHead, "qualified-head")
})

test("does not merge held, forked, draft, unadmitted or mixed-file contributions", async () => {
  const mutations = [
    state => state.pr.labels.push({ name: "in progress" }),
    state => { state.pr.head.repo.full_name = "contributor/fork" },
    state => { state.pr.draft = true },
    state => { state.pr.labels = [] },
    state => state.files.push("Formula/d/demo.rb"),
    state => state.files.push("Casks/e/extra.rb"),
    state => { state.files = [] },
  ]
  for (const mutate of mutations) {
    const { state, run } = fixture()
    mutate(state)
    await run()
    assert.equal(state.pr.state, "open")
    assert.equal(state.mergedHead, null)
  }
})

test("preserves an open PR if its head changes after checks pass", async () => {
  const { state, run } = fixture()
  state.afterChecks = () => { state.pr.head.sha = "replacement-head" }
  await run()
  assert.equal(state.pr.state, "open")
  assert.equal(state.pr.head.sha, "replacement-head")
  assert.equal(state.mergedHead, null)
})

test("honors a hold added after qualification", async () => {
  const { state, run } = fixture()
  state.afterChecks = () => state.pr.labels.push({ name: "in progress" })
  await run()
  assert.equal(state.pr.state, "open")
  assert.equal(state.mergedHead, null)
})

test("fails closed on missing, skipped, failed or superseded required checks", async () => {
  const changes = [
    state => { state.checks = state.checks.filter(check => check.name !== "cask-conclusion") },
    state => { state.checks[0].conclusion = "skipped" },
    state => { state.checks[1].conclusion = "failure" },
    state => state.checks.push({ id: 4, name: "cask-conclusion", status: "completed", conclusion: "failure" }),
    state => state.checks.push({ id: 4, name: "other validation", status: "completed", conclusion: "cancelled" }),
    state => state.statuses.push({ context: "external validation", state: "failure" }),
  ]
  for (const change of changes) {
    const { state, run } = fixture()
    change(state)
    await run()
    assert.equal(state.pr.state, "open")
    assert.equal(state.mergedHead, null)
    assert.ok(state.failures.length > 0)
  }
})

test("waits for pending current-head checks before merging", async () => {
  const { state, run } = fixture()
  state.checks[0].status = "in_progress"
  state.checks[0].conclusion = null
  state.onSleep = () => {
    assert.equal(state.pr.state, "open")
    state.checks[0].status = "completed"
    state.checks[0].conclusion = "success"
  }
  await run()
  assert.equal(state.pr.state, "closed")
  assert.equal(state.mergedHead, "qualified-head")
})

test("rearms a failed same-head qualification after a successful CI rerun", async () => {
  const { state, run } = fixture()
  state.checks[0].conclusion = "failure"
  await run()
  assert.equal(state.pr.state, "open")

  state.checks[0].conclusion = "success"
  state.context.payload = {
    workflow_run: { event: "pull_request", conclusion: "success", head_sha: "qualified-head", head_branch: "candidate" },
  }
  await run()
  assert.equal(state.pr.state, "closed")
  assert.equal(state.mergedHead, "qualified-head")
})

test("does not qualify a replacement head from an older CI completion", async () => {
  const { state, run } = fixture()
  state.pr.head.sha = "replacement-head"
  state.context.payload = {
    workflow_run: { event: "pull_request", conclusion: "success", head_sha: "qualified-head", head_branch: "candidate" },
  }
  await run()
  assert.equal(state.pr.state, "open")
  assert.equal(state.mergedHead, null)
})

test("ignores completed non-PR workflows even when cask checks are green", async () => {
  const { state, run } = fixture()
  state.context.payload = {
    workflow_run: { event: "push", conclusion: "success", head_sha: "qualified-head", head_branch: "candidate" },
  }
  await run()
  assert.equal(state.pr.state, "open")
  assert.equal(state.mergedHead, null)
})

test("manual re-evaluation qualifies the current head without restarting its checks", async () => {
  const { state, run } = fixture()
  state.context.eventName = "workflow_dispatch"
  state.context.payload = { inputs: { pr_number: "7" } }
  await run()
  assert.equal(state.pr.state, "closed")
  assert.equal(state.mergedHead, "qualified-head")
})

test("a newer skipped target spellcheck does not shadow successful PR spellcheck", async () => {
  const { state, run } = fixture()
  state.checks.push({ id: 5, name: "Spell Check", status: "completed", conclusion: "skipped" })
  await run()
  assert.equal(state.pr.state, "closed")
  assert.equal(state.mergedHead, "qualified-head")
})

test("a skipped target spellcheck cannot qualify a failed or missing real spellcheck", async () => {
  for (const missing of [false, true]) {
    const { state, run } = fixture()
    if (missing) state.checks = state.checks.filter(check => check.name !== "Spell Check")
    else state.checks[1].conclusion = "failure"
    state.checks.push({ id: 5, name: "Spell Check", status: "completed", conclusion: "skipped" })
    await run()
    assert.equal(state.pr.state, "open")
    assert.equal(state.mergedHead, null)
  }
})

test("a concurrent base update is requalified before retrying the merge", async () => {
  const { state, run } = fixture()
  state.mergeError = Object.assign(new Error("Base branch was modified. Review and try the merge again."), { status: 405 })
  state.onSleep = () => { state.mergeError = null }
  await run()
  assert.equal(state.pr.state, "closed")
  assert.equal(state.mergedHead, "qualified-head")
})

test("a hold added during a base-update race prevents the retried merge", async () => {
  const { state, run } = fixture()
  state.mergeError = Object.assign(new Error("Base branch was modified. Review and try the merge again."), { status: 405 })
  state.onSleep = () => state.pr.labels.push({ name: "in progress" })
  await run()
  assert.equal(state.pr.state, "open")
  assert.equal(state.mergedHead, null)
})

test("permission failures are surfaced rather than retried", async () => {
  const { state, run } = fixture()
  state.mergeError = Object.assign(new Error("Resource not accessible"), { status: 403 })
  await assert.rejects(run, { message: "Resource not accessible" })
  assert.equal(state.pr.state, "open")
  assert.equal(state.mergedHead, null)
})
