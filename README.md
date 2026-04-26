# Hermes Dashboard Theme: Porcelain

[English](README.md) · [简体中文](README.zh-CN.md)


Porcelain is a minimal, readable light theme for the Hermes Agent dashboard.
It keeps the dashboard layout and interaction model intact while replacing the
default stylized dark treatment with a quiet monochrome surface, system fonts,
and higher contrast controls.

## Design Goals

- Preserve the default Hermes dashboard layout, sizing, and controls.
- Use native system fonts instead of the default stylized display fonts.
- Keep the palette grayscale and readable on a white canvas.
- Remove decorative glow, grain, and filler imagery that become distracting in light mode.
- Keep icon-only controls, switches, badges, and small labels visible.

## Screenshots

| Sessions | Config | Analytics |
|---|---|---|
| ![Sessions](public/sessions.webp) | ![Config](public/config.webp) | ![Analytics](public/analytics.webp) |

## Project Structure

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

## Install

### One-line installer (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/thedavidweng/hermes-dashboard-theme-porcelain/main/install.sh | bash
```

The script clones this repo to a temp directory, installs the theme and optional companion plugin, then cleans up.

### Local install (from source)

```bash
./scripts/install.sh
```

The installer copies `theme/porcelain.yaml` to `~/.hermes/dashboard-themes/`.
It also offers to install the companion plugin. The plugin is optional for the theme itself, but recommended
because it adds the Porcelain swatch preview while other themes are active
without patching Hermes core.

#### Manual install (no scripts)

```bash
mkdir -p ~/.hermes/dashboard-themes
cp theme/porcelain.yaml ~/.hermes/dashboard-themes/

mkdir -p ~/.hermes/plugins/porcelain-theme/dashboard
cp -r plugin/dashboard/. ~/.hermes/plugins/porcelain-theme/dashboard/
```

> **Note:** The source repo stores plugin files under `plugin/dashboard/` (not `plugin/` directly).
## Companion Plugin

Hermes currently renders placeholder swatches for user YAML themes when another
theme is active. A YAML theme cannot affect that state because its `customCSS` is
only injected after the theme is selected.

The companion plugin is the shareable workaround: it does not modify Hermes
source code, and it does not add UI panels or page banners. It only patches the
existing theme picker DOM so the Porcelain row shows the same kind of swatch as
built-in themes.

## Development

```bash
./scripts/dev.sh install
./scripts/dev.sh install-plugin
./scripts/dev.sh check
./scripts/dev.sh logs
```

Run these checks before publishing changes:

```bash
ruby -e 'require "yaml"; YAML.load_file("theme/porcelain.yaml")'
node --check plugin/dashboard/dist/index.js
python3 -m json.tool plugin/dashboard/manifest.json >/dev/null
bash -n scripts/dev.sh scripts/install.sh
git diff --check
```

## License

MIT.
