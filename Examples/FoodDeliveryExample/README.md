# Food Delivery Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `FoodDeliveryApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve performance proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/FoodDeliveryApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- food delivery lane icin discovery, cart ve order-tracking flow yonunu gormek
- Wave 1 app-pack icin richer example surface'i takip etmek
- naming, restaurant hierarchy ve delivery UX direction incelemek

## Start Here

```bash
open ../../Templates/FoodDeliveryApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
- [Food Delivery Proof](../../Documentation/App-Proofs/FoodDeliveryApp.md)
- [Food Delivery Media](../../Documentation/App-Media/FoodDeliveryApp.md)
