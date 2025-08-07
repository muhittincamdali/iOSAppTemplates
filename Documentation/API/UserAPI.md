# 👤 User API Documentation

## Overview

The User API provides comprehensive functionality for managing user data, authentication, and user-related operations in iOS App Templates.

## Table of Contents

- [Authentication](#authentication)
- [User Management](#user-management)
- [Profile Operations](#profile-operations)
- [Security](#security)
- [Error Handling](#error-handling)
- [Examples](#examples)

## Authentication

### User Authentication
```swift
protocol UserAuthenticationService {
    func authenticate(email: String, password: String) async throws -> User
    func authenticateWithBiometrics() async throws -> User
    func logout() async throws
    func refreshToken() async throws -> String
}
```

### Implementation
```swift
class UserAuthenticationServiceImpl: UserAuthenticationService {
    private let networkService: NetworkServiceProtocol
    private let keychainService: KeychainServiceProtocol
    
    init(networkService: NetworkServiceProtocol, keychainService: KeychainServiceProtocol) {
        self.networkService = networkService
        self.keychainService = keychainService
    }
    
    func authenticate(email: String, password: String) async throws -> User {
        let credentials = AuthCredentials(email: email, password: password)
        let request = AuthRequest(credentials: credentials)
        
        let response: AuthResponse = try await networkService.post(
            endpoint: "/auth/login",
            body: request
        )
        
        try await keychainService.saveToken(response.token)
        return response.user
    }
    
    func authenticateWithBiometrics() async throws -> User {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw AuthenticationError.biometricsNotAvailable
        }
        
        let success = try await context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Authenticate to access your account"
        )
        
        if success {
            guard let token = try? await keychainService.getToken() else {
                throw AuthenticationError.noStoredToken
            }
            
            let response: AuthResponse = try await networkService.post(
                endpoint: "/auth/refresh",
                headers: ["Authorization": "Bearer \(token)"]
            )
            
            return response.user
        } else {
            throw AuthenticationError.biometricAuthenticationFailed
        }
    }
    
    func logout() async throws {
        try await keychainService.deleteToken()
        // Additional cleanup
    }
    
    func refreshToken() async throws -> String {
        guard let currentToken = try? await keychainService.getToken() else {
            throw AuthenticationError.noStoredToken
        }
        
        let response: TokenRefreshResponse = try await networkService.post(
            endpoint: "/auth/refresh",
            headers: ["Authorization": "Bearer \(currentToken)"]
        )
        
        try await keychainService.saveToken(response.token)
        return response.token
    }
}
```

## User Management

### User Service
```swift
protocol UserServiceProtocol {
    func createUser(_ user: CreateUserRequest) async throws -> User
    func getUser(id: String) async throws -> User
    func updateUser(id: String, updates: UpdateUserRequest) async throws -> User
    func deleteUser(id: String) async throws
    func searchUsers(query: String) async throws -> [User]
    func getUsers(page: Int, limit: Int) async throws -> PaginatedUsersResponse
}
```

### Implementation
```swift
class UserServiceImpl: UserServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let cacheService: CacheServiceProtocol
    
    init(networkService: NetworkServiceProtocol, cacheService: CacheServiceProtocol) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func createUser(_ user: CreateUserRequest) async throws -> User {
        let response: User = try await networkService.post(
            endpoint: "/users",
            body: user
        )
        
        try await cacheService.cacheUser(response)
        return response
    }
    
    func getUser(id: String) async throws -> User {
        // Try cache first
        if let cachedUser = try? await cacheService.getCachedUser(id: id) {
            return cachedUser
        }
        
        // Fetch from network
        let user: User = try await networkService.get(endpoint: "/users/\(id)")
        
        // Cache the result
        try await cacheService.cacheUser(user)
        
        return user
    }
    
    func updateUser(id: String, updates: UpdateUserRequest) async throws -> User {
        let response: User = try await networkService.put(
            endpoint: "/users/\(id)",
            body: updates
        )
        
        // Update cache
        try await cacheService.cacheUser(response)
        
        return response
    }
    
    func deleteUser(id: String) async throws {
        try await networkService.delete(endpoint: "/users/\(id)")
        
        // Remove from cache
        try await cacheService.removeCachedUser(id: id)
    }
    
    func searchUsers(query: String) async throws -> [User] {
        let response: SearchUsersResponse = try await networkService.get(
            endpoint: "/users/search",
            query: ["q": query]
        )
        
        return response.users
    }
    
    func getUsers(page: Int, limit: Int) async throws -> PaginatedUsersResponse {
        let response: PaginatedUsersResponse = try await networkService.get(
            endpoint: "/users",
            query: ["page": "\(page)", "limit": "\(limit)"]
        )
        
        return response
    }
}
```

## Profile Operations

### Profile Management
```swift
protocol ProfileServiceProtocol {
    func updateProfile(_ profile: UpdateProfileRequest) async throws -> Profile
    func uploadAvatar(image: UIImage) async throws -> URL
    func getProfile(id: String) async throws -> Profile
    func updatePreferences(_ preferences: UserPreferences) async throws -> UserPreferences
}
```

### Implementation
```swift
class ProfileServiceImpl: ProfileServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let imageProcessor: ImageProcessorProtocol
    
    init(networkService: NetworkServiceProtocol, imageProcessor: ImageProcessorProtocol) {
        self.networkService = networkService
        self.imageProcessor = imageProcessor
    }
    
    func updateProfile(_ profile: UpdateProfileRequest) async throws -> Profile {
        let response: Profile = try await networkService.put(
            endpoint: "/profile",
            body: profile
        )
        
        return response
    }
    
    func uploadAvatar(image: UIImage) async throws -> URL {
        // Process image
        let processedImage = try await imageProcessor.processAvatar(image)
        
        // Create multipart form data
        let formData = MultipartFormData()
        formData.append(processedImage, withName: "avatar", fileName: "avatar.jpg", mimeType: "image/jpeg")
        
        let response: AvatarUploadResponse = try await networkService.upload(
            endpoint: "/profile/avatar",
            formData: formData
        )
        
        return response.avatarURL
    }
    
    func getProfile(id: String) async throws -> Profile {
        let response: Profile = try await networkService.get(endpoint: "/profile/\(id)")
        return response
    }
    
    func updatePreferences(_ preferences: UserPreferences) async throws -> UserPreferences {
        let response: UserPreferences = try await networkService.put(
            endpoint: "/profile/preferences",
            body: preferences
        )
        
        return response
    }
}
```

## Security

### Token Management
```swift
protocol TokenManagerProtocol {
    func saveToken(_ token: String) async throws
    func getToken() async throws -> String?
    func deleteToken() async throws
    func isTokenValid() async throws -> Bool
}
```

### Implementation
```swift
class TokenManagerImpl: TokenManagerProtocol {
    private let keychainService: KeychainServiceProtocol
    
    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }
    
    func saveToken(_ token: String) async throws {
        try await keychainService.save(key: "auth_token", value: token)
    }
    
    func getToken() async throws -> String? {
        return try await keychainService.get(key: "auth_token")
    }
    
    func deleteToken() async throws {
        try await keychainService.delete(key: "auth_token")
    }
    
    func isTokenValid() async throws -> Bool {
        guard let token = try await getToken() else { return false }
        
        // Decode JWT token and check expiration
        let payload = try decodeJWT(token)
        let expirationDate = Date(timeIntervalSince1970: payload.exp)
        
        return Date() < expirationDate
    }
}
```

## Error Handling

### User API Errors
```swift
enum UserAPIError: LocalizedError {
    case authenticationFailed
    case userNotFound
    case invalidCredentials
    case networkError(Error)
    case serverError(String)
    case validationError([String])
    
    var errorDescription: String? {
        switch self {
        case .authenticationFailed:
            return "Authentication failed. Please try again."
        case .userNotFound:
            return "User not found."
        case .invalidCredentials:
            return "Invalid email or password."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        case .validationError(let errors):
            return "Validation errors: \(errors.joined(separator: ", "))"
        }
    }
}
```

### Error Handling Implementation
```swift
extension UserServiceImpl {
    private func handleAPIError(_ error: NetworkError) throws {
        switch error {
        case .unauthorized:
            throw UserAPIError.authenticationFailed
        case .notFound:
            throw UserAPIError.userNotFound
        case .badRequest(let message):
            throw UserAPIError.validationError([message])
        case .serverError(let message):
            throw UserAPIError.serverError(message)
        case .networkError(let underlyingError):
            throw UserAPIError.networkError(underlyingError)
        }
    }
}
```

## Examples

### Basic Usage
```swift
// Initialize services
let networkService = NetworkServiceImpl()
let keychainService = KeychainServiceImpl()
let cacheService = CacheServiceImpl()

let authService = UserAuthenticationServiceImpl(
    networkService: networkService,
    keychainService: keychainService
)

let userService = UserServiceImpl(
    networkService: networkService,
    cacheService: cacheService
)

// Authenticate user
do {
    let user = try await authService.authenticate(
        email: "user@example.com",
        password: "password123"
    )
    print("Authenticated user: \(user.name)")
} catch {
    print("Authentication failed: \(error.localizedDescription)")
}

// Get user profile
do {
    let user = try await userService.getUser(id: "user-id")
    print("User profile: \(user)")
} catch {
    print("Failed to get user: \(error.localizedDescription)")
}
```

### Advanced Usage
```swift
// Search users
do {
    let users = try await userService.searchUsers(query: "john")
    print("Found \(users.count) users")
} catch {
    print("Search failed: \(error.localizedDescription)")
}

// Update user profile
do {
    let updates = UpdateUserRequest(
        name: "John Doe",
        email: "john.doe@example.com",
        bio: "iOS Developer"
    )
    
    let updatedUser = try await userService.updateUser(
        id: "user-id",
        updates: updates
    )
    
    print("Updated user: \(updatedUser)")
} catch {
    print("Update failed: \(error.localizedDescription)")
}
```

### Biometric Authentication
```swift
// Authenticate with biometrics
do {
    let user = try await authService.authenticateWithBiometrics()
    print("Biometric authentication successful: \(user.name)")
} catch {
    print("Biometric authentication failed: \(error.localizedDescription)")
}
```

## Data Models

### User Models
```swift
struct User: Codable {
    let id: String
    let email: String
    let name: String
    let avatarURL: URL?
    let createdAt: Date
    let updatedAt: Date
}

struct CreateUserRequest: Codable {
    let email: String
    let password: String
    let name: String
}

struct UpdateUserRequest: Codable {
    let name: String?
    let email: String?
    let bio: String?
}

struct PaginatedUsersResponse: Codable {
    let users: [User]
    let total: Int
    let page: Int
    let limit: Int
    let hasNext: Bool
}
```

### Authentication Models
```swift
struct AuthCredentials: Codable {
    let email: String
    let password: String
}

struct AuthRequest: Codable {
    let credentials: AuthCredentials
}

struct AuthResponse: Codable {
    let user: User
    let token: String
    let refreshToken: String
}

struct TokenRefreshResponse: Codable {
    let token: String
    let expiresAt: Date
}
```

---

**👤 User API provides comprehensive user management capabilities with security and performance in mind!**
