# NewsBlog Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `NewsBlogApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve newsroom workflow proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/NewsBlogApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- news/editorial lane icin briefing, section feed ve reader mode yonunu gormek
- Wave 2 app-pack icin richer example surface'i takip etmek
- editorial decision surface ve content workflow naming incelemek

## Start Here

```bash
open ../../Templates/NewsBlogApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Portfolio Matrix](../../Documentation/Portfolio-Matrix.md)
- [NewsBlog Proof](../../Documentation/App-Proofs/NewsBlogApp.md)
- [NewsBlog Media](../../Documentation/App-Media/NewsBlogApp.md)
