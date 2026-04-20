# Team Collaboration Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `TeamCollaborationApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve collaboration workflow proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/TeamCollaborationApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- collaboration lane icin workspace, project routing ve async handoff workflow yonunu gormek
- Wave 3 app-pack icin richer example surface'i takip etmek
- collaboration product naming ve review flow incelemek

## Start Here

```bash
open ../../Templates/TeamCollaborationApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Portfolio Matrix](../../Documentation/Portfolio-Matrix.md)
- [TeamCollaboration Proof](../../Documentation/App-Proofs/TeamCollaborationApp.md)
- [TeamCollaboration Media](../../Documentation/App-Media/TeamCollaborationApp.md)
