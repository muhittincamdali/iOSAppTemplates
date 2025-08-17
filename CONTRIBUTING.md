# Contributing to iOS App Templates

First off, thank you for considering contributing to iOS App Templates! It's people like you that make iOS App Templates such a great tool for the iOS development community. 🎉

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Development Workflow](#development-workflow)
- [Style Guidelines](#style-guidelines)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Community](#community)

## 📜 Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [conduct@iosapptemplates.dev](mailto:conduct@iosapptemplates.dev).

## 🤝 How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, please include as many details as possible using our [bug report template](.github/ISSUE_TEMPLATE/bug_report.yml).

**Great Bug Reports** tend to have:
- A quick summary and/or background
- Steps to reproduce (be specific!)
- What you expected would happen
- What actually happens
- Sample code or project that demonstrates the issue
- Notes (possibly including why you think this might be happening)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues using our [feature request template](.github/ISSUE_TEMPLATE/feature_request.yml).

**Great Enhancement Suggestions** tend to have:
- A clear and descriptive title
- A detailed description of the proposed enhancement
- Concrete examples of how it would be used
- An explanation of why this enhancement would be useful
- Mockups or wireframes (if applicable)

### Contributing Code

#### First Time Contributors

Unsure where to begin? You can start by looking through these issues:
- `good first issue` - issues which should only require a few lines of code
- `help wanted` - issues which need extra attention
- `documentation` - improvements or additions to documentation

#### Types of Contributions

##### 🚀 New Templates
We love new template contributions! To add a new template:

1. Create a new directory under `Templates/[Category]/`
2. Follow our template structure:
   ```
   YourTemplate/
   ├── Sources/
   │   ├── Models/
   │   ├── Views/
   │   ├── ViewModels/
   │   └── Services/
   ├── Tests/
   ├── Resources/
   ├── README.md
   └── Template.swift
   ```
3. Include comprehensive documentation
4. Add unit and UI tests
5. Update the template catalog

##### 🐛 Bug Fixes
- Write a test that exposes the bug
- Fix the bug
- Ensure all tests pass
- Update documentation if needed

##### 📚 Documentation
- Fix typos and grammar
- Improve clarity of existing docs
- Add missing documentation
- Create tutorials and guides
- Translate documentation

##### ⚡ Performance Improvements
- Profile the performance issue
- Implement the improvement
- Provide benchmark results
- Document the optimization

## 💻 Development Setup

### Prerequisites

```bash
# Install Xcode (16.0+)
xcode-select --install

# Install SwiftLint
brew install swiftlint

# Install Swift Format
brew install swift-format

# Clone the repository
git clone https://github.com/yourusername/iOSAppTemplates.git
cd iOSAppTemplates
```

### Building the Project

```bash
# Resolve dependencies
swift package resolve

# Build the project
swift build

# Run tests
swift test

# Generate documentation
swift package generate-documentation
```

### Setting Up Development Environment

1. **Fork the Repository**
   ```bash
   # Fork via GitHub UI, then:
   git clone https://github.com/YOUR_USERNAME/iOSAppTemplates.git
   cd iOSAppTemplates
   git remote add upstream https://github.com/yourusername/iOSAppTemplates.git
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/issue-number
   ```

3. **Install Git Hooks**
   ```bash
   # Install pre-commit hooks
   cp .githooks/pre-commit .git/hooks/
   chmod +x .git/hooks/pre-commit
   ```

## 🔄 Development Workflow

### 1. Stay Updated

```bash
# Fetch upstream changes
git fetch upstream
git checkout main
git merge upstream/main
```

### 2. Make Your Changes

Follow our coding standards and ensure:
- All tests pass
- SwiftLint warnings are resolved
- Documentation is updated
- Changelog entry is added (if applicable)

### 3. Test Your Changes

```bash
# Run all tests
swift test

# Run specific tests
swift test --filter YourTestName

# Run SwiftLint
swiftlint

# Run Swift Format
swift-format -i Sources/**/*.swift
```

### 4. Commit Your Changes

Follow our [commit message conventions](#commit-guidelines):

```bash
git add .
git commit -m "feat(templates): add new social media template"
```

### 5. Push Your Branch

```bash
git push origin feature/your-feature-name
```

### 6. Create Pull Request

Use our [pull request template](.github/pull_request_template.md) and ensure:
- PR description clearly describes the changes
- All CI checks pass
- Documentation is updated
- Tests are included

## 🎨 Style Guidelines

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and use SwiftLint for enforcement.

#### Key Points:

```swift
// MARK: - Naming

// Use descriptive names
let maximumWidgetCount = 100 // Good
let maxCount = 100 // Avoid

// Use camelCase for functions and variables
func calculateTotalPrice() -> Double
var itemCount: Int

// Use PascalCase for types
struct UserProfile
enum PaymentMethod
protocol Downloadable

// MARK: - Code Organization

// Use extensions for protocol conformance
struct User {
    let id: String
    let name: String
}

extension User: Codable {
    // Codable implementation
}

// MARK: - Documentation

/// Calculates the total price including tax
/// - Parameters:
///   - subtotal: The price before tax
///   - taxRate: The tax rate as a decimal (e.g., 0.08 for 8%)
/// - Returns: The total price including tax
func calculateTotal(subtotal: Double, taxRate: Double) -> Double {
    subtotal * (1 + taxRate)
}
```

### File Organization

```swift
// 1. Imports
import SwiftUI
import Combine

// 2. Protocols
protocol DataServiceProtocol {
    // Protocol definition
}

// 3. Main Type
struct ContentView: View {
    // 4. Properties
    @State private var isLoading = false
    @StateObject private var viewModel = ContentViewModel()
    
    // 5. Body/Computed Properties
    var body: some View {
        // View implementation
    }
    
    // 6. Methods
    private func loadData() {
        // Method implementation
    }
}

// 7. Extensions
extension ContentView {
    // Additional functionality
}

// 8. Nested Types
extension ContentView {
    struct Configuration {
        // Nested type
    }
}
```

## 📝 Commit Guidelines

We use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages.

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Test additions or corrections
- `build`: Build system changes
- `ci`: CI/CD changes
- `chore`: Maintenance tasks

### Examples

```bash
# Feature
feat(templates): add new e-commerce template with payment integration

# Bug Fix
fix(auth): resolve token refresh issue in authentication flow

# Documentation
docs(readme): update installation instructions for Swift 6.0

# Performance
perf(feed): optimize image loading with lazy loading

# Breaking Change
feat(api)!: update API client to v2.0

BREAKING CHANGE: API client now requires Swift 6.0
```

## 🚀 Pull Request Process

### Before Submitting

1. **Update Documentation** - Include relevant documentation changes
2. **Add Tests** - Ensure adequate test coverage
3. **Run Tests Locally** - All tests must pass
4. **Update CHANGELOG** - Add entry for significant changes
5. **Resolve Conflicts** - Merge latest main branch

### PR Checklist

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] All tests pass
- [ ] SwiftLint passes
- [ ] No merge conflicts
- [ ] PR template completed

### Review Process

1. **Automated Checks** - CI/CD must pass
2. **Code Review** - At least one maintainer approval
3. **Testing** - Manual testing if applicable
4. **Documentation Review** - Docs team review if needed
5. **Merge** - Squash and merge to main

### After Merge

- Delete your branch
- Update your local repository
- Celebrate your contribution! 🎉

## 👥 Community

### Communication Channels

- **GitHub Discussions** - General discussions and questions
- **Discord Server** - Real-time chat and support
- **Twitter** - Updates and announcements
- **Stack Overflow** - Technical questions (tag: `ios-app-templates`)

### Getting Help

- Review existing documentation
- Search existing issues and discussions
- Ask in Discord `#help` channel
- Create a discussion for broader topics
- Open an issue for bugs or features

### Recognition

Contributors are recognized in:
- [Contributors list](https://github.com/yourusername/iOSAppTemplates/contributors)
- Release notes
- Annual contributor spotlight
- Special badges in Discord

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🙏 Acknowledgments

Thank you to all our contributors! Your efforts make this project possible.

Special thanks to:
- All template contributors
- Documentation writers
- Bug reporters and fixers
- Community moderators
- Everyone who spreads the word

---

<div align="center">
  <strong>Happy Contributing! 🚀</strong>
  <br>
  <em>Together, we're building the best iOS development toolkit</em>
</div>