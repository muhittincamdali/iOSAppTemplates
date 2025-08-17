//
//  SocialMediaApp.swift
//  SocialMediaExample
//
//  Created on 17/08/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct SocialMediaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let store = Store(initialState: AppFeature.State()) {
        AppFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
                .onAppear {
                    configureAppearance()
                }
        }
    }
    
    private func configureAppearance() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

// MARK: - App Delegate

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Configure app launch
        configureServices()
        setupNotifications()
        trackAppLaunch()
        
        return true
    }
    
    private func configureServices() {
        // Initialize services
        NetworkManager.shared.configure()
        DatabaseManager.shared.setup()
        AuthenticationManager.shared.initialize()
        AnalyticsManager.shared.start()
    }
    
    private func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    private func trackAppLaunch() {
        let launchTime = ProcessInfo.processInfo.systemUptime
        AnalyticsManager.shared.track(.appLaunched(duration: launchTime))
    }
}

// MARK: - App Feature

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .feed
        var feed = FeedFeature.State()
        var explore = ExploreFeature.State()
        var create = CreatePostFeature.State()
        var messages = MessagesFeature.State()
        var profile = ProfileFeature.State()
        var isAuthenticated = false
        var isLoading = true
        
        enum Tab: String, CaseIterable {
            case feed = "Feed"
            case explore = "Explore"
            case create = "Create"
            case messages = "Messages"
            case profile = "Profile"
            
            var icon: String {
                switch self {
                case .feed: return "house.fill"
                case .explore: return "magnifyingglass"
                case .create: return "plus.circle.fill"
                case .messages: return "message.fill"
                case .profile: return "person.fill"
                }
            }
        }
    }
    
    enum Action {
        case onAppear
        case selectTab(State.Tab)
        case authenticationChanged(Bool)
        case feed(FeedFeature.Action)
        case explore(ExploreFeature.Action)
        case create(CreatePostFeature.Action)
        case messages(MessagesFeature.Action)
        case profile(ProfileFeature.Action)
    }
    
    @Dependency(\.authenticationClient) var authClient
    @Dependency(\.continuousClock) var clock
    
    var body: some Reducer<State, Action> {
        Scope(state: \.feed, action: \.feed) {
            FeedFeature()
        }
        
        Scope(state: \.explore, action: \.explore) {
            ExploreFeature()
        }
        
        Scope(state: \.create, action: \.create) {
            CreatePostFeature()
        }
        
        Scope(state: \.messages, action: \.messages) {
            MessagesFeature()
        }
        
        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    try await clock.sleep(for: .milliseconds(500))
                    let isAuthenticated = await authClient.checkAuthentication()
                    await send(.authenticationChanged(isAuthenticated))
                }
                
            case .selectTab(let tab):
                state.selectedTab = tab
                return .none
                
            case .authenticationChanged(let isAuthenticated):
                state.isAuthenticated = isAuthenticated
                state.isLoading = false
                return .none
                
            case .feed, .explore, .create, .messages, .profile:
                return .none
            }
        }
    }
}

// MARK: - App View

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        Group {
            if store.isLoading {
                LaunchScreen()
            } else if store.isAuthenticated {
                MainTabView(store: store)
            } else {
                AuthenticationView()
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

struct MainTabView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        TabView(selection: $store.selectedTab) {
            ForEach(AppFeature.State.Tab.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .feed:
                        NavigationStack {
                            FeedView(
                                store: store.scope(state: \.feed, action: \.feed)
                            )
                        }
                        
                    case .explore:
                        NavigationStack {
                            ExploreView(
                                store: store.scope(state: \.explore, action: \.explore)
                            )
                        }
                        
                    case .create:
                        NavigationStack {
                            CreatePostView(
                                store: store.scope(state: \.create, action: \.create)
                            )
                        }
                        
                    case .messages:
                        NavigationStack {
                            MessagesView(
                                store: store.scope(state: \.messages, action: \.messages)
                            )
                        }
                        
                    case .profile:
                        NavigationStack {
                            ProfileView(
                                store: store.scope(state: \.profile, action: \.profile)
                            )
                        }
                    }
                }
                .tabItem {
                    Label(tab.rawValue, systemImage: tab.icon)
                }
                .tag(tab)
            }
        }
    }
}

struct LaunchScreen: View {
    @State private var scale = 0.8
    @State private var opacity = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                    .scaleEffect(scale)
                
                Text("Social App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

// MARK: - Placeholder Views

struct FeedView: View {
    let store: StoreOf<FeedFeature>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<10) { index in
                    PostCard(index: index)
                }
            }
            .padding()
        }
        .navigationTitle("Feed")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct PostCard: View {
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading) {
                    Text("User \(index + 1)")
                        .font(.headline)
                    Text("2 hours ago")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("This is a sample post content for demonstration purposes. It shows how posts would appear in the feed.")
                .font(.body)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.2))
                .frame(height: 200)
            
            HStack(spacing: 24) {
                Button(action: {}) {
                    Label("Like", systemImage: "heart")
                        .font(.subheadline)
                }
                
                Button(action: {}) {
                    Label("Comment", systemImage: "message")
                        .font(.subheadline)
                }
                
                Button(action: {}) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .font(.subheadline)
                }
                
                Spacer()
            }
            .foregroundStyle(.primary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ExploreView: View {
    let store: StoreOf<ExploreFeature>
    
    var body: some View {
        Text("Explore")
            .navigationTitle("Explore")
    }
}

struct CreatePostView: View {
    let store: StoreOf<CreatePostFeature>
    
    var body: some View {
        Text("Create Post")
            .navigationTitle("Create")
    }
}

struct MessagesView: View {
    let store: StoreOf<MessagesFeature>
    
    var body: some View {
        Text("Messages")
            .navigationTitle("Messages")
    }
}

struct ProfileView: View {
    let store: StoreOf<ProfileFeature>
    
    var body: some View {
        Text("Profile")
            .navigationTitle("Profile")
    }
}

struct AuthenticationView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button("Sign In") {
                // Handle sign in
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Placeholder Features

@Reducer
struct FeedFeature {
    @ObservableState
    struct State: Equatable {}
    enum Action {}
    var body: some Reducer<State, Action> {
        EmptyReducer()
    }
}

@Reducer
struct ExploreFeature {
    @ObservableState
    struct State: Equatable {}
    enum Action {}
    var body: some Reducer<State, Action> {
        EmptyReducer()
    }
}

@Reducer
struct CreatePostFeature {
    @ObservableState
    struct State: Equatable {}
    enum Action {}
    var body: some Reducer<State, Action> {
        EmptyReducer()
    }
}

@Reducer
struct MessagesFeature {
    @ObservableState
    struct State: Equatable {}
    enum Action {}
    var body: some Reducer<State, Action> {
        EmptyReducer()
    }
}

@Reducer
struct ProfileFeature {
    @ObservableState
    struct State: Equatable {}
    enum Action {}
    var body: some Reducer<State, Action> {
        EmptyReducer()
    }
}

// MARK: - Mock Services

struct NetworkManager {
    static let shared = NetworkManager()
    func configure() {}
}

struct DatabaseManager {
    static let shared = DatabaseManager()
    func setup() {}
}

struct AuthenticationManager {
    static let shared = AuthenticationManager()
    func initialize() {}
}

struct AnalyticsManager {
    static let shared = AnalyticsManager()
    func start() {}
    func track(_ event: AnalyticsEvent) {}
}

enum AnalyticsEvent {
    case appLaunched(duration: TimeInterval)
}

// MARK: - Dependencies

struct AuthenticationClient {
    var checkAuthentication: @Sendable () async -> Bool
}

extension AuthenticationClient: DependencyKey {
    static let liveValue = Self(
        checkAuthentication: {
            // Check if user is authenticated
            return UserDefaults.standard.bool(forKey: "isAuthenticated")
        }
    )
}

extension DependencyValues {
    var authenticationClient: AuthenticationClient {
        get { self[AuthenticationClient.self] }
        set { self[AuthenticationClient.self] = newValue }
    }
}