const assert = require("node:assert/strict")
const { chmodSync, copyFileSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } = require("node:fs")
const { tmpdir } = require("node:os")
const { join } = require("node:path")
const { spawnSync } = require("node:child_process")
const test = require("node:test")

function applyCleanup({ version, tap = "example/tap" }) {
  const root = mkdtempSync(join(tmpdir(), "superseded-provider-"))
  try {
    const bin = join(root, "bin")
    const cmd = join(root, "cmd")
    const formula = join(root, "Formula", "w")
    for (const path of [bin, cmd, formula]) mkdirSync(path, { recursive: true })
    const helper = join(cmd, "brew-close-superseded-prs")
    copyFileSync(join(__dirname, "../../cmd/brew-close-superseded-prs"), helper)
    writeFileSync(join(formula, "widget.rb"), 'class Widget < Formula\n  version "1.0"\nend\n')
    const stateFile = join(root, "state.json")
    writeFileSync(stateFile, JSON.stringify({
      pr: { number: 7, title: "widget 2.0", labels: [], createdAt: "2026-11-08T00:00:00Z", state: "OPEN", mergedAt: null },
      metadata: { tap, versions: { stable: version } },
      comments: [],
    }))
    writeFileSync(join(bin, "brew"), `#!/usr/bin/env node
const fs = require("node:fs")
const args = process.argv.slice(2)
const state = JSON.parse(fs.readFileSync(process.env.FAKE_GH_STATE, "utf8"))
if (args[0] === "--repo") {
  console.log(process.env.FAKE_TAP_ROOT)
} else if (args[0] === "info") {
  const metadata = args.at(-1) === "example/tap/widget"
    ? state.metadata
    : { tap: "other/tap", versions: { stable: "9.0" } }
  console.log(JSON.stringify({ formulae: [metadata], casks: [] }))
} else {
  process.exit(2)
}
`)
    writeFileSync(join(bin, "gh"), `#!/usr/bin/env node
const fs = require("node:fs")
const file = process.env.FAKE_GH_STATE
const state = JSON.parse(fs.readFileSync(file, "utf8"))
const args = process.argv.slice(2)
const value = name => args[args.indexOf(name) + 1]
if (args[0] === "pr" && args[1] === "list") {
  console.log(JSON.stringify(state.pr.state.toLowerCase() === value("--state") ? [state.pr] : []))
} else if (args[0] === "label" && args[1] === "list") {
  console.log(JSON.stringify([{ name: "superseded" }]))
} else if (args[0] === "pr" && args[1] === "comment") {
  state.comments.push(fs.readFileSync(value("--body-file"), "utf8"))
} else if (args[0] === "pr" && args[1] === "edit") {
  state.pr.labels.push({ name: value("--add-label") })
} else if (args[0] === "pr" && args[1] === "close") {
  state.pr.state = "CLOSED"
} else {
  process.exit(2)
}
fs.writeFileSync(file, JSON.stringify(state))
`)
    for (const name of ["brew", "gh"]) chmodSync(join(bin, name), 0o755)
    const result = spawnSync("ruby", [helper, "--apply", "--repo", "example/homebrew-tap", "--formula", "widget", "--closed-days", "0"], {
      cwd: root,
      env: { ...process.env, PATH: `${bin}:${process.env.PATH}`, FAKE_TAP_ROOT: root, FAKE_GH_STATE: stateFile },
      encoding: "utf8",
    })
    assert.equal(result.status, 0, result.stderr)
    return JSON.parse(readFileSync(stateFile, "utf8")).pr.state
  } finally {
    rmSync(root, { recursive: true, force: true })
  }
}

test("keeps an update open when only another installed tap has its version", () => {
  assert.equal(applyCleanup({ version: "1.0" }), "OPEN")
})

test("closes an update already present in the requested tap", () => {
  assert.equal(applyCleanup({ version: "2.0" }), "CLOSED")
})

test("keeps an update open if qualified metadata still resolves to another tap", () => {
  assert.equal(applyCleanup({ version: "2.0", tap: "other/tap" }), "OPEN")
})
