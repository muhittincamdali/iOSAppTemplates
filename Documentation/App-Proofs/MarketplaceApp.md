# MarketplaceApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `Marketplace`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/MarketplaceApp/Package.swift`
- Extra route: `Examples/MarketplaceExample`
- Product target: `Marketplace`

## Best For / Not For

### Best for

- buyer/seller shell, merchandising lanes ve trust routing incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 2 icin gercek marketplace packaging kaniti isteyenler

### Not for

- bugun complete marketplace parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- hosted standalone iOS CI proof'unun verildigini dusunenler

## Product Shape Today

- merchandising dashboard shell
- category and seller routing
- payout and trust health surface
- richer marketplace example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/MarketplaceApp/Package.swift` dependency-free app shell graph'i veriyor; no external dependency lockfile is required
- `swift package dump-package` gecerli
- `cd Templates/MarketplaceApp && swift test` gecerli
- `xcodebuild -scheme MarketplaceApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/MarketplaceExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS CI proof yok

## Start Path

```bash
open Templates/MarketplaceApp/Package.swift
open Examples/MarketplaceExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/MarketplaceApp
xcodebuild -scheme MarketplaceApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/MarketplaceApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
