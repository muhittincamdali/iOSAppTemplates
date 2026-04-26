# ProductivityApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Productivity`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/ProductivityApp/Package.swift`
- Extra route: `Examples/ProductivityExample`
- Product target: `Productivity / Tasks`

## Best For / Not For

### Best for

- teams evaluating a dashboard-first productivity starter
- readers comparing root package and standalone shell packaging
- maintainers reviewing a reusable task and focus workspace surface

### Not for

- teams expecting a fully integrated collaboration suite today
- readers who expect deeper runtime scenario coverage than the current screenshot and demo proof
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- workspace dashboard
- task summary surface
- project counters
- focus-session actions
- starter quick-action model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/ProductivityApp/Package.swift` exists
- `Templates/ProductivityApp/Package.resolved` exists as the tracked dependency lockfile
- local generic iOS build proof is tracked via `xcodebuild -scheme ProductivityApp -destination 'generic/platform=iOS' build`
- local simulator runtime launch proof is tracked via `bash Scripts/validate-runtime-app-launches.sh ProductivityApp`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- runtime screenshot is published: [../Assets/AppScreenshots/ProductivityApp.png](../Assets/AppScreenshots/ProductivityApp.png)
- demo clip is published: [../Assets/AppDemoClips/ProductivityApp.mp4](../Assets/AppDemoClips/ProductivityApp.mp4)
- `Examples/ProductivityExample` inspection route exists

## Missing Proof

- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/ProductivityApp/Package.swift
open Templates/ProductivityApp/Package.resolved
open Examples/ProductivityExample/README.md
xcodebuild -scheme ProductivityApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/ProductivityApp/README.md)
- [Richer Example](../../Examples/ProductivityExample/README.md)
- [App Media Surface](../App-Media/ProductivityApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
