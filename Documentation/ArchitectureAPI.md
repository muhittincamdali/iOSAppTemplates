# Architecture API

This repo does not enforce a single mandatory architecture contract. Instead, a few patterns repeat across different template families:

- `SwiftUI`-first app shells
- `ObservableObject`-based store and manager structures
- domain models plus sample data
- `TCA` in selected areas
- `visionOS` and `AI` reference surfaces in selected areas

This page is a canonical architecture map, not a premium-delivery guarantee.

## Repo-Level Architecture Map

### 1. Root Discovery Layer

Source:
- `Sources/iOSAppTemplates/iOSAppTemplates.swift`

Role:
- exposes template metadata
- performs template discovery through category, complexity, and search

Core types:
- `TemplateManager`
- `AppTemplate`
- `TemplateCategory`
- `TemplateComplexity`

### 2. Template Family Modules

Each family carries its own product lane:

- `Sources/SocialTemplates`
- `Sources/CommerceTemplates`
- `Sources/HealthTemplates`
- `Sources/ProductivityTemplates`
- `Sources/EducationTemplates`
- `Sources/FinanceTemplates`
- `Sources/TravelTemplates`
- `Sources/EntertainmentTemplates`
- `Sources/FoodTemplates`

General pattern:
- domain models
- manager or store types
- sample data
- SwiftUI views
- sometimes standalone `App` entries

These families are not all at the same abstraction level. Some modules are closer to reference implementations, while others carry broader UI surfaces.

## Architecture Patterns Present Today

### SwiftUI + ObservableObject

Most common pattern:

```swift
@MainActor
final class ExampleStore: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading = false
}
```

This pattern repeats across social, finance, health, and productivity surfaces.

### Domain Models + Sample Data

Many template families follow a shape like this:

```swift
public struct Product: Identifiable, Codable {
    public let id: String
    public let name: String
}

public enum CommerceSampleData {
    // curated sample content
}
```

This is one of the strongest current traits of the repo: reusable models plus sample content plus SwiftUI views.

### TCA Reference Surface

Source:
- `Sources/TCATemplates/SocialMediaTCATemplate.swift`

`TCA` support exists at a reference level in the repo. It does not mean every template uses `TCA`.

Example types:
- `SocialMediaApp`
- `PostsFeature`
- `ProfileFeature`
- `NotificationsFeature`

### visionOS Reference Surface

Source:
- `Sources/VisionOSTemplates/SpatialSocialTemplate.swift`

This area provides a reference surface for spatial UI and immersive-scene composition. Today it is more valuable for:

- category expansion
- spatial UI reference
- API exploration

It is not complete product proof.

### AI Reference Surface

Source:
- `Sources/AITemplates/SmartPhotoTemplate.swift`

The AI lane currently provides a reference or sample surface through:

- photo analysis
- smart search
- enhancement client abstractions

## What This Repo Does Not Guarantee

This repo does not currently guarantee the following as a canonical contract:

- one official architecture pattern
- a uniform dependency-injection contract
- identical test depth in every lane
- identical production hardening in every lane
- standalone shippable maturity in every lane

So an `architecture guide` is not the same thing as a `complete app` claim.

## Recommended Reading Order

1. [API Reference](./API-Reference.md)
2. [Complete App Standard](./Complete-App-Standard.md)
3. `Sources/iOSAppTemplates/iOSAppTemplates.swift`
4. the relevant `Sources/*Templates/*.swift` file for your lane
5. the standalone roots under `Templates/`

## External References

- [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Apple visionOS Documentation](https://developer.apple.com/documentation/visionos)
