const REQUIRED_LABELS = ["CI-syntax-only", "dependencies", "renovate"]
const BLOCKING_LABELS = [
  "audit failure",
  "automerge-skip",
  "blocked",
  "build failure",
  "in progress",
  "test failure",
]
const REQUIRED_CHECKS = ["GitGuardian Security Checks", "Spell Check"]
const FAILURE_CONCLUSIONS = new Set([
  "action_required",
  "cancelled",
  "failure",
  "stale",
  "startup_failure",
  "timed_out",
])

function normalizePinLine(line) {
  const action = line.match(/^(\s*(?:-\s*)?uses:\s*[^\s@]+@)[0-9a-f]{40}(\s*(?:#.*)?)$/i)
  if (action) return `${action[1]}<commit>${action[2]}`

  const image = line.match(/^(\s*image:\s*\S+@sha256:)[0-9a-f]{64}(\s*(?:#.*)?)$/i)
  if (image) return `${image[1]}<digest>${image[2]}`

  return null
}

function changedLines(patch) {
  const additions = []
  const deletions = []

  for (const line of patch.split("\n")) {
    if (line.startsWith("+++ ") || line.startsWith("--- ")) continue
    if (line.startsWith("+")) additions.push(line.slice(1))
    if (line.startsWith("-")) deletions.push(line.slice(1))
  }

  return { additions, deletions }
}

function validateFilePatch(file) {
  if (file.status !== "modified") {
    return { eligible: false, reason: `${file.filename} is not a modified file` }
  }
  if (!/^\.github\/workflows\/[^/]+\.ya?ml$/.test(file.filename)) {
    return { eligible: false, reason: `${file.filename} is outside .github/workflows` }
  }
  if (typeof file.patch !== "string" || file.patch.length === 0) {
    return { eligible: false, reason: `${file.filename} has no complete patch` }
  }

  const { additions, deletions } = changedLines(file.patch)
  if (file.additions !== additions.length || file.deletions !== deletions.length) {
    return { eligible: false, reason: `${file.filename} has a truncated patch` }
  }
  if (additions.length === 0 || additions.length !== deletions.length) {
    return { eligible: false, reason: `${file.filename} is not a one-for-one pin update` }
  }

  const normalizedAdditions = additions.map(normalizePinLine)
  const normalizedDeletions = deletions.map(normalizePinLine)
  if (normalizedAdditions.includes(null) || normalizedDeletions.includes(null)) {
    return { eligible: false, reason: `${file.filename} changes more than action or image pins` }
  }

  normalizedAdditions.sort()
  normalizedDeletions.sort()
  if (JSON.stringify(normalizedAdditions) !== JSON.stringify(normalizedDeletions)) {
    return { eligible: false, reason: `${file.filename} changes pin context, tags, or comments` }
  }

  return { eligible: true }
}

function validatePullRequest(pr, files, repository) {
  if (pr.state !== "open") return { eligible: false, reason: "pull request is not open" }
  if (pr.draft) return { eligible: false, reason: "pull request is a draft" }
  if (pr.user?.login !== "renovate[bot]") {
    return { eligible: false, reason: "pull request author is not renovate[bot]" }
  }
  if (pr.base?.ref !== "main") return { eligible: false, reason: "base branch is not main" }
  if (pr.head?.repo?.full_name !== repository) {
    return { eligible: false, reason: "pull request head is not in this repository" }
  }
  if (!pr.head?.ref?.startsWith("renovate/")) {
    return { eligible: false, reason: "head branch is not a Renovate branch" }
  }
  if (pr.commits !== 1) return { eligible: false, reason: "pull request does not have exactly one commit" }
  if (pr.changed_files !== files.length || files.length === 0) {
    return { eligible: false, reason: "changed-file metadata is incomplete" }
  }

  const labels = new Set((pr.labels || []).map((label) => label.name))
  const missingLabel = REQUIRED_LABELS.find((label) => !labels.has(label))
  if (missingLabel) return { eligible: false, reason: `missing ${missingLabel} label` }

  const blockingLabel = BLOCKING_LABELS.find((label) => labels.has(label))
  if (blockingLabel) return { eligible: false, reason: `blocked by ${blockingLabel} label` }

  for (const file of files) {
    const result = validateFilePatch(file)
    if (!result.eligible) return result
  }

  return { eligible: true }
}

function requiredCheckState(checkRuns) {
  for (const name of REQUIRED_CHECKS) {
    const matches = checkRuns.filter((check) => check.name === name)
    if (matches.length === 0) return { state: "pending", reason: `${name} has not reported` }
    if (matches.some((check) => check.status !== "completed")) {
      return { state: "pending", reason: `${name} is still running` }
    }

    const failure = matches.find((check) => FAILURE_CONCLUSIONS.has(check.conclusion))
    if (failure) return { state: "failed", reason: `${name} concluded ${failure.conclusion}` }
    if (!matches.some((check) => check.conclusion === "success")) {
      return { state: "pending", reason: `${name} has no successful run` }
    }
  }

  return { state: "ready" }
}

module.exports = {
  BLOCKING_LABELS,
  REQUIRED_CHECKS,
  REQUIRED_LABELS,
  normalizePinLine,
  requiredCheckState,
  validateFilePatch,
  validatePullRequest,
}
