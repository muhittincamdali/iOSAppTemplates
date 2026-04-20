# Creator Short Video Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `CreatorShortVideoApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve creator workflow proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/CreatorShortVideoApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- creator lane icin clip routing, publishing ve moderation workflow yonunu gormek
- Wave 2 app-pack icin richer example surface'i takip etmek
- short-video product naming ve creator decision surface incelemek

## Start Here

```bash
open ../../Templates/CreatorShortVideoApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Portfolio Matrix](../../Documentation/Portfolio-Matrix.md)
- [CreatorShortVideo Proof](../../Documentation/App-Proofs/CreatorShortVideoApp.md)
- [CreatorShortVideo Media](../../Documentation/App-Media/CreatorShortVideoApp.md)
