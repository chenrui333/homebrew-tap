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

const fakeGh = `#!/bin/bash
path="\${@: -1}"
case "$path" in
  repos/chenrui333/homebrew-tap/pulls/11999) cat "$PUBLISH_TEST_DIR/pr.json" ;;
  repos/chenrui333/homebrew-tap/commits/*/statuses)
    sha="\${path#*/commits/}"
    jq -c --arg sha "\${sha%/statuses}" '[.[$sha] // []]' "$PUBLISH_TEST_DIR/statuses.json" ;;
  repos/chenrui333/homebrew-tap/issues/11999/comments) jq -c '[.]' "$PUBLISH_TEST_DIR/comments.json" ;;
  *) echo "Unexpected GitHub call" >&2; exit 99 ;;
esac
`

function validate(overrides = {}, {statuses = {}, comments = []} = {}) {
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
    writeFileSync(join(directory, "statuses.json"), JSON.stringify(statuses))
    writeFileSync(join(directory, "comments.json"), JSON.stringify(comments))
    writeFileSync(join(directory, "gh"), fakeGh, {mode: 0o755})
    const output = join(directory, "output")
    writeFileSync(output, "")
    const result = spawnSync("bash", ["-e", "-c", script], {
      encoding: "utf8",
      env: {
        ...process.env,
        PATH: `${directory}:${process.env.PATH}`,
        PUBLISH_TEST_DIR: directory,
        PUBLISHED_HEAD_CONTEXT: "homebrew-tap/published-bottle-head",
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

const headSha = "a".repeat(40)
const bottlePr = {labels: [{name: "pr-pull"}]}
const publishedStatus = (login = "github-actions[bot]", state = "success") =>
  ({context: "homebrew-tap/published-bottle-head", state, creator: {login}})
const legacyMarker = (login, sha = headSha) =>
  ({user: {login}, body: `<!-- homebrew-tap: published-bottle-head ${sha} -->`})

function publishOutputs(result) {
  assert.equal(result.status, 0, result.stderr + result.stdout)
  const outputs = Object.fromEntries(result.output.trim().split("\n").map((line) => line.split(/=(.*)/s).slice(0, 2)))
  return {publish: outputs.publish, publishedHead: outputs.published_head, legacyAuthor: outputs.legacy_marker_author}
}

test("a published-bottle status on the current head makes publication a no-op without reading comments", () => {
  const result = validate(bottlePr, {statuses: {[headSha]: [publishedStatus()]}, comments: "not-json-if-read"})
  assert.deepEqual(publishOutputs(result), {publish: "false", publishedHead: headSha, legacyAuthor: ""})
})

for (const author of ["github-actions[bot]", "chenrui333"]) {
  test(`a legacy ${author} comment marker on the current head is handed to reconcile for migration`, () => {
    const result = validate(bottlePr, {comments: [legacyMarker(author)]})
    assert.deepEqual(publishOutputs(result), {publish: "false", publishedHead: headSha, legacyAuthor: author})
  })
}

for (const [name, data] of [
  ["no published-bottle record", {}],
  ["a status from another creator", {statuses: {[headSha]: [publishedStatus("chenrui333")]}}],
  ["a superseded bot status", {statuses: {[headSha]: [publishedStatus(undefined, "failure"), publishedStatus()]}}],
  ["a status on an older head", {statuses: {["b".repeat(40)]: [publishedStatus()]}}],
  ["a legacy marker for an older head", {comments: [legacyMarker("github-actions[bot]", "b".repeat(40))]}],
  ["a legacy marker from another user", {comments: [legacyMarker("someone-else")]}],
]) {
  test(`publishes bottles with ${name}`, () => {
    const result = validate(bottlePr, data)
    assert.deepEqual(publishOutputs(result), {publish: "true", publishedHead: undefined, legacyAuthor: undefined})
  })
}
