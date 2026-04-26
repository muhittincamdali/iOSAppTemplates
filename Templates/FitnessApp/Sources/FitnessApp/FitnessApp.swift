import SwiftUI
import Charts
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import HealthKit
import DGCharts

private enum RuntimeCaptureMode {
    static let isEnabled = ProcessInfo.processInfo.environment["IOSAPPTEMPLATES_SCREENSHOT_MODE"] == "1"
}

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
                height: 180,
                weight: 78,
                age: 29,
                fitnessLevel: "Intermediate",
                createdAt: Date(),
                updatedAt: Date()
            )
            authManager.isAuthenticated = true

            Task {
                await workoutManager.loadWorkouts()
                await progressManager.loadProgress()
            }
            return
        }

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
            
            ProgressInsightsView()
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

struct WeeklyHabit: Identifiable {
    let id = UUID()
    let title: String
    let completionCount: Int
    let targetCount: Int
    let color: Color
}

// MARK: - View Models
@MainActor
class WorkoutManager: ObservableObject {
    static let shared = WorkoutManager()

    @Published var workouts: [Workout] = []
    @Published var recentWorkouts: [Workout] = []
    @Published var weeklyPlan: [Workout] = []
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
    
    var totalWeeklyMinutes: Int {
        workouts.reduce(0) { $0 + workoutDurationMinutes(for: $1.duration) }
    }
    
    var totalWeeklyCalories: Int {
        workouts.reduce(0) { $0 + $1.caloriesBurned }
    }
    
    var totalWeeklyDistance: Double {
        workouts.compactMap(\.distance).reduce(0, +)
    }
    
    private func workoutDurationMinutes(for value: String) -> Int {
        Int(value.replacingOccurrences(of: "m", with: "")) ?? 0
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
            ),
            Workout(
                id: "4",
                name: "Mobility Flow",
                type: "Yoga",
                duration: "25m",
                caloriesBurned: 140,
                distance: nil,
                heartRate: 92,
                date: Date().addingTimeInterval(-172800),
                notes: "Focused on hips and thoracic mobility"
            ),
            Workout(
                id: "5",
                name: "Tempo Run",
                type: "Running",
                duration: "35m",
                caloriesBurned: 370,
                distance: 4.4,
                heartRate: 151,
                date: Date().addingTimeInterval(-259200),
                notes: "Strong pacing blocks"
            )
        ]
        
        recentWorkouts = Array(workouts.prefix(5))
        weeklyPlan = [
            Workout(id: "plan-1", name: "Intervals", type: "Running", duration: "40m", caloriesBurned: 420, distance: 5.0, heartRate: 148, date: Date().addingTimeInterval(86400), notes: "6 x 400m at threshold pace"),
            Workout(id: "plan-2", name: "Lower Body Strength", type: "Strength", duration: "50m", caloriesBurned: 360, distance: nil, heartRate: 118, date: Date().addingTimeInterval(172800), notes: "Squat, hinge, lunge, carries"),
            Workout(id: "plan-3", name: "Zone 2 Ride", type: "Cycling", duration: "60m", caloriesBurned: 430, distance: 18.0, heartRate: 132, date: Date().addingTimeInterval(259200), notes: "Aerobic endurance block")
        ]
    }
}

@MainActor
class ProgressManager: ObservableObject {
    static let shared = ProgressManager()

    @Published var progress: [ProgressData] = []
    @Published var goals: [Goal] = []
    @Published var weeklyHabits: [WeeklyHabit] = []
    @Published var isLoading = false
    
    init() {}
    
    func loadProgress() async {
        if progress.isEmpty {
            seedProgress()
        }
    }
    
    func refreshProgress() async {
        await loadProgress()
    }
    
    var latestProgress: ProgressData? {
        progress.sorted { $0.date > $1.date }.first
    }
    
    var averageDailySteps: Int {
        guard !progress.isEmpty else { return 0 }
        return progress.map(\.steps).reduce(0, +) / progress.count
    }
    
    var completedGoalsCount: Int {
        goals.filter(\.isCompleted).count
    }
    
    private func seedProgress() {
        progress = [
            ProgressData(date: Date().addingTimeInterval(-518400), calories: 1120, steps: 6800, activeMinutes: 34),
            ProgressData(date: Date().addingTimeInterval(-432000), calories: 1280, steps: 7420, activeMinutes: 42),
            ProgressData(date: Date().addingTimeInterval(-345600), calories: 1390, steps: 8050, activeMinutes: 48),
            ProgressData(date: Date().addingTimeInterval(-259200), calories: 1210, steps: 7100, activeMinutes: 37),
            ProgressData(date: Date().addingTimeInterval(-172800), calories: 1510, steps: 9320, activeMinutes: 58),
            ProgressData(date: Date().addingTimeInterval(-86400), calories: 1440, steps: 8870, activeMinutes: 51),
            ProgressData(date: Date(), calories: 1250, steps: 8432, activeMinutes: 45)
        ]
        
        goals = [
            Goal(id: "goal-1", title: "Weekly Running Volume", description: "Hit 15 km total distance this week.", targetValue: 15, currentValue: 9.6, unit: "km", deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date()), isCompleted: false, createdAt: Date().addingTimeInterval(-1209600)),
            Goal(id: "goal-2", title: "Strength Sessions", description: "Complete 3 lifting sessions this week.", targetValue: 3, currentValue: 2, unit: "sessions", deadline: Calendar.current.date(byAdding: .day, value: 2, to: Date()), isCompleted: false, createdAt: Date().addingTimeInterval(-604800)),
            Goal(id: "goal-3", title: "Daily Mobility", description: "Finish a mobility flow 5 times this week.", targetValue: 5, currentValue: 5, unit: "flows", deadline: nil, isCompleted: true, createdAt: Date().addingTimeInterval(-604800))
        ]
        
        weeklyHabits = [
            WeeklyHabit(title: "Hydration", completionCount: 5, targetCount: 7, color: .blue),
            WeeklyHabit(title: "Sleep 8h", completionCount: 4, targetCount: 7, color: .purple),
            WeeklyHabit(title: "Protein Target", completionCount: 6, targetCount: 7, color: .orange)
        ]
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
    @StateObject private var workoutManager = WorkoutManager.shared
    
    var body: some View {
        NavigationView {
            List {
                Section("This Week") {
                    SummaryMetricRow(title: "Workouts logged", value: "\(workoutManager.workouts.count)")
                    SummaryMetricRow(title: "Training time", value: "\(workoutManager.totalWeeklyMinutes)m")
                    SummaryMetricRow(title: "Distance", value: String(format: "%.1f km", workoutManager.totalWeeklyDistance))
                    SummaryMetricRow(title: "Calories", value: "\(workoutManager.totalWeeklyCalories)")
                }
                
                Section("Upcoming Plan") {
                    ForEach(workoutManager.weeklyPlan) { workout in
                        WorkoutPlanRow(workout: workout)
                    }
                }
                
                Section("Recent Sessions") {
                    ForEach(workoutManager.workouts) { workout in
                        WorkoutLogRow(workout: workout)
                    }
                }
            }
            .navigationTitle("Workouts")
        }
    }
}

struct ProgressInsightsView: View {
    @StateObject private var progressManager = ProgressManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let latest = progressManager.latestProgress {
                        HStack(spacing: 12) {
                            ProgressSummaryCard(title: "Steps", value: "\(latest.steps)", detail: "today")
                            ProgressSummaryCard(title: "Active", value: "\(latest.activeMinutes)m", detail: "today")
                            ProgressSummaryCard(title: "Calories", value: "\(latest.calories)", detail: "today")
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("7-Day Trend")
                            .font(.title3.weight(.bold))
                            .padding(.horizontal, 16)
                        Chart {
                            ForEach(progressManager.progress) { entry in
                                LineMark(
                                    x: .value("Day", entry.date, unit: .day),
                                    y: .value("Steps", entry.steps)
                                )
                                .foregroundStyle(Color.green)
                                
                                AreaMark(
                                    x: .value("Day", entry.date, unit: .day),
                                    y: .value("Steps", entry.steps)
                                )
                                .foregroundStyle(Color.green.opacity(0.15))
                            }
                        }
                        .frame(height: 220)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Habit Consistency")
                            .font(.title3.weight(.bold))
                            .padding(.horizontal, 16)
                        ForEach(progressManager.weeklyHabits) { habit in
                            HabitProgressRow(habit: habit)
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Progress")
        }
    }
}

struct GoalsView: View {
    @StateObject private var progressManager = ProgressManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 12) {
                        ProgressSummaryCard(title: "Open", value: "\(progressManager.goals.filter { !$0.isCompleted }.count)", detail: "goals")
                        ProgressSummaryCard(title: "Completed", value: "\(progressManager.completedGoalsCount)", detail: "this cycle")
                    }
                    .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Active Goals")
                            .font(.title3.weight(.bold))
                            .padding(.horizontal, 16)
                        ForEach(progressManager.goals) { goal in
                            GoalCard(goal: goal)
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Goals")
        }
    }
}

struct ProfileView: View {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var progressManager = ProgressManager.shared
    @StateObject private var workoutManager = WorkoutManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let user = authManager.currentUser {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(user.displayName)
                                .font(.title2.weight(.bold))
                            Text("@\(user.username)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Level: \(user.fitnessLevel ?? "Unknown")")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(.green)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.green.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 16)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                            FitnessMetricCard(title: "Height", value: "\(Int(user.height ?? 0)) cm")
                            FitnessMetricCard(title: "Weight", value: "\(Int(user.weight ?? 0)) kg")
                            FitnessMetricCard(title: "Avg Steps", value: "\(progressManager.averageDailySteps)")
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Training Summary")
                            .font(.title3.weight(.bold))
                            .padding(.horizontal, 16)
                        FitnessDetailRow(title: "Sessions this week", detail: "\(workoutManager.workouts.count) logged workouts")
                        FitnessDetailRow(title: "Focus split", detail: "Running, Strength, Mobility")
                        FitnessDetailRow(title: "Recovery score", detail: "Strong - no missed sleep warning")
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Connected Sources")
                            .font(.title3.weight(.bold))
                            .padding(.horizontal, 16)
                        FitnessDetailRow(title: "HealthKit", detail: "Steps, heart rate, workouts synced")
                        FitnessDetailRow(title: "Coach notes", detail: "Last updated after Friday tempo run")
                        FitnessDetailRow(title: "Plan cadence", detail: "3 performance days, 2 recovery days")
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Profile")
        }
    }
}

struct SummaryMetricRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

struct WorkoutPlanRow: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(workout.name)
                    .font(.headline)
                Spacer()
                Text(workout.duration)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.green)
            }
            Text(workout.notes ?? "No notes")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(workout.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct WorkoutLogRow: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(workout.name)
                    .font(.headline)
                Spacer()
                Text("\(workout.caloriesBurned) cal")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.orange)
            }
            HStack {
                Label(workout.type, systemImage: "figure.run")
                Label(workout.duration, systemImage: "clock")
                if let distance = workout.distance {
                    Label(String(format: "%.1f km", distance), systemImage: "location")
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
            if let notes = workout.notes {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ProgressSummaryCard: View {
    let title: String
    let value: String
    let detail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value)
                .font(.title3.weight(.bold))
            Text(title)
                .font(.caption.weight(.semibold))
            Text(detail)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

struct HabitProgressRow: View {
    let habit: WeeklyHabit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(habit.title)
                    .font(.headline)
                Spacer()
                Text("\(habit.completionCount)/\(habit.targetCount)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(habit.color)
            }
            ProgressView(value: Double(habit.completionCount), total: Double(habit.targetCount))
                .tint(habit.color)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

struct GoalCard: View {
    let goal: Goal
    
    var body: some View {
        let progress = min(goal.currentValue / goal.targetValue, 1)
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                Spacer()
                Text(goal.isCompleted ? "Done" : "\(Int(progress * 100))%")
                    .font(.caption.weight(.bold))
                    .foregroundColor(goal.isCompleted ? .green : .orange)
            }
            Text(goal.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            ProgressView(value: progress)
                .tint(goal.isCompleted ? .green : .orange)
            HStack {
                Text("\(goal.currentValue, specifier: "%.1f") / \(goal.targetValue, specifier: "%.1f") \(goal.unit)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                if let deadline = goal.deadline {
                    Text(deadline.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

struct FitnessMetricCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title3.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }
}

struct FitnessDetailRow: View {
    let title: String
    let detail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(detail)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
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
