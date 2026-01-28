# iOS App Templates

<p align="center">
  <img src="Assets/banner.png" alt="iOS App Templates" width="800">
</p>

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.9+-F05138?style=flat&logo=swift&logoColor=white" alt="Swift 5.9+"></a>
  <a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-15.0+-000000?style=flat&logo=apple&logoColor=white" alt="iOS 15.0+"></a>
  <a href="https://developer.apple.com/visionos/"><img src="https://img.shields.io/badge/visionOS-1.0+-007AFF?style=flat&logo=apple&logoColor=white" alt="visionOS"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="MIT License"></a>
  <a href="https://github.com/muhittincamdali/iOSAppTemplates/actions"><img src="https://github.com/muhittincamdali/iOSAppTemplates/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
</p>

<p align="center">
  <b>Production-ready iOS app templates with Clean Architecture, MVVM, and TCA patterns.</b>
</p>

<p align="center">
  <a href="#templates">Templates</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#architecture">Architecture</a> •
  <a href="Documentation/">Documentation</a>
</p>

---

## Demo

<p align="center">
  <img src="Assets/demo.gif" alt="Demo" width="300">
</p>

## Templates

| Category | Templates | Description |
|----------|-----------|-------------|
| **Social** | Feed, Profile, Chat, Stories | Complete social networking features |
| **E-Commerce** | Product List, Cart, Checkout, Orders | Full shopping experience |
| **Finance** | Dashboard, Transactions, Cards | Banking & fintech apps |
| **Health** | Tracker, Workouts, Nutrition | HealthKit integration |
| **Education** | Courses, Quiz, Progress | Learning platform |
| **Travel** | Search, Booking, Itinerary | Travel & booking apps |
| **AI** | Chat, Image Gen, Voice | Core ML integration |
| **Productivity** | Tasks, Calendar, Notes | GTD apps |

## Quick Start

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOSAppTemplates.git", from: "1.0.0")
]
```

### Usage

```swift
import iOSAppTemplates

// Social Media App
let socialApp = SocialMediaTemplate()
    .withFeatures([.feed, .stories, .messaging, .profile])
    .withArchitecture(.mvvm)
    .build()

// E-Commerce App  
let shopApp = ECommerceTemplate()
    .withFeatures([.productList, .cart, .checkout, .orders])
    .withPayment([.applePay, .stripe])
    .build()

// Finance App
let financeApp = FinanceTemplate()
    .withFeatures([.dashboard, .transactions, .cards])
    .withSecurity(.biometric)
    .build()
```

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Presentation                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │   View   │  │ ViewModel│  │Coordinator│          │
│  └──────────┘  └──────────┘  └──────────┘          │
├─────────────────────────────────────────────────────┤
│                     Domain                           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │ Use Case │  │  Entity  │  │Repository│          │
│  │          │  │          │  │ Protocol │          │
│  └──────────┘  └──────────┘  └──────────┘          │
├─────────────────────────────────────────────────────┤
│                      Data                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │Repository│  │  Network │  │  Storage │          │
│  │   Impl   │  │  Service │  │  Service │          │
│  └──────────┘  └──────────┘  └──────────┘          │
└─────────────────────────────────────────────────────┘
```

### Supported Patterns

- **MVVM-C** — Model-View-ViewModel with Coordinator
- **TCA** — The Composable Architecture
- **Clean Architecture** — Domain-driven design

## Project Structure

```
iOSAppTemplates/
├── Sources/
│   ├── Core/                  # Shared utilities
│   ├── SocialTemplates/       # Social media templates
│   ├── CommerceTemplates/     # E-commerce templates
│   ├── FinanceTemplates/      # Finance templates
│   ├── HealthTemplates/       # Health & fitness
│   ├── EducationTemplates/    # Education templates
│   ├── TravelTemplates/       # Travel & booking
│   ├── AITemplates/           # AI-powered templates
│   └── ProductivityTemplates/ # Productivity apps
├── Examples/                  # Sample implementations
├── Tests/                     # Unit & UI tests
└── Documentation/             # Guides & API docs
```

## Examples

### Social Feed

```swift
struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.posts) { post in
                    PostCard(post: post)
                        .onTapGesture {
                            viewModel.openPost(post)
                        }
                }
            }
            .padding()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}
```

### E-Commerce Cart

```swift
struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                CartItemRow(item: item)
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.remove(item)
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
            }
            
            Section {
                HStack {
                    Text("Total")
                        .font(.headline)
                    Spacer()
                    Text(viewModel.total, format: .currency(code: "USD"))
                        .font(.title2.bold())
                }
            }
        }
    }
}
```

## Requirements

| Platform | Version |
|----------|---------|
| iOS | 15.0+ |
| macOS | 12.0+ |
| visionOS | 1.0+ |
| Swift | 5.9+ |
| Xcode | 15.0+ |

## Installation

### Xcode

1. File → Add Package Dependencies
2. Enter: `https://github.com/muhittincamdali/iOSAppTemplates.git`
3. Select version and add

### Manual

Clone and drag the `Sources` folder into your project.

## Documentation

- [Getting Started](Documentation/Guides/QuickStart.md)
- [Template Guide](Documentation/TemplateGuide.md)
- [Architecture Guide](Documentation/ArchitectureTemplatesGuide.md)
- [API Reference](Documentation/API-Reference.md)
- [Best Practices](Documentation/BestPracticesGuide.md)

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md).

1. Fork the repo
2. Create feature branch (`git checkout -b feature/new-template`)
3. Commit changes (`git commit -m 'Add new template'`)
4. Push (`git push origin feature/new-template`)
5. Open Pull Request

## License

MIT License. See [LICENSE](LICENSE).

## Author

**Muhittin Camdali**
- GitHub: [@muhittincamdali](https://github.com/muhittincamdali)

---

<p align="center">
  <sub>Built with ❤️ for the iOS community</sub>
</p>
