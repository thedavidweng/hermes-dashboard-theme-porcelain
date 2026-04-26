[English](README.md) · [简体中文](README.zh-CN.md)

# Hermes Dashboard Theme: Porcelain（白瓷主题）



Porcelain（白瓷）是为 Hermes Agent 仪表板设计的极简、高可读性浅色主题。
它保持默认的仪表板布局、尺寸和控件不变，同时用素雅的灰度表面、系统字体
和高对比度控件取代了原本风格化的深色处理和装饰性光晕。

## 设计目标

- 保留 Hermes 仪表板的默认布局、尺寸和控件位置
- 使用原生系统字体，而非默认的风格化展示字体
- 保持灰度配色，在白底上保持高可读性
- 移除装饰性光晕、纹理和填充图像，避免浅色模式下分散注意力
- 保持仅图标控件、开关、徽章和小标签的可见性

## 截图

| Sessions | Config | Analytics |
|---|---|---|
| ![Sessions](public/sessions.webp) | ![Config](public/config.webp) | ![Analytics](public/analytics.webp) |

## 项目结构

```text
hermes-dashboard-theme-porcelain/
├── theme/
│   └── porcelain.yaml
├── plugin/
│   └── dashboard/
│       ├── manifest.json
│       ├── plugin_api.py
│       └── dist/
│           ├── index.js
│           └── style.css
├── docs/
│   └── FEATURES.md
├── scripts/
│   ├── dev.sh
│   └── install.sh
├── DESIGN.md
├── README.md
└── CONTRIBUTING.md
```

## 安装

### 一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/thedavidweng/hermes-dashboard-theme-porcelain/main/install.sh | bash
```

脚本会将仓库克隆到临时目录，安装主题及可选配套插件，然后自动清理。

### 本地安装（从源码）

```bash
./scripts/install.sh
```

安装脚本会将 `theme/porcelain.yaml` 复制到 `~/.hermes/dashboard-themes/`，
并询问是否安装配套插件。插件本身不是主题运行所必需的，但推荐安装，
因为它在其他主题激活时也能显示 Porcelain 色板预览，且无需修改 Hermes 核心。

#### 手动安装（不使用脚本）

```bash
mkdir -p ~/.hermes/dashboard-themes
cp theme/porcelain.yaml ~/.hermes/dashboard-themes/

mkdir -p ~/.hermes/plugins/porcelain-theme/dashboard
cp -r plugin/dashboard/. ~/.hermes/plugins/porcelain-theme/dashboard/
```

> **注意：** 源码仓库中插件文件位于 `plugin/dashboard/` 目录下（而非直接放在 `plugin/`）。
## 配套插件

当前 Hermes 在激活其他主题时，为用户 YAML 主题渲染占位符色块。YAML 主题无法改变这一状态，
因为其 `customCSS` 仅在主题被选中后才注入。

配套插件就是这个问题的可共享解决方案：它不修改 Hermes 源码，也不添加 UI 面板或页面横幅。
它仅修补现有的主题选择器 DOM，使 Porcelain 行能像内置主题一样显示色块。

## 开发

```bash
./scripts/dev.sh install
./scripts/dev.sh install-plugin
./scripts/dev.sh check
./scripts/dev.sh logs
```

发布更改前运行以下检查：

```bash
ruby -e 'require "yaml"; YAML.load_file("theme/porcelain.yaml")'
node --check plugin/dashboard/dist/index.js
python3 -m json.tool plugin/dashboard/manifest.json >/dev/null
bash -n scripts/dev.sh scripts/install.sh
git diff --check
```

## License

MIT.
