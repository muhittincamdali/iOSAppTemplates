import SwiftUI
import Firebase

// MARK: - Basic Example App
@main
struct BasicExampleApp: App {
    
    init() {
        setupFirebase()
        setupAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthManager.shared)
                .environmentObject(DataManager.shared)
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
    }
}

// MARK: - Content View
struct ContentView: View {
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: authManager.isAuthenticated)
    }
}

// MARK: - Main View
struct MainView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
        }
        .accentColor(.primary)
    }
}

// MARK: - Login View
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "app.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.primary)
                    
                    Text("Welcome")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Sign in to continue")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)
                
                // Form
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
                .padding(.horizontal, 20)
                
                // Login Button
                PrimaryButton(
                    title: "Sign In",
                    isLoading: isLoading
                ) {
                    signIn()
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Sign Up Link
                HStack {
                    Text("Don't have an account?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button("Sign Up") {
                        // Handle sign up
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
                .padding(.bottom, 40)
            }
            .navigationBarHidden(true)
            .alert("Login Error", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
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
                try await AuthManager.shared.signIn(email: email, password: password)
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

// MARK: - Home View
struct HomeView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Search Bar
                    SearchBar(text: $searchText, placeholder: "Search items...")
                        .padding(.horizontal, 16)
                    
                    // Content
                    ForEach(dataManager.items) { item in
                        ItemCard(item: item)
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Home")
            .refreshable {
                await dataManager.fetchItems()
            }
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @StateObject private var authManager = AuthManager.shared
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
                            Text("\(userManager.currentUser?.itemsCount ?? 0)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Items")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("\(userManager.currentUser?.favoritesCount ?? 0)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Favorites")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    
                    // Actions
                    VStack(spacing: 0) {
                        SettingsRowView(
                            icon: "person",
                            title: "Edit Profile",
                            accessory: .chevron
                        ) {
                            // Handle edit profile
                        }
                        
                        SettingsRowView(
                            icon: "heart",
                            title: "Favorites",
                            accessory: .chevron
                        ) {
                            // Handle favorites
                        }
                        
                        SettingsRowView(
                            icon: "rectangle.portrait.and.arrow.right",
                            title: "Sign Out",
                            accessory: .none
                        ) {
                            authManager.signOut()
                        }
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

// MARK: - Settings View
struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var autoSyncEnabled = true
    
    var body: some View {
        NavigationView {
            List {
                Section("Preferences") {
                    CustomToggle(
                        isOn: $notificationsEnabled,
                        title: "Notifications",
                        subtitle: "Receive push notifications",
                        icon: "bell"
                    )
                    
                    CustomToggle(
                        isOn: $darkModeEnabled,
                        title: "Dark Mode",
                        subtitle: "Use dark appearance",
                        icon: "moon"
                    )
                    
                    CustomToggle(
                        isOn: $autoSyncEnabled,
                        title: "Auto Sync",
                        subtitle: "Automatically sync data",
                        icon: "arrow.triangle.2.circlepath"
                    )
                }
                
                Section("Support") {
                    SettingsRowView(
                        icon: "questionmark.circle",
                        title: "Help & Support",
                        accessory: .chevron
                    ) {
                        // Handle help
                    }
                    
                    SettingsRowView(
                        icon: "doc.text",
                        title: "Privacy Policy",
                        accessory: .chevron
                    ) {
                        // Handle privacy policy
                    }
                    
                    SettingsRowView(
                        icon: "doc.text",
                        title: "Terms of Service",
                        accessory: .chevron
                    ) {
                        // Handle terms
                    }
                }
                
                Section("About") {
                    SettingsRowView(
                        icon: "info.circle",
                        title: "Version",
                        subtitle: "1.0.0",
                        accessory: .none
                    ) {
                        // Handle version info
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Supporting Views
struct ItemCard: View {
    let item: Item
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: item.icon)
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(item.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle favorite
                    }) {
                        Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(item.isFavorite ? .red : .gray)
                    }
                }
                
                HStack {
                    Text(item.category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Text(item.date, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Models
struct Item: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let category: String
    let date: Date
    let isFavorite: Bool
}

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let itemsCount: Int
    let favoritesCount: Int
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
        currentUser = User(id: "1", name: "John Doe", email: email, itemsCount: 15, favoritesCount: 8)
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
    }
}

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var items: [Item] = []
    
    private init() {
        loadMockData()
    }
    
    func fetchItems() async {
        // Fetch items from API
        // This is a mock implementation
    }
    
    private func loadMockData() {
        items = [
            Item(id: "1", title: "First Item", description: "This is the first item description", icon: "star.fill", category: "Featured", date: Date(), isFavorite: true),
            Item(id: "2", title: "Second Item", description: "This is the second item description", icon: "heart.fill", category: "Popular", date: Date().addingTimeInterval(-3600), isFavorite: false),
            Item(id: "3", title: "Third Item", description: "This is the third item description", icon: "bookmark.fill", category: "Recent", date: Date().addingTimeInterval(-7200), isFavorite: true)
        ]
    }
}

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var currentUser: User?
    
    private init() {
        // Mock user data
        currentUser = User(id: "1", name: "John Doe", email: "john@example.com", itemsCount: 15, favoritesCount: 8)
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
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct Card<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String?
    let accessory: RowAccessory
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        accessory: RowAccessory = .none,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.accessory = accessory
        self.action = action
    }
    
    var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                accessoryView
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var accessoryView: some View {
        switch accessory {
        case .none:
            EmptyView()
        case .chevron:
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        case .switch:
            Toggle("", isOn: .constant(true))
                .labelsHidden()
        case .badge(let text):
            Text(text)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.red)
                .clipShape(Capsule())
        case .custom(let view):
            view
        }
    }
}

enum RowAccessory {
    case none
    case chevron
    case `switch`
    case badge(String)
    case custom(AnyView)
} 