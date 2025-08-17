//
// GraphQLClient.swift
// iOS App Templates
//
// Created on 16/08/2024.
//

import Foundation
import Combine

// MARK: - GraphQL Types
public struct GraphQLQuery {
    let query: String
    let variables: [String: Any]?
    let operationName: String?
    
    public init(query: String, variables: [String: Any]? = nil, operationName: String? = nil) {
        self.query = query
        self.variables = variables
        self.operationName = operationName
    }
}

public struct GraphQLMutation {
    let mutation: String
    let variables: [String: Any]?
    let operationName: String?
    
    public init(mutation: String, variables: [String: Any]? = nil, operationName: String? = nil) {
        self.mutation = mutation
        self.variables = variables
        self.operationName = operationName
    }
}

public struct GraphQLSubscription {
    let subscription: String
    let variables: [String: Any]?
    let operationName: String?
    
    public init(subscription: String, variables: [String: Any]? = nil, operationName: String? = nil) {
        self.subscription = subscription
        self.variables = variables
        self.operationName = operationName
    }
}

// MARK: - GraphQL Response
public struct GraphQLResponse<T: Decodable>: Decodable {
    public let data: T?
    public let errors: [GraphQLError]?
    public let extensions: [String: AnyCodable]?
}

public struct GraphQLError: Decodable, Error {
    public let message: String
    public let locations: [Location]?
    public let path: [String]?
    public let extensions: [String: AnyCodable]?
    
    public struct Location: Decodable {
        public let line: Int
        public let column: Int
    }
}

// MARK: - GraphQL Client Protocol
public protocol GraphQLClientProtocol {
    func query<T: Decodable>(_ query: GraphQLQuery, type: T.Type) -> AnyPublisher<T, Error>
    func mutate<T: Decodable>(_ mutation: GraphQLMutation, type: T.Type) -> AnyPublisher<T, Error>
    func subscribe<T: Decodable>(_ subscription: GraphQLSubscription, type: T.Type) -> AnyPublisher<T, Error>
}

// MARK: - GraphQL Client Implementation
public final class GraphQLClient: GraphQLClientProtocol {
    
    // MARK: - Properties
    private let endpoint: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private var headers: [String: String]
    private let requestInterceptor: GraphQLRequestInterceptor?
    private let responseInterceptor: GraphQLResponseInterceptor?
    private let cache: GraphQLCache
    private let logger: GraphQLLogger
    
    // MARK: - Configuration
    public struct Configuration {
        public let endpoint: URL
        public let headers: [String: String]
        public let timeout: TimeInterval
        public let cachePolicy: CachePolicy
        public let retryPolicy: RetryPolicy
        public let loggingEnabled: Bool
        
        public enum CachePolicy {
            case disabled
            case inMemory(maxAge: TimeInterval)
            case persistent(maxAge: TimeInterval)
        }
        
        public enum RetryPolicy {
            case none
            case linear(maxAttempts: Int, delay: TimeInterval)
            case exponential(maxAttempts: Int, initialDelay: TimeInterval)
        }
        
        public init(
            endpoint: URL,
            headers: [String: String] = [:],
            timeout: TimeInterval = 30,
            cachePolicy: CachePolicy = .inMemory(maxAge: 300),
            retryPolicy: RetryPolicy = .exponential(maxAttempts: 3, initialDelay: 1),
            loggingEnabled: Bool = false
        ) {
            self.endpoint = endpoint
            self.headers = headers
            self.timeout = timeout
            self.cachePolicy = cachePolicy
            self.retryPolicy = retryPolicy
            self.loggingEnabled = loggingEnabled
        }
    }
    
    private let configuration: Configuration
    
    // MARK: - Initialization
    public init(
        configuration: Configuration,
        session: URLSession = .shared,
        requestInterceptor: GraphQLRequestInterceptor? = nil,
        responseInterceptor: GraphQLResponseInterceptor? = nil
    ) {
        self.configuration = configuration
        self.endpoint = configuration.endpoint
        self.session = session
        self.headers = configuration.headers
        self.requestInterceptor = requestInterceptor
        self.responseInterceptor = responseInterceptor
        
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        
        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
        
        self.cache = GraphQLCache(policy: configuration.cachePolicy)
        self.logger = GraphQLLogger(enabled: configuration.loggingEnabled)
    }
    
    // MARK: - Public Methods
    public func query<T: Decodable>(_ query: GraphQLQuery, type: T.Type) -> AnyPublisher<T, Error> {
        let cacheKey = cache.key(for: query)
        
        // Check cache first
        if let cached: T = cache.get(key: cacheKey) {
            logger.log("Cache hit for query: \(query.operationName ?? "unnamed")")
            return Just(cached)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return performRequest(
            body: createRequestBody(query: query.query, variables: query.variables, operationName: query.operationName),
            type: type
        )
        .handleEvents(receiveOutput: { [weak self] result in
            self?.cache.set(result, key: cacheKey)
        })
        .eraseToAnyPublisher()
    }
    
    public func mutate<T: Decodable>(_ mutation: GraphQLMutation, type: T.Type) -> AnyPublisher<T, Error> {
        return performRequest(
            body: createRequestBody(query: mutation.mutation, variables: mutation.variables, operationName: mutation.operationName),
            type: type
        )
    }
    
    public func subscribe<T: Decodable>(_ subscription: GraphQLSubscription, type: T.Type) -> AnyPublisher<T, Error> {
        // For WebSocket-based subscriptions, integrate with WebSocketManager
        return performRequest(
            body: createRequestBody(query: subscription.subscription, variables: subscription.variables, operationName: subscription.operationName),
            type: type
        )
    }
    
    // MARK: - Private Methods
    private func performRequest<T: Decodable>(body: Data, type: T.Type) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.httpBody = body
        request.timeoutInterval = configuration.timeout
        
        // Add headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Apply request interceptor
        if let interceptor = requestInterceptor {
            request = interceptor.intercept(request)
        }
        
        logger.logRequest(request, body: body)
        
        return session.dataTaskPublisher(for: request)
            .retry(configuration.retryPolicy)
            .tryMap { [weak self] data, response in
                self?.logger.logResponse(response, data: data)
                
                // Apply response interceptor
                if let interceptor = self?.responseInterceptor {
                    return try interceptor.intercept(data: data, response: response)
                }
                
                return data
            }
            .decode(type: GraphQLResponse<T>.self, decoder: decoder)
            .tryMap { response in
                if let errors = response.errors, !errors.isEmpty {
                    throw GraphQLClientError.graphQLErrors(errors)
                }
                
                guard let data = response.data else {
                    throw GraphQLClientError.noData
                }
                
                return data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func createRequestBody(query: String, variables: [String: Any]?, operationName: String?) -> Data {
        var body: [String: Any] = ["query": query]
        
        if let variables = variables {
            body["variables"] = variables
        }
        
        if let operationName = operationName {
            body["operationName"] = operationName
        }
        
        return (try? JSONSerialization.data(withJSONObject: body)) ?? Data()
    }
}

// MARK: - GraphQL Client Error
public enum GraphQLClientError: LocalizedError {
    case graphQLErrors([GraphQLError])
    case noData
    case invalidResponse
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .graphQLErrors(let errors):
            return errors.map { $0.message }.joined(separator: ", ")
        case .noData:
            return "No data received from GraphQL server"
        case .invalidResponse:
            return "Invalid response from GraphQL server"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Request Interceptor
public protocol GraphQLRequestInterceptor {
    func intercept(_ request: URLRequest) -> URLRequest
}

// MARK: - Response Interceptor
public protocol GraphQLResponseInterceptor {
    func intercept(data: Data, response: URLResponse) throws -> Data
}

// MARK: - GraphQL Cache
private class GraphQLCache {
    private let policy: GraphQLClient.Configuration.CachePolicy
    private var storage: [String: (data: Any, timestamp: Date)] = [:]
    private let queue = DispatchQueue(label: "com.iosapptemplates.graphql.cache", attributes: .concurrent)
    
    init(policy: GraphQLClient.Configuration.CachePolicy) {
        self.policy = policy
    }
    
    func key(for query: GraphQLQuery) -> String {
        var components = [query.query]
        if let variables = query.variables {
            let sortedVars = variables.sorted { $0.key < $1.key }
            components.append(sortedVars.description)
        }
        return components.joined(separator: "-").data(using: .utf8)?.base64EncodedString() ?? ""
    }
    
    func get<T>(key: String) -> T? {
        guard case .inMemory(let maxAge) = policy else { return nil }
        
        return queue.sync {
            guard let entry = storage[key],
                  Date().timeIntervalSince(entry.timestamp) < maxAge else {
                return nil
            }
            return entry.data as? T
        }
    }
    
    func set<T>(_ value: T, key: String) {
        guard case .inMemory = policy else { return }
        
        queue.async(flags: .barrier) {
            self.storage[key] = (value, Date())
        }
    }
    
    func clear() {
        queue.async(flags: .barrier) {
            self.storage.removeAll()
        }
    }
}

// MARK: - GraphQL Logger
private class GraphQLLogger {
    private let enabled: Bool
    
    init(enabled: Bool) {
        self.enabled = enabled
    }
    
    func log(_ message: String) {
        guard enabled else { return }
        print("[GraphQL] \(message)")
    }
    
    func logRequest(_ request: URLRequest, body: Data) {
        guard enabled else { return }
        
        var message = "[GraphQL Request]\n"
        message += "URL: \(request.url?.absoluteString ?? "unknown")\n"
        message += "Headers: \(request.allHTTPHeaderFields ?? [:])\n"
        
        if let bodyString = String(data: body, encoding: .utf8) {
            message += "Body: \(bodyString)"
        }
        
        print(message)
    }
    
    func logResponse(_ response: URLResponse, data: Data) {
        guard enabled else { return }
        
        var message = "[GraphQL Response]\n"
        
        if let httpResponse = response as? HTTPURLResponse {
            message += "Status: \(httpResponse.statusCode)\n"
            message += "Headers: \(httpResponse.allHeaderFields)\n"
        }
        
        if let dataString = String(data: data, encoding: .utf8) {
            message += "Body: \(dataString)"
        }
        
        print(message)
    }
}

// MARK: - Retry Support
private extension Publisher {
    func retry(_ policy: GraphQLClient.Configuration.RetryPolicy) -> AnyPublisher<Output, Failure> {
        switch policy {
        case .none:
            return self.eraseToAnyPublisher()
        case .linear(let maxAttempts, let delay):
            return self.retry(maxAttempts - 1, delay: .seconds(Int(delay)))
                .eraseToAnyPublisher()
        case .exponential(let maxAttempts, let initialDelay):
            return self.retryWithExponentialBackoff(maxAttempts: maxAttempts, initialDelay: initialDelay)
                .eraseToAnyPublisher()
        }
    }
    
    func retryWithExponentialBackoff(maxAttempts: Int, initialDelay: TimeInterval) -> AnyPublisher<Output, Failure> {
        var currentDelay = initialDelay
        
        return self.catch { error -> AnyPublisher<Output, Failure> in
            guard maxAttempts > 0 else {
                return Fail(error: error).eraseToAnyPublisher()
            }
            
            return Just(())
                .delay(for: .seconds(currentDelay), scheduler: DispatchQueue.main)
                .flatMap { _ -> AnyPublisher<Output, Failure> in
                    currentDelay *= 2
                    return self.retryWithExponentialBackoff(maxAttempts: maxAttempts - 1, initialDelay: currentDelay)
                }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - AnyCodable Helper
public struct AnyCodable: Codable {
    public let value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(Bool.self) {
            self.value = value
        } else if let value = try? container.decode(Int.self) {
            self.value = value
        } else if let value = try? container.decode(Double.self) {
            self.value = value
        } else if let value = try? container.decode(String.self) {
            self.value = value
        } else if let value = try? container.decode([AnyCodable].self) {
            self.value = value.map { $0.value }
        } else if let value = try? container.decode([String: AnyCodable].self) {
            self.value = value.mapValues { $0.value }
        } else {
            self.value = NSNull()
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case let value as Bool:
            try container.encode(value)
        case let value as Int:
            try container.encode(value)
        case let value as Double:
            try container.encode(value)
        case let value as String:
            try container.encode(value)
        case let value as [Any]:
            try container.encode(value.map { AnyCodable($0) })
        case let value as [String: Any]:
            try container.encode(value.mapValues { AnyCodable($0) })
        default:
            try container.encodeNil()
        }
    }
}