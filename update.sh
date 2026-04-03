#!/usr/bin/env bash
# Copilot Crew — Update Script (macOS / Linux)
# Run: bash update.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
PROMPTS_SOURCE="$REPO_DIR/prompts"
SKILLS_SOURCE="$REPO_DIR/skills"

# Determine install targets
if [[ "$OSTYPE" == "darwin"* ]]; then
    PROMPTS_TARGET="$HOME/Library/Application Support/Code/User/prompts"
else
    PROMPTS_TARGET="$HOME/.config/Code/User/prompts"
fi
SKILLS_TARGET="$HOME/.copilot/skills"

echo "=== Copilot Crew Updater ==="
echo ""

# Step 1: Pull latest changes
echo "[1/3] Pulling latest changes..."
cd "$REPO_DIR"
if git pull origin main; then
    echo "  OK — pulled latest from GitHub"
else
    echo "  ERROR: git pull failed. Check your network or resolve conflicts."
    exit 1
fi

# Step 2: Copy prompts (agents, instructions, prompts)
echo "[2/3] Updating prompts..."
if [ -d "$PROMPTS_SOURCE" ]; then
    mkdir -p "$PROMPTS_TARGET"
    cp -R "$PROMPTS_SOURCE/"* "$PROMPTS_TARGET/"
    echo "  OK — prompts updated at $PROMPTS_TARGET"
else
    echo "  SKIP — prompts directory not found in repo"
fi

# Step 3: Copy skills
echo "[3/3] Updating skills..."
if [ -d "$SKILLS_SOURCE" ]; then
    mkdir -p "$SKILLS_TARGET"
    cp -R "$SKILLS_SOURCE/"* "$SKILLS_TARGET/"
    echo "  OK — skills updated at $SKILLS_TARGET"
else
    echo "  SKIP — skills directory not found in repo"
fi

# Done
VERSION="unknown"
if [ -f "$REPO_DIR/VERSION" ]; then
    VERSION=$(head -1 "$REPO_DIR/VERSION")
fi
echo ""
echo "=== Update complete! Version: $VERSION ==="
echo "Restart VS Code to apply changes."
