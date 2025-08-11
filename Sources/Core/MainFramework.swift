import Foundation
import UIKit

/**
 * Main Framework Implementation
 * 
 * Core functionality and main entry point for the framework.
 * Provides high-level API for framework operations.
 */

@available(iOS 15.0, *)
public final class MainFramework: ObservableObject {
    
    // MARK: - Published Properties
    @Published public private(set) var isRunning: Bool = false
    @Published public private(set) var isPaused: Bool = false
    @Published public private(set) var currentStatus: FrameworkStatus = .idle
    
    // MARK: - Private Properties
    private var configuration: FrameworkConfiguration
    private var dataManager: DataManager
    private var networkManager: NetworkManager
    private var logger: Logger
    
    // MARK: - Initialization
    public init(configuration: FrameworkConfiguration = .default) {
        self.configuration = configuration
        self.dataManager = DataManager(configuration: configuration)
        self.networkManager = NetworkManager(configuration: configuration)
        self.logger = Logger(configuration: configuration)
        
        setupFramework()
    }
    
    // MARK: - Public Methods
    public func start() {
        guard !isRunning else {
            logger.log(.warning, "Framework is already running")
            return
        }
        
        do {
            try validateConfiguration()
            try dataManager.initialize()
            try networkManager.initialize()
            
            isRunning = true
            currentStatus = .running
            logger.log(.info, "Framework started successfully")
            
        } catch {
            logger.log(.error, "Failed to start framework: \(error)")
            currentStatus = .error(error)
        }
    }
    
    public func stop() {
        guard isRunning else {
            logger.log(.warning, "Framework is not running")
            return
        }
        
        dataManager.cleanup()
        networkManager.cleanup()
        
        isRunning = false
        isPaused = false
        currentStatus = .stopped
        logger.log(.info, "Framework stopped successfully")
    }
    
    // MARK: - Private Methods
    private func setupFramework() {
        logger.log(.info, "Framework setup completed")
    }
    
    private func validateConfiguration() throws {
        guard configuration.timeoutInterval > 0 else {
            throw FrameworkError.invalidConfiguration
        }
        
        guard !configuration.apiKey.isEmpty else {
            throw FrameworkError.missingAPIKey
        }
    }
}

// MARK: - Supporting Types
public enum FrameworkStatus: Equatable {
    case idle
    case running
    case paused
    case stopped
    case error(Error)
}

public enum FrameworkError: LocalizedError {
    case invalidConfiguration
    case missingAPIKey
    case networkError
    case dataError
}

public struct FrameworkConfiguration {
    public let apiKey: String
    public let timeoutInterval: TimeInterval
    public let enableLogging: Bool
    public let debugMode: Bool
    
    public init(apiKey: String, timeoutInterval: TimeInterval = 30.0, enableLogging: Bool = true, debugMode: Bool = false) {
        self.apiKey = apiKey
        self.timeoutInterval = timeoutInterval
        self.enableLogging = enableLogging
        self.debugMode = debugMode
    }
    
    public static let `default` = FrameworkConfiguration(apiKey: "default_key")
}
