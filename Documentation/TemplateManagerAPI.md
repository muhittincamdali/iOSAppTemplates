# Template Manager API

## Overview

The Template Manager API provides the core functionality for managing iOS app templates in the iOS App Templates framework.

## Core Classes

### TemplateManager

The main class responsible for managing template operations.

```swift
public class TemplateManager {
    public init()
    public func start(with configuration: TemplateConfiguration)
    public func configure(_ configuration: TemplateConfiguration)
    public func generateTemplate(type: TemplateType, configuration: TemplateConfiguration) async throws -> GeneratedTemplate
}
```

## Configuration

### TemplateConfiguration

Configuration class for template generation settings.

```swift
public struct TemplateConfiguration {
    public var enableAppTemplates: Bool
    public var enableArchitectureTemplates: Bool
    public var enableUITemplates: Bool
    public var enableTestingTemplates: Bool
    public var enableDocumentation: Bool
    public var enableTesting: Bool
    public var enableCI: Bool
    public var enableCodeCoverage: Bool
    public var enableCustomization: Bool
    public var enableModularStructure: Bool
    public var enableBestPractices: Bool
    public var enablePerformanceOptimization: Bool
}
```

## Template Types

### TemplateType

Enumeration of available template types.

```swift
public enum TemplateType {
    case socialMedia
    case ecommerce
    case news
    case chat
    case fitness
    case travel
    case finance
    case education
    case custom(String)
}
```

## Usage Examples

### Basic Template Generation

```swift
import iOSAppTemplates

let templateManager = TemplateManager()

let config = TemplateConfiguration()
config.enableAppTemplates = true
config.enableDocumentation = true
config.enableTesting = true

templateManager.start(with: config)

let template = try await templateManager.generateTemplate(
    type: .socialMedia,
    configuration: config
)
```

### Advanced Configuration

```swift
let advancedConfig = TemplateConfiguration()
advancedConfig.enableAppTemplates = true
advancedConfig.enableArchitectureTemplates = true
advancedConfig.enableUITemplates = true
advancedConfig.enableTestingTemplates = true
advancedConfig.enableDocumentation = true
advancedConfig.enableTesting = true
advancedConfig.enableCI = true
advancedConfig.enableCodeCoverage = true
advancedConfig.enableCustomization = true
advancedConfig.enableModularStructure = true
advancedConfig.enableBestPractices = true
advancedConfig.enablePerformanceOptimization = true

templateManager.configure(advancedConfig)
```

## Error Handling

### TemplateError

Custom error types for template operations.

```swift
public enum TemplateError: Error {
    case invalidConfiguration
    case templateNotFound
    case generationFailed(String)
    case validationFailed(String)
    case unsupportedTemplateType
}
```

## Best Practices

1. **Always configure the template manager before use**
2. **Use appropriate error handling**
3. **Validate configurations before generation**
4. **Test generated templates thoroughly**
5. **Follow iOS development best practices**

## Support

For API-specific questions, please refer to the main documentation or create an issue.
