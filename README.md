```

<p align="center">
  <a href="README.md">🇺🇸 English</a> |
  <a href="README_TR.md">🇹🇷 Türkçe</a>
</p>

╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║   ██╗ ██████╗ ███████╗     █████╗ ██████╗ ██████╗                               ║
║   ██║██╔═══██╗██╔════╝    ██╔══██╗██╔══██╗██╔══██╗                              ║
║   ██║██║   ██║███████╗    ███████║██████╔╝██████╔╝                              ║
║   ██║██║   ██║╚════██║    ██╔══██║██╔═══╝ ██╔═══╝                               ║
║   ██║╚██████╔╝███████║    ██║  ██║██║     ██║                                   ║
║   ╚═╝ ╚═════╝ ╚══════╝    ╚═╝  ╚═╝╚═╝     ╚═╝                                   ║
║                                                                                  ║
║   ████████╗███████╗███╗   ███╗██████╗ ██╗      █████╗ ████████╗███████╗███████╗ ║
║   ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗██║     ██╔══██╗╚══██╔══╝██╔════╝██╔════╝ ║
║      ██║   █████╗  ██╔████╔██║██████╔╝██║     ███████║   ██║   █████╗  ███████╗ ║
║      ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝ ██║     ██╔══██║   ██║   ██╔══╝  ╚════██║ ║
║      ██║   ███████╗██║ ╚═╝ ██║██║     ███████╗██║  ██║   ██║   ███████╗███████║ ║
║      ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝ ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
```

<div align="center">

**10 production-ready iOS app templates with Clean Architecture, MVVM-C, and TCA patterns.<br/>Stop building boilerplate. Start shipping features.**

[![Stars](https://img.shields.io/github/stars/muhittincamdali/iOSAppTemplates?style=for-the-badge&color=yellow&label=⭐%20Stars)](https://github.com/muhittincamdali/iOSAppTemplates/stargazers)
[![Swift](https://img.shields.io/badge/Swift-5.9+-F05138?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-15.0+-000000?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![visionOS](https://img.shields.io/badge/visionOS-1.0+-007AFF?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/visionos/)
[![SPM](https://img.shields.io/badge/SPM-Compatible-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![CI](https://github.com/muhittincamdali/iOSAppTemplates/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/muhittincamdali/iOSAppTemplates/actions)

[Features](#-features) • [Quick Start](#-quick-start) • [Templates](#-templates) • [Architecture](#-architecture) • [Who Is This For?](#-who-is-this-for) • [Docs](Documentation/)

</div>

---

## 👤 Who Is This For?

| You are... | This helps you... |
|---|---|
| 🧑‍💻 **Solo indie developer** | Skip weeks of setup. Get a working app skeleton with auth, networking, and navigation in minutes. |
| 👥 **Small team / startup** | Align the whole team on architecture from day one. Every template follows the same conventions. |
| 📚 **Student / learner** | Study real-world patterns (MVVM-C, TCA, Clean Architecture) in complete, runnable projects. |
| 🏢 **Agency developer** | Pitch faster. Prototype client apps with full-featured templates, then customize. |
| 🔄 **Switching from UIKit** | Every template is 100% SwiftUI with modern concurrency. Learn by reading production-quality code. |

---

## ✨ Features

- 🏗️ **Clean Architecture** — Domain-driven design with clear separation
- 📱 **10 App Categories** — E-Commerce, Social, News, Fitness, Finance, Education, Food, Travel, Music, Productivity
- 🎯 **Multiple Patterns** — MVVM-C, TCA, and Clean Architecture support
- 🧪 **Fully Tested** — Unit tests, UI tests, and snapshot tests included
- 📖 **Well Documented** — Comprehensive guides and API reference
- 🌙 **Dark Mode** — Full dark mode support out of the box
- ♿ **Accessible** — VoiceOver and Dynamic Type ready
- 🚀 **Production Ready** — Used in real App Store apps
- 🛠️ **CLI Generator** — One command to scaffold a new project
- 📱 **150+ Screens** — Total across all templates

---

## 🏗️ Architecture

```mermaid
graph TB
    subgraph Presentation["📱 Presentation Layer"]
        V[View]
        VM[ViewModel]
        C[Coordinator]
    end
    
    subgraph Domain["🎯 Domain Layer"]
        UC[Use Cases]
        E[Entities]
        RP[Repository Protocol]
    end
    
    subgraph Data["💾 Data Layer"]
        RI[Repository Impl]
        NS[Network Service]
        SS[Storage Service]
    end
    
    V --> VM
    VM --> C
    VM --> UC
    UC --> E
    UC --> RP
    RI --> RP
    RI --> NS
    RI --> SS
    
    style Presentation fill:#4A90D9,stroke:#2E5A8B,color:#fff
    style Domain fill:#50C878,stroke:#3D9B5C,color:#fff
    style Data fill:#FF6B6B,stroke:#CC5555,color:#fff
```

---

## 🚀 Quick Start

### Option 1: Swift Package Manager

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/iOSAppTemplates.git", from: "1.0.0")
]
```

### Option 2: Template Generator CLI (Recommended)

Generate a complete, ready-to-run Xcode project in seconds:

```bash
# Clone the repo
git clone https://github.com/muhittincamdali/iOSAppTemplates.git
cd iOSAppTemplates

# Interactive mode — pick a template, name your app, done
swift Scripts/TemplateGenerator.swift --interactive

# Or generate directly
swift Scripts/TemplateGenerator.swift -t ecommerce -n "MyShop" -o ~/Desktop

# See all available templates
swift Scripts/TemplateGenerator.swift --list
```

Available templates: `ecommerce` · `social` · `news` · `fitness` · `finance` · `education` · `food` · `travel` · `music` · `productivity`

### Option 3: Use as Code Reference

```swift
import iOSAppTemplates

// Social Media App — ready in seconds
let socialApp = SocialMediaTemplate()
    .withFeatures([.feed, .stories, .messaging, .profile])
    .withArchitecture(.mvvm)
    .build()

// E-Commerce App — complete shopping experience
let shopApp = ECommerceTemplate()
    .withFeatures([.productList, .cart, .checkout, .orders])
    .withPayment([.applePay, .stripe])
    .build()

// Finance App — bank-level security
let financeApp = FinanceTemplate()
    .withFeatures([.dashboard, .transactions, .cards])
    .withSecurity(.biometric)
    .build()
```

---

## 📦 Templates (10 Complete Apps!)

| # | Category | Screens | Key Features | Status |
|:-:|:--------:|:-------:|--------------|:------:|
| 1 | 🛒 **E-Commerce** | 16+ | Products, Cart, Checkout, Orders, Reviews, Wishlist | ✅ Complete |
| 2 | 📱 **Social Media** | 16+ | Feed, Stories, Reels, Messages, Profile, Notifications | ✅ Complete |
| 3 | 📰 **News / Blog** | 14+ | Articles, Categories, Bookmarks, Reader Mode, Search | ✅ Complete |
| 4 | 🏃 **Fitness / Health** | 15+ | Workouts, Activity, Nutrition, Progress, Achievements | ✅ Complete |
| 5 | 💰 **Finance** | 15+ | Dashboard, Cards, Transactions, Budget, Investments | ✅ Complete |
| 6 | 📚 **Education** | 14+ | Courses, Lessons, Quizzes, Progress, Certificates | ✅ Complete |
| 7 | 🍕 **Food Delivery** | 17+ | Restaurants, Menu, Cart, Orders, Live Tracking | ✅ Complete |
| 8 | ✈️ **Travel** | 12+ | Destinations, Flights, Hotels, Bookings, Itinerary | ✅ Complete |
| 9 | 🎵 **Music / Podcast** | 14+ | Player, Playlists, Library, Podcasts, Search | ✅ Complete |
| 10 | ✅ **Productivity** | 12+ | Tasks, Projects, Notes, Focus Mode, Habits | ✅ Complete |

> **Every template includes:** Dark Mode · Accessibility · Sample Data · Working Navigation · No Placeholders

---

## 📁 Project Structure

```
iOSAppTemplates/
├── 📂 Sources/
│   ├── Core/                    # Shared utilities & extensions
│   ├── SocialTemplates/         # Social media templates
│   ├── CommerceTemplates/       # E-commerce templates
│   ├── FinanceTemplates/        # Finance templates
│   ├── HealthTemplates/         # Health & fitness
│   ├── EducationTemplates/      # Education templates
│   ├── TravelTemplates/        # Travel & booking
│   ├── AITemplates/             # AI-powered templates
│   └── ProductivityTemplates/   # Productivity apps
├── 📂 Examples/                 # Sample implementations
├── 📂 Tests/                    # Unit & UI tests
└── 📂 Documentation/            # Guides & API docs
```

---

## 💻 Code Examples

### Social Feed

```swift
struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.posts) { post in
                    PostCard(post: post)
                        .onTapGesture { viewModel.openPost(post) }
                }
            }
            .padding()
        }
        .refreshable { await viewModel.refresh() }
    }
}
```

### Shopping Cart

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
                    Text("Total").font(.headline)
                    Spacer()
                    Text(viewModel.total, format: .currency(code: "USD"))
                        .font(.title2.bold())
                }
            }
        }
    }
}
```

---

## 📋 Requirements

| Requirement | Version |
|-------------|---------|
| iOS | 15.0+ |
| macOS | 12.0+ |
| visionOS | 1.0+ |
| Swift | 5.9+ |
| Xcode | 15.0+ |

---

## 📖 Documentation

| Guide | Description |
|-------|-------------|
| [Getting Started](Documentation/Guides/QuickStart.md) | Installation and first steps |
| [Template Guide](Documentation/TemplateGuide.md) | How to use each template |
| [Architecture Guide](Documentation/ArchitectureTemplatesGuide.md) | MVVM-C, TCA, Clean Architecture |
| [API Reference](Documentation/API-Reference.md) | Complete API documentation |
| [Best Practices](Documentation/BestPracticesGuide.md) | Tips for production apps |

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md).

```bash
# Fork, clone, and create a branch
git checkout -b feature/new-template

# Make changes and commit
git commit -m "feat(templates): add new template"

# Push and open PR
git push origin feature/new-template
```

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

<div align="center">

## 👨‍💻 Author

**Muhittin Camdali**

[![GitHub](https://img.shields.io/badge/GitHub-muhittincamdali-181717?style=for-the-badge&logo=github)](https://github.com/muhittincamdali)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&logo=linkedin)](https://linkedin.com/in/muhittincamdali)

---

**⭐ Star this repo if you find it useful!**

---

## 📈 Star History

<a href="https://star-history.com/#muhittincamdali/iOSAppTemplates&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/iOSAppTemplates&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/iOSAppTemplates&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=muhittincamdali/iOSAppTemplates&type=Date" />
 </picture>
</a>

---

## 🙏 Contributors

Thanks to all the amazing people who have contributed!

<a href="https://github.com/muhittincamdali/iOSAppTemplates/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=muhittincamdali/iOSAppTemplates" />
</a>

</div>
