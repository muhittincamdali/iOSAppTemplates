import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Kingfisher

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
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
        print("📊 Analytics configured")
    }
    
    private func setupApp() {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
    @StateObject private var feedViewModel = FeedViewModel()
    @State private var showCreatePost = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(feedViewModel.posts) { post in
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
                await feedViewModel.refreshFeed()
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
    @State private var isLiked = false
    @State private var isBookmarked = false
    @State private var showComments = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                AsyncImage(url: URL(string: post.authorAvatarURL ?? "")) { image in
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
                        Text(post.authorDisplayName)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        if post.authorIsVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                                .font(.caption)
                        }
                    }
                    
                    Text("@\(post.authorUsername)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(post.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Content
            Text(post.content)
                .font(.body)
                .multilineTextAlignment(.leading)
            
            // Media
            if let images = post.images, !images.isEmpty {
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
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isLiked.toggle()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .primary)
                        Text("\(post.likesCount)")
                            .font(.caption)
                    }
                }
                
                Button(action: {
                    showComments = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.left")
                        Text("\(post.commentsCount)")
                            .font(.caption)
                    }
                }
                
                Button(action: {
                    // Handle share
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrowshape.turn.up.right")
                        Text("\(post.sharesCount)")
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isBookmarked.toggle()
                    }
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
            CommentsView(post: post)
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
    let content: String
    let images: [String]?
    let videoURL: String?
    let likesCount: Int
    let commentsCount: Int
    let sharesCount: Int
    let createdAt: Date
    let updatedAt: Date
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
    var body: some View {
        NavigationView {
            Text("Explore View")
                .navigationTitle("Explore")
        }
    }
}

struct CreatePostView: View {
    var body: some View {
        NavigationView {
            Text("Create Post View")
                .navigationTitle("Create Post")
        }
    }
}

struct NotificationsView: View {
    var body: some View {
        NavigationView {
            Text("Notifications View")
                .navigationTitle("Notifications")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            Text("Profile View")
                .navigationTitle("Profile")
        }
    }
}

struct CommentsView: View {
    let post: Post
    
    var body: some View {
        NavigationView {
            Text("Comments for post: \(post.id)")
                .navigationTitle("Comments")
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
    
    private init() {}
    
    func initialize() async {
        // Initialize data manager
    }
}

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() async {
        // Request notification permission
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
