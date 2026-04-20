# ProductivityExample

Generated from `Documentation/app-surface-catalog.json`.

`ProductivityExample` is the richer example surface for the `Productivity` lane.

## Product Shape

- workspace dashboard
- task summary surface
- project counters
- focus-session actions

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `ProductivityApp`
- readers who want to inspect the `Productivity / Tasks` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect published runtime screenshots or simulator media proof today

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open ProductivityWorkspaceExample.swift
open ../../Templates/ProductivityApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [ProductivityApp Proof](../../Documentation/App-Proofs/ProductivityApp.md)
- [ProductivityApp Media](../../Documentation/App-Media/ProductivityApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
