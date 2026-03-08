# Agent Instructions for homebrew-core

This document helps coding agents produce high-quality PRs for homebrew-core formula contributions.

## Before Any PR

1. **Check for existing PRs** for the same formula: [open PRs](https://github.com/Homebrew/homebrew-core/pulls)
2. Run `brew tap homebrew/core` if not already tapped

## Tap/Core Overlap Checks

- Treat a tap vs `homebrew/core` overlap as real only when both formulae point to the same upstream project.
- For quick screening, compare exact formula name plus `url` and `desc`; a name match alone is not enough.
- Re-verify any collision whose `url` or `desc` differs before proposing removal, rename, or dedupe work.
- Known exceptions in this tap:
  - `hello` is an intentional overlap and should be kept because it is used to test the tap formula infrastructure.
  - `kafka` is an intentional overlap because this tap needs Kafka 3.9.
  - `zookeeper` is an intentional overlap because this tap needs a JDK 21 build; the `homebrew/core` `openjdk`-based formula does not work for this use case.
  - `carton` is a name-only collision, not a real overlap: this tap packages `swiftwasm/carton`, while `homebrew/core` `carton` is the Perl CPAN dependency manager.

## Version Updates

Preferred method for version bumps:

```sh
brew bump-formula-pr --strict <formula> --url=<url> --sha256=<sha256>
# or
brew bump-formula-pr --strict <formula> --tag=<tag> --revision=<revision>
# or
brew bump-formula-pr --strict <formula> --version=<version>
```

This handles URL/checksum updates, commit message, and opens the PR automatically.

### Manual Version Updates

If manual editing is needed:

```sh
brew edit <formula>
# Update url and sha256 (or tag and revision)
# Leave `bottle do` block unchanged
```

Commit message: `foo 1.2.3`

## Formula Fixes

For bug fixes or improvements to existing formulae:

```sh
brew edit <formula>
# Make changes
# Leave `bottle do` block unchanged
```

Commit message: `foo: fix <description>` or `foo: <description>`

### Ruby Style Preferences

Prefer `Pathname` idioms where possible.

Examples:
```ruby
session_dir.mkpath
bin.install_symlink libexec.glob("bin/*")
```

### Python Dependency Reuse

When a Python formula can reuse a packaged dependency from Homebrew instead of vendoring it as a resource, prefer the shared formula dependency.

- For Pydantic v2 consumers, prefer:
  ```ruby
  depends_on "pydantic" => :no_linkage
  ```
- Do NOT add `depends_on "pydantic-core"`: there is no standalone `pydantic-core` formula in Homebrew; `pydantic-core` is provided by the `pydantic` formula.
- Remove vendored `pydantic`, `pydantic-core`, and their helper resources when they are satisfied by the shared `pydantic` formula.
- If the formula uses `pypi_packages`, exclude shared Python formula deps there as well so autobump can manage the remaining vendored resources cleanly. For example:
  ```ruby
  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage

  pypi_packages exclude_packages: %w[certifi pydantic]
  ```
- Apply the same exclusion pattern to any other shared Python deps moved out of resources, such as `cryptography` or `rpds-py`.

### When to Add a Revision

Add or increment `revision` when:
- Fix requires existing bottles to be rebuilt
- Dependencies changed in a way that affects the built package
- The installed binary/library behavior changes

Do NOT add revision for cosmetic changes (comments, style, livecheck fixes).

## New Formulae

```sh
brew create <url>
# Edit the generated formula
```

Commit message: `foo 1.2.3 (new formula)`

### Required Elements

- **Build source policy**: MUST build from source in the formula (e.g., `go build`, `cargo install`, `cmake`, etc.).
  - Do NOT package upstream prebuilt binaries/releases for formula installation.
  - If upstream only ships binaries and no buildable source path, raise it for manual review instead of adding the formula.
  - Rust binary formulae MUST use `cargo install` with `std_cargo_args` (for example `system "cargo", "install", *std_cargo_args(path: ".")`).
  - Do NOT hand-roll standard Rust binary installs with `cargo build` + `bin.install` when `std_cargo_args` applies.
  - Do NOT manually append `--locked` or `--path` when `std_cargo_args(path: "...")` is used.
- **Test block**: MUST verify actual functionality, not just `--version` or `--help`
  - Include a version assertion as an additional check whenever a reliable version command/output exists
  - Prefer the simple standard form: `assert_match version.to_s, shell_output("#{bin}/foo --version")`
  - Avoid regex-only version assertions when `version.to_s` matching is available
  - For libraries: compile and link sample code
  - Use `testpath` for temporary files
  - Do NOT set `ENV["HOME"] = testpath.to_s` in `test do`.
  - Prefer command-scoped environment overrides such as `shell_output("HOME=#{testpath} #{bin}/foo ...")` or `system "env", "HOME=#{testpath}", bin/"foo", ...`.
- **Completions policy**: Add shell completion support when upstream CLI supports it.
  - Use Homebrew DSL: `generate_completions_from_executable`.
  - Rust CLIs: prefer `shell_parameter_format: :clap`.
  - Go CLIs: prefer `shell_parameter_format: :cobra`.
  - Python CLIs: prefer `shell_parameter_format: :click` or `:typer` (based on upstream framework).

### Library Packaging Guidance

- Prefer installing **shared libraries** (`.dylib`/`.so`) when upstream supports both shared and static builds.
- Avoid static-only installs unless upstream cannot build shared libraries, or there is a clear technical reason documented in the formula.
- If upstream lacks `install()` rules, manual installation is acceptable, but still prefer installing the shared artifact when available.

- **Service block**: If the software can run as a daemon, include a `service do` block.
  - Place `service do` after `def install` and before `test do`.
  ```ruby
service do
  run [opt_bin/"foo", "start"]
  keep_alive true
end
  ```

- **Livecheck**: Prefer default behavior. Only add a `livecheck` block if automatic detection fails.

- **Head support**: Include when the project has a development branch:
  ```ruby
head "https://github.com/org/repo.git", branch: "main"
  ```
  Git repositories MUST specify `branch:`.

## Required Validation (All PR Types)

All checks MUST pass locally before opening a PR:

```sh
# Build from source (required)
HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source <formula>

# Run tests
brew test <formula>

# Linkage check
brew linkage --test <formula>

# Audit (existing formula)
brew audit --strict <formula>

# Audit (new formula only)
brew audit --new <formula>

# Style check
brew style <formula>
```

## Merge Path

- Any formula PR that is not labeled `CI-syntax-only` MUST go through the `pr-pull` process.
  - This includes new formulae, version bumps, revision rebuilds, and formula fixes that should produce or refresh bottles.
  - After checks pass, wait for the test workflow to add `pr-pull`, then let the `brew pr-pull` workflow merge the PR.
  - Do NOT manually merge these PRs with `gh pr merge`, because that bypasses BrewTestBot bottle commits and can leave `main` without a `bottle do` block.
- Never force-push `main` to `main`.
  - `git push --force-with-lease` is only for PR head branches that you explicitly verified are not `main`.
  - When updating `main`, use a normal `git push origin main`.
  - If local `main` and `origin/main` diverge, run `git pull --rebase origin main`, resolve conflicts locally, and then push normally.
- Manual merges are acceptable only for PRs explicitly labeled `CI-syntax-only`, meaning CI should run syntax checks only and no bottle-producing build should occur.
- If a new formula lands on `main` without a `bottle do` block, open a one-formula follow-up PR that only adds or increments `revision` to force a fresh bottle build, and again leave that PR for the bot-managed `pr-pull` merge path.

## PR Triage Workflow

For formula patch PR triage, follow this exact sequence:

1. Run brew ops and ensure all pass:
   ```sh
   HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source <formula>
   brew test <formula>
   brew linkage --test <formula>
   brew audit --strict <formula>   # or --new for new formulae
   brew style <formula>
   ```
   - If any step fails, patch the PR branch with the smallest formula fix and rerun the full brew-ops chain until all steps pass.
   - When testing on Linux/macOS `*.upterm.dev` remote runners, do not run `exit`, `logout`, or close the session after brew ops; keep the runner alive for follow-up commands.
2. Commit on the PR head branch with a short, concise formula patch:
   ```sh
   branch="$(gh pr view --json headRefName -q .headRefName)"
   git switch "$branch"
   git add Formula/<path>/<formula>.rb
   git commit -m "<formula>: <short fix>"
   ```
3. Squash commits while preserving the BrewTestBot-compatible commit subject header:
   ```sh
   base="$(gh pr view --json baseRefName -q .baseRefName)"
   header="$(git log --reverse --format=%s "origin/${base}..HEAD" | head -n1)"
   # Squash as needed, but keep the final first line equal to "$header"
   git log -1 --pretty=%s
   ```
4. Force-update the PR head branch safely:
   ```sh
   test "$branch" != main
   git push --force-with-lease origin "$branch"
   ```
5. Mark the PR with `CI-no-fail-fast`:
   ```sh
   pr="$(gh pr view --json number -q .number)"
   gh pr edit "$pr" --add-label CI-no-fail-fast
   ```
6. For any formula PR not labeled `CI-syntax-only`, stop after the branch is green and labeled correctly, then leave merge to the bot-managed `pr-pull` workflow.
   - Do NOT use `gh pr merge` manually for formula PRs that should produce bottles.
   - If the goal is to regenerate missing bottles for a merged formula, open a one-formula `revision` follow-up PR and again leave merge to `pr-pull`.
7. If triaging many open PRs, dedupe only version-bump PRs for the same formula by keeping only the latest one.
   - Apply this only to PR titles in version-bump format (`<formula> <version>`), and skip non-version PRs such as `foo: fix ...`.
   ```sh
   repo="<owner>/<repo>"
   gh pr list --repo "$repo" --state open --limit 1000 --json number,title,createdAt > /tmp/open_prs.json
   jq -r '
     # Version-bump titles only: "<formula> <version>"
     map(select(.title | test("^[^: ]+ [0-9]"))) |
     sort_by(.createdAt) |
     group_by(.title | capture("^(?<formula>[^ ]+) ").formula)[] |
     select(length > 1) |
     (.[-1].number | tostring) as $keeper |
     .[0:-1][] |
     "\(.number) \($keeper)"
   ' /tmp/open_prs.json > /tmp/superseded_pr_pairs.txt
   ```
8. For each older PR, comment + label + close:
   ```sh
   repo="<owner>/<repo>"
   while read -r old_pr keeper_pr; do
     [ -n "$old_pr" ] || continue
     printf 'Superseded by #%s\n' "$keeper_pr" > "/tmp/pr-${old_pr}-superseded.md"
     gh pr comment "$old_pr" --repo "$repo" --body-file "/tmp/pr-${old_pr}-superseded.md"
     gh pr edit "$old_pr" --repo "$repo" --add-label superseded
     gh pr close "$old_pr" --repo "$repo"
   done < /tmp/superseded_pr_pairs.txt
   ```

## PR Template Checklist

You MUST verify all items before submitting:

- [ ] Followed [CONTRIBUTING.md](CONTRIBUTING.md)
- [ ] Commits follow [commit style guide](https://docs.brew.sh/Formula-Cookbook#commit)
- [ ] No existing [open PRs](https://github.com/Homebrew/homebrew-core/pulls) for same change
- [ ] Built locally with `HOMEBREW_NO_INSTALL_FROM_API=1 brew install --build-from-source`
- [ ] Tests pass with `brew test`
- [ ] Linkage passes with `brew linkage --test`
- [ ] Audit passes with `brew audit --strict` (or `--new` for new formulae)
- [ ] Style passes with `brew style`

## Commit Message Format

- Version update: `foo 1.2.3`
- New formula: `<formula_name> <version> (new formula)`
  - Example: `ls-hpack 2.3.4 (new formula)`
- Fix/change: `foo: fix <description>` or `foo: <description>`
- First line MUST be 50 characters or less
- Reference issues with `Closes #12345` in commit body if applicable

## PR Hygiene

### MUST

- One formula change per PR
- Keep diffs minimal and focused
- Provide only essential context in PR description
- For any formula PR not labeled `CI-syntax-only`, use the `pr-pull` merge path so BrewTestBot adds the bottle commit to `main`

### MUST NOT

- Edit `bottle do` blocks (managed by BrewTestBot)
- Batch unrelated formula changes
- Include large logs or verbose output in PR body
- Add non-Homebrew usage caveats in PR body
- Include unrelated refactors or cleanups
- Manually merge formula PRs that are not labeled `CI-syntax-only` with `gh pr merge`

## PR Description Template

Keep it minimal:

```
Built and tested locally on [macOS version/Linux].

[One sentence describing the change if not obvious from title.]
```

## GitHub Body Formatting

When using `gh` to create/edit PRs or issues:

- Prefer `--body-file` with a heredoc-generated markdown file to preserve newlines.
- Avoid passing escaped `\n` in quoted `--body` strings.
- If inline body text is required, use single quotes around the full body to avoid shell interpolation.

## CI Failures

- Reproduce failures locally before debugging
- Read error messages and annotations in "Files changed" tab
- Check complete build log in "Checks" tab if needed
- For Linux failures, use the [Homebrew Docker container](CONTRIBUTING.md#homebrew-docker-container)
- If stuck, comment describing what you've tried

## AI Disclosure

If AI assisted with the PR, check the AI checkbox in the PR template and briefly describe:
- How AI was used
- What manual verification was performed

## References

- [Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [CONTRIBUTING.md](CONTRIBUTING.md)
- [How to Open a PR](https://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request)
