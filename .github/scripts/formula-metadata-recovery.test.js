const assert = require("node:assert/strict")
const { chmodSync, mkdtempSync, readFileSync, rmSync, writeFileSync } = require("node:fs")
const { tmpdir } = require("node:os")
const { join } = require("node:path")
const { spawnSync } = require("node:child_process")
const test = require("node:test")

const repository = "example/homebrew-tap"
const branch = "automation/formula-metadata"
const head = "a".repeat(40)
const outputs = [".cache/formula_metadata.json", "formula-status/formula-status.md"]

// Exercise the workflow's real shell with a local gh double; never contact GitHub.
const mergeSource = readFileSync(
  process.env.METADATA_MERGE_WORKFLOW || join(__dirname, "../workflows/generated-maintenance-merge.yml"), "utf8",
)
const shell = mergeSource.split("        run: |\n")[1]
  .split("\n").map((line) => line.replace(/^          /, "")).join("\n")

function admission({ files = outputs, pr = {}, finalPr = pr, checks = null, ref = branch } = {}) {
  const root = mkdtempSync(join(tmpdir(), "formula-metadata-recovery-"))
  try {
    const state = join(root, "state.json")
    const initial = {
      state: "open", draft: false, base: { ref: "main" }, labels: [],
      head: { ref: branch, sha: head, repo: { full_name: repository } },
    }
    writeFileSync(state, JSON.stringify({
      files, initial: { ...initial, ...pr }, final: { ...initial, ...finalPr },
      checks: checks ?? [{ name: "Spell Check", bucket: "pass", workflow: "Spell Check" }],
      reads: 0,
    }))
    const gh = join(root, "gh")
    writeFileSync(gh, `#!/usr/bin/env node
const fs = require("node:fs")
const file = process.env.METADATA_TEST_STATE
const state = JSON.parse(fs.readFileSync(file, "utf8"))
const args = process.argv.slice(2)
if (args[0] === "api") {
  const endpoint = args.at(-1)
  if (endpoint.endsWith("/files")) console.log(JSON.stringify(state.files.map(filename => ({ filename }))))
  else if (endpoint.endsWith("/pulls/7")) console.log(JSON.stringify(state.reads++ === 0 ? state.initial : state.final))
  else process.exit(2)
} else if (args[0] === "pr" && args[1] === "checks") {
  console.log(JSON.stringify(state.checks))
} else if (args[0] === "pr" && args[1] === "merge") {
  const guard = args.indexOf("--match-head-commit")
  if (guard !== -1 && args[guard + 1] !== state.final.head.sha) process.exit(1)
  state.final.state = "closed"
} else process.exit(2)
fs.writeFileSync(file, JSON.stringify(state))
`)
    chmodSync(gh, 0o755)
    const result = spawnSync("bash", ["-c", shell], {
      encoding: "utf8", timeout: 5000,
      env: {
        ...process.env, PATH: `${root}:${process.env.PATH}`, GH_TOKEN: "test-only",
        METADATA_TEST_STATE: state, GITHUB_REPOSITORY: repository,
        PR_NUMBER: "7", EVENT_HEAD_SHA: head, HEAD_REF: ref,
      },
    })
    assert.ifError(result.error)
    return { ...result, state: JSON.parse(readFileSync(state, "utf8")) }
  } finally {
    rmSync(root, { recursive: true, force: true })
  }
}


test("exact metadata outputs merge only at the event head after passing checks", () => {
  const result = admission({ files: [...outputs].reverse() })
  assert.equal(result.status, 0, result.stderr)
  assert.equal(result.state.final.state, "closed")
})

test("a report timestamp update can merge while deterministic cache contents stay unchanged", () => {
  const result = admission({ files: ["formula-status/formula-status.md"] })
  assert.equal(result.status, 0, result.stderr)
  assert.equal(result.state.final.state, "closed")
})

for (const [name, options] of Object.entries({
  "no output": { files: [] },
  "newline path": { files: [outputs.join("\n")] },
  "extra cache file": { files: [...outputs, ".cache/unrelated.json"] },
  "extra workflow": { files: [...outputs, ".github/workflows/formula-status.yml"] },
  "lookalike branch": { ref: `${branch}-other` },
  "fork PR": { pr: { head: { ref: branch, sha: head, repo: { full_name: "fork/homebrew-tap" } } } },
  "non-main base": { pr: { base: { ref: "other" } } },
  "draft PR": { pr: { draft: true } },
  "held PR": { pr: { labels: [{ name: "in progress" }] } },
  "changed head": { pr: { head: { ref: branch, sha: "b".repeat(40), repo: { full_name: repository } } } },
  "head changed after checks": { finalPr: { head: { ref: branch, sha: "b".repeat(40), repo: { full_name: repository } } } },
  "failed check": { checks: [{ name: "Spell Check", bucket: "fail", workflow: "Spell Check" }] },
})) {
  test(`metadata admission rejects ${name}`, () => {
    const result = admission(options)
    assert.equal(result.status, name === "failed check" ? 1 : 0, result.stderr)
    assert.equal(result.state.final.state, "open")
  })
}
