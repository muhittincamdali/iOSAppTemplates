# MusicPodcastApp Proof Surface

Last updated: 2026-04-20

## Product Summary

- Lane: `Music / Podcast`
- Label today: `Standalone Root + richer example surface`
- Entry path: `Templates/MusicPodcastApp/Package.swift`
- Extra route: `Examples/MusicPodcastExample`
- Product target: `Music / Podcast`

## Best For / Not For

### Best for

- playback dashboard, queue ve collection shell incelemek isteyen ekipler
- standalone root ile richer example surface'i birlikte gormek isteyenler
- Wave 2 icin gercek music/podcast packaging kaniti isteyenler

### Not for

- bugun complete streaming parity bekleyenler
- screenshot/demo proof'un zaten mevcut oldugunu varsayanlar
- hosted standalone iOS CI proof'unun verildigini dusunenler

## Product Shape Today

- playback center shell
- collection/library routing
- podcast queue entry
- offline and subscription quick actions
- richer music/podcast example route

## Current Proof

- standalone root package mevcut
- template-root README mevcut
- `Templates/MusicPodcastApp/Package.swift` dependency-free app shell graph'i veriyor; no external dependency lockfile is required
- `swift package dump-package` gecerli
- `cd Templates/MusicPodcastApp && swift test` gecerli
- `xcodebuild -scheme MusicPodcastApp -destination 'generic/platform=iOS' build` gecerli
- root repo `swift build -c release` gecerli
- root repo `swift test` gecerli
- `Examples/MusicPodcastExample` inspection route mevcut

## Missing Proof

- canonical screenshot yok
- demo clip yok
- hosted standalone iOS CI proof yok

## Start Path

```bash
open Templates/MusicPodcastApp/Package.swift
open Examples/MusicPodcastExample/README.md
```

Root repo proof icin:

```bash
swift build
swift test
```

Standalone generic iOS proof icin:

```bash
cd Templates/MusicPodcastApp
xcodebuild -scheme MusicPodcastApp -destination 'generic/platform=iOS' build
```

## Canonical References

- [Template Root README](../../Templates/MusicPodcastApp/README.md)
- [../Template-Showcase.md](../Template-Showcase.md)
- [../Proof-Matrix.md](../Proof-Matrix.md)
- [../Portfolio-Matrix.md](../Portfolio-Matrix.md)
