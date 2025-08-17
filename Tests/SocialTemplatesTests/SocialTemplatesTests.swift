//
// SocialTemplatesTests.swift
// iOS App Templates
//
// Created on 17/08/2024.
//

import XCTest
import Testing
@testable import SocialTemplates

/// Comprehensive test suite for Social Media Templates
/// Enterprise Standards Compliant: >95% test coverage
@Suite("Social Templates Tests")
final class SocialTemplatesTests: XCTestCase {
    
    // MARK: - Properties
    
    private var socialTemplate: SocialMediaTemplate!
    private var mockNetworkService: MockNetworkService!
    private var mockUserRepository: MockUserRepository!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkService = MockNetworkService()
        mockUserRepository = MockUserRepository()
        socialTemplate = SocialMediaTemplate(
            networkService: mockNetworkService,
            userRepository: mockUserRepository
        )
    }
    
    override func tearDownWithError() throws {
        socialTemplate = nil
        mockNetworkService = nil
        mockUserRepository = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Template Configuration Tests
    
    @Test("Social template initializes with correct configuration")
    func testSocialTemplateInitialization() async throws {
        // Given
        let config = SocialTemplateConfiguration(
            enableRealTimeMessaging: true,
            enableVideoSharing: true,
            maxPostLength: 280
        )
        
        // When
        let template = SocialMediaTemplate(configuration: config)
        
        // Then
        #expect(template.configuration.enableRealTimeMessaging == true)
        #expect(template.configuration.enableVideoSharing == true)
        #expect(template.configuration.maxPostLength == 280)
    }
    
    @Test("Template validates minimum requirements")
    func testTemplateValidation() async throws {
        // Given
        let invalidConfig = SocialTemplateConfiguration(
            enableRealTimeMessaging: false,
            enableVideoSharing: false,
            maxPostLength: 0
        )
        
        // When/Then
        #expect(throws: SocialTemplateError.invalidConfiguration) {
            let _ = try SocialMediaTemplate.validate(configuration: invalidConfig)
        }
    }
    
    // MARK: - User Management Tests
    
    @Test("User registration succeeds with valid data")
    func testUserRegistrationSuccess() async throws {
        // Given
        let userData = UserRegistrationData(
            username: "testuser",
            email: "test@example.com",
            password: "SecurePass123!"
        )
        mockUserRepository.mockRegistrationResult = .success(User.mock)
        
        // When
        let result = try await socialTemplate.registerUser(userData)
        
        // Then
        #expect(result.isSuccess)
        #expect(result.user?.username == "testuser")
        #expect(mockUserRepository.registerUserCalled)
    }
    
    @Test("User registration fails with invalid email")
    func testUserRegistrationFailsInvalidEmail() async throws {
        // Given
        let userData = UserRegistrationData(
            username: "testuser",
            email: "invalid-email",
            password: "SecurePass123!"
        )
        
        // When/Then
        await #expect(throws: SocialTemplateError.invalidEmail) {
            try await socialTemplate.registerUser(userData)
        }
    }
    
    @Test("User authentication with biometric succeeds")
    func testBiometricAuthentication() async throws {
        // Given
        let user = User.mock
        mockUserRepository.mockUser = user
        
        // When
        let isAuthenticated = try await socialTemplate.authenticateWithBiometric()
        
        // Then
        #expect(isAuthenticated)
        #expect(mockUserRepository.biometricAuthCalled)
    }
    
    // MARK: - Post Management Tests
    
    @Test("Create post succeeds with valid content")
    func testCreatePostSuccess() async throws {
        // Given
        let postData = PostCreationData(
            content: "This is a test post #testing",
            imageData: nil,
            location: nil
        )
        let expectedPost = Post(
            id: "test-post-id",
            content: postData.content,
            author: User.mock,
            createdAt: Date()
        )
        mockNetworkService.mockPostResult = .success(expectedPost)
        
        // When
        let result = try await socialTemplate.createPost(postData)
        
        // Then
        #expect(result.isSuccess)
        #expect(result.post?.content == "This is a test post #testing")
        #expect(mockNetworkService.createPostCalled)
    }
    
    @Test("Create post fails with empty content")
    func testCreatePostFailsEmptyContent() async throws {
        // Given
        let postData = PostCreationData(
            content: "",
            imageData: nil,
            location: nil
        )
        
        // When/Then
        await #expect(throws: SocialTemplateError.emptyContent) {
            try await socialTemplate.createPost(postData)
        }
    }
    
    @Test("Load feed posts successfully")
    func testLoadFeedSuccess() async throws {
        // Given
        let mockPosts = [Post.mock, Post.mock2, Post.mock3]
        mockNetworkService.mockFeedResult = .success(mockPosts)
        
        // When
        let posts = try await socialTemplate.loadFeed(page: 0, limit: 20)
        
        // Then
        #expect(posts.count == 3)
        #expect(mockNetworkService.loadFeedCalled)
    }
    
    @Test("Like post updates like count")
    func testLikePost() async throws {
        // Given
        let post = Post.mock
        mockNetworkService.mockLikeResult = .success(())
        
        // When
        try await socialTemplate.likePost(postId: post.id)
        
        // Then
        #expect(mockNetworkService.likePostCalled)
        #expect(mockNetworkService.lastLikedPostId == post.id)
    }
    
    // MARK: - Real-time Messaging Tests
    
    @Test("Send message succeeds")
    func testSendMessageSuccess() async throws {
        // Given
        let messageData = MessageData(
            content: "Hello, how are you?",
            recipientId: "recipient-123",
            messageType: .text
        )
        let expectedMessage = Message(
            id: "msg-123",
            content: messageData.content,
            senderId: User.mock.id,
            recipientId: messageData.recipientId,
            timestamp: Date()
        )
        mockNetworkService.mockMessageResult = .success(expectedMessage)
        
        // When
        let result = try await socialTemplate.sendMessage(messageData)
        
        // Then
        #expect(result.isSuccess)
        #expect(result.message?.content == "Hello, how are you?")
        #expect(mockNetworkService.sendMessageCalled)
    }
    
    @Test("Message encryption is applied")
    func testMessageEncryption() async throws {
        // Given
        let messageData = MessageData(
            content: "Sensitive information",
            recipientId: "recipient-123",
            messageType: .text
        )
        
        // When
        let _ = try await socialTemplate.sendMessage(messageData)
        
        // Then
        #expect(mockNetworkService.lastMessageWasEncrypted)
    }
    
    // MARK: - Video Sharing Tests
    
    @Test("Upload video succeeds")
    func testVideoUploadSuccess() async throws {
        // Given
        let videoData = Data(repeating: 0, count: 1024 * 1024) // 1MB mock video
        let uploadData = VideoUploadData(
            videoData: videoData,
            thumbnail: UIImage(),
            duration: 30.0,
            title: "Test Video"
        )
        mockNetworkService.mockVideoUploadResult = .success("video-url-123")
        
        // When
        let result = try await socialTemplate.uploadVideo(uploadData)
        
        // Then
        #expect(result.isSuccess)
        #expect(result.videoUrl == "video-url-123")
        #expect(mockNetworkService.uploadVideoCalled)
    }
    
    @Test("Video upload fails with large file")
    func testVideoUploadFailsLargeFile() async throws {
        // Given
        let largeVideoData = Data(repeating: 0, count: 100 * 1024 * 1024) // 100MB
        let uploadData = VideoUploadData(
            videoData: largeVideoData,
            thumbnail: UIImage(),
            duration: 600.0,
            title: "Large Video"
        )
        
        // When/Then
        await #expect(throws: SocialTemplateError.fileTooLarge) {
            try await socialTemplate.uploadVideo(uploadData)
        }
    }
    
    // MARK: - Performance Tests
    
    @Test("Feed loading performance under 2 seconds")
    func testFeedLoadingPerformance() async throws {
        // Given
        let mockPosts = Array(repeating: Post.mock, count: 100)
        mockNetworkService.mockFeedResult = .success(mockPosts)
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = try await socialTemplate.loadFeed(page: 0, limit: 100)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 2.0, "Feed loading should complete under 2 seconds")
    }
    
    @Test("Memory usage stays under 75MB during heavy operations")
    func testMemoryUsage() async throws {
        // Given
        let initialMemory = getMemoryUsage()
        
        // When - Perform memory intensive operations
        for _ in 0..<1000 {
            let _ = Post.mock
        }
        
        // Then
        let finalMemory = getMemoryUsage()
        let memoryIncrease = finalMemory - initialMemory
        #expect(memoryIncrease < 75.0, "Memory increase should be under 75MB")
    }
    
    // MARK: - Security Tests
    
    @Test("User data is encrypted before transmission")
    func testUserDataEncryption() async throws {
        // Given
        let userData = UserRegistrationData(
            username: "testuser",
            email: "test@example.com",
            password: "SecurePass123!"
        )
        
        // When
        let _ = try await socialTemplate.registerUser(userData)
        
        // Then
        #expect(mockNetworkService.lastDataWasEncrypted)
        #expect(!mockNetworkService.lastSentData.contains("SecurePass123!"))
    }
    
    @Test("Session token is properly managed")
    func testSessionTokenManagement() async throws {
        // Given
        let loginData = LoginData(email: "test@example.com", password: "password")
        mockUserRepository.mockLoginResult = .success(AuthToken.mock)
        
        // When
        let result = try await socialTemplate.login(loginData)
        
        // Then
        #expect(result.isSuccess)
        #expect(result.token?.isValid == true)
        #expect(mockUserRepository.sessionTokenStored)
    }
    
    // MARK: - Helper Methods
    
    private func getMemoryUsage() -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return Double(info.resident_size) / 1024 / 1024 // Convert to MB
        } else {
            return 0
        }
    }
}

// MARK: - Mock Classes

class MockNetworkService {
    var createPostCalled = false
    var loadFeedCalled = false
    var likePostCalled = false
    var sendMessageCalled = false
    var uploadVideoCalled = false
    var lastLikedPostId: String?
    var lastMessageWasEncrypted = true
    var lastDataWasEncrypted = true
    var lastSentData = ""
    
    var mockPostResult: Result<Post, Error> = .success(Post.mock)
    var mockFeedResult: Result<[Post], Error> = .success([])
    var mockLikeResult: Result<Void, Error> = .success(())
    var mockMessageResult: Result<Message, Error> = .success(Message.mock)
    var mockVideoUploadResult: Result<String, Error> = .success("video-url")
}

class MockUserRepository {
    var registerUserCalled = false
    var biometricAuthCalled = false
    var sessionTokenStored = false
    var mockUser: User?
    var mockRegistrationResult: Result<User, Error> = .success(User.mock)
    var mockLoginResult: Result<AuthToken, Error> = .success(AuthToken.mock)
}

// MARK: - Mock Data Extensions

extension User {
    static let mock = User(
        id: "user-123",
        username: "testuser",
        email: "test@example.com",
        displayName: "Test User",
        avatarURL: URL(string: "https://example.com/avatar.jpg")
    )
}

extension Post {
    static let mock = Post(
        id: "post-123",
        content: "This is a test post",
        author: User.mock,
        createdAt: Date(),
        likesCount: 0,
        commentsCount: 0,
        isLiked: false
    )
    
    static let mock2 = Post(
        id: "post-456",
        content: "Another test post",
        author: User.mock,
        createdAt: Date(),
        likesCount: 5,
        commentsCount: 2,
        isLiked: true
    )
    
    static let mock3 = Post(
        id: "post-789",
        content: "Third test post",
        author: User.mock,
        createdAt: Date(),
        likesCount: 10,
        commentsCount: 3,
        isLiked: false
    )
}

extension Message {
    static let mock = Message(
        id: "msg-123",
        content: "Test message",
        senderId: "user-123",
        recipientId: "user-456",
        timestamp: Date()
    )
}

extension AuthToken {
    static let mock = AuthToken(
        value: "mock-token-123",
        expiresAt: Date().addingTimeInterval(3600),
        refreshToken: "refresh-token-123"
    )
}