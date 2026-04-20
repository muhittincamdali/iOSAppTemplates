# MarketplaceApp

Last updated: 2026-04-20

`MarketplaceApp`, `iOSAppTemplates` icindeki Marketplace lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Marketplace`
- Entry: `Package.swift`
- Extra route: `../../Examples/MarketplaceExample`
- Product target: `Marketplace`

## Best For / Not For

### Best for

- buyer/seller shell, category merchandising ve trust routing incelemek isteyen ekipler
- marketplace lane icin package-entry seviyesinde app surface gormek isteyenler
- Wave 2 expansion icin gercek root/package kaniti isteyenler

### Not for

- bugun tam multi-tenant marketplace parity bekleyenler
- screenshot veya demo proof arayanlar
- hosted standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- buyer marketplace dashboard
- seller trust and payout shell
- merchandising lanes
- dispute and protection quick actions

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` gecerli
- `cd Templates/MarketplaceApp && swift test` gecerli
- `xcodebuild -scheme MarketplaceApp -destination 'generic/platform=iOS' build` gecerli
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
xcodebuild -scheme MarketplaceApp -destination 'generic/platform=iOS' build
open ../../Examples/MarketplaceExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/MarketplaceApp.md)
- [Media Surface](../../Documentation/App-Media/MarketplaceApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
