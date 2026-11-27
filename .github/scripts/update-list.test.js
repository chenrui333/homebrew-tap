const assert = require("node:assert/strict")
const { execFileSync } = require("node:child_process")
const { mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } = require("node:fs")
const { tmpdir } = require("node:os")
const { join } = require("node:path")
const test = require("node:test")

test("lists tracked formulae and casks and drops removed recipes", (t) => {
  const cwd = mkdtempSync(join(tmpdir(), "tap-list-"))
  t.after(() => rmSync(cwd, { recursive: true, force: true }))
  const git = (...args) => execFileSync("git", args, { cwd })
  const generate = () => {
    execFileSync("bash", [join(__dirname, "update-list.sh")], { cwd })
    return readFileSync(join(cwd, "README.md"), "utf8")
  }

  git("init", "-q")
  for (const dir of ["Formula/h", "Casks/a", "Casks/z"]) mkdirSync(join(cwd, dir), { recursive: true })
  for (const file of ["Formula/h/hello.rb", "Casks/a/alpha.rb", "Casks/z/zeta.rb", "Casks/a/local.rb"]) {
    writeFileSync(join(cwd, file), "")
  }
  git("add", "Formula/h/hello.rb", "Casks/a/alpha.rb", "Casks/z/zeta.rb")
  writeFileSync(join(cwd, "README.md"), "Intro\n<!-- FORMULAE-LIST-START -->\nold\n<!-- FORMULAE-LIST-END -->\nFooter\n")

  const first = generate()
  assert.match(first, /<summary>Formula List<\/summary>\n\n- `hello`/)
  assert.match(first, /<summary>Cask List<\/summary>\n\n- `alpha`\n- `zeta`/)
  assert.doesNotMatch(first, /`local`/)
  assert.match(first, /^Intro\n[\s\S]*\nFooter\n$/)
  assert.equal(generate(), first)

  git("rm", "--cached", "Casks/a/alpha.rb")
  const updated = generate()
  assert.doesNotMatch(updated, /`alpha`/)
  assert.match(updated, /<summary>Cask List<\/summary>\n\n- `zeta`/)
})
