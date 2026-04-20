# CRMAdminApp

Last updated: 2026-04-20

`CRMAdminApp`, `iOSAppTemplates` icindeki CRM / Admin lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `CRM / Admin`
- Entry: `Package.swift`
- Extra route: `../../Examples/CRMAdminExample`
- Product target: `CRM / Admin Companion`

## Best For / Not For

### Best for

- B2B CRM ve admin workspace shell'i incelemek isteyen ekipler
- pipeline, SLA ve renewal routing icin package-entry seviyesinde app surface gormek isteyenler
- Wave 3 premium differentiation lane'i icin gercek root/package kaniti isteyenler

### Not for

- bugun tam CRM parity veya backend-integrated operations bekleyenler
- screenshot veya demo proof arayanlar
- hosted standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- CRM dashboard shell
- admin workspace lanes
- renewal and SLA workflow
- operator quick actions

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` gecerli
- `cd Templates/CRMAdminApp && swift test` gecerli
- `xcodebuild -scheme CRMAdminApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- canonical app proof page mevcut
- richer example route mevcut

## Missing Proof

- screenshot
- demo clip
- hosted standalone iOS CI proof

## Start Here

```bash
open Package.swift
xcodebuild -scheme CRMAdminApp -destination 'generic/platform=iOS' build
open ../../Examples/CRMAdminExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/CRMAdminApp.md)
- [Media Surface](../../Documentation/App-Media/CRMAdminApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
