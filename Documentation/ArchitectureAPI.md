# Architecture API

Bu repo tek bir zorunlu architecture contract sunmuyor. Bunun yerine farkli template family'lerinde tekrarlanan birkac desen var:

- `SwiftUI-first app shells`
- `ObservableObject` tabanli store/manager yapilari
- domain models + sample data
- secili alanlarda `TCA`
- secili alanlarda `visionOS` ve `AI` reference surfaces

Bu sayfa canonical architecture map'tir; premium delivery guarantee belgesi degildir.

## Repo-Level Architecture Map

### 1. Root Discovery Layer

Kaynak:
- `Sources/iOSAppTemplates/iOSAppTemplates.swift`

Rol:
- template metadata'yi expose eder
- category/complexity/search uzerinden template discovery yapar

Ana tipler:
- `TemplateManager`
- `AppTemplate`
- `TemplateCategory`
- `TemplateComplexity`

### 2. Template Family Modules

Her family kendi product lane'ini tasir:

- `Sources/SocialTemplates`
- `Sources/CommerceTemplates`
- `Sources/HealthTemplates`
- `Sources/ProductivityTemplates`
- `Sources/EducationTemplates`
- `Sources/FinanceTemplates`
- `Sources/TravelTemplates`
- `Sources/EntertainmentTemplates`
- `Sources/FoodTemplates`

Genel pattern:
- domain model'ler
- manager/store tipleri
- sample data
- SwiftUI views
- bazen standalone `App` girisleri

Bu family'ler ayni abstraction seviyesinde degildir. Bazi moduller daha cok reference implementation, bazilari daha fazla UI surface tasir.

## Architecture Patterns Present Today

### SwiftUI + ObservableObject

En yaygin pattern bu:

```swift
@MainActor
final class ExampleStore: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading = false
}
```

Bu desen sosyal, finance, health ve productivity surface'lerinde tekrar eder.

### Domain Models + Sample Data

Bir cok template family su yapida ilerler:

```swift
public struct Product: Identifiable, Codable {
    public let id: String
    public let name: String
}

public enum CommerceSampleData {
    // curated sample content
}
```

Bu repo'nun bugunku en guclu tarafi burada: yeniden kullanilabilir model + sample content + SwiftUI view kombinasyonu.

### TCA Reference Surface

Kaynak:
- `Sources/TCATemplates/SocialMediaTCATemplate.swift`

Repo'da `TCA` support reference seviyesinde vardir. Bu, tum template'lerin `TCA` kullandigi anlamina gelmez.

Ornek tipler:
- `SocialMediaApp`
- `PostsFeature`
- `ProfileFeature`
- `NotificationsFeature`

### visionOS Reference Surface

Kaynak:
- `Sources/VisionOSTemplates/SpatialSocialTemplate.swift`

Bu alan spatial UI ve immersive scene orgusu icin reference surface sunar. Bugun icin bu alan:
- category expansion
- spatial UI reference
- API exploration
amaciyla daha anlamlidir; tam product proof degildir.

### AI Reference Surface

Kaynak:
- `Sources/AITemplates/SmartPhotoTemplate.swift`

AI lane su an:
- photo analysis
- smart search
- enhancement client abstractions
uzerinden reference/sample surface sunar.

## What This Repo Does Not Guarantee

Bu repo su anda asagidakileri canonical contract olarak garanti etmez:

- tek resmi architecture pattern
- uniform dependency injection contract
- tum lane'lerde ayni test depth
- tum lane'lerde ayni production hardening
- tum lane'lerde standalone shippable app maturity

Bu nedenle `architecture guide` ile `complete app claim` ayni sey degildir.

## Recommended Reading Order

1. [API Reference](./API-Reference.md)
2. [Complete App Standard](./Complete-App-Standard.md)
3. `Sources/iOSAppTemplates/iOSAppTemplates.swift`
4. ilgilendigin lane icin ilgili `Sources/*Templates/*.swift`
5. `Templates/` altindaki standalone roots

## External References

- [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Apple visionOS Documentation](https://developer.apple.com/documentation/visionos)
