import XCTest
import Combine
@testable import iOSAppTemplates

final class UserViewModelTests: XCTestCase {
    var viewModel: UserViewModel!
    var mockUserService: MockUserService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        viewModel = UserViewModel(userService: mockUserService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialState() {
        XCTAssertNil(viewModel.user)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isAuthenticated)
    }
    
    // MARK: - Authentication Tests
    
    func testSuccessfulAuthentication() async {
        // Given
        let expectedUser = User(
            id: "test-id",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        mockUserService.mockUser = expectedUser
        mockUserService.shouldSucceed = true
        
        // When
        await viewModel.authenticate(email: "test@example.com", password: "password123")
        
        // Then
        XCTAssertEqual(viewModel.user?.id, expectedUser.id)
        XCTAssertEqual(viewModel.user?.name, expectedUser.name)
        XCTAssertEqual(viewModel.user?.email, expectedUser.email)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.isAuthenticated)
    }
    
    func testFailedAuthentication() async {
        // Given
        mockUserService.shouldSucceed = false
        mockUserService.mockError = UserAPIError.invalidCredentials
        
        // When
        await viewModel.authenticate(email: "test@example.com", password: "wrongpassword")
        
        // Then
        XCTAssertNil(viewModel.user)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertEqual(viewModel.errorMessage, "Invalid email or password.")
    }
    
    func testAuthenticationWithEmptyCredentials() async {
        // When
        await viewModel.authenticate(email: "", password: "")
        
        // Then
        XCTAssertNil(viewModel.user)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isAuthenticated)
    }
    
    // MARK: - User Profile Tests
    
    func testLoadUserProfile() async {
        // Given
        let expectedUser = User(
            id: "user-id",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: URL(string: "https://example.com/avatar.jpg"),
            createdAt: Date(),
            updatedAt: Date()
        )
        mockUserService.mockUser = expectedUser
        mockUserService.shouldSucceed = true
        
        // When
        await viewModel.loadUserProfile(id: "user-id")
        
        // Then
        XCTAssertEqual(viewModel.user?.id, expectedUser.id)
        XCTAssertEqual(viewModel.user?.name, expectedUser.name)
        XCTAssertEqual(viewModel.user?.email, expectedUser.email)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadUserProfileFailure() async {
        // Given
        mockUserService.shouldSucceed = false
        mockUserService.mockError = UserAPIError.userNotFound
        
        // When
        await viewModel.loadUserProfile(id: "nonexistent-id")
        
        // Then
        XCTAssertNil(viewModel.user)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "User not found.")
    }
    
    // MARK: - User Update Tests
    
    func testUpdateUserProfile() async {
        // Given
        let originalUser = User(
            id: "user-id",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let updatedUser = User(
            id: "user-id",
            name: "John Smith",
            email: "john.smith@example.com",
            avatarURL: nil,
            createdAt: originalUser.createdAt,
            updatedAt: Date()
        )
        
        viewModel.user = originalUser
        mockUserService.mockUser = updatedUser
        mockUserService.shouldSucceed = true
        
        // When
        await viewModel.updateProfile(
            name: "John Smith",
            email: "john.smith@example.com",
            bio: "iOS Developer"
        )
        
        // Then
        XCTAssertEqual(viewModel.user?.name, updatedUser.name)
        XCTAssertEqual(viewModel.user?.email, updatedUser.email)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testUpdateUserProfileFailure() async {
        // Given
        let originalUser = User(
            id: "user-id",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        viewModel.user = originalUser
        mockUserService.shouldSucceed = false
        mockUserService.mockError = UserAPIError.validationError(["Invalid email format"])
        
        // When
        await viewModel.updateProfile(
            name: "John Smith",
            email: "invalid-email",
            bio: "iOS Developer"
        )
        
        // Then
        XCTAssertEqual(viewModel.user?.name, originalUser.name) // Should remain unchanged
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.errorMessage?.contains("Invalid email format") ?? false)
    }
    
    // MARK: - Logout Tests
    
    func testLogout() async {
        // Given
        let user = User(
            id: "user-id",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        viewModel.user = user
        viewModel.isAuthenticated = true
        mockUserService.shouldSucceed = true
        
        // When
        await viewModel.logout()
        
        // Then
        XCTAssertNil(viewModel.user)
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLogoutFailure() async {
        // Given
        let user = User(
            id: "user-id",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        viewModel.user = user
        viewModel.isAuthenticated = true
        mockUserService.shouldSucceed = false
        mockUserService.mockError = UserAPIError.networkError(NSError(domain: "Test", code: 0))
        
        // When
        await viewModel.logout()
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.errorMessage?.contains("Network error") ?? false)
    }
    
    // MARK: - Loading State Tests
    
    func testLoadingStateDuringAuthentication() async {
        // Given
        mockUserService.shouldSucceed = true
        mockUserService.mockUser = User(
            id: "test-id",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When
        let expectation = XCTestExpectation(description: "Loading state should be true during authentication")
        
        // Monitor loading state changes
        viewModel.$isLoading
            .dropFirst() // Skip initial value
            .sink { isLoading in
                if isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        await viewModel.authenticate(email: "test@example.com", password: "password123")
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading) // Should be false after completion
    }
    
    // MARK: - Error Handling Tests
    
    func testNetworkErrorHandling() async {
        // Given
        let networkError = NSError(domain: "Network", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
        mockUserService.shouldSucceed = false
        mockUserService.mockError = UserAPIError.networkError(networkError)
        
        // When
        await viewModel.authenticate(email: "test@example.com", password: "password123")
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.errorMessage?.contains("Server error") ?? false)
    }
    
    func testServerErrorHandling() async {
        // Given
        mockUserService.shouldSucceed = false
        mockUserService.mockError = UserAPIError.serverError("Internal server error")
        
        // When
        await viewModel.authenticate(email: "test@example.com", password: "password123")
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Server error: Internal server error")
    }
    
    // MARK: - Validation Tests
    
    func testEmailValidation() {
        // Valid emails
        XCTAssertTrue(viewModel.isValidEmail("test@example.com"))
        XCTAssertTrue(viewModel.isValidEmail("user.name@domain.co.uk"))
        XCTAssertTrue(viewModel.isValidEmail("user+tag@example.org"))
        
        // Invalid emails
        XCTAssertFalse(viewModel.isValidEmail("invalid-email"))
        XCTAssertFalse(viewModel.isValidEmail("@example.com"))
        XCTAssertFalse(viewModel.isValidEmail("test@"))
        XCTAssertFalse(viewModel.isValidEmail(""))
    }
    
    func testPasswordValidation() {
        // Valid passwords
        XCTAssertTrue(viewModel.isValidPassword("password123"))
        XCTAssertTrue(viewModel.isValidPassword("SecurePass1!"))
        XCTAssertTrue(viewModel.isValidPassword("12345678"))
        
        // Invalid passwords
        XCTAssertFalse(viewModel.isValidPassword("short"))
        XCTAssertFalse(viewModel.isValidPassword(""))
        XCTAssertFalse(viewModel.isValidPassword("123"))
    }
    
    // MARK: - Biometric Authentication Tests
    
    func testBiometricAuthenticationSuccess() async {
        // Given
        let expectedUser = User(
            id: "test-id",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        mockUserService.mockUser = expectedUser
        mockUserService.shouldSucceed = true
        
        // When
        await viewModel.authenticateWithBiometrics()
        
        // Then
        XCTAssertEqual(viewModel.user?.id, expectedUser.id)
        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testBiometricAuthenticationFailure() async {
        // Given
        mockUserService.shouldSucceed = false
        mockUserService.mockError = UserAPIError.authenticationFailed
        
        // When
        await viewModel.authenticateWithBiometrics()
        
        // Then
        XCTAssertNil(viewModel.user)
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Authentication failed. Please try again.")
    }
}

// MARK: - Mock User Service

class MockUserService: UserServiceProtocol {
    var mockUser: User?
    var shouldSucceed = true
    var mockError: Error?
    
    func authenticate(email: String, password: String) async throws -> User {
        if shouldSucceed {
            return mockUser ?? User(
                id: "mock-id",
                name: "Mock User",
                email: email,
                avatarURL: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
        } else {
            throw mockError ?? UserAPIError.invalidCredentials
        }
    }
    
    func authenticateWithBiometrics() async throws -> User {
        if shouldSucceed {
            return mockUser ?? User(
                id: "mock-id",
                name: "Mock User",
                email: "mock@example.com",
                avatarURL: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
        } else {
            throw mockError ?? UserAPIError.authenticationFailed
        }
    }
    
    func getUser(id: String) async throws -> User {
        if shouldSucceed {
            return mockUser ?? User(
                id: id,
                name: "Mock User",
                email: "mock@example.com",
                avatarURL: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
        } else {
            throw mockError ?? UserAPIError.userNotFound
        }
    }
    
    func updateUser(id: String, updates: UpdateUserRequest) async throws -> User {
        if shouldSucceed {
            return mockUser ?? User(
                id: id,
                name: updates.name ?? "Updated User",
                email: updates.email ?? "updated@example.com",
                avatarURL: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
        } else {
            throw mockError ?? UserAPIError.validationError(["Update failed"])
        }
    }
    
    func logout() async throws {
        if !shouldSucceed {
            throw mockError ?? UserAPIError.networkError(NSError(domain: "Test", code: 0))
        }
    }
}

// MARK: - Supporting Types

struct User {
    let id: String
    let name: String
    let email: String
    let avatarURL: URL?
    let createdAt: Date
    let updatedAt: Date
}

struct UpdateUserRequest {
    let name: String?
    let email: String?
    let bio: String?
}

enum UserAPIError: LocalizedError {
    case authenticationFailed
    case invalidCredentials
    case userNotFound
    case networkError(Error)
    case serverError(String)
    case validationError([String])
    
    var errorDescription: String? {
        switch self {
        case .authenticationFailed:
            return "Authentication failed. Please try again."
        case .invalidCredentials:
            return "Invalid email or password."
        case .userNotFound:
            return "User not found."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        case .validationError(let errors):
            return "Validation errors: \(errors.joined(separator: ", "))"
        }
    }
}

protocol UserServiceProtocol {
    func authenticate(email: String, password: String) async throws -> User
    func authenticateWithBiometrics() async throws -> User
    func getUser(id: String) async throws -> User
    func updateUser(id: String, updates: UpdateUserRequest) async throws -> User
    func logout() async throws
}

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    @MainActor
    func authenticate(email: String, password: String) async {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Email and password are required."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            user = try await userService.authenticate(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            isAuthenticated = false
        }
        
        isLoading = false
    }
    
    @MainActor
    func authenticateWithBiometrics() async {
        isLoading = true
        errorMessage = nil
        
        do {
            user = try await userService.authenticateWithBiometrics()
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            isAuthenticated = false
        }
        
        isLoading = false
    }
    
    @MainActor
    func loadUserProfile(id: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            user = try await userService.getUser(id: id)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    @MainActor
    func updateProfile(name: String?, email: String?, bio: String?) async {
        guard let currentUser = user else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let updates = UpdateUserRequest(name: name, email: email, bio: bio)
            user = try await userService.updateUser(id: currentUser.id, updates: updates)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    @MainActor
    func logout() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await userService.logout()
            user = nil
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
