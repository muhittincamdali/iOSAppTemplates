# API Reference

## Core Classes

### Main Framework

The main entry point for the iOSAppTemplates framework.

```swift
public class iOSAppTemplates {
    public init()
    public func configure()
    public func reset()
}
```

## Configuration

### Options

```swift
public struct Configuration {
    public var debugMode: Bool
    public var logLevel: LogLevel
    public var cacheEnabled: Bool
}
```

## Error Handling

```swift
public enum iOSAppTemplatesError: Error {
    case configurationFailed
    case initializationError
    case runtimeError(String)
}
