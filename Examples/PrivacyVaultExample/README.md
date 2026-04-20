# Privacy Vault Example

Bu klasor tek basina ship edilen bir Xcode app projesi degil. `PrivacyVaultApp` hedef UX'inin daha zengin bir inspection surface'idir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve privacy workflow proof bu klasore bagli degil.
- Canonical standalone package-entry root su an `Templates/PrivacyVaultApp`.
- Canonical package validation root seviyedeki `swift build` ve `swift test`.

## What This Example Is Good For

- privacy vault lane icin secure collection, recovery ve access review workflow yonunu gormek
- Wave 3 app-pack icin richer example surface'i takip etmek
- privacy-first routing ve security naming incelemek

## Start Here

```bash
open ../../Templates/PrivacyVaultApp/Package.swift
```

Repo proof:

```bash
swift build
swift test
```

## Related Docs

- [Portfolio Matrix](../../Documentation/Portfolio-Matrix.md)
- [PrivacyVaultApp Proof](../../Documentation/App-Proofs/PrivacyVaultApp.md)
- [PrivacyVaultApp Media](../../Documentation/App-Media/PrivacyVaultApp.md)
