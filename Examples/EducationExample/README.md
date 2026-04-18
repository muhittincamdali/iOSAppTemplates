# Education Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `EducationApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve performance proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/EducationApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- education lane icin dashboard, course ve quiz flow yonunu gormek
- Wave 1 app-pack icin richer example surface'i takip etmek
- naming, progression ve learning UX direction incelemek

## Start Here

```bash
open ../../Templates/EducationApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Wave 1 Plan](../../Documentation/Wave-1-Implementation-Plan.md)
- [Education Proof](../../Documentation/App-Proofs/EducationApp.md)
- [Education Media](../../Documentation/App-Media/EducationApp.md)
