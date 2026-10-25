#!/usr/bin/env bash
# Copy the knowledge base (INDEX.md, note folders, assets) into each skill's references/ folder.
# Run this after editing notes. The GitHub Action also runs it on every push to main.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCES=(INDEX.md 01Foundation 02BuildingBlocks 03Patterns 04Architectures assets)

for skill in "$ROOT"/skills/*/; do
  [ -f "$skill/SKILL.md" ] || continue
  ref="$skill/references"
  rm -rf "$ref"
  mkdir -p "$ref"
  for src in "${SOURCES[@]}"; do
    [ -e "$ROOT/$src" ] && cp -R "$ROOT/$src" "$ref/"
  done
  # AGENTS.md is not bundled; drop the INDEX.md link to it.
  sed -i.bak 's/ (see \[AGENTS.md\](AGENTS.md))//' "$ref/INDEX.md" && rm -f "$ref/INDEX.md.bak"
  cat > "$ref/README.md" <<'EOF'
# references/ (generated)

Do not edit files here. This folder is copied from the repository root by
`scripts/sync-skills.sh`. Edit the original notes instead.
EOF
  echo "synced $(basename "$skill")"
done
