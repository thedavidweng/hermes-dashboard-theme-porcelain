# Contributing

Porcelain is meant to be a shareable Hermes dashboard theme. Changes should stay
inside this repository and must not require users to patch their Hermes install.

## Local Workflow

Edit the theme:

```bash
code theme/porcelain.yaml
```

Install locally:

```bash
./scripts/dev.sh install
./scripts/dev.sh install-plugin
```

Request a plugin rescan if the dashboard is running:

```bash
./scripts/dev.sh rescan
```

Open the dashboard at `http://127.0.0.1:9119`, select Porcelain, and refresh the
browser if needed.

## Scope Rules

- Preserve the default Hermes layout and control sizes.
- Prefer theme tokens and narrow CSS selectors over broad global overrides.
- Do not add plugin UI that changes the dashboard layout unless it is explicitly
  requested.
- Keep repository files, comments, scripts, and docs in English.
- Do not require per-machine Hermes source edits.

## Validation

```bash
ruby -e 'require "yaml"; YAML.load_file("theme/porcelain.yaml")'
node --check plugin/dist/index.js
python3 -m json.tool plugin/manifest.json >/dev/null
bash -n scripts/dev.sh scripts/install.sh
git diff --check
```

## Theme File Shape

```yaml
name: porcelain
label: Porcelain
description: Soft monochrome on white - clean and focused.
palette: ...
typography: ...
layout: ...
componentStyles: ...
customCSS: |
  ...
```

## Support

Use GitHub Issues for bugs and feature requests.
