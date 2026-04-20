# ProductivityApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `Productivity`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/ProductivityApp/Package.swift`
- Extra route: `Examples/ProductivityExample`
- Product target: `Productivity / Tasks`

## Best For / Not For

### Best for

- task, project ve focus-shell incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 1 icin gercek productivity packaging kaniti isteyenler

### Not for

- bugun complete productivity suite parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- hosted standalone iOS CI proof'unun verildigini dusunenler

## Product Shape Today

- task dashboard shell
- project summary surface
- focus-session entry
- quick action workflow
- richer productivity example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/ProductivityApp/Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- `cd Templates/ProductivityApp && swift test` gecerli
- `xcodebuild -scheme ProductivityApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/ProductivityExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS CI proof yok

## Start Path

```bash
open Templates/ProductivityApp/Package.swift
open Templates/ProductivityApp/Package.resolved
open Examples/ProductivityExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/ProductivityApp
xcodebuild -scheme ProductivityApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/ProductivityApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
