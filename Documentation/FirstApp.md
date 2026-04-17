# First App Tutorial

Bu repo ile en hizli ilk basari iki farkli yoldan gelir:

1. root package surface'ini incelemek
2. `Templates/` altindaki standalone app roots'lari acmak

Bu sayfa bugunku repo gercegine gore en kisa ilk yol'u anlatir. Uydurma generator/config API'leri kullanmaz.

## Hangi Ilk Yol Daha Dogru?

### Hemen standalone bir app shell incelemek istiyorsan

Su klasorlerden biriyle basla:

- `Templates/SocialMediaApp`
- `Templates/EcommerceApp`
- `Templates/FitnessApp`

Bu yuzeyler repo icindeki bugunku en net standalone roots'lardir. Manifest smoke gecerler; app-specific build proof ise ayri backlog katmanidir.

### Once package surface'ini anlamak istiyorsan

Su dosyayla basla:

- `Sources/iOSAppTemplates/iOSAppTemplates.swift`

Burada:
- `TemplateManager.shared`
- category filtering
- complexity filtering
- search
gorursun.

## Prerequisites

- Xcode `16+`
- Swift `6+`
- macOS uzerinde Swift Package build calistirabilecek ortam

## Option A: Root Package'i Calistir ve Incele

```bash
git clone https://github.com/muhittincamdali/iOSAppTemplates.git
cd iOSAppTemplates
open Package.swift
```

Sonra package dogrulamasi:

```bash
swift build
swift test
```

Minimal inspection:

```swift
import iOSAppTemplates

let manager = TemplateManager.shared
let allTemplates = manager.searchTemplates(query: "")
let commerceTemplates = manager.getTemplates(category: .commerce)
let socialTemplates = manager.searchTemplates(query: "social")
```

Bu yol:
- root metadata surface'ini
- category map'i
- search davranisini
dogrular.

## Option B: Standalone Template Root Ac ve Incele

En hizli UI-first yol:

```bash
open Templates/SocialMediaApp/Package.swift
```

Ayni pattern su roots icin de gecerli:

```bash
open Templates/EcommerceApp/Package.swift
open Templates/FitnessApp/Package.swift
```

Bu roots:
- standalone app shell
- package-level app entry
- kendi dependency ve platform baseline'i
tasir

ama bugun henuz otomatik olarak su seyi kanitlamaz:
- standalone iOS build proof
- per-app media proof

## Sonra Nereye Bakmali?

### Social lane
- `Sources/SocialTemplates/SocialMediaTemplate.swift`
- `Sources/TCATemplates/SocialMediaTCATemplate.swift`

### Commerce lane
- `Sources/CommerceTemplates/CommerceTemplates.swift`

### Health lane
- `Sources/HealthTemplates/FitnessHealthTemplate.swift`
- `Sources/HealthTemplates/HealthTemplates.swift`

## Bu Sayfa Ne Vaad Etmiyor?

Bu tutorial su claim'leri vermez:

- tek adimda shipping-level app
- store submission proof
- hardened security guarantee
- fixed coverage/launch/performance metricleri

Bugunku dogru claim:
- repo, template family + standalone root + reference implementation kombinasyonu sunuyor
- tam `complete app` standardi icin [Complete-App-Standard.md](./Complete-App-Standard.md) takip edilmeli

## Recommended Next Steps

1. [Quick Start](./Guides/QuickStart.md)
2. [Template Guide](./TemplateGuide.md)
3. [API Reference](./API-Reference.md)
4. [Complete App Standard](./Complete-App-Standard.md)
