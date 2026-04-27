# EcommerceApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Commerce`
- Label today: `Standalone Root + richer example + rebuilt runtime flow`
- Entry path: `Templates/EcommerceApp/Package.swift`
- Extra route: `Examples/EcommerceExample`
- Product target: `E-Commerce Store`

## Best For / Not For

### Best for

- teams evaluating a catalog and checkout starter flow
- commerce lanes that need a SwiftUI package entry first
- maintainers comparing standalone root packaging against the richer example

### Not for

- teams that expect release-grade commerce integrations today
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- auth flow
- catalog and featured-product surface
- cart flow
- checkout flow
- order domain surface

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/EcommerceApp/Package.swift` exists
- no external dependency lockfile is required today
- local generic iOS build proof is tracked via `xcodebuild -scheme EcommerceApp -destination 'generic/platform=iOS' build`
- local simulator runtime launch proof is tracked via `bash Scripts/validate-runtime-app-launches.sh EcommerceApp`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- runtime screenshot is published: [../Assets/AppScreenshots/EcommerceApp.png](../Assets/AppScreenshots/EcommerceApp.png)
- demo clip is published: [../Assets/AppDemoClips/EcommerceApp.mp4](../Assets/AppDemoClips/EcommerceApp.mp4)
- launch-to-ready scenario frames are published: [launch](../Assets/AppScenarioShots/EcommerceApp-launch.png) / [ready](../Assets/AppScenarioShots/EcommerceApp-ready.png)
- `Examples/EcommerceExample` inspection route exists

## Missing Proof

- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/EcommerceApp/Package.swift
open Examples/EcommerceExample/README.md
xcodebuild -scheme EcommerceApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/EcommerceApp/README.md)
- [Richer Example](../../Examples/EcommerceExample/README.md)
- [App Media Surface](../App-Media/EcommerceApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
