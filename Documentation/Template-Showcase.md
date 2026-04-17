# Template Showcase

Last updated: 2026-04-18

Bu sayfa `iOSAppTemplates` icin tracked gallery surface'tir.

Buradaki kural:

- bugun manifest smoke gecen sey `standalone package root`
- sadece source seviyesinde olan sey `template family`
- eksik proof tasiyan sey `complete app` diye sayilmaz

## Runnable Now

### Commerce: EcommerceApp

- Type: `Standalone Root`
- Entry: `Templates/EcommerceApp/Package.swift`
- Product shape: store, cart, checkout, auth shell
- Proof today: package root mevcut, manifest smoke gecerli, source shell mevcut
- Gap: iOS-targeted standalone build proof, screenshot, per-app README

### Social: SocialMediaApp

- Type: `Standalone Root + richer source shell`
- Entry: `Templates/SocialMediaApp/Package.swift`
- Extra route: `Examples/SocialMediaExample`
- Product shape: auth, feed/community shell, richer UI fragments
- Proof today: package root mevcut, manifest smoke gecerli, ek example surface mevcut
- Gap: iOS-targeted standalone build proof, screenshot, per-app README

### Health / Fitness: FitnessApp

- Type: `Standalone Root`
- Entry: `Templates/FitnessApp/Package.swift`
- Product shape: auth, workout/progress shell, HealthKit-adjacent flow
- Proof today: package root mevcut, manifest smoke gecerli, source shell mevcut
- Gap: iOS-targeted standalone build proof, screenshot, per-app README

## Template Family Coverage

Bunlar bugun lane-level source surface olarak var ama standalone complete-app proof tasimiyor:

| Lane | Current Type | Best Route |
| --- | --- | --- |
| News | Template Family | `Sources/NewsTemplates/NewsBlogTemplate.swift` |
| Finance | Template Family | `Sources/FinanceTemplates/FinanceAppTemplate.swift` |
| Education | Template Family | `Sources/EducationTemplates/EducationAppTemplate.swift` |
| Food Delivery | Template Family | `Sources/FoodTemplates/FoodDeliveryTemplate.swift` |
| Travel | Template Family | `Sources/TravelTemplates/TravelAppTemplate.swift` |
| Music / Podcast | Template Family | `Sources/MusicTemplates/MusicPodcastTemplate.swift` |
| Productivity | Template Family | `Sources/ProductivityTemplates/ProductivityAppTemplate.swift` |

## Generator Coverage

Generator bugun `10` lane icin starter shell uretiyor:

```bash
swift Scripts/TemplateGenerator.swift --list
swift Scripts/TemplateGenerator.swift --interactive
```

Bu coverage:

- category breadth kaniti
- starter-shell kaniti

ama su an tek basina `complete app` kaniti degil.

## If You Need A Decision Fast

### UI shell incelemek istiyorsan

1. `Templates/SocialMediaApp`
2. `Templates/EcommerceApp`
3. `Templates/FitnessApp`

### Category breadth gormek istiyorsan

1. [Portfolio-Matrix.md](./Portfolio-Matrix.md)
2. `swift Scripts/TemplateGenerator.swift --list`
3. [TemplateGuide.md](./TemplateGuide.md)

### Proof seviyesini gormek istiyorsan

1. [Proof-Matrix.md](./Proof-Matrix.md)
2. [Complete-App-Standard.md](./Complete-App-Standard.md)

## Next Upgrade Path

Bu sayfa ancak su iki katman geldikce gercek world-class gallery'ye donusur:

1. per-app README
2. screenshot / demo proof
3. explicit standalone build proof
