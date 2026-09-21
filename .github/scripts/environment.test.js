const assert = require("node:assert/strict")
const test = require("node:test")

const environment = require("./environment.js")

const repository = "chenrui333/homebrew-tap"

async function buildMatrix(formulaFile) {
  const outputs = new Map()
  const github = {
    rest: {
      pulls: {
        get: async () => ({data: {labels: []}}),
        listFiles: async () => ({data: [{filename: formulaFile}]}),
      },
    },
    paginate: async () => [{filename: formulaFile}],
  }
  const context = {
    eventName: "pull_request",
    issue: {number: 1},
    repo: {owner: repository.split("/")[0], repo: repository.split("/")[1]},
  }
  const core = {
    setOutput: (name, value) => outputs.set(name, value),
  }

  await environment({github, context, core}, {})
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
