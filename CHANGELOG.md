# Changelog

All notable changes to this theme are documented here.

## [Unreleased]

### Changed
- Rebuilt the Porcelain CSS around Hermes' actual theme hooks and DOM targets.
- Restored default Hermes layout sizing by using the default `0.5rem` radius and removing theme-level card/tab/badge geometry overrides.
- Forced Hermes display utility classes to use the native system font stack.
- Made the navigation icon and switch thumbs visible on the light canvas.
- Disabled the default filler image layer that produced an opaque circular artifact in light mode.

### Removed
- Removed obsolete demo wording and unused plugin slot UI.

## [1.0.0] - 2026-04-25

### Added
- Initial Porcelain theme for Hermes Dashboard.
- Optional companion plugin for the Porcelain swatch preview in the theme picker.

[Unreleased]: https://github.com/thedavidweng/hermes-dashboard-theme-porcelain/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/thedavidweng/hermes-dashboard-theme-porcelain/releases/tag/v1.0.0
