# FitnessApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `Health / Fitness`
- Label today: `Standalone Root`
- Entry path: `Templates/FitnessApp/Package.swift`
- Product target: `Health / Fitness`

## Best For / Not For

### Best for

- workout/progress shell incelemek isteyen ekipler
- HealthKit-adjacent source surface gormek isteyenler
- fitness lane icin package-entry inspection isteyenler

### Not for

- bugun tam release-grade fitness app bekleyenler
- canonical media proof arayanlar
- hosted standalone iOS CI proof'unun verildigini dusunenler

## Product Shape Today

- auth shell
- workout model/manager surface
- progress tracking shell
- HealthKit-adjacent manager surface

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/FitnessApp/Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- `xcodebuild -scheme FitnessApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- source shell mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS CI proof yok

## Start Path

```bash
open Templates/FitnessApp/Package.swift
open Templates/FitnessApp/Package.resolved
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/FitnessApp
xcodebuild -scheme FitnessApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/FitnessApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
