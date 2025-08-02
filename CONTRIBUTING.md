# Contributing to iOS App Templates

Thank you for your interest in contributing to iOS App Templates! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

- Use the GitHub issue tracker
- Include detailed reproduction steps
- Provide system information (iOS version, device, etc.)
- Include crash logs if applicable
- Use the bug report template

### Suggesting Enhancements

- Use the GitHub issue tracker
- Describe the enhancement clearly
- Explain why this enhancement would be useful
- Include mockups or examples if applicable
- Use the enhancement request template

### Contributing Code

- Fork the repository
- Create a feature branch
- Make your changes
- Add tests for new functionality
- Update documentation
- Submit a pull request

### Improving Documentation

- Fix typos and grammar
- Add missing information
- Improve clarity and structure
- Add code examples
- Update outdated information

## Development Setup

### Prerequisites

- Xcode 15.0+
- iOS 15.0+ deployment target
- Swift 5.9+
- macOS 13.0+

### Getting Started

1. **Fork the repository**
   ```bash
   git clone https://github.com/your-username/iOSAppTemplates.git
   cd iOSAppTemplates
   ```

2. **Install dependencies**
   ```bash
   # Swift Package Manager (automatic)
   # No additional setup required
   ```

3. **Open in Xcode**
   ```bash
   open iOSAppTemplates.xcodeproj
   ```

4. **Run tests**
   ```bash
   xcodebuild test -scheme iOSAppTemplates
   ```

### Project Structure

```
iOSAppTemplates/
├── Templates/
│   ├── SocialMediaApp/
│   ├── EcommerceApp/
│   └── FitnessApp/
├── Documentation/
│   ├── GettingStarted.md
│   ├── Architecture.md
│   ├── TemplateGuide.md
│   ├── UIComponents.md
│   └── API.md
├── Examples/
│   ├── BasicExample/
│   ├── AdvancedExample/
│   └── CustomExample/
├── Sources/
│   ├── Core/
│   ├── UI/
│   └── Utils/
├── Tests/
│   ├── UnitTests/
│   ├── UITests/
│   └── IntegrationTests/
└── Resources/
    ├── Assets/
    └── Localization/
```

## Coding Standards

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) and [Google Swift Style Guide](https://google.github.io/swift/).

### Key Principles

- **Clarity**: Code should be self-documenting
- **Consistency**: Follow established patterns
- **Simplicity**: Prefer simple solutions over complex ones
- **Performance**: Consider performance implications
- **Accessibility**: Ensure accessibility compliance

### Naming Conventions

```swift
// Types and protocols
struct UserProfile { }
protocol DataService { }

// Functions and methods
func fetchUserData() { }
func calculateTotalPrice() { }

// Variables and constants
let maximumRetryCount = 3
var currentUser: User?

// Enums
enum NetworkError: Error {
    case timeout
    case invalidResponse
}
```

### Code Organization

```swift
// MARK: - Imports
import SwiftUI
import Firebase

// MARK: - Protocols
protocol UserServiceProtocol {
    func fetchUser(id: String) async throws -> User
}

// MARK: - Models
struct User: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
}

// MARK: - Services
class UserService: UserServiceProtocol {
    func fetchUser(id: String) async throws -> User {
        // Implementation
    }
}

// MARK: - ViewModels
class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    
    func loadUser(id: String) async {
        // Implementation
    }
}

// MARK: - Views
struct UserView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        // Implementation
    }
}
```

### Documentation

```swift
/// A service for managing user data and authentication.
///
/// This service provides methods for fetching user information,
/// handling authentication, and managing user sessions.
///
/// ## Usage
/// ```swift
/// let userService = UserService()
/// let user = try await userService.fetchUser(id: "123")
/// ```
///
/// - Note: This service requires a valid authentication token.
/// - Warning: Do not call this service from the main thread.
class UserService {
    
    /// Fetches user data by ID.
    ///
    /// - Parameter id: The unique identifier of the user.
    /// - Returns: A `User` object containing the user's information.
    /// - Throws: `NetworkError` if the request fails.
    func fetchUser(id: String) async throws -> User {
        // Implementation
    }
}
```

## Testing

### Test Structure

```
Tests/
├── UnitTests/
│   ├── Models/
│   ├── Services/
│   ├── ViewModels/
│   └── Utils/
├── UITests/
│   ├── FlowTests/
│   ├── ComponentTests/
│   └── AccessibilityTests/
└── IntegrationTests/
    ├── APITests/
    ├── DatabaseTests/
    └── PerformanceTests/
```

### Writing Tests

```swift
import XCTest
@testable import iOSAppTemplates

final class UserServiceTests: XCTestCase {
    
    var userService: UserService!
    
    override func setUp() {
        super.setUp()
        userService = UserService()
    }
    
    override func tearDown() {
        userService = nil
        super.tearDown()
    }
    
    func testFetchUserSuccess() async throws {
        // Given
        let userId = "123"
        
        // When
        let user = try await userService.fetchUser(id: userId)
        
        // Then
        XCTAssertEqual(user.id, userId)
        XCTAssertNotNil(user.name)
        XCTAssertNotNil(user.email)
    }
    
    func testFetchUserFailure() async {
        // Given
        let invalidUserId = ""
        
        // When & Then
        do {
            _ = try await userService.fetchUser(id: invalidUserId)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}
```

### Test Coverage

- Aim for at least 80% code coverage
- Test all public APIs
- Test error conditions
- Test edge cases
- Test performance critical paths

## Documentation

### Documentation Standards

- Use clear, concise language
- Include code examples
- Provide step-by-step instructions
- Include screenshots when helpful
- Keep documentation up to date

### Documentation Structure

```
Documentation/
├── GettingStarted.md
├── Architecture.md
├── TemplateGuide.md
├── UIComponents.md
├── API.md
├── Examples/
│   ├── BasicExample.md
│   ├── AdvancedExample.md
│   └── CustomExample.md
└── Guides/
    ├── Deployment.md
    ├── Testing.md
    └── Troubleshooting.md
```

## Pull Request Process

### Before Submitting

1. **Ensure tests pass**
   ```bash
   xcodebuild test -scheme iOSAppTemplates
   ```

2. **Check code style**
   ```bash
   swiftlint lint
   ```

3. **Update documentation**
   - Update README if needed
   - Add inline documentation
   - Update API documentation

4. **Test on different devices**
   - iPhone simulator
   - iPad simulator
   - Different iOS versions

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] UI tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] No breaking changes

## Screenshots (if applicable)
Add screenshots here

## Additional Notes
Any additional information
```

### Review Process

1. **Automated checks**
   - CI/CD pipeline
   - Code coverage
   - Style checks

2. **Manual review**
   - Code quality
   - Architecture decisions
   - Performance implications
   - Security considerations

3. **Testing**
   - Functionality testing
   - Integration testing
   - Performance testing

## Release Process

### Versioning

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Checklist

- [ ] All tests pass
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version number updated
- [ ] Release notes prepared
- [ ] Tag created
- [ ] Release published

### Creating a Release

1. **Update version**
   ```bash
   # Update version in project files
   # Update CHANGELOG.md
   ```

2. **Create tag**
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

3. **Create GitHub release**
   - Go to GitHub releases
   - Create new release
   - Add release notes
   - Upload assets

## Getting Help

- **Issues**: Use GitHub issues
- **Discussions**: Use GitHub discussions
- **Documentation**: Check the docs folder
- **Examples**: Check the examples folder

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- GitHub contributors page

Thank you for contributing to iOS App Templates! 