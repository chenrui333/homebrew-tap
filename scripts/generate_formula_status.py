#!/usr/bin/env python3
"""
Formula Metadata Crawler for Homebrew Tap

Extracts formula metadata and fetches GitHub/GitLab/Codeberg stats.
Pure git hosting metadata - no brew checks.
"""

import argparse
import json
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional


@dataclass
class GitStats:
    """Git hosting statistics (GitHub/GitLab/Codeberg)"""
    stars: Optional[int] = None
    forks: Optional[int] = None
    last_commit: Optional[str] = None  # YYYY-MM-DD
    last_release: Optional[str] = None  # YYYY-MM-DD
    hosting: str = ""  # github, gitlab, codeberg, other


@dataclass
class FormulaInfo:
    """Formula metadata and git stats"""
    name: str
    desc: str = ""
    homepage: str = ""
    url: str = ""
    license: str = ""
    has_bottle: bool = False
    has_livecheck: bool = False
    git_stats: GitStats = None

    def __post_init__(self):
        if self.git_stats is None:
            self.git_stats = GitStats()


class FormulaCrawler:
    """Crawl formulas for metadata and git hosting stats"""

    def __init__(self, workers: int = 20, verbose: bool = False, refresh_cache: bool = False):
        self.workers = workers
        self.verbose = verbose
        self.refresh_cache = refresh_cache
        self.cache_file = Path(".cache/formula_metadata.json")
        self.cache: Dict = {}
        self._load_cache()

    def log(self, msg: str):
        """Print log message if verbose"""
        if self.verbose:
            timestamp = datetime.now().strftime("%H:%M:%S")
            print(f"[{timestamp}] {msg}", flush=True)

    def _load_cache(self):
        """Load git stats cache"""
        if not self.refresh_cache and self.cache_file.exists():
            try:
                with open(self.cache_file, 'r') as f:
                    self.cache = json.load(f)
                print(f"Loaded cache from {self.cache_file}", flush=True)
            except Exception as e:
                print(f"Warning: Failed to load cache: {e}", flush=True)
                self.cache = {}

    def _save_cache(self):
        """Save git stats cache"""
        self.cache_file.parent.mkdir(parents=True, exist_ok=True)
        try:
            with open(self.cache_file, 'w') as f:
                json.dump(self.cache, f, indent=2)
            print(f"Saved cache to {self.cache_file}", flush=True)
        except Exception as e:
            print(f"Warning: Failed to save cache: {e}", flush=True)

    def find_formulas(self) -> List[Path]:
        """Find all formula files"""
        formula_dir = Path("Formula")
        if not formula_dir.exists():
            return []

        formulas = []
        for letter_dir in sorted(formula_dir.iterdir()):
            if letter_dir.is_dir():
                formulas.extend(sorted(letter_dir.glob("*.rb")))

        # Also check root Formula/ directory
        formulas.extend(sorted(formula_dir.glob("*.rb")))

        return sorted(set(formulas))

    def extract_metadata(self, formula_path: Path) -> Dict:
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

            # Extract fields
            if match := re.search(r'desc\s+"([^"]+)"', content):
                metadata["desc"] = match.group(1)
            if match := re.search(r'homepage\s+"([^"]+)"', content):
                metadata["homepage"] = match.group(1)
            if match := re.search(r'url\s+"([^"]+)"', content):
                metadata["url"] = match.group(1)
            if match := re.search(r'license\s+"([^"]+)"', content):
                metadata["license"] = match.group(1)

            metadata["has_bottle"] = "bottle do" in content
            metadata["has_livecheck"] = "livecheck do" in content

        except Exception as e:
            self.log(f"Error extracting metadata from {formula_path}: {e}")

        return metadata

    def infer_git_repo(self, homepage: str, url: str) -> Optional[tuple]:
        """Infer git repo (hosting, owner, repo) from homepage or url"""
        for link in [homepage, url]:
            if not link:
                continue

            # GitHub
            if match := re.search(r'github\.com[/:]([^/]+)/([^/\s.]+)', link):
                owner, repo = match.groups()
                repo = repo.replace('.git', '')
                return ("github", owner, repo)

            # GitLab
            if match := re.search(r'gitlab\.com[/:]([^/]+)/([^/\s.]+)', link):
                owner, repo = match.groups()
                repo = repo.replace('.git', '')
                return ("gitlab", owner, repo)

            # Codeberg
            if match := re.search(r'codeberg\.org[/:]([^/]+)/([^/\s.]+)', link):
                owner, repo = match.groups()
                repo = repo.replace('.git', '')
                return ("codeberg", owner, repo)

        return None

    def fetch_github_stats(self, owner: str, repo: str) -> GitStats:
        """Fetch GitHub stats using gh CLI"""
        cache_key = f"github:{owner}/{repo}"

        if cache_key in self.cache:
            cached = self.cache[cache_key]
            return GitStats(
                stars=cached.get("stars"),
                forks=cached.get("forks"),
                last_commit=cached.get("last_commit"),
                last_release=cached.get("last_release"),
                hosting="github"
            )

        stats = GitStats(hosting="github")

        try:
            # Fetch repo info
            result = subprocess.run(
                ["gh", "repo", "view", f"{owner}/{repo}", "--json", "stargazerCount,forkCount,pushedAt"],
                capture_output=True,
                text=True,
                timeout=10,
            )

            if result.returncode == 0:
                data = json.loads(result.stdout)
                stats.stars = data.get("stargazerCount")
                stats.forks = data.get("forkCount")

                if pushed_at := data.get("pushedAt"):
                    stats.last_commit = pushed_at.split("T")[0]

            # Fetch latest release
            result = subprocess.run(
                ["gh", "release", "view", "--repo", f"{owner}/{repo}", "--json", "publishedAt"],
                capture_output=True,
                text=True,
                timeout=10,
            )

            if result.returncode == 0:
                data = json.loads(result.stdout)
                if published_at := data.get("publishedAt"):
                    stats.last_release = published_at.split("T")[0]

        except Exception as e:
            self.log(f"Error fetching GitHub stats for {owner}/{repo}: {e}")

        # Cache results
        self.cache[cache_key] = {
            "stars": stats.stars,
            "forks": stats.forks,
            "last_commit": stats.last_commit,
            "last_release": stats.last_release,
        }

        return stats

    def process_formula(self, formula_path: Path) -> FormulaInfo:
        """Process single formula"""
        formula_name = formula_path.stem
        self.log(f"Processing {formula_name}")

        # Extract metadata
        metadata = self.extract_metadata(formula_path)

        # Get git stats
        git_stats = GitStats()
        if repo_info := self.infer_git_repo(metadata["homepage"], metadata["url"]):
            hosting, owner, repo = repo_info

            if hosting == "github":
                git_stats = self.fetch_github_stats(owner, repo)
            # TODO: Add GitLab/Codeberg support if needed

        return FormulaInfo(
            name=formula_name,
            desc=metadata["desc"],
            homepage=metadata["homepage"],
            url=metadata["url"],
            license=metadata["license"],
            has_bottle=metadata["has_bottle"],
            has_livecheck=metadata["has_livecheck"],
            git_stats=git_stats,
        )

    def generate_report(self, formulas: List[FormulaInfo]) -> str:
        """Generate Markdown report"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC")

        # Sort by stars (descending), then name
        formulas.sort(key=lambda f: (-(f.git_stats.stars or 0), f.name))

        lines = [
            "# Formula Metadata",
            "",
            f"Generated: {timestamp}",
            f"Total formulas: {len(formulas)}",
            "",
            "## Formulas",
            "",
            "| Formula | Description | Stars | Forks | Last Commit | Last Release | License | Bottle | Livecheck | Homepage |",
            "| ------- | ----------- | ----- | ----- | ----------- | ------------ | ------- | ------ | --------- | -------- |",
        ]

        for formula in formulas:
            desc = formula.desc[:60] + "..." if len(formula.desc) > 60 else formula.desc
            row = [
                formula.name,
                desc,
                str(formula.git_stats.stars) if formula.git_stats.stars else "-",
                str(formula.git_stats.forks) if formula.git_stats.forks else "-",
                formula.git_stats.last_commit or "-",
                formula.git_stats.last_release or "-",
                formula.license or "-",
                "✓" if formula.has_bottle else "-",
                "✓" if formula.has_livecheck else "-",
                f"[link]({formula.homepage})" if formula.homepage else "-",
            ]
            lines.append("| " + " | ".join(row) + " |")

        return "\n".join(lines) + "\n"

    def run(self, output_file: Path):
        """Main execution"""
        print("Formula Metadata Crawler", flush=True)
        print(f"Workers: {self.workers}", flush=True)
        print(flush=True)

        # Find formulas
        formulas = self.find_formulas()
        print(f"Found {len(formulas)} formulas", flush=True)

        if not formulas:
            print("No formulas found!", flush=True)
            return

        # Process formulas in parallel
        results = []
        print(f"\nProcessing with {self.workers} parallel workers...", flush=True)

        with ThreadPoolExecutor(max_workers=self.workers) as executor:
            future_to_formula = {
                executor.submit(self.process_formula, fp): fp
                for fp in formulas
            }

            completed = 0
            for future in as_completed(future_to_formula):
                formula_path = future_to_formula[future]
                completed += 1

                try:
                    result = future.result()
                    results.append(result)
                    print(f"[{completed}/{len(formulas)}] ✓ {result.name}", flush=True)
                except Exception as e:
                    print(f"[{completed}/{len(formulas)}] ✗ {formula_path.stem}: {e}", flush=True)

        # Save cache
        self._save_cache()

        # Generate report
        report = self.generate_report(results)

        # Write output
        output_file.write_text(report)
        print(f"\nReport written to {output_file}", flush=True)


def main():
    parser = argparse.ArgumentParser(
        description="Crawl formula metadata and git hosting stats"
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("STATUS.md"),
        help="Output file (default: STATUS.md)",
    )
    parser.add_argument(
        "--workers",
        type=int,
        default=20,
        help="Parallel workers (default: 20)",
    )
    parser.add_argument(
        "--refresh",
        action="store_true",
        help="Refresh cache",
    )
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Verbose logging",
    )

    args = parser.parse_args()

    crawler = FormulaCrawler(
        workers=args.workers,
        verbose=args.verbose,
        refresh_cache=args.refresh,
    )

    try:
        crawler.run(args.output)
    except KeyboardInterrupt:
        print("\nInterrupted", flush=True)
        sys.exit(1)
    except Exception as e:
        print(f"\nError: {e}", flush=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
