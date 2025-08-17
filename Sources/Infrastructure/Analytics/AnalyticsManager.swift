//
// AnalyticsManager.swift
// iOS App Templates
//
// Created on 16/08/2024.
//

import Foundation
import Combine
import os.log

// MARK: - Analytics Event Protocol
public protocol AnalyticsEvent {
    var name: String { get }
    var parameters: [String: Any] { get }
    var timestamp: Date { get }
    var priority: AnalyticsPriority { get }
}

// MARK: - Analytics Priority
public enum AnalyticsPriority: Int {
    case low = 0
    case medium = 1
    case high = 2
    case critical = 3
}

// MARK: - Analytics Provider Protocol
public protocol AnalyticsProvider {
    func track(event: AnalyticsEvent)
    func setUserProperty(key: String, value: Any)
    func setUserId(_ userId: String?)
    func flush()
    func reset()
}

// MARK: - Analytics Manager
public final class AnalyticsManager: ObservableObject {
    
    // MARK: - Singleton
    public static let shared = AnalyticsManager()
    
    // MARK: - Properties
    private var providers: [AnalyticsProvider] = []
    private let eventQueue = DispatchQueue(label: "com.iosapptemplates.analytics", qos: .background)
    private let logger = Logger(subsystem: "com.iosapptemplates", category: "Analytics")
    private var cancellables = Set<AnyCancellable>()
    
    @Published public private(set) var isEnabled: Bool = true
    @Published public private(set) var debugMode: Bool = false
    @Published public private(set) var sessionId: String = UUID().uuidString
    @Published public private(set) var eventCount: Int = 0
    
    private let userDefaults = UserDefaults.standard
    private let eventBuffer: EventBuffer
    private let sessionManager: SessionManager
    private let privacyManager: PrivacyManager
    
    // MARK: - Configuration
    public struct Configuration {
        public var isEnabled: Bool = true
        public var debugMode: Bool = false
        public var sessionTimeout: TimeInterval = 1800 // 30 minutes
        public var maxEventsPerBatch: Int = 100
        public var flushInterval: TimeInterval = 60 // 1 minute
        public var retryPolicy: RetryPolicy = .exponentialBackoff
        public var dataResidency: DataResidency = .automatic
        
        public init() {}
    }
    
    public enum RetryPolicy {
        case none
        case linear(maxAttempts: Int)
        case exponentialBackoff
    }
    
    public enum DataResidency {
        case automatic
        case us
        case eu
        case asia
    }
    
    private var configuration: Configuration
    
    // MARK: - Initialization
    private init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
        self.eventBuffer = EventBuffer(maxSize: configuration.maxEventsPerBatch)
        self.sessionManager = SessionManager(timeout: configuration.sessionTimeout)
        self.privacyManager = PrivacyManager()
        
        setupConfiguration()
        startFlushTimer()
        observeAppLifecycle()
    }
    
    // MARK: - Setup
    private func setupConfiguration() {
        self.isEnabled = configuration.isEnabled && privacyManager.hasAnalyticsConsent
        self.debugMode = configuration.debugMode
        
        #if DEBUG
        self.debugMode = true
        #endif
    }
    
    private func startFlushTimer() {
        Timer.publish(every: configuration.flushInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.flush()
            }
            .store(in: &cancellables)
    }
    
    private func observeAppLifecycle() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.handleAppBecameActive()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                self?.handleAppWillResignActive()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                self?.handleAppDidEnterBackground()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    public func configure(with configuration: Configuration) {
        self.configuration = configuration
        setupConfiguration()
    }
    
    public func addProvider(_ provider: AnalyticsProvider) {
        providers.append(provider)
        logger.info("Added analytics provider: \(String(describing: type(of: provider)))")
    }
    
    public func removeAllProviders() {
        providers.removeAll()
        logger.info("Removed all analytics providers")
    }
    
    // MARK: - Event Tracking
    public func track(event: AnalyticsEvent) {
        guard isEnabled else {
            logger.debug("Analytics disabled, skipping event: \(event.name)")
            return
        }
        
        eventQueue.async { [weak self] in
            self?.processEvent(event)
        }
    }
    
    public func track(name: String, parameters: [String: Any] = [:], priority: AnalyticsPriority = .medium) {
        let event = StandardAnalyticsEvent(
            name: name,
            parameters: parameters,
            priority: priority
        )
        track(event: event)
    }
    
    private func processEvent(_ event: AnalyticsEvent) {
        // Enrich event with session data
        var enrichedParameters = event.parameters
        enrichedParameters["session_id"] = sessionId
        enrichedParameters["event_timestamp"] = event.timestamp.timeIntervalSince1970
        enrichedParameters["platform"] = "iOS"
        enrichedParameters["app_version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        enrichedParameters["os_version"] = UIDevice.current.systemVersion
        enrichedParameters["device_model"] = UIDevice.current.model
        
        let enrichedEvent = StandardAnalyticsEvent(
            name: event.name,
            parameters: enrichedParameters,
            priority: event.priority
        )
        
        // Add to buffer
        eventBuffer.add(enrichedEvent)
        eventCount += 1
        
        // Send to providers
        if debugMode {
            logger.debug("Tracking event: \(event.name) with parameters: \(enrichedParameters)")
        }
        
        providers.forEach { provider in
            provider.track(event: enrichedEvent)
        }
        
        // Check if buffer should be flushed
        if eventBuffer.shouldFlush {
            flush()
        }
    }
    
    // MARK: - User Properties
    public func setUserProperty(key: String, value: Any) {
        guard isEnabled else { return }
        
        eventQueue.async { [weak self] in
            self?.providers.forEach { provider in
                provider.setUserProperty(key: key, value: value)
            }
        }
    }
    
    public func setUserId(_ userId: String?) {
        guard isEnabled else { return }
        
        eventQueue.async { [weak self] in
            self?.providers.forEach { provider in
                provider.setUserId(userId)
            }
        }
    }
    
    // MARK: - Session Management
    public func startSession() {
        sessionId = UUID().uuidString
        sessionManager.startSession()
        
        track(name: "session_start", parameters: [
            "session_id": sessionId,
            "timestamp": Date().timeIntervalSince1970
        ], priority: .high)
    }
    
    public func endSession() {
        let duration = sessionManager.sessionDuration
        
        track(name: "session_end", parameters: [
            "session_id": sessionId,
            "duration": duration,
            "event_count": eventCount,
            "timestamp": Date().timeIntervalSince1970
        ], priority: .high)
        
        flush()
        sessionManager.endSession()
    }
    
    // MARK: - Data Management
    public func flush() {
        eventQueue.async { [weak self] in
            guard let self = self else { return }
            
            let events = self.eventBuffer.flush()
            if !events.isEmpty {
                self.logger.info("Flushing \(events.count) analytics events")
                
                self.providers.forEach { provider in
                    provider.flush()
                }
            }
        }
    }
    
    public func reset() {
        eventQueue.async { [weak self] in
            self?.providers.forEach { provider in
                provider.reset()
            }
            
            self?.eventBuffer.clear()
            self?.eventCount = 0
            self?.sessionId = UUID().uuidString
            self?.logger.info("Analytics manager reset")
        }
    }
    
    // MARK: - Privacy
    public func setAnalyticsConsent(_ hasConsent: Bool) {
        privacyManager.hasAnalyticsConsent = hasConsent
        isEnabled = configuration.isEnabled && hasConsent
        
        if !hasConsent {
            reset()
        }
    }
    
    public func optOut() {
        setAnalyticsConsent(false)
    }
    
    public func optIn() {
        setAnalyticsConsent(true)
    }
    
    // MARK: - App Lifecycle
    private func handleAppBecameActive() {
        if sessionManager.shouldStartNewSession {
            startSession()
        }
    }
    
    private func handleAppWillResignActive() {
        flush()
    }
    
    private func handleAppDidEnterBackground() {
        endSession()
    }
}

// MARK: - Standard Analytics Event
public struct StandardAnalyticsEvent: AnalyticsEvent {
    public let name: String
    public let parameters: [String: Any]
    public let timestamp: Date
    public let priority: AnalyticsPriority
    
    public init(
        name: String,
        parameters: [String: Any] = [:],
        timestamp: Date = Date(),
        priority: AnalyticsPriority = .medium
    ) {
        self.name = name
        self.parameters = parameters
        self.timestamp = timestamp
        self.priority = priority
    }
}

// MARK: - Event Buffer
private class EventBuffer {
    private var events: [AnalyticsEvent] = []
    private let maxSize: Int
    private let queue = DispatchQueue(label: "com.iosapptemplates.eventbuffer", attributes: .concurrent)
    
    init(maxSize: Int) {
        self.maxSize = maxSize
    }
    
    func add(_ event: AnalyticsEvent) {
        queue.async(flags: .barrier) {
            self.events.append(event)
            if self.events.count > self.maxSize {
                self.events.removeFirst()
            }
        }
    }
    
    func flush() -> [AnalyticsEvent] {
        queue.sync(flags: .barrier) {
            let flushedEvents = events
            events.removeAll()
            return flushedEvents
        }
    }
    
    func clear() {
        queue.async(flags: .barrier) {
            self.events.removeAll()
        }
    }
    
    var shouldFlush: Bool {
        queue.sync {
            events.count >= maxSize
        }
    }
}

// MARK: - Session Manager
private class SessionManager {
    private var sessionStartTime: Date?
    private let timeout: TimeInterval
    private var lastActivityTime: Date = Date()
    
    init(timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    func startSession() {
        sessionStartTime = Date()
        lastActivityTime = Date()
    }
    
    func endSession() {
        sessionStartTime = nil
    }
    
    var sessionDuration: TimeInterval {
        guard let startTime = sessionStartTime else { return 0 }
        return Date().timeIntervalSince(startTime)
    }
    
    var shouldStartNewSession: Bool {
        Date().timeIntervalSince(lastActivityTime) > timeout
    }
    
    func recordActivity() {
        lastActivityTime = Date()
    }
}

// MARK: - Privacy Manager
private class PrivacyManager {
    private let userDefaults = UserDefaults.standard
    private let consentKey = "com.iosapptemplates.analytics.consent"
    
    var hasAnalyticsConsent: Bool {
        get { userDefaults.bool(forKey: consentKey) }
        set { userDefaults.set(newValue, forKey: consentKey) }
    }
    
    init() {
        // Default to true if not set
        if userDefaults.object(forKey: consentKey) == nil {
            hasAnalyticsConsent = true
        }
    }
}

// MARK: - Common Analytics Events
public extension AnalyticsManager {
    
    func trackScreenView(screenName: String, screenClass: String? = nil) {
        var parameters: [String: Any] = ["screen_name": screenName]
        if let screenClass = screenClass {
            parameters["screen_class"] = screenClass
        }
        
        track(name: "screen_view", parameters: parameters, priority: .high)
    }
    
    func trackButtonTap(buttonName: String, screenName: String? = nil) {
        var parameters: [String: Any] = ["button_name": buttonName]
        if let screenName = screenName {
            parameters["screen_name"] = screenName
        }
        
        track(name: "button_tap", parameters: parameters)
    }
    
    func trackError(error: Error, context: String? = nil) {
        var parameters: [String: Any] = [
            "error_description": error.localizedDescription,
            "error_domain": (error as NSError).domain,
            "error_code": (error as NSError).code
        ]
        
        if let context = context {
            parameters["context"] = context
        }
        
        track(name: "error", parameters: parameters, priority: .high)
    }
    
    func trackPurchase(productId: String, price: Double, currency: String = "USD") {
        track(name: "purchase", parameters: [
            "product_id": productId,
            "price": price,
            "currency": currency
        ], priority: .critical)
    }
    
    func trackSignUp(method: String) {
        track(name: "sign_up", parameters: [
            "method": method
        ], priority: .high)
    }
    
    func trackLogin(method: String) {
        track(name: "login", parameters: [
            "method": method
        ], priority: .high)
    }
    
    func trackSearch(query: String, resultsCount: Int? = nil) {
        var parameters: [String: Any] = ["search_query": query]
        if let resultsCount = resultsCount {
            parameters["results_count"] = resultsCount
        }
        
        track(name: "search", parameters: parameters)
    }
    
    func trackShare(contentType: String, method: String) {
        track(name: "share", parameters: [
            "content_type": contentType,
            "method": method
        ])
    }
}