#!/usr/bin/env bash
# Porcelain Theme — Dev Helper
# 常用开发命令快捷方式

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "${1:-help}" in
  install)
    echo "📦 安装主题到本地..."
    cp "$REPO_DIR/theme/porcelain.yaml" "$HOME/.hermes/dashboard-themes/"
    echo "✅ 主题已安装"
    ;;
  install-plugin)
    echo "📦 安装 companion plugin..."
    mkdir -p "$HOME/.hermes/plugins/porcelain-theme/dashboard"
    cp -r "$REPO_DIR/plugin/." "$HOME/.hermes/plugins/porcelain-theme/dashboard/"
    echo "🔁 重扫插件..."
    curl -s "http://127.0.0.1:9119/api/dashboard/plugins/rescan" > /dev/null
    echo "✅ Plugin 已安装并重扫"
    ;;
  rescan)
    echo "🔁 通知 dashboard 重扫插件..."
    curl -s "http://127.0.0.1:9119/api/dashboard/plugins/rescan" | jq .
    ;;
  logs)
    echo "📄 查看 dashboard 日志..."
    tail -f "$HOME/.hermes/logs/errors.log"
    ;;
  check)
    echo "🔍 检查主题是否被识别..."
    curl -s "http://127.0.0.1:9119/api/dashboard/themes" | jq '.[] | select(.name=="porcelain")'
    ;;
  clean)
    echo "🧹 清理本地安装（谨慎操作）..."
    rm -f "$HOME/.hermes/dashboard-themes/porcelain.yaml"
    rm -rf "$HOME/.hermes/plugins/porcelain-theme"
    echo "✅ 清理完成"
    ;;
  *)
    echo "Porcelain Theme Dev Helper"
    echo ""
    echo "用法: $0 <命令>"
    echo ""
    echo "命令列表:"
    echo "  install       复制主题到 ~/.hermes/dashboard-themes/"
    echo "  install-plugin 复制 companion plugin 并触发重扫"
    echo "  rescan        仅触发插件重扫（不需复制文件）"
    echo "  logs          跟踪查看 errors.log"
    echo "  check         通过 API 验证主题是否被发现"
    echo "  clean         删除本地安装的文件"
    echo ""
    echo "提示：修改文件后，只需刷新浏览器即可看到主题更改。"
    echo "      插件修改后需要 rescan 或重启 dashboard。"
    ;;
esac
