const assert = require("node:assert/strict")
const {spawnSync} = require("node:child_process")
const {mkdtempSync, readFileSync, rmSync, writeFileSync} = require("node:fs")
const {tmpdir} = require("node:os")
const {join} = require("node:path")
const test = require("node:test")

const repository = "chenrui333/homebrew-tap"
const workflow = readFileSync(".github/workflows/publish.yml", "utf8")
const validationStep = workflow.split("      - name: Validate PR\n")[1]
  .split("\n      - name: Reconcile published bottle label\n")[0]
const script = validationStep.split("        run: |\n")[1]
  .split("\n").map((line) => line.replace(/^          /, "")).join("\n")

function validate(overrides = {}) {
  const directory = mkdtempSync(join(tmpdir(), "publish-validation-"))
  try {
    const pr = {
      state: "open",
      draft: false,
      merged_at: null,
      base: {ref: "main"},
      head: {ref: "network-sandbox/example", sha: "a".repeat(40), repo: {full_name: repository}},
      title: "example: add network sandbox",
      labels: [{name: "CI-no-bottles"}, {name: "pr-pull"}],
      user: {type: "User"},
      ...overrides,
    }
    writeFileSync(join(directory, "pr.json"), JSON.stringify(pr))
    writeFileSync(join(directory, "gh"), '#!/bin/bash\nif [[ "$1" == api && "$2" == "repos/chenrui333/homebrew-tap/pulls/11999" ]]; then\n  cat "$PUBLISH_TEST_PR"\nelse\n  echo "Unexpected GitHub call" >&2\n  exit 99\nfi\n', {mode: 0o755})
    const output = join(directory, "output")
    writeFileSync(output, "")
    const result = spawnSync("bash", ["-e", "-c", script], {
      encoding: "utf8",
      env: {
        ...process.env,
        PATH: `${directory}:${process.env.PATH}`,
        PUBLISH_TEST_PR: join(directory, "pr.json"),
        GITHUB_REPOSITORY: repository,
        GITHUB_REPOSITORY_OWNER: "chenrui333",
        GITHUB_EVENT_NAME: "pull_request_target",
        GITHUB_OUTPUT: output,
        PR: "11999",
      },
    })
    return {...result, output: readFileSync(output, "utf8")}
  } finally {
    rmSync(directory, {recursive: true, force: true})
  }
}

test("queued no-bottles publication succeeds without mutations after the PR merges", () => {
  const result = validate({state: "closed", merged_at: "2026-10-03T15:48:09Z"})
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.equal(result.output, "publish=false\nmerged=true\n")
})

test("queued bottle publication succeeds without mutations after the PR merges", () => {
  const result = validate({state: "closed", merged_at: "2026-10-03T19:03:05Z", labels: [{name: "pr-pull"}, {name: "CI-published-bottle-commits"}]})
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.equal(result.output, "publish=false\nmerged=true\n")
})

test("open no-bottles publication remains a no-op", () => {
  const result = validate()
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.equal(result.output, "publish=false\nno_bottles=true\n")
})

for (const [name, overrides] of [
  ["closed unmerged PR", {state: "closed"}],
  ["merged fork", {state: "closed", merged_at: "2026-10-03T15:48:09Z", head: {ref: "example", sha: "a".repeat(40), repo: {full_name: "other/tap"}}}],
  ["merged PR targeting another base", {state: "closed", merged_at: "2026-10-03T15:48:09Z", base: {ref: "other"}}],
  ["draft PR", {draft: true}],
]) {
  test(`rejects ${name}`, () => {
    const result = validate(overrides)
    assert.equal(result.status, 1, result.stderr + result.stdout)
    assert.equal(result.output, "")
  })
}
