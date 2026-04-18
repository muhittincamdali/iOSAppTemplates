# FoodDeliveryApp

Last updated: 2026-04-19

`FoodDeliveryApp`, `iOSAppTemplates` icindeki Food Delivery lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Food Delivery`
- Entry: `Package.swift`
- Product target: `Food Delivery`

## Best For / Not For

### Best for

- restaurant, cart ve delivery shell incelemek isteyen ekipler
- food delivery lane icin package-entry seviyesinde app surface gormek isteyenler
- Wave 1 backlog icin gercek root/package kaniti isteyenler

### Not for

- bugun tam release-grade food delivery parity bekleyenler
- screenshot veya demo proof arayanlar
- explicit standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- restaurant discovery shell
- cart entry
- order status workflow
- delivery summary surface

## Current Proof

- `Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- local `swift test` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- canonical app proof page mevcut

## Missing Proof

- screenshot
- demo clip
- explicit standalone iOS-targeted CI proof

## Start Here

```bash
open Package.swift
open Package.resolved
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/FoodDeliveryApp.md)
- [Media Surface](../../Documentation/App-Media/FoodDeliveryApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
