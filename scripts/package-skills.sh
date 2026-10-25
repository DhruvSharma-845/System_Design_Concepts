#!/usr/bin/env bash
# Build one upload-ready zip per skill in dist/ (for claude.ai, ChatGPT, etc.).
# Each zip contains a top-level <skill-name>/ folder with SKILL.md inside.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
"$ROOT/scripts/sync-skills.sh"

rm -rf "$ROOT/dist"
mkdir -p "$ROOT/dist"
cd "$ROOT/skills"
for skill in */; do
  name="${skill%/}"
  [ -f "$name/SKILL.md" ] || continue
  zip -qr "$ROOT/dist/$name.zip" "$name" -x '*.DS_Store'
  echo "built dist/$name.zip"
done
