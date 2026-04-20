# PrivacyVaultApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `Privacy / Secure Vault`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/PrivacyVaultApp/Package.swift`
- Extra route: `Examples/PrivacyVaultExample`
- Product target: `Privacy / Secure Vault`

## Best For / Not For

### Best for

- teams evaluating a privacy-first storage starter shell
- readers comparing security-oriented packaging with a richer example route
- maintainers reviewing secure-list and vault UI patterns

### Not for

- teams expecting production audited secure storage today
- readers who assume runtime screenshots and demo clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- vault overview shell
- secure item list surface
- detail and reveal starter flow
- privacy settings shell
- secure-vault starter model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/PrivacyVaultApp/Package.swift` exists
- local generic iOS build proof is tracked via `xcodebuild -scheme PrivacyVaultApp -destination 'generic/platform=iOS' build`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- `Examples/PrivacyVaultExample` inspection route exists

## Missing Proof

- runtime screenshot not yet published
- demo clip not yet published
- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/PrivacyVaultApp/Package.swift
open Examples/PrivacyVaultExample/README.md
xcodebuild -scheme PrivacyVaultApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/PrivacyVaultApp/README.md)
- [Richer Example](../../Examples/PrivacyVaultExample/README.md)
- [App Media Surface](../App-Media/PrivacyVaultApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
