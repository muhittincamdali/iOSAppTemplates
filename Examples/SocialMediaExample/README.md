# SocialMediaExample

Generated from `Documentation/app-surface-catalog.json`.

`SocialMediaExample` is the richer example surface for the `Social` lane.

## Product Shape

- auth shell
- profile model surface
- feed and community shell
- notification manager surface

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `SocialMediaApp`
- readers who want to inspect the `Social Media` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect deeper multi-screen runtime scenario proof than the current published media set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open SocialMediaApp.swift
open ../../Templates/SocialMediaApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [SocialMediaApp Proof](../../Documentation/App-Proofs/SocialMediaApp.md)
- [SocialMediaApp Media](../../Documentation/App-Media/SocialMediaApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
