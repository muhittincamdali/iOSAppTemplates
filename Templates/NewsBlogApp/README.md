# NewsBlogApp

Last updated: 2026-04-20

`NewsBlogApp`, `iOSAppTemplates` icindeki News lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `News`
- Entry: `Package.swift`
- Extra route: `../../Examples/NewsBlogExample`
- Product target: `News / Editorial`

## Best For / Not For

### Best for

- editorial dashboard, section routing ve reader-mode shell incelemek isteyen ekipler
- news lane icin package-entry seviyesinde app surface gormek isteyenler
- Wave 2 expansion icin gercek root/package kaniti isteyenler

### Not for

- bugun tam release-grade newsroom suite parity bekleyenler
- screenshot veya demo proof arayanlar
- hosted standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- editorial briefing shell
- section/category routing
- reader mode entry
- newsletter and moderation quick actions

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` gecerli
- `cd Templates/NewsBlogApp && swift test` gecerli
- `xcodebuild -scheme NewsBlogApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- canonical app proof page mevcut
- richer example route mevcut

## Missing Proof

- screenshot
- demo clip
- hosted standalone iOS CI proof

## Start Here

```bash
open Package.swift
xcodebuild -scheme NewsBlogApp -destination 'generic/platform=iOS' build
open ../../Examples/NewsBlogExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/NewsBlogApp.md)
- [Media Surface](../../Documentation/App-Media/NewsBlogApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
