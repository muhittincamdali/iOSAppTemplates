# Template Guide

Bu sayfa repo icindeki template surface'lerin bugunku yapisini anlatir. Sahte dosya isimleri veya garanti edilmeyen deployment claim'leri kullanmaz.

## Current Template Surface

Repo bugun uc farkli katmandan olusuyor:

### 1. Root package discovery

Kaynak:
- `Sources/iOSAppTemplates/iOSAppTemplates.swift`

Bu katman:
- category map
- complexity map
- template discovery/search
icin kullanilir.

### 2. Template family modules

Kaynak:
- `Sources/SocialTemplates`
- `Sources/CommerceTemplates`
- `Sources/HealthTemplates`
- `Sources/ProductivityTemplates`
- `Sources/EducationTemplates`
- `Sources/FinanceTemplates`
- `Sources/TravelTemplates`
- `Sources/EntertainmentTemplates`
- `Sources/FoodTemplates`
- `Sources/AITemplates`
- `Sources/VisionOSTemplates`

Bu katman:
- models
- stores/managers
- sample data
- SwiftUI views
- bazen app entry points
tasir.

### 3. Standalone template roots

Bugun public repo icinde net standalone roots:

- `Templates/SocialMediaApp`
- `Templates/EcommerceApp`
- `Templates/FitnessApp`

Bu roots bugunku en yakin "open package and inspect app shell" yuzeyidir.

## How To Choose A Starting Point

### Social/product feed akisi istiyorsan
- `Sources/SocialTemplates/SocialMediaTemplate.swift`
- `Templates/SocialMediaApp`

### Commerce/catalog akisi istiyorsan
- `Sources/CommerceTemplates/CommerceTemplates.swift`
- `Templates/EcommerceApp`

### Health/workout akisi istiyorsan
- `Sources/HealthTemplates/FitnessHealthTemplate.swift`
- `Templates/FitnessApp`

### Reference-only advanced lanes
- `Sources/TCATemplates/SocialMediaTCATemplate.swift`
- `Sources/AITemplates/SmartPhotoTemplate.swift`
- `Sources/VisionOSTemplates/SpatialSocialTemplate.swift`

## What You Can Safely Customize Today

Bugun repo gercegine gore en guvenli customization alanlari:

- sample data
- domain models
- SwiftUI screens
- product copy
- navigation flow
- category-specific feature slices

Her template family'de ayni config dosya isimleri veya ayni design token sistemi yoktur. Bu nedenle `AppColors.swift`, `AppFonts.swift`, `AppConfig.swift` gibi sabit bir contract varsayilmamalidir.

## Build And Inspection Flow

### Root package

```bash
open Package.swift
swift build
swift test
```

### Standalone roots

```bash
open Templates/SocialMediaApp/Package.swift
open Templates/EcommerceApp/Package.swift
open Templates/FitnessApp/Package.swift
```

## Deployment And App Store Notes

Bu repo bugun:
- template families
- standalone roots
- reference implementations
sunar.

Bu repo bugun su seyi otomatik garanti etmez:
- App Store submission readiness
- TestFlight-ready binary
- uniform CI proof for every template lane

Bir template'i ship etmek istiyorsan en dogru akış:

1. ilgili lane veya standalone root'u sec
2. branding ve data surface'i ozellestir
3. kendi signing / bundle / privacy setup'ini ekle
4. kendi QA ve release proof'unu uret

## Complete App Claim

Bir template'i `complete app` olarak saymak icin [Complete-App-Standard.md](./Complete-App-Standard.md) takip edilmelidir.

Bu standardin disinda kalanlar:
- template family
- example surface
- reference implementation
olarak dusunulmelidir.

## Next Reading

1. [First App Tutorial](./FirstApp.md)
2. [API Reference](./API-Reference.md)
3. [Architecture API](./ArchitectureAPI.md)
4. [World-Class Audit](./World-Class-Audit-2026-04-15.md)
