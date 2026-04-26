# FinanceExample

Generated from `Documentation/app-surface-catalog.json`.

`FinanceExample` is the richer example surface for the `Finance` lane.

## Product Shape

- account summary shell
- transaction overview
- budget category surface
- spending insight cards

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `FinanceApp`
- readers who want to inspect the `Finance / Budgeting` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect deeper multi-screen runtime scenario proof than the current published media set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open FinanceDashboardExample.swift
open ../../Templates/FinanceApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [FinanceApp Proof](../../Documentation/App-Proofs/FinanceApp.md)
- [FinanceApp Media](../../Documentation/App-Media/FinanceApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
