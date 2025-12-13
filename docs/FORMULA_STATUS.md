# Formula Status System

Automated health checking and monitoring for all formulas in this tap.

## Overview

The Formula Status system provides automated health checks for every formula in the tap, generating a comprehensive `STATUS.md` report with:

- **Per-formula health checks**: audit, style, and readall validation
- **Metadata extraction**: description, homepage, license, bottle, livecheck
- **GitHub statistics**: stars, forks, last commit, last release
- **Failure diagnostics**: clear error messages for failed checks

## Quick Start

### Local Usage

```bash
# Fast mode (audit only, recommended for quick checks)
python3 scripts/generate_formula_status.py

# Full mode (strict audit + style + readall)
python3 scripts/generate_formula_status.py --mode full

# Refresh GitHub stats cache
python3 scripts/generate_formula_status.py --refresh

# Custom output file
python3 scripts/generate_formula_status.py --output my-status.md

# Select specific checks
python3 scripts/generate_formula_status.py --checks audit,style
```

### CI/CD Integration

The system runs automatically:

- **Weekly**: Every Monday at 09:00 UTC
- **Manual**: Trigger from GitHub Actions UI
  - Go to Actions → Formula Status → Run workflow
  - Choose mode: `fast` or `full`

Changes are automatically committed to the repository.

## Command Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--mode` | Check mode: `fast` (audit only) or `full` (all checks) | `fast` |
| `--refresh` | Ignore cache and refresh GitHub stats | false |
| `--output` | Output file path | `STATUS.md` |
| `--tap` | Tap name (e.g., `chenrui333/tap`) | Auto-detected |
| `--checks` | Comma-separated checks to run | `audit,style,readall` |

## Check Types

### Audit Check

Runs `brew audit --formula` (or `--strict` in full mode) to verify:
- Formula syntax and structure
- Metadata completeness
- URL accessibility
- License information
- Best practices compliance

**Fast mode**: Basic audit checks
**Full mode**: Strict audit with additional validations

### Style Check

Runs `brew style` to verify:
- Ruby code style compliance
- RuboCop violations
- Formatting consistency

**Note**: Only enabled in full mode by default due to execution time.

### Readall Check

Runs `brew readall --tap=<tap>` to verify:
- Formula can be parsed without errors
- No Ruby syntax errors
- Dependencies are valid

**Note**: Only enabled in full mode by default.

## Output Format

The generated `STATUS.md` contains:

### Summary Section

```markdown
## Summary

- **Total formulas**: 150
- **Pass**: 145
- **Fail**: 3
- **Unknown**: 2
```

### Status Table

| Formula | Audit | Style | Readall | Desc | Stars | Forks | Last commit | Last release | Homepage | Notes |
|---------|-------|-------|---------|------|-------|-------|-------------|--------------|----------|-------|
| failing-tool | FAIL | PASS | PASS | A tool that fails | 42 | 7 | 2024-12-01 | 2024-11-15 | [link](https://...) | license: MIT; bottle: yes, livecheck: yes; audit: URL not accessible |
| passing-tool | PASS | PASS | PASS | A working tool | 100 | 20 | 2024-12-10 | 2024-12-05 | [link](https://...) | license: Apache-2.0; bottle: yes, livecheck: no |

**Table columns**:
1. **Formula**: Formula name
2. **Audit**: Audit check status (PASS/FAIL/N/A)
3. **Style**: Style check status (PASS/FAIL/N/A)
4. **Readall**: Readall check status (PASS/FAIL/N/A)
5. **Desc**: Short description (truncated to 50 chars)
6. **Stars**: GitHub stars count
7. **Forks**: GitHub forks count
8. **Last commit**: Last commit date (YYYY-MM-DD)
9. **Last release**: Last release date (YYYY-MM-DD)
10. **Homepage**: Link to project homepage
11. **Notes**: License, bottle/livecheck status, failure messages

**Sorting**: Failed formulas appear first, then sorted alphabetically.

## GitHub Stats Caching

GitHub API responses are cached in `.cache/formula_status.json` to:
- Avoid rate limiting
- Speed up subsequent runs
- Reduce API usage

Cache is automatically:
- **Loaded**: On script start (unless `--refresh` specified)
- **Updated**: When new repos are fetched
- **Saved**: After processing all formulas
- **Committed**: To repository for CI/CD reuse

Use `--refresh` to force-refresh all cached stats.

## Example Output

### Mock Table Header + 2 Rows

```markdown
| Formula | Audit | Style | Readall | Desc | Stars | Forks | Last commit | Last release | Homepage | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| broken-formula | FAIL | PASS | PASS | Tool with audit issues | 1234 | 56 | 2024-12-10 | 2024-11-20 | [link](https://github.com/user/broken-formula) | license: MIT; bottle: yes, livecheck: yes; audit: URL checksum mismatch |
| working-formula | PASS | PASS | PASS | Perfectly working tool | 5678 | 123 | 2024-12-12 | 2024-12-01 | [link](https://github.com/user/working-formula) | license: Apache-2.0; bottle: yes, livecheck: no |
```

## Requirements

- **Python 3**: For running the script
- **Homebrew**: For formula checks (`brew` command)
- **GitHub CLI**: For fetching repo stats (`gh` command)

All requirements are pre-installed in the GitHub Actions environment.

## Troubleshooting

### Common Issues

**Script fails to find formulas**:
- Ensure you're in the tap root directory
- Check that `Formula/` directory exists

**GitHub API rate limiting**:
- Use cached results (default behavior)
- Run during off-peak hours
- Use personal access token with higher limits

**Check timeouts**:
- Use `--mode fast` for quicker execution
- Disable slow checks with `--checks audit`

**Permission errors**:
- Ensure script is executable: `chmod +x scripts/generate_formula_status.py`

### Debug Mode

Enable verbose output by modifying the script:

```python
# Add at the top of main()
import logging
logging.basicConfig(level=logging.DEBUG)
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

**Fast mode** (~5-10 minutes for 150 formulas):
- Audit only
- Cached GitHub stats
- Parallel-friendly

**Full mode** (~15-30 minutes for 150 formulas):
- Strict audit
- Style checks
- Readall validation
- May require sequential processing

## Contributing

To improve the status system:

1. **Add new checks**: Modify `run_check()` method
2. **Enhance reporting**: Update `generate_report()` method
3. **Improve caching**: Extend cache schema
4. **Add metrics**: Track additional formula metadata

See `scripts/generate_formula_status.py` for implementation details.

## Future Enhancements

Planned improvements:

- [ ] Parallel check execution for speed
- [ ] Historical trend tracking
- [ ] Email notifications for failures
- [ ] Integration with Homebrew analytics
- [ ] Custom check definitions
- [ ] Multi-tap support
- [ ] Web dashboard UI

## Support

For issues or questions:
- Open an issue on GitHub
- Check existing STATUS.md for formula-specific issues
- Review GitHub Actions logs for CI failures
