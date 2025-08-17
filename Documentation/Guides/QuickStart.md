# Quick Start Guide

Build your first iOS app using iOS App Templates in just 5 minutes! This guide will walk you through creating a fully functional app from scratch.

## 🎯 What You'll Build

In this tutorial, you'll create:
- A modern social media app with authentication
- Real-time chat functionality
- User profiles and feed
- Dark mode support
- Accessibility features

## 🚀 5-Minute Setup

### Step 1: Create New Project (1 minute)

Open Terminal and run:

```bash
# Create new directory
mkdir MyAwesomeApp && cd MyAwesomeApp

# Initialize Swift package
swift package init --type executable --name MyAwesomeApp

# Open in Xcode
open Package.swift
```

### Step 2: Add iOS App Templates (1 minute)

Update your `Package.swift`:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MyAwesomeApp",
    platforms: [
        .iOS(.v18)
    ],
    dependencies: [
        .package(url: "https://github.com/yourusername/iOSAppTemplates.git", from: "2.0.0")
    ],
    targets: [
        .executableTarget(
            name: "MyAwesomeApp",
            dependencies: [
                .product(name: "iOSAppTemplates", package: "iOSAppTemplates"),
                .product(name: "TCATemplates", package: "iOSAppTemplates")
            ]
        )
    ]
)
```

### Step 3: Create Your App (2 minutes)

Replace the contents of `Sources/MyAwesomeApp/MyAwesomeApp.swift`:

```swift
import SwiftUI
import iOSAppTemplates

@main
struct MyAwesomeApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            TemplateBuilder()
                .useTemplate(.social)
                .configure { config in
                    config.appName = "MyAwesome"
                    config.primaryColor = .blue
                    config.features = [
                        .authentication,
                        .userProfiles,
                        .feed,
                        .chat,
                        .notifications,
                        .settings
                    ]
                }
                .build()
                .environmentObject(appState)
        }
    }
}

// App State Management
class AppState: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    
    init() {
        checkAuthenticationStatus()
    }
    
    private func checkAuthenticationStatus() {
        // Check if user is logged in
        if let savedUser = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: savedUser) {
            self.user = user
            self.isAuthenticated = true
        }
    }
}
```

### Step 4: Customize Your Template (1 minute)

Create `Sources/MyAwesomeApp/Configuration.swift`:

```swift
import iOSAppTemplates
import SwiftUI

extension TemplateConfiguration {
    static var myAwesomeConfig: TemplateConfiguration {
        TemplateConfiguration(
            // App Identity
            appName: "MyAwesome",
            bundleId: "com.example.myawesome",
            version: "1.0.0",
            
            // Visual Design
            theme: Theme(
                primaryColor: Color.blue,
                secondaryColor: Color.purple,
                backgroundColor: Color(.systemBackground),
                font: .system
            ),
            
            // Features
            features: [
                .authentication(.emailPassword, .biometric, .social),
                .userProfiles(editable: true, public: true),
                .feed(.timeline, .stories, .reels),
                .chat(.oneToOne, .groups, .voice),
                .notifications(.push, .inApp),
                .settings(.profile, .privacy, .appearance)
            ],
            
            // API Configuration
            apiConfig: APIConfiguration(
                baseURL: "https://api.myawesome.com",
                timeout: 30,
                headers: ["X-App-Version": "1.0.0"]
            ),
            
            // Analytics
            analytics: AnalyticsConfiguration(
                providers: [.firebase, .mixpanel],
                trackingEnabled: true
            )
        )
    }
}
```

## 📱 Template Options

### Social Media App

```swift
TemplateBuilder()
    .useTemplate(.social)
    .configure { config in
        config.features = [
            .authentication,
            .feed,
            .stories,
            .messaging,
            .notifications
        ]
    }
    .build()
```

### E-Commerce App

```swift
TemplateBuilder()
    .useTemplate(.commerce)
    .configure { config in
        config.features = [
            .productCatalog,
            .shoppingCart,
            .payments,
            .orderTracking,
            .reviews
        ]
    }
    .build()
```

### Health & Fitness App

```swift
TemplateBuilder()
    .useTemplate(.health)
    .configure { config in
        config.features = [
            .healthKit,
            .workoutTracking,
            .nutrition,
            .goals,
            .progress
        ]
    }
    .build()
```

### Education App

```swift
TemplateBuilder()
    .useTemplate(.education)
    .configure { config in
        config.features = [
            .courses,
            .videoLessons,
            .quizzes,
            .progress,
            .certificates
        ]
    }
    .build()
```

## 🎨 Customization Examples

### Custom Theme

```swift
let customTheme = Theme(
    primaryColor: Color(hex: "#FF6B6B"),
    secondaryColor: Color(hex: "#4ECDC4"),
    backgroundColor: Color(hex: "#1A1A2E"),
    textColor: Color(hex: "#EAEAEA"),
    font: Font.custom("Avenir", size: 16)
)

TemplateBuilder()
    .useTemplate(.social)
    .setTheme(customTheme)
    .build()
```

### Add Custom Views

```swift
struct CustomFeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.posts) { post in
                    PostCard(post: post)
                        .padding(.horizontal)
                }
            }
        }
        .task {
            await viewModel.loadPosts()
        }
    }
}

// Integrate with template
TemplateBuilder()
    .useTemplate(.social)
    .replaceView(.feed, with: CustomFeedView())
    .build()
```

### Add Custom Features

```swift
extension Feature {
    static let aiAssistant = Feature(
        id: "ai_assistant",
        name: "AI Assistant",
        view: AIAssistantView(),
        icon: "brain",
        requiresAuth: true
    )
}

TemplateBuilder()
    .useTemplate(.education)
    .addFeature(.aiAssistant)
    .build()
```

## 🏗️ Architecture Patterns

### Using TCA (The Composable Architecture)

```swift
import ComposableArchitecture
import TCATemplates

struct AppFeature: Reducer {
    struct State: Equatable {
        var user: User?
        var isLoading = false
        var feed = FeedFeature.State()
        var profile = ProfileFeature.State()
    }
    
    enum Action: Equatable {
        case onAppear
        case feed(FeedFeature.Action)
        case profile(ProfileFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.feed, action: /Action.feed) {
            FeedFeature()
        }
        Scope(state: \.profile, action: /Action.profile) {
            ProfileFeature()
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    // Load initial data
                }
            case .feed, .profile:
                return .none
            }
        }
    }
}
```

### Using MVVM

```swift
import Combine

class MainViewModel: ObservableObject {
    @Published var user: User?
    @Published var posts: [Post] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIService
    
    init(apiService: APIService = .shared) {
        self.apiService = apiService
        loadData()
    }
    
    func loadData() {
        isLoading = true
        
        apiService.fetchPosts()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in
                    self.isLoading = false
                },
                receiveValue: { posts in
                    self.posts = posts
                }
            )
            .store(in: &cancellables)
    }
}
```

## 🚢 Running Your App

### On Simulator

1. Select target device in Xcode
2. Press ⌘R or click the Run button
3. App launches in simulator

### On Device

1. Connect your iPhone/iPad
2. Select your device in Xcode
3. Trust developer certificate on device:
   - Settings → General → VPN & Device Management
4. Press ⌘R to run

### Testing Different Configurations

```swift
// Debug configuration
#if DEBUG
TemplateBuilder()
    .useTemplate(.social)
    .enableMockData()
    .enableDebugMenu()
    .build()
#else
// Production configuration
TemplateBuilder()
    .useTemplate(.social)
    .configure(with: .production)
    .build()
#endif
```

## 📊 Sample Data

### Using Mock Data

```swift
TemplateBuilder()
    .useTemplate(.social)
    .useMockDataProvider { provider in
        provider.users = User.mockUsers
        provider.posts = Post.mockPosts
        provider.messages = Message.mockMessages
    }
    .build()
```

### Creating Mock Models

```swift
extension User {
    static var mockUsers: [User] {
        [
            User(id: "1", name: "John Doe", avatar: "person.circle"),
            User(id: "2", name: "Jane Smith", avatar: "person.circle.fill"),
            User(id: "3", name: "Bob Johnson", avatar: "person.crop.circle")
        ]
    }
}

extension Post {
    static var mockPosts: [Post] {
        [
            Post(
                id: "1",
                author: User.mockUsers[0],
                content: "Hello, World! 🎉",
                timestamp: Date(),
                likes: 42
            ),
            Post(
                id: "2",
                author: User.mockUsers[1],
                content: "Check out iOS App Templates!",
                timestamp: Date().addingTimeInterval(-3600),
                likes: 128
            )
        ]
    }
}
```

## 🎯 Next Steps

### Essential Guides
1. [Architecture Overview](../Architecture/Overview.md) - Understand app structure
2. [Template Catalog](../Templates/Catalog.md) - Explore all templates
3. [Customization Guide](./Customization.md) - Deep customization
4. [API Integration](./APIIntegration.md) - Connect to backend

### Advanced Topics
1. [Performance Optimization](./Performance.md)
2. [Security Best Practices](./Security.md)
3. [App Store Deployment](./AppStore.md)
4. [Analytics Integration](./Analytics.md)

## 💡 Pro Tips

1. **Use Environment Variables** for API keys
2. **Enable SwiftLint** for code quality
3. **Add Unit Tests** early in development
4. **Use Git** from the start
5. **Follow Apple's Human Interface Guidelines**

## 🆘 Need Help?

- 📖 [Documentation](../README.md)
- 💬 [Discord Community](https://discord.gg/iosapptemplates)
- 🐛 [Report Issues](https://github.com/yourusername/iOSAppTemplates/issues)
- ✉️ [Email Support](mailto:support@iosapptemplates.dev)

---

<div align="center">
  <h3>🎉 Congratulations!</h3>
  <p>You've built your first app with iOS App Templates!</p>
  <p>Share your creation: <strong>#iOSAppTemplates</strong></p>
</div>