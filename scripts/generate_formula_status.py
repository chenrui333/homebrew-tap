#!/usr/bin/env python3
"""
Formula Status Generator for Homebrew Tap

Generates a STATUS.md page with per-formula health checks and GitHub stats.
Supports fast and full modes with configurable checks.
"""

import argparse
import json
import os
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Set


@dataclass
class CheckResult:
    """Result of a single check (audit, style, readall)"""
    name: str
    status: str  # PASS, FAIL, UNKNOWN
    message: str = ""  # Short failure message if FAIL


@dataclass
class GitHubStats:
    """GitHub repository statistics"""
    stars: Optional[int] = None
    forks: Optional[int] = None
    last_commit: Optional[str] = None  # YYYY-MM-DD
    last_release: Optional[str] = None  # YYYY-MM-DD


@dataclass
class FormulaStatus:
    """Complete status for a single formula"""
    name: str
    desc: str = ""
    homepage: str = ""
    url: str = ""
    license: str = ""
    has_bottle: bool = False
    has_livecheck: bool = False
    checks: List[CheckResult] = field(default_factory=list)
    github_stats: GitHubStats = field(default_factory=GitHubStats)

    @property
    def overall_status(self) -> str:
        """Derive overall status from individual checks"""
        if not self.checks:
            return "UNKNOWN"

        statuses = [c.status for c in self.checks]
        if "FAIL" in statuses:
            return "FAIL"
        elif "UNKNOWN" in statuses:
            return "UNKNOWN"
        elif all(s == "PASS" for s in statuses):
            return "PASS"
        return "UNKNOWN"

    def get_check_status(self, check_name: str) -> str:
        """Get status for a specific check"""
        for check in self.checks:
            if check.name == check_name:
                return check.status
        return "N/A"

    def get_notes(self) -> str:
        """Generate notes column content"""
        notes = []

        # Add license
        if self.license:
            notes.append(f"license: {self.license}")

        # Add bottle/livecheck info
        bottle_str = "yes" if self.has_bottle else "no"
        livecheck_str = "yes" if self.has_livecheck else "no"
        notes.append(f"bottle: {bottle_str}, livecheck: {livecheck_str}")

        # Add failure messages
        for check in self.checks:
            if check.status == "FAIL" and check.message:
                # Truncate message to ~160 chars
                msg = check.message[:160]
                if len(check.message) > 160:
                    msg += "..."
                notes.append(f"{check.name}: {msg}")

        return "; ".join(notes) if notes else "-"


class FormulaStatusGenerator:
    """Main class for generating formula status reports"""

    def __init__(self, tap_name: str, mode: str, checks: Set[str],
                 refresh_cache: bool, output_file: Path, workers: int = 20,
                 verbose: bool = False):
        self.tap_name = tap_name
        self.mode = mode
        self.enabled_checks = checks
        self.refresh_cache = refresh_cache
        self.output_file = output_file
        self.workers = workers
        self.verbose = verbose
        self.cache_file = Path(".cache/formula_status.json")
        self.github_cache: Dict = {}
        self._load_cache()

    def log(self, msg: str, force: bool = False):
        """Print log message if verbose or force"""
        if self.verbose or force:
            timestamp = datetime.now().strftime("%H:%M:%S")
            print(f"[{timestamp}] {msg}", flush=True)

    def _load_cache(self):
        """Load GitHub stats cache"""
        if not self.refresh_cache and self.cache_file.exists():
            try:
                with open(self.cache_file, 'r') as f:
                    self.github_cache = json.load(f)
                print(f"Loaded cache from {self.cache_file}")
            except Exception as e:
                print(f"Warning: Failed to load cache: {e}")
                self.github_cache = {}

    def _save_cache(self):
        """Save GitHub stats cache"""
        self.cache_file.parent.mkdir(parents=True, exist_ok=True)
        try:
            with open(self.cache_file, 'w') as f:
                json.dump(self.github_cache, f, indent=2)
            print(f"Saved cache to {self.cache_file}")
        except Exception as e:
            print(f"Warning: Failed to save cache: {e}")

    def find_formulas(self) -> List[Path]:
        """Find all formula files in the tap"""
        formula_dir = Path("Formula")
        if not formula_dir.exists():
            print(f"Error: Formula directory not found: {formula_dir}")
            return []

        formulas = []
        for letter_dir in sorted(formula_dir.iterdir()):
            if letter_dir.is_dir():
                formulas.extend(sorted(letter_dir.glob("*.rb")))

        # Also check root Formula/ directory
        formulas.extend(sorted(formula_dir.glob("*.rb")))

        return sorted(set(formulas))  # Remove duplicates

    def extract_metadata(self, formula_path: Path) -> Dict[str, str]:
        """Extract metadata from formula file"""
        metadata = {
            "desc": "",
            "homepage": "",
            "url": "",
            "license": "",
            "has_bottle": False,
            "has_livecheck": False,
        }

        try:
            with open(formula_path, 'r') as f:
                content = f.read()

            # Extract desc
            desc_match = re.search(r'desc\s+"([^"]+)"', content)
            if desc_match:
                metadata["desc"] = desc_match.group(1)

            # Extract homepage
            homepage_match = re.search(r'homepage\s+"([^"]+)"', content)
            if homepage_match:
                metadata["homepage"] = homepage_match.group(1)

            # Extract url
            url_match = re.search(r'url\s+"([^"]+)"', content)
            if url_match:
                metadata["url"] = url_match.group(1)

            # Extract license
            license_match = re.search(r'license\s+"([^"]+)"', content)
            if license_match:
                metadata["license"] = license_match.group(1)

            # Check for bottle block
            metadata["has_bottle"] = "bottle do" in content

            # Check for livecheck block
            metadata["has_livecheck"] = "livecheck do" in content

        except Exception as e:
            print(f"Warning: Failed to extract metadata from {formula_path}: {e}")

        return metadata

    def infer_github_repo(self, homepage: str, url: str) -> Optional[str]:
        """Infer GitHub repo (owner/repo) from homepage or url"""
        for link in [homepage, url]:
            if not link:
                continue

            # Match github.com/owner/repo patterns
            match = re.search(r'github\.com[/:]([^/]+)/([^/\s.]+)', link)
            if match:
                owner, repo = match.groups()
                # Clean up repo name (remove .git, etc.)
                repo = repo.replace('.git', '')
                return f"{owner}/{repo}"

        return None

    def fetch_github_stats(self, repo: str) -> GitHubStats:
        """Fetch GitHub stats using gh CLI (with caching)"""
        if repo in self.github_cache:
            cached = self.github_cache[repo]
            return GitHubStats(
                stars=cached.get("stars"),
                forks=cached.get("forks"),
                last_commit=cached.get("last_commit"),
                last_release=cached.get("last_release"),
            )

        stats = GitHubStats()

        try:
            # Fetch repo info
            result = subprocess.run(
                ["gh", "repo", "view", repo, "--json", "stargazerCount,forkCount,pushedAt"],
                capture_output=True,
                text=True,
                timeout=10,
            )

            if result.returncode == 0:
                data = json.loads(result.stdout)
                stats.stars = data.get("stargazerCount")
                stats.forks = data.get("forkCount")

                # Parse last commit date
                pushed_at = data.get("pushedAt")
                if pushed_at:
                    stats.last_commit = pushed_at.split("T")[0]  # YYYY-MM-DD

            # Fetch latest release
            result = subprocess.run(
                ["gh", "release", "view", "--repo", repo, "--json", "publishedAt"],
                capture_output=True,
                text=True,
                timeout=10,
            )

            if result.returncode == 0:
                data = json.loads(result.stdout)
                published_at = data.get("publishedAt")
                if published_at:
                    stats.last_release = published_at.split("T")[0]  # YYYY-MM-DD

        except Exception as e:
            print(f"Warning: Failed to fetch GitHub stats for {repo}: {e}")

        # Cache the results
        self.github_cache[repo] = {
            "stars": stats.stars,
            "forks": stats.forks,
            "last_commit": stats.last_commit,
            "last_release": stats.last_release,
        }

        return stats

    def run_check(self, check_name: str, formula_path: Path) -> CheckResult:
        """Run a single check (audit, style, or readall)"""
        formula_name = formula_path.stem

        try:
            if check_name == "audit":
                # Run brew audit
                strict_flag = "--strict" if self.mode == "full" else ""
                cmd = ["brew", "audit", "--formula"]
                if strict_flag:
                    cmd.append(strict_flag)
                cmd.append(formula_name)

                self.log(f"{formula_name}: Running {' '.join(cmd)}")

                result = subprocess.run(
                    cmd,
                    capture_output=True,
                    text=True,
                    timeout=60,
                )

                self.log(f"{formula_name}: audit completed (rc={result.returncode})")

                if result.returncode == 0:
                    return CheckResult(check_name, "PASS")
                else:
                    # Extract first line of error
                    msg = result.stdout.strip() or result.stderr.strip()
                    first_line = msg.split("\n")[0] if msg else "Unknown error"
                    return CheckResult(check_name, "FAIL", first_line)

            elif check_name == "style":
                # Run brew style
                result = subprocess.run(
                    ["brew", "style", str(formula_path)],
                    capture_output=True,
                    text=True,
                    timeout=30,
                )

                if result.returncode == 0:
                    return CheckResult(check_name, "PASS")
                else:
                    msg = result.stdout.strip() or result.stderr.strip()
                    first_line = msg.split("\n")[0] if msg else "Style violations"
                    return CheckResult(check_name, "FAIL", first_line)

            elif check_name == "readall":
                # Run brew readall for the tap
                result = subprocess.run(
                    ["brew", "readall", f"--tap={self.tap_name}"],
                    capture_output=True,
                    text=True,
                    timeout=60,
                )

                if result.returncode == 0:
                    return CheckResult(check_name, "PASS")
                else:
                    msg = result.stdout.strip() or result.stderr.strip()
                    # Check if this specific formula is mentioned in errors
                    if formula_name in msg:
                        first_line = msg.split("\n")[0] if msg else "Read error"
                        return CheckResult(check_name, "FAIL", first_line)
                    return CheckResult(check_name, "PASS")  # Not this formula's fault

            else:
                return CheckResult(check_name, "UNKNOWN", f"Unknown check: {check_name}")

        except subprocess.TimeoutExpired:
            return CheckResult(check_name, "UNKNOWN", "Timeout")
        except Exception as e:
            return CheckResult(check_name, "UNKNOWN", str(e))

    def process_formula(self, formula_path: Path) -> FormulaStatus:
        """Process a single formula and generate its status"""
        formula_name = formula_path.stem
        start_time = datetime.now()

        # Extract metadata
        metadata = self.extract_metadata(formula_path)

        # Run enabled checks
        checks = []
        for check_name in self.enabled_checks:
            check_start = datetime.now()
            check_result = self.run_check(check_name, formula_path)
            check_duration = (datetime.now() - check_start).total_seconds()
            checks.append(check_result)

        # Fetch GitHub stats
        github_stats = GitHubStats()
        github_repo = self.infer_github_repo(metadata["homepage"], metadata["url"])
        if github_repo:
            gh_start = datetime.now()
            github_stats = self.fetch_github_stats(github_repo)
            gh_duration = (datetime.now() - gh_start).total_seconds()

        duration = (datetime.now() - start_time).total_seconds()

        return FormulaStatus(
            name=formula_name,
            desc=metadata["desc"],
            homepage=metadata["homepage"],
            url=metadata["url"],
            license=metadata["license"],
            has_bottle=metadata["has_bottle"],
            has_livecheck=metadata["has_livecheck"],
            checks=checks,
            github_stats=github_stats,
        )

    def generate_report(self, statuses: List[FormulaStatus]) -> str:
        """Generate Markdown report"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC")

        # Calculate summary
        total = len(statuses)
        pass_count = sum(1 for s in statuses if s.overall_status == "PASS")
        fail_count = sum(1 for s in statuses if s.overall_status == "FAIL")
        unknown_count = sum(1 for s in statuses if s.overall_status == "UNKNOWN")

        # Sort: FAIL first, then by name
        statuses.sort(key=lambda s: (s.overall_status != "FAIL", s.name))

        lines = [
            "# Formula Status",
            "",
            f"Generated: {timestamp}",
            "",
            "## Summary",
            "",
            f"- **Total formulas**: {total}",
            f"- **Pass**: {pass_count}",
            f"- **Fail**: {fail_count}",
            f"- **Unknown**: {unknown_count}",
            "",
            "## Status Table",
            "",
        ]

        # Table header
        header = ["Formula", "Audit", "Style", "Readall", "Desc", "Stars",
                  "Forks", "Last commit", "Last release", "Homepage", "Notes"]
        separator = ["---"] * len(header)

        lines.append("| " + " | ".join(header) + " |")
        lines.append("| " + " | ".join(separator) + " |")

        # Table rows
        for status in statuses:
            row = [
                status.name,
                status.get_check_status("audit"),
                status.get_check_status("style"),
                status.get_check_status("readall"),
                status.desc[:50] + "..." if len(status.desc) > 50 else status.desc,
                str(status.github_stats.stars) if status.github_stats.stars else "-",
                str(status.github_stats.forks) if status.github_stats.forks else "-",
                status.github_stats.last_commit or "-",
                status.github_stats.last_release or "-",
                f"[link]({status.homepage})" if status.homepage else "-",
                status.get_notes(),
            ]
            lines.append("| " + " | ".join(row) + " |")

        return "\n".join(lines) + "\n"

    def run(self):
        """Main execution flow"""
        print(f"Formula Status Generator", flush=True)
        print(f"Tap: {self.tap_name}", flush=True)
        print(f"Mode: {self.mode}", flush=True)
        print(f"Checks: {', '.join(self.enabled_checks)}", flush=True)
        print(f"Workers: {self.workers}", flush=True)
        print(flush=True)

        # Find all formulas
        formulas = self.find_formulas()
        print(f"Found {len(formulas)} formulas", flush=True)

        if not formulas:
            print("No formulas found!", flush=True)
            return

        # Process formulas in parallel
        statuses = []
        print(f"\nProcessing formulas with {self.workers} parallel workers...", flush=True)

        with ThreadPoolExecutor(max_workers=self.workers) as executor:
            # Submit all formulas for processing
            future_to_formula = {
                executor.submit(self.process_formula, formula_path): formula_path
                for formula_path in formulas
            }

            # Collect results as they complete
            completed = 0
            for future in as_completed(future_to_formula):
                formula_path = future_to_formula[future]
                completed += 1

                try:
                    status = future.result()
                    statuses.append(status)
                    print(f"[{completed}/{len(formulas)}] ✓ {status.name}", flush=True)
                except Exception as e:
                    print(f"[{completed}/{len(formulas)}] ✗ {formula_path.stem}: {e}", flush=True)

        # Save GitHub cache
        self._save_cache()

        # Generate report
        report = self.generate_report(statuses)

        # Write output
        self.output_file.write_text(report)
        print(f"\nReport written to {self.output_file}", flush=True)


def detect_tap_name() -> str:
    """Auto-detect tap name from git remote or path"""
    try:
        # Try to get from git remote
        result = subprocess.run(
            ["git", "config", "--get", "remote.origin.url"],
            capture_output=True,
            text=True,
            timeout=5,
        )

        if result.returncode == 0:
            url = result.stdout.strip()
            # Parse owner/repo from GitHub URL
            match = re.search(r'github\.com[/:]([^/]+)/homebrew-([^/\s.]+)', url)
            if match:
                owner, tap = match.groups()
                return f"{owner}/{tap}"

    except Exception:
        pass

    # Default fallback
    return "chenrui333/tap"


def main():
    parser = argparse.ArgumentParser(
        description="Generate Formula Status report for Homebrew tap"
    )
    parser.add_argument(
        "--mode",
        choices=["fast", "full"],
        default="fast",
        help="Check mode: fast (lightweight) or full (strict)",
    )
    parser.add_argument(
        "--refresh",
        action="store_true",
        help="Ignore cache and refresh GitHub stats",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("STATUS.md"),
        help="Output file path (default: STATUS.md)",
    )
    parser.add_argument(
        "--tap",
        default=None,
        help="Tap name (e.g., chenrui333/tap). Auto-detected if not specified.",
    )
    parser.add_argument(
        "--checks",
        default="audit,style,readall",
        help="Comma-separated list of checks to run (audit,style,readall)",
    )
    parser.add_argument(
        "--workers",
        type=int,
        default=20,
        help="Number of parallel workers (default: 20)",
    )
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable verbose logging",
    )

    args = parser.parse_args()

    # Detect tap name if not specified
    tap_name = args.tap or detect_tap_name()

    # Parse checks
    enabled_checks = set(args.checks.split(","))

    # Skip style and readall in fast mode to speed things up
    if args.mode == "fast":
        # Keep audit only in fast mode by default
        enabled_checks = {"audit"}

    # Create generator and run
    generator = FormulaStatusGenerator(
        tap_name=tap_name,
        mode=args.mode,
        checks=enabled_checks,
        refresh_cache=args.refresh,
        output_file=args.output,
        workers=args.workers,
        verbose=args.verbose,
    )

    try:
        generator.run()
    except KeyboardInterrupt:
        print("\nInterrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\nError: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
