import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Kingfisher
import Stripe

// MARK: - E-commerce App
@main
struct EcommerceApp: App {
    
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var cartManager = CartManager.shared
    @StateObject private var productManager = ProductManager.shared
    @StateObject private var orderManager = OrderManager.shared
    
    init() {
        setupFirebase()
        setupStripe()
        setupAppearance()
        setupAnalytics()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(cartManager)
                .environmentObject(productManager)
                .environmentObject(orderManager)
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
    
    private func setupStripe() {
        StripeAPI.defaultPublishableKey = "pk_test_your_stripe_key"
        print("💳 Stripe configured successfully")
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
            await productManager.loadProducts()
            await cartManager.loadCart()
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
                colors: [Color.orange.opacity(0.8), Color.red.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // App logo
                Image(systemName: "bag.fill")
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
                Text("ShopConnect")
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
                Text("Discover amazing products")
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
                        .foregroundColor(.orange)
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
            Image(systemName: "bag.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            // Title
            Text("Welcome to ShopConnect")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // Subtitle
            Text("Shop, discover, and save on amazing products")
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
            .foregroundColor(.orange)
            
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
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            CategoriesView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Categories")
                }
                .tag(1)
            
            CartView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
                .tag(2)
            
            OrdersView()
                .tabItem {
                    Image(systemName: "bag")
                    Text("Orders")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.orange)
    }
}

// MARK: - Home View
struct HomeView: View {
    @StateObject private var productManager = ProductManager.shared
    @State private var searchText = ""
    @State private var selectedCategory: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Search bar
                    SearchBar(text: $searchText, placeholder: "Search products...")
                        .padding(.horizontal, 16)
                    
                    // Featured products
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Featured Products")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 16) {
                                ForEach(productManager.featuredProducts) { product in
                                    FeaturedProductCard(product: product)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    // Categories
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Categories")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 16)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            ForEach(productManager.categories, id: \.self) { category in
                                CategoryCard(category: category)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Recent products
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Products")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 16)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            ForEach(productManager.recentProducts) { product in
                                ProductCard(product: product)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("ShopConnect")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await productManager.refreshProducts()
            }
        }
    }
}

// MARK: - Product Card
struct ProductCard: View {
    let product: Product
    @StateObject private var cartManager = CartManager.shared
    @State private var isFavorite = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Product image
            AsyncImage(url: URL(string: product.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Product info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(product.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("$\(String(format: "%.2f", product.price))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isFavorite.toggle()
                        }
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .gray)
                    }
                }
                
                // Add to cart button
                Button(action: {
                    cartManager.addToCart(product: product)
                }) {
                    Text("Add to Cart")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(Color.orange)
                        .cornerRadius(8)
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Featured Product Card
struct FeaturedProductCard: View {
    let product: Product
    @StateObject private var cartManager = CartManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Product image
            AsyncImage(url: URL(string: product.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 200, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Product info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
        }
        .frame(width: 200)
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: String
    
    var body: some View {
        VStack {
            Image(systemName: categoryIcon)
                .font(.system(size: 40))
                .foregroundColor(.orange)
            
            Text(category)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var categoryIcon: String {
        switch category.lowercased() {
        case "electronics": return "laptopcomputer"
        case "clothing": return "tshirt"
        case "books": return "book"
        case "sports": return "sportscourt"
        case "home": return "house"
        case "beauty": return "sparkles"
        default: return "cube"
        }
    }
}

// MARK: - Models
struct Product: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let originalPrice: Double?
    let imageURL: String
    let category: String
    let brand: String
    let rating: Double
    let reviewCount: Int
    let stockQuantity: Int
    let isFeatured: Bool
    let isOnSale: Bool
    let salePercentage: Int?
    let tags: [String]
    let createdAt: Date
    let updatedAt: Date
}

// MARK: - View Models
class ProductManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var featuredProducts: [Product] = []
    @Published var recentProducts: [Product] = []
    @Published var categories: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        loadMockData()
    }
    
    func loadProducts() async {
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
    
    func refreshProducts() async {
        await loadProducts()
    }
    
    private func loadMockData() {
        products = [
            Product(
                id: "1",
                name: "Wireless Bluetooth Headphones",
                description: "High-quality wireless headphones with noise cancellation",
                price: 99.99,
                originalPrice: 129.99,
                imageURL: "https://picsum.photos/300/300",
                category: "Electronics",
                brand: "TechBrand",
                rating: 4.5,
                reviewCount: 128,
                stockQuantity: 50,
                isFeatured: true,
                isOnSale: true,
                salePercentage: 23,
                tags: ["wireless", "bluetooth", "noise-cancellation"],
                createdAt: Date(),
                updatedAt: Date()
            ),
            Product(
                id: "2",
                name: "Premium Cotton T-Shirt",
                description: "Comfortable and stylish cotton t-shirt",
                price: 29.99,
                originalPrice: nil,
                imageURL: "https://picsum.photos/301/301",
                category: "Clothing",
                brand: "FashionBrand",
                rating: 4.2,
                reviewCount: 89,
                stockQuantity: 100,
                isFeatured: false,
                isOnSale: false,
                salePercentage: nil,
                tags: ["cotton", "comfortable", "stylish"],
                createdAt: Date(),
                updatedAt: Date()
            ),
            Product(
                id: "3",
                name: "Smart Fitness Watch",
                description: "Advanced fitness tracking with heart rate monitor",
                price: 199.99,
                originalPrice: 249.99,
                imageURL: "https://picsum.photos/302/302",
                category: "Electronics",
                brand: "FitTech",
                rating: 4.7,
                reviewCount: 256,
                stockQuantity: 25,
                isFeatured: true,
                isOnSale: true,
                salePercentage: 20,
                tags: ["fitness", "smartwatch", "heart-rate"],
                createdAt: Date(),
                updatedAt: Date()
            )
        ]
        
        featuredProducts = products.filter { $0.isFeatured }
        recentProducts = Array(products.prefix(6))
        categories = ["Electronics", "Clothing", "Books", "Sports", "Home", "Beauty"]
    }
}

// MARK: - Supporting Views
struct CategoriesView: View {
    var body: some View {
        NavigationView {
            Text("Categories View")
                .navigationTitle("Categories")
        }
    }
}

struct CartView: View {
    var body: some View {
        NavigationView {
            Text("Cart View")
                .navigationTitle("Cart")
        }
    }
}

struct OrdersView: View {
    var body: some View {
        NavigationView {
            Text("Orders View")
                .navigationTitle("Orders")
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
            .background(Color.orange)
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

// MARK: - Managers
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

class CartManager: ObservableObject {
    static let shared = CartManager()
    
    @Published var cartItems: [CartItem] = []
    @Published var totalAmount: Double = 0.0
    
    private init() {}
    
    func loadCart() async {
        // Load cart from local storage or API
    }
    
    func addToCart(product: Product) {
        if let existingItem = cartItems.first(where: { $0.product.id == product.id }) {
            existingItem.quantity += 1
        } else {
            cartItems.append(CartItem(product: product, quantity: 1))
        }
        calculateTotal()
    }
    
    func removeFromCart(productId: String) {
        cartItems.removeAll { $0.product.id == productId }
        calculateTotal()
    }
    
    func updateQuantity(productId: String, quantity: Int) {
        if let item = cartItems.first(where: { $0.product.id == productId }) {
            item.quantity = quantity
            if quantity <= 0 {
                removeFromCart(productId: productId)
            }
        }
        calculateTotal()
    }
    
    private func calculateTotal() {
        totalAmount = cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
}

class OrderManager: ObservableObject {
    static let shared = OrderManager()
    
    @Published var orders: [Order] = []
    
    private init() {}
}

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
}

struct Order: Identifiable, Codable {
    let id: String
    let userId: String
    let items: [OrderItem]
    let totalAmount: Double
    let status: OrderStatus
    let createdAt: Date
    let updatedAt: Date
}

struct OrderItem: Identifiable, Codable {
    let id: String
    let productId: String
    let productName: String
    let quantity: Int
    let price: Double
}

enum OrderStatus: String, Codable {
    case pending = "pending"
    case confirmed = "confirmed"
    case shipped = "shipped"
    case delivered = "delivered"
    case cancelled = "cancelled"
}

struct User: Identifiable, Codable {
    let id: String
    let username: String
    let email: String
    let displayName: String
    let avatarURL: String?
    let address: Address?
    let phoneNumber: String?
    let createdAt: Date
    let updatedAt: Date
}

struct Address: Codable {
    let street: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
} 