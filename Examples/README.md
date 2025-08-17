# 📱 iOS App Templates - Example Projects

## Overview

This directory contains production-ready example projects demonstrating the full capabilities of the iOS App Templates framework. Each example is a complete, runnable application with comprehensive documentation.

## 🚀 Quick Start Examples

### 1. Social Media App
A complete social media application with real-time messaging, user profiles, and content sharing.

**Features:**
- User authentication with Face ID/Touch ID
- Real-time feed with 120fps scrolling
- Post creation with media support
- Secure messaging with AES-256 encryption
- Push notifications
- Dark mode support

[📂 View Source](./SocialMediaExample/)

### 2. E-Commerce App
Full-featured shopping application with product catalog, cart, and payment processing.

**Features:**
- Product browsing with advanced filters
- Shopping cart with persistence
- Apple Pay integration
- Order tracking
- Wishlist functionality
- Product reviews and ratings

[📂 View Source](./ECommerceExample/)

### 3. Vision Pro Spatial App
Revolutionary spatial computing application for Apple Vision Pro.

**Features:**
- 3D content display
- Hand tracking interactions
- Eye tracking navigation
- Immersive environments
- Multi-user sessions
- Spatial audio

[📂 View Source](./VisionProExample/)

## 🏗️ Architecture Examples

### TCA (The Composable Architecture)
Modern unidirectional data flow architecture with comprehensive state management.

[📂 View Example](./TCAExample/)

### MVVM + Clean Architecture
Enterprise-grade architecture with clear separation of concerns.

[📂 View Example](./MVVMCleanExample/)

## 🎯 Running the Examples

### Prerequisites
- Xcode 16.0+
- iOS 18.0+ Simulator or Device
- Swift 6.0+
- (Optional) Apple Vision Pro for spatial examples

### Installation Steps

1. **Clone the repository:**
```bash
git clone https://github.com/muhittincamdali/iOSAppTemplates.git
cd iOSAppTemplates/Examples
```

2. **Open the example project:**
```bash
cd SocialMediaExample
open SocialMediaExample.xcodeproj
```

3. **Build and run:**
- Select your target device/simulator
- Press ⌘R to build and run

## 📊 Example Categories

| Category | Examples | Features |
|----------|----------|----------|
| **Social & Networking** | Social Media, Messaging | Real-time updates, multimedia sharing |
| **Commerce** | E-Commerce, Marketplace | Payments, inventory, orders |
| **Productivity** | Task Manager, Notes | Sync, collaboration, widgets |
| **Entertainment** | Video Streaming, Music | Media playback, offline support |
| **Finance** | Banking, Crypto | Security, transactions, charts |
| **Health & Fitness** | Workout Tracker | HealthKit, activity tracking |
| **Education** | Learning Platform | Progress tracking, quizzes |
| **Enterprise** | CRM, Analytics | Data visualization, reports |

## 🔧 Customization

Each example can be customized for your specific needs:

1. **Branding**: Update colors, fonts, and assets in `Resources/`
2. **Features**: Enable/disable features in `Configuration.swift`
3. **Backend**: Configure your API endpoints in `NetworkConfig.swift`
4. **Analytics**: Add your tracking codes in `Analytics.swift`

## 📚 Learning Resources

- [First App Tutorial](../Documentation/FirstApp.md) - Step-by-step guide
- [Architecture Guide](../Documentation/Guides/ArchitectureGuide.md) - Design patterns
- [Best Practices](../Documentation/BestPracticesGuide.md) - iOS development standards
- [API Reference](../Documentation/API-Reference.md) - Complete framework documentation

## 🤝 Contributing

We welcome contributions! To add a new example:

1. Create a new directory under `Examples/`
2. Include a complete Xcode project
3. Add comprehensive README documentation
4. Ensure >95% test coverage
5. Submit a pull request

## 📄 License

All examples are provided under the MIT License. See [LICENSE](../LICENSE) for details.

## 🆘 Support

- **GitHub Issues**: [Report bugs](https://github.com/muhittincamdali/iOSAppTemplates/issues)
- **Discussions**: [Community forum](https://github.com/muhittincamdali/iOSAppTemplates/discussions)
- **Documentation**: [Full docs](../Documentation/)

---

**Built with ❤️ by the iOS Community**