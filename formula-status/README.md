# Formula Metadata System

Automated metadata crawling and git hosting statistics for all formulas in this tap.

## Overview

The Formula Metadata system provides automated metadata extraction and git hosting statistics for every formula in the tap, generating a comprehensive `formula-status.md` report with:

- **Metadata extraction**: description, homepage, license, bottle, livecheck status
- **Multi-platform git statistics**: stars, forks, last commit, last release
  - GitHub (via gh CLI)
  - GitLab (via API)
  - Codeberg (via Forgejo API)
  - SourceHut (limited support)
- **Smart sorting**: formulas ranked by popularity (stars)

## Quick Start

### Using Justfile (Recommended)

```bash
# Generate metadata report
just status

# Generate with verbose logging (see what's happening)
just status-verbose

# Refresh git stats cache
just status-refresh

# Run in background and follow logs
just status-background
just status-logs

# Check if it's running
just status-check

# View results
just view
just count
just top 10

# Clean up
just clean
```

### Direct Python Usage

```bash
# Generate metadata report
python3 scripts/generate_formula_status.py

# Generate with verbose logging
python3 scripts/generate_formula_status.py --verbose

# Refresh git stats cache (ignore cached results)
python3 scripts/generate_formula_status.py --refresh

# Custom output file
python3 scripts/generate_formula_status.py --output my-status.md

# Control parallelism (default: 20 workers)
python3 scripts/generate_formula_status.py --workers 10
```

### CI/CD Integration

The system runs automatically:

- **Weekly**: Every Monday at 09:00 UTC
- **Manual**: Trigger from GitHub Actions UI
  - Go to Actions → Formula Metadata → Run workflow

Changes are automatically committed to the repository.

## Command Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--output` | Output file path | `formula-status.md` |
| `--refresh` | Ignore cache and refresh git stats | false |
| `--workers` | Number of parallel workers | 20 |
| `--verbose` / `-v` | Enable verbose logging | false |

## Justfile Commands

The `justfile` provides convenient shortcuts for common operations:

### Generation Commands
- `just status` - Generate metadata report
- `just status-verbose` - Generate with verbose logging
- `just status-refresh` - Refresh git stats cache
- `just status-workers N` - Use N parallel workers (default: 20)

### Background Execution
- `just status-background` - Run in background with logging
- `just status-check` - Check if crawler is running
- `just status-kill` - Stop background crawler
- `just status-logs` - Follow background logs
- `just status-watch` - Watch progress in real-time

### Viewing & Analysis
- `just view` - Display full formula-status.md
- `just count` - Count total formulas
- `just top N` - Show top N formulas by stars (default: 10)

### Maintenance
- `just clean` - Remove all generated files and cache
- `just clean-cache` - Remove git stats cache only
- `just clean-reports` - Remove formula-status.md only
- `just clean-logs` - Remove log files
- `just validate` - Validate generated formula-status.md

### Utilities
- `just example` - Show example output table
- `just install-deps` - Check dependencies (python3, gh)

## Git Hosting Platform Support

The crawler automatically detects and fetches statistics from multiple git hosting platforms:

### GitHub
- **Detection**: `github.com` in homepage or URL
- **Method**: `gh` CLI tool
- **Stats**: stars, forks, last commit, last release
- **Requirements**: `gh` command must be installed and authenticated

### GitLab
- **Detection**: `gitlab.com` in homepage or URL
- **Method**: GitLab REST API
- **Stats**: stars, forks, last activity, latest release
- **Requirements**: No authentication needed for public repos

### Codeberg
- **Detection**: `codeberg.org` in homepage or URL
- **Method**: Forgejo/Gitea API
- **Stats**: stars, forks, last update, latest release
- **Requirements**: No authentication needed for public repos

### SourceHut
- **Detection**: `git.sr.ht` in homepage or URL
- **Method**: Limited API support
- **Stats**: Basic repo information only (stars/forks not available)
- **Note**: SourceHut has minimal public API for statistics

## Output Format

The generated `formula-status.md` contains a sorted table of all formulas:

### Metadata Table

| Formula | Description | Stars | Forks | Last Commit | Last Release | License | Bottle | Livecheck | Homepage |
|---------|-------------|-------|-------|-------------|--------------|---------|--------|-----------|----------|
| popular-tool | An awesome CLI tool for developers | 1234 | 56 | 2024-12-10 | 2024-11-20 | MIT | ✓ | ✓ | [link](https://...) |
| another-tool | A cool application | 567 | 23 | 2024-12-12 | - | Apache-2.0 | ✓ | - | [link](https://...) |

**Table columns**:
1. **Formula**: Formula name
2. **Description**: Short description (truncated to 60 chars)
3. **Stars**: Git hosting stars count (or `-` if unavailable)
4. **Forks**: Git hosting forks count (or `-` if unavailable)
5. **Last Commit**: Last commit date in YYYY-MM-DD format
6. **Last Release**: Last release date in YYYY-MM-DD format (or `-` if none)
7. **License**: Software license (or `-` if not specified)
8. **Bottle**: ✓ if pre-built binary available, `-` otherwise
9. **Livecheck**: ✓ if version check configured, `-` otherwise
10. **Homepage**: Link to project homepage

**Sorting**: Formulas are sorted by stars (descending), then alphabetically by name.

## Git Stats Caching

Git hosting API responses are cached in `.cache/formula_metadata.json` to:
- Avoid rate limiting (especially for GitHub)
- Speed up subsequent runs
- Reduce API usage across all platforms

Cache is automatically:
- **Loaded**: On script start (unless `--refresh` specified)
- **Updated**: When new repos are fetched
- **Saved**: After processing all formulas
- **Committed**: To repository for CI/CD reuse

Use `--refresh` to force-refresh all cached stats for all platforms.

## Example Output

### Sample Table

```markdown
| Formula | Description | Stars | Forks | Last Commit | Last Release | License | Bottle | Livecheck | Homepage |
|---------|-------------|-------|-------|-------------|--------------|---------|--------|-----------|----------|
| awesome-tool | An awesome CLI tool for developers | 1234 | 56 | 2024-12-10 | 2024-11-20 | MIT | ✓ | ✓ | [link](https://github.com/user/awesome-tool) |
| cool-app | A cool application for productivity | 567 | 23 | 2024-12-12 | - | Apache-2.0 | ✓ | - | [link](https://gitlab.com/user/cool-app) |
| neat-util | Neat utility for developers | 234 | 12 | 2024-12-08 | 2024-11-15 | BSD-3-Clause | - | ✓ | [link](https://codeberg.org/user/neat-util) |
```

## Requirements

- **Python 3.x**: For running the script
- **GitHub CLI** (`gh`): For fetching GitHub repo stats (most common)
- **curl**: For fetching GitLab, Codeberg, and SourceHut stats

The `gh` CLI must be installed and authenticated for GitHub repos. For other platforms, no authentication is needed for public repositories.

All requirements are pre-installed in the GitHub Actions environment.

## Troubleshooting

### Common Issues

**Script fails to find formulas**:
- Ensure you're in the tap root directory
- Check that `Formula/` directory exists with `.rb` files

**GitHub API rate limiting**:
- Use cached results (default behavior)
- Ensure `gh` CLI is authenticated: `gh auth status`
- Run during off-peak hours

**Missing stats for some formulas**:
- Formula may not have a recognized git hosting URL
- Git hosting platform may be down or rate-limited
- Check formula's homepage and url fields

**Script appears stuck**:
- Use `--verbose` flag to see progress
- Use `just status-watch` to monitor in real-time
- Check process with `just status-check`

**Permission errors**:
- Ensure script is executable: `chmod +x scripts/generate_formula_status.py`
- Ensure `gh` CLI is authenticated

### Verbose Mode

Enable verbose output to see detailed progress:

```bash
just status-verbose
# or
python3 scripts/generate_formula_status.py --verbose
```

## Integration with Other Tools

### Pre-commit Hook

Add to `.pre-commit-config.yaml`:

```yaml
- repo: local
  hooks:
    - id: formula-status
      name: Update formula status
      entry: python3 scripts/generate_formula_status.py
      language: system
      pass_filenames: false
      always_run: false  # Only run manually
```

### CI/CD Badge

Add to README:

```markdown
![Formula Status](https://github.com/chenrui333/homebrew-tap/actions/workflows/formula-status.yml/badge.svg)
```

## Performance

**Typical execution** (~3-5 minutes for 150 formulas):
- Pure metadata extraction and git stats
- Parallel processing with 20 workers
- Cached git stats for subsequent runs
- Fast API calls to GitLab, Codeberg
- GitHub via `gh` CLI (fastest)

**Optimization tips**:
- Use cached results (default) for faster runs
- Adjust `--workers` based on your system
- Run with `--verbose` only when debugging

## Contributing

To improve the metadata system:

1. **Add new platforms**: Add detection pattern and stats fetcher
2. **Enhance reporting**: Update `generate_report()` method
3. **Improve caching**: Extend cache schema
4. **Add metadata**: Track additional formula fields

See `scripts/generate_formula_status.py` for implementation details.

## Future Enhancements

Planned improvements:

- [ ] Self-hosted GitLab/Gitea instance support
- [ ] Historical trend tracking (stars over time)
- [ ] Formula health scoring algorithm
- [ ] Integration with Homebrew analytics
- [ ] Multi-tap aggregation support
- [ ] Web dashboard UI
- [ ] Better SourceHut API integration (when available)

## Support

For issues or questions:
- Open an issue on GitHub
- Check existing formula-status.md for formula-specific issues
- Review GitHub Actions logs for CI failures
