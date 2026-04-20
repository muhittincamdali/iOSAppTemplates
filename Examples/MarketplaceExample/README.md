# Marketplace Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `MarketplaceApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve marketplace workflow proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/MarketplaceApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- marketplace lane icin buyer/seller, merchandising ve trust workflow yonunu gormek
- Wave 2 app-pack icin richer example surface'i takip etmek
- category routing ve seller operations naming incelemek

## Start Here

```bash
open ../../Templates/MarketplaceApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Portfolio Matrix](../../Documentation/Portfolio-Matrix.md)
- [Marketplace Proof](../../Documentation/App-Proofs/MarketplaceApp.md)
- [Marketplace Media](../../Documentation/App-Media/MarketplaceApp.md)
