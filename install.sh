#!/usr/bin/env bash
# Install the system design skills for all local AI agents.
#
#   curl -fsSL https://raw.githubusercontent.com/DhruvSharma-845/System_Design_Concepts/main/install.sh | bash
#
# Options (env vars):
#   SDK_DIR=<path>   where to clone the repo   (default: ~/.local/share/system-design-kb)
#   SDK_MODE=copy    copy skill folders instead of symlinking them (default: link)
#
# Targets:
#   ~/.claude/skills  -> Claude Code (also read by OpenCode)
#   ~/.agents/skills  -> GitHub Copilot (CLI / VS Code), OpenAI Codex, OpenCode
# Re-run the script (or `git -C "$SDK_DIR" pull`) to update.
set -euo pipefail

REPO_URL="${SDK_REPO_URL:-https://github.com/DhruvSharma-845/System_Design_Concepts.git}"
SDK_DIR="${SDK_DIR:-$HOME/.local/share/system-design-kb}"
SDK_MODE="${SDK_MODE:-link}"
TARGETS=("$HOME/.claude/skills" "$HOME/.agents/skills")

if [ -d "$SDK_DIR/.git" ]; then
  echo "Updating $SDK_DIR"
  git -C "$SDK_DIR" pull --ff-only --quiet
else
  echo "Cloning into $SDK_DIR"
  mkdir -p "$(dirname "$SDK_DIR")"
  git clone --depth 1 --quiet "$REPO_URL" "$SDK_DIR"
fi

for target in "${TARGETS[@]}"; do
  mkdir -p "$target"
  for skill in "$SDK_DIR"/skills/*/; do
    name="$(basename "$skill")"
    [ -f "$skill/SKILL.md" ] || continue
    dest="$target/$name"
    rm -rf "$dest"
    if [ "$SDK_MODE" = "copy" ]; then
      cp -R "${skill%/}" "$dest"
    else
      ln -s "${skill%/}" "$dest"
    fi
    echo "installed $name -> $dest ($SDK_MODE)"
  done
done

echo "Done. Restart your agents to pick up the skills."
