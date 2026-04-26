#!/usr/bin/env bash
# Porcelain Theme dev helper.

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEME_DIR="$HOME/.hermes/dashboard-themes"
THEME_PATH="$THEME_DIR/porcelain.yaml"
LEGACY_THEME_PATH="$THEME_DIR/minimalist.yaml"
LEGACY_DISABLED_PATH="$THEME_DIR/minimalist.yaml.disabled"
PLUGIN_DIR="$HOME/.hermes/plugins/porcelain-theme/dashboard"

migrate_legacy_theme() {
  if [[ -f "$LEGACY_THEME_PATH" ]] && grep -Eq '^name:[[:space:]]*porcelain[[:space:]]*$' "$LEGACY_THEME_PATH"; then
    echo "Moving legacy theme file out of Hermes theme discovery..."
    mv "$LEGACY_THEME_PATH" "$LEGACY_DISABLED_PATH"
  fi
}

case "${1:-help}" in
  install)
    echo "Installing theme..."
    mkdir -p "$THEME_DIR"
    migrate_legacy_theme
    cp "$REPO_DIR/theme/porcelain.yaml" "$THEME_PATH"
    echo "Theme installed."
    ;;
  install-plugin)
    echo "Installing companion plugin..."
    mkdir -p "$PLUGIN_DIR"
    cp -r "$REPO_DIR/plugin/." "$PLUGIN_DIR/"
    echo "Requesting plugin rescan..."
    curl -s "http://127.0.0.1:9119/api/dashboard/plugins/rescan" > /dev/null || true
    echo "Plugin installed and rescan requested."
    ;;
  rescan)
    echo "Requesting plugin rescan..."
    curl -s "http://127.0.0.1:9119/api/dashboard/plugins/rescan" | jq .
    ;;
  logs)
    tail -f "$HOME/.hermes/logs/errors.log"
    ;;
  check)
    curl -s "http://127.0.0.1:9119/api/dashboard/themes" | jq '.themes[] | select(.name=="porcelain")'
    ;;
  clean)
    echo "Removing local Porcelain install..."
    rm -f "$THEME_PATH"
    rm -rf "$HOME/.hermes/plugins/porcelain-theme"
    echo "Removed."
    ;;
  *)
    echo "Porcelain Theme Dev Helper"
    echo ""
    echo "Usage: $0 <command>"
    echo ""
    echo "Commands:"
    echo "  install         Copy the theme to ~/.hermes/dashboard-themes/"
    echo "  install-plugin  Copy the companion plugin and request a plugin rescan"
    echo "  rescan          Request a plugin rescan"
    echo "  logs            Tail dashboard logs"
    echo "  check           Verify the theme is listed by the dashboard API"
    echo "  clean           Remove the local Porcelain install"
    echo ""
    echo "After theme changes, refresh the browser."
    echo "After plugin changes, run rescan or restart the dashboard."
    ;;
esac
