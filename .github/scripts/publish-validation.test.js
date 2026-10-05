const assert = require("node:assert/strict")
const {spawnSync} = require("node:child_process")
const {mkdtempSync, readFileSync, rmSync, writeFileSync} = require("node:fs")
const {tmpdir} = require("node:os")
const {join} = require("node:path")
const test = require("node:test")

const repository = "chenrui333/homebrew-tap"
const workflow = readFileSync(".github/workflows/publish.yml", "utf8")
function stepScript(name) {
  const step = workflow.split(`      - name: ${name}\n`)[1].split("\n      - name: ")[0]
  return step.split("        run: |\n")[1]
    .split("\n").map((line) => line.replace(/^          /, "")).join("\n")
}
const script = stepScript("Validate PR")

const fakeGh = `#!/bin/bash
path="\${@: -1}"
case "$path" in
  repos/chenrui333/homebrew-tap/pulls/11999) cat "$PUBLISH_TEST_DIR/pr.json" ;;
  repos/chenrui333/homebrew-tap/commits/*/statuses)
    sha="\${path#*/commits/}"
    jq -c --arg sha "\${sha%/statuses}" '[.[$sha] // []]' "$PUBLISH_TEST_DIR/statuses.json" ;;
  repos/chenrui333/homebrew-tap/commits/*)
    jq -c --arg sha "\${path#*/commits/}" '.[$sha] // {commit: {author: {name: "Rui Chen"}}, parents: []}' "$PUBLISH_TEST_DIR/commits.json" ;;
  repos/chenrui333/homebrew-tap/actions/workflows/tests.yml/runs\\?head_sha=*\\&event=pull_request\\&status=success)
    jq -c '{workflow_runs: .}' "$PUBLISH_TEST_DIR/runs.json" ;;
  repos/chenrui333/homebrew-tap/issues/11999/comments) jq -c '[.]' "$PUBLISH_TEST_DIR/comments.json" ;;
  *) echo "Unexpected GitHub call" >&2; exit 99 ;;
esac
`

function validate(overrides = {}, {statuses = {}, comments = [], commits = {}, runs = []} = {}) {
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
    writeFileSync(join(directory, "commits.json"), JSON.stringify(commits))
    writeFileSync(join(directory, "runs.json"), JSON.stringify(runs))
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
  return {publish: outputs.publish, publishedHead: outputs.published_head, legacyAuthor: outputs.legacy_marker_author, recovered: outputs.recovered_bottle_commit}
}

test("a published-bottle status on the current head makes publication a no-op without reading comments", () => {
  const result = validate(bottlePr, {statuses: {[headSha]: [publishedStatus()]}, comments: "not-json-if-read"})
  assert.deepEqual(publishOutputs(result), {publish: "false", publishedHead: headSha, legacyAuthor: "", recovered: "false"})
})

for (const author of ["github-actions[bot]", "chenrui333"]) {
  test(`a legacy ${author} comment marker on the current head is handed to reconcile for migration`, () => {
    const result = validate(bottlePr, {comments: [legacyMarker(author)]})
    assert.deepEqual(publishOutputs(result), {publish: "false", publishedHead: headSha, legacyAuthor: author, recovered: "false"})
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
    assert.deepEqual(publishOutputs(result), {publish: "true", publishedHead: undefined, legacyAuthor: undefined, recovered: undefined})
  })
}

const sourceSha = "c".repeat(40)
const botEmail = "1589480+BrewTestBot@users.noreply.github.com"
const bottleCommit = (parent, overrides = {}) => ({
  commit: {
    author: {name: "BrewTestBot", email: botEmail},
    committer: {name: "BrewTestBot", email: botEmail},
    message: "example: update 1.0.0 bottle.",
  },
  parents: [{sha: parent}],
  files: [{filename: "Formula/e/example.rb", status: "modified"}],
  ...overrides,
})
const sourceCommit = {commit: {author: {name: "Rui Chen", email: "rui@example.com"}}, parents: [{sha: "d".repeat(40)}]}
const testedRun = (overrides = {}) =>
  ({head_sha: sourceSha, head_branch: "network-sandbox/example", head_repository: {full_name: repository}, ...overrides})

test("bottle commits pushed by an earlier attempt on a tested source head are reconciled", () => {
  const result = validate(bottlePr, {commits: {[headSha]: bottleCommit(sourceSha), [sourceSha]: sourceCommit}, runs: [testedRun()]})
  assert.deepEqual(publishOutputs(result), {publish: "false", publishedHead: headSha, legacyAuthor: "", recovered: "true"})
})

test("a chain of per-formula bottle commits is reconciled down to the tested source head", () => {
  const middleSha = "e".repeat(40)
  const result = validate(bottlePr, {
    commits: {[headSha]: bottleCommit(middleSha), [middleSha]: bottleCommit(sourceSha), [sourceSha]: sourceCommit},
    runs: [testedRun()],
  })
  assert.deepEqual(publishOutputs(result), {publish: "false", publishedHead: headSha, legacyAuthor: "", recovered: "true"})
})

for (const [name, commit, runs] of [
  ["an untested source head", bottleCommit(sourceSha), []],
  ["a tested run on another branch", bottleCommit(sourceSha), [testedRun({head_branch: "other"})]],
  ["a tested run from a fork", bottleCommit(sourceSha), [testedRun({head_repository: {full_name: "other/tap"}})]],
  ["a non-bot committer", bottleCommit(sourceSha, {commit: {...bottleCommit(sourceSha).commit, committer: {name: "Rui Chen", email: "rui@example.com"}}}), [testedRun()]],
  ["a non-bottle commit message", bottleCommit(sourceSha, {commit: {...bottleCommit(sourceSha).commit, message: "example: tweak"}}), [testedRun()]],
  ["extra changed files", bottleCommit(sourceSha, {files: [{filename: "Formula/e/example.rb", status: "modified"}, {filename: ".github/workflows/publish.yml", status: "modified"}]}), [testedRun()]],
  ["a merge commit", bottleCommit(sourceSha, {parents: [{sha: sourceSha}, {sha: "f".repeat(40)}]}), [testedRun()]],
]) {
  test(`does not reconcile a bottle-like head with ${name}`, () => {
    const result = validate(bottlePr, {commits: {[headSha]: commit, [sourceSha]: sourceCommit}, runs})
    assert.deepEqual(publishOutputs(result), {publish: "true", publishedHead: undefined, legacyAuthor: undefined, recovered: undefined})
  })
}

const verifyScript = stepScript("Verify pushed bottle commit")
const pushedSha = "b".repeat(40)
const verifyGh = `#!/bin/bash
count="$(cat "$PUBLISH_TEST_DIR/pr-calls")"
echo $((count + 1)) > "$PUBLISH_TEST_DIR/pr-calls"
jq -ec --argjson i "$count" '.[$i] // .[-1] | if . == null then error("api down") else . end' "$PUBLISH_TEST_DIR/prs.json"
`
const verifyGit = `#!/bin/bash
printf '%s\\trefs/heads/network-sandbox/example\\n' "$(cat "$PUBLISH_TEST_DIR/branch-head")"
`
const verifySleep = `#!/bin/bash
echo "$1" >> "$PUBLISH_TEST_DIR/sleeps"
`
const prAt = (sha, overrides = {}) => ({
  state: "open",
  draft: false,
  base: {ref: "main"},
  head: {ref: "network-sandbox/example", sha, repo: {full_name: repository}},
  ...overrides,
})

function verify(prs, {branchHead = pushedSha} = {}) {
  const directory = mkdtempSync(join(tmpdir(), "publish-verify-"))
  try {
    writeFileSync(join(directory, "prs.json"), JSON.stringify(prs))
    writeFileSync(join(directory, "pr-calls"), "0")
    writeFileSync(join(directory, "branch-head"), branchHead)
    writeFileSync(join(directory, "sleeps"), "")
    writeFileSync(join(directory, "gh"), verifyGh, {mode: 0o755})
    writeFileSync(join(directory, "git"), verifyGit, {mode: 0o755})
    writeFileSync(join(directory, "sleep"), verifySleep, {mode: 0o755})
    const result = spawnSync("bash", ["-e", "-c", verifyScript], {
      encoding: "utf8",
      env: {
        ...process.env,
        PATH: `${directory}:${process.env.PATH}`,
        PUBLISH_TEST_DIR: directory,
        GITHUB_REPOSITORY: repository,
        PR: "11999",
        PUBLISHED_HEAD: pushedSha,
        EXPECTED_HEAD: headSha,
        HEAD_BRANCH: "network-sandbox/example",
      },
    })
    const sleeps = readFileSync(join(directory, "sleeps"), "utf8").trim().split("\n").filter(Boolean).map(Number)
    return {...result, sleeps}
  } finally {
    rmSync(directory, {recursive: true, force: true})
  }
}

test("verification succeeds once the PR API reports the pushed bottle commit", () => {
  const result = verify([prAt(headSha), prAt(headSha), prAt(pushedSha)])
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.sleeps, [5, 10])
  assert.doesNotMatch(result.stdout, /treating it as published/)
})

test("verification backs off for about ten minutes, then trusts an exact branch ref over a lagging PR API", () => {
  const result = verify([prAt(headSha)])
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.ok(result.sleeps.reduce((a, b) => a + b) >= 500, `slept ${result.sleeps}`)
  assert.match(result.stdout, /::warning::GitHub PR API still reports a{40}, but refs\/heads\/network-sandbox\/example is exactly the published bottle commit b{40}/)
})

for (const [name, prs, options] of [
  ["the branch ref moved past the pushed commit", [prAt(headSha)], {branchHead: "f".repeat(40)}],
  ["the PR API reports an unrelated head", [prAt("f".repeat(40))], {}],
  ["the PR API never answers", [null], {}],
  ["the PR was closed", [prAt(headSha, {state: "closed"})], {}],
  ["the PR became a draft", [prAt(headSha, {draft: true})], {}],
  ["the PR base changed", [prAt(headSha, {base: {ref: "other"}})], {}],
  ["the PR head repository changed", [prAt(headSha, {head: {ref: "network-sandbox/example", sha: headSha, repo: {full_name: "other/tap"}}})], {}],
]) {
  test(`verification fails when ${name}`, () => {
    const result = verify(prs, options)
    assert.equal(result.status, 1, result.stderr + result.stdout)
  })
}
