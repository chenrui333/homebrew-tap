# Formula Metadata Crawler Justfile
# Crawl formula metadata and git hosting stats (GitHub/GitLab/Codeberg)

# Default recipe - show help
default:
    @just --list

# Generate formula metadata report
status:
    python3 formula-status/generate_formula_status.py

# Generate with verbose logging
status-verbose:
    python3 formula-status/generate_formula_status.py --verbose

# Refresh git stats cache
status-refresh:
    python3 formula-status/generate_formula_status.py --refresh

# Run with custom number of workers
status-workers WORKERS="10":
    python3 formula-status/generate_formula_status.py --workers {{WORKERS}}

# Run in background with logging
status-background:
    #!/usr/bin/env bash
    nohup python3 formula-status/generate_formula_status.py --verbose > formula-status.log 2>&1 &
    echo "Crawler running in background (PID: $!)"
    echo "Follow logs with: just status-logs"

# Watch progress in real-time
status-watch:
    #!/usr/bin/env bash
    while true; do
        clear
        echo "=== Formula Metadata Crawler Progress ==="
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

            if [ -f .cache/formula_metadata.json ]; then
                echo ""
                echo "Cache:"
                CACHED=$(jq 'keys | length' .cache/formula_metadata.json 2>/dev/null || echo 0)
                echo "  Repos cached: $CACHED"
            fi
        else
            echo "✗ Not running"
            break
        fi

        echo ""
        echo "Press Ctrl+C to stop watching"
        sleep 2
    done

# Check if crawler is running
status-check:
    #!/usr/bin/env bash
    if pgrep -f "generate_formula_status.py" > /dev/null; then
        echo "✓ Formula metadata crawler is running"
        pgrep -f "generate_formula_status.py" | xargs ps -p
        echo ""
        if [ -f STATUS.md ]; then
            echo "STATUS.md:"
            echo "  Last modified: $(stat -f "%Sm" STATUS.md)"
            FORMULAS=$(grep -c '^| [a-z]' STATUS.md 2>/dev/null || echo 0)
            echo "  Formulas processed: $FORMULAS"
        fi
    else
        echo "✗ Formula metadata crawler is not running"
    fi

# Kill running crawler
status-kill:
    #!/usr/bin/env bash
    if pgrep -f "generate_formula_status.py" > /dev/null; then
        pkill -f "generate_formula_status.py"
        echo "✓ Killed formula metadata crawler"
    else
        echo "✗ No running crawler found"
    fi

# Follow logs
status-logs:
    #!/usr/bin/env bash
    if [ -f formula-status.log ]; then
        tail -f formula-status.log
    else
        echo "No log file found. Run 'just status-background' first."
    fi

# View generated report
view:
    cat STATUS.md

# Count formulas
count:
    #!/usr/bin/env bash
    if [ ! -f STATUS.md ]; then
        echo "STATUS.md not found. Run 'just status' first."
        exit 1
    fi
    TOTAL=$(grep -c '^| [a-z]' STATUS.md 2>/dev/null || echo 0)
    echo "Total formulas: $TOTAL"

# Show top formulas by stars
top N="10":
    #!/usr/bin/env bash
    if [ ! -f STATUS.md ]; then
        echo "STATUS.md not found. Run 'just status' first."
        exit 1
    fi
    echo "Top {{N}} formulas by stars:"
    grep '^| [a-z]' STATUS.md | head -{{N}}

# Clean cache
clean-cache:
    rm -rf .cache/formula_metadata.json
    @echo "Cache cleaned"

# Clean reports
clean-reports:
    rm -f STATUS.md
    @echo "Reports cleaned"

# Clean logs
clean-logs:
    rm -f formula-status.log nohup.out
    @echo "Logs cleaned"

# Clean everything
clean: clean-cache clean-reports clean-logs
    @echo "All artifacts cleaned"

# Validate generated report
validate:
    #!/usr/bin/env bash
    if [ ! -f STATUS.md ]; then
        echo "❌ STATUS.md not found"
        exit 1
    fi

    SIZE=$(wc -c < STATUS.md)
    if [ "$SIZE" -lt 500 ]; then
        echo "❌ STATUS.md seems too small ($SIZE bytes)"
        exit 1
    fi

    if ! grep -q "# Formula Metadata" STATUS.md; then
        echo "❌ Missing header"
        exit 1
    fi

    echo "✅ STATUS.md validation passed"
    echo "   Size: $SIZE bytes"
    FORMULAS=$(grep -c '^| [a-z]' STATUS.md 2>/dev/null || echo 0)
    echo "   Formulas: $FORMULAS"

# Example output
example:
    @echo "Example Formula Metadata Table:"
    @echo ""
    @echo "| Formula | Description | Stars | Forks | Last Commit | Last Release | License | Bottle | Livecheck | Homepage |"
    @echo "| ------- | ----------- | ----- | ----- | ----------- | ------------ | ------- | ------ | --------- | -------- |"
    @echo "| awesome-tool | An awesome CLI tool for developers | 1234 | 56 | 2024-12-10 | 2024-11-20 | MIT | ✓ | ✓ | [link](https://github.com/user/awesome-tool) |"
    @echo "| cool-app | A cool application | 567 | 23 | 2024-12-12 | - | Apache-2.0 | ✓ | - | [link](https://gitlab.com/user/cool-app) |"

# Install dependencies check
install-deps:
    @echo "Checking dependencies..."
    @which python3 > /dev/null || (echo "❌ python3 not found" && exit 1)
    @which gh > /dev/null || (echo "❌ gh CLI not found" && exit 1)
    @echo "✅ All dependencies installed"
