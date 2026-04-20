# CRMAdminApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `CRM / Admin`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/CRMAdminApp/Package.swift`
- Extra route: `Examples/CRMAdminExample`
- Product target: `CRM / Admin Companion`

## Best For / Not For

### Best for

- CRM admin shell, renewal board ve SLA routing incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 3 premium differentiation lane'i icin gercek packaging kaniti isteyenler

### Not for

- bugun full CRM parity veya backend-integrated ops proof bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- teams that assume hosted standalone iOS proof is already green for this app pack

## Product Shape Today

- CRM dashboard shell
- account and renewal workspace lanes
- SLA and operator workflow
- richer CRM example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/CRMAdminApp/Package.swift` dependency-free app shell graph'i veriyor; no external dependency lockfile is required
- `swift package dump-package` gecerli
- `cd Templates/CRMAdminApp && swift test` gecerli
- `xcodebuild -scheme CRMAdminApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/CRMAdminExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS proof workflow is active; check live GitHub status on master

## Start Path

```bash
open Templates/CRMAdminApp/Package.swift
open Examples/CRMAdminExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/CRMAdminApp
xcodebuild -scheme CRMAdminApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/CRMAdminApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
