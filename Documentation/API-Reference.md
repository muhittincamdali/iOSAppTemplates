# API Reference

This page summarizes the stable surface that is directly visible from the root package. For broader app and template APIs, inspect the relevant `Sources/*Templates/*.swift` files.

## Canonical Entry Points

Most important public types at the root package level:

- `iOSAppTemplates`
- `TemplateManager`
- `AppTemplate`
- `TemplateCategory`
- `TemplateComplexity`
- `TemplateError`

Source:
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

Notes:
- `configure` is a lightweight bootstrap helper, not a runtime feature-flag system.
- It does not provide security, performance, or release guarantees.

## TemplateManager

Canonical discovery surface exposed by the root package:

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

Example:

```swift
let manager = TemplateManager.shared
let commerceTemplates = manager.getTemplates(category: .commerce)
let allTemplates = manager.searchTemplates(query: "")
let socialMatch = manager.searchTemplates(query: "social")
```

Current truth:
- `TemplateManager` remains a lightweight discovery layer.
- The broader product surface now lives across the lane modules under `Sources/*Templates` and the `20` standalone roots under `Templates/`.
- Use [Portfolio Matrix](./Portfolio-Matrix.md) and [Template Showcase](./Template-Showcase.md) for the current packaging map.

## AppTemplate

Lightweight metadata model returned by `TemplateManager`:

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

Category enum used by the root package discovery layer:

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

This enum also exposes lightweight `icon` and `color` helpers.

## TemplateComplexity

```swift
public enum TemplateComplexity: String, CaseIterable, Codable {
    case beginner
    case intermediate
    case advanced
    case expert
}
```

Each level also exposes:
- `description`
- `estimatedExperience`

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

The repo is not just a root metadata surface. Broader product-lane APIs live in:

- `Sources/SocialTemplates/SocialTemplates.swift`
- `Sources/CommerceTemplates/CommerceTemplates.swift`
- `Sources/HealthTemplates/HealthTemplates.swift`
- `Sources/FinanceTemplates/FinanceAppTemplate.swift`
- `Sources/ProductivityTemplates/ProductivityTemplates.swift`
- `Sources/EducationTemplates/EducationTemplates.swift`
- `Sources/TravelTemplates/TravelTemplates.swift`
- `Sources/FoodTemplates/FoodDeliveryTemplate.swift`
- `Sources/AITemplates/SmartPhotoTemplate.swift`
- `Sources/VisionOSTemplates/SpatialSocialTemplate.swift`

These families contain:
- domain models
- stores or managers
- SwiftUI views
- sample data

They are not all at the same maturity level. For any `complete app` claim, use [Complete-App-Standard.md](./Complete-App-Standard.md).
