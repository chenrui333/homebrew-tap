const assert = require("node:assert/strict")
const test = require("node:test")

const environment = require("./environment.js")

const repository = "chenrui333/homebrew-tap"

async function runEnvironment({
  formulaFile,
  eventName = "pull_request",
  formulaDetect = {},
  labels = [],
  headSha = "a".repeat(40),
  publishedBottleHead = null,
}) {
  const outputs = new Map()
  const apiCalls = []
  const listComments = async () => {
    apiCalls.push("issues.listComments")
    return publishedBottleHead
      ? [{user: {login: "github-actions[bot]"}, body: `<!-- homebrew-tap: published-bottle-head ${publishedBottleHead} -->`}]
      : []
  }
  const github = {
    rest: {
      pulls: {
        get: async () => {
          apiCalls.push("pulls.get")
          return {data: {labels: labels.map((name) => ({name}))}}
        },
        listFiles: async () => {
          apiCalls.push("pulls.listFiles")
          return {data: [{filename: formulaFile}]}
        },
      },
      issues: {listComments},
    },
    paginate: async (method) => {
      if (method === listComments) return listComments()
      apiCalls.push("paginate")
      return [{filename: formulaFile}]
    },
  }
  const context = {
    eventName,
    issue: {number: 1},
    repo: {owner: repository.split("/")[0], repo: repository.split("/")[1]},
    payload: {pull_request: {head: {sha: headSha}}},
  }
  const core = {
    setOutput: (name, value) => outputs.set(name, value),
  }

  await environment({github, context, core}, formulaDetect)
  return {outputs, apiCalls}
}

async function buildMatrix(formulaFile, eventName = "pull_request") {
  const {outputs} = await runEnvironment({formulaFile, eventName})
  return JSON.parse(outputs.get("build-matrix")).map(({runner}) => runner)
}

test("generates the supported cross-platform formula matrix", async () => {
  assert.deepEqual(await buildMatrix("Formula/w/watchfiles.rb"), [
    "macos-26",
    "macos-15",
    "ubuntu-24.04",
    "ubuntu-24.04-arm",
  ])
})

test("generates the supported macOS-only formula matrix", async () => {
  assert.deepEqual(await buildMatrix("Formula/c/ctxmv.rb"), [
    "macos-26",
    "macos-15",
  ])
})

test("generates the supported Linux-only formula matrix", async () => {
  assert.deepEqual(await buildMatrix("Formula/w/wild.rb"), [
    "ubuntu-24.04",
    "ubuntu-24.04-arm",
  ])
})

test("does not generate obsolete formula macOS runners", async () => {
  const matrices = await Promise.all([
    buildMatrix("Formula/w/watchfiles.rb"),
    buildMatrix("Formula/c/ctxmv.rb"),
    buildMatrix("Formula/w/wild.rb"),
  ])
  const runners = matrices.flat()

  assert.equal(runners.includes("macos-14"), false)
  assert.equal(runners.includes("macos-15-intel"), false)
})

test("merge_group avoids PR APIs and uses the full supported formula matrix", async () => {
  const {outputs, apiCalls} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
    eventName: "merge_group",
    formulaDetect: {
      testing_formulae: "watchfiles",
      added_formulae: "",
      deleted_formulae: "",
    },
  })

  assert.deepEqual(apiCalls, [])
  assert.deepEqual(JSON.parse(outputs.get("build-matrix")).map(({runner}) => runner), [
    "macos-26",
    "macos-15",
    "ubuntu-24.04",
    "ubuntu-24.04-arm",
  ])
  assert.match(outputs.get("test-bot-formulae-args"), /--testing-formulae=watchfiles/)
})

test("push keeps the non-PR full formula matrix behavior", async () => {
  const {outputs, apiCalls} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
    eventName: "push",
  })

  assert.deepEqual(apiCalls, [])
  assert.deepEqual(JSON.parse(outputs.get("build-matrix")).map(({runner}) => runner), [
    "macos-26",
    "macos-15",
    "ubuntu-24.04",
    "ubuntu-24.04-arm",
  ])
})

test("published bottle commits make a pull request syntax-only", async () => {
  const headSha = "a".repeat(40)
  const {outputs, apiCalls} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
    labels: ["CI-published-bottle-commits"],
    headSha,
    publishedBottleHead: headSha,
  })

  assert.equal(outputs.get("syntax-only"), "true")
  assert.equal(apiCalls.includes("issues.listComments"), true)
})

test("stale published bottle commits do not skip a newer pull request head", async () => {
  const {outputs} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
    labels: ["CI-published-bottle-commits"],
    headSha: "b".repeat(40),
    publishedBottleHead: "a".repeat(40),
  })

  assert.equal(outputs.get("syntax-only"), "false")
})

test("ordinary pull requests still run the formula build path", async () => {
  const {outputs} = await runEnvironment({
    formulaFile: "Formula/w/watchfiles.rb",
  })

  assert.equal(outputs.get("syntax-only"), "false")
})
