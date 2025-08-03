# 📱 iOS App Templates Collection

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20iPadOS-lightgrey.svg)](https://developer.apple.com/)
[![Documentation](https://img.shields.io/badge/Documentation-Complete-blue.svg)](Documentation/)
[![Templates](https://img.shields.io/badge/Templates-3+-yellow.svg)](Templates/)
[![Stars](https://img.shields.io/github/stars/muhittincamdali/iOSAppTemplates?style=social)](https://github.com/muhittincamdali/iOSAppTemplates)
[![Forks](https://img.shields.io/github/forks/muhittincamdali/iOSAppTemplates?style=social)](https://github.com/muhittincamdali/iOSAppTemplates)

**Professional iOS App Templates Collection - Ready-to-use templates for different app types**

A comprehensive collection of production-ready iOS app templates built with Clean Architecture, MVVM, and modern SwiftUI. Each template is designed to accelerate your iOS development process with enterprise-grade quality.

## 🚀 Available Templates

### 📱 **Social Media App Template**
- **Features**: User authentication, feed, posts, comments, likes, profiles
- **Architecture**: Clean Architecture + MVVM
- **UI**: Modern SwiftUI with custom components
- **Backend**: Firebase integration ready
- **Status**: ✅ Production Ready
- **Location**: `Templates/SocialMediaApp/`

### 🛒 **E-commerce App Template**
- **Features**: Product catalog, shopping cart, checkout, payment, orders
- **Architecture**: Clean Architecture + MVVM
- **UI**: Professional e-commerce design
- **Payment**: Stripe integration ready
- **Status**: ✅ Production Ready
- **Location**: `Templates/EcommerceApp/`

### 💪 **Fitness App Template**
- **Features**: Workout tracking, progress charts, goals, achievements
- **Architecture**: Clean Architecture + MVVM
- **UI**: Health-focused design with charts
- **HealthKit**: Apple Health integration
- **Status**: ✅ Production Ready
- **Location**: `Templates/FitnessApp/`

## 🏗️ Architecture

### **Clean Architecture**
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

### **MVVM Pattern**
- **Views**: SwiftUI views with minimal logic
- **ViewModels**: Business logic and state management
- **Models**: Data models and entities
- **Services**: Network, storage, and utility services

## 🛠️ Quick Start

### **Installation**

#### **Clone Template**
```bash
# Clone the repository
git clone https://github.com/muhittincamdali/iOSAppTemplates.git

# Navigate to specific template
cd Templates/SocialMediaApp
```

#### **Open in Xcode**
```bash
# Open the project
open SocialMediaApp.xcodeproj

# Or open workspace if using CocoaPods
open SocialMediaApp.xcworkspace
```

#### **Configure Project**
1. **Bundle Identifier**: Update in project settings
2. **Team**: Select your development team
3. **Signing**: Configure code signing
4. **Dependencies**: Install required dependencies

### **Customization**

#### **Branding**
```swift
// Update app colors
struct AppColors {
    static let primary = Color("PrimaryColor")
    static let secondary = Color("SecondaryColor")
    static let accent = Color("AccentColor")
}

// Update app fonts
struct AppFonts {
    static let title = Font.custom("YourFont-Bold", size: 24)
    static let body = Font.custom("YourFont-Regular", size: 16)
}
```

#### **Configuration**
```swift
// Update API endpoints
struct APIConfig {
    static let baseURL = "https://your-api.com"
    static let apiKey = "your-api-key"
}

// Update app settings
struct AppConfig {
    static let appName = "Your App Name"
    static let appVersion = "1.0.0"
    static let buildNumber = "1"
}
```

## 📱 Template Features

### **Common Features**
- ✅ **User Authentication**: Login, registration, password reset
- ✅ **Profile Management**: User profiles, settings, preferences
- ✅ **Navigation**: Tab bar, navigation stack, deep linking
- ✅ **Data Persistence**: Core Data, UserDefaults, Keychain
- ✅ **Network Layer**: RESTful API client with error handling
- ✅ **Image Loading**: Async image loading with caching
- ✅ **Push Notifications**: Local and remote notifications
- ✅ **Analytics**: Firebase Analytics integration
- ✅ **Crash Reporting**: Firebase Crashlytics integration
- ✅ **Testing**: Unit tests, UI tests, integration tests

### **UI Components**
- ✅ **Custom Buttons**: Primary, secondary, outline styles
- ✅ **Cards**: Product cards, post cards, info cards
- ✅ **Lists**: Custom list views with animations
- ✅ **Forms**: Input fields, validation, error handling
- ✅ **Modals**: Custom modal presentations
- ✅ **Charts**: Progress charts, analytics charts
- ✅ **Animations**: Smooth transitions and micro-interactions

### **Performance Features**
- ✅ **Lazy Loading**: Efficient data loading
- ✅ **Image Caching**: Memory and disk caching
- ✅ **Background Processing**: Offline data sync
- ✅ **Memory Management**: Automatic memory cleanup
- ✅ **Battery Optimization**: Efficient resource usage

## 🎨 Design System

### **Color Palette**
```swift
struct AppColors {
    // Primary Colors
    static let primary = Color(hex: "#007AFF")
    static let primaryDark = Color(hex: "#0056CC")
    
    // Secondary Colors
    static let secondary = Color(hex: "#5856D6")
    static let secondaryLight = Color(hex: "#7B7AFF")
    
    // Accent Colors
    static let accent = Color(hex: "#FF9500")
    static let accentLight = Color(hex: "#FFB340")
    
    // Neutral Colors
    static let background = Color(hex: "#F2F2F7")
    static let surface = Color.white
    static let text = Color(hex: "#1C1C1E")
    static let textSecondary = Color(hex: "#8E8E93")
}
```

### **Typography**
```swift
struct AppFonts {
    // Headings
    static let h1 = Font.system(size: 32, weight: .bold)
    static let h2 = Font.system(size: 28, weight: .semibold)
    static let h3 = Font.system(size: 24, weight: .medium)
    
    // Body Text
    static let bodyLarge = Font.system(size: 18, weight: .regular)
    static let body = Font.system(size: 16, weight: .regular)
    static let bodySmall = Font.system(size: 14, weight: .regular)
    
    // Captions
    static let caption = Font.system(size: 12, weight: .regular)
    static let captionSmall = Font.system(size: 10, weight: .regular)
}
```

### **Spacing**
```swift
struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}
```

## 📚 Documentation

- **[Getting Started](Documentation/GettingStarted.md)** - Quick setup guide
- **[Template Guide](Documentation/TemplateGuide.md)** - Template customization
- **[Architecture Guide](Documentation/Architecture.md)** - System architecture
- **[UI Components](Documentation/UIComponents.md)** - Component library
- **[API Reference](Documentation/API.md)** - Complete API documentation

## 🧪 Testing

### **Test Coverage**
```bash
# Run all tests
xcodebuild test -scheme SocialMediaApp -destination 'platform=iOS Simulator,name=iPhone 14'

# Run specific test categories
xcodebuild test -scheme SocialMediaApp -only-testing:UnitTests
xcodebuild test -scheme SocialMediaApp -only-testing:UITests
```

### **Test Structure**
```
Tests/
├── UnitTests/
│   ├── Domain/
│   ├── Data/
│   └── Presentation/
├── UITests/
│   ├── FlowTests/
│   └── ComponentTests/
└── IntegrationTests/
```

## 🚀 Deployment

### **App Store Preparation**
1. **App Icon**: Generate all required sizes
2. **Screenshots**: Create for all device sizes
3. **Metadata**: App description, keywords, categories
4. **Privacy**: Privacy policy and data usage
5. **Testing**: TestFlight distribution

### **CI/CD Pipeline**
```yaml
# GitHub Actions workflow
name: iOS CI/CD
on: [push, pull_request]
jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Tests
        run: xcodebuild test -scheme SocialMediaApp
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### **Development Setup**
```bash
# Fork the repository
git clone https://github.com/your-username/iOSAppTemplates.git

# Create feature branch
git checkout -b feature/new-template

# Make changes and commit
git add .
git commit -m "feat: add new template"

# Push and create pull request
git push origin feature/new-template
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Apple for SwiftUI and iOS frameworks
- The iOS development community
- Contributors and maintainers

## 📞 Support

- **Documentation**: [Complete Documentation](Documentation/)
- **Issues**: [GitHub Issues](https://github.com/muhittincamdali/iOSAppTemplates/issues)
- **Discussions**: [GitHub Discussions](https://github.com/muhittincamdali/iOSAppTemplates/discussions)

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=muhittincamdali/iOSAppTemplates&type=Date)](https://star-history.com/#muhittincamdali/iOSAppTemplates&Date)

---

**Made with ❤️ for the iOS development community**

[![GitHub stars](https://img.shields.io/github/stars/muhittincamdali/iOSAppTemplates?style=social)](https://github.com/muhittincamdali/iOSAppTemplates)
[![GitHub forks](https://img.shields.io/github/forks/muhittincamdali/iOSAppTemplates?style=social)](https://github.com/muhittincamdali/iOSAppTemplates)
[![GitHub watchers](https://img.shields.io/github/watchers/muhittincamdali/iOSAppTemplates?style=social)](https://github.com/muhittincamdali/iOSAppTemplates) 