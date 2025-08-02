# 🏗️ Architecture Guide

Complete architecture documentation for iOS App Templates.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Clean Architecture](#clean-architecture)
- [MVVM Pattern](#mvvm-pattern)
- [Dependency Injection](#dependency-injection)
- [Data Flow](#data-flow)
- [Testing Strategy](#testing-strategy)

## 🏗️ Architecture Overview

iOS App Templates follow Clean Architecture principles with MVVM pattern for optimal maintainability and testability.

### **High-Level Architecture**
```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │   Views     │  │ ViewModels  │  │ Coordinators│      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │  Entities   │  │  Use Cases  │  │  Protocols  │      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │Repositories │  │Data Sources │  │    DTOs     │      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                  Infrastructure Layer                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │   Network   │  │   Storage   │  │   Utils     │      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

## 🧹 Clean Architecture

### **Layer Responsibilities**

#### **Presentation Layer**
- **Views**: SwiftUI views with minimal logic
- **ViewModels**: Business logic and state management
- **Coordinators**: Navigation and flow control

#### **Domain Layer**
- **Entities**: Core business objects
- **Use Cases**: Business logic implementation
- **Protocols**: Contracts for dependencies

#### **Data Layer**
- **Repositories**: Data access abstraction
- **Data Sources**: Concrete data implementations
- **DTOs**: Data transfer objects

#### **Infrastructure Layer**
- **Network**: HTTP client and API communication
- **Storage**: Local data persistence
- **Utils**: Helper functions and utilities

### **Dependency Rule**
```
Presentation → Domain ← Data
     ↓           ↑        ↓
Infrastructure → Domain ← Data
```

## 🎯 MVVM Pattern

### **View (SwiftUI)**
```swift
struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                UserRowView(user: user)
            }
            .navigationTitle("Users")
            .onAppear {
                viewModel.loadUsers()
            }
        }
    }
}
```

### **ViewModel**
```swift
class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getUserListUseCase: GetUserListUseCase
    
    init(getUserListUseCase: GetUserListUseCase = GetUserListUseCase()) {
        self.getUserListUseCase = getUserListUseCase
    }
    
    func loadUsers() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let users = try await getUserListUseCase.execute()
                await MainActor.run {
                    self.users = users
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
```

### **Model (Entity)**
```swift
struct User: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let avatarURL: String?
    
    var displayName: String {
        return name.isEmpty ? email : name
    }
    
    var hasAvatar: Bool {
        return avatarURL != nil
    }
}
```

## 💉 Dependency Injection

### **Container Setup**
```swift
class DependencyContainer {
    static let shared = DependencyContainer()
    
    // Network dependencies
    lazy var networkClient: NetworkClient = {
        let config = NetworkConfiguration(
            baseURL: "https://api.example.com",
            timeout: 30
        )
        return NetworkClient(configuration: config)
    }()
    
    // Storage dependencies
    lazy var userDefaultsStorage: UserDefaultsStorage = {
        return UserDefaultsStorage(suiteName: "com.app.storage")
    }()
    
    lazy var keychainStorage: KeychainStorage = {
        return KeychainStorage(service: "com.app.keychain")
    }()
    
    // Repository dependencies
    lazy var userRepository: UserRepositoryProtocol = {
        return UserRepository(
            remoteDataSource: UserRemoteDataSource(networkClient: networkClient),
            localDataSource: UserLocalDataSource(storage: userDefaultsStorage)
        )
    }()
    
    // Use case dependencies
    lazy var getUserListUseCase: GetUserListUseCase = {
        return GetUserListUseCase(userRepository: userRepository)
    }()
    
    lazy var createUserUseCase: CreateUserUseCase = {
        return CreateUserUseCase(userRepository: userRepository)
    }()
}
```

### **Environment Objects**
```swift
struct ContentView: View {
    @StateObject private var networkClient = DependencyContainer.shared.networkClient
    @StateObject private var storage = DependencyContainer.shared.userDefaultsStorage
    @StateObject private var analytics = DependencyContainer.shared.analyticsManager
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .environmentObject(networkClient)
        .environmentObject(storage)
        .environmentObject(analytics)
    }
}
```

## 🔄 Data Flow

### **Request Flow**
```
1. User Action → View
2. View → ViewModel
3. ViewModel → Use Case
4. Use Case → Repository
5. Repository → Data Source
6. Data Source → Network/Storage
7. Response flows back up the chain
```

### **Error Handling Flow**
```
1. Error occurs in Data Layer
2. Error propagates up through Repository
3. Repository → Use Case
4. Use Case → ViewModel
5. ViewModel updates @Published error state
6. View displays error to user
```

### **State Management**
```swift
enum ViewState {
    case idle
    case loading
    case loaded
    case error(String)
}

class BaseViewModel: ObservableObject {
    @Published var state: ViewState = .idle
    
    func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.state = .error(error.localizedDescription)
        }
    }
    
    func setLoading() {
        DispatchQueue.main.async {
            self.state = .loading
        }
    }
    
    func setLoaded() {
        DispatchQueue.main.async {
            self.state = .loaded
        }
    }
}
```

## 🧪 Testing Strategy

### **Unit Testing**
```swift
class UserListViewModelTests: XCTestCase {
    var viewModel: UserListViewModel!
    var mockUseCase: MockGetUserListUseCase!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockGetUserListUseCase()
        viewModel = UserListViewModel(getUserListUseCase: mockUseCase)
    }
    
    func testLoadUsersSuccess() async {
        // Given
        let expectedUsers = [User(id: "1", name: "John", email: "john@example.com", avatarURL: nil)]
        mockUseCase.result = .success(expectedUsers)
        
        // When
        await viewModel.loadUsers()
        
        // Then
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertEqual(viewModel.users.first?.name, "John")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadUsersFailure() async {
        // Given
        mockUseCase.result = .failure(NetworkError.timeout)
        
        // When
        await viewModel.loadUsers()
        
        // Then
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
```

### **Integration Testing**
```swift
class UserRepositoryIntegrationTests: XCTestCase {
    var repository: UserRepository!
    var networkClient: NetworkClient!
    var storage: UserDefaultsStorage!
    
    override func setUp() {
        super.setUp()
        networkClient = NetworkClient(configuration: NetworkConfiguration(baseURL: "https://api.example.com"))
        storage = UserDefaultsStorage(suiteName: "test")
        repository = UserRepository(
            remoteDataSource: UserRemoteDataSource(networkClient: networkClient),
            localDataSource: UserLocalDataSource(storage: storage)
        )
    }
    
    func testFetchUsersFromRemote() async throws {
        // When
        let users = try await repository.getUsers()
        
        // Then
        XCTAssertFalse(users.isEmpty)
    }
}
```

### **UI Testing**
```swift
class UserListViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    func testUserListDisplaysUsers() {
        // Given
        let userList = app.collectionViews["UserList"]
        
        // When
        userList.waitForExistence(timeout: 5)
        
        // Then
        XCTAssertTrue(userList.exists)
        XCTAssertGreaterThan(userList.cells.count, 0)
    }
    
    func testUserDetailNavigation() {
        // Given
        let userList = app.collectionViews["UserList"]
        let firstCell = userList.cells.element(boundBy: 0)
        
        // When
        firstCell.tap()
        
        // Then
        let detailView = app.navigationBars["User Detail"]
        XCTAssertTrue(detailView.exists)
    }
}
```

## 📁 Project Structure

### **Directory Organization**
```
MyApp/
├── App/
│   ├── MyAppApp.swift
│   └── ContentView.swift
├── Presentation/
│   ├── Views/
│   │   ├── Home/
│   │   ├── Profile/
│   │   └── Settings/
│   ├── ViewModels/
│   └── Coordinators/
├── Domain/
│   ├── Entities/
│   ├── UseCases/
│   └── Protocols/
├── Data/
│   ├── Repositories/
│   ├── DataSources/
│   └── DTOs/
├── Infrastructure/
│   ├── Network/
│   ├── Storage/
│   └── Utils/
└── Tests/
    ├── UnitTests/
    ├── IntegrationTests/
    └── UITests/
```

### **File Naming Conventions**
```
Views: UserListView.swift
ViewModels: UserListViewModel.swift
Use Cases: GetUserListUseCase.swift
Repositories: UserRepository.swift
Data Sources: UserRemoteDataSource.swift
DTOs: UserDTO.swift
Entities: User.swift
```

## 📚 Next Steps

1. **Read [Getting Started](GettingStarted.md)** for quick setup
2. **Check [Template Guide](TemplateGuide.md)** for template usage
3. **Review [UI Components](UIComponents.md)** for UI components
4. **See [API Reference](API.md)** for complete documentation

## 🤝 Support

- **Documentation**: [Complete Documentation](Documentation/)
- **Issues**: [GitHub Issues](https://github.com/muhittincamdali/iOSAppTemplates/issues)
- **Discussions**: [GitHub Discussions](https://github.com/muhittincamdali/iOSAppTemplates/discussions)

---

**Happy architecting with iOS App Templates! 🏗️** 