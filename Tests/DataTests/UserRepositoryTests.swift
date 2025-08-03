import XCTest
@testable import iOSAppTemplates

final class UserRepositoryTests: XCTestCase {
    
    var userRepository: UserRepository!
    var mockRemoteDataSource: MockUserRemoteDataSource!
    var mockLocalDataSource: MockUserLocalDataSource!
    
    override func setUp() {
        super.setUp()
        mockRemoteDataSource = MockUserRemoteDataSource()
        mockLocalDataSource = MockUserLocalDataSource()
        userRepository = UserRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
    }
    
    override func tearDown() {
        userRepository = nil
        mockRemoteDataSource = nil
        mockLocalDataSource = nil
        super.tearDown()
    }
    
    // MARK: - Get User Tests
    
    func testGetUserSuccess() async throws {
        // Given
        let userId = "test-user-id"
        let expectedUser = User(
            id: userId,
            username: "testuser",
            email: "test@example.com",
            displayName: "Test User",
            avatarURL: "https://example.com/avatar.jpg",
            bio: "Test bio",
            followersCount: 100,
            followingCount: 50,
            postsCount: 25,
            isVerified: false,
            createdAt: Date(),
            lastActiveAt: Date()
        )
        mockRemoteDataSource.mockUser = expectedUser
        
        // When
        let result = try await userRepository.getUser(id: userId)
        
        // Then
        XCTAssertEqual(result.id, expectedUser.id)
        XCTAssertEqual(result.username, expectedUser.username)
        XCTAssertEqual(result.email, expectedUser.email)
        XCTAssertEqual(result.displayName, expectedUser.displayName)
    }
    
    func testGetUserFailure() async {
        // Given
        let userId = "invalid-user-id"
        mockRemoteDataSource.shouldFail = true
        mockRemoteDataSource.mockError = NetworkError.userNotFound
        
        // When & Then
        do {
            _ = try await userRepository.getUser(id: userId)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testGetUserWithLocalCache() async throws {
        // Given
        let userId = "test-user-id"
        let cachedUser = User(
            id: userId,
            username: "cacheduser",
            email: "cached@example.com",
            displayName: "Cached User",
            avatarURL: nil,
            bio: nil,
            followersCount: 0,
            followingCount: 0,
            postsCount: 0,
            isVerified: false,
            createdAt: Date(),
            lastActiveAt: Date()
        )
        mockLocalDataSource.mockUser = cachedUser
        mockRemoteDataSource.shouldFail = true
        
        // When
        let result = try await userRepository.getUser(id: userId)
        
        // Then
        XCTAssertEqual(result.id, cachedUser.id)
        XCTAssertEqual(result.username, cachedUser.username)
    }
    
    // MARK: - Create User Tests
    
    func testCreateUserSuccess() async throws {
        // Given
        let newUser = User(
            id: "new-user-id",
            username: "newuser",
            email: "new@example.com",
            displayName: "New User",
            avatarURL: nil,
            bio: nil,
            followersCount: 0,
            followingCount: 0,
            postsCount: 0,
            isVerified: false,
            createdAt: Date(),
            lastActiveAt: Date()
        )
        mockRemoteDataSource.mockUser = newUser
        
        // When
        let result = try await userRepository.createUser(newUser)
        
        // Then
        XCTAssertEqual(result.id, newUser.id)
        XCTAssertEqual(result.username, newUser.username)
        XCTAssertEqual(result.email, newUser.email)
    }
    
    func testCreateUserFailure() async {
        // Given
        let newUser = User(
            id: "new-user-id",
            username: "newuser",
            email: "new@example.com",
            displayName: "New User",
            avatarURL: nil,
            bio: nil,
            followersCount: 0,
            followingCount: 0,
            postsCount: 0,
            isVerified: false,
            createdAt: Date(),
            lastActiveAt: Date()
        )
        mockRemoteDataSource.shouldFail = true
        mockRemoteDataSource.mockError = NetworkError.invalidData
        
        // When & Then
        do {
            _ = try await userRepository.createUser(newUser)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    // MARK: - Update User Tests
    
    func testUpdateUserSuccess() async throws {
        // Given
        let userId = "test-user-id"
        let updatedUser = User(
            id: userId,
            username: "updateduser",
            email: "updated@example.com",
            displayName: "Updated User",
            avatarURL: "https://example.com/updated-avatar.jpg",
            bio: "Updated bio",
            followersCount: 150,
            followingCount: 75,
            postsCount: 30,
            isVerified: true,
            createdAt: Date(),
            lastActiveAt: Date()
        )
        mockRemoteDataSource.mockUser = updatedUser
        
        // When
        let result = try await userRepository.updateUser(updatedUser)
        
        // Then
        XCTAssertEqual(result.id, updatedUser.id)
        XCTAssertEqual(result.username, updatedUser.username)
        XCTAssertEqual(result.displayName, updatedUser.displayName)
        XCTAssertTrue(result.isVerified)
    }
    
    func testUpdateUserFailure() async {
        // Given
        let updatedUser = User(
            id: "test-user-id",
            username: "updateduser",
            email: "updated@example.com",
            displayName: "Updated User",
            avatarURL: nil,
            bio: nil,
            followersCount: 0,
            followingCount: 0,
            postsCount: 0,
            isVerified: false,
            createdAt: Date(),
            lastActiveAt: Date()
        )
        mockRemoteDataSource.shouldFail = true
        mockRemoteDataSource.mockError = NetworkError.userNotFound
        
        // When & Then
        do {
            _ = try await userRepository.updateUser(updatedUser)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    // MARK: - Delete User Tests
    
    func testDeleteUserSuccess() async throws {
        // Given
        let userId = "test-user-id"
        mockRemoteDataSource.shouldFail = false
        
        // When
        try await userRepository.deleteUser(id: userId)
        
        // Then
        XCTAssertTrue(mockRemoteDataSource.deleteUserCalled)
        XCTAssertEqual(mockRemoteDataSource.deletedUserId, userId)
    }
    
    func testDeleteUserFailure() async {
        // Given
        let userId = "test-user-id"
        mockRemoteDataSource.shouldFail = true
        mockRemoteDataSource.mockError = NetworkError.userNotFound
        
        // When & Then
        do {
            try await userRepository.deleteUser(id: userId)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    // MARK: - Get Users List Tests
    
    func testGetUsersListSuccess() async throws {
        // Given
        let expectedUsers = [
            User(
                id: "user1",
                username: "user1",
                email: "user1@example.com",
                displayName: "User One",
                avatarURL: nil,
                bio: nil,
                followersCount: 100,
                followingCount: 50,
                postsCount: 25,
                isVerified: false,
                createdAt: Date(),
                lastActiveAt: Date()
            ),
            User(
                id: "user2",
                username: "user2",
                email: "user2@example.com",
                displayName: "User Two",
                avatarURL: nil,
                bio: nil,
                followersCount: 200,
                followingCount: 100,
                postsCount: 50,
                isVerified: true,
                createdAt: Date(),
                lastActiveAt: Date()
            )
        ]
        mockRemoteDataSource.mockUsers = expectedUsers
        
        // When
        let result = try await userRepository.getUsers()
        
        // Then
        XCTAssertEqual(result.count, expectedUsers.count)
        XCTAssertEqual(result[0].id, expectedUsers[0].id)
        XCTAssertEqual(result[1].id, expectedUsers[1].id)
    }
    
    func testGetUsersListFailure() async {
        // Given
        mockRemoteDataSource.shouldFail = true
        mockRemoteDataSource.mockError = NetworkError.serverError
        
        // When & Then
        do {
            _ = try await userRepository.getUsers()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    // MARK: - Search Users Tests
    
    func testSearchUsersSuccess() async throws {
        // Given
        let searchQuery = "test"
        let expectedUsers = [
            User(
                id: "user1",
                username: "testuser1",
                email: "test1@example.com",
                displayName: "Test User One",
                avatarURL: nil,
                bio: nil,
                followersCount: 100,
                followingCount: 50,
                postsCount: 25,
                isVerified: false,
                createdAt: Date(),
                lastActiveAt: Date()
            )
        ]
        mockRemoteDataSource.mockUsers = expectedUsers
        
        // When
        let result = try await userRepository.searchUsers(query: searchQuery)
        
        // Then
        XCTAssertEqual(result.count, expectedUsers.count)
        XCTAssertEqual(result[0].username, expectedUsers[0].username)
    }
    
    func testSearchUsersEmptyResult() async throws {
        // Given
        let searchQuery = "nonexistent"
        mockRemoteDataSource.mockUsers = []
        
        // When
        let result = try await userRepository.searchUsers(query: searchQuery)
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
}

// MARK: - Mock Classes

class MockUserRemoteDataSource: UserRemoteDataSourceProtocol {
    var mockUser: User?
    var mockUsers: [User] = []
    var shouldFail = false
    var mockError: Error = NetworkError.unknown
    var deleteUserCalled = false
    var deletedUserId: String?
    
    func getUser(id: String) async throws -> User {
        if shouldFail {
            throw mockError
        }
        guard let user = mockUser else {
            throw NetworkError.userNotFound
        }
        return user
    }
    
    func createUser(_ user: User) async throws -> User {
        if shouldFail {
            throw mockError
        }
        return user
    }
    
    func updateUser(_ user: User) async throws -> User {
        if shouldFail {
            throw mockError
        }
        return user
    }
    
    func deleteUser(id: String) async throws {
        if shouldFail {
            throw mockError
        }
        deleteUserCalled = true
        deletedUserId = id
    }
    
    func getUsers() async throws -> [User] {
        if shouldFail {
            throw mockError
        }
        return mockUsers
    }
    
    func searchUsers(query: String) async throws -> [User] {
        if shouldFail {
            throw mockError
        }
        return mockUsers
    }
}

class MockUserLocalDataSource: UserLocalDataSourceProtocol {
    var mockUser: User?
    var mockUsers: [User] = []
    var shouldFail = false
    var mockError: Error = StorageError.unknown
    
    func saveUser(_ user: User) async throws {
        if shouldFail {
            throw mockError
        }
        mockUser = user
    }
    
    func getUser(id: String) async throws -> User? {
        if shouldFail {
            throw mockError
        }
        return mockUser
    }
    
    func updateUser(_ user: User) async throws {
        if shouldFail {
            throw mockError
        }
        mockUser = user
    }
    
    func deleteUser(id: String) async throws {
        if shouldFail {
            throw mockError
        }
        mockUser = nil
    }
    
    func saveUsers(_ users: [User]) async throws {
        if shouldFail {
            throw mockError
        }
        mockUsers = users
    }
    
    func getUsers() async throws -> [User] {
        if shouldFail {
            throw mockError
        }
        return mockUsers
    }
    
    func clearAll() async throws {
        if shouldFail {
            throw mockError
        }
        mockUser = nil
        mockUsers = []
    }
}

// MARK: - Error Types

enum NetworkError: Error, LocalizedError {
    case unknown
    case userNotFound
    case invalidData
    case serverError
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error occurred"
        case .userNotFound:
            return "User not found"
        case .invalidData:
            return "Invalid data received"
        case .serverError:
            return "Server error occurred"
        case .networkError:
            return "Network error occurred"
        }
    }
}

enum StorageError: Error, LocalizedError {
    case unknown
    case saveFailed
    case loadFailed
    case deleteFailed
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown storage error"
        case .saveFailed:
            return "Failed to save data"
        case .loadFailed:
            return "Failed to load data"
        case .deleteFailed:
            return "Failed to delete data"
        }
    }
}
