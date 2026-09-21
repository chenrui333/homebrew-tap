#!/usr/bin/env bash

set -euo pipefail

die() {
	printf '::error::%s\n' "$*" >&2
	exit 1
}

require_automation_branch() {
	[[ -n "${BRANCH:-}" ]] || die "BRANCH is required"
	[[ "$BRANCH" == automation/* ]] || die "Refusing non-automation branch: $BRANCH"
	[[ "$BRANCH" != "main" ]] || die "Refusing to operate on main"
}

write_output() {
	if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
		printf '%s=%s\n' "$1" "$2" >>"$GITHUB_OUTPUT"
	fi
}

remote_branch_sha() {
	git ls-remote --heads origin "refs/heads/$BRANCH" | awk 'NR == 1 { print $1 }'
}

open_prs() {
	gh pr list \
		--repo "$GITHUB_REPOSITORY" \
		--base main \
		--head "$BRANCH" \
		--state open \
		--limit 1000 \
		--json number,headRefName,headRepository \
		--jq '.[] | [.number, .headRefName, (.headRepository.nameWithOwner // "")] | @tsv'
}

prepare_branch() {
	local observed_sha base_sha

	require_automation_branch
	git fetch --no-tags origin +refs/heads/main:refs/remotes/origin/main
	git rev-parse --verify refs/remotes/origin/main >/dev/null
	base_sha="$(git rev-parse refs/remotes/origin/main)"

	observed_sha="$(remote_branch_sha)"
	if [[ -n "$observed_sha" ]]; then
		[[ "$observed_sha" =~ ^[0-9a-f]{40}$ ]] || die "Invalid remote SHA for $BRANCH: $observed_sha"
		git fetch --no-tags origin "+refs/heads/$BRANCH:refs/remotes/origin/$BRANCH"
	fi

	git checkout -B "$BRANCH" refs/remotes/origin/main
	[[ "$(git branch --show-current)" == "$BRANCH" ]] || die "Failed to check out $BRANCH"

	write_output base_sha "$base_sha"
	write_output remote_sha "$observed_sha"
}

close_stale_pr() {
	local pr_number current_sha
	pr_number="$1"

	current_sha="$(remote_branch_sha)"
	[[ "$current_sha" == "${REMOTE_SHA:-}" ]] || die "Automation branch changed before closing stale PR"

	gh pr close "$pr_number" \
		--repo "$GITHUB_REPOSITORY" \
		--comment "Generated output is already current on main; closing this stale automation PR."

	current_sha="$(remote_branch_sha)"
	[[ "$current_sha" == "${REMOTE_SHA:-}" ]] || die "Automation branch changed while closing stale PR"
	[[ "$current_sha" =~ ^[0-9a-f]{40}$ ]] || die "Expected an existing automation branch before deletion"
	git push \
		--force-with-lease="refs/heads/$BRANCH:$current_sha" \
		origin ":refs/heads/$BRANCH"
}

publish_pr() {
	local files=("$@")
	local changed pr_lines pr_count pr_number pr_head pr_repo current_main

	require_automation_branch
	[[ -n "${GITHUB_REPOSITORY:-}" ]] || die "GITHUB_REPOSITORY is required"
	[[ -n "${PR_TITLE:-}" ]] || die "PR_TITLE is required"
	[[ -n "${PR_BODY:-}" ]] || die "PR_BODY is required"
	[[ -n "${COMMIT_MESSAGE:-}" ]] || die "COMMIT_MESSAGE is required"
	[[ -n "${BASE_SHA:-}" ]] || die "BASE_SHA is required"
	[[ ${#files[@]} -gt 0 ]] || die "At least one generated file is required"

	current_main="$(git ls-remote --heads origin refs/heads/main | awk 'NR == 1 { print $1 }')"
	[[ "$current_main" == "$BASE_SHA" ]] || die "main changed while generating; rerun from current main"

	if [[ -n "$(git status --porcelain --untracked-files=all -- "${files[@]}")" ]]; then
		git config user.name "github-actions"
		git config user.email "actions@github.com"
		git add -- "${files[@]}"
		git commit -m "$COMMIT_MESSAGE"
	fi

	if [[ -n "$(git status --porcelain --untracked-files=all)" ]]; then
		die "Unexpected uncommitted files remain after generation"
	fi

	if git diff --quiet refs/remotes/origin/main..HEAD -- "${files[@]}"; then
		pr_lines="$(open_prs)"
		if [[ -n "$pr_lines" ]]; then
			pr_count="$(printf '%s\n' "$pr_lines" | wc -l | tr -d ' ')"
			[[ "$pr_count" -eq 1 ]] || die "Expected at most one open PR for $BRANCH"
			IFS=$'\t' read -r pr_number pr_head pr_repo <<<"$pr_lines"
			[[ "$pr_head" == "$BRANCH" && "$pr_repo" == "$GITHUB_REPOSITORY" ]] || die "Open PR does not belong to $BRANCH"
			close_stale_pr "$pr_number"
			write_output action "closed-stale-pr"
		else
			echo "Generated output is already current; no PR needed."
			write_output action "no-change"
		fi
		return 0
	fi

	if [[ -n "${REMOTE_SHA:-}" ]]; then
		git push \
			--force-with-lease="refs/heads/$BRANCH:$REMOTE_SHA" \
			origin "HEAD:refs/heads/$BRANCH"
	else
		git push origin "HEAD:refs/heads/$BRANCH"
	fi

	pr_lines="$(open_prs)"
	if [[ -n "$pr_lines" ]]; then
		pr_count="$(printf '%s\n' "$pr_lines" | wc -l | tr -d ' ')"
		[[ "$pr_count" -eq 1 ]] || die "Expected at most one open PR for $BRANCH"
		IFS=$'\t' read -r pr_number pr_head pr_repo <<<"$pr_lines"
		[[ "$pr_head" == "$BRANCH" && "$pr_repo" == "$GITHUB_REPOSITORY" ]] || die "Open PR does not belong to $BRANCH"
		gh pr edit "$pr_number" \
			--repo "$GITHUB_REPOSITORY" \
			--title "$PR_TITLE" \
			--body "$PR_BODY"
		changed="updated-pr"
	else
		gh pr create \
			--repo "$GITHUB_REPOSITORY" \
			--base main \
			--head "$BRANCH" \
			--title "$PR_TITLE" \
			--body "$PR_BODY" >/dev/null
		pr_lines="$(open_prs)"
		pr_count="$(printf '%s\n' "$pr_lines" | wc -l | tr -d ' ')"
		[[ "$pr_count" -eq 1 ]] || die "Expected exactly one open PR after creating $BRANCH"
		IFS=$'\t' read -r pr_number pr_head pr_repo <<<"$pr_lines"
		[[ "$pr_head" == "$BRANCH" && "$pr_repo" == "$GITHUB_REPOSITORY" ]] || die "Created PR does not belong to $BRANCH"
		changed="created-pr"
	fi

	echo "Generated PR #$pr_number ($changed)."
	write_output action "$changed"
	write_output pr_number "$pr_number"
}

case "${1:-}" in
	prepare)
		[[ $# -eq 1 ]] || die "prepare takes no file arguments"
		prepare_branch
		;;
	publish)
		shift
		publish_pr "$@"
		;;
	*)
		die "Usage: $0 prepare|publish [generated-file ...]"
		;;
esac
