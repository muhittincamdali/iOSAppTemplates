# FitnessApp Proof Surface

Last updated: 2026-04-21

## Product Summary

- Lane: `Health / Fitness`
- Label today: `Standalone Root`
- Entry path: `Templates/FitnessApp/Package.swift`
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

## Product Shape Today

- dashboard shell
- goal and workout surface
- health metric cards
- progress summary shell
- starter health domain model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/FitnessApp/Package.swift` exists
- `Templates/FitnessApp/Package.resolved` exists
- local generic iOS build proof is tracked via `xcodebuild -scheme FitnessApp -destination 'generic/platform=iOS' build`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes

## Missing Proof

- runtime screenshot not yet published
- demo clip not yet published
- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/FitnessApp/Package.swift
open Templates/FitnessApp/Package.resolved
xcodebuild -scheme FitnessApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/FitnessApp/README.md)
- [App Media Surface](../App-Media/FitnessApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
