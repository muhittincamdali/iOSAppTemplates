# iOSAppTemplates API Reference

Complete API documentation for iOSAppTemplates framework.

## Table of Contents

1. [Template Engine](#template-engine)
2. [Architecture Templates](#architecture-templates)
3. [UI Components](#ui-components)
4. [Data Layer](#data-layer)
5. [Networking](#networking)
6. [Utilities](#utilities)

---

## Template Engine

### TemplateGenerator

The main class for generating project templates.

```swift
public final class TemplateGenerator {
    /// Available template types
    public static var availableTemplates: [TemplateType] { get }
    
    /// Generate template
    public func generate(
        template: TemplateType,
        configuration: TemplateConfiguration
    ) throws -> GeneratedProject
    
    /// Validate configuration
    public func validate(_ configuration: TemplateConfiguration) throws
    
    /// Preview template structure
    public func preview(_ template: TemplateType) -> TemplatePreview
}
```

### TemplateType

```swift
public enum TemplateType: String, CaseIterable {
    case mvvm = "MVVM"
    case mvvmC = "MVVM-C"
    case viper = "VIPER"
    case cleanArchitecture = "Clean Architecture"
    case tca = "The Composable Architecture"
    case redux = "Redux"
}
```

### TemplateConfiguration

```swift
public struct TemplateConfiguration {
    /// Project name
    public var projectName: String
    
    /// Organization identifier
    public var organizationIdentifier: String
    
    /// Minimum iOS version
    public var minimumIOSVersion: String
    
    /// Include SwiftUI
    public var includeSwiftUI: Bool
    
    /// Include UIKit
    public var includeUIKit: Bool
    
    /// Include networking layer
    public var includeNetworking: Bool
    
    /// Include persistence layer
    public var includePersistence: Bool
    
    /// Include unit tests
    public var includeTests: Bool
    
    /// Include UI tests
    public var includeUITests: Bool
}
```

#### Usage

```swift
let generator = TemplateGenerator()

let config = TemplateConfiguration(
    projectName: "MyApp",
    organizationIdentifier: "com.example",
    minimumIOSVersion: "15.0",
    includeSwiftUI: true,
    includeUIKit: false,
    includeNetworking: true,
    includePersistence: true,
    includeTests: true,
    includeUITests: true
)

let project = try generator.generate(template: .mvvm, configuration: config)
```

---

## Architecture Templates

### MVVM Template

#### ViewModel Protocol

```swift
public protocol ViewModelProtocol: ObservableObject {
    associatedtype State
    associatedtype Action
    
    var state: State { get }
    func dispatch(_ action: Action)
}
```

#### BaseViewModel

```swift
open class BaseViewModel<State, Action>: ViewModelProtocol {
    @Published public private(set) var state: State
    
    public init(initialState: State)
    
    open func dispatch(_ action: Action)
    
    open func reduce(_ state: State, _ action: Action) -> State
}
```

### VIPER Template

#### Interactor Protocol

```swift
public protocol InteractorProtocol {
    associatedtype Request
    associatedtype Response
    
    func execute(_ request: Request) async throws -> Response
}
```

#### Presenter Protocol

```swift
public protocol PresenterProtocol: AnyObject {
    associatedtype ViewModel
    
    var viewModel: ViewModel { get }
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
}
```

#### Router Protocol

```swift
public protocol RouterProtocol {
    associatedtype Route
    
    func navigate(to route: Route)
    func dismiss()
    func pop()
}
```

### Clean Architecture Template

#### UseCase Protocol

```swift
public protocol UseCaseProtocol {
    associatedtype Request
    associatedtype Response
    
    func execute(_ request: Request) async throws -> Response
}
```

#### Repository Protocol

```swift
public protocol RepositoryProtocol {
    associatedtype Entity
    associatedtype ID: Hashable
    
    func get(by id: ID) async throws -> Entity?
    func getAll() async throws -> [Entity]
    func save(_ entity: Entity) async throws
    func delete(by id: ID) async throws
}
```

---

## UI Components

### BaseView

```swift
public protocol BaseViewProtocol: View {
    associatedtype ViewModel: ViewModelProtocol
    
    var viewModel: ViewModel { get }
}
```

### LoadingView

```swift
public struct LoadingView: View {
    let message: String?
    let style: LoadingStyle
    
    public enum LoadingStyle {
        case spinner
        case progress(Double)
        case skeleton
    }
}
```

### ErrorView

```swift
public struct ErrorView: View {
    let error: Error
    let retryAction: (() -> Void)?
    
    public init(error: Error, retryAction: (() -> Void)? = nil)
}
```

### EmptyStateView

```swift
public struct EmptyStateView: View {
    let title: String
    let message: String?
    let systemImage: String?
    let action: ButtonAction?
    
    public struct ButtonAction {
        let title: String
        let action: () -> Void
    }
}
```

---

## Data Layer

### DataSource Protocol

```swift
public protocol DataSourceProtocol {
    associatedtype Entity
    
    func fetch() async throws -> [Entity]
    func save(_ entities: [Entity]) async throws
    func clear() async throws
}
```

### LocalDataSource

```swift
public final class LocalDataSource<Entity: Codable>: DataSourceProtocol {
    public init(storage: StorageProtocol)
    
    public func fetch() async throws -> [Entity]
    public func save(_ entities: [Entity]) async throws
    public func clear() async throws
}
```

### RemoteDataSource

```swift
public final class RemoteDataSource<Entity: Codable>: DataSourceProtocol {
    public init(client: HTTPClientProtocol, endpoint: String)
    
    public func fetch() async throws -> [Entity]
    public func save(_ entities: [Entity]) async throws
    public func clear() async throws
}
```

### StorageProtocol

```swift
public protocol StorageProtocol {
    func read<T: Codable>(_ type: T.Type, forKey key: String) throws -> T?
    func write<T: Codable>(_ value: T, forKey key: String) throws
    func delete(forKey key: String) throws
    func exists(forKey key: String) -> Bool
}
```

---

## Networking

### HTTPClient

```swift
public final class HTTPClient: HTTPClientProtocol {
    public init(configuration: HTTPClientConfiguration)
    
    public func request<T: Decodable>(
        _ request: HTTPRequest
    ) async throws -> T
    
    public func request(
        _ request: HTTPRequest
    ) async throws -> Data
}
```

### HTTPRequest

```swift
public struct HTTPRequest {
    public let method: HTTPMethod
    public let path: String
    public var queryItems: [URLQueryItem]
    public var headers: [String: String]
    public var body: Data?
    public var timeout: TimeInterval
}
```

### HTTPMethod

```swift
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
```

### NetworkError

```swift
public enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingFailed(Error)
    case networkFailure(Error)
    case unauthorized
    case notFound
    case serverError
}
```

---

## Utilities

### Coordinator Protocol

```swift
public protocol CoordinatorProtocol: AnyObject {
    associatedtype Route
    
    var navigationController: UINavigationController { get }
    var childCoordinators: [any CoordinatorProtocol] { get set }
    
    func start()
    func navigate(to route: Route)
    func finish()
}
```

### DependencyContainer

```swift
public final class DependencyContainer {
    public static let shared = DependencyContainer()
    
    public func register<T>(_ type: T.Type, factory: @escaping () -> T)
    public func resolve<T>(_ type: T.Type) -> T?
}
```

### Logger

```swift
public struct Logger {
    public static func debug(_ message: String, file: String, function: String, line: Int)
    public static func info(_ message: String, file: String, function: String, line: Int)
    public static func warning(_ message: String, file: String, function: String, line: Int)
    public static func error(_ message: String, file: String, function: String, line: Int)
}
```

### Configuration

```swift
public struct AppConfiguration {
    public static var environment: Environment { get }
    public static var baseURL: URL { get }
    public static var apiKey: String { get }
    
    public enum Environment {
        case development
        case staging
        case production
    }
}
```

---

## Extensions

### View Extensions

```swift
public extension View {
    /// Add loading overlay
    func loading(_ isLoading: Bool) -> some View
    
    /// Add error alert
    func errorAlert(_ error: Binding<Error?>) -> some View
    
    /// Add empty state
    func emptyState(_ isEmpty: Bool, title: String, message: String?) -> some View
}
```

### Publisher Extensions

```swift
public extension Publisher {
    /// Convert to Result
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never>
    
    /// Handle errors with default value
    func replaceError(with value: Output) -> AnyPublisher<Output, Never>
}
```

---

## Platform Support

| Platform | Minimum Version |
|----------|----------------|
| iOS | 15.0+ |
| macOS | 12.0+ |
| tvOS | 15.0+ |
| watchOS | 8.0+ |

---

**Version**: 2.0.0  
**Last Updated**: 2025
