# Subscription Lifestyle Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `SubscriptionLifestyleApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve subscription workflow proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/SubscriptionLifestyleApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- subscription lifestyle lane icin retention, streak ve paywall workflow yonunu gormek
- Wave 3 app-pack icin richer example surface'i takip etmek
- membership operations naming ve retention actions incelemek

## Start Here

```bash
open ../../Templates/SubscriptionLifestyleApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Portfolio Matrix](../../Documentation/Portfolio-Matrix.md)
- [SubscriptionLifestyleApp Proof](../../Documentation/App-Proofs/SubscriptionLifestyleApp.md)
- [SubscriptionLifestyleApp Media](../../Documentation/App-Media/SubscriptionLifestyleApp.md)
