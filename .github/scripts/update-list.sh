#!/usr/bin/env bash

# 1. Get only the short formula names (strip chenrui333/tap/).
FORMULAE="$(
  brew tap-info chenrui333/tap --json \
    | jq -r '.[0].formula_names[]' \
    | sed 's|^chenrui333/tap/||'
)"

# 2. Build the lines we want to insert, including bullet points
FORMATTED_FORMULAE="$(
  echo "$FORMULAE" | awk '
    $0 == "debugg-ai-mcp" { printf("- `%s` <!-- spellchecker:disable-line -->\n", $0); next }
    { printf("- `%s`\n", $0) }
  '
)"

cat <<EOF > .tmp-formulae-list
<!-- FORMULAE-LIST-START -->
<details>
<summary>Formula List</summary>

${FORMATTED_FORMULAE}

</details>
<!-- FORMULAE-LIST-END -->
EOF

# 3. Use 'r' to insert the lines, then 'd' to remove the old block
sed -i.bak '/<!-- FORMULAE-LIST-START -->/,/<!-- FORMULAE-LIST-END -->/ {
  /<!-- FORMULAE-LIST-START -->/r .tmp-formulae-list
  d
}' README.md

rm -f README.md.bak .tmp-formulae-list

if ! git diff --exit-code README.md; then
  git config user.name "github-actions"
  git config user.email "actions@github.com"
  git add README.md
  git commit -m "Update formulae list"
fi
