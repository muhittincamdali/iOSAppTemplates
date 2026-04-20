# CRM Admin Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `CRMAdminApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve CRM workflow proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/CRMAdminApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- CRM / Admin lane icin pipeline, renewal ve SLA workflow yonunu gormek
- Wave 3 app-pack icin richer example surface'i takip etmek
- admin workspace naming ve operator actions incelemek

## Start Here

```bash
open ../../Templates/CRMAdminApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Portfolio Matrix](../../Documentation/Portfolio-Matrix.md)
- [CRMAdminApp Proof](../../Documentation/App-Proofs/CRMAdminApp.md)
- [CRMAdminApp Media](../../Documentation/App-Media/CRMAdminApp.md)
