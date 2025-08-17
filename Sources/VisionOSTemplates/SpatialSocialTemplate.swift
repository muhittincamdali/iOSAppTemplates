import SwiftUI
import RealityKit

#if os(visionOS)
import ComposableArchitecture

// MARK: - Spatial Social Media Template for Vision Pro

/// Revolutionary spatial social media app template for visionOS
/// Features: 3D content, immersive experiences, spatial interactions
public struct SpatialSocialTemplate {
    public init() {}
}

// MARK: - Spatial Social App

@main
struct SpatialSocialApp: App {
    @State private var immersionStyle: ImmersionStyle = .mixed
    
    var body: some Scene {
        WindowGroup {
            SpatialSocialView()
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1.0, height: 0.8, depth: 0.6, in: .meters)
        
        ImmersiveSpace(id: "SocialSpace") {
            SocialImmersiveView()
        }
        .immersionStyle(selection: $immersionStyle, in: .mixed, .progressive, .full)
    }
}

// MARK: - Main Spatial View

public struct SpatialSocialView: View {
    @State private var store = Store(initialState: SpatialSocialFeature.State()) {
        SpatialSocialFeature()
    }
    
    public var body: some View {
        NavigationSplitView {
            // Sidebar
            SpatialSidebarView(store: store)
                .frame(minWidth: 300)
        } detail: {
            // Main content
            SpatialContentView(store: store)
        }
        .onAppear {
            store.send(.loadInitialData)
        }
    }
}

// MARK: - Spatial Social Feature

@Reducer
public struct SpatialSocialFeature {
    @ObservableState
    public struct State: Equatable {
        var posts: [SpatialPost] = []
        var selectedPost: SpatialPost?
        var isLoading = false
        var showingImmersiveSpace = false
        var spatialUsers: [SpatialUser] = []
        var currentView: ViewMode = .feed
        
        public enum ViewMode: String, CaseIterable {
            case feed = "Feed"
            case spatial = "Spatial"
            case profile = "Profile"
            case immersive = "Immersive"
            
            var icon: String {
                switch self {
                case .feed: return "list.bullet"
                case .spatial: return "view.3d"
                case .profile: return "person.fill"
                case .immersive: return "visionpro"
                }
            }
        }
    }
    
    public enum Action {
        case loadInitialData
        case postsLoaded([SpatialPost])
        case selectPost(SpatialPost?)
        case changeView(State.ViewMode)
        case toggleImmersiveSpace
        case spatialInteraction(SpatialPost.ID, SpatialInteraction)
        case loadSpatialUsers
        case spatialUsersLoaded([SpatialUser])
    }
    
    @Dependency(\.spatialPostsClient) var spatialPostsClient
    @Dependency(\.spatialUsersClient) var spatialUsersClient
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadInitialData:
                state.isLoading = true
                return .merge(
                    .run { send in
                        let posts = try await spatialPostsClient.fetchSpatialPosts()
                        await send(.postsLoaded(posts))
                    },
                    .send(.loadSpatialUsers)
                )
                
            case .postsLoaded(let posts):
                state.isLoading = false
                state.posts = posts
                return .none
                
            case .selectPost(let post):
                state.selectedPost = post
                return .none
                
            case .changeView(let viewMode):
                state.currentView = viewMode
                return .none
                
            case .toggleImmersiveSpace:
                state.showingImmersiveSpace.toggle()
                return .none
                
            case .spatialInteraction(let postId, let interaction):
                return .run { _ in
                    try await spatialPostsClient.performSpatialInteraction(postId, interaction)
                }
                
            case .loadSpatialUsers:
                return .run { send in
                    let users = try await spatialUsersClient.fetchSpatialUsers()
                    await send(.spatialUsersLoaded(users))
                }
                
            case .spatialUsersLoaded(let users):
                state.spatialUsers = users
                return .none
            }
        }
    }
}

// MARK: - Spatial Sidebar

public struct SpatialSidebarView: View {
    @Bindable var store: StoreOf<SpatialSocialFeature>
    
    public var body: some View {
        List {
            Section("Navigation") {
                ForEach(SpatialSocialFeature.State.ViewMode.allCases, id: \.self) { mode in
                    Button(action: { store.send(.changeView(mode)) }) {
                        Label(mode.rawValue, systemImage: mode.icon)
                    }
                    .listRowBackground(
                        store.currentView == mode ? Color.blue.opacity(0.2) : Color.clear
                    )
                }
            }
            
            Section("Spatial Features") {
                Button("Enter Immersive Space") {
                    store.send(.toggleImmersiveSpace)
                }
                .disabled(store.showingImmersiveSpace)
            }
            
            Section("Online Users") {
                ForEach(store.spatialUsers.prefix(5)) { user in
                    SpatialUserRowView(user: user)
                }
            }
        }
        .navigationTitle("Spatial Social")
    }
}

// MARK: - Spatial Content View

public struct SpatialContentView: View {
    @Bindable var store: StoreOf<SpatialSocialFeature>
    
    public var body: some View {
        Group {
            switch store.currentView {
            case .feed:
                SpatialFeedView(store: store)
            case .spatial:
                Spatial3DView(store: store)
            case .profile:
                SpatialProfileView(store: store)
            case .immersive:
                ImmersiveSpaceToggleView(store: store)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Spatial Feed View

public struct SpatialFeedView: View {
    @Bindable var store: StoreOf<SpatialSocialFeature>
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(store.posts) { post in
                    SpatialPostCard3D(
                        post: post,
                        isSelected: store.selectedPost?.id == post.id,
                        onSelect: { store.send(.selectPost(post)) },
                        onSpatialInteraction: { interaction in
                            store.send(.spatialInteraction(post.id, interaction))
                        }
                    )
                    .frame(height: 300)
                }
            }
            .padding()
        }
        .navigationTitle("Spatial Feed")
        .overlay {
            if store.isLoading {
                ProgressView("Loading spatial content...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
            }
        }
    }
}

// MARK: - Spatial Post Card 3D

public struct SpatialPostCard3D: View {
    let post: SpatialPost
    let isSelected: Bool
    let onSelect: () -> Void
    let onSpatialInteraction: (SpatialInteraction) -> Void
    
    @State private var rotation: Double = 0
    @State private var scale: Double = 1.0
    @State private var hovered = false
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? .blue : .clear, lineWidth: 2)
                }
            
            VStack(alignment: .leading, spacing: 16) {
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
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(post.author.displayName)
                            .font(.headline)
                        Text(post.createdAt, style: .relative)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if post.has3DContent {
                        Image(systemName: "cube.fill")
                            .foregroundStyle(.blue)
                    }
                }
                
                // Content
                Text(post.content)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
                // 3D Content Preview
                if post.has3DContent {
                    Model3D(named: post.modelName ?? "DefaultModel") { model in
                        model
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .rotation3DEffect(
                                .degrees(rotation),
                                axis: (x: 0, y: 1, z: 0)
                            )
                    } placeholder: {
                        ProgressView()
                            .frame(height: 100)
                    }
                    .frame(height: 120)
                    .onAppear {
                        withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                            rotation = 360
                        }
                    }
                }
                
                // Spatial Actions
                HStack(spacing: 16) {
                    Button(action: { onSpatialInteraction(.like) }) {
                        Label("\(post.likesCount)", systemImage: post.isLiked ? "heart.fill" : "heart")
                            .foregroundStyle(post.isLiked ? .red : .primary)
                    }
                    
                    Button(action: { onSpatialInteraction(.spatialView) }) {
                        Label("View in Space", systemImage: "view.3d")
                    }
                    
                    Button(action: { onSpatialInteraction(.share) }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    
                    Spacer()
                }
                .font(.subheadline)
            }
            .padding()
        }
        .scaleEffect(scale)
        .rotation3DEffect(
            .degrees(hovered ? 5 : 0),
            axis: (x: 1, y: 0, z: 0)
        )
        .onHover { hovering in
            withAnimation(.spring(response: 0.3)) {
                hovered = hovering
                scale = hovering ? 1.05 : 1.0
            }
        }
        .onTapGesture {
            onSelect()
        }
        .animation(.spring(response: 0.4), value: isSelected)
    }
}

// MARK: - Spatial 3D View

public struct Spatial3DView: View {
    @Bindable var store: StoreOf<SpatialSocialFeature>
    
    public var body: some View {
        VStack {
            if let selectedPost = store.selectedPost {
                Spatial3DPostView(post: selectedPost)
            } else {
                ContentUnavailableView(
                    "No Post Selected",
                    systemImage: "cube",
                    description: Text("Select a post from the feed to view in 3D")
                )
            }
        }
        .navigationTitle("3D View")
    }
}

// MARK: - Spatial 3D Post View

public struct Spatial3DPostView: View {
    let post: SpatialPost
    @State private var rotationAngle: Double = 0
    @State private var scale: Double = 1.0
    
    public var body: some View {
        VStack(spacing: 20) {
            Text(post.content)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
            
            if post.has3DContent {
                Model3D(named: post.modelName ?? "DefaultModel") { model in
                    model
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .rotation3DEffect(
                            .degrees(rotationAngle),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .scaleEffect(scale)
                } placeholder: {
                    ProgressView("Loading 3D model...")
                        .frame(width: 200, height: 200)
                }
                .frame(minHeight: 300)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            rotationAngle = Double(value.translation.x)
                        }
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = value
                        }
                )
            }
            
            HStack(spacing: 20) {
                Button("Reset View") {
                    withAnimation(.spring()) {
                        rotationAngle = 0
                        scale = 1.0
                    }
                }
                .buttonStyle(.bordered)
                
                Button("Auto Rotate") {
                    withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                        rotationAngle += 360
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

// MARK: - Spatial Profile View

public struct SpatialProfileView: View {
    @Bindable var store: StoreOf<SpatialSocialFeature>
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Avatar in 3D space
                VStack {
                    Model3D(named: "UserAvatar") { model in
                        model
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Circle()
                            .fill(.blue.gradient)
                            .frame(width: 150, height: 150)
                    }
                    .frame(width: 150, height: 150)
                    
                    Text("Your Spatial Profile")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Connected in spatial reality")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                // Spatial Statistics
                HStack(spacing: 40) {
                    VStack {
                        Text("12")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("3D Posts")
                            .font(.caption)
                    }
                    
                    VStack {
                        Text("45")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Spatial Likes")
                            .font(.caption)
                    }
                    
                    VStack {
                        Text("8")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Immersive Sessions")
                            .font(.caption)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Recent spatial activities
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Spatial Activities")
                        .font(.headline)
                    
                    ForEach(0..<3) { index in
                        HStack {
                            Image(systemName: "cube.fill")
                                .foregroundStyle(.blue)
                            
                            VStack(alignment: .leading) {
                                Text("Viewed 3D Model #\(index + 1)")
                                    .font(.body)
                                Text("2 hours ago")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Spatial Profile")
    }
}

// MARK: - Immersive Space Toggle

public struct ImmersiveSpaceToggleView: View {
    @Bindable var store: StoreOf<SpatialSocialFeature>
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    public var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "visionpro")
                .font(.system(size: 80))
                .foregroundStyle(.blue.gradient)
            
            VStack(spacing: 16) {
                Text("Immersive Social Experience")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Step into a fully immersive social space where you can interact with content and other users in a shared 3D environment.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            
            Button(store.showingImmersiveSpace ? "Exit Immersive Space" : "Enter Immersive Space") {
                Task {
                    if store.showingImmersiveSpace {
                        await dismissImmersiveSpace()
                    } else {
                        await openImmersiveSpace(id: "SocialSpace")
                    }
                    store.send(.toggleImmersiveSpace)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .navigationTitle("Immersive Mode")
    }
}

// MARK: - Social Immersive View

public struct SocialImmersiveView: View {
    @State private var users: [SpatialUser] = mockSpatialUsers
    
    public var body: some View {
        RealityView { content in
            // Create the immersive social space
            let groundEntity = ModelEntity(
                mesh: .generatePlane(width: 10, depth: 10),
                materials: [SimpleMaterial(color: .gray.withAlphaComponent(0.3), isMetallic: false)]
            )
            groundEntity.position.y = -1
            content.add(groundEntity)
            
            // Add user avatars in space
            for (index, user) in users.enumerated() {
                let avatarEntity = ModelEntity(
                    mesh: .generateSphere(radius: 0.3),
                    materials: [SimpleMaterial(color: .blue, isMetallic: false)]
                )
                
                let angle = Float(index) * .pi * 2 / Float(users.count)
                avatarEntity.position = [sin(angle) * 3, 0, cos(angle) * 3]
                
                // Add user label
                let textEntity = ModelEntity(
                    mesh: .generateText(
                        user.displayName,
                        extrusionDepth: 0.01,
                        font: .systemFont(ofSize: 0.1),
                        containerFrame: .zero,
                        alignment: .center,
                        lineBreakMode: .byWordWrapping
                    ),
                    materials: [SimpleMaterial(color: .white, isMetallic: false)]
                )
                textEntity.position.y = 0.5
                avatarEntity.addChild(textEntity)
                
                content.add(avatarEntity)
            }
            
            // Add floating content
            for i in 0..<5 {
                let contentEntity = ModelEntity(
                    mesh: .generateBox(width: 0.5, height: 0.3, depth: 0.1),
                    materials: [SimpleMaterial(color: .orange, isMetallic: false)]
                )
                
                contentEntity.position = [
                    Float.random(in: -4...4),
                    Float.random(in: 1...3),
                    Float.random(in: -4...4)
                ]
                
                content.add(contentEntity)
            }
        }
    }
}

// MARK: - Spatial User Row

public struct SpatialUserRowView: View {
    let user: SpatialUser
    
    public var body: some View {
        HStack {
            AsyncImage(url: user.avatarURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(.blue.gradient)
            }
            .frame(width: 30, height: 30)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(user.isOnline ? .green : .gray)
                        .frame(width: 6, height: 6)
                    
                    Text(user.isOnline ? "Online" : "Offline")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            if user.inSpatialSpace {
                Image(systemName: "cube.fill")
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
        }
    }
}

// MARK: - Models

public struct SpatialPost: Identifiable, Equatable, Codable {
    public let id: String
    public let content: String
    public let author: SpatialUser
    public let createdAt: Date
    public let likesCount: Int
    public let isLiked: Bool
    public let has3DContent: Bool
    public let modelName: String?
    public let spatialData: SpatialData?
    
    public init(
        id: String = UUID().uuidString,
        content: String,
        author: SpatialUser,
        createdAt: Date = Date(),
        likesCount: Int = 0,
        isLiked: Bool = false,
        has3DContent: Bool = false,
        modelName: String? = nil,
        spatialData: SpatialData? = nil
    ) {
        self.id = id
        self.content = content
        self.author = author
        self.createdAt = createdAt
        self.likesCount = likesCount
        self.isLiked = isLiked
        self.has3DContent = has3DContent
        self.modelName = modelName
        self.spatialData = spatialData
    }
}

public struct SpatialUser: Identifiable, Equatable, Codable {
    public let id: String
    public let username: String
    public let displayName: String
    public let avatarURL: URL?
    public let isOnline: Bool
    public let inSpatialSpace: Bool
    public let spatialPosition: SpatialPosition?
    
    public init(
        id: String = UUID().uuidString,
        username: String,
        displayName: String,
        avatarURL: URL? = nil,
        isOnline: Bool = false,
        inSpatialSpace: Bool = false,
        spatialPosition: SpatialPosition? = nil
    ) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.avatarURL = avatarURL
        self.isOnline = isOnline
        self.inSpatialSpace = inSpatialSpace
        self.spatialPosition = spatialPosition
    }
}

public struct SpatialData: Equatable, Codable {
    public let position: SpatialPosition
    public let rotation: SpatialRotation
    public let scale: SpatialScale
    
    public init(
        position: SpatialPosition,
        rotation: SpatialRotation = SpatialRotation(),
        scale: SpatialScale = SpatialScale()
    ) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }
}

public struct SpatialPosition: Equatable, Codable {
    public let x: Float
    public let y: Float
    public let z: Float
    
    public init(x: Float = 0, y: Float = 0, z: Float = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public struct SpatialRotation: Equatable, Codable {
    public let x: Float
    public let y: Float
    public let z: Float
    
    public init(x: Float = 0, y: Float = 0, z: Float = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public struct SpatialScale: Equatable, Codable {
    public let x: Float
    public let y: Float
    public let z: Float
    
    public init(x: Float = 1, y: Float = 1, z: Float = 1) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public enum SpatialInteraction: String, CaseIterable {
    case like = "like"
    case share = "share"
    case spatialView = "spatialView"
    case comment = "comment"
    case save = "save"
}

// MARK: - Dependencies

extension DependencyValues {
    public var spatialPostsClient: SpatialPostsClient {
        get { self[SpatialPostsClientKey.self] }
        set { self[SpatialPostsClientKey.self] = newValue }
    }
    
    public var spatialUsersClient: SpatialUsersClient {
        get { self[SpatialUsersClientKey.self] }
        set { self[SpatialUsersClientKey.self] = newValue }
    }
}

private enum SpatialPostsClientKey: DependencyKey {
    static let liveValue = SpatialPostsClient.live
}

private enum SpatialUsersClientKey: DependencyKey {
    static let liveValue = SpatialUsersClient.live
}

// MARK: - Clients

public struct SpatialPostsClient {
    public var fetchSpatialPosts: @Sendable () async throws -> [SpatialPost]
    public var performSpatialInteraction: @Sendable (String, SpatialInteraction) async throws -> Void
    
    public static let live = SpatialPostsClient(
        fetchSpatialPosts: {
            try await Task.sleep(for: .seconds(1))
            return mockSpatialPosts
        },
        performSpatialInteraction: { _, _ in
            try await Task.sleep(for: .milliseconds(500))
        }
    )
}

public struct SpatialUsersClient {
    public var fetchSpatialUsers: @Sendable () async throws -> [SpatialUser]
    
    public static let live = SpatialUsersClient(
        fetchSpatialUsers: {
            try await Task.sleep(for: .seconds(0.5))
            return mockSpatialUsers
        }
    )
}

// MARK: - Mock Data

private let mockSpatialUsers = [
    SpatialUser(
        username: "alice3d",
        displayName: "Alice Johnson",
        avatarURL: URL(string: "https://picsum.photos/200/200?random=10"),
        isOnline: true,
        inSpatialSpace: true,
        spatialPosition: SpatialPosition(x: 1, y: 0, z: 2)
    ),
    SpatialUser(
        username: "bob_spatial",
        displayName: "Bob Chen",
        avatarURL: URL(string: "https://picsum.photos/200/200?random=11"),
        isOnline: true,
        inSpatialSpace: false
    ),
    SpatialUser(
        username: "carol_vr",
        displayName: "Carol Williams",
        avatarURL: URL(string: "https://picsum.photos/200/200?random=12"),
        isOnline: false,
        inSpatialSpace: false
    ),
    SpatialUser(
        username: "dave_3d",
        displayName: "Dave Rodriguez",
        avatarURL: URL(string: "https://picsum.photos/200/200?random=13"),
        isOnline: true,
        inSpatialSpace: true,
        spatialPosition: SpatialPosition(x: -1, y: 0, z: 1)
    )
]

private let mockSpatialPosts = [
    SpatialPost(
        content: "Check out this amazing 3D sculpture I created! 🎨",
        author: mockSpatialUsers[0],
        createdAt: Date().addingTimeInterval(-3600),
        likesCount: 42,
        isLiked: true,
        has3DContent: true,
        modelName: "Sculpture3D",
        spatialData: SpatialData(
            position: SpatialPosition(x: 0, y: 1, z: 0),
            rotation: SpatialRotation(x: 0, y: 45, z: 0),
            scale: SpatialScale(x: 1.2, y: 1.2, z: 1.2)
        )
    ),
    SpatialPost(
        content: "The future of social media is spatial! Experience this in 3D space. 🌟",
        author: mockSpatialUsers[1],
        createdAt: Date().addingTimeInterval(-7200),
        likesCount: 28,
        isLiked: false,
        has3DContent: true,
        modelName: "FutureModel",
        spatialData: SpatialData(
            position: SpatialPosition(x: 2, y: 0.5, z: -1)
        )
    ),
    SpatialPost(
        content: "Just joined the spatial social network. This is incredible! 🚀",
        author: mockSpatialUsers[3],
        createdAt: Date().addingTimeInterval(-10800),
        likesCount: 15,
        isLiked: false,
        has3DContent: false,
        modelName: nil,
        spatialData: nil
    ),
    SpatialPost(
        content: "Floating through virtual space with my digital art piece 🎭",
        author: mockSpatialUsers[0],
        createdAt: Date().addingTimeInterval(-14400),
        likesCount: 67,
        isLiked: true,
        has3DContent: true,
        modelName: "DigitalArt",
        spatialData: SpatialData(
            position: SpatialPosition(x: -2, y: 2, z: 1),
            rotation: SpatialRotation(x: 15, y: 0, z: 0),
            scale: SpatialScale(x: 0.8, y: 0.8, z: 0.8)
        )
    )
]

#endif