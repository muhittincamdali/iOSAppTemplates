# Quick Start Guide

Bu repo ile en hizli ilk basari yolu `generator-style` API degil, mevcut package ve standalone template roots'lari acmaktir.

## Fastest Paths

### 1. Root package'i incele

```bash
git clone https://github.com/muhittincamdali/iOSAppTemplates.git
cd iOSAppTemplates
open Package.swift
swift build
swift test
```

Sonra su surface ile basla:

```swift
import iOSAppTemplates

let manager = TemplateManager.shared
let allTemplates = manager.searchTemplates(query: "")
let commerce = manager.getTemplates(category: .commerce)
let social = manager.searchTemplates(query: "social")
```

Bu yol:
- root metadata surface'ini
- category/complexity map'ini
- arama davranisini
dogrular.

### 2. Standalone template root ac

Bugun repo icindeki en net standalone roots:

```bash
open Templates/SocialMediaApp/Package.swift
open Templates/EcommerceApp/Package.swift
open Templates/FitnessApp/Package.swift
```

Bu yol:
- app shell
- package-level entry
- lane-specific source surface
gosterir.

## Which Path Should You Pick?

### Repo'yu hizli degerlendirmek istiyorsan
- `Package.swift`
- `Sources/iOSAppTemplates/iOSAppTemplates.swift`
- `Documentation/Complete-App-Standard.md`

### UI-first bir lane ile baslamak istiyorsan
- `Templates/SocialMediaApp`
- `Templates/EcommerceApp`
- `Templates/FitnessApp`

### Daha genis source surface istiyorsan
- `Sources/SocialTemplates`
- `Sources/CommerceTemplates`
- `Sources/HealthTemplates`
- `Sources/ProductivityTemplates`
- `Sources/FinanceTemplates`

## Current Truth

Bu repo bugun:
- root package discovery surface sunuyor
- birden fazla template family modulu sunuyor
- `3` net standalone template root tasiyor

Bu repo bugun otomatik olarak sunmuyor:
- tek adimda generated shippable app
- store submission proof
- `20 complete apps` galerisi

O iddia icin canonical standard:
- [Complete App Standard](../Complete-App-Standard.md)

## Recommended Reading Order

1. [Installation](./Installation.md)
2. [First App Tutorial](../FirstApp.md)
3. [Template Guide](../TemplateGuide.md)
4. [API Reference](../API-Reference.md)
