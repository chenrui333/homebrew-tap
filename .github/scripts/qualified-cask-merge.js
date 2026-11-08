const { aggregateCheckRuns, latestCheckRun } = require("./merge-gate")

const REQUIRED_CHECKS = ["cask-conclusion", "Spell Check"]
const SIDECARS = new Set([".typos.toml", "audit_exceptions/signing_audit_skiplist.json"])

function eligible(pr, repository, expectedHead) {
  const labels = pr.labels.map(label => label.name)
  return pr.state === "open" && !pr.draft && pr.base.ref === "main" &&
    pr.head.repo?.full_name === repository && pr.head.sha === expectedHead &&
    pr.user?.type === "User" && labels.includes("pr-cask-merge") && !labels.includes("in progress")
}

function caskOnly(files) {
  return files.filter(file => /^Casks\/.+\.rb$/.test(file)).length === 1 &&
    files.every(file => /^Casks\/.+\.rb$/.test(file) || SIDECARS.has(file))
}

function readiness(checkRuns, statuses) {
  // Triage's target event emits a skipped duplicate, not a PR spellcheck verdict.
  const requiredRuns = checkRuns.filter(check => !(check.name === "Spell Check" && check.conclusion === "skipped"))
  const required = aggregateCheckRuns(requiredRuns, REQUIRED_CHECKS)
  if (required.state === "failed") return "failed"
  let pending = required.state !== "ready"
  for (const name of new Set(checkRuns.map(check => check.name))) {
    if (name === "cask-merge") continue
    const check = latestCheckRun(checkRuns, name)
    if (check.status !== "completed") pending = true
    else if (!["success", "skipped", "neutral"].includes(check.conclusion)) return "failed"
  }
  for (const status of statuses) {
    if (["failure", "error"].includes(status.state)) return "failed"
    if (status.state === "pending") pending = true
    else if (status.state !== "success") return "failed"
  }
  return pending ? "waiting" : "ready"
}

async function mergeQualifiedCask({
  github, context, core,
  intervalMs = 30_000,
  timeoutMs = 240 * 60 * 1_000,
  now = Date.now,
  sleep = milliseconds => new Promise(resolve => setTimeout(resolve, milliseconds)),
}) {
  const { owner, repo } = context.repo
  let pull_number = context.payload.pull_request?.number
  let expectedHead = context.payload.pull_request?.head.sha
  const run = context.payload.workflow_run
  if (run) {
    if (run.event !== "pull_request" || run.conclusion !== "success") return
    const candidates = await github.paginate(github.rest.pulls.list, {
      owner, repo, state: "open", base: "main", head: `${owner}:${run.head_branch}`, per_page: 100,
    })
    const matchingPr = candidates.find(pr => pr.head.sha === run.head_sha)
    if (!matchingPr) {
      core.info("Completed checks no longer match an open PR head")
      return
    }
    pull_number = matchingPr.number
    expectedHead = run.head_sha
  } else if (context.eventName === "workflow_dispatch") {
    pull_number = Number(context.payload.inputs.pr_number)
    const { data: pr } = await github.rest.pulls.get({ owner, repo, pull_number })
    expectedHead = pr.head.sha
  }
  const repository = `${owner}/${repo}`
  const params = { owner, repo, pull_number }
  const deadline = now() + timeoutMs
  const changedFiles = async () => (await github.paginate(github.rest.pulls.listFiles, {
    ...params, per_page: 100,
  })).map(file => file.filename)

  let mergeRaceRetries = 0
  while (true) {
    const { data: pr } = await github.rest.pulls.get(params)
    if (!eligible(pr, repository, expectedHead)) {
      core.info("Cask PR changed, is held, or is not eligible; leaving it unmerged")
      return
    }
    if (!caskOnly(await changedFiles())) {
      core.setFailed("Cask merge requires exactly one cask and only supported cask-maintenance sidecars")
      return
    }
    const checkRuns = await github.paginate(github.rest.checks.listForRef, {
      owner, repo, ref: expectedHead, per_page: 100,
    })
    const { data: combined } = await github.rest.repos.getCombinedStatusForRef({ owner, repo, ref: expectedHead })
    const state = readiness(checkRuns, combined.statuses)
    if (state === "failed") {
      core.setFailed("Current-head checks failed; leaving the cask PR unmerged")
      return
    }
    if (state === "waiting") {
      if (now() >= deadline) {
        core.setFailed("Timed out waiting for current-head cask checks")
        return
      }
      await sleep(intervalMs)
      continue
    }

    // No native auto-merge request: required checks are enforced even without branch-protection rules.
    const { data: finalPr } = await github.rest.pulls.get(params)
    if (!eligible(finalPr, repository, expectedHead) || !caskOnly(await changedFiles())) {
      core.info("Cask PR changed after qualification; leaving it unmerged")
      return
    }
    try {
      const { data: result } = await github.rest.pulls.merge({ ...params, sha: expectedHead, merge_method: "merge" })
      if (!result.merged) core.setFailed("GitHub did not merge the qualified cask head")
      else core.info(`Merged qualified cask PR #${pull_number} at ${expectedHead}`)
      return
    } catch (error) {
      if (error.status !== 405 || !String(error.message).includes("Base branch was modified") || mergeRaceRetries >= 2) {
        throw error
      }
      mergeRaceRetries++
      core.info("Base changed during merge; requalifying the current head before retry")
      await sleep(intervalMs)
    }
  }
}

module.exports = { mergeQualifiedCask }
