# NewsBlogExample

Generated from `Documentation/app-surface-catalog.json`.

`NewsBlogExample` is the richer example surface for the `News` lane.

## Product Shape

- headline list flow
- article detail surface
- category routing
- saved or trending content flow

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `NewsBlogApp`
- readers who want to inspect the `News / Editorial` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open ../../Templates/NewsBlogApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [NewsBlogApp Proof](../../Documentation/App-Proofs/NewsBlogApp.md)
- [NewsBlogApp Media](../../Documentation/App-Media/NewsBlogApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
