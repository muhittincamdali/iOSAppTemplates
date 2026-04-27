# TeamCollaborationExample

Generated from `Documentation/app-surface-catalog.json`.

`TeamCollaborationExample` is the richer example surface for the `Team Collaboration` lane.

## Product Shape

- workspace flow
- team activity surface
- project board starter flow
- member cards

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `TeamCollaborationApp`
- readers who want to inspect the `Team Collaboration` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open ../../Templates/TeamCollaborationApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [TeamCollaborationApp Proof](../../Documentation/App-Proofs/TeamCollaborationApp.md)
- [TeamCollaborationApp Media](../../Documentation/App-Media/TeamCollaborationApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
