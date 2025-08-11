import Foundation

/// World-Class iOS Development Framework
/// 
/// iOSAppTemplates provides developers with professional-grade tools and patterns
/// for building exceptional iOS applications.
public final class iOSAppTemplates {
    
    // MARK: - Properties
    
    /// Configuration options for the framework
    public var configuration: Configuration
    
    /// Current state of the framework
    public private(set) var isConfigured: Bool = false
    
    // MARK: - Initialization
    
    /// Initialize the framework with default configuration
    public init() {
        self.configuration = Configuration()
    }
    
    /// Initialize the framework with custom configuration
    /// - Parameter configuration: Custom configuration options
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    // MARK: - Public Methods
    
    /// Configure the framework with current settings
    public func configure() {
        guard !isConfigured else {
            print("⚠️ Framework already configured")
            return
        }
        
        // Apply configuration
        applyConfiguration()
        
        // Mark as configured
        isConfigured = true
        
        print("✅ iOSAppTemplates configured successfully")
    }
    
    /// Reset the framework to initial state
    public func reset() {
        isConfigured = false
        print("🔄 iOSAppTemplates reset to initial state")
    }
    
    // MARK: - Private Methods
    
    private func applyConfiguration() {
        // Apply configuration settings
        if configuration.debugMode {
            print("🐛 Debug mode enabled")
        }
        
        if configuration.cacheEnabled {
            print("💾 Cache enabled")
        }
        
        print("📱 Log level: \(configuration.logLevel)")
    }
}

// MARK: - Configuration

public struct Configuration {
    /// Enable debug mode for additional logging
    public var debugMode: Bool = false
    
    /// Logging level for the framework
    public var logLevel: LogLevel = .info
    
    /// Enable caching for improved performance
    public var cacheEnabled: Bool = true
    
    public init() {}
}

// MARK: - Log Level

public enum LogLevel: String, CaseIterable {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

// MARK: - Errors

public enum iOSAppTemplatesError: Error, LocalizedError {
    case configurationFailed
    case initializationError
    case runtimeError(String)
    
    public var errorDescription: String? {
        switch self {
        case .configurationFailed:
            return "Framework configuration failed"
        case .initializationError:
            return "Framework initialization error"
        case .runtimeError(let message):
            return "Runtime error: \(message)"
        }
    }
}
