# Porcelain Theme Features

Porcelain is a minimal light theme for Hermes Agent. It keeps the existing
dashboard layout and replaces the default stylized visual language with a
readable monochrome treatment.

## Core Principles

| Principle | Implementation |
| --- | --- |
| Preserve layout | Uses the default Hermes layout variant, density, and `0.5rem` radius. |
| System typography | SF Pro/system font stack for UI text; system monospace for code. |
| White canvas | `#ffffff` background with grayscale text and borders. |
| Low decoration | Warm glow, noise, and default filler imagery are disabled. |
| Readable controls | Icon-only buttons, switches, badges, and small labels stay visible. |

## Theme Fields

### Palette

| Token | Value | Purpose |
| --- | --- | --- |
| `palette.background` | `#ffffff` | Page canvas |
| `palette.midground` | `#262626` | Primary text and icon color |
| `palette.foreground` | `#000000` | Strong foreground layer |
| `palette.warmGlow` | `rgba(0, 0, 0, 0)` | Disables glow |
| `palette.noiseOpacity` | `0` | Disables grain |

### Typography

| Property | Value |
| --- | --- |
| `fontSans` | `system-ui, -apple-system, BlinkMacSystemFont, 'SF Pro Text', 'SF Pro Display', 'Helvetica Neue', Arial, sans-serif` |
| `fontMono` | `ui-monospace, SFMono-Regular, 'SF Mono', Menlo, Monaco, Consolas, 'Liberation Mono', monospace` |
| `fontDisplay` | `system-ui, -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'SF Pro Text', 'Helvetica Neue', Arial, sans-serif` |
| `baseSize` | `15px` |
| `lineHeight` | `1.55` |
| `letterSpacing` | `0` |

### Component Styles

| Bucket | Purpose |
| --- | --- |
| `backdrop` | Disables the default filler backdrop layer without changing layout geometry. |

## Custom CSS

The CSS is intentionally scoped around Hermes structures that the YAML theme API
can reach:

- Forces Hermes display utility classes such as `font-mondwest` and
  `font-expanded` to use the system font stack.
- Cancels root-level uppercase transforms from the default theme.
- Targets the mobile navigation button through `aria-controls="app-sidebar"`.
- Targets Hermes switches through `button[role="switch"]` and controls both
  `translate` and `transform` so the thumb remains visible.
- Hides the default filler image layer that becomes an opaque artifact in light
  mode.

## Companion Plugin

The companion plugin is a shareable workaround for a Hermes limitation: user YAML
themes render with placeholder swatches when another theme is active. Because
Porcelain CSS is only injected after Porcelain is active, YAML alone cannot fix
that state.

The plugin adds the Porcelain swatch to the existing theme picker DOM without
patching Hermes source code and without adding page banners, sidebars, or other
layout changes.

## Validation

```bash
ruby -e 'require "yaml"; YAML.load_file("theme/porcelain.yaml")'
node --check plugin/dashboard/dist/index.js
python3 -m json.tool plugin/dashboard/manifest.json >/dev/null
bash -n scripts/dev.sh scripts/install.sh
git diff --check
```
