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

def _resolve_alias(formula_name: str, repo_root: Path) -> Optional[Path]:
    """If formula_name is an alias, resolve it to the real Formula path."""
    alias_path = repo_root / "Aliases" / formula_name
    try:
        if alias_path.exists():
            # Aliases in homebrew-core are symlinks
            target = os.readlink(alias_path)
            target_path = (repo_root / target).resolve()
            if target_path.exists():
                return target_path
    except OSError:
        pass
    return None

def find_formula_file(formula_name: str, formula_dir: Path) -> Optional[Path]:
    """
    Find the formula file for a given formula name across common Homebrew layouts.

    Accepts either:
      - repo root (…/homebrew-core), or
      - Formula dir (…/homebrew-core/Formula)
    """
    filename = f"{formula_name}.rb"

    # If user passed the repo root, derive useful subdirs
    repo_root = formula_dir
    formula_subdir = None
    if (formula_dir / "Formula").is_dir():
        # formula_dir is the repo root (contains Formula/)
        repo_root = formula_dir
        formula_subdir = formula_dir / "Formula"
    elif formula_dir.name == "Formula" and formula_dir.is_dir():
        # formula_dir is already the Formula directory
        repo_root = formula_dir.parent
        formula_subdir = formula_dir
    else:
        # Unknown structure; still try smart guesses below
        formula_subdir = None

    # 1) Preferred modern layout: Formula/<name>.rb
    if formula_subdir:
        p = formula_subdir / filename
        if p.exists():
            return p

        # 2) Older/variant layout: Formula/<first>/<name>.rb
        first_char = formula_name[0].lower()
        if first_char.isalpha():
            p = formula_subdir / first_char / filename
            if p.exists():
                return p

    # 3) If user pointed to repo root, try top-level <name>.rb (some taps do this)
    p = repo_root / filename
    if p.exists():
        return p

    # 4) Try <first>/<name>.rb directly under the provided dir (some taps)
    first_char = formula_name[0].lower()
    if first_char.isalpha():
        p = repo_root / first_char / filename
        if p.exists():
            return p

    # 5) Resolve aliases (homebrew-core has Aliases/<alias> symlinks)
    alias_target = _resolve_alias(formula_name, repo_root)
    if alias_target and alias_target.exists():
        return alias_target

    # 6) Last resort: recursive glob under Formula/ then repo root
    search_roots = []
    if formula_subdir:
        search_roots.append(formula_subdir)
    search_roots.append(repo_root)

    for root in search_roots:
        try:
            found = next(root.rglob(filename), None)
            if found:
                return found
        except Exception:
            # In case of permission or symlink loops—just skip
            pass

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
    parser.add_argument('--formula-dir', type=Path, default=Path('/opt/homebrew/Homebrew/Library/Taps/homebrew/homebrew-core'),
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
