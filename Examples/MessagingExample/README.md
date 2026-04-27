# MessagingExample

Generated from `Documentation/app-surface-catalog.json`.

`MessagingExample` is the richer example surface for the `Messaging / Community` lane.

## Product Shape

- conversation list flow
- chat thread surface
- contact or member routing
- composer starter flow

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `MessagingApp`
- readers who want to inspect the `Messaging / Community` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open ../../Templates/MessagingApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [MessagingApp Proof](../../Documentation/App-Proofs/MessagingApp.md)
- [MessagingApp Media](../../Documentation/App-Media/MessagingApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
