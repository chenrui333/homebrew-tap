const assert = require("node:assert/strict")
const {spawnSync} = require("node:child_process")
const {mkdtempSync, readFileSync, rmSync, writeFileSync} = require("node:fs")
const {tmpdir} = require("node:os")
const {join} = require("node:path")
const test = require("node:test")

const repository = "chenrui333/homebrew-tap"
// Point at an old workflow snapshot to demonstrate the behavior regressions before the repair.
const workflow = readFileSync(process.env.PUBLISH_WORKFLOW || ".github/workflows/publish.yml", "utf8")
function stepDefinition(name) {
  return workflow.split(`      - name: ${name}\n`)[1].split("\n      - name: ")[0]
}
function stepScript(name) {
  const step = stepDefinition(name)
  const match = step.match(/^        run: (.*)\n?/m)
  if (!match) return null
  if (match[1] !== "|" && match[1] !== ">-") return match[1]
  return step.slice(match.index + match[0].length)
    .split("\n").map((line) => line.replace(/^          /, "")).join(match[1] === ">-" ? " " : "\n")
}

// Run real workflow shell against a stateful API/process fixture. Only mutations are mocked;
// the workflow itself decides whether upload, push, status and label side effects are reachable.
const fakeGh = `#!/usr/bin/env node
const {readFileSync, writeFileSync, appendFileSync} = require("node:fs")
const root = process.env.PUBLISH_TEST_DIR
const data = JSON.parse(readFileSync(root + "/fixture.json"))
const state = JSON.parse(readFileSync(root + "/state.json"))
const args = process.argv.slice(2)
const path = args.find(arg => arg.startsWith("repos/")) || ""
function reply(key, fallback) {
  const i = state.calls[key] || 0
  state.calls[key] = i + 1
  writeFileSync(root + "/state.json", JSON.stringify(state))
  appendFileSync(root + "/calls", key + "\\n")
  const sequence = data.responses[key]
  let value = sequence ? sequence[Math.min(i, sequence.length - 1)] : fallback
  if (value && value._error) { console.error("fixture API unavailable"); process.exit(1) }
  if (value && value._raw !== undefined) { process.stdout.write(value._raw); return }
  console.log(JSON.stringify(value))
}
if (args[0] === "pr" && args[1] === "edit") {
  appendFileSync(root + "/effects", "label\\n")
} else if (args.includes("POST")) {
  appendFileSync(root + "/effects", "status\\n")
  console.log("{}")
} else if (args.includes("graphql")) {
  reply("consumer", data.consumer)
} else if (path.endsWith("/pulls/11999")) {
  const pr = structuredClone(data.pr)
  if (state.pushed) pr.head.sha = data.pushedSha
  reply("pr", pr)
} else if (path.includes("/commits/") && path.endsWith("/statuses")) {
  const sha = path.split("/commits/")[1].split("/")[0]
  reply("statuses", [data.statuses[sha] || []])
} else if (path.includes("/commits/")) {
  const sha = path.split("/commits/")[1]
  reply("commit:" + sha, data.commits[sha] || {commit: {author: {name: "Rui Chen"}}, parents: []})
} else if (path.includes("/issues/11999/comments")) {
  reply("comments", [data.comments])
} else if (path.includes("/actions/workflows/tests.yml/runs")) {
  if (path.includes("status=success")) reply("recovery", {workflow_runs: data.runs})
  else reply("runs", [{total_count: data.sourceRuns.length, workflow_runs: data.sourceRuns}])
} else {
  const match = path.match(/\\/actions\\/runs\\/(\\d+)(.*)/)
  if (!match) { console.error("Unexpected GitHub call: " + args.join(" ")); process.exit(99) }
  const [, id, suffix] = match
  if (suffix.startsWith("/artifacts")) reply("artifacts:" + id, [{total_count: data.artifacts.length, artifacts: data.artifacts}])
  else if (suffix.startsWith("/jobs")) reply("jobs:" + id, [{total_count: data.jobs.length, jobs: data.jobs}])
  else if (suffix.startsWith("/attempts/")) reply("attempt:" + id + ":" + suffix.split("/")[2], data.attempts[suffix.split("/")[2]] || null)
  else reply("run:" + id, data.sourceRuns.find(run => String(run.id) === id) || null)
}
`
const fakeGit = `#!/usr/bin/env node
const {readFileSync, writeFileSync, appendFileSync} = require("node:fs")
const root = process.env.PUBLISH_TEST_DIR
const data = JSON.parse(readFileSync(root + "/fixture.json"))
const state = JSON.parse(readFileSync(root + "/state.json"))
const args = process.argv.slice(2)
if (args.includes("ls-remote")) console.log((data.branchHead || (state.pushed ? data.pushedSha : data.pr.head.sha)) + "\\trefs/heads/network-sandbox/example")
else if (args.includes("rev-parse")) console.log(state.uploaded ? data.pushedSha : data.pr.head.sha)
else if (args.includes("--show-current")) console.log(data.pr.head.ref)
else if (args.includes("push")) {
  state.pushed = true
  writeFileSync(root + "/state.json", JSON.stringify(state))
  appendFileSync(root + "/effects", "push\\n")
} else if (!args.includes("fetch")) process.exit(99)
`
const fakeBrew = `#!/usr/bin/env node
const {readFileSync, writeFileSync, appendFileSync} = require("node:fs")
const root = process.env.PUBLISH_TEST_DIR
const command = process.argv[2]
if (command === "pr-upload") {
  const state = JSON.parse(readFileSync(root + "/state.json"))
  state.uploaded = true
  writeFileSync(root + "/state.json", JSON.stringify(state))
  appendFileSync(root + "/effects", "upload\\n")
} else if (command === "pr-pull") appendFileSync(root + "/effects", "pull\\n")
else process.exit(99)
`
const fakeSleep = `#!/bin/bash
echo "$1" >> "$PUBLISH_TEST_DIR/sleeps"
`
const parseOutputs = text => Object.fromEntries(text.trim().split("\n").filter(Boolean).map(line => line.split(/=(.*)/s).slice(0, 2)))
const runPages = runs => [{total_count: runs.length, workflow_runs: runs}]
function sourceRun(overrides = {}) {
  return {
    id: 42, workflow_id: 123, run_attempt: 1, status: "completed", conclusion: "success",
    head_sha: "a".repeat(40), head_branch: "network-sandbox/example",
    head_repository: {full_name: repository}, repository: {full_name: repository},
    event: "pull_request", path: ".github/workflows/tests.yml",
    created_at: "2026-11-08T00:00:00Z", run_started_at: "2026-11-08T00:00:00Z",
    ...overrides,
  }
}
function bottleArtifact(overrides = {}) {
  return {
    id: 100, name: "bottles_ubuntu-24.04", expired: false, size_in_bytes: 4096,
    created_at: "2026-11-08T00:03:00Z",
    expires_at: "2099-11-08T00:00:00Z",
    workflow_run: {id: 42, head_sha: "a".repeat(40), head_branch: "network-sandbox/example"},
    ...overrides,
  }
}
const failedArtifact = (overrides = {}) => bottleArtifact({
  id: 101, name: "failed-bottles_ubuntu-24.04", created_at: "2026-11-08T00:02:00Z", ...overrides,
})
function consumerResponse({sha = "a".repeat(40), runId = 42, workflowId = 123, suites} = {}) {
  return {data: {repository: {pullRequest: {commits: {nodes: [{commit: {
    oid: sha,
    checkSuites: suites || {
      totalCount: 1, pageInfo: {hasNextPage: false},
      nodes: [{status: "COMPLETED", workflowRun: {databaseId: runId, workflow: {databaseId: workflowId}}}],
    },
  }}]}}}}}
}

function publicationFixture(overrides, options, execute) {
  const directory = mkdtempSync(join(tmpdir(), "publish-validation-"))
  try {
    const data = {
      pr: {
        state: "open", draft: false, merged_at: null,
        base: {ref: "main"},
        head: {ref: "network-sandbox/example", sha: "a".repeat(40), repo: {full_name: repository}},
        title: "example: add network sandbox",
        labels: [{name: "CI-no-bottles"}, {name: "pr-pull"}],
        user: {type: "User"},
        ...overrides,
      },
      statuses: {}, comments: [], commits: {}, runs: [],
      sourceRuns: [sourceRun()], artifacts: [bottleArtifact()], jobs: [], attempts: {},
      responses: {}, consumer: consumerResponse(), pushedSha: "b".repeat(40),
      ...options,
    }
    writeFileSync(join(directory, "fixture.json"), JSON.stringify(data))
    writeFileSync(join(directory, "state.json"), JSON.stringify({calls: {}}))
    for (const file of ["calls", "effects", "sleeps"]) writeFileSync(join(directory, file), "")
    for (const [file, source] of [["gh", fakeGh], ["git", fakeGit], ["brew", fakeBrew], ["sleep", fakeSleep]]) {
      writeFileSync(join(directory, file), source, {mode: 0o755})
    }
    const outputs = {}
    const run = (name) => {
      const definition = stepDefinition(name)
      const condition = definition.match(/^        if: (.*)$/m)?.[1]
      if (condition) {
        const expression = condition.replace(/steps\.([\w-]+)\.outputs\.([\w-]+)/g,
          (_, step, key) => JSON.stringify(outputs[step]?.[key] || ""))
          .replace(/github\.event_name/g, JSON.stringify(options.eventName || "pull_request_target"))
          .replace(/github\.event\.label\.name/g, JSON.stringify("pr-pull"))
        if (!Function(`return (${expression})`)()) return null
      }
      const output = join(directory, "output")
      writeFileSync(output, "")
      const details = outputs["pr-details"] || {}
      const result = spawnSync("bash", ["-e", "-c", stepScript(name) || "git push"], {
        encoding: "utf8",
        env: {
          ...process.env,
          PATH: `${directory}:${process.env.PATH}`,
          PUBLISH_TEST_DIR: directory,
          PUBLISHED_HEAD_CONTEXT: "homebrew-tap/published-bottle-head",
          GITHUB_REPOSITORY: repository, GITHUB_REPOSITORY_OWNER: "chenrui333",
          GITHUB_EVENT_NAME: options.eventName || "pull_request_target",
          GITHUB_OUTPUT: output, PR: "11999", REPO_PATH: directory,
          EXPECTED_HEAD: details.expected_head || data.pr.head.sha,
          HEAD_BRANCH: details.head_branch || data.pr.head.ref,
          QUALIFIED_RUN_ID: details.qualified_run_id || "",
          QUALIFIED_RUN_ATTEMPT: details.qualified_run_attempt || "",
          PUBLISHED_HEAD: outputs["pr-upload"]?.published_head_sha || "",
          VERIFIED_PUBLISHED_HEAD: details.published_head || "",
          LEGACY_MARKER_AUTHOR: details.legacy_marker_author || "",
          RECOVERED_BOTTLE_COMMIT: details.recovered_bottle_commit || "",
          REPAIR_UPLOAD: options.eventName === "workflow_dispatch" ? "--warn-on-upload-failure" : "",
          GH_TOKEN: "fixture-token", BOT_TOKEN: "fixture-bot-token",
        },
      })
      const text = readFileSync(output, "utf8")
      const id = definition.match(/^        id: (.*)$/m)?.[1]
      if (id) outputs[id] = parseOutputs(text)
      return {...result, output: text}
    }
    const result = execute(run)
    const lines = file => readFileSync(join(directory, file), "utf8").trim().split("\n").filter(Boolean)
    return {...result, outputs, effects: lines("effects"), calls: lines("calls"), sleeps: lines("sleeps").map(Number)}
  } finally {
    rmSync(directory, {recursive: true, force: true})
  }
}

function validate(overrides = {}, options = {}) {
  return publicationFixture(overrides, options, run => run("Validate PR"))
}
function publish(overrides = {}, options = {}) {
  return publicationFixture(overrides, options, run => {
    let result
    for (const name of ["Validate PR", "Reconcile published bottle label", "Pull bottles", "Upload bottles",
      "Verify PR branch unchanged before push", "Push commits", "Verify pushed bottle commit",
      "Mark PR with published bottle commits", "Record published bottle head"]) {
      const next = run(name)
      if (next) result = next
      if (result.status !== 0) break
    }
    return result
  })
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

function assertNotPublished(result) {
  assert.notEqual(result.status, 0, result.stderr + result.stdout)
  assert.notEqual(result.outputs["pr-details"]?.publish, "true")
  assert.deepEqual(result.effects, [])
}
const bottleSourcePr = (overrides = {}) => ({
  ...prAt(headSha), merged_at: null, title: "example: update 1.0.0",
  user: {type: "User"}, labels: [{name: "pr-pull"}], ...overrides,
})

test("a qualified current source head reaches upload, push, label and status publication", () => {
  const result = publish(bottlePr)
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, ["pull", "upload", "push", "label", "status"])
})

for (const conclusion of ["failure", "cancelled", "timed_out", "neutral", "skipped"]) {
  test(`pr-pull cannot publish a source run whose conclusion is ${conclusion}`, () => {
    assertNotPublished(publish(bottlePr, {sourceRuns: [sourceRun({conclusion})]}))
  })
}

for (const [name, sourceRuns] of [
  ["no tests workflow", []],
  ["an older source SHA", [sourceRun({head_sha: sourceSha})]],
  ["another branch", [sourceRun({head_branch: "other"})]],
  ["a fork head", [sourceRun({head_repository: {full_name: "other/tap"}})]],
  ["another workflow repository", [sourceRun({repository: {full_name: "other/tap"}})]],
  ["a push event", [sourceRun({event: "push"})]],
  ["another workflow path", [sourceRun({path: ".github/workflows/cask-tests.yml"})]],
  ["a queued run", [sourceRun({status: "queued", conclusion: null})]],
  ["an older success before a newer failure", [
    sourceRun(), sourceRun({id: 43, created_at: "2026-11-08T01:00:00Z", conclusion: "failure"}),
  ]],
  ["a newer failed rerun attempt", [sourceRun({run_attempt: 2, conclusion: "failure"})]],
]) {
  test(`source qualification fails closed with ${name}`, () => {
    assertNotPublished(publish(bottlePr, {sourceRuns}))
  })
}

for (const [name, response] of [
  ["a missing run collection", [{total_count: 0}]],
  ["a truncated run page", [{total_count: 2, workflow_runs: [sourceRun()]}]],
  ["a duplicated run page", [{total_count: 2, workflow_runs: [sourceRun(), sourceRun()]}]],
  ["inconsistent run totals", [{total_count: 1, workflow_runs: [sourceRun()]}, {total_count: 2, workflow_runs: []}]],
  ["an API pagination failure", {_error: true}],
  ["malformed JSON", {_raw: '{"total_count":'}],
]) {
  test(`source qualification rejects ${name} before pulling or uploading`, () => {
    assertNotPublished(publish(bottlePr, {responses: {runs: [response]}}))
  })
}

test("the direct run API cannot hide a failed latest attempt behind a stale successful list entry", () => {
  assertNotPublished(publish(bottlePr, {responses: {
    "run:42": [sourceRun({run_attempt: 2, conclusion: "failure"})],
  }}))
})

for (const [name, artifacts] of [
  ["a real failed-bottles artifact beside successful bottles", [failedArtifact(), bottleArtifact()]],
  ["an expired failure artifact from the same attempt", [failedArtifact({expired: true}), bottleArtifact()]],
  ["an expired bottle artifact", [bottleArtifact({expired: true})]],
  ["an elapsed expiry date despite a stale expired=false flag", [bottleArtifact({expires_at: "2026-01-01T00:00:00Z"})]],
  ["a missing expiry date", [bottleArtifact({expires_at: undefined})]],
  ["ambiguous newest artifacts of one name", [bottleArtifact(), bottleArtifact({id: 105})]],
  ["missing bottle artifacts", []],
  ["logs only", [bottleArtifact({name: "logs_ubuntu-24.04"})]],
  ["a missing expiry flag", [bottleArtifact({expired: undefined})]],
  ["an empty partial artifact", [bottleArtifact({size_in_bytes: 0})]],
  ["an unparseable creation time", [bottleArtifact({created_at: null})]],
  ["another run's artifact", [bottleArtifact({workflow_run: {id: 41, head_sha: headSha, head_branch: "network-sandbox/example"}})]],
  ["another head's artifact", [bottleArtifact({workflow_run: {id: 42, head_sha: sourceSha, head_branch: "network-sandbox/example"}})]],
]) {
  test(`source qualification rejects ${name}`, () => {
    assertNotPublished(publish(bottlePr, {artifacts}))
  })
}

for (const [name, pages] of [
  ["a missing artifact collection", [{total_count: 0}]],
  ["a truncated artifact page", [{total_count: 2, artifacts: [bottleArtifact()]}]],
  ["a duplicate artifact ID", [{total_count: 2, artifacts: [bottleArtifact(), bottleArtifact()]}]],
  ["inconsistent artifact page totals", [{total_count: 1, artifacts: [bottleArtifact()]}, {total_count: 2, artifacts: []}]],
  ["a failed artifact API", {_error: true}],
]) {
  test(`source qualification rejects ${name}`, () => {
    assertNotPublished(publish(bottlePr, {responses: {"artifacts:42": [pages]}}))
  })
}

test("a failure on a later complete artifact page still blocks upload", () => {
  assertNotPublished(publish(bottlePr, {responses: {
    "artifacts:42": [[
      {total_count: 2, artifacts: [bottleArtifact()]},
      {total_count: 2, artifacts: [failedArtifact()]},
    ]],
  }}))
})

test("complete paginated source and bottle responses qualify the newest matching run", () => {
  const otherRun = sourceRun({id: 41, head_branch: "other"})
  const otherBottle = bottleArtifact({id: 102, name: "bottles_macos-15"})
  const result = publish(bottlePr, {responses: {
    runs: [[{total_count: 2, workflow_runs: [otherRun]}, {total_count: 2, workflow_runs: [sourceRun()]}]],
    "artifacts:42": [[{total_count: 2, artifacts: [bottleArtifact()]}, {total_count: 2, artifacts: [otherBottle]}]],
  }})
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, ["pull", "upload", "push", "label", "status"])
})

const rerun = (attempt = 2) => sourceRun({
  run_attempt: attempt, run_started_at: `2026-11-08T0${attempt - 1}:00:00Z`,
})
const rebuiltBottle = bottleArtifact({id: 103, created_at: "2026-11-08T01:03:00Z"})
const attemptData = {
  2: rerun(2),
  3: rerun(3),
}

test("a clean later rerun supersedes only its platform's older failed-bottles artifact", () => {
  const result = publish(bottlePr, {
    sourceRuns: [rerun()], attempts: attemptData,
    artifacts: [failedArtifact(), bottleArtifact(), rebuiltBottle,
      bottleArtifact({id: 104, name: "bottles_macos-15"})],
  })
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, ["pull", "upload", "push", "label", "status"])
})

test("a third label-only attempt preserves the second attempt's clean rebuild recovery", () => {
  const result = publish(bottlePr, {
    sourceRuns: [rerun(3)], attempts: attemptData,
    artifacts: [failedArtifact(), rebuiltBottle],
  })
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, ["pull", "upload", "push", "label", "status"])
})

for (const [name, artifacts] of [
  ["a label-only rerun that did not rebuild failed bottles", [failedArtifact(), bottleArtifact()]],
  ["a rebuild of a different platform", [failedArtifact(), bottleArtifact(),
    bottleArtifact({id: 104, name: "bottles_macos-15", created_at: "2026-11-08T01:03:00Z"})]],
  ["a fresh failure uploaded before that attempt's partial successful bottles", [
    failedArtifact({created_at: "2026-11-08T01:02:00Z"}), rebuiltBottle,
  ]],
]) {
  test(`an old failure is not cleared by ${name}`, () => {
    assertNotPublished(publish(bottlePr, {sourceRuns: [rerun()], attempts: attemptData, artifacts}))
  })
}

test("missing attempt metadata cannot turn an old failure into a clean rebuild", () => {
  assertNotPublished(publish(bottlePr, {sourceRuns: [rerun()], artifacts: [failedArtifact(), rebuiltBottle]}))
})

const reportingRun = sourceRun({status: "in_progress", conclusion: null})
const reportingJobs = [
  {id: 1, name: "tap-syntax", status: "completed", conclusion: "success"},
  {id: 2, name: "set-environment", status: "completed", conclusion: "success"},
  {id: 3, name: "build-formula (ubuntu-24.04)", status: "completed", conclusion: "success"},
  {id: 4, name: "formula-conclusion", status: "completed", conclusion: "success"},
  {id: 5, name: "label-pr", status: "in_progress", conclusion: null},
].map(job => ({run_id: 42, run_attempt: 1, ...job}))

test("fresh pr-pull waits for label-pr terminal reporting, then revalidates and publishes", () => {
  const result = publish(bottlePr, {jobs: reportingJobs, responses: {
    runs: [runPages([reportingRun]), runPages([reportingRun]), runPages([sourceRun()])],
    "run:42": [reportingRun, reportingRun, sourceRun()],
  }})
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, ["pull", "upload", "push", "label", "status"])
})

test("a queued formula conclusion can finish after label admission before publication", () => {
  const jobs = reportingJobs.map(job => job.name === "formula-conclusion"
    ? {...job, status: "queued", conclusion: null}
    : job)
  const result = publish(bottlePr, {jobs, responses: {
    runs: [runPages([reportingRun]), runPages([reportingRun]), runPages([sourceRun()])],
    "run:42": [reportingRun, reportingRun, sourceRun()],
  }})
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, ["pull", "upload", "push", "label", "status"])
})

test("an in-progress label-only rerun inherits successful builds without inheriting the old label failure", () => {
  const active = sourceRun({run_attempt: 2, status: "in_progress", conclusion: null})
  const complete = sourceRun({run_attempt: 2})
  const jobs = [
    ...reportingJobs.map(job => job.name === "label-pr"
      ? {...job, status: "completed", conclusion: "failure"}
      : job),
    {...reportingJobs[4], id: 6, run_attempt: 2},
  ]
  const result = publish(bottlePr, {jobs, responses: {
    runs: [runPages([active]), runPages([complete])],
    "run:42": [active, complete],
  }})
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, ["pull", "upload", "push", "label", "status"])
})

test("a newer failed rebuild cannot inherit an earlier successful matrix result", () => {
  const active = sourceRun({run_attempt: 2, status: "in_progress", conclusion: null})
  const jobs = [
    ...reportingJobs.map(job => job.name === "label-pr"
      ? {...job, status: "completed", conclusion: "success"}
      : job),
    {...reportingJobs[2], id: 6, run_attempt: 2, conclusion: "failure"},
    {...reportingJobs[4], id: 7, run_attempt: 2},
  ]
  assertNotPublished(publish(bottlePr, {sourceRuns: [active], jobs}))
})

test("waiting for label-pr is bounded and never publishes a run that stays active", () => {
  const result = publish(bottlePr, {sourceRuns: [reportingRun], jobs: reportingJobs})
  assertNotPublished(result)
  assert.equal(result.status, 1, result.stderr + result.stdout)
})

for (const [name, jobs] of [
  ["an unfinished matrix", reportingJobs.map(job => job.id === 3 ? {...job, status: "in_progress", conclusion: null} : job)],
  ["a queued matrix", reportingJobs.map(job => job.id === 3 ? {...job, status: "queued", conclusion: null} : job)],
  ["a failed matrix", reportingJobs.map(job => job.id === 3 ? {...job, conclusion: "failure"} : job)],
  ["a failed label-pr job", reportingJobs.map(job => job.id === 5 ? {...job, status: "completed", conclusion: "failure"} : job)],
  ["a skipped label-pr job", reportingJobs.map(job => job.id === 5 ? {...job, status: "completed", conclusion: "skipped"} : job)],
]) {
  test(`the label transition wait cannot admit ${name}`, () => {
    const result = publish(bottlePr, {sourceRuns: [reportingRun], jobs})
    assertNotPublished(result)
    assert.deepEqual(result.sleeps, [])
  })
}

test("a partial latest-jobs response is not evidence of a label-pr-only transition", () => {
  const result = publish(bottlePr, {sourceRuns: [reportingRun], responses: {
    "jobs:42": [[{total_count: 6, jobs: reportingJobs}]],
  }})
  assertNotPublished(result)
  assert.deepEqual(result.sleeps, [])
})

test("a changed source head during the label-pr wait fails closed", () => {
  assertNotPublished(publish(bottlePr, {sourceRuns: [reportingRun], jobs: reportingJobs, responses: {
    pr: [bottleSourcePr(), bottleSourcePr({head: {...prAt(sourceSha).head}})],
  }}))
})

test("a hold added during the label-pr wait is a successful no-op", () => {
  const result = publish(bottlePr, {sourceRuns: [reportingRun], jobs: reportingJobs, responses: {
    pr: [bottleSourcePr(), bottleSourcePr({labels: [{name: "pr-pull"}, {name: "in progress"}]})],
  }})
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.equal(result.outputs["pr-details"].held, "true")
  assert.deepEqual(result.effects, [])
})

for (const eventName of ["pull_request_target", "workflow_dispatch"]) {
  test(`${eventName} respects an existing hold without reconciling or publishing`, () => {
    const result = publish({labels: [{name: "pr-pull"}, {name: "in progress"}]}, {
      eventName, statuses: {[headSha]: [publishedStatus()]},
    })
    assert.equal(result.status, 0, result.stderr + result.stdout)
    assert.equal(result.outputs["pr-details"].held, "true")
    assert.deepEqual(result.effects, [])
    assert.deepEqual(result.calls, ["pr"])
  })
}

test("a hold added after validation prevents bottle upload and all later mutations", () => {
  const result = publish(bottlePr, {responses: {
    pr: [bottleSourcePr(), bottleSourcePr({labels: [{name: "pr-pull"}, {name: "in progress"}]})],
  }})
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, ["pull"])
})

test("a hold added after upload prevents push, publication labels and published-head status", () => {
  const result = publish(bottlePr, {responses: {
    pr: [bottleSourcePr(), bottleSourcePr(), bottleSourcePr({labels: [{name: "pr-pull"}, {name: "in progress"}]})],
  }})
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, ["pull", "upload"])
})

for (const [name, changed] of [
  ["a changed source head", bottleSourcePr({head: prAt(sourceSha).head})],
  ["a closed PR", bottleSourcePr({state: "closed"})],
  ["a draft PR", bottleSourcePr({draft: true})],
  ["a changed base", bottleSourcePr({base: {ref: "other"}})],
  ["removed pr-pull admission", bottleSourcePr({labels: []})],
]) {
  for (const phase of ["before upload", "before push"]) {
    test(`${name} ${phase} blocks the next publication side effect`, () => {
      const prs = phase === "before upload" ? [bottleSourcePr(), changed] : [bottleSourcePr(), bottleSourcePr(), changed]
      const result = publish(bottlePr, {responses: {pr: prs}})
      assert.notEqual(result.status, 0, result.stderr + result.stdout)
      assert.deepEqual(result.effects, phase === "before upload" ? ["pull"] : ["pull", "upload"])
    })
  }
}

for (const [name, changed] of [
  ["a new run", sourceRun({id: 43, created_at: "2026-11-08T01:00:00Z"})],
  ["a new rerun attempt", sourceRun({run_attempt: 2})],
  ["a failed latest run", sourceRun({conclusion: "failure"})],
]) {
  test(`${name} after validation cannot upload the earlier artifacts`, () => {
    const result = publish(bottlePr, {responses: {runs: [runPages([sourceRun()]), runPages([changed])]}})
    assert.notEqual(result.status, 0, result.stderr + result.stdout)
    assert.deepEqual(result.effects, ["pull"])
  })
}

test("a rerun appearing in direct run metadata just before upload also blocks publication", () => {
  const result = publish(bottlePr, {responses: {"run:42": [sourceRun(), sourceRun({run_attempt: 2})]}})
  assert.notEqual(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, ["pull"])
})

test("a branch ref that disagrees with the source head prevents upload", () => {
  const result = publish(bottlePr, {branchHead: sourceSha})
  assert.notEqual(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, ["pull"])
})

test("a hold added to an already-published head prevents reconciliation mutations", () => {
  const result = publish(bottlePr, {statuses: {[headSha]: [publishedStatus()]}, responses: {
    pr: [bottleSourcePr(), bottleSourcePr({labels: [{name: "pr-pull"}, {name: "in progress"}]})],
  }})
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, [])
})

test("manual source publication still requires the current pr-pull admission label", () => {
  assertNotPublished(publish({labels: []}, {eventName: "workflow_dispatch"}))
})

test("an open fork cannot enter trusted source qualification or publication", () => {
  assertNotPublished(publish({head: {...prAt(headSha).head, repo: {full_name: "other/tap"}}, ...bottlePr}))
})

test("no-bottles publication remains a no-op without source qualification", () => {
  const result = publish()
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, [])
  assert.deepEqual(result.calls, ["pr"])
})

test("a newer non-PR workflow cannot supply partial artifacts behind an older green PR run", () => {
  assertNotPublished(publish(bottlePr, {sourceRuns: [
    sourceRun(), sourceRun({id: 43, event: "workflow_dispatch", created_at: "2026-11-08T01:00:00Z"}),
  ]}))
})

test("a partial newer run record cannot be silently skipped in favor of an older success", () => {
  assertNotPublished(publish(bottlePr, {sourceRuns: [
    sourceRun(), sourceRun({id: 43, created_at: undefined}),
  ]}))
})

test("a later clean rebuild can recover an expired failure artifact without trusting expired bottles", () => {
  const result = publish(bottlePr, {
    sourceRuns: [rerun()], attempts: attemptData,
    artifacts: [failedArtifact({expired: true, expires_at: "2026-01-01T00:00:00Z"}), rebuiltBottle],
  })
  assert.equal(result.status, 0, result.stderr + result.stdout)
  assert.deepEqual(result.effects, ["pull", "upload", "push", "label", "status"])
})

for (const [name, response] of [
  ["another run selected by Homebrew's check-suite ordering", consumerResponse({runId: 41})],
  ["a truncated first-100 check-suite connection", consumerResponse({suites: {
    totalCount: 101, pageInfo: {hasNextPage: true},
    nodes: [{status: "COMPLETED", workflowRun: {databaseId: 42, workflow: {databaseId: 123}}}],
  }})],
  ["an incomplete check-suite node list", consumerResponse({suites: {
    totalCount: 2, pageInfo: {hasNextPage: false},
    nodes: [{status: "COMPLETED", workflowRun: {databaseId: 42, workflow: {databaseId: 123}}}],
  }})],
  ["a different PR source head", consumerResponse({sha: sourceSha})],
  ["a different tests workflow ID", consumerResponse({workflowId: 124})],
  ["an active consumer check suite", consumerResponse({suites: {
    totalCount: 1, pageInfo: {hasNextPage: false},
    nodes: [{status: "IN_PROGRESS", workflowRun: {databaseId: 42, workflow: {databaseId: 123}}}],
  }})],
  ["partial GraphQL data with errors", {...consumerResponse(), errors: [{message: "partial result"}]}],
  ["an unavailable GraphQL API", {_error: true}],
]) {
  test(`${name} prevents upload even when REST qualification succeeded`, () => {
    const result = publish(bottlePr, {responses: {consumer: [response]}})
    assert.notEqual(result.status, 0, result.stderr + result.stdout)
    assert.deepEqual(result.effects, ["pull"])
  })
}
