//
//  NetworkManager.swift
//  iOSAppTemplates
//
//  Created by Muhittin Camdali on 17/08/2024.
//

import Foundation
import Combine

/// Centralized network manager providing secure and efficient API communication
public final class NetworkManager: ObservableObject {
    public static let shared = NetworkManager()
    
    private let session: URLSession
    private let baseURL: URL
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Configuration
    
    public struct Configuration {
        let baseURL: String
        let timeout: TimeInterval
        let retryCount: Int
        let enableLogging: Bool
        
        public static let `default` = Configuration(
            baseURL: "https://api.example.com",
            timeout: 30.0,
            retryCount: 3,
            enableLogging: true
        )
    }
    
    private let configuration: Configuration
    
    // MARK: - Initialization
    
    public init(configuration: Configuration = .default) {
        self.configuration = configuration
        self.baseURL = URL(string: configuration.baseURL)!
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = configuration.timeout
        config.timeoutIntervalForResource = configuration.timeout * 2
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Public API
    
    public func request<T: Codable>(
        endpoint: Endpoint,
        responseType: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        guard let request = buildRequest(for: endpoint) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        if configuration.enableLogging {
            logRequest(request)
        }
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return NetworkError.decodingFailed
                } else {
                    return NetworkError.requestFailed(error)
                }
            }
            .retry(configuration.retryCount)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Request Building
    
    private func buildRequest(for endpoint: Endpoint) -> URLRequest? {
        let url = baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("iOS App Templates/1.0", forHTTPHeaderField: "User-Agent")
        
        // Add authentication header if available
        if let token = getAuthToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add request body for POST/PUT requests
        if let body = endpoint.body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                return nil
            }
        }
        
        return request
    }
    
    // MARK: - Authentication
    
    private func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: "auth_token")
    }
    
    public func setAuthToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "auth_token")
    }
    
    public func clearAuthToken() {
        UserDefaults.standard.removeObject(forKey: "auth_token")
    }
    
    // MARK: - Logging
    
    private func logRequest(_ request: URLRequest) {
        print("🌐 [Network] \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")
        
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("📝 [Network] Body: \(bodyString)")
        }
    }
}

// MARK: - Endpoint Protocol

public protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var body: [String: Any]? { get }
}

// MARK: - HTTP Method

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - Network Error

public enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed
    case unauthorized
    case serverError(Int)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .decodingFailed:
            return "Failed to decode response"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError(let code):
            return "Server error with code: \(code)"
        }
    }
}