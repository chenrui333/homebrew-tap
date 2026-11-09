const assert = require("node:assert/strict")
const { createHash } = require("node:crypto")
const test = require("node:test")
const { validateCaskChange } = require("./cask-change-policy")

const HEAD = "a".repeat(40)
const BASE = "b".repeat(40)
const MERGE_BASE = "c".repeat(40)
const oldPath = "Casks/d/demo.rb"
const newPath = "Casks/n/new-demo.rb"
const source = 'cask "demo" do\n  version "1.0"\n  sha256 "abc"\n  homepage "https://example.org"\nend\n'
const blob = (ref, path) => createHash("sha1").update(`${ref}:${path}`).digest("hex")
const missing = () => Object.assign(new Error("Not Found"), { status: 404 })

function fixture(kind = "rename") {
  const state = {
    files: kind === "rename" ? [
      { filename: newPath, previous_filename: oldPath, status: "renamed" },
      { filename: "cask_renames.json", status: "added" },
    ] : [
      { filename: oldPath, status: "removed" },
      { filename: "tap_migrations.json", status: "modified" },
    ],
    contents: {
      [MERGE_BASE]: { [oldPath]: source, "tap_migrations.json": '{"prior":"homebrew/core"}' },
      [BASE]: { [oldPath]: source.replace('version "1.0"', 'version "2.0"'),
        "tap_migrations.json": '{"prior":"homebrew/core"}' },
      [HEAD]: {
        [newPath]: source.replace('cask "demo"', 'cask "new-demo"'),
        [oldPath]: source,
        "cask_renames.json": '{"demo":"new-demo"}',
        "tap_migrations.json": '{"prior":"homebrew/core","demo":"homebrew/cask"}',
      },
    },
    mergeBase: MERGE_BASE,
    contentError: () => {},
    payload: data => data,
    treePayload: data => data,
    modes: {},
  }
  const github = { rest: {
    repos: {
      compareCommitsWithBasehead: async () => ({ data: { merge_base_commit: { sha: state.mergeBase } } }),
      getContent: async ({ path, ref }) => {
        const error = state.contentError(path, ref)
        if (error) throw error
        const text = state.contents[ref]?.[path]
        if (text === undefined) throw missing()
        return { data: state.payload({
          type: "file", path, sha: blob(ref, path), encoding: "base64",
          content: Buffer.from(text).toString("base64"), size: Buffer.byteLength(text),
        }, path, ref) }
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
          const tree = [...names].map(name => {
            const path = prefix + name
            const isDirectory = !Object.hasOwn(contents, path)
            return { path: name, sha: blob(ref, path), type: isDirectory ? "tree" : "blob",
              mode: state.modes[`${ref}:${path}`] || (isDirectory ? "040000" : "100644") }
          })
          return { data: state.treePayload({ tree, truncated: false }, ref, directory) }
        }
      }
      throw missing()
    } },
  } }
  const run = () => validateCaskChange({ github, owner: "example", repo: "tap",
    pr: { base: { sha: BASE }, head: { sha: HEAD } }, files: state.files })
  return { state, run }
}

async function rejected(mutate, kind) {
  const { state, run } = fixture(kind)
  mutate(state)
  const result = await run()
  assert.equal(result.eligible, false)
  assert.ok(result.reason)
}

test("leaves formula and routing-only maintenance outside cask admission", async () => {
  const { state, run } = fixture()
  state.files = [{ filename: "Formula/d/demo.rb", status: "modified" },
    { filename: "tap_migrations.json", status: "modified" }]
  assert.equal((await run()).kind, "none")
})

test("admits ordinary added and modified casks with the existing maintenance sidecars", async () => {
  for (const status of ["added", "modified"]) {
    const { state, run } = fixture()
    state.files = [{ filename: oldPath, status }, { filename: ".typos.toml", status: "modified" },
      { filename: "audit_exceptions/signing_audit_skiplist.json", status: "modified" }]
    assert.equal((await run()).eligible, true)
  }
})

test("admits a token-only rename with a new registry or a preserved existing registry", async () => {
  for (const existing of [false, true]) {
    const { state, run } = fixture()
    if (existing) {
      state.files[1].status = "modified"
      state.contents[MERGE_BASE]["cask_renames.json"] = '{"prior":"renamed-prior"}'
      state.contents[BASE]["cask_renames.json"] = '{"prior":"renamed-prior"}'
      state.contents[HEAD]["cask_renames.json"] = '{\n "demo": "new-demo", "prior": "renamed-prior"\n}'
    }
    assert.equal((await run()).eligible, true)
  }
})

test("uses the merge base, not the advanced base branch, for rename identity", async () => {
  const { state, run } = fixture()
  assert.equal((await run()).eligible, true)
  state.contents[MERGE_BASE][oldPath] = source.replace('version "1.0"', 'version "3.0"')
  assert.equal((await run()).eligible, false)
})

test("admits a single cask removal routed to homebrew/cask", async () => {
  const { run } = fixture("migration")
  assert.equal((await run()).eligible, true)
})

test("Core cask migrations cannot redirect an existing formula or formula alias", async () => {
  for (const path of ["Formula/demo.rb", "Formula/d/demo.rb", "Formula/nested/group/demo.rb", "Aliases/demo"]) {
    const { state, run } = fixture("migration")
    state.contents[BASE][path] = "existing formula"
    const result = await run()
    assert.equal(result.eligible, false)
    assert.match(result.reason, /existing formula/)
  }
})

test("cask-only renames preserve same-token formula resolution", async () => {
  const { state, run } = fixture("rename")
  state.contents[BASE]["Formula/d/demo.rb"] = "existing formula"
  assert.equal((await run()).eligible, true)
})

test("rejects a route established at the current base while the merge base stays unchanged", async () => {
  for (const kind of ["rename", "migration"]) {
    const { state, run } = fixture(kind)
    state.contents[BASE][kind === "rename" ? "cask_renames.json" : "tap_migrations.json"] =
      '{"prior":"homebrew/core","demo":"established/tap"}'
    assert.equal((await run()).eligible, false)
  }
})

test("unrelated routes added on main do not force stale branches to overwrite them", async () => {
  for (const kind of ["rename", "migration"]) {
    const { state, run } = fixture(kind)
    state.contents[BASE][kind === "rename" ? "cask_renames.json" : "tap_migrations.json"] =
      '{"prior":"homebrew/core","unrelated":"another/tap"}'
    assert.equal((await run()).eligible, true)
  }
})

test("rejects mixed packages, extra sidecars and unsupported file transitions", async () => {
  const mutations = [
    state => state.files.push({ filename: "Formula/d/demo.rb", status: "modified" }),
    state => state.files.push({ filename: ".typos.toml", status: "modified" }),
    state => state.files.push({ filename: "Casks/e/extra.rb", status: "added" }),
    state => { state.files[0].status = "copied" },
    state => { delete state.files[0].previous_filename },
    state => { state.files[0].previous_filename = "Formula/d/demo.rb" },
    state => { state.files[0].previous_filename = newPath },
    state => { state.files[0].filename = "Formula/n/new-demo.rb" },
    state => { state.files[0].filename = "Casks/../new-demo.rb" },
    state => { state.files[1].status = "removed" },
    state => { state.files[1].previous_filename = "some-other.json" },
    state => { state.files = [{ filename: oldPath, status: "removed" },
      { filename: newPath, status: "added" }, state.files[1]] },
    state => { state.files = [newPath] },
    state => state.files.push({ ...state.files[1] }),
  ]
  for (const mutate of mutations) await rejected(mutate)
})

test("ordinary updates cannot smuggle a renamed sidecar or a routing registry", async () => {
  for (const sidecar of [
    { filename: ".typos.toml", previous_filename: "Formula/d/demo.rb", status: "renamed" },
    { filename: "tap_migrations.json", status: "modified" },
    { filename: "cask_renames.json", status: "added" },
  ]) {
    await rejected(state => { state.files = [{ filename: oldPath, status: "modified" }, sidecar] })
  }
})

test("renames reject any source change besides the first declaration token", async () => {
  for (const change of [
    text => text.replace('version "1.0"', 'version "2.0"'),
    text => text + "\n",
    text => text.replace('cask "new-demo"', 'cask "wrong"'),
    text => text.replace('sha256 "abc"', 'sha256 "def"'),
  ]) await rejected(state => { state.contents[HEAD][newPath] = change(state.contents[HEAD][newPath]) })
  await rejected(state => { state.contents[MERGE_BASE][oldPath] = source.replace('cask "demo"', 'cask "wrong"') })
})

test("routing deltas cannot overwrite, delete, redirect or add unrelated entries", async () => {
  const maps = [
    '{"demo":"other"}',
    '{"demo":"new-demo","unrelated":"other"}',
    '{}',
    '{"demo":"new-demo","prior":"changed"}',
    '{"demo":"new-demo"}',
  ]
  for (const head of maps) await rejected(state => {
    state.files[1].status = "modified"
    state.contents[MERGE_BASE]["cask_renames.json"] = '{"prior":"preserved"}'
    state.contents[HEAD]["cask_renames.json"] = head
  })
  await rejected(state => {
    state.files[1].status = "modified"
    state.contents[MERGE_BASE]["cask_renames.json"] = '{"demo":"previous"}'
  })
  for (const target of ["homebrew/core", "homebrew/cask/other", "another/tap"]) {
    await rejected(state => {
      state.contents[HEAD]["tap_migrations.json"] = JSON.stringify({ prior: "homebrew/core", demo: target })
    }, "migration")
  }
})

test("routing registries reject invalid JSON, non-flat maps and duplicate decoded keys", async () => {
  for (const value of ["{", "null", "[]", '{"demo":{}}', '{"demo":1}',
    '{"demo":"wrong","demo":"new-demo"}', '{"demo":"wrong","d\\u0065mo":"new-demo"}']) {
    await rejected(state => { state.contents[HEAD]["cask_renames.json"] = value })
    await rejected(state => {
      state.files[1].status = "modified"
      state.contents[MERGE_BASE]["cask_renames.json"] = value
    })
  }
})

test("only an added registry with an actual content 404 can start from an empty map", async () => {
  await rejected(state => { state.files[1].status = "modified" })
  await rejected(state => { state.contents[MERGE_BASE]["cask_renames.json"] = "{}" })
  await rejected(state => { state.contentError = path => path === "cask_renames.json" &&
    Object.assign(new Error("Forbidden"), { status: 403 }) })
  await rejected(state => {
    state.contents[MERGE_BASE]["cask_renames.json"] = "{}"
    state.contentError = (path, ref) => path === "cask_renames.json" && ref === MERGE_BASE && missing()
  })
  await rejected(state => {
    state.contents[MERGE_BASE]["cask_renames.json"] = "{}"
    state.treePayload = (data, ref) => { if (ref === MERGE_BASE) throw missing(); return data }
  })
})

test("rejects malformed content, unsupported types and mismatched immutable blobs", async () => {
  const payloads = [
    data => ({ ...data, type: "symlink" }),
    data => ({ ...data, target: "another.rb" }),
    data => ({ ...data, encoding: "utf-8" }),
    data => ({ ...data, path: "Casks/w/wrong.rb" }),
    data => ({ ...data, size: data.size + 1 }),
    data => ({ ...data, content: `${data.content}!` }),
    data => ({ ...data, content: "/w==", size: 1 }),
    data => ({ ...data, sha: "d".repeat(40) }),
    () => [],
  ]
  for (const payload of payloads) await rejected(state => { state.payload = payload })
  await rejected(state => { state.mergeBase = "main" })
  await rejected(state => { state.treePayload = data => ({ ...data, truncated: true }) })
})

test("rejects symlinks even when the Contents API dereferences them as files", async () => {
  for (const kind of ["rename", "migration"]) {
    await rejected(state => {
      state.modes[`${MERGE_BASE}:${oldPath}`] = "120000"
    }, kind)
  }
})

test("rejects symlinked rename destinations, registries and parent directories", async () => {
  for (const [ref, path] of [[HEAD, newPath], [HEAD, "cask_renames.json"], [MERGE_BASE, "Casks"]]) {
    await rejected(state => { state.modes[`${ref}:${path}`] = "120000" })
  }
  await rejected(state => { state.treePayload = data => ({ tree: data.tree }) })
})
