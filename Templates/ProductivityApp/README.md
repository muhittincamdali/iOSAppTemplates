# ProductivityApp

Last updated: 2026-04-20

`ProductivityApp`, `iOSAppTemplates` icindeki Productivity lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Productivity`
- Entry: `Package.swift`
- Product target: `Productivity / Tasks`

## Best For / Not For

### Best for

- task, project, focus-session shell incelemek isteyen ekipler
- productivity lane icin package-entry seviyesinde app surface gormek isteyenler
- Wave 1 backlog icin gercek root/package kaniti isteyenler

### Not for

- bugun tam release-grade productivity suite parity bekleyenler
- screenshot veya demo proof arayanlar
- explicit standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- task dashboard shell
- project summary surface
- focus session entry
- quick action workflow

## Current Proof

- `Package.resolved` lockfile mevcut
- `swift package dump-package` gecerli
- local `swift test` gecerli
- `xcodebuild -scheme ProductivityApp -destination 'generic/platform=iOS' build` gecerli
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
xcodebuild -scheme ProductivityApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/ProductivityApp.md)
- [Media Surface](../../Documentation/App-Media/ProductivityApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
