const assert = require("node:assert/strict")
const { createHash } = require("node:crypto")
const test = require("node:test")
const { planRebottle, publishRebottle } = require("./rebottle-pr")

const MAIN = "a".repeat(40), ROOT = "b".repeat(40), NEW = "c".repeat(40), OLD = "d".repeat(40)
const PATH = "Formula/h/hello.rb"
const SOURCE = 'class Hello < Formula\n  url "https://example.org/hello-1.0.tar.gz"\n  license "MIT"\n\n  bottle do\n    sha256 all: "abc"\n  end\nend\n'
const BUMPED = SOURCE.replace('  license "MIT"\n', '  license "MIT"\n  revision 1\n')
const blob = source => {
  const bytes = Buffer.from(source)
  return createHash("sha1").update(`blob ${bytes.length}\0`).update(bytes).digest("hex")
}

function fixture() {
  const context = {
    eventName: "workflow_dispatch", ref: "refs/heads/main", sha: MAIN, runId: 42,
    repo: { owner: "example", repo: "homebrew-tap" }, payload: { inputs: { formula: "hello" } },
  }
  const state = {
    source: SOURCE, mode: "100644", paths: [PATH], truncated: false,
    pulls: [], branch: null, branchSource: BUMPED, branchFiles: [{ filename: PATH, status: "modified" }],
    ancestry: "diverged", afterAncestry: () => {}, objectWrites: 0, refUpdates: 0,
  }
  const list = async () => {}, listFiles = async () => {}
  const github = {
    paginate: async (route, params) => {
      if (route === list) return state.pulls
      if (route === listFiles) return state.pulls.find(pull => pull.number === params.pull_number).files
      throw new Error("Unexpected pagination")
    },
    rest: {
      pulls: { list, listFiles },
      git: {
        getTree: async () => ({ data: { sha: ROOT, truncated: state.truncated,
          tree: state.paths.map(path => ({ path, type: "blob", mode: state.mode, sha: blob(state.source) })) } }),
        getRef: async ({ ref }) => ({ data: { object: { sha: ref === "heads/main" ? MAIN : state.branch } } }),
        createTree: async () => { state.objectWrites++; return { data: { sha: ROOT } } },
        createCommit: async () => { state.objectWrites++; return { data: { sha: NEW } } },
        createRef: async () => {
          if (state.branch) throw Object.assign(new Error("Reference already exists"), { status: 422 })
          state.branch = NEW
        },
        updateRef: async ({ sha, force }) => {
          // Model the Git non-fast-forward guard, not an expected request echo.
          if (state.branch !== OLD && !force) throw Object.assign(new Error("Not a fast forward"), { status: 409 })
          state.branch = sha
          state.refUpdates++
        },
      },
      repos: {
        getContent: async ({ path, ref }) => {
          const source = ref === MAIN ? state.source : state.branchSource
          return { data: { type: "file", path, encoding: "base64", size: Buffer.byteLength(source),
            sha: blob(source), content: Buffer.from(source).toString("base64") } }
        },
        compareCommitsWithBasehead: async ({ basehead }) => {
          if (basehead.endsWith(`...${MAIN}`)) {
            const result = { data: { status: state.ancestry } }
            state.afterAncestry()
            return result
          }
          return { data: { files: state.branchFiles } }
        },
      },
    },
  }
  const plan = { kind: "new", token: "hello", path: PATH, sourceSha: blob(SOURCE) }
  return { state, context, github, plan }
}

function priorPull(state, files = [{ filename: PATH }]) {
  state.pulls.push({ number: 7, draft: true, html_url: "https://example.org/pull/7", files })
}

test("invalid refs and foreign or multiple formula requests cannot select work", async () => {
  for (const input of ["other/tap/hello", "hello world", "../hello", "hello;uname", ""]) {
    const f = fixture()
    f.context.payload.inputs.formula = input
    await assert.rejects(planRebottle(f), /Select one/)
  }
  const f = fixture()
  f.context.ref = "refs/heads/unreviewed"
  await assert.rejects(planRebottle(f), /main workflow/)
  await assert.rejects(publishRebottle({ ...f, content: BUMPED }), /main workflow/)
})

test("incomplete, ambiguous and symlink formula inventories fail closed", async () => {
  for (const mutate of [
    state => { state.truncated = true },
    state => { state.paths = [] },
    state => { state.paths.push("Formula/other/hello.rb") },
    state => { state.mode = "120000" },
  ]) {
    const f = fixture()
    mutate(f.state)
    await assert.rejects(planRebottle(f), /tree|exactly one|regular Git/)
  }
})

test("existing draft work blocks a rebuild but unrelated cask names do not", async () => {
  const f = fixture()
  priorPull(f.state)
  assert.equal((await planRebottle(f)).kind, "existing")
  f.state.pulls[0].files = [{ filename: "Casks/h/hello.rb" }]
  f.context.payload.inputs.formula = "example/tap/hello"
  assert.equal((await planRebottle(f)).kind, "new")
})

test("a formula advanced on main cannot be overwritten by a queued rebuild", async () => {
  const f = fixture()
  f.state.source = SOURCE.replace("1.0.tar.gz", "2.0.tar.gz")
  await assert.rejects(publishRebottle({ ...f, content: BUMPED }), /changed on main/)
  assert.equal(f.state.branch, null)
  assert.equal(f.state.objectWrites, 0)
})

test("runtime, bottle, unchanged and multi-revision edits cannot be published", async () => {
  for (const content of [
    SOURCE,
    BUMPED.replace("revision 1", "revision 2"),
    BUMPED.replace("1.0.tar.gz", "2.0.tar.gz"),
    BUMPED.replace('sha256 all: "abc"', 'sha256 all: "different"'),
  ]) {
    const f = fixture()
    await assert.rejects(publishRebottle({ ...f, content }), /only the selected formula revision/)
    assert.equal(f.state.branch, null)
    assert.equal(f.state.objectWrites, 0)
  }
})

test("work opened after planning is retained without creating Git objects", async () => {
  const f = fixture()
  priorPull(f.state)
  assert.equal((await publishRebottle({ ...f, content: BUMPED })).kind, "existing")
  assert.equal(f.state.objectWrites, 0)
  assert.equal(f.state.branch, null)
})

test("an unmerged automation branch with other work is not rewritten", async () => {
  for (const mutate of [
    state => { state.branchSource = BUMPED.replace("1.0.tar.gz", "9.0.tar.gz") },
    state => { state.branchFiles.push({ filename: "Formula/o/other.rb", status: "modified" }) },
  ]) {
    const f = fixture()
    f.state.branch = OLD
    mutate(f.state)
    await assert.rejects(publishRebottle({ ...f, content: BUMPED }), /different work/)
    assert.equal(f.state.branch, OLD)
    assert.equal(f.state.refUpdates, 0)
  }
})

test("a concurrently advanced bot branch cannot be force-updated", async () => {
  const f = fixture()
  f.state.branch = OLD
  f.state.ancestry = "ahead"
  const concurrent = "e".repeat(40)
  f.state.afterAncestry = () => { f.state.branch = concurrent }
  await assert.rejects(publishRebottle({ ...f, content: BUMPED }), /Not a fast forward/)
  assert.equal(f.state.branch, concurrent)
  assert.equal(f.state.refUpdates, 0)
})
