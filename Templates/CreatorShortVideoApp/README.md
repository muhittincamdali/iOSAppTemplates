# CreatorShortVideoApp

Generated from `Documentation/app-surface-catalog.json`.

`CreatorShortVideoApp` is the standalone-root surface for the `Creator / Short Video` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example + rebuilt runtime flow`
- Lane: `Creator / Short Video`
- Entry: `Package.swift`
- Product target: `Creator / Short Video`
- Richer example: `Examples/CreatorShortVideoExample`

## Best For / Not For

### Best for

- teams evaluating creator feed and publishing starter surfaces
- readers comparing creator-economy packaging with a richer example
- maintainers reviewing short-video oriented UI patterns

### Not for

- teams expecting production video pipelines today
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- creator feed flow
- clip card surface
- engagement starter routing
- publish or upload flow
- creator starter domain model

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme CreatorShortVideoApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh CreatorShortVideoApp` passes locally
- root repo `swift build -c release` passes
- root repo `swift test` passes
- canonical app proof page exists
- canonical app media page exists
- runtime screenshot is published
- demo clip is published
- richer example route exists

## Missing Proof

- stable green hosted standalone iOS baseline on current `master`

## Start Here

```bash
open Package.swift
open ../../Examples/CreatorShortVideoExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme CreatorShortVideoApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/CreatorShortVideoApp.md)
- [Media Surface](../../Documentation/App-Media/CreatorShortVideoApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/CreatorShortVideoExample/README.md)
