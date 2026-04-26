# FoodDeliveryExample

Generated from `Documentation/app-surface-catalog.json`.

`FoodDeliveryExample` is the richer example surface for the `Food Delivery` lane.

## Product Shape

- restaurant discovery shell
- menu and item cards
- cart flow
- order tracking shell

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `FoodDeliveryApp`
- readers who want to inspect the `Food Delivery` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect deeper multi-screen runtime scenario proof than the current published media set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open FoodDeliveryFlowExample.swift
open ../../Templates/FoodDeliveryApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [FoodDeliveryApp Proof](../../Documentation/App-Proofs/FoodDeliveryApp.md)
- [FoodDeliveryApp Media](../../Documentation/App-Media/FoodDeliveryApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
