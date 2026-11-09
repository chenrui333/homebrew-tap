const assert = require("node:assert/strict")
const test = require("node:test")
const { validateCaskChangeCI, validateCaskChangeMatrix, githubRepositoryIdentity } = require("./cask-change-ci")

const HEAD = "a".repeat(40)
const BASE = "b".repeat(40)
const MERGE_BASE = "c".repeat(40)
const MERGE = "d".repeat(40)
const source = token => `cask "${token}" do\n  version "1.0"\n  sha256 "${"d".repeat(64)}"\n  url "https://github.com/Example/Project/releases/download/v1/App.zip"\n  name "Example"\n  homepage "https://example.com"\n  app "Example.app"\nend\n`

function fixture(kind = "migration") {
  const eventPr = {
    number: 42,
    head: { sha: HEAD, repo: { full_name: "maintainer/homebrew-apps" } },
    base: { sha: BASE, ref: "main" },
  }
  const context = { eventName: "pull_request", sha: MERGE, repo: { owner: "maintainer", repo: "homebrew-apps" }, payload: { pull_request: eventPr } }
  const files = kind === "rename" ? [
    { filename: "Casks/new.rb", previous_filename: "Casks/old.rb", status: "renamed" },
    { filename: "cask_renames.json", status: "added" },
  ] : kind === "migration" ? [
    { filename: "Casks/old.rb", status: "removed" },
    { filename: "tap_migrations.json", status: "modified" },
  ] : kind === "update" ? [
    { filename: "Casks/old.rb", status: "modified" },
  ] : [{ filename: ".github/workflows/cask-tests.yml", status: "modified" }]
  const contents = {
    [BASE]: { "tap_migrations.json": '{"unrelated":"another/tap"}' },
    [MERGE_BASE]: { "Casks/old.rb": source("old"), "tap_migrations.json": '{"unrelated":"another/tap"}' },
    [HEAD]: kind === "rename" ? {
      "Casks/new.rb": source("new"), "cask_renames.json": '{"old":"new"}',
    } : kind === "migration" ? {
      "tap_migrations.json": '{"unrelated":"another/tap","old":"homebrew/cask"}',
    } : { "Casks/old.rb": source("old") },
  }
  const metadata = {
    baseline: {
      token: "old", tap: "maintainer/apps", version: "1.0", sha256: "d".repeat(64),
      url: "https://github.com/Example/Project/releases/download/v1/App.zip", artifacts: [{ app: ["Example.app"] }],
    },
    resolved: {
      token: kind === "rename" ? "new" : "old", tap: kind === "rename" ? "maintainer/apps" : "homebrew/cask",
      version: "1.0", sha256: "d".repeat(64),
      url: "https://github.com/Example/Project/releases/download/v1/App.zip", artifacts: [{ app: ["Example.app"] }],
    },
  }
  let reads = 0
  const state = { metadata, files, contents, prAtRead: () => ({ ...structuredClone(eventPr), changed_files: files.length }) }
  const github = {
    rest: {
      pulls: {
        get: async () => ({ data: state.prAtRead(++reads) }),
        listFiles: async () => ({ data: files }),
      },
      repos: {
        compareCommitsWithBasehead: async () => ({ data: { merge_base_commit: { sha: MERGE_BASE } } }),
        getContent: async ({ ref, path }) => {
          const content = contents[ref]?.[path]
          if (content === undefined) throw Object.assign(new Error("Not Found"), { status: 404 })
          return { data: {
            type: "file", path, sha: "e".repeat(40), size: Buffer.byteLength(content),
            encoding: "base64", content: Buffer.from(content).toString("base64"),
          } }
        },
      },
      git: {
        getTree: async ({ tree_sha }) => {
          const directories = { [HEAD]: "1".repeat(40), [MERGE_BASE]: "2".repeat(40),
            [BASE]: "3".repeat(40), ["e".repeat(40)]: "4".repeat(40) }
          const directoryRef = Object.keys(directories).find(ref => directories[ref] === tree_sha)
          const paths = Object.keys(contents[directoryRef || tree_sha] || {})
          const tree = directoryRef
            ? paths.filter(path => path.startsWith("Casks/")).map(path => ({
              path: path.slice("Casks/".length), mode: "100644", type: "blob", sha: "e".repeat(40),
            }))
            : [
              ...paths.filter(path => !path.includes("/")).map(path => ({
                path, mode: "100644", type: "blob", sha: "e".repeat(40),
              })),
              { path: "Casks", mode: "040000", type: "tree", sha: directories[tree_sha] },
            ]
          return { data: { truncated: false, tree } }
        },
      },
    },
    paginate: async () => files,
  }
  const options = {
    github, context, core: { info() {} }, readCheckoutHead: async () => MERGE,
    inspect: async () => structuredClone(metadata),
  }
  return { options, state }
}

test("ordinary updates and non-cask workflow changes do not load Ruby metadata", async () => {
  for (const kind of ["none", "update"]) {
    const { options } = fixture(kind)
    options.inspect = async () => { throw new Error("Ordinary changes must not load casks") }
    const result = await validateCaskChangeCI(options)
    assert.equal(result.kind, kind)
  }
})

test("a rename admits native old-name resolution to the new token and unchanged package", async () => {
  const { options } = fixture("rename")
  const result = await validateCaskChangeCI(options)
  assert.equal(result.kind, "rename")
})

test("rename syntax jobs defer native loading to the already-trusted cask job", async () => {
  const { options } = fixture("rename")
  options.verifyRename = false
  options.inspect = async () => { throw new Error("Syntax jobs do not trust this cask") }
  assert.equal((await validateCaskChangeCI(options)).kind, "rename")
})

test("a rename requires a native verifier for its exact tap, token and source path", async () => {
  for (const matrix of [
    [{ name: "tap_syntax" }],
    [{ tap: "other/tap", cask: { token: "new", path: "./Casks/new.rb" } }],
    [{ tap: "maintainer/apps", cask: { token: "old", path: "./Casks/new.rb" } }],
    [{ tap: "maintainer/apps", cask: { token: "new", path: "./Casks/other.rb" } }],
  ]) {
    const { options } = fixture("rename")
    options.matrix = matrix
    await assert.rejects(validateCaskChangeMatrix(options), /Rename requires a native cask verification job/)
  }
  const { options } = fixture("rename")
  options.matrix = [
    { name: "tap_syntax" },
    { tap: "maintainer/apps", cask: { token: "new", path: "./Casks/new.rb" } },
  ]
  assert.equal((await validateCaskChangeMatrix(options)).kind, "rename")
})

test("migration syntax jobs cannot defer official Cask identity verification", async () => {
  const { options } = fixture("migration")
  options.verifyRename = false
  options.inspect = async () => { throw new Error("Native migration identity remains mandatory") }
  await assert.rejects(validateCaskChangeCI(options), /Native migration identity remains mandatory/)
})

test("a migration admits the same normalized upstream despite differing release versions", async () => {
  const { options, state } = fixture()
  state.metadata.resolved.url = "https://github.com/example/PROJECT/releases/download/v2/Project-arm64.zip"
  state.metadata.resolved.version = "2.0"
  state.metadata.resolved.sha256 = "f".repeat(64)
  assert.equal((await validateCaskChangeCI(options)).kind, "migration")
})

test("matching display name cannot admit a different GitHub upstream", async () => {
  const { options, state } = fixture()
  state.metadata.baseline.name = state.metadata.resolved.name = ["Example"]
  state.metadata.resolved.url = "https://github.com/Other/Project/releases/download/v1/App.zip"
  await assert.rejects(validateCaskChangeCI(options), /different GitHub repositories/)
})

test("non-GitHub and lookalike download hosts cannot establish migration identity", async () => {
  for (const url of [
    "https://example.com/Example/Project/releases/download/v1/App.zip",
    "https://github.com.example.com/Example/Project/releases/download/v1/App.zip",
    "https://github.com@evil.example/Example/Project/releases/download/v1/App.zip",
    "https://github.com/Example/Other/releases/download/v1/App.zip",
  ]) {
    const { options, state } = fixture()
    state.metadata.resolved.url = url
    await assert.rejects(validateCaskChangeCI(options), /GitHub|different/)
  }
})

test("upstream repository extraction rejects unsupported GitHub routes", () => {
  for (const url of ["https://github.com/Example/Project", "https://github.com/Example/Project/issues/1", "https://github.com/Example%2fOther/Project/archive/v1.zip"]) {
    assert.throws(() => githubRepositoryIdentity(url), /Unsupported/)
  }
  assert.equal(githubRepositoryIdentity("https://github.com/Example/Project/archive/refs/tags/v1.zip"), "example/project")
})

test("old-name aliases must resolve to both the expected tap and token", async () => {
  for (const kind of ["rename", "migration"]) {
    for (const field of ["tap", "token"]) {
      const { options, state } = fixture(kind)
      state.metadata.resolved[field] = "wrong"
      await assert.rejects(validateCaskChangeCI(options), /old cask name did not resolve/)
    }
  }
})

test("rename routing cannot hide changed package metadata", async () => {
  for (const field of ["url", "version", "sha256", "artifacts"]) {
    const { options, state } = fixture("rename")
    state.metadata.resolved[field] = "changed"
    await assert.rejects(validateCaskChangeCI(options), /changed package metadata/)
  }
})

test("baseline metadata must belong to the removed or renamed cask", async () => {
  const { options, state } = fixture()
  state.metadata.baseline.token = "unrelated"
  await assert.rejects(validateCaskChangeCI(options), /Merge-base cask metadata/)
})

test("metadata fetched for a changed PR head is rejected before native loading", async () => {
  const { options, state } = fixture()
  const original = state.prAtRead
  state.prAtRead = read => ({ ...original(read), head: { ...original(read).head, sha: "f".repeat(40) } })
  options.inspect = async () => { throw new Error("Must reject changed metadata before loading") }
  await assert.rejects(validateCaskChangeCI(options), /PR head or base changed/)
})

test("PR head changes while listing files or loading metadata fail closed", async () => {
  for (const changedAtRead of [2, 3]) {
    const { options, state } = fixture()
    const original = state.prAtRead
    state.prAtRead = read => {
      const pr = original(read)
      if (read >= changedAtRead) pr.head.sha = "f".repeat(40)
      return pr
    }
    await assert.rejects(validateCaskChangeCI(options), /PR head or base changed/)
  }
})

test("unrelated main advances do not invalidate the event merge checkout", async () => {
  const { options, state } = fixture("rename")
  const original = state.prAtRead
  state.prAtRead = read => {
    const pr = original(read)
    pr.base.sha = "e".repeat(40)
    return pr
  }
  assert.equal((await validateCaskChangeCI(options)).kind, "rename")
})

test("a stale or replaced checkout cannot attest an event head", async () => {
  for (const changesAfterInspection of [false, true]) {
    const { options } = fixture()
    let reads = 0
    options.readCheckoutHead = async () => ++reads === 1 && changesAfterInspection ? MERGE : "f".repeat(40)
    await assert.rejects(validateCaskChangeCI(options), /Checkout does not match/)
  }
})

test("partial file lists and policy rejections cannot reach native route admission", async () => {
  const partial = fixture()
  const original = partial.state.prAtRead
  partial.state.prAtRead = read => ({ ...original(read), changed_files: 99 })
  await assert.rejects(validateCaskChangeCI(partial.options), /Incomplete PR/)

  const mixed = fixture("rename")
  mixed.state.files.push({ filename: "Formula/unrelated.rb", status: "modified" })
  mixed.options.inspect = async () => { throw new Error("Rejected change reached native loading") }
  await assert.rejects(validateCaskChangeCI(mixed.options), error => !error.message.includes("reached native loading"))
})

test("native loader failures propagate rather than approving a route", async () => {
  const { options } = fixture()
  options.inspect = async () => { throw new Error("Native cask loader failed") }
  await assert.rejects(validateCaskChangeCI(options), /Native cask loader failed/)
})
