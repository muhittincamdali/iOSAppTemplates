# EducationApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `Education`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/EducationApp/Package.swift`
- Extra route: `Examples/EducationExample`
- Product target: `Education / Learning`

## Best For / Not For

### Best for

- course, quiz ve progress shell incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 1 icin gercek education packaging kaniti isteyenler

### Not for

- bugun complete education suite parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- hosted standalone iOS CI proof'unun verildigini dusunenler

## Product Shape Today

- learning dashboard shell
- course summary surface
- quiz entry
- progress workflow
- richer education example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/EducationApp/Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- `cd Templates/EducationApp && swift test` gecerli
- `xcodebuild -scheme EducationApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/EducationExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS CI proof yok

## Start Path

```bash
open Templates/EducationApp/Package.swift
open Templates/EducationApp/Package.resolved
open Examples/EducationExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/EducationApp
xcodebuild -scheme EducationApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/EducationApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
