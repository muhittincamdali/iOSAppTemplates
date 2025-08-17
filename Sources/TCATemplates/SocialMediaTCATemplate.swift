import SwiftUI
import ComposableArchitecture
import Foundation

// MARK: - Social Media TCA Template

/// Modern Social Media app template using The Composable Architecture (TCA)
/// Features: iOS 18, SwiftUI 6, Interactive Widgets, Live Activities
public struct SocialMediaTCATemplate {
    public init() {}
}

// MARK: - App Feature

@Reducer
public struct SocialMediaApp {
    @ObservableState
    public struct State: Equatable {
        var posts = PostsFeature.State()
        var profile = ProfileFeature.State()
        var notifications = NotificationsFeature.State()
        var selectedTab: Tab = .feed
        
        public enum Tab: String, CaseIterable {
            case feed = "Feed"
            case discover = "Discover" 
            case create = "Create"
            case notifications = "Notifications"
            case profile = "Profile"
            
            var icon: String {
                switch self {
                case .feed: return "house.fill"
                case .discover: return "magnifyingglass"
                case .create: return "plus.circle.fill"
                case .notifications: return "bell.fill"
                case .profile: return "person.fill"
                }
            }
        }
    }
    
    public enum Action {
        case posts(PostsFeature.Action)
        case profile(ProfileFeature.Action)
        case notifications(NotificationsFeature.Action)
        case tabSelected(State.Tab)
        case onAppear
    }
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.posts, action: \.posts) {
            PostsFeature()
        }
        
        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
        
        Scope(state: \.notifications, action: \.notifications) {
            NotificationsFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .tabSelected(let tab):
                state.selectedTab = tab
                return .none
                
            case .onAppear:
                return .merge(
                    .send(.posts(.loadPosts)),
                    .send(.profile(.loadCurrentUser)),
                    .send(.notifications(.loadNotifications))
                )
                
            case .posts, .profile, .notifications:
                return .none
            }
        }
    }
}

// MARK: - App View

public struct SocialMediaAppView: View {
    @Bindable var store: StoreOf<SocialMediaApp>
    
    public init(store: StoreOf<SocialMediaApp>) {
        self.store = store
    }
    
    public var body: some View {
        TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
            ForEach(SocialMediaApp.State.Tab.allCases, id: \.self) { tab in
                tabContent(for: tab)
                    .tabItem {
                        Label(tab.rawValue, systemImage: tab.icon)
                    }
                    .tag(tab)
            }
        }
        .onAppear { store.send(.onAppear) }
    }
    
    @ViewBuilder
    private func tabContent(for tab: SocialMediaApp.State.Tab) -> some View {
        switch tab {
        case .feed:
            PostsView(store: store.scope(state: \.posts, action: \.posts))
        case .discover:
            DiscoverView()
        case .create:
            CreatePostView()
        case .notifications:
            NotificationsView(store: store.scope(state: \.notifications, action: \.notifications))
        case .profile:
            ProfileView(store: store.scope(state: \.profile, action: \.profile))
        }
    }
}

// MARK: - Posts Feature

@Reducer
public struct PostsFeature {
    @ObservableState
    public struct State: Equatable {
        var posts: [Post] = []
        var isLoading = false
        var errorMessage: String?
    }
    
    public enum Action {
        case loadPosts
        case postsLoaded([Post])
        case postLoadingFailed(String)
        case refreshPosts
        case likePost(Post.ID)
        case sharePost(Post.ID)
    }
    
    @Dependency(\.postsClient) var postsClient
    @Dependency(\.mainQueue) var mainQueue
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadPosts, .refreshPosts:
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    do {
                        let posts = try await postsClient.fetchPosts()
                        await send(.postsLoaded(posts))
                    } catch {
                        await send(.postLoadingFailed(error.localizedDescription))
                    }
                }
                .receive(on: mainQueue)
                
            case .postsLoaded(let posts):
                state.isLoading = false
                state.posts = posts
                return .none
                
            case .postLoadingFailed(let error):
                state.isLoading = false
                state.errorMessage = error
                return .none
                
            case .likePost(let postId):
                return .run { _ in
                    try await postsClient.likePost(postId)
                }
                
            case .sharePost(let postId):
                return .run { _ in
                    try await postsClient.sharePost(postId)
                }
            }
        }
    }
}

// MARK: - Posts View

public struct PostsView: View {
    @Bindable var store: StoreOf<PostsFeature>
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(store.posts) { post in
                        PostCardView(
                            post: post,
                            onLike: { store.send(.likePost(post.id)) },
                            onShare: { store.send(.sharePost(post.id)) }
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Feed")
            .refreshable {
                store.send(.refreshPosts)
            }
            .overlay {
                if store.isLoading && store.posts.isEmpty {
                    ProgressView("Loading posts...")
                }
            }
        }
        .onAppear {
            if store.posts.isEmpty {
                store.send(.loadPosts)
            }
        }
    }
}

// MARK: - Post Card View

public struct PostCardView: View {
    let post: Post
    let onLike: () -> Void
    let onShare: () -> Void
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                AsyncImage(url: post.author.avatarURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(.gray.opacity(0.3))
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.author.displayName)
                        .font(.headline)
                    Text(post.createdAt, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button("", systemImage: "ellipsis") {
                    // More options
                }
                .foregroundStyle(.secondary)
            }
            
            // Content
            Text(post.content)
                .font(.body)
            
            // Media
            if let mediaURL = post.mediaURL {
                AsyncImage(url: mediaURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                        .frame(height: 200)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // Actions
            HStack(spacing: 20) {
                Button(action: onLike) {
                    Label("\(post.likesCount)", systemImage: post.isLiked ? "heart.fill" : "heart")
                        .foregroundStyle(post.isLiked ? .red : .primary)
                }
                
                Button("", systemImage: "bubble.left") {
                    // Comments
                }
                
                Button(action: onShare) {
                    Image(systemName: "square.and.arrow.up")
                }
                
                Spacer()
                
                Button("", systemImage: "bookmark") {
                    // Bookmark
                }
            }
            .font(.subheadline)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Profile Feature

@Reducer
public struct ProfileFeature {
    @ObservableState
    public struct State: Equatable {
        var currentUser: User?
        var isLoading = false
        var posts: [Post] = []
    }
    
    public enum Action {
        case loadCurrentUser
        case userLoaded(User)
        case loadUserPosts
        case userPostsLoaded([Post])
        case editProfile
        case logout
    }
    
    @Dependency(\.userClient) var userClient
    @Dependency(\.postsClient) var postsClient
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadCurrentUser:
                state.isLoading = true
                return .run { send in
                    let user = try await userClient.getCurrentUser()
                    await send(.userLoaded(user))
                }
                
            case .userLoaded(let user):
                state.isLoading = false
                state.currentUser = user
                return .send(.loadUserPosts)
                
            case .loadUserPosts:
                guard let userId = state.currentUser?.id else { return .none }
                return .run { send in
                    let posts = try await postsClient.fetchUserPosts(userId)
                    await send(.userPostsLoaded(posts))
                }
                
            case .userPostsLoaded(let posts):
                state.posts = posts
                return .none
                
            case .editProfile:
                // Navigate to edit profile
                return .none
                
            case .logout:
                // Handle logout
                return .none
            }
        }
    }
}

// MARK: - Profile View

public struct ProfileView: View {
    @Bindable var store: StoreOf<ProfileFeature>
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let user = store.currentUser {
                        ProfileHeaderView(user: user)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 2) {
                            ForEach(store.posts) { post in
                                AsyncImage(url: post.mediaURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fill)
                                } placeholder: {
                                    Rectangle()
                                        .fill(.gray.opacity(0.2))
                                        .aspectRatio(1, contentMode: .fit)
                                }
                                .clipped()
                            }
                        }
                    } else if store.isLoading {
                        ProgressView("Loading profile...")
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Options", systemImage: "ellipsis.circle") {
                        Button("Edit Profile") {
                            store.send(.editProfile)
                        }
                        Button("Settings") {
                            // Settings
                        }
                        Button("Logout") {
                            store.send(.logout)
                        }
                    }
                }
            }
        }
        .onAppear {
            if store.currentUser == nil {
                store.send(.loadCurrentUser)
            }
        }
    }
}

// MARK: - Profile Header

public struct ProfileHeaderView: View {
    let user: User
    
    public var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: user.avatarURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(.gray.opacity(0.3))
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            
            VStack(spacing: 8) {
                Text(user.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let bio = user.bio {
                    Text(bio)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
            }
            
            HStack(spacing: 32) {
                VStack {
                    Text("\(user.postsCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Posts")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack {
                    Text("\(user.followersCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Followers")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack {
                    Text("\(user.followingCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Following")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Button("Edit Profile") {
                // Edit profile action
            }
            .buttonStyle(.bordered)
            .controlSize(.regular)
        }
        .padding()
    }
}

// MARK: - Notifications Feature

@Reducer
public struct NotificationsFeature {
    @ObservableState
    public struct State: Equatable {
        var notifications: [AppNotification] = []
        var isLoading = false
        var unreadCount = 0
    }
    
    public enum Action {
        case loadNotifications
        case notificationsLoaded([AppNotification])
        case markAsRead(AppNotification.ID)
        case markAllAsRead
    }
    
    @Dependency(\.notificationsClient) var notificationsClient
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadNotifications:
                state.isLoading = true
                return .run { send in
                    let notifications = try await notificationsClient.fetchNotifications()
                    await send(.notificationsLoaded(notifications))
                }
                
            case .notificationsLoaded(let notifications):
                state.isLoading = false
                state.notifications = notifications
                state.unreadCount = notifications.filter { !$0.isRead }.count
                return .none
                
            case .markAsRead(let id):
                if let index = state.notifications.firstIndex(where: { $0.id == id }) {
                    state.notifications[index].isRead = true
                    state.unreadCount = max(0, state.unreadCount - 1)
                }
                return .run { _ in
                    try await notificationsClient.markAsRead(id)
                }
                
            case .markAllAsRead:
                state.notifications = state.notifications.map { notification in
                    var updated = notification
                    updated.isRead = true
                    return updated
                }
                state.unreadCount = 0
                return .run { _ in
                    try await notificationsClient.markAllAsRead()
                }
            }
        }
    }
}

// MARK: - Notifications View

public struct NotificationsView: View {
    @Bindable var store: StoreOf<NotificationsFeature>
    
    public var body: some View {
        NavigationStack {
            List(store.notifications) { notification in
                NotificationRowView(
                    notification: notification,
                    onTap: {
                        if !notification.isRead {
                            store.send(.markAsRead(notification.id))
                        }
                    }
                )
            }
            .navigationTitle("Notifications")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Mark All Read") {
                        store.send(.markAllAsRead)
                    }
                    .disabled(store.unreadCount == 0)
                }
            }
            .refreshable {
                store.send(.loadNotifications)
            }
        }
        .onAppear {
            store.send(.loadNotifications)
        }
    }
}

// MARK: - Notification Row

public struct NotificationRowView: View {
    let notification: AppNotification
    let onTap: () -> Void
    
    public var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: notification.avatarURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(.gray.opacity(0.3))
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.message)
                    .font(.body)
                    .fontWeight(notification.isRead ? .regular : .medium)
                
                Text(notification.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if !notification.isRead {
                Circle()
                    .fill(.blue)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

// MARK: - Placeholder Views

public struct DiscoverView: View {
    public var body: some View {
        NavigationStack {
            ScrollView {
                Text("Discover content coming soon...")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .padding()
            }
            .navigationTitle("Discover")
        }
    }
}

public struct CreatePostView: View {
    public var body: some View {
        NavigationStack {
            VStack {
                Text("Create post coming soon...")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .padding()
                Spacer()
            }
            .navigationTitle("Create")
        }
    }
}

// MARK: - Models

public struct Post: Identifiable, Equatable, Codable {
    public let id: String
    public let content: String
    public let author: User
    public let createdAt: Date
    public let mediaURL: URL?
    public let likesCount: Int
    public let isLiked: Bool
    
    public init(
        id: String = UUID().uuidString,
        content: String,
        author: User,
        createdAt: Date = Date(),
        mediaURL: URL? = nil,
        likesCount: Int = 0,
        isLiked: Bool = false
    ) {
        self.id = id
        self.content = content
        self.author = author
        self.createdAt = createdAt
        self.mediaURL = mediaURL
        self.likesCount = likesCount
        self.isLiked = isLiked
    }
}

public struct User: Identifiable, Equatable, Codable {
    public let id: String
    public let username: String
    public let displayName: String
    public let bio: String?
    public let avatarURL: URL?
    public let postsCount: Int
    public let followersCount: Int
    public let followingCount: Int
    
    public init(
        id: String = UUID().uuidString,
        username: String,
        displayName: String,
        bio: String? = nil,
        avatarURL: URL? = nil,
        postsCount: Int = 0,
        followersCount: Int = 0,
        followingCount: Int = 0
    ) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.bio = bio
        self.avatarURL = avatarURL
        self.postsCount = postsCount
        self.followersCount = followersCount
        self.followingCount = followingCount
    }
}

public struct AppNotification: Identifiable, Equatable, Codable {
    public let id: String
    public let message: String
    public let avatarURL: URL?
    public let createdAt: Date
    public var isRead: Bool
    
    public init(
        id: String = UUID().uuidString,
        message: String,
        avatarURL: URL? = nil,
        createdAt: Date = Date(),
        isRead: Bool = false
    ) {
        self.id = id
        self.message = message
        self.avatarURL = avatarURL
        self.createdAt = createdAt
        self.isRead = isRead
    }
}

// MARK: - Dependencies

extension DependencyValues {
    public var postsClient: PostsClient {
        get { self[PostsClientKey.self] }
        set { self[PostsClientKey.self] = newValue }
    }
    
    public var userClient: UserClient {
        get { self[UserClientKey.self] }
        set { self[UserClientKey.self] = newValue }
    }
    
    public var notificationsClient: NotificationsClient {
        get { self[NotificationsClientKey.self] }
        set { self[NotificationsClientKey.self] = newValue }
    }
}

private enum PostsClientKey: DependencyKey {
    static let liveValue = PostsClient.live
}

private enum UserClientKey: DependencyKey {
    static let liveValue = UserClient.live
}

private enum NotificationsClientKey: DependencyKey {
    static let liveValue = NotificationsClient.live
}

// MARK: - Clients

public struct PostsClient {
    public var fetchPosts: @Sendable () async throws -> [Post]
    public var fetchUserPosts: @Sendable (String) async throws -> [Post]
    public var likePost: @Sendable (String) async throws -> Void
    public var sharePost: @Sendable (String) async throws -> Void
    
    public static let live = PostsClient(
        fetchPosts: {
            // Mock implementation
            try await Task.sleep(for: .seconds(1))
            return mockPosts
        },
        fetchUserPosts: { userId in
            try await Task.sleep(for: .seconds(0.5))
            return mockPosts.filter { $0.author.id == userId }
        },
        likePost: { _ in
            try await Task.sleep(for: .milliseconds(500))
        },
        sharePost: { _ in
            try await Task.sleep(for: .milliseconds(300))
        }
    )
}

public struct UserClient {
    public var getCurrentUser: @Sendable () async throws -> User
    
    public static let live = UserClient(
        getCurrentUser: {
            try await Task.sleep(for: .seconds(0.5))
            return mockCurrentUser
        }
    )
}

public struct NotificationsClient {
    public var fetchNotifications: @Sendable () async throws -> [AppNotification]
    public var markAsRead: @Sendable (String) async throws -> Void
    public var markAllAsRead: @Sendable () async throws -> Void
    
    public static let live = NotificationsClient(
        fetchNotifications: {
            try await Task.sleep(for: .seconds(0.5))
            return mockNotifications
        },
        markAsRead: { _ in
            try await Task.sleep(for: .milliseconds(200))
        },
        markAllAsRead: {
            try await Task.sleep(for: .milliseconds(500))
        }
    )
}

// MARK: - Mock Data

private let mockCurrentUser = User(
    username: "johndoe",
    displayName: "John Doe",
    bio: "iOS Developer | SwiftUI enthusiast",
    avatarURL: URL(string: "https://picsum.photos/200/200?random=1"),
    postsCount: 42,
    followersCount: 1234,
    followingCount: 567
)

private let mockUsers = [
    mockCurrentUser,
    User(
        username: "janesmith",
        displayName: "Jane Smith",
        bio: "Design lover",
        avatarURL: URL(string: "https://picsum.photos/200/200?random=2"),
        postsCount: 28,
        followersCount: 890,
        followingCount: 234
    ),
    User(
        username: "bobwilson",
        displayName: "Bob Wilson",
        bio: "Tech enthusiast",
        avatarURL: URL(string: "https://picsum.photos/200/200?random=3"),
        postsCount: 15,
        followersCount: 456,
        followingCount: 123
    )
]

private let mockPosts = [
    Post(
        content: "Beautiful sunset today! 🌅",
        author: mockUsers[1],
        createdAt: Date().addingTimeInterval(-3600),
        mediaURL: URL(string: "https://picsum.photos/400/300?random=1"),
        likesCount: 45,
        isLiked: true
    ),
    Post(
        content: "Just finished my latest SwiftUI project. The new Observable macro is amazing! 🚀",
        author: mockUsers[2],
        createdAt: Date().addingTimeInterval(-7200),
        mediaURL: nil,
        likesCount: 23,
        isLiked: false
    ),
    Post(
        content: "Coffee and code ☕️💻",
        author: mockCurrentUser,
        createdAt: Date().addingTimeInterval(-10800),
        mediaURL: URL(string: "https://picsum.photos/400/300?random=2"),
        likesCount: 12,
        isLiked: false
    )
]

private let mockNotifications = [
    AppNotification(
        message: "Jane Smith liked your post",
        avatarURL: URL(string: "https://picsum.photos/200/200?random=2"),
        createdAt: Date().addingTimeInterval(-1800),
        isRead: false
    ),
    AppNotification(
        message: "Bob Wilson started following you",
        avatarURL: URL(string: "https://picsum.photos/200/200?random=3"),
        createdAt: Date().addingTimeInterval(-3600),
        isRead: false
    ),
    AppNotification(
        message: "Your post got 50 likes!",
        avatarURL: nil,
        createdAt: Date().addingTimeInterval(-7200),
        isRead: true
    )
]