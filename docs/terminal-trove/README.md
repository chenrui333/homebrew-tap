# Awesome Tools Collection

This directory contains curated lists and utilities for discovering and tracking awesome tools.

## Terminal Trove Weekly Tools

The `scrape_terminal_trove.py` script automatically scrapes [Terminal Trove](https://terminaltrove.com/new/) and generates a markdown file with new terminal tools organized by week.

### Usage

Run the scraper to generate/update the tools list:

```bash
python3 scrape_terminal_trove.py
```

This will create `terminal_trove_weekly.md` containing all new tools from Terminal Trove.

## Files

- `scrape_terminal_trove.py` - Main scraper script
- `terminal_trove_weekly.md` - Generated weekly tools list (auto-generated)
- `README.md` - This file
