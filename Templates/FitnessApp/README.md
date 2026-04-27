# FitnessApp

Generated from `Documentation/app-surface-catalog.json`.

`FitnessApp` is the standalone-root surface for the `Health / Fitness` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example + rebuilt runtime flow`
- Lane: `Health / Fitness`
- Entry: `Package.swift`
- Product target: `Health / Fitness`
- Richer example: `Examples/FitnessExample`

## Best For / Not For

### Best for

- teams reviewing a fitness app flow package entry
- maintainers validating HealthKit-oriented starter surfaces
- readers comparing standalone app packaging against family-level health templates and a richer example route

### Not for

- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- dashboard flow
- goal and workout surface
- health metric cards
- progress summary flow
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
- richer example route exists

## Missing Proof

- stable green hosted standalone iOS baseline on current `master`

## Start Here

```bash
open Package.swift
open Package.resolved
open ../../Examples/FitnessExample/README.md
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
- [Richer Example](../../Examples/FitnessExample/README.md)
