# EducationApp

Last updated: 2026-04-19

`EducationApp`, `iOSAppTemplates` icindeki Education lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Education`
- Entry: `Package.swift`
- Product target: `Education / Learning`

## Best For / Not For

### Best for

- course, quiz ve progress shell incelemek isteyen ekipler
- education lane icin package-entry seviyesinde app surface gormek isteyenler
- Wave 1 backlog icin gercek root/package kaniti isteyenler

### Not for

- bugun tam release-grade education suite parity bekleyenler
- screenshot veya demo proof arayanlar
- explicit standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- learning dashboard shell
- course summary surface
- quiz entry
- progress workflow

## Current Proof

- `Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- local `swift test` gecerli
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
open Package.resolved
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/EducationApp.md)
- [Media Surface](../../Documentation/App-Media/EducationApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
