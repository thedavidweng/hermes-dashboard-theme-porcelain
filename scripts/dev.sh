#!/usr/bin/env bash
# Porcelain Theme dev helper.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "${1:-help}" in
  install)
    echo "Installing theme..."
    mkdir -p "$HOME/.hermes/dashboard-themes"
    cp "$REPO_DIR/theme/porcelain.yaml" "$HOME/.hermes/dashboard-themes/"
    echo "Theme installed."
    ;;
  install-plugin)
    echo "Installing companion plugin..."
    mkdir -p "$HOME/.hermes/plugins/porcelain-theme/dashboard"
    cp -r "$REPO_DIR/plugin/." "$HOME/.hermes/plugins/porcelain-theme/dashboard/"
    echo "Requesting plugin rescan..."
    curl -s "http://127.0.0.1:9119/api/dashboard/plugins/rescan" > /dev/null
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
    curl -s "http://127.0.0.1:9119/api/dashboard/themes" | jq '.[] | select(.name=="porcelain")'
    ;;
  clean)
    echo "Removing local Porcelain install..."
    rm -f "$HOME/.hermes/dashboard-themes/porcelain.yaml"
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
