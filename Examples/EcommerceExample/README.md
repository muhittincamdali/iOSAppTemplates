# Ecommerce Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `EcommerceApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve payment-provider proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/EcommerceApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- commerce lane icin catalog, cart ve checkout akisini daha zengin okumak
- Wave 1 app-pack icin richer example surface'i takip etmek
- product-card, merch, promo ve basket UX direction incelemek

## Start Here

```bash
open ../../Templates/EcommerceApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
- [Ecommerce Proof](../../Documentation/App-Proofs/EcommerceApp.md)
- [Ecommerce Media](../../Documentation/App-Media/EcommerceApp.md)
