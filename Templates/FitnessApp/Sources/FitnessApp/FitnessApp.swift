import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import HealthKit
import Charts

// MARK: - Fitness App
@main
struct FitnessApp: App {
    
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var workoutManager = WorkoutManager.shared
    @StateObject private var healthKitManager = HealthKitManager.shared
    @StateObject private var progressManager = ProgressManager.shared
    
    init() {
        setupFirebase()
        setupAppearance()
        setupAnalytics()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(workoutManager)
                .environmentObject(healthKitManager)
                .environmentObject(progressManager)
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
            await healthKitManager.requestAuthorization()
            await workoutManager.loadWorkouts()
            await progressManager.loadProgress()
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
                colors: [Color.green.opacity(0.8), Color.blue.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // App logo
                Image(systemName: "figure.run")
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
                Text("FitConnect")
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
                Text("Transform your fitness journey")
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
                        .foregroundColor(.green)
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
            Image(systemName: "figure.run")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            // Title
            Text("Welcome to FitConnect")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // Subtitle
            Text("Track, improve, and achieve your fitness goals")
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
            .foregroundColor(.green)
            
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
            DashboardView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Dashboard")
                }
                .tag(0)
            
            WorkoutsView()
                .tabItem {
                    Image(systemName: "figure.run")
                    Text("Workouts")
                }
                .tag(1)
            
            ProgressView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Progress")
                }
                .tag(2)
            
            GoalsView()
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.green)
    }
}

// MARK: - Dashboard View
struct DashboardView: View {
    @StateObject private var workoutManager = WorkoutManager.shared
    @StateObject private var progressManager = ProgressManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Today's summary
                    TodaySummaryCard()
                    
                    // Quick stats
                    QuickStatsGrid()
                    
                    // Recent workouts
                    RecentWorkoutsSection()
                    
                    // Weekly progress
                    WeeklyProgressSection()
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await workoutManager.refreshWorkouts()
                await progressManager.refreshProgress()
            }
        }
    }
}

// MARK: - Today Summary Card
struct TodaySummaryCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Summary")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: 20) {
                StatCard(
                    title: "Calories",
                    value: "1,250",
                    icon: "flame.fill",
                    color: .orange
                )
                
                StatCard(
                    title: "Steps",
                    value: "8,432",
                    icon: "figure.walk",
                    color: .blue
                )
                
                StatCard(
                    title: "Active Time",
                    value: "45m",
                    icon: "clock.fill",
                    color: .green
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Quick Stats Grid
struct QuickStatsGrid: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Stats")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, 16)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                QuickStatCard(
                    title: "Weekly Distance",
                    value: "12.5 km",
                    icon: "figure.run",
                    color: .green
                )
                
                QuickStatCard(
                    title: "Weekly Workouts",
                    value: "5",
                    icon: "dumbbell.fill",
                    color: .blue
                )
                
                QuickStatCard(
                    title: "Weekly Calories",
                    value: "8,750",
                    icon: "flame.fill",
                    color: .orange
                )
                
                QuickStatCard(
                    title: "Weekly Time",
                    value: "4h 30m",
                    icon: "clock.fill",
                    color: .purple
                )
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Quick Stat Card
struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Recent Workouts Section
struct RecentWorkoutsSection: View {
    @StateObject private var workoutManager = WorkoutManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Workouts")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(workoutManager.recentWorkouts) { workout in
                        WorkoutCard(workout: workout)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Workout Card
struct WorkoutCard: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Workout type icon
            Image(systemName: workoutTypeIcon)
                .font(.title2)
                .foregroundColor(workoutTypeColor)
            
            Text(workout.name)
                .font(.headline)
                .fontWeight(.semibold)
                .lineLimit(2)
            
            Text(workout.duration)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("\(workout.caloriesBurned) cal")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.orange)
        }
        .frame(width: 120)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var workoutTypeIcon: String {
        switch workout.type.lowercased() {
        case "running": return "figure.run"
        case "cycling": return "bicycle"
        case "swimming": return "figure.pool.swim"
        case "strength": return "dumbbell.fill"
        case "yoga": return "figure.mind.and.body"
        default: return "figure.run"
        }
    }
    
    private var workoutTypeColor: Color {
        switch workout.type.lowercased() {
        case "running": return .green
        case "cycling": return .blue
        case "swimming": return .cyan
        case "strength": return .orange
        case "yoga": return .purple
        default: return .green
        }
    }
}

// MARK: - Weekly Progress Section
struct WeeklyProgressSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weekly Progress")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, 16)
            
            WeeklyProgressChart()
                .frame(height: 200)
                .padding(.horizontal, 16)
        }
    }
}

// MARK: - Weekly Progress Chart
struct WeeklyProgressChart: View {
    let weeklyData = [
        ("Mon", 45),
        ("Tue", 60),
        ("Wed", 30),
        ("Thu", 75),
        ("Fri", 50),
        ("Sat", 90),
        ("Sun", 40)
    ]
    
    var body: some View {
        VStack {
            Chart {
                ForEach(Array(weeklyData.enumerated()), id: \.offset) { index, data in
                    BarMark(
                        x: .value("Day", data.0),
                        y: .value("Minutes", data.1)
                    )
                    .foregroundStyle(Color.green.gradient)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Models
struct Workout: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let duration: String
    let caloriesBurned: Int
    let distance: Double?
    let heartRate: Int?
    let date: Date
    let notes: String?
}

struct Goal: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let targetValue: Double
    let currentValue: Double
    let unit: String
    let deadline: Date?
    let isCompleted: Bool
    let createdAt: Date
}

// MARK: - View Models
class WorkoutManager: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var recentWorkouts: [Workout] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        loadMockData()
    }
    
    func loadWorkouts() async {
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
    
    func refreshWorkouts() async {
        await loadWorkouts()
    }
    
    private func loadMockData() {
        workouts = [
            Workout(
                id: "1",
                name: "Morning Run",
                type: "Running",
                duration: "45m",
                caloriesBurned: 450,
                distance: 5.2,
                heartRate: 145,
                date: Date().addingTimeInterval(-3600),
                notes: "Great morning run, felt energized"
            ),
            Workout(
                id: "2",
                name: "Strength Training",
                type: "Strength",
                duration: "60m",
                caloriesBurned: 380,
                distance: nil,
                heartRate: 120,
                date: Date().addingTimeInterval(-7200),
                notes: "Upper body focus"
            ),
            Workout(
                id: "3",
                name: "Evening Cycling",
                type: "Cycling",
                duration: "30m",
                caloriesBurned: 320,
                distance: 12.5,
                heartRate: 135,
                date: Date().addingTimeInterval(-10800),
                notes: "Relaxing evening ride"
            )
        ]
        
        recentWorkouts = Array(workouts.prefix(5))
    }
}

class ProgressManager: ObservableObject {
    @Published var progress: [ProgressData] = []
    @Published var isLoading = false
    
    init() {}
    
    func loadProgress() async {
        // Load progress data
    }
    
    func refreshProgress() async {
        await loadProgress()
    }
}

struct ProgressData: Identifiable {
    let id = UUID()
    let date: Date
    let calories: Int
    let steps: Int
    let activeMinutes: Int
}

// MARK: - Supporting Views
struct WorkoutsView: View {
    var body: some View {
        NavigationView {
            Text("Workouts View")
                .navigationTitle("Workouts")
        }
    }
}

struct ProgressView: View {
    var body: some View {
        NavigationView {
            Text("Progress View")
                .navigationTitle("Progress")
        }
    }
}

struct GoalsView: View {
    var body: some View {
        NavigationView {
            Text("Goals View")
                .navigationTitle("Goals")
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
            .background(Color.green)
            .cornerRadius(10)
        }
        .disabled(isLoading)
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

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    
    private init() {}
    
    func requestAuthorization() async {
        // Request HealthKit authorization
    }
}

struct User: Identifiable, Codable {
    let id: String
    let username: String
    let email: String
    let displayName: String
    let avatarURL: String?
    let height: Double?
    let weight: Double?
    let age: Int?
    let fitnessLevel: String?
    let createdAt: Date
    let updatedAt: Date
} 