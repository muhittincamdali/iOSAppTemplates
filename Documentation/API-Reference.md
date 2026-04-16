# API Reference

Bu sayfa root package tarafinda dogrudan gorunen stabil surface'i ozetler. Daha genis app/template API'leri icin ilgili `Sources/*Templates/*.swift` dosyalarini incele.

## Canonical Entry Points

Root package icin en onemli public tipler:

- `iOSAppTemplates`
- `TemplateManager`
- `AppTemplate`
- `TemplateCategory`
- `TemplateComplexity`
- `TemplateError`

Kaynak:
- `Sources/iOSAppTemplates/iOSAppTemplates.swift`

## iOSAppTemplates

Package-level bootstrap helper:

```swift
import iOSAppTemplates

iOSAppTemplates.initialize()
iOSAppTemplates.configure(
    templatesEnabled: true,
    documentationEnabled: true,
    examplesEnabled: true
)
```

Public members:

```swift
public struct iOSAppTemplates {
    public static let version: String
    public static func initialize()
    public static func configure(
        templatesEnabled: Bool = true,
        documentationEnabled: Bool = true,
        examplesEnabled: Bool = true
    )
}
```

Not:
- Bu `configure` cagrisi runtime feature toggles benzeri hafif bir helper'dir.
- Security/performance/test guarantees vermez.

## TemplateManager

Root package icindeki canonical discovery surface:

```swift
@MainActor
public class TemplateManager: ObservableObject {
    public static let shared: TemplateManager

    @Published public var availableTemplates: [AppTemplate] { get }
    @Published public var selectedTemplate: AppTemplate? { get }

    public func loadTemplates()
    public func getTemplate(id: String) -> AppTemplate?
    public func getTemplates(category: TemplateCategory) -> [AppTemplate]
    public func getTemplates(complexity: TemplateComplexity) -> [AppTemplate]
    public func searchTemplates(query: String) -> [AppTemplate]
    public func selectTemplate(_ template: AppTemplate)
    public func clearSelection()
}
```

Ornek:

```swift
let manager = TemplateManager.shared
let commerceTemplates = manager.getTemplates(category: .commerce)
let allTemplates = manager.searchTemplates(query: "")
let socialMatch = manager.searchTemplates(query: "social")
```

Current truth:
- Root `TemplateManager` bugun package icinde `3` curated top-level template kaydi expose eder:
  - `Social Media App`
  - `E-commerce App`
  - `Fitness App`
- Daha genis template family surface'i `Sources/*Templates` altindadir.

## AppTemplate

`TemplateManager` tarafindan donen hafif metadata modeli:

```swift
public struct AppTemplate: Identifiable, Codable {
    public let id: String
    public let name: String
    public let description: String
    public let category: TemplateCategory
    public let features: [String]
    public let technologies: [String]
    public let complexity: TemplateComplexity
    public let estimatedTime: String
}
```

## TemplateCategory

Root package discovery icin kullanilan kategori enum'u:

```swift
public enum TemplateCategory: String, CaseIterable, Codable {
    case social
    case commerce
    case health
    case productivity
    case entertainment
    case education
    case finance
    case travel
}
```

Bu enum ayrica basit `icon` ve `color` helper'lari da expose eder.

## TemplateComplexity

```swift
public enum TemplateComplexity: String, CaseIterable, Codable {
    case beginner
    case intermediate
    case advanced
    case expert
}
```

Her seviye icin:
- `description`
- `estimatedExperience`
helper'lari vardir.

## TemplateError

```swift
public enum TemplateError: LocalizedError {
    case templateNotFound(String)
    case invalidTemplate(String)
    case generationFailed(String)
    case configurationError(String)
}
```

## Template Family APIs

Repo sadece root metadata surface'den ibaret degil. Daha genis product-lane API'leri ilgili source dosyalarinda:

- `Sources/SocialTemplates/SocialTemplates.swift`
- `Sources/CommerceTemplates/CommerceTemplates.swift`
- `Sources/HealthTemplates/HealthTemplates.swift`
- `Sources/FinanceTemplates/FinanceTemplates.swift`
- `Sources/ProductivityTemplates/ProductivityTemplates.swift`
- `Sources/EducationTemplates/EducationTemplates.swift`
- `Sources/TravelTemplates/TravelTemplates.swift`
- `Sources/FoodTemplates/FoodDeliveryTemplate.swift`
- `Sources/AITemplates/SmartPhotoTemplate.swift`
- `Sources/VisionOSTemplates/SpatialSocialTemplate.swift`

Bu family'ler:
- domain models
- stores/managers
- SwiftUI views
- sample data
icerir.

Ancak hepsi ayni maturity seviyesinde degildir; "complete app" claim'i icin [Complete-App-Standard.md](./Complete-App-Standard.md) referans alinmalidir.
