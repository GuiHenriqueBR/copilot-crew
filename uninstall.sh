#!/usr/bin/env bash
set -euo pipefail

case "$(uname -s)" in
    Darwin) PROMPTS_DEST="$HOME/Library/Application Support/Code/User/prompts" ;;
    Linux)  PROMPTS_DEST="$HOME/.config/Code/User/prompts" ;;
    *)      echo "  [ERROR] Unsupported OS: $(uname -s)"; exit 1 ;;
esac

SKILLS_DEST="$HOME/.copilot/skills"
BACKUP_DIR="$HOME/.copilot-crew-backup/uninstall_$(date +%Y-%m-%d_%H%M%S)"

echo ""
echo "========================================"
echo "      Copilot Crew - Uninstaller        "
echo "========================================"
echo ""

read -rp "  This will remove all Copilot Crew files. Continue? (y/N) " confirm
if [[ ! "$confirm" =~ ^[Yy] ]]; then
    echo "  Aborted."
    exit 0
fi

echo "  -> Backing up before removal..."
mkdir -p "$BACKUP_DIR"
[[ -d "$SKILLS_DEST" ]] && cp -r "$SKILLS_DEST" "$BACKUP_DIR/skills" 2>/dev/null || true
[[ -d "$PROMPTS_DEST" ]] && cp -r "$PROMPTS_DEST" "$BACKUP_DIR/prompts" 2>/dev/null || true
echo "  [OK] Backup at $BACKUP_DIR"

if [[ -d "$SKILLS_DEST" ]]; then
    rm -rf "$SKILLS_DEST"
    echo "  [OK] Skills removed"
else
    echo "  [!] Skills folder not found, skipping"
fi

if [[ -d "$PROMPTS_DEST" ]]; then
    rm -rf "$PROMPTS_DEST"
    echo "  [OK] Prompts removed"
else
    echo "  [!] Prompts folder not found, skipping"
fi

echo ""
echo "  Copilot Crew has been removed."
echo "  Restart VS Code to complete uninstall."
echo ""
