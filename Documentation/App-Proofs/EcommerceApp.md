# EcommerceApp Proof Surface

Last updated: 2026-04-18

## Product Summary

- Lane: `Commerce`
- Label today: `Standalone Root`
- Entry path: `Templates/EcommerceApp/Package.swift`
- Product target: `E-Commerce Store`

## Best For / Not For

### Best for

- store, catalog, cart, checkout shell incelemek isteyen ekipler
- commerce lane icin SwiftUI source surface gormek isteyenler
- `Templates/` altinda package-entry inspection isteyenler

### Not for

- bugun full release-grade ecommerce app bekleyenler
- canonical screenshot/demo proof arayanlar
- standalone iOS CI proof'unun zaten var oldugunu varsayanlar

## Product Shape Today

- auth shell
- product catalog
- featured products
- cart flow
- checkout/order domain surface

## Current Proof

- standalone root package mevcut
- `swift package dump-package` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- source shell mevcut

## Missing Proof

- app-specific README `Templates/EcommerceApp` altinda yok
- canonical screenshot yok
- demo clip yok
- explicit standalone iOS-targeted CI proof yok

## Start Path

```bash
open Templates/EcommerceApp/Package.swift
```

Ardindan:

```bash
swift build
swift test
```

Bu ikinci yol root repo proof'unu dogrular; `Templates/EcommerceApp` icin tek basina hosted iOS build proof'u sayilmaz.

## Canonical References

- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
