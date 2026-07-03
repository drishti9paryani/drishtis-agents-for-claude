#!/usr/bin/env bash
# Drishti's Agents for Claude - Mac/Linux installer
# Copies agents and skills into your user-level Claude Code folders.
set -euo pipefail

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$CLAUDE_DIR/agents" "$CLAUDE_DIR/skills"

cp "$REPO_ROOT/agents/"*.md "$CLAUDE_DIR/agents/"
cp -R "$REPO_ROOT/skills/"* "$CLAUDE_DIR/skills/"

echo ""
echo "Installed to $CLAUDE_DIR:"
echo "  - agents/totem.md"
echo "  - agents/rancho.md"
echo "  - skills/unagi/SKILL.md"
echo ""
echo "Restart Claude Code, then try: 'run totem' or '/unagi'"
