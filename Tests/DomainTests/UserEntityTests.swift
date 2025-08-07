import XCTest
@testable import iOSAppTemplates

final class UserEntityTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testUserInitialization() {
        // Given
        let id = "test-user-id"
        let name = "John Doe"
        let email = "john@example.com"
        let avatarURL = URL(string: "https://example.com/avatar.jpg")
        let createdAt = Date()
        let updatedAt = Date()
        
        // When
        let user = User(
            id: id,
            name: name,
            email: email,
            avatarURL: avatarURL,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
        
        // Then
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.name, name)
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.avatarURL, avatarURL)
        XCTAssertEqual(user.createdAt, createdAt)
        XCTAssertEqual(user.updatedAt, updatedAt)
    }
    
    func testUserInitializationWithNilAvatar() {
        // Given
        let id = "test-user-id"
        let name = "Jane Smith"
        let email = "jane@example.com"
        let createdAt = Date()
        let updatedAt = Date()
        
        // When
        let user = User(
            id: id,
            name: name,
            email: email,
            avatarURL: nil,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
        
        // Then
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.name, name)
        XCTAssertEqual(user.email, email)
        XCTAssertNil(user.avatarURL)
        XCTAssertEqual(user.createdAt, createdAt)
        XCTAssertEqual(user.updatedAt, updatedAt)
    }
    
    // MARK: - Computed Properties Tests
    
    func testDisplayName() {
        // Given
        let userWithName = User(
            id: "1",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let userWithoutName = User(
            id: "2",
            name: "",
            email: "anonymous@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When & Then
        XCTAssertEqual(userWithName.displayName, "John Doe")
        XCTAssertEqual(userWithoutName.displayName, "Unknown User")
    }
    
    func testIsValidEmail() {
        // Given
        let validEmailUser = User(
            id: "1",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let invalidEmailUser = User(
            id: "2",
            name: "Test User",
            email: "invalid-email",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let emptyEmailUser = User(
            id: "3",
            name: "Test User",
            email: "",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When & Then
        XCTAssertTrue(validEmailUser.isValidEmail)
        XCTAssertFalse(invalidEmailUser.isValidEmail)
        XCTAssertFalse(emptyEmailUser.isValidEmail)
    }
    
    func testHasAvatar() {
        // Given
        let userWithAvatar = User(
            id: "1",
            name: "Test User",
            email: "test@example.com",
            avatarURL: URL(string: "https://example.com/avatar.jpg"),
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let userWithoutAvatar = User(
            id: "2",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When & Then
        XCTAssertTrue(userWithAvatar.hasAvatar)
        XCTAssertFalse(userWithoutAvatar.hasAvatar)
    }
    
    func testIsNewUser() {
        // Given
        let newUser = User(
            id: "1",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let oldUser = User(
            id: "2",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date().addingTimeInterval(-86400 * 30), // 30 days ago
            updatedAt: Date()
        )
        
        // When & Then
        XCTAssertTrue(newUser.isNewUser)
        XCTAssertFalse(oldUser.isNewUser)
    }
    
    // MARK: - Equality Tests
    
    func testUserEquality() {
        // Given
        let user1 = User(
            id: "test-id",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: URL(string: "https://example.com/avatar.jpg"),
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let user2 = User(
            id: "test-id",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: URL(string: "https://example.com/avatar.jpg"),
            createdAt: user1.createdAt,
            updatedAt: user1.updatedAt
        )
        
        let user3 = User(
            id: "different-id",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: URL(string: "https://example.com/avatar.jpg"),
            createdAt: user1.createdAt,
            updatedAt: user1.updatedAt
        )
        
        // When & Then
        XCTAssertEqual(user1, user2)
        XCTAssertNotEqual(user1, user3)
    }
    
    func testUserHashEquality() {
        // Given
        let user1 = User(
            id: "test-id",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let user2 = User(
            id: "test-id",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: nil,
            createdAt: user1.createdAt,
            updatedAt: user1.updatedAt
        )
        
        // When & Then
        XCTAssertEqual(user1.hashValue, user2.hashValue)
    }
    
    // MARK: - Codable Tests
    
    func testUserEncoding() throws {
        // Given
        let user = User(
            id: "test-id",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: URL(string: "https://example.com/avatar.jpg"),
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(user)
        
        // Then
        XCTAssertNotNil(data)
        XCTAssertGreaterThan(data.count, 0)
    }
    
    func testUserDecoding() throws {
        // Given
        let jsonString = """
        {
            "id": "test-id",
            "name": "John Doe",
            "email": "john@example.com",
            "avatarURL": "https://example.com/avatar.jpg",
            "createdAt": "2023-01-01T00:00:00Z",
            "updatedAt": "2023-01-01T00:00:00Z"
        }
        """
        
        let data = jsonString.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let user = try decoder.decode(User.self, from: data)
        
        // Then
        XCTAssertEqual(user.id, "test-id")
        XCTAssertEqual(user.name, "John Doe")
        XCTAssertEqual(user.email, "john@example.com")
        XCTAssertEqual(user.avatarURL?.absoluteString, "https://example.com/avatar.jpg")
    }
    
    func testUserDecodingWithNilAvatar() throws {
        // Given
        let jsonString = """
        {
            "id": "test-id",
            "name": "John Doe",
            "email": "john@example.com",
            "avatarURL": null,
            "createdAt": "2023-01-01T00:00:00Z",
            "updatedAt": "2023-01-01T00:00:00Z"
        }
        """
        
        let data = jsonString.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let user = try decoder.decode(User.self, from: data)
        
        // Then
        XCTAssertEqual(user.id, "test-id")
        XCTAssertEqual(user.name, "John Doe")
        XCTAssertEqual(user.email, "john@example.com")
        XCTAssertNil(user.avatarURL)
    }
    
    // MARK: - Validation Tests
    
    func testUserValidation() {
        // Given
        let validUser = User(
            id: "valid-id",
            name: "Valid User",
            email: "valid@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        let invalidUser = User(
            id: "",
            name: "",
            email: "invalid-email",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When & Then
        XCTAssertTrue(validUser.isValid)
        XCTAssertFalse(invalidUser.isValid)
    }
    
    func testUserValidationErrors() {
        // Given
        let user = User(
            id: "",
            name: "",
            email: "invalid-email",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When
        let errors = user.validationErrors
        
        // Then
        XCTAssertTrue(errors.contains(.invalidId))
        XCTAssertTrue(errors.contains(.invalidName))
        XCTAssertTrue(errors.contains(.invalidEmail))
    }
    
    // MARK: - Business Logic Tests
    
    func testCanEditProfile() {
        // Given
        let activeUser = User(
            id: "active-user",
            name: "Active User",
            email: "active@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date(),
            status: .active
        )
        
        let suspendedUser = User(
            id: "suspended-user",
            name: "Suspended User",
            email: "suspended@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date(),
            status: .suspended
        )
        
        // When & Then
        XCTAssertTrue(activeUser.canEditProfile)
        XCTAssertFalse(suspendedUser.canEditProfile)
    }
    
    func testCanSendMessages() {
        // Given
        let verifiedUser = User(
            id: "verified-user",
            name: "Verified User",
            email: "verified@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date(),
            isVerified: true
        )
        
        let unverifiedUser = User(
            id: "unverified-user",
            name: "Unverified User",
            email: "unverified@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date(),
            isVerified: false
        )
        
        // When & Then
        XCTAssertTrue(verifiedUser.canSendMessages)
        XCTAssertFalse(unverifiedUser.canSendMessages)
    }
    
    func testUserAge() {
        // Given
        let birthDate = Calendar.current.date(byAdding: .year, value: -25, to: Date())!
        let user = User(
            id: "test-user",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date(),
            birthDate: birthDate
        )
        
        // When
        let age = user.age
        
        // Then
        XCTAssertEqual(age, 25)
    }
    
    // MARK: - Performance Tests
    
    func testUserCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                let _ = User(
                    id: UUID().uuidString,
                    name: "Performance Test User",
                    email: "performance@example.com",
                    avatarURL: nil,
                    createdAt: Date(),
                    updatedAt: Date()
                )
            }
        }
    }
    
    func testUserValidationPerformance() {
        let user = User(
            id: "test-id",
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        measure {
            for _ in 0..<1000 {
                let _ = user.isValid
            }
        }
    }
    
    // MARK: - Edge Cases
    
    func testUserWithVeryLongName() {
        // Given
        let longName = String(repeating: "A", count: 1000)
        let user = User(
            id: "test-id",
            name: longName,
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When & Then
        XCTAssertEqual(user.name, longName)
        XCTAssertEqual(user.displayName, longName)
    }
    
    func testUserWithSpecialCharacters() {
        // Given
        let specialName = "José María O'Connor-Smith"
        let user = User(
            id: "test-id",
            name: specialName,
            email: "jose.maria@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When & Then
        XCTAssertEqual(user.name, specialName)
        XCTAssertEqual(user.displayName, specialName)
    }
    
    func testUserWithComplexEmail() {
        // Given
        let complexEmail = "user.name+tag@subdomain.example.co.uk"
        let user = User(
            id: "test-id",
            name: "Test User",
            email: complexEmail,
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        // When & Then
        XCTAssertEqual(user.email, complexEmail)
        XCTAssertTrue(user.isValidEmail)
    }
}

// MARK: - Supporting Types

struct User: Codable, Equatable, Hashable {
    let id: String
    let name: String
    let email: String
    let avatarURL: URL?
    let createdAt: Date
    let updatedAt: Date
    let status: UserStatus
    let isVerified: Bool
    let birthDate: Date?
    
    init(
        id: String,
        name: String,
        email: String,
        avatarURL: URL?,
        createdAt: Date,
        updatedAt: Date,
        status: UserStatus = .active,
        isVerified: Bool = false,
        birthDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.status = status
        self.isVerified = isVerified
        self.birthDate = birthDate
    }
    
    var displayName: String {
        return name.isEmpty ? "Unknown User" : name
    }
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    var hasAvatar: Bool {
        return avatarURL != nil
    }
    
    var isNewUser: Bool {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        return createdAt > thirtyDaysAgo
    }
    
    var isValid: Bool {
        return !id.isEmpty && !name.isEmpty && isValidEmail
    }
    
    var validationErrors: [UserValidationError] {
        var errors: [UserValidationError] = []
        
        if id.isEmpty {
            errors.append(.invalidId)
        }
        
        if name.isEmpty {
            errors.append(.invalidName)
        }
        
        if !isValidEmail {
            errors.append(.invalidEmail)
        }
        
        return errors
    }
    
    var canEditProfile: Bool {
        return status == .active
    }
    
    var canSendMessages: Bool {
        return isVerified
    }
    
    var age: Int {
        guard let birthDate = birthDate else { return 0 }
        return Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
    }
}

enum UserStatus: String, Codable {
    case active
    case suspended
    case deleted
}

enum UserValidationError: LocalizedError {
    case invalidId
    case invalidName
    case invalidEmail
    
    var errorDescription: String? {
        switch self {
        case .invalidId:
            return "Invalid user ID"
        case .invalidName:
            return "Invalid user name"
        case .invalidEmail:
            return "Invalid email address"
        }
    }
}
