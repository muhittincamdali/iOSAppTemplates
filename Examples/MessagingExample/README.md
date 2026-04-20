# Messaging Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `MessagingApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve messaging/community workflow proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/MessagingApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- messaging lane icin inbox, room routing ve moderation yonunu gormek
- Wave 2 app-pack icin richer example surface'i takip etmek
- community communication ve safety workflow naming incelemek

## Start Here

```bash
open ../../Templates/MessagingApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Portfolio Matrix](../../Documentation/Portfolio-Matrix.md)
- [Messaging Proof](../../Documentation/App-Proofs/MessagingApp.md)
- [Messaging Media](../../Documentation/App-Media/MessagingApp.md)
