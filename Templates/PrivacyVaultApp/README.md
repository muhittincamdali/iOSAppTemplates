# PrivacyVaultApp

Generated from `Documentation/app-surface-catalog.json`.

`PrivacyVaultApp` is the standalone-root surface for the `Privacy / Secure Vault` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example + rebuilt runtime flow`
- Lane: `Privacy / Secure Vault`
- Entry: `Package.swift`
- Product target: `Privacy / Secure Vault`
- Richer example: `Examples/PrivacyVaultExample`

## Best For / Not For

### Best for

- teams evaluating a privacy-first storage starter flow
- readers comparing security-oriented packaging with a richer example route
- maintainers reviewing secure-list and vault UI patterns

### Not for

- teams expecting production audited secure storage today
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- vault overview flow
- secure item list surface
- detail and reveal starter flow
- privacy settings flow
- secure-vault starter model

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme PrivacyVaultApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh PrivacyVaultApp` passes locally
- root repo `swift build -c release` passes
- root repo `swift test` passes
- canonical app proof page exists
- canonical app media page exists
- runtime screenshot is published
- demo clip is published
- richer example route exists

## Missing Proof

- stable green hosted standalone iOS baseline on current `master`

## Start Here

```bash
open Package.swift
open ../../Examples/PrivacyVaultExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme PrivacyVaultApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/PrivacyVaultApp.md)
- [Media Surface](../../Documentation/App-Media/PrivacyVaultApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/PrivacyVaultExample/README.md)
