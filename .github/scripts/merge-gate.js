const FORMULA_CHECK = "formula-conclusion"
const CASK_CHECK = "cask-conclusion"
const POLL_INTERVAL_MS = 30_000
const POLL_TIMEOUT_MS = 4_320 * 60 * 1_000

function classifyChangedFiles(files) {
  const formula = files.some((filename) =>
    filename.startsWith("Formula/") ||
    [
      ".github/workflows/tests.yml",
      ".github/scripts/environment.js",
      ".github/scripts/environment.test.js",
    ].includes(filename),
  )
  const cask = files.some((filename) =>
    filename.startsWith("Casks/") ||
    [".github/workflows/cask-tests.yml"].includes(filename),
  )

  return {formula, cask}
}

async function changedFiles({github, context}) {
  return github.paginate(github.rest.pulls.listFiles, {
    owner: context.repo.owner,
    repo: context.repo.repo,
    pull_number: context.issue.number,
    per_page: 100,
  }).then((files) => files.map(({filename}) => filename))
}

async function determineRequirements({github, context}) {
  if (context.eventName === "merge_group") {
    return {
      expectedChecks: [FORMULA_CHECK, CASK_CHECK],
      actionlint: true,
      changedFiles: [],
    }
  }

  if (context.eventName !== "pull_request") {
    return {expectedChecks: [], actionlint: false, changedFiles: []}
  }

  const files = await changedFiles({github, context})
  const {formula, cask} = classifyChangedFiles(files)
  return {
    expectedChecks: [
      ...(formula ? [FORMULA_CHECK] : []),
      ...(cask ? [CASK_CHECK] : []),
    ],
    actionlint: files.some((filename) => filename.startsWith(".github/workflows/")),
    changedFiles: files,
  }
}

function checkRunOrder(run) {
  const id = Number(run.id || 0)
  const attempt = Number(run.run_attempt || 0)
  const started = Date.parse(run.started_at || run.created_at || 0) || 0
  return [id, attempt, started]
}

function isNewerRun(candidate, current) {
  const candidateOrder = checkRunOrder(candidate)
  const currentOrder = checkRunOrder(current)
  for (let index = 0; index < candidateOrder.length; index += 1) {
    if (candidateOrder[index] !== currentOrder[index]) {
      return candidateOrder[index] > currentOrder[index]
    }
  }
  return false
}

function latestCheckRun(checkRuns, name) {
  return checkRuns
    .filter((checkRun) => checkRun.name === name)
    .reduce((latest, checkRun) => !latest || isNewerRun(checkRun, latest) ? checkRun : latest, null)
}

function checkRunState(checkRun) {
  if (!checkRun) return "missing"
  if (checkRun.status !== "completed") return "pending"
  return checkRun.conclusion === "success" ? "success" : "failure"
}

function aggregateCheckRuns(checkRuns, expectedChecks) {
  const checks = Object.fromEntries(expectedChecks.map((name) => {
    const run = latestCheckRun(checkRuns, name)
    return [name, {
      state: checkRunState(run),
      id: run?.id ?? null,
      conclusion: run?.conclusion ?? null,
      status: run?.status ?? null,
    }]
  }))
  const states = Object.values(checks).map(({state}) => state)
  const state = states.includes("failure")
    ? "failed"
    : states.every((checkState) => checkState === "success")
      ? "ready"
      : "waiting"
  return {state, checks}
}

function delay(milliseconds) {
  return new Promise((resolve) => setTimeout(resolve, milliseconds))
}

async function pollCheckRuns({
  github,
  context,
  expectedChecks,
  sha = context.sha,
  intervalMs = POLL_INTERVAL_MS,
  timeoutMs = POLL_TIMEOUT_MS,
  sleep = delay,
}) {
  const deadline = Date.now() + timeoutMs
  while (true) {
    const response = await github.rest.checks.listForRef({
      owner: context.repo.owner,
      repo: context.repo.repo,
      ref: sha,
      per_page: 100,
    })
    const result = aggregateCheckRuns(response.data.check_runs, expectedChecks)
    if (result.state !== "waiting") return result
    if (Date.now() >= deadline) return {...result, state: "failed", timedOut: true}
    await sleep(intervalMs)
  }
}

module.exports = {
  CASK_CHECK,
  FORMULA_CHECK,
  aggregateCheckRuns,
  classifyChangedFiles,
  determineRequirements,
  latestCheckRun,
  pollCheckRuns,
}
