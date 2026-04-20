# FinanceApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `Finance`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/FinanceApp/Package.swift`
- Extra route: `Examples/FinanceExample`
- Product target: `Finance / Budgeting`

## Best For / Not For

### Best for

- dashboard, account ve budget shell incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 1 icin gercek finance packaging kaniti isteyenler

### Not for

- bugun complete finance suite parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- teams that assume hosted standalone iOS proof is already green for this app pack

## Product Shape Today

- finance dashboard shell
- account snapshot surface
- budget review entry
- cash-flow quick actions
- richer finance example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/FinanceApp/Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- `cd Templates/FinanceApp && swift test` gecerli
- `xcodebuild -scheme FinanceApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/FinanceExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS proof workflow is active; check live GitHub status on master

## Start Path

```bash
open Templates/FinanceApp/Package.swift
open Templates/FinanceApp/Package.resolved
open Examples/FinanceExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/FinanceApp
xcodebuild -scheme FinanceApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/FinanceApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
