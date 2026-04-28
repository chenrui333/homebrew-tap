import requests
import os

# --- CONFIGURATION ---
SOURCE_OWNER = "homebrew"
SOURCE_REPO = "homebrew-core"
DEST_OWNER = "chenrui333"
DEST_REPO = "homebrew-tap"

GITHUB_TOKEN = os.environ.get("HOMEBREW_GITHUB_API_TOKEN")
# --------------------

# GitHub API endpoints
SOURCE_LABELS_URL = f"https://api.github.com/repos/{SOURCE_OWNER}/{SOURCE_REPO}/labels"
DEST_LABELS_URL = f"https://api.github.com/repos/{DEST_OWNER}/{DEST_REPO}/labels"

headers = {
    "Authorization": f"Bearer {GITHUB_TOKEN}",
    "Accept": "application/vnd.github+json"  # or application/vnd.github.v3+json
}

def fetch_labels(url):
    """Fetch all labels from the source repository (handle pagination)."""
    all_labels = []
    page = 1

    while True:
        response = requests.get(url, headers=headers, params={"page": page, "per_page": 100})
        response.raise_for_status()
        data = response.json()

        if not data:
            break

        all_labels.extend(data)
        page += 1

    return all_labels

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
    print(f"Fetching labels from {SOURCE_OWNER}/{SOURCE_REPO}...")
    source_labels = fetch_labels(SOURCE_LABELS_URL)

    print(f"Creating labels in {DEST_OWNER}/{DEST_REPO}...")
    for label in source_labels:
        create_label(label, DEST_LABELS_URL)

if __name__ == "__main__":
    main()
