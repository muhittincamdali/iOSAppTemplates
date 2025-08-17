//
// WebSocketManager.swift
// iOS App Templates
//
// Created on 16/08/2024.
//

import Foundation
import Combine

// MARK: - WebSocket Message Types
public enum WebSocketMessageType {
    case text(String)
    case data(Data)
    case ping
    case pong
    case close(code: Int, reason: String?)
}

// MARK: - WebSocket State
public enum WebSocketState {
    case connecting
    case connected
    case disconnected
    case failed(Error)
}

// MARK: - WebSocket Manager Protocol
public protocol WebSocketManagerProtocol {
    var state: AnyPublisher<WebSocketState, Never> { get }
    var messages: AnyPublisher<WebSocketMessageType, Never> { get }
    
    func connect()
    func disconnect()
    func send(_ message: WebSocketMessageType)
    func reconnect()
}

// MARK: - WebSocket Manager Implementation
public final class WebSocketManager: NSObject, WebSocketManagerProtocol {
    
    // MARK: - Properties
    private let url: URL
    private var webSocketTask: URLSessionWebSocketTask?
    private let session: URLSession
    private let configuration: Configuration
    
    private let stateSubject = CurrentValueSubject<WebSocketState, Never>(.disconnected)
    private let messageSubject = PassthroughSubject<WebSocketMessageType, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var pingTimer: Timer?
    private var reconnectTimer: Timer?
    private var reconnectAttempts = 0
    private let maxReconnectAttempts = 5
    
    private let logger: WebSocketLogger
    private let messageQueue: MessageQueue
    private let connectionMonitor: ConnectionMonitor
    
    // MARK: - Configuration
    public struct Configuration {
        public let autoReconnect: Bool
        public let reconnectInterval: TimeInterval
        public let pingInterval: TimeInterval
        public let timeout: TimeInterval
        public let maxMessageSize: Int
        public let compressionEnabled: Bool
        public let headers: [String: String]
        public let loggingEnabled: Bool
        
        public init(
            autoReconnect: Bool = true,
            reconnectInterval: TimeInterval = 5,
            pingInterval: TimeInterval = 30,
            timeout: TimeInterval = 60,
            maxMessageSize: Int = 1024 * 1024, // 1MB
            compressionEnabled: Bool = true,
            headers: [String: String] = [:],
            loggingEnabled: Bool = false
        ) {
            self.autoReconnect = autoReconnect
            self.reconnectInterval = reconnectInterval
            self.pingInterval = pingInterval
            self.timeout = timeout
            self.maxMessageSize = maxMessageSize
            self.compressionEnabled = compressionEnabled
            self.headers = headers
            self.loggingEnabled = loggingEnabled
        }
    }
    
    // MARK: - Public Properties
    public var state: AnyPublisher<WebSocketState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    public var messages: AnyPublisher<WebSocketMessageType, Never> {
        messageSubject.eraseToAnyPublisher()
    }
    
    public var isConnected: Bool {
        if case .connected = stateSubject.value {
            return true
        }
        return false
    }
    
    // MARK: - Initialization
    public init(url: URL, configuration: Configuration = Configuration()) {
        self.url = url
        self.configuration = configuration
        self.logger = WebSocketLogger(enabled: configuration.loggingEnabled)
        self.messageQueue = MessageQueue()
        self.connectionMonitor = ConnectionMonitor()
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = configuration.timeout
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        if !configuration.headers.isEmpty {
            sessionConfiguration.httpAdditionalHeaders = configuration.headers
        }
        
        self.session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: .main)
        
        super.init()
        
        setupConnectionMonitoring()
    }
    
    deinit {
        disconnect()
        cancellables.removeAll()
    }
    
    // MARK: - Setup
    private func setupConnectionMonitoring() {
        connectionMonitor.isReachable
            .sink { [weak self] isReachable in
                guard let self = self else { return }
                
                if isReachable && self.configuration.autoReconnect {
                    if case .failed = self.stateSubject.value {
                        self.reconnect()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Connection Management
    public func connect() {
        guard !isConnected else {
            logger.log("Already connected")
            return
        }
        
        disconnect()
        
        stateSubject.send(.connecting)
        logger.log("Connecting to \(url)")
        
        var request = URLRequest(url: url)
        request.timeoutInterval = configuration.timeout
        
        configuration.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        webSocketTask = session.webSocketTask(with: request)
        
        if configuration.compressionEnabled {
            webSocketTask?.maximumMessageSize = configuration.maxMessageSize
        }
        
        webSocketTask?.resume()
        
        // Start receiving messages
        receiveMessage()
        
        // Send initial ping to verify connection
        sendPing()
        
        // Start ping timer
        startPingTimer()
        
        stateSubject.send(.connected)
        logger.log("Connected successfully")
        
        // Send queued messages
        messageQueue.flush().forEach { send($0) }
    }
    
    public func disconnect() {
        logger.log("Disconnecting")
        
        stopPingTimer()
        stopReconnectTimer()
        
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        
        stateSubject.send(.disconnected)
        reconnectAttempts = 0
    }
    
    public func reconnect() {
        guard configuration.autoReconnect else { return }
        guard reconnectAttempts < maxReconnectAttempts else {
            logger.log("Max reconnect attempts reached")
            stateSubject.send(.failed(WebSocketError.maxReconnectAttemptsReached))
            return
        }
        
        reconnectAttempts += 1
        logger.log("Reconnecting... (attempt \(reconnectAttempts)/\(maxReconnectAttempts))")
        
        disconnect()
        
        reconnectTimer = Timer.scheduledTimer(withTimeInterval: configuration.reconnectInterval, repeats: false) { [weak self] _ in
            self?.connect()
        }
    }
    
    // MARK: - Message Handling
    public func send(_ message: WebSocketMessageType) {
        guard isConnected else {
            logger.log("Not connected, queuing message")
            messageQueue.enqueue(message)
            
            if configuration.autoReconnect {
                reconnect()
            }
            return
        }
        
        switch message {
        case .text(let string):
            sendText(string)
        case .data(let data):
            sendData(data)
        case .ping:
            sendPing()
        case .pong:
            sendPong()
        case .close(let code, let reason):
            close(code: code, reason: reason)
        }
    }
    
    private func sendText(_ text: String) {
        let message = URLSessionWebSocketTask.Message.string(text)
        
        webSocketTask?.send(message) { [weak self] error in
            if let error = error {
                self?.handleError(error)
            } else {
                self?.logger.log("Sent text: \(text)")
            }
        }
    }
    
    private func sendData(_ data: Data) {
        let message = URLSessionWebSocketTask.Message.data(data)
        
        webSocketTask?.send(message) { [weak self] error in
            if let error = error {
                self?.handleError(error)
            } else {
                self?.logger.log("Sent data: \(data.count) bytes")
            }
        }
    }
    
    private func sendPing() {
        webSocketTask?.sendPing { [weak self] error in
            if let error = error {
                self?.handleError(error)
            } else {
                self?.logger.log("Ping sent")
            }
        }
    }
    
    private func sendPong() {
        // URLSessionWebSocketTask handles pong automatically
        logger.log("Pong sent")
    }
    
    private func close(code: Int, reason: String?) {
        let closeCode = URLSessionWebSocketTask.CloseCode(rawValue: code) ?? .normalClosure
        let reasonData = reason?.data(using: .utf8)
        
        webSocketTask?.cancel(with: closeCode, reason: reasonData)
        disconnect()
    }
    
    // MARK: - Message Reception
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                self.handleMessage(message)
                self.receiveMessage() // Continue receiving
                
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    private func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let text):
            logger.log("Received text: \(text)")
            messageSubject.send(.text(text))
            
        case .data(let data):
            logger.log("Received data: \(data.count) bytes")
            messageSubject.send(.data(data))
            
        @unknown default:
            logger.log("Received unknown message type")
        }
    }
    
    private func handleError(_ error: Error) {
        logger.log("Error: \(error.localizedDescription)")
        
        stateSubject.send(.failed(error))
        
        if configuration.autoReconnect {
            reconnect()
        }
    }
    
    // MARK: - Ping Timer
    private func startPingTimer() {
        stopPingTimer()
        
        pingTimer = Timer.scheduledTimer(withTimeInterval: configuration.pingInterval, repeats: true) { [weak self] _ in
            self?.sendPing()
        }
    }
    
    private func stopPingTimer() {
        pingTimer?.invalidate()
        pingTimer = nil
    }
    
    // MARK: - Reconnect Timer
    private func stopReconnectTimer() {
        reconnectTimer?.invalidate()
        reconnectTimer = nil
    }
}

// MARK: - WebSocket Error
public enum WebSocketError: LocalizedError {
    case invalidURL
    case connectionFailed
    case maxReconnectAttemptsReached
    case messageSizeTooLarge
    case invalidMessage
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid WebSocket URL"
        case .connectionFailed:
            return "Failed to establish WebSocket connection"
        case .maxReconnectAttemptsReached:
            return "Maximum reconnection attempts reached"
        case .messageSizeTooLarge:
            return "Message size exceeds maximum allowed"
        case .invalidMessage:
            return "Invalid message format"
        }
    }
}

// MARK: - Message Queue
private class MessageQueue {
    private var queue: [WebSocketMessageType] = []
    private let lock = NSLock()
    
    func enqueue(_ message: WebSocketMessageType) {
        lock.lock()
        defer { lock.unlock() }
        queue.append(message)
    }
    
    func flush() -> [WebSocketMessageType] {
        lock.lock()
        defer { lock.unlock() }
        let messages = queue
        queue.removeAll()
        return messages
    }
    
    var isEmpty: Bool {
        lock.lock()
        defer { lock.unlock() }
        return queue.isEmpty
    }
}

// MARK: - Connection Monitor
private class ConnectionMonitor {
    private let reachabilitySubject = CurrentValueSubject<Bool, Never>(true)
    
    var isReachable: AnyPublisher<Bool, Never> {
        reachabilitySubject.eraseToAnyPublisher()
    }
    
    init() {
        // Monitor network reachability
        NotificationCenter.default.publisher(for: .reachabilityChanged)
            .compactMap { $0.object as? Bool }
            .sink { [weak self] isReachable in
                self?.reachabilitySubject.send(isReachable)
            }
            .store(in: &Set<AnyCancellable>())
    }
}

// MARK: - WebSocket Logger
private class WebSocketLogger {
    private let enabled: Bool
    
    init(enabled: Bool) {
        self.enabled = enabled
    }
    
    func log(_ message: String) {
        guard enabled else { return }
        print("[WebSocket] \(Date()) - \(message)")
    }
}

// MARK: - Notification Extensions
private extension Notification.Name {
    static let reachabilityChanged = Notification.Name("com.iosapptemplates.websocket.reachability")
}

// MARK: - WebSocket Extensions for Common Use Cases
public extension WebSocketManager {
    
    // JSON message handling
    func sendJSON<T: Encodable>(_ object: T) {
        do {
            let data = try JSONEncoder().encode(object)
            if let jsonString = String(data: data, encoding: .utf8) {
                send(.text(jsonString))
            }
        } catch {
            logger.log("Failed to encode JSON: \(error)")
        }
    }
    
    // Subscribe to JSON messages
    func jsonMessages<T: Decodable>(type: T.Type) -> AnyPublisher<T, Never> {
        messages
            .compactMap { message -> Data? in
                if case .text(let text) = message {
                    return text.data(using: .utf8)
                } else if case .data(let data) = message {
                    return data
                }
                return nil
            }
            .compactMap { data in
                try? JSONDecoder().decode(T.self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    // Binary message handling
    func sendBinary(_ data: Data) {
        send(.data(data))
    }
    
    // Subscribe to binary messages
    var binaryMessages: AnyPublisher<Data, Never> {
        messages
            .compactMap { message -> Data? in
                if case .data(let data) = message {
                    return data
                }
                return nil
            }
            .eraseToAnyPublisher()
    }
}