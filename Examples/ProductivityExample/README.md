# Productivity Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `ProductivityApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve performance proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/ProductivityApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- productivity lane icin dashboard, task board ve focus flow yonunu gormek
- Wave 1 app-pack icin richer example surface'i takip etmek
- naming, feature slicing ve UI direction incelemek

## Start Here

```bash
open ../../Templates/ProductivityApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
- [Productivity Proof](../../Documentation/App-Proofs/ProductivityApp.md)
- [Productivity Media](../../Documentation/App-Media/ProductivityApp.md)
