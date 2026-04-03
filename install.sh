#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC="$REPO_ROOT/skills"
PROMPTS_SRC="$REPO_ROOT/prompts"

# Detect OS for VS Code prompts path
case "$(uname -s)" in
    Darwin) PROMPTS_DEST="$HOME/Library/Application Support/Code/User/prompts" ;;
    Linux)  PROMPTS_DEST="$HOME/.config/Code/User/prompts" ;;
    *)      echo "  [ERROR] Unsupported OS: $(uname -s)"; exit 1 ;;
esac

SKILLS_DEST="$HOME/.copilot/skills"
BACKUP_DIR="$HOME/.copilot-crew-backup/$(date +%Y-%m-%d_%H%M%S)"

echo ""
echo "========================================"
echo "       Copilot Crew - Installer         "
echo "========================================"
echo ""

# Validate sources
if [[ ! -d "$SKILLS_SRC" ]]; then
    echo "  [ERROR] skills/ folder not found. Run from the copilot-crew repo root."
    exit 1
fi
if [[ ! -d "$PROMPTS_SRC" ]]; then
    echo "  [ERROR] prompts/ folder not found. Run from the copilot-crew repo root."
    exit 1
fi

# Confirmation
echo "  This will install Copilot Crew to:"
echo "    Skills:  $SKILLS_DEST"
echo "    Prompts: $PROMPTS_DEST"
echo ""
read -rp "  Continue? (Y/n) " confirm
if [[ "$confirm" =~ ^[Nn] ]]; then
    echo "  Aborted."
    exit 0
fi

# Backup existing files
if [[ -d "$SKILLS_DEST" ]] || [[ -d "$PROMPTS_DEST" ]]; then
    echo "  -> Backing up existing config..."
    mkdir -p "$BACKUP_DIR"
    [[ -d "$SKILLS_DEST" ]] && cp -r "$SKILLS_DEST" "$BACKUP_DIR/skills" 2>/dev/null || true
    [[ -d "$PROMPTS_DEST" ]] && cp -r "$PROMPTS_DEST" "$BACKUP_DIR/prompts" 2>/dev/null || true
    echo "  [OK] Backup created at $BACKUP_DIR"
fi

# Install skills
echo "  -> Installing skills..."
mkdir -p "$SKILLS_DEST"
cp -r "$SKILLS_SRC"/* "$SKILLS_DEST/"
SKILL_COUNT=$(find "$SKILLS_DEST" -maxdepth 1 -type d | tail -n +2 | wc -l | tr -d ' ')
echo "  [OK] $SKILL_COUNT skills installed"

# Install prompts
echo "  -> Installing prompts..."
mkdir -p "$PROMPTS_DEST"
cp -r "$PROMPTS_SRC"/* "$PROMPTS_DEST/"

AGENT_COUNT=$(find "$PROMPTS_DEST/agents" -name "*.agent.md" 2>/dev/null | wc -l | tr -d ' ')
PROMPT_COUNT=$(find "$PROMPTS_DEST" -maxdepth 1 -name "*.prompt.md" 2>/dev/null | wc -l | tr -d ' ')
INSTR_COUNT=$(find "$PROMPTS_DEST/instructions" -name "*.instructions.md" 2>/dev/null | wc -l | tr -d ' ')

echo "  [OK] Prompts installed"

echo ""
echo "========================================"
echo "       Installation Complete!           "
echo "========================================"
echo ""
echo "  Agents:       $AGENT_COUNT"
echo "  Prompts:      $PROMPT_COUNT"
echo "  Instructions: $INSTR_COUNT"
echo "  Skills:       $SKILL_COUNT"
echo ""
echo "  Restart VS Code to activate."
echo ""
