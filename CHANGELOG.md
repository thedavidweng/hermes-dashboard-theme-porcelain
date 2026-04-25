# Changelog

All notable changes to this theme will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-04-25

### Added
- Initial Porcelain theme for Hermes Dashboard
- Pure white canvas (`palette.background: #ffffff`)
- Grayscale color system (`#374151` primary, gray-scale overrides)
- 12px global border radius (`layout.radius: "12px"`)
- Pill-shaped navigation tabs via `componentStyles.tab.clipPath`
- Lightweight shadow on cards for depth
- Glassmorphism header (semi-transparent + backdrop blur)
- Custom scrollbar styling
- Table styling with zebra striping and hover states
- `.stat-card-bar` utility for bar chart visualization
- Badge/Tab/Progress pill shapes
- Full `customCSS` for selector-level control (tables, code blocks, modals, tooltips, dropdowskeleton loading animation)

### Companion Plugin (optional)
- Sidebar HUD displaying realtime agent status (sessions, version, uptime, model)
- Header crest support (reads `--theme-asset-crest` from active theme)
- Sessions page top banner augmentation
- `plugin_api.py` skeleton for custom backend routes

### Documentation
- Comprehensive README with design philosophy
- FEATURES.md for hackathon submission
- Contributing guide (CONTRIBUTING.md)
- Install script (`scripts/install.sh`)
- Dev helper (`scripts/dev.sh`)

[Unreleased]: https://github.com/thedavidweng/hermes-dashboard-theme-porcelain/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/thedavidweng/hermes-dashboard-theme-porcelain/releases/tag/v1.0.0
