# EcommerceApp

Last updated: 2026-04-18

`EcommerceApp`, `iOSAppTemplates` icindeki Commerce lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Commerce`
- Entry: `Package.swift`
- Product target: `E-Commerce Store`

## Best For / Not For

### Best for

- catalog, cart, checkout shell incelemek isteyen ekipler
- package-entry seviyesinde commerce app shell gormek isteyenler
- root repo proof'u ile commerce lane source surface'ini birlikte okumak isteyenler

### Not for

- bugun full release-grade ecommerce app parity bekleyenler
- canonical screenshot veya demo proof arayanlar
- explicit standalone iOS CI proof'unun verildigini varsayanlar

## Product Shape

- auth shell
- product catalog
- featured products
- cart flow
- checkout/order surface

## Current Proof

- `swift package dump-package` gecerli
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
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/EcommerceApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
