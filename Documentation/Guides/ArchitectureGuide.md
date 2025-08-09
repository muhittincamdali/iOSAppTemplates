# 🏗️ Architecture Guide

<!-- TOC START -->
## Table of Contents
- [🏗️ Architecture Guide](#-architecture-guide)
- [Overview](#overview)
- [Table of Contents](#table-of-contents)
- [Architecture Overview](#architecture-overview)
  - [Architectural Layers](#architectural-layers)
  - [Key Principles](#key-principles)
- [Clean Architecture](#clean-architecture)
  - [Domain Layer](#domain-layer)
  - [Data Layer](#data-layer)
  - [Presentation Layer](#presentation-layer)
- [MVVM Pattern](#mvvm-pattern)
  - [Model](#model)
  - [ViewModel](#viewmodel)
  - [View](#view)
- [SOLID Principles](#solid-principles)
  - [Single Responsibility Principle](#single-responsibility-principle)
  - [Open/Closed Principle](#openclosed-principle)
  - [Liskov Substitution Principle](#liskov-substitution-principle)
  - [Interface Segregation Principle](#interface-segregation-principle)
  - [Dependency Inversion Principle](#dependency-inversion-principle)
- [Dependency Injection](#dependency-injection)
  - [Constructor Injection](#constructor-injection)
  - [Property Injection](#property-injection)
  - [Method Injection](#method-injection)
- [Module Design](#module-design)
  - [Feature Modules](#feature-modules)
  - [Coordinator Pattern](#coordinator-pattern)
- [Testing Architecture](#testing-architecture)
  - [Unit Testing](#unit-testing)
  - [Integration Testing](#integration-testing)
- [Best Practices](#best-practices)
  - [Architecture Checklist](#architecture-checklist)
  - [Code Organization](#code-organization)
  - [Naming Conventions](#naming-conventions)
- [Resources](#resources)
<!-- TOC END -->


## Overview

This comprehensive architecture guide provides detailed information about the architectural patterns and design principles used in iOS App Templates.

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Clean Architecture](#clean-architecture)
- [MVVM Pattern](#mvvm-pattern)
- [SOLID Principles](#solid-principles)
- [Dependency Injection](#dependency-injection)
- [Module Design](#module-design)
- [Testing Architecture](#testing-architecture)
- [Best Practices](#best-practices)

## Architecture Overview

### Architectural Layers
```
┌─────────────────────────────────────┐
│           Presentation              │
│         (UI Layer)                 │
├─────────────────────────────────────┤
│            Domain                   │
│         (Business Logic)            │
├─────────────────────────────────────┤
│           Data Layer                │
│         (Repository)                │
└─────────────────────────────────────┘
```

### Key Principles
- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Open for extension, closed for modification

## Clean Architecture

### Domain Layer
```swift
// Entities
struct User {
    let id: String
    let name: String
    let email: String
}

// Use Cases
protocol GetUserUseCase {
    func execute(id: String) async throws -> User
}

class GetUserUseCaseImpl: GetUserUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(id: String) async throws -> User {
        return try await userRepository.getUser(id: id)
    }
}
```

### Data Layer
```swift
// Repository Interface
protocol UserRepository {
    func getUser(id: String) async throws -> User
    func saveUser(_ user: User) async throws
    func deleteUser(id: String) async throws
}

// Repository Implementation
class UserRepositoryImpl: UserRepository {
    private let localDataSource: UserLocalDataSource
    private let remoteDataSource: UserRemoteDataSource
    
    init(localDataSource: UserLocalDataSource, remoteDataSource: UserRemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func getUser(id: String) async throws -> User {
        // Try local first, then remote
        do {
            return try await localDataSource.getUser(id: id)
        } catch {
            let user = try await remoteDataSource.getUser(id: id)
            try await localDataSource.saveUser(user)
            return user
        }
    }
}
```

### Presentation Layer
```swift
// ViewModel
class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let getUserUseCase: GetUserUseCase
    
    init(getUserUseCase: GetUserUseCase) {
        self.getUserUseCase = getUserUseCase
    }
    
    @MainActor
    func loadUser(id: String) async {
        isLoading = true
        error = nil
        
        do {
            user = try await getUserUseCase.execute(id: id)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}
```

## MVVM Pattern

### Model
```swift
struct UserModel {
    let id: String
    let name: String
    let email: String
    let avatarURL: URL?
    
    var displayName: String {
        return name.isEmpty ? "Unknown User" : name
    }
    
    var isValidEmail: Bool {
        return email.contains("@") && email.contains(".")
    }
}
```

### ViewModel
```swift
class UserViewModel: ObservableObject {
    @Published var user: UserModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    @MainActor
    func fetchUser(id: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await userService.fetchUser(id: id)
            self.user = UserModel(from: user)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func validateUser() -> Bool {
        guard let user = user else { return false }
        return user.isValidEmail
    }
}
```

### View
```swift
struct UserView: View {
    @StateObject private var viewModel: UserViewModel
    
    init(userService: UserServiceProtocol) {
        _viewModel = StateObject(wrappedValue: UserViewModel(userService: userService))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let user = viewModel.user {
                UserProfileView(user: user)
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage)
            }
        }
        .task {
            await viewModel.fetchUser(id: "user-id")
        }
    }
}
```

## SOLID Principles

### Single Responsibility Principle
```swift
// ❌ Bad: Multiple responsibilities
class UserManager {
    func fetchUser() { }
    func saveUser() { }
    func validateEmail() { }
    func sendEmail() { }
    func updateUI() { }
}

// ✅ Good: Single responsibility
class UserRepository {
    func fetchUser() { }
    func saveUser() { }
}

class EmailValidator {
    func validateEmail(_ email: String) -> Bool { }
}

class EmailService {
    func sendEmail(_ email: String) { }
}
```

### Open/Closed Principle
```swift
// ✅ Open for extension, closed for modification
protocol PaymentProcessor {
    func processPayment(_ amount: Decimal) -> Bool
}

class CreditCardProcessor: PaymentProcessor {
    func processPayment(_ amount: Decimal) -> Bool {
        // Credit card processing logic
        return true
    }
}

class PayPalProcessor: PaymentProcessor {
    func processPayment(_ amount: Decimal) -> Bool {
        // PayPal processing logic
        return true
    }
}
```

### Liskov Substitution Principle
```swift
// ✅ Base class can be substituted with derived class
protocol Animal {
    func makeSound() -> String
}

class Dog: Animal {
    func makeSound() -> String {
        return "Woof"
    }
}

class Cat: Animal {
    func makeSound() -> String {
        return "Meow"
    }
}

func animalSound(_ animal: Animal) -> String {
    return animal.makeSound() // Works with any Animal implementation
}
```

### Interface Segregation Principle
```swift
// ❌ Bad: Fat interface
protocol UserService {
    func fetchUser() { }
    func saveUser() { }
    func deleteUser() { }
    func sendEmail() { }
    func validateEmail() { }
}

// ✅ Good: Segregated interfaces
protocol UserRepository {
    func fetchUser() { }
    func saveUser() { }
    func deleteUser() { }
}

protocol EmailService {
    func sendEmail() { }
}

protocol EmailValidator {
    func validateEmail() -> Bool { }
}
```

### Dependency Inversion Principle
```swift
// ✅ High-level modules don't depend on low-level modules
protocol UserRepositoryProtocol {
    func getUser(id: String) async throws -> User
}

class UserService {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func getUser(id: String) async throws -> User {
        return try await repository.getUser(id: id)
    }
}
```

## Dependency Injection

### Constructor Injection
```swift
class TemplateManager {
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    
    init(networkService: NetworkServiceProtocol, storageService: StorageServiceProtocol) {
        self.networkService = networkService
        self.storageService = storageService
    }
}
```

### Property Injection
```swift
class TemplateViewController: UIViewController {
    var templateService: TemplateServiceProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Service will be injected by parent
    }
}
```

### Method Injection
```swift
class TemplateProcessor {
    func processTemplate(_ template: Template, using service: TemplateServiceProtocol) {
        // Use injected service
    }
}
```

## Module Design

### Feature Modules
```swift
// User Module
struct UserModule {
    static func makeUserService() -> UserServiceProtocol {
        let repository = UserRepositoryImpl()
        return UserService(repository: repository)
    }
    
    static func makeUserViewModel() -> UserViewModel {
        let service = makeUserService()
        return UserViewModel(service: service)
    }
}

// Template Module
struct TemplateModule {
    static func makeTemplateService() -> TemplateServiceProtocol {
        let repository = TemplateRepositoryImpl()
        return TemplateService(repository: repository)
    }
}
```

### Coordinator Pattern
```swift
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMainFlow()
    }
    
    private func showMainFlow() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
```

## Testing Architecture

### Unit Testing
```swift
class UserViewModelTests: XCTestCase {
    var viewModel: UserViewModel!
    var mockService: MockUserService!
    
    override func setUp() {
        super.setUp()
        mockService = MockUserService()
        viewModel = UserViewModel(service: mockService)
    }
    
    func testFetchUserSuccess() async {
        // Given
        let expectedUser = User(id: "1", name: "Test", email: "test@example.com")
        mockService.mockUser = expectedUser
        
        // When
        await viewModel.fetchUser(id: "1")
        
        // Then
        XCTAssertEqual(viewModel.user?.name, expectedUser.name)
        XCTAssertNil(viewModel.errorMessage)
    }
}
```

### Integration Testing
```swift
class UserServiceIntegrationTests: XCTestCase {
    func testUserServiceWithRealRepository() async throws {
        // Given
        let repository = UserRepositoryImpl()
        let service = UserService(repository: repository)
        
        // When
        let user = try await service.fetchUser(id: "test-id")
        
        // Then
        XCTAssertNotNil(user)
        XCTAssertFalse(user.name.isEmpty)
    }
}
```

## Best Practices

### Architecture Checklist
- [ ] Follow Clean Architecture principles
- [ ] Implement proper separation of concerns
- [ ] Use dependency injection
- [ ] Follow SOLID principles
- [ ] Write testable code
- [ ] Use appropriate design patterns
- [ ] Document architectural decisions
- [ ] Maintain consistency across modules
- [ ] Consider scalability and maintainability
- [ ] Review and refactor regularly

### Code Organization
```swift
// Group by feature, not by type
UserFeature/
├── Domain/
│   ├── Entities/
│   ├── UseCases/
│   └── Repositories/
├── Data/
│   ├── Repositories/
│   ├── DataSources/
│   └── Models/
└── Presentation/
    ├── ViewModels/
    ├── Views/
    └── Coordinators/
```

### Naming Conventions
```swift
// Use descriptive names
class UserProfileViewModel: ObservableObject { }
class UserRepositoryImpl: UserRepository { }
class UserServiceProtocol { }

// Use clear abbreviations
class URLSessionNetworkService: NetworkServiceProtocol { }
class CoreDataUserRepository: UserRepository { }
```

## Resources

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [MVVM Pattern](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [Dependency Injection](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app)

---

**🏗️ Remember: Good architecture is the foundation of maintainable software!**
