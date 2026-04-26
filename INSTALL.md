# Porcelain Theme — Installation Guide

## One-line installer (推荐)

```bash
curl -fsSL https://raw.githubusercontent.com/thedavidweng/hermes-dashboard-theme-porcelain/main/scripts/install.sh | bash
```

该命令会：
1. 自动克隆仓库到临时目录
2. 运行安装脚本（复制主题文件 + 可选配套插件）
3. 请求 Hermes Dashboard 重扫插件
4. 自动清理临时目录

无需手动 `git clone`。

## What gets installed

| File | Destination | Purpose |
|------|-------------|---------|
| `theme/porcelain.yaml` | `~/.hermes/dashboard-themes/porcelain.yaml` | Theme definition (YAML) |
| `plugin/dashboard/manifest.json` | `~/.hermes/plugins/porcelain-theme/dashboard/` | Plugin manifest |
| `plugin/dashboard/dist/index.js` | `~/.hermes/plugins/porcelain-theme/dashboard/` | Plugin UI logic |
| `plugin/dashboard/dist/style.css` | `~/.hermes/plugins/porcelain-theme/dashboard/` | Plugin styles |
| `plugin/dashboard/plugin_api.py` | `~/.hermes/plugins/porcelain-theme/dashboard/` | Backend API routes |

## Post-install

1. 打开 Hermes Dashboard: http://127.0.0.1:9119
2. 点击右上角调色板图标打开主题选择器
3. 选择 **Porcelain** 主题
4. 如果仪表板已打开，刷新浏览器页面

### 验证主题已生效

```bash
curl -s http://127.0.0.1:9119/api/dashboard/themes | jq '.themes[] | select(.name=="porcelain")'
```

应看到类似输出：
```json
{
  "name": "porcelain",
  "label": "Porcelain",
  "path": "~/.hermes/dashboard-themes/porcelain.yaml",
  "active": false
}
```

### 查看日志（如有问题）

```bash
tail -f ~/.hermes/logs/errors.log
```

## Uninstall

```bash
rm -f ~/.hermes/dashboard-themes/porcelain.yaml
rm -rf ~/.hermes/plugins/porcelain-theme
curl -s http://127.0.0.1:9119/api/dashboard/plugins/rescan > /dev/null 2>&1 || true
```

然后切换到其他主题。
