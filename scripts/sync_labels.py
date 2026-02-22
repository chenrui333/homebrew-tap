import os
import sys

import requests

# --- CONFIGURATION ---
SOURCE_REPOS = [
    ("homebrew", "homebrew-core"),
    ("homebrew", "homebrew-cask"),
]
DEST_OWNER = "chenrui333"
DEST_REPO = "homebrew-tap"

GITHUB_TOKEN = os.environ.get("HOMEBREW_GITHUB_API_TOKEN")
# --------------------

DEST_LABELS_URL = f"https://api.github.com/repos/{DEST_OWNER}/{DEST_REPO}/labels"

headers = {
    "Authorization": f"Bearer {GITHUB_TOKEN}",
    "Accept": "application/vnd.github+json",
}


def labels_url(owner, repo):
    return f"https://api.github.com/repos/{owner}/{repo}/labels"


def fetch_labels(owner, repo):
    """Fetch all labels from a source repository (handle pagination)."""
    all_labels = []
    page = 1

    while True:
        response = requests.get(labels_url(owner, repo), headers=headers, params={"page": page, "per_page": 100})
        response.raise_for_status()
        data = response.json()

        if not data:
            break

        all_labels.extend(data)
        page += 1

    return all_labels


def merge_source_labels():
    """
    Merge labels from SOURCE_REPOS in order.

    homebrew-core labels win over homebrew-cask labels on conflicts.
    """
    merged = {}

    for owner, repo in SOURCE_REPOS:
        source_name = f"{owner}/{repo}"
        print(f"Fetching labels from {source_name}...")
        for label in fetch_labels(owner, repo):
            key = label["name"].strip().lower()
            if key in merged:
                print(
                    f"Ignoring conflict from {source_name} for label '{label['name']}' "
                    f"(already defined by {merged[key]['_source_repo']})."
                )
                continue

            label["_source_repo"] = source_name
            merged[key] = label

    return list(merged.values())


def create_label(label, url):
    """Create an individual label in the destination repository."""
    response = requests.post(url, headers=headers, json={
        "name": label["name"],
        "color": label["color"],
        "description": label.get("description", "")
    })

    if response.status_code == 201:
        print(f"Created label: {label['name']}")
    elif response.status_code == 422:
        # Typically means the label already exists
        print(f"Label '{label['name']}' already exists, skipping.")
    else:
        print(f"Failed to create label '{label['name']}': {response.text}")

def main():
    if not GITHUB_TOKEN:
        print("HOMEBREW_GITHUB_API_TOKEN is required.", file=sys.stderr)
        raise SystemExit(1)

    source_labels = merge_source_labels()

    print(f"Creating {len(source_labels)} labels in {DEST_OWNER}/{DEST_REPO}...")
    for label in source_labels:
        create_label(label, DEST_LABELS_URL)

if __name__ == "__main__":
    main()
