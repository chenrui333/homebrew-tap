#!/usr/bin/env python3
"""
Formula Metadata Crawler for Homebrew Tap

Extracts formula metadata and fetches git hosting stats from:
- GitHub (via gh CLI)
- GitLab (via API)
- Codeberg (via Forgejo API)
- SourceHut (limited support)

Pure git hosting metadata - no brew checks.
"""

import argparse
import json
import re
import subprocess
import sys
from urllib.parse import quote, unquote
from urllib.request import urlopen
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from datetime import UTC, datetime
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
    livecheck_mode: str = "default"
    git_stats: GitStats = None

    def __post_init__(self):
        if self.git_stats is None:
            self.git_stats = GitStats()


class FormulaCrawler:
    """Crawl formulas for metadata and git hosting stats"""

    NPM_REPO_OVERRIDES: Dict[str, Optional[str]] = {
        "@google/jules": None,
    }

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
            # Keep cache output deterministic for stable diffs across runs.
            normalized_cache = {}
            for cache_key in sorted(self.cache):
                cached = self.cache.get(cache_key) or {}
                if cache_key.startswith("npm:"):
                    normalized_cache[cache_key] = {
                        "repo": cached.get("repo"),
                    }
                    continue

                normalized_cache[cache_key] = {
                    "forks": cached.get("forks"),
                    "last_commit": cached.get("last_commit"),
                    "last_release": cached.get("last_release"),
                    "stars": cached.get("stars"),
                }
            with open(self.cache_file, 'w') as f:
                json.dump(normalized_cache, f, indent=2, sort_keys=True)
                f.write("\n")
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
            "livecheck_mode": "default",
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
            if match := re.search(r"^  license[ \t]+(\S[^\n]*)", content, re.M):
                metadata["license"] = match.group(1).strip().removeprefix('"').removesuffix('"')

            metadata["has_bottle"] = "bottle do" in content
            if match := re.search(r"^  livecheck do\n(.*?)^  end\b", content, re.M | re.S):
                metadata["livecheck_mode"] = (
                    "skip" if re.search(r"^    skip\b", match.group(1), re.M) else "explicit"
                )

        except Exception as e:
            raise ValueError(f"Cannot extract metadata from {formula_path}") from e

        return metadata

    def infer_git_repo_from_links(self, links: List[str]) -> Optional[tuple]:
        """Infer git repo (hosting, owner, repo) from candidate links"""
        for link in links:
            if not link:
                continue

            # GitHub
            if match := re.search(r'github\.com[/:]([^/]+)/([^/\s?#]+)', link):
                owner, repo = match.groups()
                repo = repo.removesuffix(".git")
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

            # SourceHut
            if match := re.search(r'git\.sr\.ht[/:]~([^/]+)/([^/\s.]+)', link):
                owner, repo = match.groups()
                repo = repo.replace('.git', '')
                return ("sourcehut", owner, repo)

        return None

    def repo_info_to_cache_key(self, repo_info: tuple) -> str:
        """Convert a git repo tuple to the cache key used for stats"""
        hosting, owner, repo = repo_info
        return f"{hosting}:{owner}/{repo}"

    def repo_info_from_cache_key(self, cache_key: str) -> Optional[tuple]:
        """Convert a cached repo key back to a git repo tuple"""
        if match := re.match(r'^(github|gitlab|codeberg|sourcehut):([^/]+)/(.+)$', cache_key):
            hosting, owner, repo = match.groups()
            return (hosting, owner, repo)

        return None

    def infer_npm_git_repo(self, url: str) -> Optional[tuple]:
        """Infer git repo from npm package metadata for registry tarball URLs"""
        if not url:
            return None

        match = re.search(r'registry\.npmjs\.org/((?:@[^/]+/)?[^/]+)/', url)
        if not match:
            return None

        package_name = unquote(match.group(1))
        cache_key = f"npm:{package_name}"

        if package_name in self.NPM_REPO_OVERRIDES:
            cached_repo = self.NPM_REPO_OVERRIDES[package_name]
            self.cache[cache_key] = {"repo": cached_repo}
            if cached_repo:
                return self.repo_info_from_cache_key(cached_repo)
            return None

        if cached_repo := (self.cache.get(cache_key) or {}).get("repo"):
            if repo_info := self.repo_info_from_cache_key(cached_repo):
                return repo_info

        try:
            result = subprocess.run(
                ["curl", "-sL", f"https://registry.npmjs.org/{quote(package_name, safe='')}"],
                capture_output=True,
                text=True,
                timeout=10,
            )
            if result.returncode != 0:
                return None

            data = json.loads(result.stdout)
            repository = data.get("repository")
            repo_url = repository.get("url") if isinstance(repository, dict) else repository
            bugs = data.get("bugs")
            bugs_url = bugs.get("url") if isinstance(bugs, dict) else None

            repo_info = self.infer_git_repo_from_links([
                repo_url,
                data.get("homepage"),
                bugs_url,
            ])
            if repo_info:
                self.cache[cache_key] = {"repo": self.repo_info_to_cache_key(repo_info)}

            return repo_info
        except Exception as e:
            self.log(f"Error inferring npm repo for {package_name}: {e}")
            return None

    def infer_git_repo(self, homepage: str, url: str) -> Optional[tuple]:
        """Infer git repo (hosting, owner, repo) from homepage, url, or package metadata"""
        return self.infer_git_repo_from_links([homepage, url]) or self.infer_npm_git_repo(url)

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

    def fetch_gitlab_stats(self, owner: str, repo: str) -> GitStats:
        """Fetch GitLab stats using API"""
        cache_key = f"gitlab:{owner}/{repo}"

        if cache_key in self.cache:
            cached = self.cache[cache_key]
            return GitStats(
                stars=cached.get("stars"),
                forks=cached.get("forks"),
                last_commit=cached.get("last_commit"),
                last_release=cached.get("last_release"),
                hosting="gitlab"
            )

        stats = GitStats(hosting="gitlab")

        try:
            # Fetch project info
            result = subprocess.run(
                ["curl", "-s", f"https://gitlab.com/api/v4/projects/{owner}%2F{repo}"],
                capture_output=True,
                text=True,
                timeout=10,
            )

            if result.returncode == 0:
                data = json.loads(result.stdout)
                stats.stars = data.get("star_count")
                stats.forks = data.get("forks_count")

                if last_activity := data.get("last_activity_at"):
                    stats.last_commit = last_activity.split("T")[0]

            # Fetch latest release
            result = subprocess.run(
                ["curl", "-s", f"https://gitlab.com/api/v4/projects/{owner}%2F{repo}/releases"],
                capture_output=True,
                text=True,
                timeout=10,
            )

            if result.returncode == 0:
                releases = json.loads(result.stdout)
                if releases and len(releases) > 0:
                    stats.last_release = releases[0].get("released_at", "").split("T")[0]

        except Exception as e:
            self.log(f"Error fetching GitLab stats for {owner}/{repo}: {e}")

        # Cache results
        self.cache[cache_key] = {
            "stars": stats.stars,
            "forks": stats.forks,
            "last_commit": stats.last_commit,
            "last_release": stats.last_release,
        }

        return stats

    def fetch_codeberg_stats(self, owner: str, repo: str) -> GitStats:
        """Fetch Codeberg stats using Forgejo/Gitea API"""
        cache_key = f"codeberg:{owner}/{repo}"

        if cache_key in self.cache:
            cached = self.cache[cache_key]
            return GitStats(
                stars=cached.get("stars"),
                forks=cached.get("forks"),
                last_commit=cached.get("last_commit"),
                last_release=cached.get("last_release"),
                hosting="codeberg"
            )

        stats = GitStats(hosting="codeberg")

        try:
            # Fetch repo info
            result = subprocess.run(
                ["curl", "-s", f"https://codeberg.org/api/v1/repos/{owner}/{repo}"],
                capture_output=True,
                text=True,
                timeout=10,
            )

            if result.returncode == 0:
                data = json.loads(result.stdout)
                stats.stars = data.get("stars_count")
                stats.forks = data.get("forks_count")

                if updated_at := data.get("updated_at"):
                    stats.last_commit = updated_at.split("T")[0]

            # Fetch latest release
            result = subprocess.run(
                ["curl", "-s", f"https://codeberg.org/api/v1/repos/{owner}/{repo}/releases"],
                capture_output=True,
                text=True,
                timeout=10,
            )

            if result.returncode == 0:
                releases = json.loads(result.stdout)
                if releases and len(releases) > 0:
                    stats.last_release = releases[0].get("published_at", "").split("T")[0]

        except Exception as e:
            self.log(f"Error fetching Codeberg stats for {owner}/{repo}: {e}")

        # Cache results
        self.cache[cache_key] = {
            "stars": stats.stars,
            "forks": stats.forks,
            "last_commit": stats.last_commit,
            "last_release": stats.last_release,
        }

        return stats

    def fetch_sourcehut_stats(self, owner: str, repo: str) -> GitStats:
        """Fetch SourceHut stats using API"""
        cache_key = f"sourcehut:{owner}/{repo}"

        if cache_key in self.cache:
            cached = self.cache[cache_key]
            return GitStats(
                stars=cached.get("stars"),
                forks=cached.get("forks"),
                last_commit=cached.get("last_commit"),
                last_release=cached.get("last_release"),
                hosting="sourcehut"
            )

        stats = GitStats(hosting="sourcehut")

        try:
            # SourceHut doesn't have a public API for repo stats like stars/forks
            # We can at least try to fetch basic info
            result = subprocess.run(
                ["curl", "-s", f"https://git.sr.ht/~{owner}/{repo}"],
                capture_output=True,
                text=True,
                timeout=10,
            )

            # SourceHut doesn't expose stars/forks in API, so we leave them as None
            # We could scrape the HTML but that's fragile

        except Exception as e:
            self.log(f"Error fetching SourceHut stats for ~{owner}/{repo}: {e}")

        # Cache results (even if mostly empty)
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
            elif hosting == "gitlab":
                git_stats = self.fetch_gitlab_stats(owner, repo)
            elif hosting == "codeberg":
                git_stats = self.fetch_codeberg_stats(owner, repo)
            elif hosting == "sourcehut":
                git_stats = self.fetch_sourcehut_stats(owner, repo)

        return FormulaInfo(
            name=formula_name,
            desc=metadata["desc"],
            homepage=metadata["homepage"],
            url=metadata["url"],
            license=metadata["license"],
            has_bottle=metadata["has_bottle"],
            livecheck_mode=metadata["livecheck_mode"],
            git_stats=git_stats,
        )

    @staticmethod
    def load_core_index(path: Optional[Path]) -> Dict:
        """Index current names and their alias/rename routes from the Core formula API."""
        if path is None:
            with urlopen("https://formulae.brew.sh/api/formula.json", timeout=30) as response:
                formulas = json.load(response)
        else:
            formulas = json.loads(path.read_text())
        if not isinstance(formulas, list) or not formulas:
            raise ValueError("Core formula index must be a nonempty array")
        canonical = {entry["name"]: entry for entry in formulas}
        index = {name: (entry, "name") for name, entry in canonical.items()}
        for name, entry in canonical.items():
            for field, route in (("aliases", "alias"), ("oldnames", "former name")):
                for token in entry.get(field, []):
                    if token not in canonical and token in index and index[token][0]["name"] != name:
                        raise ValueError(f"Ambiguous Core route for {token}")
                    index.setdefault(token, (entry, route))
        return index

    def core_screen(self, formula: FormulaInfo, index: Dict) -> tuple[str, str]:
        """Screen for review; never infer migration parity or submission approval."""
        if formula.name in {"hello", "kafka", "zookeeper"}:
            return "Preserve", "Tap test fixture or intentional variant"
        if match := index.get(formula.name):
            entry, route = match
            name = entry["name"]
            target = f"[{name}](https://formulae.brew.sh/formula/{name}) ({route})"
            core_url = entry.get("urls", {}).get("stable", {}).get("url")
            tap_repo = self.infer_git_repo_from_links([formula.url, formula.homepage])
            core_repo = self.infer_git_repo_from_links([core_url, entry.get("homepage")])
            if (core_url and formula.url == core_url) or (
                tap_repo and core_repo and tuple(map(str.lower, tap_repo)) == tuple(map(str.lower, core_repo))
            ):
                return "Core overlap candidate", f"{target}; verify commands, platforms and migration"
            return "Core name collision", f"{target}; verify canonical upstream identity before removing"

        if formula.livecheck_mode == "skip":
            return "Blocked", "Verify the skip reason and whether a stable-release strategy is available"
        if not formula.license or formula.license.startswith(":"):
            return "Needs license review", "Verify the upstream SPDX terms and recipe license"
        stats = formula.git_stats
        if stats.hosting == "github":
            if (stats.stars or 0) >= 75 or (stats.forks or 0) >= 30:
                return "Notability candidate", "Verify current canonical metrics, age, authorship, livecheck and Core CI"
            return "Notability unverified", "Check current canonical stars, forks and subscribers"
        return "Notability unverified", "Gather equivalent public adoption evidence"

    @staticmethod
    def markdown_cell(value: str) -> str:
        return value.replace("|", r"\|").replace("\n", " ").replace("\r", " ")

    def generate_report(self, formulas: List[FormulaInfo], core_index: Dict) -> str:
        """Generate Markdown report"""
        timestamp = datetime.now(UTC).strftime("%Y-%m-%d %H:%M:%S UTC")

        # Sort by stars (descending), then name
        formulas.sort(key=lambda f: (-(f.git_stats.stars or 0), f.name))

        lines = [
            "# Formula Metadata",
            "",
            f"Generated: {timestamp}",
            f"Total formulas: {len(formulas)}",
            "",
            "[Homebrew acceptance policy](https://docs.brew.sh/Package-Acceptance-Policy#notability): "
            "third-party GitHub submissions normally need 75 stars, 30 forks or 30 subscribers; "
            "self-submissions use higher thresholds. Counts may be cached; subscribers, upstream age, "
            "source/license suitability and CI require separate verification.",
            "",
            "Livecheck is the recipe configuration, not a successful livecheck execution.",
            "",
            "## Formulas",
            "",
            "| Formula | Description | Stars | Forks | Last Commit | Last Release | License | Bottle | Livecheck | Core screen | Next action | Homepage |",
            "| ------- | ----------- | ----- | ----- | ----------- | ------------ | ------- | ------ | --------- | ----------- | ----------- | -------- |",
        ]

        for formula in formulas:
            desc = formula.desc[:60] + "..." if len(formula.desc) > 60 else formula.desc
            classification, action = self.core_screen(formula, core_index)
            row = [
                formula.name,
                desc,
                str(formula.git_stats.stars) if formula.git_stats.stars is not None else "-",
                str(formula.git_stats.forks) if formula.git_stats.forks is not None else "-",
                formula.git_stats.last_commit or "-",
                formula.git_stats.last_release or "-",
                formula.license or "-",
                "✓" if formula.has_bottle else "-",
                formula.livecheck_mode,
                classification,
                action,
                f"[link]({formula.homepage})" if formula.homepage else "-",
            ]
            lines.append("| " + " | ".join(map(self.markdown_cell, row)) + " |")

        return "\n".join(lines) + "\n"

    def run(self, output_file: Path, core_index: Dict):
        """Main execution"""
        print("Formula Metadata Crawler", flush=True)
        print(f"Workers: {self.workers}", flush=True)
        print(flush=True)

        # Find formulas
        formulas = self.find_formulas()
        print(f"Found {len(formulas)} formulas", flush=True)

        if not formulas:
            raise ValueError("No formulas found; report not written")

        # Process formulas in parallel
        results = []
        failures = []
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
                    failures.append(formula_path.stem)

        if failures:
            raise RuntimeError(f"Metadata extraction failed for: {', '.join(sorted(failures))}")

        # Save cache
        self._save_cache()

        # Generate report
        report = self.generate_report(results, core_index)

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
        default=Path("formula-status.md"),
        help="Output file (default: formula-status.md)",
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

    parser.add_argument("--core-index", type=Path, help="Use a saved Homebrew/core formula API index")

    args = parser.parse_args()

    crawler = FormulaCrawler(
        workers=args.workers,
        verbose=args.verbose,
        refresh_cache=args.refresh,
    )

    try:
        crawler.run(args.output, crawler.load_core_index(args.core_index))
    except KeyboardInterrupt:
        print("\nInterrupted", flush=True)
        sys.exit(1)
    except Exception as e:
        print(f"\nError: {e}", flush=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
