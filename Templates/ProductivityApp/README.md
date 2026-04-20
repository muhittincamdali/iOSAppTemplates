# ProductivityApp

Generated from `Documentation/app-surface-catalog.json`.

`ProductivityApp` is the standalone-root surface for the `Productivity` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Productivity`
- Entry: `Package.swift`
- Product target: `Productivity / Tasks`
- Richer example: `Examples/ProductivityExample`

## Best For / Not For

### Best for

- teams evaluating a dashboard-first productivity starter
- readers comparing root package and standalone shell packaging
- maintainers reviewing a reusable task and focus workspace surface

### Not for

- teams expecting a fully integrated collaboration suite today
- readers who assume runtime screenshots and clips already exist
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- workspace dashboard
- task summary surface
- project counters
- focus-session actions
- starter quick-action model

## Current Proof

- `Package.resolved` exists as the tracked dependency lockfile
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme ProductivityApp -destination 'generic/platform=iOS' build` passes
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
open Package.resolved
open ../../Examples/ProductivityExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme ProductivityApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/ProductivityApp.md)
- [Media Surface](../../Documentation/App-Media/ProductivityApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/ProductivityExample/README.md)
