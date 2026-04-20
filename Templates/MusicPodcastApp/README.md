# MusicPodcastApp

Last updated: 2026-04-20

`MusicPodcastApp`, `iOSAppTemplates` icindeki Music / Podcast lane standalone root surface'idir.

## Today

- Label: `Standalone Root`
- Lane: `Music / Podcast`
- Entry: `Package.swift`
- Extra route: `../../Examples/MusicPodcastExample`
- Product target: `Music / Podcast`

## Best For / Not For

### Best for

- playback dashboard, queue ve library shell incelemek isteyen ekipler
- music/podcast lane icin package-entry seviyesinde app surface gormek isteyenler
- Wave 2 expansion icin gercek root/package kaniti isteyenler

### Not for

- bugun tam release-grade streaming suite parity bekleyenler
- screenshot veya demo proof arayanlar
- hosted standalone iOS CI proof'un verildigini varsayanlar

## Product Shape

- playback center shell
- collection/library routing
- podcast queue entry
- offline and subscription quick actions

## Current Proof

- No external dependency lockfile is required today
- `swift package dump-package` gecerli
- `cd Templates/MusicPodcastApp && swift test` gecerli
- `xcodebuild -scheme MusicPodcastApp -destination 'generic/platform=iOS' build` gecerli
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
xcodebuild -scheme MusicPodcastApp -destination 'generic/platform=iOS' build
open ../../Examples/MusicPodcastExample/README.md
```

Repo-level proof:

```bash
cd ../..
swift build
swift test
```

## Canonical References

- [Proof Surface](../../Documentation/App-Proofs/MusicPodcastApp.md)
- [Media Surface](../../Documentation/App-Media/MusicPodcastApp.md)
- [Template Showcase](../../Documentation/Template-Showcase.md)
- [Proof Matrix](../../Documentation/Proof-Matrix.md)
