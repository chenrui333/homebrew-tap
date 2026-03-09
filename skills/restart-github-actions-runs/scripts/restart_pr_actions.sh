#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  restart_pr_actions.sh [--repo owner/repo] [--dry-run] <pr> [<pr> ...]

Behavior:
  - Prefer a safe empty-amend + force-with-lease on same-repo PR head branches.
  - Fall back to `gh run rerun` when the PR head branch is missing, cross-repo,
    or not safe to push.

Options:
  --repo <owner/repo>  GitHub repo. Defaults to the current git origin if possible.
  --dry-run            Print planned actions without mutating GitHub.
  -h, --help           Show help.

Safety:
  - Never force-pushes `main`.
  - Only force-updates open, same-repo PR head branches that still exist on origin.
USAGE
}

die() {
  echo "error: $*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

normalize_pr() {
  local input="$1"
  if [[ "$input" =~ ^https?://github\.com/.*/pull/([0-9]+) ]]; then
    echo "${BASH_REMATCH[1]}"
  else
    echo "$input"
  fi
}

extract_repo_from_origin() {
  local remote
  remote=$(git remote get-url origin 2>/dev/null || true)
  if [[ -z "$remote" ]]; then
    return 1
  fi
  if [[ "$remote" =~ github\.com[:/]([^/]+/[^/.]+)(\.git)?$ ]]; then
    echo "${BASH_REMATCH[1]}"
    return 0
  fi
  return 1
}

collect_run_ids() {
  local pr="$1"
  local repo="$2"
  gh pr checks "$pr" --repo "$repo" --json link |
    jq -r '.[].link | select(test("/actions/runs/[0-9]+")) | capture("/actions/runs/(?<id>[0-9]+)").id' |
    sort -u
}

rerun_runs() {
  local pr="$1"
  local repo="$2"
  local dry_run="$3"
  local ids

  ids=$(collect_run_ids "$pr" "$repo" || true)
  if [[ -z "$ids" ]]; then
    echo "FALLBACK pr=$pr mode=rerun status=no-runs-found"
    return 0
  fi

  while IFS= read -r run_id; do
    [[ -n "$run_id" ]] || continue
    if (( dry_run )); then
      echo "PLAN pr=$pr mode=rerun run=$run_id"
    else
      gh run rerun "$run_id" --repo "$repo" >/dev/null
      echo "RERUN pr=$pr run=$run_id"
    fi
  done <<<"$ids"
}

REPO=""
DRY_RUN=0
PRS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      [[ $# -ge 2 ]] || die "--repo requires a value"
      REPO="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -* )
      die "unknown option: $1"
      ;;
    *)
      PRS+=("$(normalize_pr "$1")")
      shift
      ;;
  esac
done

[[ ${#PRS[@]} -gt 0 ]] || { usage; exit 1; }
require_cmd gh
require_cmd git
require_cmd jq

gh auth status -h github.com >/dev/null 2>&1 || die "gh is not authenticated"

if [[ -z "$REPO" ]]; then
  REPO=$(extract_repo_from_origin) || die "--repo is required outside a git checkout with a GitHub origin"
fi

scratch=$(mktemp -d /private/tmp/restart-pr-actions.XXXXXX)
trap 'rm -rf "$scratch"' EXIT

git clone --filter=blob:none --no-checkout "git@github.com:${REPO}.git" "$scratch" >/dev/null 2>&1
cd "$scratch"

name=$(git -C /opt/homebrew/Homebrew/Library/Taps/chenrui333/homebrew-tap config user.name || true)
email=$(git -C /opt/homebrew/Homebrew/Library/Taps/chenrui333/homebrew-tap config user.email || true)
[[ -n "$name" ]] && git config user.name "$name"
[[ -n "$email" ]] && git config user.email "$email"

for pr in "${PRS[@]}"; do
  meta=$(gh pr view "$pr" --repo "$REPO" --json number,state,headRefName,headRefOid,isCrossRepository,title,url)
  state=$(jq -r '.state' <<<"$meta")
  branch=$(jq -r '.headRefName' <<<"$meta")
  sha=$(jq -r '.headRefOid' <<<"$meta")
  cross=$(jq -r '.isCrossRepository' <<<"$meta")
  title=$(jq -r '.title' <<<"$meta")

  if [[ "$state" != "OPEN" ]]; then
    echo "SKIP pr=$pr state=$state title=$(printf %q "$title")"
    continue
  fi

  if [[ "$branch" == "main" ]]; then
    echo "FALLBACK pr=$pr mode=rerun reason=head-is-main"
    rerun_runs "$pr" "$REPO" "$DRY_RUN"
    continue
  fi

  if [[ "$cross" == "false" ]] && git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
    if (( DRY_RUN )); then
      echo "PLAN pr=$pr mode=force-update branch=$branch sha=${sha:0:12}"
      continue
    fi

    git fetch --no-tags origin "$branch" >/dev/null 2>&1
    git checkout --detach FETCH_HEAD >/dev/null 2>&1
    old=$(git rev-parse --short=12 HEAD)
    git commit --amend --no-edit --allow-empty >/dev/null 2>&1
    new=$(git rev-parse --short=12 HEAD)
    git push --force-with-lease origin HEAD:"$branch" >/dev/null 2>&1
    echo "REFRESHED pr=$pr mode=force-update branch=$branch old=$old new=$new"
    continue
  fi

  echo "FALLBACK pr=$pr mode=rerun reason=head-not-pushable branch=$branch sha=${sha:0:12}"
  rerun_runs "$pr" "$REPO" "$DRY_RUN"
done
