# Social Media Example

Bu klasor su an tek basina ship edilen bir Xcode app projesi degil. Repo icindeki `SocialMediaApp.swift` yuzeyinin nasil gorunebilecegini gosteren kaynak-ornek alanidir.

## Current Truth

- Ayrik `.xcodeproj` veya `.xcworkspace` burada ship edilmiyor.
- Screenshot, UI test ve performance proof bu klasore bagli degil.
- Canonical runnable roots su an `Templates/` altindaki bagimsiz app paketleridir.
- Canonical package validation ise root seviyedeki `swift build` ve `swift test` komutlaridir.

## What This Example Is Good For

- `SocialTemplates` ve ilgili SwiftUI yuzeylerini hizli incelemek
- Social lane icin naming, state ve sample feature akisini gormek
- Gelecekteki complete-app gallery icin hedef UX yonunu belgelemek

## What This Example Is Not

- release-grade social app proof
- release/distribution kaniti
- gercek media, backend veya realtime infrastructure paketi

## Start Here

Root package yuzeyini dogrulamak icin:

```bash
swift build
swift test
```

Standalone social template root'unu acmak icin:

```bash
open Templates/SocialMediaApp/Package.swift
```

## Related Docs

- [QuickStart](../../Documentation/Guides/QuickStart.md)
- [Installation](../../Documentation/Guides/Installation.md)
- [Template Guide](../../Documentation/TemplateGuide.md)
- [Complete App Standard](../../Documentation/Complete-App-Standard.md)
