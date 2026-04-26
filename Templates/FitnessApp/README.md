# FitnessApp

Generated from `Documentation/app-surface-catalog.json`.

`FitnessApp` is the standalone-root surface for the `Health / Fitness` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root`
- Lane: `Health / Fitness`
- Entry: `Package.swift`
- Product target: `Health / Fitness`

## Best For / Not For

### Best for

- teams reviewing a fitness app-shell package entry
- maintainers validating HealthKit-oriented starter surfaces
- readers comparing standalone app packaging against family-level health templates

### Not for

- teams expecting a richer example route today
- readers who assume canonical screenshots and demo clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- dashboard shell
- goal and workout surface
- health metric cards
- progress summary shell
- starter health domain model

## Current Proof

- `Package.resolved` exists as the tracked dependency lockfile
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme FitnessApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh FitnessApp` passes locally
- root repo `swift build -c release` passes
- root repo `swift test` passes
- canonical app proof page exists
- canonical app media page exists
- runtime screenshot is published
- demo clip is published

## Missing Proof

- stable green hosted standalone iOS baseline on current `master`

## Start Here

```bash
open Package.swift
open Package.resolved
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme FitnessApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/FitnessApp.md)
- [Media Surface](../../Documentation/App-Media/FitnessApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
