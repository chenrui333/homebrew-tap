const assert = require("node:assert/strict")
const test = require("node:test")
const { hostedCaskMatrix } = require("./cask-hosted-matrix")

const native = (runner, arch = "arm", overrides = {}) => ({
  name: `test example (${runner}, ${arch})`, runner, tap: "chenrui333/tap",
  cask: { token: "example", path: "./Casks/e/example.rb" },
  audit_args: ["--online", "--new"], fetch_args: [], skip_install: false,
  ...overrides,
})

test("syntax jobs use hosted macOS without changing stable or audit policy", () => {
  const matrix = [false, true].map(stable => ({
    name: `tap_syntax${stable ? " (stable)" : ""} (xcode-27)`,
    runner: "xcode-27", stable, skip_audit: stable,
  }))
  const before = structuredClone(matrix)
  assert.deepEqual(hostedCaskMatrix(matrix), matrix.map(job => ({
    ...job, runner: "macos-26", name: job.name.replace("xcode-27", "macos-26"),
  })))
  assert.deepEqual(matrix, before)
})

test("preserves every hosted OS and architecture job without relabeling native coverage", () => {
  const hosted = [native("macos-15"), native("macos-26"), native("ubuntu-latest", "intel"), native("ubuntu-24.04-arm")]
  const matrix = [...hosted, native("xcode-27")]
  const before = structuredClone(matrix)
  assert.deepEqual(hostedCaskMatrix(matrix), hosted)
  assert.deepEqual(matrix, before)
})

test("fails closed when a higher macOS floor leaves no compatible hosted native job", () => {
  assert.throws(() => hostedCaskMatrix([native("xcode-27"), native("ubuntu-latest")]), /Unsupported cask runner requirement/)
})

test("does not substitute another architecture, cask, tap, source or weaker audit/install policy", () => {
  for (const candidate of [
    native("macos-26", "intel"),
    native("macos-26", "arm", { cask: { token: "other", path: "./Casks/e/example.rb" } }),
    native("macos-26", "arm", { cask: { token: "example", path: "./Casks/e/other.rb" } }),
    native("macos-26", "arm", { tap: "other/tap" }),
    native("macos-26", "arm", { audit_args: ["--online", "--new", "--except", "signing"] }),
    native("macos-26", "arm", { skip_audit: true }),
    native("macos-26", "arm", { skip_install: true }),
    native("macos-26", "arm", { fetch_args: ["--force"] }),
  ]) {
    assert.throws(() => hostedCaskMatrix([candidate, native("xcode-27")]), /Unsupported cask runner requirement/)
  }
})

test("rejects malformed or empty matrices rather than producing an empty success", () => {
  for (const matrix of [null, {}, []]) assert.throws(() => hostedCaskMatrix(matrix), /invalid cask matrix/)
  assert.throws(() => hostedCaskMatrix([native("xcode-27", "unknown")]), /Unsupported cask runner requirement/)
})
