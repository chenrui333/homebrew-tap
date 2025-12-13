# Formula Metadata Crawler System

## Overview

The Formula Metadata Crawler is an automated system that extracts formula metadata and fetches git hosting statistics for all formulas in the homebrew-tap. It generates a comprehensive `formula-status.md` report sorted by popularity (stars).

## Location

All formula status related files are in the `formula-status/` directory:

```
formula-status/
├── generate_formula_status.py    # Main crawler script
└── README.md                      # Full documentation
```

## Purpose

**Original Intent Evolution**: The system was initially conceived as a formula health checker with brew audit/style/readall validation. Through iterative refinement with the user, it was clarified that the actual goal was pure git hosting metadata crawling - no brew checks at all.

**Final Purpose**: Extract formula metadata and fetch git hosting statistics to create a popularity-ranked table of all formulas in the tap.

## Architecture

### Core Components

1. **FormulaCrawler Class**: Main orchestrator with parallel processing (20 workers default)
2. **GitStats Dataclass**: Holds git hosting statistics (stars, forks, commits, releases)
3. **FormulaInfo Dataclass**: Combines formula metadata with git stats
4. **Multi-Platform Support**: GitHub, GitLab, Codeberg, SourceHut

### Data Flow

```
Formula .rb files
    ↓
Extract metadata (desc, homepage, url, license, bottle, livecheck)
    ↓
Infer git hosting platform from homepage/url
    ↓
Fetch stats via platform-specific method
    ↓
Cache results (.cache/formula_metadata.json)
    ↓
Generate sorted Markdown table (formula-status.md)
```

## Git Hosting Platform Support

### GitHub
- **Detection**: `github.com` in homepage or URL
- **Method**: `gh` CLI tool (`gh repo view`, `gh release view`)
- **Stats**: stars, forks, last commit (pushedAt), last release (publishedAt)
- **Requirements**: `gh` CLI installed and authenticated
- **Implementation**: scripts/generate_formula_status.py:161-218

### GitLab
- **Detection**: `gitlab.com` in homepage or URL
- **Method**: GitLab REST API v4
- **Stats**: star_count, forks_count, last_activity_at, releases
- **Requirements**: None (public API)
- **Implementation**: scripts/generate_formula_status.py:226-283

### Codeberg
- **Detection**: `codeberg.org` in homepage or URL
- **Method**: Forgejo/Gitea API v1
- **Stats**: stars_count, forks_count, updated_at, releases
- **Requirements**: None (public API)
- **Implementation**: scripts/generate_formula_status.py:285-342

### SourceHut
- **Detection**: `git.sr.ht` in homepage or URL
- **Method**: Limited support (no public stats API)
- **Stats**: Basic repo info only (no stars/forks available)
- **Requirements**: None
- **Implementation**: scripts/generate_formula_status.py:344-384

## Key Features

### Parallel Processing
- Uses `ThreadPoolExecutor` with 20 workers (configurable)
- Each formula processed independently
- Real-time progress output with `flush=True`

### Caching System
- Cache file: `.cache/formula_metadata.json`
- Cache key format: `{platform}:{owner}/{repo}`
- Caches all platforms (GitHub, GitLab, Codeberg, SourceHut)
- Loaded on script start unless `--refresh` specified
- Saved after all formulas processed
- Committed to repo for CI/CD reuse

### Output Format
- Markdown table with 10 columns
- Sorted by stars descending, then alphabetically by name
- Description truncated to 60 characters
- Checkmarks (✓) for bottle and livecheck
- Dashes (-) for missing data

## Usage

### Quick Commands (via justfile)

```bash
# Generate report
just status

# With verbose logging
just status-verbose

# Refresh cache
just status-refresh

# Custom worker count
just status-workers 10

# Background execution
just status-background
just status-logs
```

### Direct Python

```bash
# Basic usage
python3 formula-status/generate_formula_status.py

# With options
python3 formula-status/generate_formula_status.py \
  --output formula-status.md \
  --workers 20 \
  --verbose \
  --refresh
```

## Command Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--output` | Output file path | `formula-status.md` |
| `--workers` | Parallel workers | `20` |
| `--verbose` / `-v` | Enable verbose logging | `false` |
| `--refresh` | Ignore cache, refresh all stats | `false` |

## Automation

### GitHub Actions Workflow
- **File**: `.github/workflows/formula-status.yml`
- **Schedule**: Weekly (Monday 09:00 UTC)
- **Trigger**: Manual via GitHub Actions UI
- **Steps**:
  1. Checkout repo
  2. Set up Homebrew and Python
  3. Generate metadata with `GH_TOKEN`
  4. Commit changes if formula-status.md updated
  5. Push to repository

## Technical Details

### Regex Patterns for Platform Detection

```python
# GitHub
r'github\.com[/:]([^/]+)/([^/\s.]+)'

# GitLab
r'gitlab\.com[/:]([^/]+)/([^/\s.]+)'

# Codeberg
r'codeberg\.org[/:]([^/]+)/([^/\s.]+)'

# SourceHut
r'git\.sr\.ht[/:]~([^/]+)/([^/\s.]+)'
```

### Formula Metadata Extraction

Reads `.rb` files and extracts via regex:
- `desc "..."` → description
- `homepage "..."` → homepage URL
- `url "..."` → source URL
- `license "..."` → license identifier
- `bottle do` → has_bottle = True
- `livecheck do` → has_livecheck = True

### Error Handling
- Subprocess timeouts: 10 seconds per API call
- JSON parsing errors: Logged and cached as empty
- Missing formulas: Warning printed
- API failures: Logged, formula proceeds with no stats

## Performance

**Typical execution**: 3-5 minutes for 150 formulas
- Metadata extraction: ~10ms per formula
- GitHub stats (cached): ~100ms per formula
- GitHub stats (uncached): ~2-3s per formula
- GitLab/Codeberg stats: ~500ms per formula
- Parallel processing: 20 formulas at once

## Implementation History

### Initial Implementation (Removed)
- Brew check system with audit/style/readall
- Mode selection (fast/full)
- Complex check infrastructure
- Per-check status tracking (PASS/FAIL/N/A)

### User Feedback Evolution
1. **"Why do we need brew audit??"** → Questioned the brew check approach
2. **"We should skip it, we should purely leverage gh to do the stats page generation"** → Clarified pure git stats intent
3. **"The whole purpose is just do the github/codeberg/gitlab metadata crawling for formulae"** → Final clarification
4. **"We should remove unrelated stuff"** → Request for simplification
5. **"Should consider gitlab, codeberg, sourcehut as well"** → Multi-platform requirement

### Complete Rewrite
- Removed all brew subprocess calls (~250 LOC)
- Simplified from 600+ LOC to 370 LOC
- Changed from check-focused to metadata-focused
- Added multi-platform support (+178 LOC)
- Updated documentation to match new purpose

## File Organization

### Before Reorganization
```
scripts/
  └── generate_formula_status.py
docs/
  └── FORMULA_formula-status.md
```

### After Reorganization
```
formula-status/
  ├── generate_formula_status.py
  └── README.md
claudedocs/
  └── formula-metadata-system.md
```

## Related Files

- **Main script**: formula-status/generate_formula_status.py
- **Documentation**: formula-status/README.md
- **Justfile**: justfile (status-* commands)
- **Workflow**: .github/workflows/formula-status.yml
- **Cache**: .cache/formula_metadata.json
- **Output**: formula-status.md

## Troubleshooting

### Common Issues

**Missing stats for formulas**:
- Formula doesn't have recognized git hosting URL
- Check homepage/url fields in formula .rb file
- Platform may be rate-limited or down

**GitHub rate limiting**:
- Ensure `gh` CLI authenticated: `gh auth status`
- Use cached results (default)
- Run during off-peak hours

**Script appears stuck**:
- Use `--verbose` to see progress
- Check with `just status-check`
- Monitor with `just status-watch`

### Debug Tips

```bash
# Verbose execution
python3 formula-status/generate_formula_status.py --verbose

# Test single formula manually
python3 -c "from formula_status.generate_formula_status import FormulaCrawler; \
c = FormulaCrawler(verbose=True); \
c.process_formula('Formula/a/some-tool.rb')"

# Check cache contents
cat .cache/formula_metadata.json | jq '.'
```

## Future Enhancements

Potential improvements:
- [ ] Self-hosted GitLab/Gitea instance support
- [ ] Historical trend tracking (stars over time)
- [ ] Formula health scoring algorithm
- [ ] Integration with Homebrew analytics
- [ ] Multi-tap aggregation support
- [ ] Web dashboard UI
- [ ] Better SourceHut API integration (when available)
- [ ] Formula popularity badges
- [ ] Automated outdated formula detection

## Key Learnings

1. **User Intent Clarification**: Initial requirements evolved significantly through conversation
2. **Simplification > Complexity**: Complete rewrite was better than incremental patching
3. **Multi-Platform from Start**: Adding platform support upfront saves refactoring
4. **Output Buffering**: Always use `flush=True` for long-running scripts
5. **Cache Everything**: API rate limits are real, caching is essential
6. **Parallel by Default**: 20 workers provides good balance for I/O-bound operations

## Dependencies

**Python Standard Library**:
- `argparse`: Command-line argument parsing
- `json`: Cache file and API response handling
- `re`: Regex pattern matching for metadata extraction
- `subprocess`: External command execution (gh, curl)
- `concurrent.futures`: Parallel processing via ThreadPoolExecutor
- `dataclasses`: Data structure definitions
- `datetime`: Timestamp generation
- `pathlib`: File path handling
- `typing`: Type hints

**External Commands**:
- `gh`: GitHub CLI (required for GitHub repos)
- `curl`: HTTP requests (required for GitLab, Codeberg, SourceHut)
- `python3`: Python 3.x interpreter

## Contact

For questions or improvements:
- Open an issue on GitHub
- Check formula-status.md for formula-specific data
- Review GitHub Actions logs for CI failures
- Read formula-status/README.md for full documentation
