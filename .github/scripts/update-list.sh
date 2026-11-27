#!/usr/bin/env bash

set -euo pipefail

recipe_list() {
	LC_ALL=C git ls-files -- "$1" | awk -F/ '
    /\.rb$/ {
      name = $NF
      sub(/\.rb$/, "", name)
      suffix = name == "debugg-ai-mcp" ? " <!-- spellchecker:disable-line -->" : ""
      printf("- `%s`%s\n", name, suffix)
    }
  ' | LC_ALL=C sort
}

FORMATTED_FORMULAE="$(recipe_list Formula)"
FORMATTED_CASKS="$(recipe_list Casks)"

cat <<EOF >.tmp-formulae-list
<!-- FORMULAE-LIST-START -->
<details>
<summary>Formula List</summary>

${FORMATTED_FORMULAE}

</details>

<details>
<summary>Cask List</summary>

${FORMATTED_CASKS}

</details>
<!-- FORMULAE-LIST-END -->
EOF

# 3. Use 'r' to insert the lines, then 'd' to remove the old block
sed -i.bak '/<!-- FORMULAE-LIST-START -->/,/<!-- FORMULAE-LIST-END -->/ {
  /<!-- FORMULAE-LIST-START -->/r .tmp-formulae-list
  d
}' README.md

rm -f README.md.bak .tmp-formulae-list
