const assert = require("node:assert/strict")
const test = require("node:test")

const {
  requiredCheckState,
  validateFilePatch,
  validatePullRequest,
} = require("./renovate-workflow-automerge.js")

const repository = "chenrui333/homebrew-tap"

function pullRequest(overrides = {}) {
  return {
    base: { ref: "main" },
    changed_files: 1,
    commits: 1,
    draft: false,
    head: { ref: "renovate/example", repo: { full_name: repository } },
    labels: [
      { name: "CI-syntax-only" },
      { name: "dependencies" },
      { name: "renovate" },
    ],
    state: "open",
    user: { login: "renovate[bot]" },
    ...overrides,
  }
}

const actionFile = {
  additions: 1,
  deletions: 1,
  filename: ".github/workflows/formula-status.yml",
  patch: `@@ -30,1 +30,1 @@
-        uses: Homebrew/actions/setup-homebrew@18fcb8e3e06b4247c676c506750dc95ea7226479 # main
+        uses: Homebrew/actions/setup-homebrew@100978dc923ea73ee9ed454d1d5c4fcf3ee14a9e # main`,
  status: "modified",
}

const imageFile = {
  additions: 1,
  deletions: 1,
  filename: ".github/workflows/tests.yml",
  patch: `@@ -31,1 +31,1 @@
-      image: ghcr.io/homebrew/ubuntu24.04:main@sha256:465a154c8c0ead8af138f9e1f1cd525b6ef59c4869f74ef9efbd9c22d7bf2859
+      image: ghcr.io/homebrew/ubuntu24.04:main@sha256:92595ffa835f692f3f6fdd3106b5d9ceb97ca321d53086bb32d6de290153a680`,
  status: "modified",
}

test("accepts Renovate action commit and container digest updates", () => {
  assert.deepEqual(validateFilePatch(actionFile), { eligible: true })
  assert.deepEqual(validateFilePatch(imageFile), { eligible: true })

  const files = [actionFile, imageFile]
  assert.deepEqual(validatePullRequest(pullRequest({ changed_files: 2 }), files, repository), {
    eligible: true,
  })
})

test("rejects workflow edits beyond the immutable pin", () => {
  const file = {
    ...actionFile,
    additions: 2,
    deletions: 2,
    patch: `${actionFile.patch}\n+      persist-credentials: true\n-      persist-credentials: false`,
  }
  assert.match(validateFilePatch(file).reason, /changes more than action or image pins/)
  assert.match(validateFilePatch({ ...actionFile, additions: 2 }).reason, /truncated patch/)
})

test("rejects changed pin context and files outside workflows", () => {
  const changedComment = {
    ...actionFile,
    patch: actionFile.patch.replace(
      "100978dc923ea73ee9ed454d1d5c4fcf3ee14a9e # main",
      "100978dc923ea73ee9ed454d1d5c4fcf3ee14a9e # v4",
    ),
  }
  assert.equal(validateFilePatch(changedComment).eligible, false)
  assert.equal(validateFilePatch({ ...actionFile, filename: "mise.toml" }).eligible, false)
})

test("rejects forks, non-Renovate authors, missing labels, and blocking labels", () => {
  assert.equal(
    validatePullRequest(
      pullRequest({ head: { ref: "renovate/example", repo: { full_name: "fork/homebrew-tap" } } }),
      [actionFile],
      repository,
    ).eligible,
    false,
  )
  assert.equal(
    validatePullRequest(pullRequest({ user: { login: "contributor" } }), [actionFile], repository).eligible,
    false,
  )
  assert.equal(
    validatePullRequest(pullRequest({ labels: [{ name: "renovate" }] }), [actionFile], repository).eligible,
    false,
  )
  assert.equal(
    validatePullRequest(
      pullRequest({ labels: [...pullRequest().labels, { name: "automerge-skip" }] }),
      [actionFile],
      repository,
    ).eligible,
    false,
  )
})

test("requires successful Spell Check and GitGuardian runs", () => {
  const ready = [
    { conclusion: "success", name: "Spell Check", status: "completed" },
    { conclusion: "skipped", name: "Spell Check", status: "completed" },
    { conclusion: "success", name: "GitGuardian Security Checks", status: "completed" },
  ]
  assert.deepEqual(requiredCheckState(ready), { state: "ready" })
  assert.deepEqual(requiredCheckState([undefined, ...ready]), { state: "ready" })
  assert.equal(requiredCheckState(ready.slice(0, 2)).state, "pending")
  assert.equal(
    requiredCheckState([
      ...ready.slice(0, 2),
      { conclusion: "failure", name: "GitGuardian Security Checks", status: "completed" },
    ]).state,
    "failed",
  )
})

test("merge runs after optional cleanup skips while retaining its trust gates", () => {
  const fs = require("node:fs")
  const path = require("node:path")
  const vm = require("node:vm")
  const workflow = fs.readFileSync(path.join(__dirname, "../workflows/renovate-workflow-automerge.yml"), "utf8")
  const condition = workflow.match(/\n  merge:\n[\s\S]*?\n    if: >-\n([\s\S]*?)\n    runs-on:/)[1]
    .trim().replace(/needs\.([\w-]+)/g, 'needs["$1"]')
  const shouldRun = (cleanup, overrides = {}, cancelled = false) => {
    const needs = {
      classify: { result: "success", outputs: { eligible: "true" } },
      actionlint: { result: "success" },
      "cancel-stale-auto-merge": { result: cleanup },
      ...overrides,
    }
    // Actions adds success() unless the condition includes a status function.
    const implicitSuccess = /\b(always|cancelled|failure|success)\s*\(/.test(condition)
      || Object.values(needs).every(({ result }) => result === "success")
    return implicitSuccess && vm.runInNewContext(condition, { needs, cancelled: () => cancelled })
  }
  assert.equal(shouldRun("skipped"), true)
  assert.equal(shouldRun("success"), true)
  for (const result of ["failure", "cancelled"]) {
    assert.equal(shouldRun(result), false)
    assert.equal(shouldRun("skipped", { actionlint: { result } }), false)
    assert.equal(shouldRun("skipped", { classify: { result, outputs: { eligible: "true" } } }), false)
  }
  assert.equal(shouldRun("skipped", { classify: { result: "success", outputs: { eligible: "false" } } }), false)
  assert.equal(shouldRun("skipped", {}, true), false)
})
