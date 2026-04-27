# NewsBlogApp

Generated from `Documentation/app-surface-catalog.json`.

`NewsBlogApp` is the standalone-root surface for the `News` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example + rebuilt runtime flow`
- Lane: `News`
- Entry: `Package.swift`
- Product target: `News / Editorial`
- Richer example: `Examples/NewsBlogExample`

## Best For / Not For

### Best for

- teams evaluating editorial and article-list starter flows
- readers comparing news lane packaging and richer example routing
- maintainers reviewing content-first list and detail patterns

### Not for

- teams expecting a production newsroom platform today
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- headline list flow
- article detail surface
- category routing
- saved or trending content flow
- starter editorial model

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme NewsBlogApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh NewsBlogApp` passes locally
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
open ../../Examples/NewsBlogExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme NewsBlogApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/NewsBlogApp.md)
- [Media Surface](../../Documentation/App-Media/NewsBlogApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/NewsBlogExample/README.md)
