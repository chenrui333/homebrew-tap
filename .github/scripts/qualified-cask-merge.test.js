const assert = require("node:assert/strict")
const { createHash } = require("node:crypto")
const test = require("node:test")
const { mergeQualifiedCask } = require("./qualified-cask-merge")

const HEAD = "a".repeat(40)
const BASE = "b".repeat(40)
const MERGE_BASE = "c".repeat(40)
const blob = (ref, path) => createHash("sha1").update(`${ref}:${path}`).digest("hex")

function caskRoute(state, kind) {
  const source = 'cask "demo" do\n  version "1.0"\n  homepage "https://example.org"\nend\n'
  state.pr.head.sha = HEAD
  state.context.payload.pull_request.head.sha = HEAD
  state.checks.push({ id: 4, name: "cask-route-verification", status: "completed", conclusion: "success" })
  state.files = kind === "rename" ? [
    { filename: "Casks/n/new-demo.rb", previous_filename: "Casks/d/demo.rb", status: "renamed" },
    { filename: "cask_renames.json", status: "added" },
  ] : [
    { filename: "Casks/d/demo.rb", status: "removed" },
    { filename: "tap_migrations.json", status: "modified" },
  ]
  state.contents = {
    [MERGE_BASE]: { "Casks/d/demo.rb": source, "tap_migrations.json": '{"prior":"homebrew/core"}' },
    [BASE]: { "tap_migrations.json": '{"prior":"homebrew/core"}' },
    [HEAD]: {
      "Casks/n/new-demo.rb": source.replace('cask "demo"', 'cask "new-demo"'),
      "cask_renames.json": '{"demo":"new-demo"}',
      "tap_migrations.json": '{"prior":"homebrew/core","demo":"homebrew/cask"}',
    },
  }
}

function fixture() {
  const state = {
    pr: {
      number: 7, state: "open", draft: false, base: { ref: "main", sha: BASE }, user: { type: "User" },
      head: { sha: "qualified-head", repo: { full_name: "example/tap" } },
      labels: [{ name: "pr-cask-merge" }],
    },
    files: [{ filename: "Casks/d/demo.rb", status: "modified" }],
    checks: [
      { id: 1, name: "cask-conclusion", status: "completed", conclusion: "success" },
      { id: 2, name: "Spell Check", status: "completed", conclusion: "success" },
      { id: 3, name: "cask-merge", status: "in_progress", conclusion: null },
    ],
    statuses: [], failures: [], mergedHead: null, reads: 0, clock: 0,
    mergeError: null,
    afterChecks: () => {}, onSleep: () => {},
    contents: {}, mergeBase: MERGE_BASE, checkReads: 0, mergeAttempts: 0,
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
      if (route === listFiles) return structuredClone(state.files)
      if (route === listForRef) {
        state.checkReads++
        return structuredClone(state.checks)
      }
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
          state.mergeAttempts++
          if (state.mergeError) throw state.mergeError
          if (sha !== state.pr.head.sha) throw new Error("Head changed")
          state.pr.state = "closed"
          state.mergedHead = sha
          return { data: { merged: true } }
        },
      },
      checks: { listForRef },
      repos: {
        compareCommitsWithBasehead: async () => ({ data: { merge_base_commit: { sha: state.mergeBase } } }),
        getContent: async ({ path, ref }) => {
          const source = state.contents[ref]?.[path]
          if (source === undefined) throw Object.assign(new Error("Not Found"), { status: 404 })
          return { data: { type: "file", path, sha: blob(ref, path), encoding: "base64",
            content: Buffer.from(source).toString("base64"), size: Buffer.byteLength(source) } }
        },
        getCombinedStatusForRef: async () => {
          const response = { data: { statuses: structuredClone(state.statuses) } }
          state.afterChecks()
          return response
        },
      },
      git: { getTree: async ({ tree_sha, recursive }) => {
        for (const [ref, contents] of Object.entries(state.contents)) {
          const directories = new Set(["", ...Object.keys(contents).flatMap(path =>
            path.split("/").slice(0, -1).map((_, index, parts) => parts.slice(0, index + 1).join("/")))])
          for (const directory of directories) {
            if (tree_sha !== (directory ? blob(ref, directory) : ref)) continue
            const prefix = directory ? `${directory}/` : ""
            const names = new Set(Object.keys(contents).filter(path => path.startsWith(prefix))
              .map(path => recursive ? path.slice(prefix.length) : path.slice(prefix.length).split("/")[0]))
            return { data: { tree: [...names].map(name => {
              const path = prefix + name
              const isDirectory = !Object.hasOwn(contents, path)
              return { path: name, sha: blob(ref, path), type: isDirectory ? "tree" : "blob",
                mode: isDirectory ? "040000" : "100644" }
            }), truncated: false } }
          }
        }
        throw new Error("Unknown tree")
      } },
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
  state.files.push({ filename: ".typos.toml", status: "modified" })
  state.files.push({ filename: "audit_exceptions/signing_audit_skiplist.json", status: "modified" })
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
    state => state.files.push({ filename: "Formula/d/demo.rb", status: "modified" }),
    state => state.files.push({ filename: "Casks/e/extra.rb", status: "added" }),
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

test("merges structurally qualified renames and Core migrations through the existing check gate", async () => {
  for (const kind of ["rename", "migration"]) {
    const { state, run } = fixture()
    caskRoute(state, kind)
    await run()
    assert.equal(state.pr.state, "closed")
    assert.equal(state.mergedHead, HEAD)
    assert.equal(state.mergeAttempts, 1)
  }
})

test("legacy conclusions and skipped route checks cannot qualify special routes", async () => {
  for (const kind of ["rename", "migration"]) {
    for (const conclusion of [undefined, "skipped", "neutral"]) {
      const { state, run } = fixture()
      caskRoute(state, kind)
      state.checks = state.checks.filter(check => check.name !== "cask-route-verification")
      if (conclusion) state.checks.push({ id: 4, name: "cask-route-verification", status: "completed", conclusion })
      await run()
      assert.equal(state.pr.state, "open")
      assert.equal(state.mergeAttempts, 0)
    }
  }
})

test("rejects invalid cask routes before polling otherwise green checks", async () => {
  const mutations = [
    state => { state.contents[HEAD]["Casks/n/new-demo.rb"] += "\n" },
    state => { state.contents[HEAD]["cask_renames.json"] = '{"demo":"other"}' },
    state => { state.contents[HEAD]["cask_renames.json"] = '{"demo":"new-demo","extra":"other"}' },
    state => { state.contents[HEAD]["cask_renames.json"] = "{" },
    state => { state.files[0].previous_filename = "Casks/o/other.rb" },
    state => { state.files[0].status = "copied" },
    state => state.files.push({ filename: ".typos.toml", status: "modified" }),
    state => state.files.push({ filename: "Formula/d/demo.rb", status: "removed" }),
  ]
  for (const mutate of mutations) {
    const { state, run } = fixture()
    caskRoute(state, "rename")
    mutate(state)
    await run()
    assert.equal(state.pr.state, "open")
    assert.equal(state.checkReads, 0)
    assert.equal(state.mergeAttempts, 0)
    assert.ok(state.failures.length > 0)
  }
  const { state, run } = fixture()
  caskRoute(state, "migration")
  state.contents[HEAD]["tap_migrations.json"] = '{"prior":"homebrew/core","demo":"homebrew/core"}'
  await run()
  assert.equal(state.pr.state, "open")
  assert.equal(state.checkReads, 0)
  assert.equal(state.mergeAttempts, 0)
})

test("revalidates routing data and source after checks pass but before the SHA-matched merge", async () => {
  const cases = [
    ["rename", state => { state.contents[HEAD]["cask_renames.json"] = '{"demo":"other"}' }],
    ["rename", state => { state.contents[HEAD]["Casks/n/new-demo.rb"] += "\n" }],
    ["rename", state => { state.files[0].previous_filename = "Casks/o/other.rb" }],
    ["migration", state => { state.contents[HEAD]["tap_migrations.json"] = '{"demo":"homebrew/cask"}' }],
  ]
  for (const [kind, mutate] of cases) {
    const { state, run } = fixture()
    caskRoute(state, kind)
    state.afterChecks = () => mutate(state)
    await run()
    assert.equal(state.pr.state, "open")
    assert.equal(state.checkReads, 1)
    assert.equal(state.mergeAttempts, 0)
    assert.equal(state.mergedHead, null)
  }
})

test("a current-base route collision after checks prevents merging despite an unchanged merge base", async () => {
  for (const kind of ["rename", "migration"]) {
    const { state, run } = fixture()
    caskRoute(state, kind)
    state.afterChecks = () => {
      state.pr.base.sha = "d".repeat(40)
      state.contents[state.pr.base.sha] = {
        "tap_migrations.json": '{"prior":"homebrew/core","demo":"established/tap"}',
        "cask_renames.json": '{"demo":"established-target"}',
      }
    }
    await run()
    assert.equal(state.pr.state, "open")
    assert.equal(state.mergedHead, null)
    assert.equal(state.mergeAttempts, 0)
  }
})

test("a formula added on current main after checks prevents a cask migration merge", async () => {
  const { state, run } = fixture()
  caskRoute(state, "migration")
  state.afterChecks = () => {
    state.pr.base.sha = "d".repeat(40)
    state.contents[state.pr.base.sha] = {
      "tap_migrations.json": '{"prior":"homebrew/core"}',
      "Formula/d/demo.rb": "existing formula",
    }
  }
  await run()
  assert.equal(state.pr.state, "open")
  assert.equal(state.mergeAttempts, 0)
})

test("revalidates special routes before the next polling iteration", async () => {
  for (const kind of ["rename", "migration"]) {
    const { state, run } = fixture()
    caskRoute(state, kind)
    state.checks[0].status = "in_progress"
    state.checks[0].conclusion = null
    state.onSleep = () => {
      state.checks[0].status = "completed"
      state.checks[0].conclusion = "success"
      state.files.push({ filename: "Formula/d/demo.rb", status: "modified" })
    }
    await run()
    assert.equal(state.pr.state, "open")
    assert.equal(state.checkReads, 1)
    assert.equal(state.mergeAttempts, 0)
  }
})

test("holds, replacement heads and failed checks still prevent special-route merges", async () => {
  for (const kind of ["rename", "migration"]) {
    for (const mutate of [
      state => state.pr.labels.push({ name: "in progress" }),
      state => { state.pr.head.sha = "replacement-head" },
    ]) {
      const { state, run } = fixture()
      caskRoute(state, kind)
      state.afterChecks = () => mutate(state)
      await run()
      assert.equal(state.pr.state, "open")
      assert.equal(state.mergeAttempts, 0)
    }
    const { state, run } = fixture()
    caskRoute(state, kind)
    state.checks[0].conclusion = "failure"
    await run()
    assert.equal(state.pr.state, "open")
    assert.equal(state.mergeAttempts, 0)
    assert.ok(state.failures.length > 0)
  }
})

test("same-head completion and manual routes can merge special cask changes", async () => {
  for (const kind of ["rename", "migration"]) {
    for (const event of ["workflow_run", "workflow_dispatch"]) {
      const { state, run } = fixture()
      caskRoute(state, kind)
      if (event === "workflow_run") {
        state.context.payload = {
          workflow_run: { event: "pull_request", conclusion: "success", head_sha: HEAD, head_branch: "candidate" },
        }
      } else {
        state.context.eventName = event
        state.context.payload = { inputs: { pr_number: "7" } }
      }
      await run()
      assert.equal(state.pr.state, "closed")
      assert.equal(state.mergedHead, HEAD)
    }
  }
})

test("a base-race retry recomputes the merge-base data policy", async () => {
  for (const kind of ["rename", "migration"]) {
    const { state, run } = fixture()
    caskRoute(state, kind)
    state.mergeError = Object.assign(new Error("Base branch was modified"), { status: 405 })
    state.onSleep = () => {
      state.mergeError = null
      state.pr.base.sha = "d".repeat(40)
      state.mergeBase = "e".repeat(40)
      state.contents[state.mergeBase] = {
        "Casks/d/demo.rb": 'cask "demo" do\n  version "2.0"\nend\n',
        "tap_migrations.json": '{"prior":"homebrew/core","demo":"other/tap"}',
      }
    }
    await run()
    assert.equal(state.pr.state, "open")
    assert.equal(state.mergeAttempts, 1)
    assert.equal(state.mergedHead, null)
  }
})

test("only the 405 base-change race is retried, with the existing retry bound", async () => {
  for (const error of [
    Object.assign(new Error("Not mergeable"), { status: 405 }),
    Object.assign(new Error("Base branch was modified"), { status: 409 }),
  ]) {
    const { state, run } = fixture()
    state.mergeError = error
    await assert.rejects(run, error)
    assert.equal(state.mergeAttempts, 1)
    assert.equal(state.pr.state, "open")
  }
  const { state, run } = fixture()
  state.mergeError = Object.assign(new Error("Base branch was modified"), { status: 405 })
  await assert.rejects(run, { status: 405 })
  assert.equal(state.mergeAttempts, 3)
  assert.equal(state.pr.state, "open")
})
