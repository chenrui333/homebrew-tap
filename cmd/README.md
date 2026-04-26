# Custom Homebrew Commands

This directory contains custom Homebrew commands provided by the `chenrui333/tap` tap.

## `brew migrate-python`

Create a tap PR that migrates a formula from the previous Homebrew `python@X.Y`
dependency to the current one and refreshes resource blocks with
`brew update-python-resources2`.

### Usage

```bash
brew migrate-python readmeai
brew migrate-python chenrui333/tap/readmeai
brew migrate-python readmeai --exclude foo,bar
```

### Notes

- Works against `chenrui333/homebrew-tap`
- Creates a branch from `origin/main`
- Uses `brew update-python-resources2` so missing sdists are handled in the same tap workflow
- Pushes the branch and opens a PR automatically
- Adds the matching `python-X.Y-migration` label when present
- Requires a clean tracked worktree in the tap

## `brew update-python-resources2`

An enhanced wrapper around `brew update-python-resources` that handles PyPI packages lacking suitable source distributions by creating skeleton resource stanzas for manual backfill.

### Problem

When running `brew update-python-resources` on formulas with complex Python dependencies, some packages may fail with:

```
Error: <package> exists on PyPI but lacks a suitable source distribution
```

This blocks the entire update process, requiring manual intervention for each problematic package.

### Solution

`brew update-python-resources2` automatically:
1. Detects packages that lack suitable source distributions
2. Excludes them for dependency resolution (allowing the update to proceed)
3. **Inserts skeleton resource blocks** into the formula file with TODO comments
4. Allows you to manually backfill `url` and `sha256` for those packages later

### Usage

**Basic usage (verbose by default):**
```bash
brew update-python-resources2 paperai
```

**Preview changes without modifying:**
```bash
brew update-python-resources2 paperai --dry-run
```

**Quiet mode:**
```bash
brew update-python-resources2 paperai --quiet
```

**Show missing packages:**
```bash
brew update-python-resources2 paperai --print-missing
```

**With manual excludes:**
```bash
brew update-python-resources2 paperai --exclude some-package,another-package
```

### Options

- `--exclude PKG1,PKG2,...` - Manually specify packages to exclude (can be used multiple times)
- `--max-retries N` - Maximum number of retry attempts (default: 25)
- `--quiet` - Reduce output verbosity (verbose by default)
- `--dry-run` - Preview changes without modifying formula file
- `--print-missing` - Print the missing-sdist package list
- `-h, --help` - Show help message

All other flags are passed through to the underlying `brew update-python-resources` command.

### Example Output

```bash
$ brew update-python-resources2 paperai
Attempt 1: Running: brew update-python-resources paperai
⚠  Found missing sdist: 'bitsandbytes' - excluding for dependency resolution...
Attempt 2: Running: brew update-python-resources paperai --exclude bitsandbytes
⚠  Found missing sdist: 'faiss-cpu' - excluding for dependency resolution...
Attempt 3: Running: brew update-python-resources paperai --exclude bitsandbytes,faiss-cpu
[...update output...]
✓ Inserted 2 skeleton resource(s) into Formula/p/paperai.rb
✓ Completed successfully. Missing sdist (skeletons added): bitsandbytes, faiss-cpu
```

### Skeleton Resource Format

For each package lacking a source distribution, the command inserts:

```ruby
# TODO: bitsandbytes has no sdist on PyPI; fill in a source URL + sha256 manually.
resource "bitsandbytes" do
  url ""
  sha256 ""
end
```

These are inserted after existing resource blocks in the formula, maintaining proper indentation and style.

### How It Works

1. Runs `brew update-python-resources` with your arguments
2. If it encounters the "lacks a suitable source distribution" error:
   - Records the package name
   - Adds it to the exclude list for dependency resolution
   - Continues the update process
3. Upon successful completion:
   - Locates the formula file
   - Finds the appropriate insertion point (after existing resources)
   - Inserts skeleton resource blocks for manual backfill
   - Does not duplicate if resource already exists
4. Prints summary of what was done

### Safety Features

- **Only modifies formula on success** - If the update fails for other reasons, no changes are made
- **No duplicates** - Checks if resource already exists before inserting
- **Proper indentation** - Matches existing resource block style
- **Dry-run mode** - Preview changes before applying them
- **Max retries** - Prevents infinite loops (default: 25, configurable)
- **Non-recursive** - Always calls core `brew update-python-resources`, never itself

### Environment

Sets `HOMEBREW_NO_AUTO_UPDATE=1` when calling the underlying command to prevent unexpected Homebrew updates during the process.

### Limitations

- Only handles the specific "lacks a suitable source distribution" error
- Does not retry for other types of errors (shows full output and exits)
- Requires manual backfill of URL and sha256 for skeleton resources
- Formula must be in the tap (cannot modify formulas from other taps)

## `brew patch`

Fetch a patch URL, calculate its SHA-256, and print a Homebrew `patch do`
block.

### Usage

```bash
brew patch https://github.com/org/repo/commit/abc123.patch
```

## `brew check`

Run a strict online audit with autofix enabled.

### Usage

```bash
brew check chenrui333/tap/bun
brew check bun
```

## `brew close-superseded-prs`

Find open formula version-bump PRs that are no longer the latest update for a
formula, then optionally comment, label, and close them.

The command only considers PR titles in the standard formula bump format:
`<formula> <version>`. It skips new formula/cask PRs and non-version update
titles.

### Usage

```bash
brew close-superseded-prs
brew close-superseded-prs --formula ministack
brew close-superseded-prs --apply
```

### Notes

- Defaults to dry-run output.
- Closes PRs already covered by the version on `main` with a `Superseded by current main...` comment.
- Keeps the most recently opened bump PR for each formula and closes older open bumps with `Superseded by #<pr>`.
- Uses the `superseded` label when applying changes.
