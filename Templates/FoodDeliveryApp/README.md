# FoodDeliveryApp

Generated from `Documentation/app-surface-catalog.json`.

`FoodDeliveryApp` is the standalone-root surface for the `Food Delivery` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Food Delivery`
- Entry: `Package.swift`
- Product target: `Food Delivery`
- Richer example: `Examples/FoodDeliveryExample`

## Best For / Not For

### Best for

- teams inspecting restaurant and order-flow starter surfaces
- readers who want a delivery lane with a richer example route
- maintainers reviewing map, cart, and order-status starter patterns

### Not for

- teams expecting production delivery logistics today
- readers who expect deeper interactive runtime flows than the current launch-to-ready scenario proof
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- restaurant discovery shell
- menu and item cards
- cart flow
- order tracking shell
- starter delivery domain model

## Current Proof

- `Package.resolved` exists as the tracked dependency lockfile
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme FoodDeliveryApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh FoodDeliveryApp` passes locally
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
open ../../Examples/FoodDeliveryExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme FoodDeliveryApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/FoodDeliveryApp.md)
- [Media Surface](../../Documentation/App-Media/FoodDeliveryApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/FoodDeliveryExample/README.md)
