# EcommerceApp Proof Surface

Last updated: 2026-04-20

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
- local generic iOS build proof'unun zaten track edildigini varsayanlar

## Product Shape Today

- auth shell
- product catalog
- featured products
- cart flow
- checkout/order domain surface

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/EcommerceApp/Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- source shell mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- explicit generic iOS build proof henuz tracked degil
- hosted standalone iOS CI proof yok

## Start Path

```bash
open Templates/EcommerceApp/Package.swift
open Templates/EcommerceApp/Package.resolved
```

Ardindan:

```bash
swift build
swift test
```

Bu ikinci yol root repo proof'unu dogrular; `Templates/EcommerceApp` icin tek basina hosted iOS build proof'u sayilmaz.

## Canonical References

- [Template Root README](../../Templates/EcommerceApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
