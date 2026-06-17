#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCS_JSON="$REPO_ROOT/docs.json"
OUTPUT="$REPO_ROOT/llms-full.txt"
BASE_URL="https://docs.xpoz.ai"

extract_pages() {
  python3 -c "
import json, sys

with open('$DOCS_JSON') as f:
    config = json.load(f)

for tab in config['navigation']['tabs']:
    for group in tab['groups']:
        for page in group['pages']:
            print(page)
"
}

strip_mdx() {
  sed '/^---$/,/^---$/d' \
    | sed -E 's/<Card[^>]*>//g; s/<\/Card>//g' \
    | sed -E 's/<CardGroup[^>]*>//g; s/<\/CardGroup>//g' \
    | sed -E 's/<Tabs?[^>]*>//g; s/<\/Tabs?>//g' \
    | sed -E 's/<Accordion[^>]*>//g; s/<\/Accordion>//g' \
    | sed -E 's/<AccordionGroup[^>]*>//g; s/<\/AccordionGroup>//g' \
    | sed -E 's/<Steps?[^>]*>//g; s/<\/Steps?>//g' \
    | sed -E 's/<Tip>//g; s/<\/Tip>//g' \
    | sed -E 's/<Note>//g; s/<\/Note>//g' \
    | sed -E 's/<Warning>//g; s/<\/Warning>//g' \
    | sed -E 's/<Info>//g; s/<\/Info>//g' \
    | sed -E 's/<Frame[^>]*>//g; s/<\/Frame>//g' \
    | sed -E 's/<ResponseField[^>]*>//g; s/<\/ResponseField>//g' \
    | sed -E 's/<ParamField[^>]*>//g; s/<\/ParamField>//g' \
    | sed -E 's/<Expandable[^>]*>//g; s/<\/Expandable>//g' \
    | sed -E 's/<CodeGroup[^>]*>//g; s/<\/CodeGroup>//g' \
    | sed -E '/<img[^>]*\/>/d' \
    | sed '/^[[:space:]]*$/N;/^[[:space:]]*\n[[:space:]]*$/d'
}

extract_title() {
  local file="$1"
  grep -m1 '^title:' "$file" | sed 's/^title: *//; s/^"//; s/"$//'
}

{
  echo "# Xpoz Documentation — Full Text"
  echo "> Social media intelligence platform. Access billions of posts and users across Twitter/X, Instagram, Reddit, and TikTok via MCP, SDKs, CLI, and Agent Skills."
  echo ""
  echo "This file contains the full text of all Xpoz documentation pages."
  echo "For a page index, see: ${BASE_URL}/llms.txt"
  echo "For the agent setup guide, see: ${BASE_URL}/agents.md"
  echo ""

  while IFS= read -r page; do
    mdx_file="$REPO_ROOT/${page}.mdx"
    if [[ ! -f "$mdx_file" ]]; then
      continue
    fi

    title=$(extract_title "$mdx_file")
    url="${BASE_URL}/${page}"

    echo "---"
    echo ""
    echo "# ${title}"
    echo "Source: ${url}"
    echo ""
    strip_mdx < "$mdx_file"
    echo ""
  done < <(extract_pages)
} > "$OUTPUT"

line_count=$(wc -l < "$OUTPUT")
page_count=$(grep -c '^# ' "$OUTPUT" || true)
echo "Generated $OUTPUT ($page_count pages, $line_count lines)"
