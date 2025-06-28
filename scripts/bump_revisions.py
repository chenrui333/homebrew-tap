#!/usr/bin/env python3
"""
Script to bump revisions for Homebrew formulae.
If a formula has revision x, bump it to x + 1.
If it doesn't have a revision field, add revision 1.

Usage:
    cat <formulae_list.txt> | ./bump_revisions.py
"""

import os
import re
import sys
from pathlib import Path
from typing import List, Optional, Tuple


def find_formula_file(formula_name: str, formula_dir: Path) -> Optional[Path]:
    """Find the formula file for a given formula name."""
    # Handle versioned formulae (e.g., percona-xtrabackup@8.0)
    if "@" in formula_name:
        filename = f"{formula_name}.rb"
    else:
        filename = f"{formula_name}.rb"

    # Search in alphabetical subdirectories
    first_char = formula_name[0].lower()
    if first_char.isalpha():
        formula_path = formula_dir / first_char / filename
        if formula_path.exists():
            return formula_path

    # Also check lib/ directory for some formulae
    lib_path = formula_dir / "lib" / filename
    if lib_path.exists():
        return lib_path

    # Direct search in Formula directory
    direct_path = formula_dir / filename
    if direct_path.exists():
        return direct_path

    return None


def parse_formula_content(content: str) -> Tuple[List[str], Optional[int], Optional[int]]:
    """
    Parse formula content and return lines, current revision, and line number.
    Returns (lines, current_revision, revision_line_index)
    """
    lines = content.splitlines()
    current_revision = None
    revision_line_index = None

    # Look for revision line
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith('revision '):
            # Extract revision number
            match = re.match(r'revision\s+(\d+)', stripped)
            if match:
                current_revision = int(match.group(1))
                revision_line_index = i
                break

    return lines, current_revision, revision_line_index


def find_insertion_point(lines: List[str]) -> int:
    """
    Find the best place to insert a new revision line.
    Should be after license but before head/bottle/dependencies.
    """
    license_line = None
    head_line = None
    bottle_line = None
    depends_on_line = None

    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith('license '):
            license_line = i
        elif stripped.startswith('head '):
            head_line = i
        elif stripped.startswith('bottle do'):
            bottle_line = i
        elif stripped.startswith('depends_on '):
            depends_on_line = i

    # Insert after license if it exists
    if license_line is not None:
        return license_line + 1

    # Otherwise, insert before the first of head/bottle/depends_on
    candidates = [x for x in [head_line, bottle_line, depends_on_line] if x is not None]
    if candidates:
        return min(candidates)

    # Fallback: insert after the class declaration and basic info
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith('sha256 ') and not stripped.startswith('sha256 cellar:'):
            return i + 1

    # Last resort: insert after URL
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith('url '):
            return i + 1

    return 1  # Very last resort


def bump_formula_revision(formula_path: Path, dry_run: bool = False) -> bool:
    """
    Bump the revision of a formula file.
    Returns True if changes were made, False otherwise.
    """
    try:
        content = formula_path.read_text()
        lines, current_revision, revision_line_index = parse_formula_content(content)

        if current_revision is not None:
            # Bump existing revision
            new_revision = current_revision + 1
            indent = '  '  # Standard Homebrew indentation
            new_line = f"{indent}revision {new_revision}"
            lines[revision_line_index] = new_line

            print(f"  Bumping revision from {current_revision} to {new_revision}")
        else:
            # Add new revision
            insertion_point = find_insertion_point(lines)
            indent = '  '  # Standard Homebrew indentation
            new_line = f"{indent}revision 1"
            lines.insert(insertion_point, new_line)

            print(f"  Adding revision 1")

        if not dry_run:
            new_content = '\n'.join(lines) + '\n'
            formula_path.write_text(new_content)

        return True

    except Exception as e:
        print(f"  Error processing {formula_path}: {e}")
        return False


def main():
    """Main function to process formulae."""
    import argparse

    parser = argparse.ArgumentParser(description='Bump revisions for Homebrew formulae')
    parser.add_argument('formulae', nargs='*', help='Formula names to bump (if none provided, reads from stdin)')
    parser.add_argument('--dry-run', action='store_true', help='Show what would be done without making changes')
    parser.add_argument('--formula-dir', type=Path, default=Path('/opt/homebrew/Library/Taps/homebrew/homebrew-core/Formula'),
                       help='Path to Formula directory')

    args = parser.parse_args()

    # Get formula names
    if args.formulae:
        formula_names = args.formulae
    else:
        # Read from stdin (e.g., from your brew linkage commands)
        formula_names = []
        for line in sys.stdin:
            line = line.strip()
            if line.startswith('brew linkage --test '):
                formula_name = line.replace('brew linkage --test ', '')
                formula_names.append(formula_name)
            elif line and not line.startswith('#'):
                # Direct formula name
                formula_names.append(line)

    if not formula_names:
        print("No formulae specified. Provide them as arguments or pipe them to stdin.")
        return 1

    if not args.formula_dir.exists():
        print(f"Formula directory not found: {args.formula_dir}")
        return 1

    print(f"Processing {len(formula_names)} formulae...")
    if args.dry_run:
        print("DRY RUN - No changes will be made")
    print()

    success_count = 0
    total_count = 0

    for formula_name in formula_names:
        total_count += 1
        print(f"Processing {formula_name}...")

        formula_path = find_formula_file(formula_name, args.formula_dir)
        if not formula_path:
            print(f"  Formula file not found for {formula_name}")
            continue

        if bump_formula_revision(formula_path, args.dry_run):
            success_count += 1
        print()

    print(f"Successfully processed {success_count}/{total_count} formulae")
    return 0 if success_count == total_count else 1


if __name__ == '__main__':
    sys.exit(main())
