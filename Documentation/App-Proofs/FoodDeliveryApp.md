# FoodDeliveryApp Proof Surface

Last updated: 2026-04-19

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
- hosted standalone iOS build proof'unun verildigini dusunenler

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
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/FoodDeliveryExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- explicit standalone iOS-targeted CI proof yok

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

## Canonical References

- [Template Root README](../../Templates/FoodDeliveryApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
