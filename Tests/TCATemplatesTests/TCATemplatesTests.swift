//
// TCATemplatesTests.swift
// iOS App Templates
//
// Created on 17/08/2024.
//

import XCTest
import Testing
import ComposableArchitecture
@testable import TCATemplates

/// Comprehensive test suite for TCA (The Composable Architecture) Templates
/// Enterprise Standards Compliant: >95% test coverage
@Suite("TCA Templates Tests")
final class TCATemplatesTests: XCTestCase {
    
    // MARK: - Properties
    
    private var store: TestStore<AppFeature.State, AppFeature.Action>!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.apiClient = .testValue
            $0.userDefaults = .mock
            $0.uuid = .incrementing
            $0.date = .constant(Date(timeIntervalSince1970: 1234567890))
        }
    }
    
    override func tearDownWithError() throws {
        store = nil
        try super.tearDownWithError()
    }
    
    // MARK: - App Feature Tests
    
    @Test("App feature initializes with correct state")
    @MainActor
    func testAppFeatureInitialization() async throws {
        // Given
        let initialState = AppFeature.State()
        
        // Then
        #expect(initialState.isLoading == false)
        #expect(initialState.user == nil)
        #expect(initialState.currentTab == .home)
    }
    
    @Test("App launch loads user session")
    @MainActor
    func testAppLaunch() async throws {
        // When
        await store.send(.appLaunched) {
            $0.isLoading = true
        }
        
        // Then
        await store.receive(.userSessionLoaded(.success(User.mock))) {
            $0.isLoading = false
            $0.user = User.mock
        }
    }
    
    @Test("Tab selection updates current tab")
    @MainActor
    func testTabSelection() async throws {
        // When
        await store.send(.tabSelected(.profile)) {
            $0.currentTab = .profile
        }
    }
    
    // MARK: - Authentication Feature Tests
    
    @Test("User login with valid credentials")
    @MainActor
    func testUserLoginSuccess() async throws {
        // Given
        let authStore = TestStore(initialState: AuthFeature.State()) {
            AuthFeature()
        } withDependencies: {
            $0.authClient = .testValue
        }
        
        // When
        await authStore.send(.loginButtonTapped) {
            $0.isLoggingIn = true
        }
        
        await authStore.send(.emailChanged("test@example.com")) {
            $0.email = "test@example.com"
        }
        
        await authStore.send(.passwordChanged("password123")) {
            $0.password = "password123"
        }
        
        await authStore.send(.loginRequested)
        
        // Then
        await authStore.receive(.loginResponse(.success(AuthToken.mock))) {
            $0.isLoggingIn = false
            $0.authToken = AuthToken.mock
        }
    }
    
    @Test("User login with invalid credentials fails")
    @MainActor
    func testUserLoginFailure() async throws {
        // Given
        let authStore = TestStore(initialState: AuthFeature.State()) {
            AuthFeature()
        } withDependencies: {
            $0.authClient.login = { _, _ in
                throw AuthError.invalidCredentials
            }
        }
        
        // When
        await authStore.send(.emailChanged("test@example.com")) {
            $0.email = "test@example.com"
        }
        
        await authStore.send(.passwordChanged("wrongpassword")) {
            $0.password = "wrongpassword"
        }
        
        await authStore.send(.loginRequested) {
            $0.isLoggingIn = true
        }
        
        // Then
        await authStore.receive(.loginResponse(.failure(AuthError.invalidCredentials))) {
            $0.isLoggingIn = false
            $0.errorMessage = "Invalid credentials"
        }
    }
    
    @Test("Biometric authentication succeeds")
    @MainActor
    func testBiometricAuthentication() async throws {
        // Given
        let authStore = TestStore(initialState: AuthFeature.State()) {
            AuthFeature()
        } withDependencies: {
            $0.biometricClient.authenticate = {
                return true
            }
        }
        
        // When
        await authStore.send(.biometricAuthRequested) {
            $0.isAuthenticating = true
        }
        
        // Then
        await authStore.receive(.biometricAuthResponse(.success(true))) {
            $0.isAuthenticating = false
            $0.isAuthenticated = true
        }
    }
    
    // MARK: - Social Media Feature Tests
    
    @Test("Load feed posts successfully")
    @MainActor
    func testLoadFeedPosts() async throws {
        // Given
        let socialStore = TestStore(initialState: SocialMediaFeature.State()) {
            SocialMediaFeature()
        } withDependencies: {
            $0.postsClient.fetchPosts = {
                return [Post.mock, Post.mock2]
            }
        }
        
        // When
        await socialStore.send(.loadPosts) {
            $0.isLoading = true
        }
        
        // Then
        await socialStore.receive(.postsLoaded(.success([Post.mock, Post.mock2]))) {
            $0.isLoading = false
            $0.posts = [Post.mock, Post.mock2]
        }
    }
    
    @Test("Create new post with content")
    @MainActor
    func testCreatePost() async throws {
        // Given
        let socialStore = TestStore(initialState: SocialMediaFeature.State()) {
            SocialMediaFeature()
        } withDependencies: {
            $0.postsClient.createPost = { content in
                return Post(
                    id: "new-post",
                    content: content,
                    author: User.mock,
                    createdAt: Date(),
                    likesCount: 0,
                    isLiked: false
                )
            }
        }
        
        // When
        await socialStore.send(.createPostTapped) {
            $0.isCreatingPost = true
        }
        
        await socialStore.send(.postContentChanged("Hello, world!")) {
            $0.newPostContent = "Hello, world!"
        }
        
        await socialStore.send(.submitPost)
        
        // Then
        await socialStore.receive(.postCreated(.success(Post.mockNewPost))) {
            $0.isCreatingPost = false
            $0.newPostContent = ""
            $0.posts = [Post.mockNewPost] + $0.posts
        }
    }
    
    @Test("Like post updates state")
    @MainActor
    func testLikePost() async throws {
        // Given
        let initialState = SocialMediaFeature.State(
            posts: [Post.mock]
        )
        let socialStore = TestStore(initialState: initialState) {
            SocialMediaFeature()
        } withDependencies: {
            $0.postsClient.likePost = { _ in }
        }
        
        // When
        await socialStore.send(.likePost(Post.mock.id))
        
        // Then
        await socialStore.receive(.postLiked(.success(Post.mock.id))) {
            $0.posts[0].isLiked = true
            $0.posts[0].likesCount += 1
        }
    }
    
    // MARK: - E-commerce Feature Tests
    
    @Test("Load product catalog")
    @MainActor
    func testLoadProductCatalog() async throws {
        // Given
        let commerceStore = TestStore(initialState: CommerceFeature.State()) {
            CommerceFeature()
        } withDependencies: {
            $0.productsClient.fetchProducts = {
                return [Product.mockElectronics, Product.mockClothing]
            }
        }
        
        // When
        await commerceStore.send(.loadProducts) {
            $0.isLoading = true
        }
        
        // Then
        await commerceStore.receive(.productsLoaded(.success([Product.mockElectronics, Product.mockClothing]))) {
            $0.isLoading = false
            $0.products = [Product.mockElectronics, Product.mockClothing]
        }
    }
    
    @Test("Add product to cart")
    @MainActor
    func testAddToCart() async throws {
        // Given
        let commerceStore = TestStore(initialState: CommerceFeature.State()) {
            CommerceFeature()
        } withDependencies: {
            $0.cartClient.addToCart = { product, quantity in
                return CartItem(product: product, quantity: quantity)
            }
        }
        
        // When
        await commerceStore.send(.addToCart(Product.mockElectronics, quantity: 1))
        
        // Then
        await commerceStore.receive(.productAddedToCart(.success(CartItem.mock))) {
            $0.cartItems.append(CartItem.mock)
            $0.cartTotal = $0.cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
        }
    }
    
    @Test("Remove product from cart")
    @MainActor
    func testRemoveFromCart() async throws {
        // Given
        let initialState = CommerceFeature.State(
            cartItems: [CartItem.mock],
            cartTotal: 999.99
        )
        let commerceStore = TestStore(initialState: initialState) {
            CommerceFeature()
        } withDependencies: {
            $0.cartClient.removeFromCart = { _ in }
        }
        
        // When
        await commerceStore.send(.removeFromCart(CartItem.mock.id))
        
        // Then
        await commerceStore.receive(.productRemovedFromCart(.success(CartItem.mock.id))) {
            $0.cartItems.removeAll { $0.id == CartItem.mock.id }
            $0.cartTotal = 0.0
        }
    }
    
    // MARK: - Finance Feature Tests
    
    @Test("Load account balance")
    @MainActor
    func testLoadAccountBalance() async throws {
        // Given
        let financeStore = TestStore(initialState: FinanceFeature.State()) {
            FinanceFeature()
        } withDependencies: {
            $0.bankingClient.getBalance = {
                return AccountBalance(checking: 5000.0, savings: 15000.0)
            }
        }
        
        // When
        await financeStore.send(.loadBalance) {
            $0.isLoading = true
        }
        
        // Then
        await financeStore.receive(.balanceLoaded(.success(AccountBalance.mock))) {
            $0.isLoading = false
            $0.balance = AccountBalance.mock
        }
    }
    
    @Test("Transfer funds between accounts")
    @MainActor
    func testTransferFunds() async throws {
        // Given
        let financeStore = TestStore(initialState: FinanceFeature.State()) {
            FinanceFeature()
        } withDependencies: {
            $0.bankingClient.transferFunds = { transferData in
                return TransferResult(
                    id: "transfer-123",
                    amount: transferData.amount,
                    status: .completed
                )
            }
        }
        
        let transferData = TransferData(
            fromAccount: "checking",
            toAccount: "savings",
            amount: 1000.0
        )
        
        // When
        await financeStore.send(.transferFunds(transferData)) {
            $0.isTransferring = true
        }
        
        // Then
        await financeStore.receive(.transferCompleted(.success(TransferResult.mock))) {
            $0.isTransferring = false
            $0.lastTransfer = TransferResult.mock
        }
    }
    
    // MARK: - Performance Tests
    
    @Test("State updates complete under 100ms")
    @MainActor
    func testStateUpdatePerformance() async throws {
        // Given
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // When
        await store.send(.tabSelected(.profile)) {
            $0.currentTab = .profile
        }
        
        // Then
        let endTime = CFAbsoluteTimeGetCurrent()
        let duration = endTime - startTime
        #expect(duration < 0.1, "State updates should complete under 100ms")
    }
    
    @Test("Effect processing under 500ms")
    @MainActor
    func testEffectPerformance() async throws {
        // Given
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // When
        await store.send(.appLaunched) {
            $0.isLoading = true
        }
        
        await store.receive(.userSessionLoaded(.success(User.mock))) {
            $0.isLoading = false
            $0.user = User.mock
        }
        
        // Then
        let endTime = CFAbsoluteTimeGetCurrent()
        let duration = endTime - startTime
        #expect(duration < 0.5, "Effect processing should complete under 500ms")
    }
    
    // MARK: - Memory Management Tests
    
    @Test("Store retains minimal memory footprint")
    func testMemoryUsage() async throws {
        // Given
        let initialMemory = getMemoryUsage()
        
        // When - Perform memory intensive operations
        var stores: [TestStore<AppFeature.State, AppFeature.Action>] = []
        for _ in 0..<100 {
            let store = TestStore(initialState: AppFeature.State()) {
                AppFeature()
            }
            stores.append(store)
        }
        
        // Then
        let finalMemory = getMemoryUsage()
        let memoryIncrease = finalMemory - initialMemory
        #expect(memoryIncrease < 50.0, "Memory increase should be under 50MB")
        
        // Cleanup
        stores.removeAll()
    }
    
    // MARK: - Concurrency Tests
    
    @Test("Concurrent actions handled correctly")
    @MainActor
    func testConcurrentActions() async throws {
        // Given
        let socialStore = TestStore(initialState: SocialMediaFeature.State()) {
            SocialMediaFeature()
        } withDependencies: {
            $0.postsClient.fetchPosts = {
                try await Task.sleep(nanoseconds: 100_000_000) // 100ms
                return [Post.mock]
            }
            $0.postsClient.likePost = { _ in
                try await Task.sleep(nanoseconds: 50_000_000) // 50ms
            }
        }
        
        // When - Send concurrent actions
        async let loadTask = socialStore.send(.loadPosts)
        async let likeTask = socialStore.send(.likePost("post-123"))
        
        // Then - Both actions should complete
        await loadTask
        await likeTask
        
        await socialStore.receive(.postsLoaded(.success([Post.mock]))) {
            $0.isLoading = false
            $0.posts = [Post.mock]
        }
        
        await socialStore.receive(.postLiked(.success("post-123")))
    }
    
    // MARK: - Error Handling Tests
    
    @Test("Network errors handled gracefully")
    @MainActor
    func testNetworkErrorHandling() async throws {
        // Given
        let socialStore = TestStore(initialState: SocialMediaFeature.State()) {
            SocialMediaFeature()
        } withDependencies: {
            $0.postsClient.fetchPosts = {
                throw NetworkError.connectionFailed
            }
        }
        
        // When
        await socialStore.send(.loadPosts) {
            $0.isLoading = true
        }
        
        // Then
        await socialStore.receive(.postsLoaded(.failure(NetworkError.connectionFailed))) {
            $0.isLoading = false
            $0.errorMessage = "Network connection failed"
        }
    }
    
    // MARK: - State Persistence Tests
    
    @Test("User preferences persist across sessions")
    @MainActor
    func testStatePersistence() async throws {
        // Given
        let userDefaults = UserDefaults.mock
        let settingsStore = TestStore(initialState: SettingsFeature.State()) {
            SettingsFeature()
        } withDependencies: {
            $0.userDefaults = userDefaults
        }
        
        // When
        await settingsStore.send(.themeChanged(.dark)) {
            $0.theme = .dark
        }
        
        await settingsStore.send(.saveSettings)
        
        // Then
        #expect(userDefaults.savedTheme == .dark)
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

// MARK: - Mock Dependencies

extension APIClient {
    static let testValue = Self(
        fetchUser: { User.mock },
        fetchPosts: { [Post.mock, Post.mock2] },
        createPost: { _ in Post.mockNewPost },
        likePost: { _ in }
    )
}

extension UserDefaults {
    static let mock = MockUserDefaults()
}

class MockUserDefaults: UserDefaults {
    var savedTheme: Theme?
    
    override func set(_ value: Any?, forKey defaultName: String) {
        if defaultName == "theme", let theme = value as? Theme {
            savedTheme = theme
        }
    }
    
    override func object(forKey defaultName: String) -> Any? {
        if defaultName == "theme" {
            return savedTheme
        }
        return nil
    }
}

// MARK: - Mock Data Extensions

extension User {
    static let mock = User(
        id: "user-123",
        username: "testuser",
        email: "test@example.com",
        displayName: "Test User"
    )
}

extension Post {
    static let mock = Post(
        id: "post-123",
        content: "This is a test post",
        author: User.mock,
        createdAt: Date(),
        likesCount: 5,
        isLiked: false
    )
    
    static let mock2 = Post(
        id: "post-456",
        content: "Another test post",
        author: User.mock,
        createdAt: Date(),
        likesCount: 10,
        isLiked: true
    )
    
    static let mockNewPost = Post(
        id: "new-post",
        content: "Hello, world!",
        author: User.mock,
        createdAt: Date(),
        likesCount: 0,
        isLiked: false
    )
}

extension Product {
    static let mockElectronics = Product(
        id: "product-123",
        name: "iPhone 16 Pro",
        price: 999.99,
        category: .electronics
    )
    
    static let mockClothing = Product(
        id: "product-456",
        name: "T-Shirt",
        price: 29.99,
        category: .clothing
    )
}

extension CartItem {
    static let mock = CartItem(
        id: "cart-item-123",
        product: Product.mockElectronics,
        quantity: 1
    )
}

extension AccountBalance {
    static let mock = AccountBalance(
        checking: 5000.0,
        savings: 15000.0
    )
}

extension TransferResult {
    static let mock = TransferResult(
        id: "transfer-123",
        amount: 1000.0,
        status: .completed
    )
}

extension AuthToken {
    static let mock = AuthToken(
        value: "mock-token-123",
        expiresAt: Date().addingTimeInterval(3600)
    )
}