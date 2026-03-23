---
name: restart-github-actions-runs
description: Restart GitHub Actions for one or more tap PRs by safely force-updating same-repo PR head branches or rerunning the latest PR workflow runs when the head branch is missing or not pushable. Use when asked to rerun, restart, or refresh CI checks for `chenrui333/homebrew-tap` without editing workflows, and never force-push `main`.
---

# Restart GitHub Actions Runs

Use this skill when the goal is to refresh GitHub Actions runs for open PRs in this tap without changing workflow files.

## Guardrails

- Never edit workflows just to restart checks.
- Never force-push `main`.
- Only force-update verified PR head branches that are open, same-repo, and not `main`.
- If the PR head branch is missing, cross-repo, or otherwise not pushable, rerun the existing workflow runs with `gh run rerun` instead.
- If global git config rewrites `https://github.com/` pushes to `git@github.com:` and SSH auth is unavailable, run the helper or any equivalent manual PR-branch push with `env GIT_CONFIG_GLOBAL=/dev/null` instead of changing `origin`.

## Preferred Command

Run the helper from the repo root:

```sh
skills/restart-github-actions-runs/scripts/restart_pr_actions.sh \
  --repo chenrui333/homebrew-tap \
  <pr> [<pr> ...]
```

Examples:

```sh
skills/restart-github-actions-runs/scripts/restart_pr_actions.sh --repo chenrui333/homebrew-tap 4991 4990 4989
skills/restart-github-actions-runs/scripts/restart_pr_actions.sh --dry-run --repo chenrui333/homebrew-tap 4991
```

## What The Script Does

1. Read PR metadata with `gh pr view`.
2. If the PR is open, same-repo, and its head branch still exists on `origin` and is not `main`, create an empty amend on that branch tip in a scratch clone and push it back with `--force-with-lease`.
3. Otherwise, collect the latest workflow run IDs from `gh pr checks` and rerun those runs directly with `gh run rerun`.
4. Print a per-PR action summary so follow-up checks are easy.

## Verification

After restarting runs, check status with:

```sh
gh pr checks <pr> --repo chenrui333/homebrew-tap
gh pr view <pr> --repo chenrui333/homebrew-tap --json url,headRefName,headRefOid
```

A fresh restart should show new `pending` checks or newly queued workflow runs.

## Upterm Session Hygiene

When the restarted workflow exposes an `*.upterm.dev` session for remote brew ops:

- Always attach to the current attempt's job/session, not an older rerun attempt. Old attempt URLs and SSH strings commonly look like "dead runners" even when the latest attempt is healthy.
- On a fresh connection, start with harmless probes such as `pwd` and `uname -a` before running brew commands.
- Do not begin with `set -euo pipefail` until you have confirmed the runner's working directory and any file paths you plan to use.
- Never reference workstation-local paths such as `/private/tmp/...` or `/Users/...` on the runner. Use heredocs, `scp`, or create the required files directly on the runner first.
