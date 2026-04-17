# iOSAppTemplates

SwiftUI-first app starter system for Apple platforms.

`iOSAppTemplates` bugun category-level template families, generator tooling, shared package targets ve `Templates/` altinda `3` standalone app root ship ediyor. Repo hedefi genis complete-app parity; bugunku claim ise bunun tamami degil, bugun gercekten neyin var oldugunu net gostermek.

## First Decision

Bu repo sana uygun:

- category-level app starter ariyorsan
- shared Swift package surface ustunden template ailesi incelemek istiyorsan
- generator ile hizli app shell cikarmak istiyorsan
- `Clean Architecture`, `MVVM-C`, `TCA` gibi pattern'leri ayni portfoyde gormek istiyorsan

Bu repo bugun sana uygun degil:

- tam complete-app parity bekliyorsan
- tek komutla tam release-grade portfolio istiyorsan
- her kategori icin ayni seviyede media, UI automation ve release proof ariyorsan

## Start Here

| Ihtiyacin | Ilk durak |
| --- | --- |
| Repo'yu 5 dakikada degerlendirmek | [Documentation/Guides/QuickStart.md](Documentation/Guides/QuickStart.md) |
| Gercek complete-app standardini gormek | [Documentation/Complete-App-Standard.md](Documentation/Complete-App-Standard.md) |
| Current portfolio gercegini gormek | [Documentation/Portfolio-Matrix.md](Documentation/Portfolio-Matrix.md) |
| Template ailelerini incelemek | [Documentation/TemplateGuide.md](Documentation/TemplateGuide.md) |
| Ornek/router yuzeyini gormek | [Examples/README.md](Examples/README.md) |
| Mevcut gap audit'i okumak | [Documentation/World-Class-Audit-2026-04-15.md](Documentation/World-Class-Audit-2026-04-15.md) |

## What Ships Today

- `Sources/` altinda category-level template families
- `Scripts/TemplateGenerator.swift` ile generator entry point
- `Templates/` altinda `3` standalone app root:
  - `Templates/EcommerceApp`
  - `Templates/FitnessApp`
  - `Templates/SocialMediaApp`
- `Examples/` altinda karisik reference/example surfaces
- root package graph icin aktif build/test/security/performance dogrulamasi

## Product Lanes

| Lane | Current Surface |
| --- | --- |
| Commerce | template family + standalone root |
| Social | template family + standalone root + richer example |
| News | template family |
| Health / Fitness | template family + standalone root |
| Finance | template family |
| Education | template family |
| Food Delivery | template family |
| Travel | template family |
| Music / Podcast | template family |
| Productivity | template family |

Bu tablo `complete app` parity degil, bugun repo icinde bulunan packaging gercegidir.

Daha net current-vs-target map icin:

- [Documentation/Portfolio-Matrix.md](Documentation/Portfolio-Matrix.md)

## Fastest Working Paths

### 1. Validate the package surface

```bash
git clone https://github.com/muhittincamdali/iOSAppTemplates.git
cd iOSAppTemplates
swift build
swift test
```

### 2. Open a standalone app root

```bash
open Templates/SocialMediaApp/Package.swift
open Templates/EcommerceApp/Package.swift
open Templates/FitnessApp/Package.swift
```

### 3. Use the generator

```bash
swift Scripts/TemplateGenerator.swift --interactive
swift Scripts/TemplateGenerator.swift --list
```

## Current Quality Bar

- Active package graph build ediyor
- Active package graph test ediliyor
- Security smoke surface var
- Performance smoke surface var
- Public docs truth-based olacak sekilde yeniden sikilastiriliyor

## Canonical Docs

- [Documentation/README.md](Documentation/README.md)
- [Documentation/Guides/Installation.md](Documentation/Guides/Installation.md)
- [Documentation/API-Reference.md](Documentation/API-Reference.md)
- [Documentation/VisionProGuide.md](Documentation/VisionProGuide.md)

## Contributing

Yeni claim ekliyorsan proof path de ekle. Ayrinti:

- [CONTRIBUTING.md](CONTRIBUTING.md)
- [SECURITY.md](SECURITY.md)
- [SUPPORT.md](SUPPORT.md)

## License

[MIT](LICENSE)
