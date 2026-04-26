#!/usr/bin/env bash
# Porcelain Theme installer.

set -e

echo "===== Porcelain Theme Installer ====="
echo ""

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "Repository: $REPO_DIR"

THEME_DIR="$HOME/.hermes/dashboard-themes"
THEME_PATH="$THEME_DIR/porcelain.yaml"
LEGACY_THEME_PATH="$THEME_DIR/minimalist.yaml"
LEGACY_DISABLED_PATH="$THEME_DIR/minimalist.yaml.disabled"
PLUGIN_DIR="$HOME/.hermes/plugins/porcelain-theme/dashboard"

migrate_legacy_theme() {
  if [[ -f "$LEGACY_THEME_PATH" ]] && grep -Eq '^name:[[:space:]]*porcelain[[:space:]]*$' "$LEGACY_THEME_PATH"; then
    echo "Moving legacy theme file out of Hermes theme discovery..."
    mv "$LEGACY_THEME_PATH" "$LEGACY_DISABLED_PATH"
    echo "   $LEGACY_THEME_PATH -> $LEGACY_DISABLED_PATH"
  fi
}

echo ""
echo "Creating target directories..."
mkdir -p "$THEME_DIR"
mkdir -p "$PLUGIN_DIR"

migrate_legacy_theme

echo ""
echo "Installing theme..."
cp "$REPO_DIR/theme/porcelain.yaml" "$THEME_PATH"
echo "   theme/porcelain.yaml -> $THEME_PATH"

echo ""
read -p "Install the companion plugin for the cross-theme Porcelain swatch? (Y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
  cp -r "$REPO_DIR/plugin/." "$PLUGIN_DIR/"
  echo "   plugin/ -> $PLUGIN_DIR/"
  echo ""
  echo "Requesting dashboard plugin rescan..."
  if curl -s "http://127.0.0.1:9119/api/dashboard/plugins/rescan" > /dev/null 2>&1; then
    echo "   Rescan requested."
  else
    echo "   Dashboard is not running. Restart it or run a plugin rescan later."
  fi
else
  echo "   Skipped plugin install."
fi

echo ""
echo "Install complete."
echo ""
echo "Next steps:"
echo "   1. Open http://127.0.0.1:9119"
echo "   2. Open the theme picker and select Porcelain"
echo "   3. Refresh the browser if the dashboard was already open"
echo ""
echo "Debug commands:"
echo "   curl http://127.0.0.1:9119/api/dashboard/themes | jq"
echo "   tail -f ~/.hermes/logs/errors.log"
