# CRMAdminApp

Generated from `Documentation/app-surface-catalog.json`.

`CRMAdminApp` is the standalone-root surface for the `CRM / Admin` lane inside `iOSAppTemplates`.

## Today

- Label: `Standalone Root + richer example + rebuilt runtime flow`
- Lane: `CRM / Admin`
- Entry: `Package.swift`
- Product target: `CRM / Admin Companion`
- Richer example: `Examples/CRMAdminExample`

## Best For / Not For

### Best for

- teams evaluating admin and lead-management starter flows
- readers comparing CRM-style surfaces against collaboration roots
- maintainers reviewing operations-first dashboards

### Not for

- teams expecting backend-integrated CRM operations today
- readers who expect automated multi-step interaction proof beyond the current first-screen runtime proof set
- teams that assume the hosted standalone iOS workflow is already green for this app pack

## Product Shape

- admin dashboard flow
- lead or client list surface
- pipeline starter cards
- operations summary
- CRM starter domain model

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` passes
- local `swift test` passes
- `xcodebuild -scheme CRMAdminApp -destination 'generic/platform=iOS' build` passes
- `bash Scripts/validate-runtime-app-launches.sh CRMAdminApp` passes locally
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
open ../../Examples/CRMAdminExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme CRMAdminApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/CRMAdminApp.md)
- [Media Surface](../../Documentation/App-Media/CRMAdminApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
- [Richer Example](../../Examples/CRMAdminExample/README.md)
