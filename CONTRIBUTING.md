# 贡献指南 / Contributing

本仓库为 Hermes Dashboard Theme Hackathon 提交，欢迎 Issue 和 Pull Request。

## 开发工作流

### 1. 本地编辑
```bash
# 编辑主题文件
code theme/porcelain.yaml

# 编辑插件
code plugin/dist/index.js
```

### 2. 安装到本地 Hermes
```bash
# 复制主题（覆盖安装）
cp theme/porcelain.yaml ~/.hermes/dashboard-themes/

# 复制插件
cp -r plugin ~/.hermes/plugins/porcelain-theme/dashboard/

# 重扫插件（无需重启 dashboard）
curl http://127.0.0.1:9119/api/dashboard/plugins/rescan
```

### 3. 调试
```bash
# 查看 dashboard 日志
tail -f ~/.hermes/logs/errors.log

# 验证主题 API 响应
curl http://127.0.0.1:9119/api/dashboard/themes | jq '.[] | select(.name=="porcelain")'

# 验证插件发现
curl http://127.0.0.1:9119/api/dashboard/plugins | jq
```

### 4. 浏览器调试
- 打开 `http://127.0.0.1:9119`
- DevTools → Console：检查 `[porcelain-theme] plugin loaded` 等日志
- DevTools → Network：确认 `manifest.json`、`index.js`、`style.css` 加载成功（200）
- DevTools → Elements：检查 CSS 变量 `--color-primary` 等是否正确应用
- DevTools → Sources：在 `index.js` 中打点调试

### 5. 截图
```bash
# macOS 截图：Cmd+Shift+4 或使用内置的 Screenshot.app
# 建议保存到 docs/screenshots/ 目录
open docs/screenshots/
```

---

## 主题文件结构说明

```yaml
name: porcelain              # 内部标识符（字母/连字符）
label: Porcelain             # 显示的标题
description: ...              # 描述文本

palette:
  background: {hex, alpha}    # 三层颜色 + 两个特效
  midground: ...
  foreground: ...
  warmGlow: "rgba(...)"       # 可选
  noiseOpacity: 0-1.2         # 可选

typography: ...
layout: ...
layoutVariant: standard       # standard / cockpit / tiled

# 可选
assets: ...
componentStyles: ...
colorOverrides: ...
customCSS: |
  ...
```

详见官方文档：https://hermes-agent.nousresearch.com/docs/user-guide/features/extending-the-dashboard

---

## 提交代码

```bash
git add .
git commit -m "feat(theme): add porcelain dashboard theme with grayscale palette

- white canvas with gray-500 primary text
- 12px rounded cards via componentStyles
- pill-shaped navigation tabs via clip-path
- customCSS for table styling, scrollbar, progress bars
- optional companion plugin with sidebar HUD and header crest"
```

---

## 许可证

MIT — 详见 `LICENSE` 文件。

---

## 问题反馈

- GitHub Issues：提交 bug 或 feature request
- Discord：@thedavidweng 或 #dashboard-theming 频道

---

**Happy hacking!** 🚀
