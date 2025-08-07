import XCTest
@testable import iOSAppTemplates

final class GetUserUseCaseTests: XCTestCase {
    var getUserUseCase: GetUserUseCase!
    var mockUserRepository: MockUserRepository!
    
    override func setUp() {
        super.setUp()
        mockUserRepository = MockUserRepository()
        getUserUseCase = GetUserUseCase(userRepository: mockUserRepository)
    }
    
    override func tearDown() {
        getUserUseCase = nil
        mockUserRepository = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    
    func testExecuteSuccess() async throws {
        // Given
        let userId = "test-user-id"
        let expectedUser = User(
            id: userId,
            name: "John Doe",
            email: "john@example.com",
            avatarURL: URL(string: "https://example.com/avatar.jpg"),
            createdAt: Date(),
            updatedAt: Date()
        )
        mockUserRepository.mockUser = expectedUser
        mockUserRepository.shouldSucceed = true
        
        // When
        let result = try await getUserUseCase.execute(id: userId)
        
        // Then
        XCTAssertEqual(result.id, expectedUser.id)
        XCTAssertEqual(result.name, expectedUser.name)
        XCTAssertEqual(result.email, expectedUser.email)
        XCTAssertEqual(result.avatarURL, expectedUser.avatarURL)
        XCTAssertTrue(mockUserRepository.getUserCalled)
        XCTAssertEqual(mockUserRepository.lastUserId, userId)
    }
    
    func testExecuteWithDifferentUserId() async throws {
        // Given
        let userId = "different-user-id"
        let expectedUser = User(
            id: userId,
            name: "Jane Smith",
            email: "jane@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        mockUserRepository.mockUser = expectedUser
        mockUserRepository.shouldSucceed = true
        
        // When
        let result = try await getUserUseCase.execute(id: userId)
        
        // Then
        XCTAssertEqual(result.id, expectedUser.id)
        XCTAssertEqual(result.name, expectedUser.name)
        XCTAssertEqual(result.email, expectedUser.email)
        XCTAssertEqual(mockUserRepository.lastUserId, userId)
    }
    
    // MARK: - Failure Tests
    
    func testExecuteUserNotFound() async throws {
        // Given
        let userId = "nonexistent-user-id"
        mockUserRepository.shouldSucceed = false
        mockUserRepository.mockError = UserRepositoryError.userNotFound
        
        // When & Then
        do {
            _ = try await getUserUseCase.execute(id: userId)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? UserRepositoryError, .userNotFound)
            XCTAssertTrue(mockUserRepository.getUserCalled)
            XCTAssertEqual(mockUserRepository.lastUserId, userId)
        }
    }
    
    func testExecuteNetworkError() async throws {
        // Given
        let userId = "test-user-id"
        let networkError = NetworkError.noConnection
        mockUserRepository.shouldSucceed = false
        mockUserRepository.mockError = UserRepositoryError.networkError(networkError)
        
        // When & Then
        do {
            _ = try await getUserUseCase.execute(id: userId)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? UserRepositoryError, .networkError(networkError))
            XCTAssertTrue(mockUserRepository.getUserCalled)
            XCTAssertEqual(mockUserRepository.lastUserId, userId)
        }
    }
    
    func testExecuteServerError() async throws {
        // Given
        let userId = "test-user-id"
        mockUserRepository.shouldSucceed = false
        mockUserRepository.mockError = UserRepositoryError.serverError("Internal server error")
        
        // When & Then
        do {
            _ = try await getUserUseCase.execute(id: userId)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? UserRepositoryError, .serverError("Internal server error"))
            XCTAssertTrue(mockUserRepository.getUserCalled)
            XCTAssertEqual(mockUserRepository.lastUserId, userId)
        }
    }
    
    // MARK: - Input Validation Tests
    
    func testExecuteWithEmptyUserId() async throws {
        // Given
        let emptyUserId = ""
        
        // When & Then
        do {
            _ = try await getUserUseCase.execute(id: emptyUserId)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? GetUserUseCaseError, .invalidUserId)
            XCTAssertFalse(mockUserRepository.getUserCalled)
        }
    }
    
    func testExecuteWithWhitespaceUserId() async throws {
        // Given
        let whitespaceUserId = "   "
        
        // When & Then
        do {
            _ = try await getUserUseCase.execute(id: whitespaceUserId)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? GetUserUseCaseError, .invalidUserId)
            XCTAssertFalse(mockUserRepository.getUserCalled)
        }
    }
    
    func testExecuteWithNilUserId() async throws {
        // Given
        let nilUserId: String? = nil
        
        // When & Then
        do {
            _ = try await getUserUseCase.execute(id: nilUserId ?? "")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? GetUserUseCaseError, .invalidUserId)
            XCTAssertFalse(mockUserRepository.getUserCalled)
        }
    }
    
    // MARK: - Edge Cases
    
    func testExecuteWithVeryLongUserId() async throws {
        // Given
        let longUserId = String(repeating: "a", count: 1000)
        let expectedUser = User(
            id: longUserId,
            name: "Long User",
            email: "long@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        mockUserRepository.mockUser = expectedUser
        mockUserRepository.shouldSucceed = true
        
        // When
        let result = try await getUserUseCase.execute(id: longUserId)
        
        // Then
        XCTAssertEqual(result.id, longUserId)
        XCTAssertTrue(mockUserRepository.getUserCalled)
        XCTAssertEqual(mockUserRepository.lastUserId, longUserId)
    }
    
    func testExecuteWithSpecialCharactersUserId() async throws {
        // Given
        let specialUserId = "user-id-with-special-chars-!@#$%^&*()"
        let expectedUser = User(
            id: specialUserId,
            name: "Special User",
            email: "special@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        mockUserRepository.mockUser = expectedUser
        mockUserRepository.shouldSucceed = true
        
        // When
        let result = try await getUserUseCase.execute(id: specialUserId)
        
        // Then
        XCTAssertEqual(result.id, specialUserId)
        XCTAssertTrue(mockUserRepository.getUserCalled)
        XCTAssertEqual(mockUserRepository.lastUserId, specialUserId)
    }
    
    // MARK: - Performance Tests
    
    func testExecutePerformance() {
        let userId = "performance-test-user"
        mockUserRepository.shouldSucceed = true
        mockUserRepository.mockUser = User(
            id: userId,
            name: "Performance User",
            email: "performance@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        measure {
            let expectation = XCTestExpectation(description: "GetUserUseCase performance")
            
            Task {
                _ = try await getUserUseCase.execute(id: userId)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 1.0)
        }
    }
    
    // MARK: - Concurrent Execution Tests
    
    func testConcurrentExecution() async throws {
        // Given
        let userIds = Array(0..<10).map { "user-\($0)" }
        mockUserRepository.shouldSucceed = true
        
        // When
        let results = await withThrowingTaskGroup(of: User.self) { group in
            for userId in userIds {
                group.addTask {
                    let user = User(
                        id: userId,
                        name: "User \(userId)",
                        email: "\(userId)@example.com",
                        avatarURL: nil,
                        createdAt: Date(),
                        updatedAt: Date()
                    )
                    self.mockUserRepository.mockUser = user
                    return try await self.getUserUseCase.execute(id: userId)
                }
            }
            
            var results: [User] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
        
        // Then
        XCTAssertEqual(results.count, userIds.count)
        XCTAssertEqual(mockUserRepository.getUserCallCount, userIds.count)
    }
    
    // MARK: - Repository Interaction Tests
    
    func testRepositoryCalledOnce() async throws {
        // Given
        let userId = "test-user-id"
        let expectedUser = User(
            id: userId,
            name: "Test User",
            email: "test@example.com",
            avatarURL: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        mockUserRepository.mockUser = expectedUser
        mockUserRepository.shouldSucceed = true
        
        // When
        _ = try await getUserUseCase.execute(id: userId)
        
        // Then
        XCTAssertEqual(mockUserRepository.getUserCallCount, 1)
    }
    
    func testRepositoryNotCalledOnValidationError() async throws {
        // Given
        let emptyUserId = ""
        
        // When
        do {
            _ = try await getUserUseCase.execute(id: emptyUserId)
        } catch {
            // Expected error
        }
        
        // Then
        XCTAssertEqual(mockUserRepository.getUserCallCount, 0)
    }
    
    // MARK: - Error Propagation Tests
    
    func testErrorPropagationFromRepository() async throws {
        // Given
        let userId = "test-user-id"
        let repositoryError = UserRepositoryError.userNotFound
        mockUserRepository.shouldSucceed = false
        mockUserRepository.mockError = repositoryError
        
        // When & Then
        do {
            _ = try await getUserUseCase.execute(id: userId)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? UserRepositoryError, repositoryError)
        }
    }
    
    func testMultipleErrorTypes() async throws {
        // Given
        let userId = "test-user-id"
        let errorTypes: [UserRepositoryError] = [
            .userNotFound,
            .networkError(.noConnection),
            .serverError("Server error"),
            .invalidData
        ]
        
        for errorType in errorTypes {
            mockUserRepository.shouldSucceed = false
            mockUserRepository.mockError = errorType
            
            // When & Then
            do {
                _ = try await getUserUseCase.execute(id: userId)
                XCTFail("Expected error to be thrown for \(errorType)")
            } catch {
                XCTAssertEqual(error as? UserRepositoryError, errorType)
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

enum GetUserUseCaseError: LocalizedError {
    case invalidUserId
    
    var errorDescription: String? {
        switch self {
        case .invalidUserId:
            return "Invalid user ID provided"
        }
    }
}

enum UserRepositoryError: LocalizedError {
    case userNotFound
    case networkError(NetworkError)
    case serverError(String)
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        case .invalidData:
            return "Invalid data received"
        }
    }
}

enum NetworkError: LocalizedError {
    case noConnection
    case timeout
    case serverError
    
    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "No internet connection"
        case .timeout:
            return "Request timeout"
        case .serverError:
            return "Server error"
        }
    }
}

protocol UserRepository {
    func getUser(id: String) async throws -> User
}

class MockUserRepository: UserRepository {
    var mockUser: User?
    var shouldSucceed = true
    var mockError: Error?
    
    var getUserCalled = false
    var getUserCallCount = 0
    var lastUserId: String?
    
    func getUser(id: String) async throws -> User {
        getUserCalled = true
        getUserCallCount += 1
        lastUserId = id
        
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
            throw mockError ?? UserRepositoryError.userNotFound
        }
    }
}

class GetUserUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(id: String) async throws -> User {
        // Input validation
        guard !id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw GetUserUseCaseError.invalidUserId
        }
        
        // Execute business logic
        return try await userRepository.getUser(id: id)
    }
}
