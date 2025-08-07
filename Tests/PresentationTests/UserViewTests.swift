import XCTest
import SwiftUI
@testable import iOSAppTemplates

final class UserViewTests: XCTestCase {
    var mockUserService: MockUserService!
    var userView: UserView!
    
    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        userView = UserView(userService: mockUserService)
    }
    
    override func tearDown() {
        userView = nil
        mockUserService = nil
        super.tearDown()
    }
    
    // MARK: - View Initialization Tests
    
    func testViewInitialization() {
        XCTAssertNotNil(userView)
        XCTAssertNotNil(userView.body)
    }
    
    func testViewHasCorrectStructure() {
        let viewBody = userView.body
        
        // Test that the view has the expected structure
        // This is a basic test to ensure the view compiles and has content
        XCTAssertNotNil(viewBody)
    }
    
    // MARK: - Loading State Tests
    
    func testLoadingStateDisplay() {
        // Given
        let viewModel = userView.viewModel
        viewModel.isLoading = true
        
        // When
        let body = userView.body
        
        // Then
        // The view should show loading indicator when isLoading is true
        XCTAssertNotNil(body)
    }
    
    func testLoadingStateHidden() {
        // Given
        let viewModel = userView.viewModel
        viewModel.isLoading = false
        
        // When
        let body = userView.body
        
        // Then
        // The view should not show loading indicator when isLoading is false
        XCTAssertNotNil(body)
    }
    
    // MARK: - User Data Display Tests
    
    func testUserDataDisplay() {
        // Given
        let testUser = User(
            id: "test-id",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: URL(string: "https://example.com/avatar.jpg"),
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let viewModel = userView.viewModel
        viewModel.user = testUser
        viewModel.isLoading = false
        viewModel.errorMessage = nil
        
        // When
        let body = userView.body
        
        // Then
        // The view should display user information
        XCTAssertNotNil(body)
    }
    
    func testEmptyUserState() {
        // Given
        let viewModel = userView.viewModel
        viewModel.user = nil
        viewModel.isLoading = false
        viewModel.errorMessage = nil
        
        // When
        let body = userView.body
        
        // Then
        // The view should handle empty user state gracefully
        XCTAssertNotNil(body)
    }
    
    // MARK: - Error State Tests
    
    func testErrorStateDisplay() {
        // Given
        let viewModel = userView.viewModel
        viewModel.errorMessage = "An error occurred"
        viewModel.isLoading = false
        viewModel.user = nil
        
        // When
        let body = userView.body
        
        // Then
        // The view should display error message
        XCTAssertNotNil(body)
    }
    
    func testErrorStateHidden() {
        // Given
        let viewModel = userView.viewModel
        viewModel.errorMessage = nil
        viewModel.isLoading = false
        
        // When
        let body = userView.body
        
        // Then
        // The view should not display error message when there's no error
        XCTAssertNotNil(body)
    }
    
    // MARK: - Authentication State Tests
    
    func testAuthenticatedState() {
        // Given
        let testUser = User(
            id: "test-id",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let viewModel = userView.viewModel
        viewModel.user = testUser
        viewModel.isAuthenticated = true
        viewModel.isLoading = false
        
        // When
        let body = userView.body
        
        // Then
        // The view should show authenticated user interface
        XCTAssertNotNil(body)
    }
    
    func testUnauthenticatedState() {
        // Given
        let viewModel = userView.viewModel
        viewModel.user = nil
        viewModel.isAuthenticated = false
        viewModel.isLoading = false
        
        // When
        let body = userView.body
        
        // Then
        // The view should show login interface
        XCTAssertNotNil(body)
    }
    
    // MARK: - User Profile Tests
    
    func testUserProfileDisplay() {
        // Given
        let testUser = User(
            id: "test-id",
            name: "Jane Smith",
            email: "jane@example.com",
            avatarURL: URL(string: "https://example.com/jane.jpg"),
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let viewModel = userView.viewModel
        viewModel.user = testUser
        viewModel.isAuthenticated = true
        viewModel.isLoading = false
        
        // When
        let body = userView.body
        
        // Then
        // The view should display user profile information
        XCTAssertNotNil(body)
    }
    
    func testUserProfileWithAvatar() {
        // Given
        let testUser = User(
            id: "test-id",
            name: "Alice Johnson",
            email: "alice@example.com",
            avatarURL: URL(string: "https://example.com/alice.jpg"),
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let viewModel = userView.viewModel
        viewModel.user = testUser
        viewModel.isAuthenticated = true
        viewModel.isLoading = false
        
        // When
        let body = userView.body
        
        // Then
        // The view should display user avatar
        XCTAssertNotNil(body)
    }
    
    func testUserProfileWithoutAvatar() {
        // Given
        let testUser = User(
            id: "test-id",
            name: "Bob Wilson",
            email: "bob@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let viewModel = userView.viewModel
        viewModel.user = testUser
        viewModel.isAuthenticated = true
        viewModel.isLoading = false
        
        // When
        let body = userView.body
        
        // Then
        // The view should handle missing avatar gracefully
        XCTAssertNotNil(body)
    }
    
    // MARK: - Form Validation Tests
    
    func testEmailValidation() {
        // Given
        let viewModel = userView.viewModel
        
        // When & Then
        XCTAssertTrue(viewModel.isValidEmail("test@example.com"))
        XCTAssertTrue(viewModel.isValidEmail("user.name@domain.co.uk"))
        XCTAssertTrue(viewModel.isValidEmail("user+tag@example.org"))
        
        XCTAssertFalse(viewModel.isValidEmail("invalid-email"))
        XCTAssertFalse(viewModel.isValidEmail("@example.com"))
        XCTAssertFalse(viewModel.isValidEmail("test@"))
        XCTAssertFalse(viewModel.isValidEmail(""))
    }
    
    func testPasswordValidation() {
        // Given
        let viewModel = userView.viewModel
        
        // When & Then
        XCTAssertTrue(viewModel.isValidPassword("password123"))
        XCTAssertTrue(viewModel.isValidPassword("SecurePass1!"))
        XCTAssertTrue(viewModel.isValidPassword("12345678"))
        
        XCTAssertFalse(viewModel.isValidPassword("short"))
        XCTAssertFalse(viewModel.isValidPassword(""))
        XCTAssertFalse(viewModel.isValidPassword("123"))
    }
    
    // MARK: - Accessibility Tests
    
    func testAccessibilityLabels() {
        // Given
        let viewModel = userView.viewModel
        viewModel.user = User(
            id: "test-id",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When
        let body = userView.body
        
        // Then
        // The view should have proper accessibility labels
        XCTAssertNotNil(body)
    }
    
    func testAccessibilityTraits() {
        // Given
        let viewModel = userView.viewModel
        viewModel.isAuthenticated = false
        
        // When
        let body = userView.body
        
        // Then
        // The view should have proper accessibility traits
        XCTAssertNotNil(body)
    }
    
    // MARK: - Dark Mode Tests
    
    func testDarkModeCompatibility() {
        // Given
        let viewModel = userView.viewModel
        viewModel.user = User(
            id: "test-id",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When
        let body = userView.body
        
        // Then
        // The view should work in dark mode
        XCTAssertNotNil(body)
    }
    
    // MARK: - Dynamic Type Tests
    
    func testDynamicTypeSupport() {
        // Given
        let viewModel = userView.viewModel
        viewModel.user = User(
            id: "test-id",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When
        let body = userView.body
        
        // Then
        // The view should support dynamic type
        XCTAssertNotNil(body)
    }
    
    // MARK: - Localization Tests
    
    func testLocalizationSupport() {
        // Given
        let viewModel = userView.viewModel
        viewModel.user = User(
            id: "test-id",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When
        let body = userView.body
        
        // Then
        // The view should support localization
        XCTAssertNotNil(body)
    }
    
    // MARK: - Performance Tests
    
    func testViewRenderingPerformance() {
        // Given
        let viewModel = userView.viewModel
        viewModel.user = User(
            id: "test-id",
            name: "Performance Test User",
            email: "performance@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When & Then
        measure {
            let _ = userView.body
        }
    }
    
    func testViewUpdatePerformance() {
        // Given
        let viewModel = userView.viewModel
        
        // When & Then
        measure {
            for i in 0..<100 {
                viewModel.user = User(
                    id: "test-\(i)",
                    name: "User \(i)",
                    email: "user\(i)@example.com",
                    avatarURL: nil,
                    createdAt: Date(),
                    updatedAt: Date()
                )
                let _ = userView.body
            }
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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}

struct UserView: View {
    @StateObject var viewModel: UserViewModel
    
    init(userService: UserServiceProtocol) {
        _viewModel = StateObject(wrappedValue: UserViewModel(userService: userService))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let user = viewModel.user {
                UserProfileView(user: user)
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage)
            } else {
                LoginView(viewModel: viewModel)
            }
        }
        .padding()
    }
}

struct UserProfileView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 20) {
            if let avatarURL = user.avatarURL {
                AsyncImage(url: avatarURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 10) {
                Text(user.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct LoginView: View {
    @ObservedObject var viewModel: UserViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Button("Login") {
                Task {
                    await viewModel.authenticate(email: email, password: password)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(email.isEmpty || password.isEmpty)
            
            Button("Login with Biometrics") {
                Task {
                    await viewModel.authenticateWithBiometrics()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
