# PrivacyVaultExample

Generated from `Documentation/app-surface-catalog.json`.

`PrivacyVaultExample` is the richer example surface for the `Privacy / Secure Vault` lane.

## Product Shape

- vault overview flow
- secure item list surface
- detail and reveal starter flow
- privacy settings flow

## Best For / Not For

### Best for

- teams that want a second inspection route beyond `PrivacyVaultApp`
- readers who want to inspect the `Privacy / Secure Vault` flow in a more product-like format

### Not for

- teams expecting a separate runnable Xcode project
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set

## Current Truth

- this example is an inspection surface, not a separate shipped app project
- the canonical standalone package-entry path lives under `Templates/`
- canonical package validation remains the root-level `swift build` and `swift test` flow

## Start Here

```bash
open ../../Templates/PrivacyVaultApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Canonical References

- [PrivacyVaultApp Proof](../../Documentation/App-Proofs/PrivacyVaultApp.md)
- [PrivacyVaultApp Media](../../Documentation/App-Media/PrivacyVaultApp.md)
- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
