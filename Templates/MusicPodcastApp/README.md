# MusicPodcastApp

Generated from `Documentation/app-surface-catalog.json`.

`MusicPodcastApp` is the standalone-root surface for the `Music / Podcast` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Music / Podcast`
- Entry: `Package.swift`
- Product target: `Music / Podcast`
- Richer example: `Examples/MusicPodcastExample`

## Best For / Not For

### Best for

- teams evaluating media-library and player starter shells
- readers comparing entertainment packaging and richer example routing
- maintainers reviewing audio-first UI patterns

### Not for

- teams expecting production streaming infrastructure today
- readers who assume runtime screenshots and demo clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- library shell
- player surface
- episode or track cards
- queue starter flow
- media content model

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme MusicPodcastApp -destination 'generic/platform=iOS' build` passes
- root repo `swift build -c release` passes
- root repo `swift test` passes
- canonical app proof page exists
- canonical app media page exists
- richer example route exists

## Missing Proof

- runtime screenshot
- demo clip
- stable green hosted standalone iOS baseline on current `master`

## Start Here

```bash
open Package.swift
open ../../Examples/MusicPodcastExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme MusicPodcastApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/MusicPodcastApp.md)
- [Media Surface](../../Documentation/App-Media/MusicPodcastApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/MusicPodcastExample/README.md)
