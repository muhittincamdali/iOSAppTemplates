# EcommerceExample

Generated from `Documentation/app-surface-catalog.json`.

`EcommerceExample` is the richer example surface for the `Commerce` lane.

## Product Shape

- auth flow
- catalog and featured-product surface
- cart flow
- checkout flow

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `EcommerceApp`
- readers who want to inspect the `E-Commerce Store` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open ../../Templates/EcommerceApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [EcommerceApp Proof](../../Documentation/App-Proofs/EcommerceApp.md)
- [EcommerceApp Media](../../Documentation/App-Media/EcommerceApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
