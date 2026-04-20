# Notes Knowledge Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `NotesKnowledgeApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve knowledge workflow proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/NotesKnowledgeApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- notes lane icin capture, collection routing ve shared-space workflow yonunu gormek
- Wave 2 app-pack icin richer example surface'i takip etmek
- knowledge system naming ve review flow incelemek

## Start Here

```bash
open ../../Templates/NotesKnowledgeApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Portfolio Matrix](../../Documentation/Portfolio-Matrix.md)
- [NotesKnowledge Proof](../../Documentation/App-Proofs/NotesKnowledgeApp.md)
- [NotesKnowledge Media](../../Documentation/App-Media/NotesKnowledgeApp.md)
