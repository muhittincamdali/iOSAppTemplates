# CRMAdminExample

Generated from `Documentation/app-surface-catalog.json`.

`CRMAdminExample` is the richer example surface for the `CRM / Admin` lane.

## Product Shape

- admin dashboard shell
- lead or client list surface
- pipeline starter cards
- operations summary

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `CRMAdminApp`
- readers who want to inspect the `CRM / Admin Companion` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect deeper multi-screen runtime scenario proof than the current published media set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open ../../Templates/CRMAdminApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [CRMAdminApp Proof](../../Documentation/App-Proofs/CRMAdminApp.md)
- [CRMAdminApp Media](../../Documentation/App-Media/CRMAdminApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
