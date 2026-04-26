# CreatorShortVideoExample

Generated from `Documentation/app-surface-catalog.json`.

`CreatorShortVideoExample` is the richer example surface for the `Creator / Short Video` lane.

## Product Shape

- creator feed shell
- clip card surface
- engagement starter routing
- publish or upload shell

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `CreatorShortVideoApp`
- readers who want to inspect the `Creator / Short Video` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect deeper interactive runtime flows than the current launch-to-ready scenario set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open ../../Templates/CreatorShortVideoApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [CreatorShortVideoApp Proof](../../Documentation/App-Proofs/CreatorShortVideoApp.md)
- [CreatorShortVideoApp Media](../../Documentation/App-Media/CreatorShortVideoApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
