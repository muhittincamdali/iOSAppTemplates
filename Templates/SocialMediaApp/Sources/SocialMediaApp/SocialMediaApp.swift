import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Kingfisher

private enum RuntimeCaptureMode {
    static let isEnabled = ProcessInfo.processInfo.environment["IOSAPPTEMPLATES_SCREENSHOT_MODE"] == "1"
}

// MARK: - Social Media App
@main
struct SocialMediaApp: App {
    
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var notificationManager = NotificationManager.shared
    
    init() {
        setupFirebase()
        setupAppearance()
        setupAnalytics()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(dataManager)
                .environmentObject(notificationManager)
                .onAppear {
                    setupApp()
                }
        }
    }
    
    // MARK: - Setup Methods
    private func setupFirebase() {
        guard !RuntimeCaptureMode.isEnabled else { return }
        FirebaseApp.configure()
        print("🔥 Firebase configured successfully")
    }
    
    private func setupAppearance() {
        // Navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        // Tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        print("🎨 App appearance configured")
    }
    
    private func setupAnalytics() {
        guard !RuntimeCaptureMode.isEnabled else { return }
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
        print("📊 Analytics configured")
    }
    
    private func setupApp() {
        if RuntimeCaptureMode.isEnabled {
            authManager.currentUser = User(
                id: "preview-user",
                username: "preview",
                email: "preview@iosapptemplates.dev",
                displayName: "Preview User",
                avatarURL: nil,
                bio: "Runtime screenshot mode",
                followersCount: 320,
                followingCount: 124,
                postsCount: 48,
                isVerified: true,
                createdAt: Date(),
                lastActiveAt: Date()
            )
            authManager.isAuthenticated = true
            dataManager.seedPreviewState(currentUser: authManager.currentUser)
            notificationManager.seedPreviewState()
            return
        }

        Task {
            await authManager.checkAuthState()
            await dataManager.initialize()
            await notificationManager.requestPermission()
        }
    }
}

// MARK: - Content View
struct ContentView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                SplashView()
            } else if authManager.isAuthenticated {
                MainTabView()
            } else {
                AuthView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authManager.isAuthenticated)
        .animation(.easeInOut(duration: 0.3), value: isLoading)
        .onAppear {
            let delay = RuntimeCaptureMode.isEnabled ? 0.1 : 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation {
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Splash View
struct SplashView: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var textOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // App logo
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.0)) {
                            logoScale = 1.0
                            logoOpacity = 1.0
                        }
                    }
                
                // App name
                Text("SocialConnect")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(textOpacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.0).delay(0.5)) {
                            textOpacity = 1.0
                        }
                    }
                
                // Tagline
                Text("Connect with the world")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .opacity(textOpacity)
            }
        }
    }
}

// MARK: - Auth View
struct AuthView: View {
    @State private var isSignUp = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                AuthHeaderView()
                
                // Auth forms
                if isSignUp {
                    SignUpView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                } else {
                    SignInView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                }
                
                // Toggle button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSignUp.toggle()
                    }
                }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Auth Header View
struct AuthHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Logo
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            // Title
            Text("Welcome to SocialConnect")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // Subtitle
            Text("Connect, share, and discover amazing content")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
        .padding(.horizontal, 32)
    }
}

// MARK: - Sign In View
struct SignInView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Form fields
            VStack(spacing: 16) {
                CustomTextField(
                    text: $email,
                    placeholder: "Email",
                    icon: "envelope",
                    validation: .email
                )
                
                CustomTextField(
                    text: $password,
                    placeholder: "Password",
                    icon: "lock",
                    validation: .password,
                    isSecure: true
                )
            }
            .padding(.horizontal, 32)
            
            // Sign in button
            PrimaryButton(
                title: "Sign In",
                isLoading: isLoading
            ) {
                signIn()
            }
            .padding(.horizontal, 32)
            
            // Forgot password
            Button("Forgot Password?") {
                // Handle forgot password
            }
            .font(.subheadline)
            .foregroundColor(.blue)
            
            Spacer()
        }
        .alert("Sign In Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        isLoading = true
        
        Task {
            do {
                try await authManager.signIn(email: email, password: password)
                await MainActor.run {
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}

// MARK: - Sign Up View
struct SignUpView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Form fields
            VStack(spacing: 16) {
                CustomTextField(
                    text: $username,
                    placeholder: "Username",
                    icon: "person",
                    validation: .username
                )
                
                CustomTextField(
                    text: $email,
                    placeholder: "Email",
                    icon: "envelope",
                    validation: .email
                )
                
                CustomTextField(
                    text: $password,
                    placeholder: "Password",
                    icon: "lock",
                    validation: .password,
                    isSecure: true
                )
                
                CustomTextField(
                    text: $confirmPassword,
                    placeholder: "Confirm Password",
                    icon: "lock",
                    validation: .password,
                    isSecure: true
                )
            }
            .padding(.horizontal, 32)
            
            // Sign up button
            PrimaryButton(
                title: "Create Account",
                isLoading: isLoading
            ) {
                signUp()
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .alert("Sign Up Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func signUp() {
        guard !username.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }
        
        isLoading = true
        
        Task {
            do {
                try await authManager.signUp(username: username, email: email, password: password)
                await MainActor.run {
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Feed")
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
                .tag(1)
            
            CreatePostView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Create")
                }
                .tag(2)
            
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
                .badge(notificationManager.notifications.filter(\.isUnread).count)
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.blue)
    }
}

// MARK: - Feed View
struct FeedView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showCreatePost = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(dataManager.posts) { post in
                        PostCard(post: post)
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCreatePost = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .refreshable {
                await dataManager.refreshFeed()
            }
            .sheet(isPresented: $showCreatePost) {
                CreatePostView()
            }
        }
    }
}

// MARK: - Post Card
struct PostCard: View {
    let post: Post
    @StateObject private var dataManager = DataManager.shared
    @State private var showComments = false
    
    private var currentPost: Post {
        dataManager.posts.first(where: { $0.id == post.id }) ?? post
    }
    
    private var isLiked: Bool {
        dataManager.likedPostIDs.contains(currentPost.id)
    }
    
    private var isBookmarked: Bool {
        dataManager.bookmarkedPostIDs.contains(currentPost.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                AsyncImage(url: URL(string: currentPost.authorAvatarURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.gray)
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(currentPost.authorDisplayName)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        if currentPost.authorIsVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                                .font(.caption)
                        }
                    }
                    
                    Text("@\(currentPost.authorUsername)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(currentPost.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Content
            Text(currentPost.content)
                .font(.body)
                .multilineTextAlignment(.leading)
            
            // Media
            if let images = currentPost.images, !images.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(images, id: \.self) { imageURL in
                            AsyncImage(url: URL(string: imageURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            // Actions
            HStack(spacing: 20) {
                Button(action: {
                    dataManager.toggleLike(postID: currentPost.id)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .primary)
                        Text("\(currentPost.likesCount)")
                            .font(.caption)
                    }
                }
                
                Button(action: {
                    showComments = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.left")
                        Text("\(currentPost.commentsCount)")
                            .font(.caption)
                    }
                }
                
                Button(action: {
                    dataManager.sharePost(postID: currentPost.id)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrowshape.turn.up.right")
                        Text("\(currentPost.sharesCount)")
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    dataManager.toggleBookmark(postID: currentPost.id)
                }) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(isBookmarked ? .blue : .primary)
                }
            }
            .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
        .sheet(isPresented: $showComments) {
            CommentsView(post: currentPost)
        }
    }
}

// MARK: - Models
struct Post: Identifiable, Codable {
    let id: String
    let authorId: String
    let authorUsername: String
    let authorDisplayName: String
    let authorAvatarURL: String?
    let authorIsVerified: Bool
    var content: String
    var images: [String]?
    let videoURL: String?
    var likesCount: Int
    var commentsCount: Int
    var sharesCount: Int
    let createdAt: Date
    let updatedAt: Date
}

struct SuggestedProfile: Identifiable {
    let id: String
    let username: String
    let displayName: String
    let bio: String
    let avatarURL: String?
    let isVerified: Bool
    var followersCount: Int
}

struct PostComment: Identifiable {
    let id: String
    let authorName: String
    let authorUsername: String
    let body: String
    let likesCount: Int
    let createdAt: Date
}

struct SocialNotificationItem: Identifiable {
    let id: String
    let actorName: String
    let message: String
    let systemImage: String
    var isUnread: Bool
    let createdAt: Date
}

// MARK: - View Models
@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        loadMockData()
    }
    
    func refreshFeed() async {
        await MainActor.run {
            isLoading = true
        }
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await MainActor.run {
            loadMockData()
            isLoading = false
        }
    }
    
    private func loadMockData() {
        posts = [
            Post(
                id: "1",
                authorId: "user1",
                authorUsername: "johndoe",
                authorDisplayName: "John Doe",
                authorAvatarURL: "https://picsum.photos/200",
                authorIsVerified: true,
                content: "Just launched my new app! 🚀 It's been an amazing journey building this. Can't wait to see how it helps people connect and share their stories.",
                images: ["https://picsum.photos/400/300"],
                videoURL: nil,
                likesCount: 42,
                commentsCount: 8,
                sharesCount: 3,
                createdAt: Date().addingTimeInterval(-3600),
                updatedAt: Date().addingTimeInterval(-3600)
            ),
            Post(
                id: "2",
                authorId: "user2",
                authorUsername: "sarahsmith",
                authorDisplayName: "Sarah Smith",
                authorAvatarURL: "https://picsum.photos/201",
                authorIsVerified: false,
                content: "Beautiful sunset today! 🌅 Nature always finds a way to amaze us. What's your favorite time of day?",
                images: ["https://picsum.photos/400/301", "https://picsum.photos/400/302"],
                videoURL: nil,
                likesCount: 128,
                commentsCount: 15,
                sharesCount: 7,
                createdAt: Date().addingTimeInterval(-7200),
                updatedAt: Date().addingTimeInterval(-7200)
            ),
            Post(
                id: "3",
                authorId: "user3",
                authorUsername: "mikejohnson",
                authorDisplayName: "Mike Johnson",
                authorAvatarURL: "https://picsum.photos/202",
                authorIsVerified: true,
                content: "Just finished reading an incredible book about AI and the future of technology. The insights are mind-blowing! 📚🤖",
                images: nil,
                videoURL: nil,
                likesCount: 89,
                commentsCount: 12,
                sharesCount: 5,
                createdAt: Date().addingTimeInterval(-10800),
                updatedAt: Date().addingTimeInterval(-10800)
            )
        ]
    }
}

// MARK: - Supporting Views
struct ExploreView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SearchBar(text: $searchText, placeholder: "Search creators, topics, or posts")
                        .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Trending Topics")
                            .font(.title3.weight(.bold))
                            .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(filteredTopics, id: \.self) { topic in
                                    Text("#\(topic)")
                                        .font(.subheadline.weight(.semibold))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .background(Color.blue.opacity(0.12))
                                        .clipShape(Capsule())
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Suggested Creators")
                            .font(.title3.weight(.bold))
                            .padding(.horizontal, 16)
                        
                        ForEach(filteredProfiles) { profile in
                            SuggestedProfileRow(profile: profile)
                                .padding(.horizontal, 16)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Discover Posts")
                            .font(.title3.weight(.bold))
                            .padding(.horizontal, 16)
                        
                        ForEach(filteredPosts) { post in
                            PostCard(post: post)
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Explore")
        }
    }
    
    private var filteredTopics: [String] {
        if searchText.isEmpty {
            return dataManager.trendingTopics
        }
        return dataManager.trendingTopics.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    private var filteredProfiles: [SuggestedProfile] {
        if searchText.isEmpty {
            return dataManager.suggestedProfiles
        }
        return dataManager.suggestedProfiles.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
            $0.username.localizedCaseInsensitiveContains(searchText) ||
            $0.bio.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var filteredPosts: [Post] {
        if searchText.isEmpty {
            return dataManager.posts
        }
        return dataManager.posts.filter {
            $0.content.localizedCaseInsensitiveContains(searchText) ||
            $0.authorDisplayName.localizedCaseInsensitiveContains(searchText) ||
            $0.authorUsername.localizedCaseInsensitiveContains(searchText)
        }
        .prefix(3)
        .map { $0 }
    }
}

struct SuggestedProfileRow: View {
    let profile: SuggestedProfile
    @StateObject private var dataManager = DataManager.shared
    
    private var isFollowing: Bool {
        dataManager.followedProfileIDs.contains(profile.id)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: profile.avatarURL ?? "")) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
            .frame(width: 52, height: 52)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(profile.displayName)
                        .font(.headline)
                    if profile.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
                Text("@\(profile.username)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(profile.bio)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button(isFollowing ? "Following" : "Follow") {
                dataManager.toggleFollow(profileID: profile.id)
            }
            .font(.subheadline.weight(.semibold))
            .foregroundColor(isFollowing ? .blue : .white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isFollowing ? Color.blue.opacity(0.12) : Color.blue)
            .clipShape(Capsule())
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = DataManager.shared
    @State private var caption = ""
    @State private var selectedAudience = "Public"
    @State private var attachedMedia = ["launch-plan.png", "workspace-shot.mov"]
    @State private var isPublishing = false
    @State private var publishMessage: String?
    
    private let audienceOptions = ["Public", "Close Friends", "Team"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Caption") {
                    TextEditor(text: $caption)
                        .frame(minHeight: 140)
                    Text("\(caption.count)/280")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section("Audience") {
                    Picker("Audience", selection: $selectedAudience) {
                        ForEach(audienceOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Attached Media") {
                    ForEach(attachedMedia, id: \.self) { asset in
                        Label(asset, systemImage: asset.hasSuffix(".mov") ? "video" : "photo")
                    }
                    Button("Add another attachment") {
                        attachedMedia.append("idea-board-\(attachedMedia.count + 1).png")
                    }
                }
                
                Section("Publishing Checklist") {
                    ChecklistRow(title: "Hook in first line", isDone: !caption.isEmpty)
                    ChecklistRow(title: "At least one attachment", isDone: !attachedMedia.isEmpty)
                    ChecklistRow(title: "Clear audience selected", isDone: !selectedAudience.isEmpty)
                }
                
                if let publishMessage {
                    Section {
                        Text(publishMessage)
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("Create Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isPublishing ? "Publishing..." : "Publish") {
                        publishPost()
                    }
                    .disabled(caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isPublishing)
                }
            }
            .onAppear {
                if caption.isEmpty {
                    caption = "Shipping a sharper runtime proof system today. The goal is simple: less template theater, more product truth."
                }
            }
        }
    }
    
    private func publishPost() {
        isPublishing = true
        let trimmedCaption = caption.trimmingCharacters(in: .whitespacesAndNewlines)
        Task {
            try? await Task.sleep(for: .milliseconds(250))
            await MainActor.run {
                dataManager.publishPost(
                    content: trimmedCaption,
                    authorName: "Preview User",
                    username: "preview",
                    isVerified: true,
                    audience: selectedAudience,
                    attachmentCount: attachedMedia.count
                )
                publishMessage = "Post published to the feed."
                isPublishing = false
            }
        }
    }
}

struct NotificationsView: View {
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some View {
        NavigationView {
            List {
                Section("Unread") {
                    ForEach(notificationManager.notifications.filter(\.isUnread)) { notification in
                        NotificationRow(notification: notification)
                    }
                }
                
                Section("Earlier") {
                    ForEach(notificationManager.notifications.filter { !$0.isUnread }) { notification in
                        NotificationRow(notification: notification)
                    }
                }
            }
            .navigationTitle("Notifications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Mark All Read") {
                        notificationManager.markAllRead()
                    }
                    .disabled(notificationManager.notifications.allSatisfy { !$0.isUnread })
                }
            }
        }
    }
}

struct ProfileView: View {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let user = authManager.currentUser {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(user.displayName)
                                    .font(.title2.weight(.bold))
                                if user.isVerified {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            Text("@\(user.username)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(user.bio ?? "No bio yet.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.blue.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                            SocialMetricCard(title: "Followers", value: "\(user.followersCount)")
                            SocialMetricCard(title: "Following", value: "\(user.followingCount)")
                            SocialMetricCard(title: "Posts", value: "\(dataManager.profilePosts(for: user.username).count)")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Posts")
                            .font(.headline)
                        ForEach(dataManager.profilePosts(for: authManager.currentUser?.username ?? "preview").prefix(3)) { post in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(post.content)
                                    .font(.subheadline)
                                    .lineLimit(3)
                                HStack {
                                    Label("\(post.likesCount)", systemImage: "heart")
                                    Label("\(post.commentsCount)", systemImage: "bubble.left")
                                    Spacer()
                                    Text(post.createdAt, style: .relative)
                                }
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Creator Tools")
                            .font(.headline)
                        ProfileActionRow(title: "Draft queue", subtitle: "2 posts waiting for publish review", icon: "square.and.pencil")
                        ProfileActionRow(title: "Audience insights", subtitle: "Best posting time: 7:30 PM", icon: "chart.bar")
                        ProfileActionRow(title: "Monetization", subtitle: "Brand kit linked and ready", icon: "dollarsign.circle")
                    }
                }
                .padding(16)
            }
            .navigationTitle("Profile")
        }
    }
}

struct CommentsView: View {
    let post: Post
    @StateObject private var dataManager = DataManager.shared
    @State private var commentDraft = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    Section("Thread") {
                        ForEach(dataManager.comments(for: post.id)) { comment in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(comment.authorName)
                                        .font(.headline)
                                    Text("@\(comment.authorUsername)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(comment.createdAt, style: .relative)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Text(comment.body)
                                    .font(.subheadline)
                                Label("\(comment.likesCount)", systemImage: "heart")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                HStack(spacing: 12) {
                    TextField("Add a comment", text: $commentDraft)
                        .textFieldStyle(.roundedBorder)
                    Button("Send") {
                        dataManager.addComment(body: commentDraft, to: post.id)
                        commentDraft = ""
                    }
                    .disabled(commentDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .navigationTitle("Comments")
        }
    }
}

struct NotificationRow: View {
    let notification: SocialNotificationItem
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: notification.systemImage)
                .foregroundColor(notification.isUnread ? .blue : .secondary)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.actorName)
                    .font(.subheadline.weight(.semibold))
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(notification.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if notification.isUnread {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
                    .padding(.top, 8)
            }
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture {
            notificationManager.markRead(notification.id)
        }
    }
}

struct SocialMetricCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title3.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct ChecklistRow: View {
    let title: String
    let isDone: Bool
    
    var body: some View {
        Label(title, systemImage: isDone ? "checkmark.circle.fill" : "circle")
            .foregroundColor(isDone ? .green : .secondary)
    }
}

struct ProfileActionRow: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}

// MARK: - Custom Components
struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String?
    let validation: TextFieldValidation
    let isSecure: Bool
    
    init(
        text: Binding<String>,
        placeholder: String,
        icon: String? = nil,
        validation: TextFieldValidation = .none,
        isSecure: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.validation = validation
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                }
                
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

enum TextFieldValidation {
    case none
    case email
    case password
    case username
}

struct PrimaryButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .disabled(isLoading)
    }
}

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Managers
@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private init() {}
    
    func checkAuthState() async {
        // Check Firebase auth state
        if let user = Auth.auth().currentUser {
            await MainActor.run {
                self.isAuthenticated = true
                // Load user data
            }
        }
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        await MainActor.run {
            self.isAuthenticated = true
            // Load user data
        }
    }
    
    func signUp(username: String, email: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        await MainActor.run {
            self.isAuthenticated = true
            // Create user profile
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        isAuthenticated = false
        currentUser = nil
    }
}

@MainActor
class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var posts: [Post] = []
    @Published var trendingTopics: [String] = []
    @Published var suggestedProfiles: [SuggestedProfile] = []
    @Published var commentsByPostId: [String: [PostComment]] = [:]
    @Published var likedPostIDs: Set<String> = []
    @Published var bookmarkedPostIDs: Set<String> = []
    @Published var followedProfileIDs: Set<String> = []
    
    private init() {}
    
    func initialize() async {
        if posts.isEmpty {
            seedPreviewState(currentUser: nil)
        }
    }
    
    func refreshFeed() async {
        try? await Task.sleep(for: .milliseconds(250))
        if posts.isEmpty {
            seedPreviewState(currentUser: nil)
        }
    }
    
    func addPost(content: String, authorName: String, username: String, isVerified: Bool) {
        let post = Post(
            id: UUID().uuidString,
            authorId: "current-user",
            authorUsername: username,
            authorDisplayName: authorName,
            authorAvatarURL: "https://picsum.photos/210",
            authorIsVerified: isVerified,
            content: content,
            images: ["https://picsum.photos/410/310"],
            videoURL: nil,
            likesCount: 0,
            commentsCount: 0,
            sharesCount: 0,
            createdAt: Date(),
            updatedAt: Date()
        )
        posts.insert(post, at: 0)
        commentsByPostId[post.id] = []
    }
    
    func publishPost(
        content: String,
        authorName: String,
        username: String,
        isVerified: Bool,
        audience: String,
        attachmentCount: Int
    ) {
        let decoratedContent = "[\(audience)] \(content)\n\nAttached assets: \(attachmentCount)"
        addPost(content: decoratedContent, authorName: authorName, username: username, isVerified: isVerified)
    }
    
    func profilePosts(for username: String) -> [Post] {
        posts.filter { $0.authorUsername == username }
    }
    
    func comments(for postId: String) -> [PostComment] {
        commentsByPostId[postId] ?? []
    }
    
    func addComment(body: String, to postId: String) {
        let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let comment = PostComment(
            id: UUID().uuidString,
            authorName: "Preview User",
            authorUsername: "preview",
            body: trimmed,
            likesCount: 0,
            createdAt: Date()
        )
        commentsByPostId[postId, default: []].append(comment)
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].commentsCount += 1
        }
    }
    
    func toggleLike(postID: String) {
        guard let index = posts.firstIndex(where: { $0.id == postID }) else { return }
        if likedPostIDs.contains(postID) {
            likedPostIDs.remove(postID)
            posts[index].likesCount = max(0, posts[index].likesCount - 1)
        } else {
            likedPostIDs.insert(postID)
            posts[index].likesCount += 1
        }
    }
    
    func toggleBookmark(postID: String) {
        if bookmarkedPostIDs.contains(postID) {
            bookmarkedPostIDs.remove(postID)
        } else {
            bookmarkedPostIDs.insert(postID)
        }
    }
    
    func sharePost(postID: String) {
        guard let index = posts.firstIndex(where: { $0.id == postID }) else { return }
        posts[index].sharesCount += 1
    }
    
    func toggleFollow(profileID: String) {
        guard let index = suggestedProfiles.firstIndex(where: { $0.id == profileID }) else { return }
        if followedProfileIDs.contains(profileID) {
            followedProfileIDs.remove(profileID)
            suggestedProfiles[index].followersCount = max(0, suggestedProfiles[index].followersCount - 1)
        } else {
            followedProfileIDs.insert(profileID)
            suggestedProfiles[index].followersCount += 1
        }
    }
    
    func seedPreviewState(currentUser: User?) {
        posts = [
            Post(
                id: "1",
                authorId: "user1",
                authorUsername: "johndoe",
                authorDisplayName: "John Doe",
                authorAvatarURL: "https://picsum.photos/200",
                authorIsVerified: true,
                content: "Just launched my new app! 🚀 It's been an amazing journey building this. Can't wait to see how it helps people connect and share their stories.",
                images: ["https://picsum.photos/400/300"],
                videoURL: nil,
                likesCount: 42,
                commentsCount: 8,
                sharesCount: 3,
                createdAt: Date().addingTimeInterval(-3600),
                updatedAt: Date().addingTimeInterval(-3600)
            ),
            Post(
                id: "2",
                authorId: "user2",
                authorUsername: "sarahsmith",
                authorDisplayName: "Sarah Smith",
                authorAvatarURL: "https://picsum.photos/201",
                authorIsVerified: false,
                content: "Beautiful sunset today! 🌅 Nature always finds a way to amaze us. What's your favorite time of day?",
                images: ["https://picsum.photos/400/301", "https://picsum.photos/400/302"],
                videoURL: nil,
                likesCount: 128,
                commentsCount: 15,
                sharesCount: 7,
                createdAt: Date().addingTimeInterval(-7200),
                updatedAt: Date().addingTimeInterval(-7200)
            ),
            Post(
                id: "3",
                authorId: "user3",
                authorUsername: "mikejohnson",
                authorDisplayName: "Mike Johnson",
                authorAvatarURL: "https://picsum.photos/202",
                authorIsVerified: true,
                content: "Just finished reading an incredible book about AI and the future of technology. The insights are mind-blowing! 📚🤖",
                images: nil,
                videoURL: nil,
                likesCount: 89,
                commentsCount: 12,
                sharesCount: 5,
                createdAt: Date().addingTimeInterval(-10800),
                updatedAt: Date().addingTimeInterval(-10800)
            )
        ]
        
        if let currentUser {
            posts.insert(
                Post(
                    id: "preview-post",
                    authorId: currentUser.id,
                    authorUsername: currentUser.username,
                    authorDisplayName: currentUser.displayName,
                    authorAvatarURL: currentUser.avatarURL,
                    authorIsVerified: currentUser.isVerified,
                    content: "Proof should reflect product reality. Shipping deeper runtime flows next.",
                    images: ["https://picsum.photos/411/311"],
                    videoURL: nil,
                    likesCount: 64,
                    commentsCount: 9,
                    sharesCount: 4,
                    createdAt: Date().addingTimeInterval(-1800),
                    updatedAt: Date().addingTimeInterval(-1800)
                ),
                at: 0
            )
        }
        
        trendingTopics = [
            "BuildInPublic", "SwiftUI", "iOSDesign", "ProductStrategy", "AIWorkflows", "CreatorTools"
        ]
        
        suggestedProfiles = [
            SuggestedProfile(
                id: "p1",
                username: "amberdesign",
                displayName: "Amber Design",
                bio: "Mobile product designer sharing systems, motion, and interface teardown threads.",
                avatarURL: "https://picsum.photos/220",
                isVerified: true,
                followersCount: 12800
            ),
            SuggestedProfile(
                id: "p2",
                username: "swiftfoundry",
                displayName: "Swift Foundry",
                bio: "Weekly SwiftUI experiments, architecture notes, and native product case studies.",
                avatarURL: "https://picsum.photos/221",
                isVerified: false,
                followersCount: 7400
            ),
            SuggestedProfile(
                id: "p3",
                username: "opsforapps",
                displayName: "Ops For Apps",
                bio: "Shipping notes on release hygiene, runtime proof, and product operations.",
                avatarURL: "https://picsum.photos/222",
                isVerified: true,
                followersCount: 18300
            )
        ]
        
        commentsByPostId = [
            "1": [
                PostComment(id: "c1", authorName: "Nina", authorUsername: "ninabuilds", body: "The onboarding flow looks much sharper now.", likesCount: 12, createdAt: Date().addingTimeInterval(-2500)),
                PostComment(id: "c2", authorName: "Leo", authorUsername: "leoproduct", body: "Would love to see the second screen interaction too.", likesCount: 6, createdAt: Date().addingTimeInterval(-1800))
            ],
            "2": [
                PostComment(id: "c3", authorName: "Maya", authorUsername: "mayastudio", body: "That color palette is unreal.", likesCount: 18, createdAt: Date().addingTimeInterval(-6000))
            ],
            "3": [
                PostComment(id: "c4", authorName: "Aria", authorUsername: "ariareads", body: "Drop the reading list when you can.", likesCount: 4, createdAt: Date().addingTimeInterval(-9000))
            ],
            "preview-post": [
                PostComment(id: "c5", authorName: "Sam", authorUsername: "samship", body: "Good. Proof without flows is still theater.", likesCount: 10, createdAt: Date().addingTimeInterval(-1200))
            ]
        ]
        likedPostIDs = ["2"]
        bookmarkedPostIDs = ["preview-post"]
        followedProfileIDs = ["p1"]
    }
}

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var notifications: [SocialNotificationItem] = []
    
    private init() {}
    
    func requestPermission() async {
        if notifications.isEmpty {
            seedPreviewState()
        }
    }
    
    func seedPreviewState() {
        notifications = [
            SocialNotificationItem(id: "n1", actorName: "Amber Design", message: "liked your runtime proof update.", systemImage: "heart.fill", isUnread: true, createdAt: Date().addingTimeInterval(-900)),
            SocialNotificationItem(id: "n2", actorName: "Swift Foundry", message: "mentioned you in a thread about app templates.", systemImage: "at", isUnread: true, createdAt: Date().addingTimeInterval(-2400)),
            SocialNotificationItem(id: "n3", actorName: "Ops For Apps", message: "shared your post with their release engineering circle.", systemImage: "arrowshape.turn.up.right.fill", isUnread: false, createdAt: Date().addingTimeInterval(-7200)),
            SocialNotificationItem(id: "n4", actorName: "Maya Studio", message: "started following you.", systemImage: "person.badge.plus", isUnread: false, createdAt: Date().addingTimeInterval(-14400))
        ]
    }
    
    func markRead(_ notificationID: String) {
        guard let index = notifications.firstIndex(where: { $0.id == notificationID }) else { return }
        notifications[index].isUnread = false
    }
    
    func markAllRead() {
        for index in notifications.indices {
            notifications[index].isUnread = false
        }
    }
}

struct User: Identifiable, Codable {
    let id: String
    let username: String
    let email: String
    let displayName: String
    let avatarURL: String?
    let bio: String?
    let followersCount: Int
    let followingCount: Int
    let postsCount: Int
    let isVerified: Bool
    let createdAt: Date
    let lastActiveAt: Date
} 
