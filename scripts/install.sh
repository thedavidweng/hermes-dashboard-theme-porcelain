#!/usr/bin/env bash
# Porcelain Theme — Quick Install Script
# 将主题和可选插件安装到 ~/.hermes/ 目录

set -e

echo "===== Porcelain Theme Installer ====="
echo ""

# 1. 确定仓库根目录（脚本所在目录）
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📍 仓库目录: $REPO_DIR"

# 2. 创建目标目录
THEME_DIR="$HOME/.hermes/dashboard-themes"
PLUGIN_DIR="$HOME/.hermes/plugins/porcelain-theme/dashboard"

echo ""
echo "📁 创建目标目录..."
mkdir -p "$THEME_DIR"
mkdir -p "$PLUGIN_DIR"

# 3. 复制主题文件
echo ""
echo "🎨  installing theme..."
cp "$REPO_DIR/theme/porcelain.yaml" "$THEME_DIR/"
echo "   ✓ theme/porcelain.yaml → $THEME_DIR/porcelain.yaml"

# 4. 复制插件（可选）
echo ""
read -p "是否同时安装 companion plugin？(y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  cp -r "$REPO_DIR/plugin/." "$PLUGIN_DIR/"
  echo "   ✓ plugin/ → $PLUGIN_DIR/"
  echo ""
  echo "🔁 通知 dashboard 重扫插件..."
  if curl -s "http://127.0.0.1:9119/api/dashboard/plugins/rescan" > /dev/null 2>&1; then
    echo "   ✓ 已请求重扫"
  else
    echo "   ⚠️  Dashboard 未运行，请手动重启 hermes dashboard"
  fi
else
  echo "   跳过插件安装。"
fi

# 5. 完成
echo ""
echo "✅ 安装完成！"
echo ""
echo "📌 下一步："
echo "   1. 打开浏览器访问 http://127.0.0.1:9119"
echo "   2. 点击右上角调色板图标，选择 'Porcelain'"
echo "   3. 如果需要 sidebar HUD，请确保已安装 companion plugin"
echo ""
echo "🔧 调试命令："
echo "   curl http://127.0.0.1:9119/api/dashboard/themes | jq"
echo "   tail -f ~/.hermes/logs/errors.log"
echo ""
echo "🎉 祝黑客松顺利！"
