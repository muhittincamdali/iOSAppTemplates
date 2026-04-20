# MusicPodcast Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `MusicPodcastApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve playback workflow proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/MusicPodcastApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- music/podcast lane icin playback, queue ve library yonunu gormek
- Wave 2 app-pack icin richer example surface'i takip etmek
- content discovery ve subscription UX direction incelemek

## Start Here

```bash
open ../../Templates/MusicPodcastApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Portfolio Matrix](../../Documentation/Portfolio-Matrix.md)
- [MusicPodcast Proof](../../Documentation/App-Proofs/MusicPodcastApp.md)
- [MusicPodcast Media](../../Documentation/App-Media/MusicPodcastApp.md)
