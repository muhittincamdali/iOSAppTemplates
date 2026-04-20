# FoodDeliveryApp Proof Surface

Last updated: 2026-04-21

## Product Summary

- Lane: `Food Delivery`
- Label today: `Standalone Root + richer example surface`
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
- readers who assume published runtime screenshots and clips already exist
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- restaurant discovery shell
- menu and item cards
- cart flow
- order tracking shell
- starter delivery domain model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/FoodDeliveryApp/Package.swift` exists
- `Templates/FoodDeliveryApp/Package.resolved` exists
- local generic iOS build proof is tracked via `xcodebuild -scheme FoodDeliveryApp -destination 'generic/platform=iOS' build`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- `Examples/FoodDeliveryExample` inspection route exists

## Missing Proof

- runtime screenshot not yet published
- demo clip not yet published
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
