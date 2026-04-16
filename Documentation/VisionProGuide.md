# Vision Pro Development Guide

Bu sayfa repo icindeki visionOS surface'in bugunku kapsamını dogru sekilde ozetler.

## Current Truth

visionOS lane'in canonical kaynagi:

- `Sources/VisionOSTemplates/SpatialSocialTemplate.swift`

Bu surface bugun:
- spatial UI reference
- immersive scene example
- visionOS-specific view composition
- sample model and reducer surface
olarak degerlidir.

Bu surface bugun su claim'i otomatik vermez:
- ship-ready Vision Pro app
- App Store proof
- hardware-validated production release

## What Exists Today

Kaynak dosyada bulunan ana tipler:

- `SpatialSocialTemplate`
- `SpatialSocialView`
- `SpatialSocialFeature`
- `SpatialSidebarView`
- `SpatialFeedView`
- `SpatialPostCard3D`
- `SocialImmersiveView`
- `SpatialPost`
- `SpatialUser`

Yani repo icinde gercek bir spatial reference surface var; ancak bu su an `complete app` standardini tek basina kanitlamaz.

## Recommended Use

Bu lane'i su durumlarda kullan:

- visionOS API'lerini incelemek
- spatial social/feed fikrini prototiplemek
- SwiftUI + RealityKit + reducer tabanli UI orkestrasyonu gormek
- gelecekteki complete-app lane'i icin reference toplamak

Bu lane'i su durumlarda tek basina yeterli sayma:

- release proof
- App Store submission
- production hardening
- hardware certification

## Minimal Inspection Flow

1. `Sources/VisionOSTemplates/SpatialSocialTemplate.swift` dosyasini ac
2. `SpatialSocialFeature` state/action yapisini incele
3. `SpatialPostCard3D` ve `SocialImmersiveView` ile UI yuzeyini takip et
4. visionOS-specific UI'yi kendi app shell'ine tasirken ayri product proof uret

## Prerequisites

- Xcode `16+`
- visionOS simulator veya uygun Apple platform tooling
- SwiftUI + RealityKit temel bilgisi

## App Store And Distribution Note

visionOS ile calisiyor olmasi:
- UX quality
- performance
- privacy text
- entitlement correctness
- distribution readiness
garantisi vermez.

Bu alan bugun bir `reference lane` olarak dusunulmelidir.

## Related Reading

1. [Architecture API](./ArchitectureAPI.md)
2. [Template Guide](./TemplateGuide.md)
3. [Complete App Standard](./Complete-App-Standard.md)
