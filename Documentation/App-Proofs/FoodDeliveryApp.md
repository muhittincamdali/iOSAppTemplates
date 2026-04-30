# FoodDeliveryApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Food Delivery`
- Label today: `Standalone Root + richer example + chained runtime flow`
- Entry path: `Templates/FoodDeliveryApp/Package.swift`
- Extra route: `Examples/FoodDeliveryExample`
- Product target: `Food Delivery`

## Best For / Not For

### Best for

- teams inspecting restaurant and order-flow starter surfaces
- readers who want a delivery lane with a richer example route
- maintainers reviewing map, cart, and order-status starter patterns

### Not for

- teams expecting production delivery logistics today
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- restaurant discovery flow
- menu and item cards
- cart flow
- order tracking flow
- starter delivery domain model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/FoodDeliveryApp/Package.swift` exists
- `Templates/FoodDeliveryApp/Package.resolved` exists as the tracked dependency lockfile
- local generic iOS build proof is tracked via `xcodebuild -scheme FoodDeliveryApp -destination 'generic/platform=iOS' build`
- local simulator runtime launch proof is tracked via `bash Scripts/validate-runtime-app-launches.sh FoodDeliveryApp`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- runtime screenshot is published: [../Assets/AppScreenshots/FoodDeliveryApp.png](../Assets/AppScreenshots/FoodDeliveryApp.png)
- demo clip is published: [../Assets/AppDemoClips/FoodDeliveryApp.mp4](../Assets/AppDemoClips/FoodDeliveryApp.mp4)
- launch-to-ready scenario frames are published: [launch](../Assets/AppScenarioShots/FoodDeliveryApp-launch.png) / [ready](../Assets/AppScenarioShots/FoodDeliveryApp-ready.png)
- `Examples/FoodDeliveryExample` inspection route exists

## Missing Proof

- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/FoodDeliveryApp/Package.swift
open Templates/FoodDeliveryApp/Package.resolved
open Examples/FoodDeliveryExample/README.md
xcodebuild -scheme FoodDeliveryApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/FoodDeliveryApp/README.md)
- [Richer Example](../../Examples/FoodDeliveryExample/README.md)
- [App Media Surface](../App-Media/FoodDeliveryApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
