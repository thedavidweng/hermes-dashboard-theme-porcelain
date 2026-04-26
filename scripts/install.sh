#!/usr/bin/env bash
# Porcelain Theme installer — supports both local and piped execution.
#
# Local:          ./scripts/install.sh
# One-line:       curl -fsSL <URL>/install.sh | bash
#
# When piped, BASH_SOURCE[0] is empty. We detect that by checking
# if the script's directory contains a 'theme/' folder. If not, we
# assume we're running from a temp clone and use the current dir.

set -e

# ── Determine repository root ───────────────────────────────────────────────
if [[ -n "${BASH_SOURCE[0]}" && -d "$(dirname "${BASH_SOURCE[0]}")/../theme" ]]; then
  # Local execution: scripts/install.sh → repo root is two levels up
  REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
else
  # Piped execution: we are likely in the repo root already (temp clone)
  REPO_DIR="$(pwd)"
  # Fallback: search upward for 'theme/' if needed
  while [[ "$REPO_DIR" != "/" && ! -d "$REPO_DIR/theme" ]]; do
    REPO_DIR="$(dirname "$REPO_DIR")"
  done
  if [[ ! -d "$REPO_DIR/theme" ]]; then
    echo "ERROR: Cannot locate repo root (missing theme/ directory)." >&2
    exit 1
  fi
fi

echo "===== Porcelain Theme Installer ====="
echo "Repository: $REPO_DIR"
echo ""

# ── Target directories ───────────────────────────────────────────────────────
THEME_DIR="$HOME/.hermes/dashboard-themes"
THEME_PATH="$THEME_DIR/porcelain.yaml"
PLUGIN_DIR="$HOME/.hermes/plugins/porcelain-theme/dashboard"

# ── Install theme ─────────────────────────────────────────────────────────────
echo "Creating target directories..."
mkdir -p "$THEME_DIR"
mkdir -p "$PLUGIN_DIR"

echo ""
echo "Installing theme..."
cp "$REPO_DIR/theme/porcelain.yaml" "$THEME_PATH"
echo "   theme/porcelain.yaml → $THEME_PATH"

# ── Optional companion plugin ─────────────────────────────────────────────────
echo ""
read -p "Install the companion plugin for the cross-theme Porcelain swatch? (Y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
  # Copy everything under plugin/dashboard/
  cp -r "$REPO_DIR/plugin/dashboard/." "$PLUGIN_DIR/"
  echo "   plugin/dashboard/ → $PLUGIN_DIR/"
  echo ""
  echo "Requesting dashboard plugin rescan..."
  if curl -s "http://127.0.0.1:9119/api/dashboard/plugins/rescan" > /dev/null 2>&1; then
    echo "   Rescan requested."
  else
    echo "   Dashboard is not running. Restart it later or manually rescan:"
    echo "     curl http://127.0.0.1:9119/api/dashboard/plugins/rescan"
  fi
else
  echo "   Skipped plugin install."
fi

echo ""
echo "Installation complete."
echo ""
echo "Next steps:"
echo "  1. Open http://127.0.0.1:9119"
echo "  2. Open the theme picker (palette icon) and select 'Porcelain'"
echo "  3. Refresh the browser if the dashboard was already open"
echo ""
echo "Debug commands:"
echo "  curl http://127.0.0.1:9119/api/dashboard/themes | jq '.themes[] | select(.name=="porcelain")'"
echo "  tail -f ~/.hermes/logs/errors.log"
