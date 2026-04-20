# FitnessApp

Last updated: 2026-04-20

`FitnessApp`, `iOSAppTemplates` icindeki Health / Fitness lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Health / Fitness`
- Entry: `Package.swift`
- Product target: `Health / Fitness`

## Best For / Not For

### Best for

- workout/progress shell incelemek isteyen ekipler
- HealthKit-adjacent source surface gormek isteyenler
- package-entry seviyesinde fitness lane app shell okumak isteyenler

### Not for

- bugun release-grade fitness app parity bekleyenler
- canonical screenshot veya demo proof arayanlar
- explicit standalone iOS CI proof'u var sananlar

## Product Shape

- auth shell
- workout model/manager surface
- progress tracking shell
- HealthKit-adjacent manager surface

## Current Proof

- `Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- `xcodebuild -scheme FitnessApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- canonical app proof page mevcut

## Missing Proof

- screenshot
- demo clip
- hosted standalone iOS CI proof

## Start Here

```bash
open Package.swift
open Package.resolved
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

Standalone generic iOS proof:

```bash
xcodebuild -scheme FitnessApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/FitnessApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
