# FitnessApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Health / Fitness`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/FitnessApp/Package.swift`
- Extra route: `Examples/FitnessExample`
- Product target: `Health / Fitness`

## Best For / Not For

### Best for

- teams reviewing a fitness app-shell package entry
- maintainers validating HealthKit-oriented starter surfaces
- readers comparing standalone app packaging against family-level health templates and a richer example route

### Not for

- readers who expect deeper runtime scenario coverage than the current screenshot and demo proof
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
- `Templates/FitnessApp/Package.resolved` exists as the tracked dependency lockfile
- local generic iOS build proof is tracked via `xcodebuild -scheme FitnessApp -destination 'generic/platform=iOS' build`
- local simulator runtime launch proof is tracked via `bash Scripts/validate-runtime-app-launches.sh FitnessApp`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- runtime screenshot is published: [../Assets/AppScreenshots/FitnessApp.png](../Assets/AppScreenshots/FitnessApp.png)
- demo clip is published: [../Assets/AppDemoClips/FitnessApp.mp4](../Assets/AppDemoClips/FitnessApp.mp4)
- `Examples/FitnessExample` inspection route exists

## Missing Proof

- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/FitnessApp/Package.swift
open Templates/FitnessApp/Package.resolved
open Examples/FitnessExample/README.md
xcodebuild -scheme FitnessApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/FitnessApp/README.md)
- [Richer Example](../../Examples/FitnessExample/README.md)
- [App Media Surface](../App-Media/FitnessApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
