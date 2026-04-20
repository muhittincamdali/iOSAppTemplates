# FoodDeliveryApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `Food Delivery`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/FoodDeliveryApp/Package.swift`
- Extra route: `Examples/FoodDeliveryExample`
- Product target: `Food Delivery`

## Best For / Not For

### Best for

- restaurant, cart ve tracking shell incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 1 icin gercek food delivery packaging kaniti isteyenler

### Not for

- bugun complete food delivery parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- teams that assume hosted standalone iOS proof is already green for this app pack

## Product Shape Today

- restaurant discovery shell
- cart entry
- order status workflow
- delivery summary surface
- richer food delivery example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/FoodDeliveryApp/Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- `cd Templates/FoodDeliveryApp && swift test` gecerli
- `xcodebuild -scheme FoodDeliveryApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/FoodDeliveryExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS proof workflow is active; check live GitHub status on master

## Start Path

```bash
open Templates/FoodDeliveryApp/Package.swift
open Templates/FoodDeliveryApp/Package.resolved
open Examples/FoodDeliveryExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/FoodDeliveryApp
xcodebuild -scheme FoodDeliveryApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/FoodDeliveryApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
