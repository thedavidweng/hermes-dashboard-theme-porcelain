# Hermes Dashboard Theme: Porcelain

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
│   ├── manifest.json
│   ├── plugin_api.py
│   └── dist/
│       ├── index.js
│       └── style.css
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

```bash
./scripts/install.sh
```

The installer copies `theme/porcelain.yaml` to `~/.hermes/dashboard-themes/`.
If it finds an older `minimalist.yaml` install that declares `name: porcelain`,
it moves that legacy file to `minimalist.yaml.disabled` so Hermes discovers the
current `porcelain.yaml` definition first. It also offers to install the
companion plugin. The plugin is optional for the theme itself, but recommended
because it adds the Porcelain swatch preview while other themes are active
without patching Hermes core.

Manual install:

```bash
mkdir -p ~/.hermes/dashboard-themes
if grep -Eq '^name:[[:space:]]*porcelain[[:space:]]*$' ~/.hermes/dashboard-themes/minimalist.yaml 2>/dev/null; then
  mv ~/.hermes/dashboard-themes/minimalist.yaml ~/.hermes/dashboard-themes/minimalist.yaml.disabled
fi
cp theme/porcelain.yaml ~/.hermes/dashboard-themes/

mkdir -p ~/.hermes/plugins/porcelain-theme/dashboard
cp -r plugin/. ~/.hermes/plugins/porcelain-theme/dashboard/
```

If the dashboard is already running, refresh the browser after installing the
theme. If you installed or changed the companion plugin, request a plugin rescan
or restart the dashboard.

```bash
curl http://127.0.0.1:9119/api/dashboard/plugins/rescan
```

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
node --check plugin/dist/index.js
python3 -m json.tool plugin/manifest.json >/dev/null
bash -n scripts/dev.sh scripts/install.sh
git diff --check
```

## License

MIT.
