# Formula Status Management Justfile
# Quick commands for generating and managing formula status reports

# Default recipe - show help
default:
    @just --list

# Generate formula status with metadata + GitHub stats only (fastest, no brew checks)
status:
    python3 scripts/generate_formula_status.py --no-checks

# Generate formula status with brew audit checks
status-with-checks:
    python3 scripts/generate_formula_status.py --mode fast

# Generate formula status with verbose logging (metadata + GitHub only)
status-verbose:
    python3 scripts/generate_formula_status.py --no-checks --verbose

# Generate formula status with brew audit checks (verbose)
status-with-checks-verbose:
    python3 scripts/generate_formula_status.py --mode fast --verbose

# Generate formula status in full mode (all checks: audit, style, readall)
status-full:
    python3 scripts/generate_formula_status.py --mode full

# Generate formula status in full mode with verbose logging
status-full-verbose:
    python3 scripts/generate_formula_status.py --mode full --verbose

# Refresh GitHub stats cache (no checks)
status-refresh:
    python3 scripts/generate_formula_status.py --no-checks --refresh

# Run with custom number of workers (no checks)
status-workers WORKERS="10":
    python3 scripts/generate_formula_status.py --no-checks --workers {{WORKERS}}

# Run specific checks only (e.g., just status-checks audit,style)
status-checks CHECKS="audit":
    python3 scripts/generate_formula_status.py --checks {{CHECKS}}

# Run on a small sample for testing (first 10 formulas)
status-sample:
    #!/usr/bin/env bash
    set -euo pipefail
    # Create temp dir with sample formulas
    mkdir -p /tmp/test-formulas/Formula/a
    find Formula/a -name "*.rb" | head -10 | xargs -I {} cp {} /tmp/test-formulas/Formula/a/
    cd /tmp/test-formulas
    python3 ../../scripts/generate_formula_status.py --mode fast --output SAMPLE-STATUS.md
    cat SAMPLE-STATUS.md

# View generated status report
view:
    cat STATUS.md

# View status summary only
summary:
    awk '/## Summary/,/## Status Table/' STATUS.md

# Count formulas by status
count:
    #!/usr/bin/env bash
    if [ ! -f STATUS.md ]; then
        echo "STATUS.md not found. Run 'just status' first."
        exit 1
    fi
    echo "Formula Status Count:"
    echo "===================="
    grep "| PASS |" STATUS.md | wc -l | xargs echo "PASS:"
    grep "| FAIL |" STATUS.md | wc -l | xargs echo "FAIL:"
    grep "| UNKNOWN |" STATUS.md | wc -l | xargs echo "UNKNOWN:"

# Show failed formulas only
failed:
    #!/usr/bin/env bash
    if [ ! -f STATUS.md ]; then
        echo "STATUS.md not found. Run 'just status' first."
        exit 1
    fi
    echo "Failed Formulas:"
    echo "================"
    grep "| FAIL |" STATUS.md

# Clean cache
clean-cache:
    rm -rf .cache/formula_status.json
    @echo "Cache cleaned"

# Clean generated reports
clean-reports:
    rm -f STATUS.md
    @echo "Reports cleaned"

# Clean everything
clean: clean-cache clean-reports
    @echo "All artifacts cleaned"

# Run in background with logging (metadata + GitHub only, fast)
status-background:
    #!/usr/bin/env bash
    nohup python3 scripts/generate_formula_status.py --no-checks --verbose > formula-status.log 2>&1 &
    echo "Status generation running in background (PID: $!)"
    echo "Follow logs with: tail -f formula-status.log"

# Run in background with brew checks
status-background-with-checks:
    #!/usr/bin/env bash
    nohup python3 scripts/generate_formula_status.py --mode fast --verbose > formula-status.log 2>&1 &
    echo "Status generation running in background (PID: $!)"
    echo "Follow logs with: tail -f formula-status.log"

# Check if status generation is running
status-check:
    #!/usr/bin/env bash
    if pgrep -f "generate_formula_status.py" > /dev/null; then
        echo "✓ Formula status generation is running"
        pgrep -f "generate_formula_status.py" | xargs ps -p
        echo ""
        echo "Check STATUS.md for partial results:"
        if [ -f STATUS.md ]; then
            echo "  Last modified: $(stat -f "%Sm" STATUS.md)"
            echo "  Size: $(wc -c < STATUS.md) bytes"
            FORMULAS=$(grep -c '^| [a-z]' STATUS.md 2>/dev/null || echo 0)
            echo "  Formulas processed so far: $FORMULAS"
        fi
    else
        echo "✗ Formula status generation is not running"
    fi

# Kill running status generation
status-kill:
    #!/usr/bin/env bash
    if pgrep -f "generate_formula_status.py" > /dev/null; then
        pkill -f "generate_formula_status.py"
        echo "✓ Killed formula status generation"
    else
        echo "✗ No running formula status generation found"
    fi

# Watch progress in real-time (refreshes every 2 seconds)
status-watch:
    #!/usr/bin/env bash
    while true; do
        clear
        echo "=== Formula Status Progress ==="
        echo ""
        date
        echo ""

        if pgrep -f "generate_formula_status.py" > /dev/null; then
            echo "✓ Running"
            echo ""

            if [ -f STATUS.md ]; then
                echo "STATUS.md:"
                echo "  Last modified: $(stat -f "%Sm" STATUS.md)"
                echo "  Size: $(wc -c < STATUS.md) bytes"
                FORMULAS=$(grep -c '^| [a-z]' STATUS.md 2>/dev/null || echo 0)
                echo "  Formulas processed: $FORMULAS"
            fi

            if [ -f .cache/formula_status.json ]; then
                echo ""
                echo "Cache:"
                CACHED=$(jq 'keys | length' .cache/formula_status.json 2>/dev/null || echo 0)
                echo "  GitHub repos cached: $CACHED"
            fi
        else
            echo "✗ Not running"
            break
        fi

        echo ""
        echo "Press Ctrl+C to stop watching"
        sleep 2
    done

# Follow status generation logs
status-logs:
    #!/usr/bin/env bash
    if [ -f formula-status.log ]; then
        tail -f formula-status.log
    else
        echo "No log file found. Run 'just status-background' first."
        echo ""
        echo "Or if running directly, redirect output:"
        echo "  python3 scripts/generate_formula_status.py --verbose > formula-status.log 2>&1"
    fi

# Test the script on a single formula
test-formula FORMULA:
    #!/usr/bin/env bash
    brew audit --formula {{FORMULA}}

# Validate the generated STATUS.md
validate:
    #!/usr/bin/env bash
    if [ ! -f STATUS.md ]; then
        echo "❌ STATUS.md not found"
        exit 1
    fi

    echo "Validating STATUS.md..."

    # Check file size
    SIZE=$(wc -c < STATUS.md)
    if [ "$SIZE" -lt 1000 ]; then
        echo "❌ STATUS.md seems too small ($SIZE bytes)"
        exit 1
    fi

    # Check for required sections
    if ! grep -q "## Summary" STATUS.md; then
        echo "❌ Missing Summary section"
        exit 1
    fi

    if ! grep -q "## Status Table" STATUS.md; then
        echo "❌ Missing Status Table section"
        exit 1
    fi

    echo "✅ STATUS.md validation passed"
    echo "   Size: $SIZE bytes"
    echo "   Formulas: $(grep -c '^|' STATUS.md | xargs echo)"

# Compare with previous status (requires git)
diff-status:
    #!/usr/bin/env bash
    if [ ! -f STATUS.md ]; then
        echo "STATUS.md not found"
        exit 1
    fi
    git diff HEAD STATUS.md || echo "No differences or not in git"

# Show example mock output
example:
    @echo "Example Formula Status Table:"
    @echo ""
    @echo "| Formula | Audit | Style | Readall | Desc | Stars | Forks | Last commit | Last release | Homepage | Notes |"
    @echo "| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |"
    @echo "| broken-formula | FAIL | PASS | PASS | Tool with audit issues | 1234 | 56 | 2024-12-10 | 2024-11-20 | [link](https://github.com/user/broken) | license: MIT; bottle: yes, livecheck: yes; audit: URL checksum mismatch |"
    @echo "| working-formula | PASS | PASS | PASS | Perfectly working tool | 5678 | 123 | 2024-12-12 | 2024-12-01 | [link](https://github.com/user/working) | license: Apache-2.0; bottle: yes, livecheck: no |"

# Install dependencies (if needed)
install-deps:
    @echo "Checking dependencies..."
    @which python3 > /dev/null || (echo "❌ python3 not found" && exit 1)
    @which brew > /dev/null || (echo "❌ brew not found" && exit 1)
    @which gh > /dev/null || (echo "❌ gh not found" && exit 1)
    @echo "✅ All dependencies installed"
