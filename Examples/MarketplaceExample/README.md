# MarketplaceExample

Generated from `Documentation/app-surface-catalog.json`.

`MarketplaceExample` is the richer example surface for the `Marketplace` lane.

## Product Shape

- listing discovery shell
- seller highlight cards
- product detail starter flow
- saved or cart-adjacent surface

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `MarketplaceApp`
- readers who want to inspect the `Marketplace` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect deeper multi-screen runtime scenario proof than the current published media set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open ../../Templates/MarketplaceApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [MarketplaceApp Proof](../../Documentation/App-Proofs/MarketplaceApp.md)
- [MarketplaceApp Media](../../Documentation/App-Media/MarketplaceApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
