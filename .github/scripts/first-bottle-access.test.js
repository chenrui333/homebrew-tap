const assert = require("node:assert/strict")
const { spawnSync } = require("node:child_process")
const { createHash } = require("node:crypto")
const { mkdtempSync, readFileSync, rmSync, writeFileSync } = require("node:fs")
const { tmpdir } = require("node:os")
const { join } = require("node:path")
const test = require("node:test")

const workflow = readFileSync(join(__dirname, "../workflows/formula-merge.yml"), "utf8")
const script = workflow.split("      - name: Verify anonymous access to first-publish bottles\n")[1]
  .split("\n      - name:")[0].split("        run: |\n")[1]
  .replace(/^ {10}/gm, "")
const head = "a".repeat(40)
const manifest = '{"schemaVersion":2,"manifests":[]}'
const digest = createHash("sha256").update(manifest).digest("hex")

function qualify(t, options = {}) {
  const cwd = mkdtempSync(join(tmpdir(), "public-bottle-"))
  t.after(() => rmSync(cwd, { recursive: true, force: true }))
  const filename = "Formula/f/foo@2.rb"
  const output = join(cwd, "output")
  writeFileSync(output, "")
  writeFileSync(join(cwd, "requests"), "")
  writeFileSync(join(cwd, "fixture.json"), JSON.stringify({
    status: "added", filename, head, digest, manifest,
    recipe: `  bottle do\n    root_url "https://ghcr.io/v2/chenrui333/tap"\n    manifest_sha256 "${digest}"\n  end\n`,
    ...options,
  }))
  const fake = `#!/usr/bin/env node
const { appendFileSync, readFileSync, writeFileSync } = require("node:fs")
const { basename } = require("node:path")
const f = JSON.parse(readFileSync("fixture.json"))
const argv = process.argv.slice(2)
if (basename(process.argv[1]) === "gh") {
  const endpoint = argv.find(arg => arg.startsWith("repos/"))
  if (endpoint.endsWith("/files")) console.log(JSON.stringify([[{ filename: f.filename, status: f.status }]]))
  else if (endpoint.endsWith("/contents/" + f.filename + "?ref=" + f.head)) console.log(Buffer.from(f.recipe).toString("base64"))
  else process.exit(2)
} else {
  const endpoint = argv.at(-1)
  appendFileSync("requests", endpoint + "\\n")
  if (endpoint === "https://ghcr.io/token") {
    if (!argv.includes("scope=repository:chenrui333/tap/foo/2:pull") || argv.some(a => a.startsWith("Authorization:"))) process.exit(2)
    if (f.denied) process.exit(22)
    console.log(JSON.stringify({ token: "anonymous-registry-token" }))
  } else if (endpoint === "https://ghcr.io/v2/chenrui333/tap/foo/2/manifests/sha256:" + f.digest &&
      argv.includes("Authorization: Bearer anonymous-registry-token")) {
    if (f.missing) process.exit(22)
    writeFileSync(argv[argv.indexOf("-o") + 1], f.manifest)
  } else process.exit(2)
}
`
  for (const name of ["gh", "curl"]) writeFileSync(join(cwd, name), fake, { mode: 0o755 })
  const result = spawnSync("bash", ["-c", script], {
    cwd, encoding: "utf8", timeout: 5000,
    env: { ...process.env, PATH: `${cwd}:${process.env.PATH}`, GITHUB_OUTPUT: output,
      GITHUB_REPOSITORY: "chenrui333/homebrew-tap", PR_NUMBER: "1", EXPECTED_HEAD_SHA: head },
  })
  assert.equal(result.status, 0, result.stderr)
  return { output: readFileSync(output, "utf8"), requests: readFileSync(join(cwd, "requests"), "utf8"),
    log: result.stdout }
}

test("admits a versioned formula only after fetching its exact public manifest", (t) => {
  const result = qualify(t)
  assert.equal(result.output, "available=true\n")
  assert.match(result.requests, /foo\/2\/manifests\/sha256:/)
  assert.doesNotMatch(result.log, /anonymous-registry-token/)
})

test("does not admit a newly added formula without anonymous pull permission", (t) => {
  const result = qualify(t, { denied: true })
  assert.equal(result.output, "")
  assert.equal(result.requests, "https://ghcr.io/token\n")
  assert.match(result.log, /did not grant anonymous pull access/)
})

test("does not admit a missing manifest or response with different bytes", (t) => {
  for (const options of [{ missing: true }, { manifest: '{"schemaVersion":2}' }]) {
    const result = qualify(t, options)
    assert.equal(result.output, "")
    assert.match(result.log, /Exact bottle manifest is not accessible/)
  }
})

test("missing metadata blocks only a new formula, without accessing GHCR", (t) => {
  const addition = qualify(t, { recipe: "" })
  assert.equal(addition.output, "")
  assert.equal(addition.requests, "")
  assert.match(addition.log, /Missing or unsupported first-publish bottle metadata/)
  const update = qualify(t, { recipe: "", status: "modified" })
  assert.equal(update.output, "available=true\n")
  assert.equal(update.requests, "")
})
