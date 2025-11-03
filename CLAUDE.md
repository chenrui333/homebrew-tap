# Agent Guide for homebrew-tap

## Repository Overview

This is a [Homebrew tap](https://docs.brew.sh/Taps) maintained by chenrui333 containing additional formulae and casks that don't fit in `homebrew-core`. The tap includes:

- **Development tools** for various programming languages and frameworks
- **CLI utilities** for productivity and system management
- **MCP servers** (Model Context Protocol servers) for AI agent integration
- **Language servers** for code editors
- **Specialized tools** for DevOps, security, and data processing

## Repository Structure

```
.
├── Formula/                    # Homebrew formula definitions
│   ├── a/                      # Formulae starting with 'a'
│   ├── c/                      # Formulae starting with 'c'
│   ├── l/                      # Formulae starting with 'l'
│   └── ...                     # Other formula directories
├── .github/                    # GitHub workflows and configuration
├── docs/                       # Documentation files
├── patches/                    # Patches for formulas
├── scripts/                    # Utility scripts
├── README.md                   # Main repository documentation
├── tap_migrations.json         # Migration metadata for formulas
├── pypi_formula_mappings.json  # Mappings for PyPI packages
└── .typos.toml                 # Typo checking configuration
```

## Key Files and Their Purposes

### Formulas (`Formula/` directory)

Each formula is a Ruby file that defines:
- Package source URL and version
- Build dependencies and options
- Installation steps
- Tests
- Bottles (pre-built binaries)

Example structure of a formula file:
```ruby
class ToolName < Formula
  desc "Description of the tool"
  homepage "https://..."
  url "https://..."
  sha256 "..."

  depends_on "dependency"

  def install
    # Installation steps
  end

  test do
    # Test code
  end
end
```

### Configuration Files

- **`.typos.toml`** - Configuration for spell-checking tool
- **`pypi_formula_mappings.json`** - Maps PyPI package names to Homebrew formulas (used for updating Python-based tools)
- **`tap_migrations.json`** - Tracks formula name changes and deprecations

## Common Tasks

### Adding a New Formula

1. Create a new Ruby file in `Formula/` with the appropriate starting letter directory
2. Define the class inheriting from `Formula`
3. Set metadata: `desc`, `homepage`, `url`, `sha256`
4. Add dependencies if needed
5. Implement `install` and `test` methods
6. Submit a PR

### Updating an Existing Formula

1. Locate the formula file in `Formula/`
2. Update the `url` and `sha256` for the new version
3. Update dependencies if needed
4. Run `brew test` to verify
5. Commit and push

### Adding/Updating Bottles

Bottles are pre-built binaries for macOS. The repository uses:
- `--bottle-do-not-change-default-options` for consistency
- Multiple architecture support (Intel, ARM64)

### Working with MCP Servers

Many formulas in this tap are MCP servers that extend Claude's capabilities. When working with these:
- Check the upstream project for the latest version
- Verify the server's compatibility with Claude Code
- Include proper documentation in the formula description

## Common Patterns

### Python-Based Tools

For Python tools, the tap often provides options to use different Python versions:
```ruby
depends_on "python@3.12"
```

### Go-Based Tools

Go formulas typically:
- Use `ldflags` for version information
- Set build flags for optimization
- Include proper test commands

### Multi-Architecture Support

Bottles are built for:
- Intel macOS (`x86_64`)
- Apple Silicon (`arm64`)

## Testing and CI

The repository uses:
- GitHub Actions for continuous integration (workflows in `.github/`)
- Pre-commit hooks (`.pre-commit-config.yaml`)
- `brew test` command for local testing

## Important Conventions

1. **Formula Naming**: Use lowercase with hyphens (not underscores)
2. **SHA256 Checksums**: Always verify checksums match the upstream release
3. **Dependencies**: List all required dependencies; don't assume they're installed
4. **Tests**: Include meaningful tests; at minimum, verify the tool runs

## Troubleshooting

- **Build failures**: Check if dependencies are correctly specified
- **SHA256 mismatches**: Verify the download URL and checksum from upstream
- **Test failures**: Ensure the test properly validates the installed tool
- **Bottle-related issues**: Bottles may need to be rebuilt for new macOS versions

## Resources

- [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- [Homebrew Tap Documentation](https://docs.brew.sh/Taps)
- [Homebrew Bottles](https://docs.brew.sh/Bottles)
- Repository README: See `README.md` for the complete formula list

## Contributing

Issues and PRs are welcome. When contributing:
1. Follow the existing code style and conventions
2. Test locally with `brew install --build-from-source path/to/formula`
3. Provide clear PR descriptions
4. Reference any upstream projects or issues
