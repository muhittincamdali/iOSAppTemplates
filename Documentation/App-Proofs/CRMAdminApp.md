# CRMAdminApp Proof Surface

Generated from `Documentation/app-surface-catalog.json`.

## Product Summary

- Lane: `CRM / Admin`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/CRMAdminApp/Package.swift`
- Extra route: `Examples/CRMAdminExample`
- Product target: `CRM / Admin Companion`

## Best For / Not For

### Best for

- teams evaluating admin and lead-management starter flows
- readers comparing CRM-style surfaces against collaboration roots
- maintainers reviewing operations-first dashboards

### Not for

- teams expecting backend-integrated CRM operations today
- readers who assume runtime screenshots and demo clips are already published
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape Today

- admin dashboard shell
- lead or client list surface
- pipeline starter cards
- operations summary
- CRM starter domain model

## Current Proof

- standalone root package exists
- template-root README exists
- `Templates/CRMAdminApp/Package.swift` exists
- local generic iOS build proof is tracked via `xcodebuild -scheme CRMAdminApp -destination 'generic/platform=iOS' build`
- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`
- root repo `swift build -c release` passes
- root repo `swift test` passes
- `Examples/CRMAdminExample` inspection route exists

## Missing Proof

- runtime screenshot not yet published
- demo clip not yet published
- stable green hosted standalone iOS baseline should be checked on current `master`

## Start Path

```bash
open Templates/CRMAdminApp/Package.swift
open Examples/CRMAdminExample/README.md
xcodebuild -scheme CRMAdminApp -destination 'generic/platform=iOS' build
```

Then validate the root package:

```bash
swift build -c release
swift test
```

## Canonical References

- [Template Root README](../../Templates/CRMAdminApp/README.md)
- [Richer Example](../../Examples/CRMAdminExample/README.md)
- [App Media Surface](../App-Media/CRMAdminApp.md)
- [Template Showcase](../Template-Showcase.md)
- [Proof Matrix](../Proof-Matrix.md)
- [Portfolio Matrix](../Portfolio-Matrix.md)
