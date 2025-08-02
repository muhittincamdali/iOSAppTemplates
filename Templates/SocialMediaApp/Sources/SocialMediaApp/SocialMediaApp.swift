import SwiftUI
import Firebase

// MARK: - Social Media App
@main
struct SocialMediaApp: App {
    
    init() {
        setupFirebase()
        setupAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthManager.shared)
                .environmentObject(PostManager.shared)
                .environmentObject(UserManager.shared)
        }
    }
    
    // MARK: - Setup Methods
    private func setupFirebase() {
        FirebaseApp.configure()
    }
    
    private func setupAppearance() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

// MARK: - Content View
struct ContentView: View {
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView()
            } else {
                AuthenticationView()
            }
        }
        .animation(.easeInOut, value: authManager.isAuthenticated)
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
        .accentColor(.primary)
    }
}

// MARK: - Authentication View
struct AuthenticationView: View {
    @State private var isSignUp = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // App Logo
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.primary)
                    .padding(.top, 60)
                
                Text("Social Media App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Connect with friends and share your moments")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                // Authentication Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        isSignUp = false
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        isSignUp = true
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .sheet(isPresented: $isSignUp) {
                SignUpView()
            }
        }
    }
}

// MARK: - Feed View
struct FeedView: View {
    @StateObject private var postManager = PostManager.shared
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(postManager.posts) { post in
                        PostCard(post: post)
                    }
                }
                .padding()
            }
            .navigationTitle("Feed")
            .refreshable {
                await loadPosts()
            }
            .onAppear {
                Task {
                    await loadPosts()
                }
            }
        }
    }
    
    private func loadPosts() async {
        isLoading = true
        await postManager.fetchPosts()
        isLoading = false
    }
}

// MARK: - Explore View
struct ExploreView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                    ForEach(0..<30) { index in
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(1, contentMode: .fit)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("Explore")
            .searchable(text: $searchText, prompt: "Search posts...")
        }
    }
}

// MARK: - Create Post View
struct CreatePostView: View {
    @State private var postText = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $postText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding()
                }
                
                HStack {
                    Button("Add Photo") {
                        showingImagePicker = true
                    }
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Button("Post") {
                        // Handle post creation
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Create Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}

// MARK: - Notifications View
struct NotificationsView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<10) { index in
                    NotificationRow(
                        title: "New like",
                        message: "Someone liked your post",
                        time: "2 hours ago"
                    )
                }
            }
            .navigationTitle("Notifications")
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @StateObject private var userManager = UserManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.primary)
                        
                        Text(userManager.currentUser?.name ?? "User")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(userManager.currentUser?.email ?? "user@example.com")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Stats
                    HStack(spacing: 40) {
                        VStack {
                            Text("\(userManager.currentUser?.postsCount ?? 0)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Posts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("\(userManager.currentUser?.followersCount ?? 0)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Followers")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("\(userManager.currentUser?.followingCount ?? 0)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Following")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    
                    // Settings
                    VStack(spacing: 0) {
                        SettingsRow(title: "Edit Profile", icon: "person")
                        SettingsRow(title: "Privacy", icon: "lock")
                        SettingsRow(title: "Notifications", icon: "bell")
                        SettingsRow(title: "Help", icon: "questionmark.circle")
                        SettingsRow(title: "Logout", icon: "rectangle.portrait.and.arrow.right")
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

// MARK: - Supporting Views
struct PostCard: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // User info
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                VStack(alignment: .leading) {
                    Text(post.authorName)
                        .font(.headline)
                    Text(post.timestamp, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            
            // Post content
            Text(post.content)
                .font(.body)
            
            // Post image if available
            if let imageURL = post.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(16/9, contentMode: .fit)
                }
                .cornerRadius(8)
            }
            
            // Action buttons
            HStack(spacing: 20) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "heart")
                        Text("\(post.likesCount)")
                    }
                    .foregroundColor(.red)
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "bubble.left")
                        Text("\(post.commentsCount)")
                    }
                    .foregroundColor(.primary)
                }
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct NotificationRow: View {
    let title: String
    let message: String
    let time: String
    
    var body: some View {
        HStack {
            Image(systemName: "bell.fill")
                .foregroundColor(.blue)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.primary)
                .frame(width: 24)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Models
struct Post: Identifiable, Codable {
    let id: String
    let content: String
    let authorName: String
    let authorID: String
    let timestamp: Date
    let imageURL: URL?
    let likesCount: Int
    let commentsCount: Int
}

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let profileImageURL: URL?
    let postsCount: Int
    let followersCount: Int
    let followingCount: Int
}

// MARK: - Managers
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private init() {}
    
    func signIn(email: String, password: String) async throws {
        // Firebase authentication implementation
        isAuthenticated = true
    }
    
    func signUp(email: String, password: String, name: String) async throws {
        // Firebase authentication implementation
        isAuthenticated = true
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
    }
}

class PostManager: ObservableObject {
    static let shared = PostManager()
    
    @Published var posts: [Post] = []
    
    private init() {}
    
    func fetchPosts() async {
        // Fetch posts from Firebase
        // This is a mock implementation
        posts = [
            Post(id: "1", content: "Hello World! This is my first post.", authorName: "John Doe", authorID: "1", timestamp: Date(), imageURL: nil, likesCount: 5, commentsCount: 2),
            Post(id: "2", content: "Beautiful sunset today! 🌅", authorName: "Jane Smith", authorID: "2", timestamp: Date().addingTimeInterval(-3600), imageURL: nil, likesCount: 12, commentsCount: 3)
        ]
    }
}

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var currentUser: User?
    
    private init() {
        // Mock user data
        currentUser = User(id: "1", name: "John Doe", email: "john@example.com", profileImageURL: nil, postsCount: 15, followersCount: 234, followingCount: 123)
    }
} 