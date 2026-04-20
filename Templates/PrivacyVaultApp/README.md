# PrivacyVaultApp

Generated from `Documentation/app-surface-catalog.json`.

`PrivacyVaultApp` is the standalone-root surface for the `Privacy / Secure Vault` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example surface`
- Lane: `Privacy / Secure Vault`
- Entry: `Package.swift`
- Product target: `Privacy / Secure Vault`
- Richer example: `Examples/PrivacyVaultExample`

## Best For / Not For

### Best for

- teams evaluating a privacy-first storage starter shell
- readers comparing security-oriented packaging with a richer example route
- maintainers reviewing secure-list and vault UI patterns

### Not for

- teams expecting production audited secure storage today
- readers who assume runtime screenshots and demo clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- vault overview shell
- secure item list surface
- detail and reveal starter flow
- privacy settings shell
- secure-vault starter model

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme PrivacyVaultApp -destination 'generic/platform=iOS' build` passes
- root repo `swift build -c release` passes
- root repo `swift test` passes
- canonical app proof page exists
- canonical app media page exists
- richer example route exists

## Missing Proof

- runtime screenshot
- demo clip
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
