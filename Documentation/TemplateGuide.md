# 📋 Template Guide

<!-- TOC START -->
## Table of Contents
- [📋 Template Guide](#-template-guide)
- [📋 Table of Contents](#-table-of-contents)
- [🏗️ Template Structure](#-template-structure)
  - [**Standard Template Structure**](#standard-template-structure)
- [🎨 Customization Guide](#-customization-guide)
  - [**Branding Customization**](#branding-customization)
    - [**App Colors**](#app-colors)
    - [**App Fonts**](#app-fonts)
    - [**App Icons**](#app-icons)
  - [**Configuration Customization**](#configuration-customization)
    - [**App Configuration**](#app-configuration)
    - [**Network Configuration**](#network-configuration)
    - [**Database Configuration**](#database-configuration)
- [🚀 Template Features](#-template-features)
  - [**Common Features**](#common-features)
  - [**Template-Specific Features**](#template-specific-features)
    - [**Social Media Template**](#social-media-template)
    - [**E-commerce Template**](#e-commerce-template)
    - [**Fitness Template**](#fitness-template)
- [📱 UI Customization](#-ui-customization)
  - [**Custom Components**](#custom-components)
  - [**Theme Support**](#theme-support)
- [🔧 Advanced Customization](#-advanced-customization)
  - [**Dependency Management**](#dependency-management)
  - [**Third-Party Integrations**](#third-party-integrations)
- [🚀 Deployment](#-deployment)
  - [**App Store Preparation**](#app-store-preparation)
  - [**TestFlight Distribution**](#testflight-distribution)
- [Archive the app](#archive-the-app)
- [Upload to App Store Connect](#upload-to-app-store-connect)
  - [**CI/CD Pipeline**](#cicd-pipeline)
- [GitHub Actions workflow](#github-actions-workflow)
- [📚 Next Steps](#-next-steps)
- [🤝 Support](#-support)
<!-- TOC END -->


Complete guide for customizing and using iOS App Templates.

## 📋 Table of Contents

- [Template Structure](#template-structure)
- [Customization Guide](#customization-guide)
- [Branding](#branding)
- [Configuration](#configuration)
- [Deployment](#deployment)

## 🏗️ Template Structure

### **Standard Template Structure**
```
TemplateName/
├── TemplateName.xcodeproj
├── TemplateName/
│   ├── App/
│   │   ├── AppDelegate.swift
│   │   ├── SceneDelegate.swift
│   │   └── App.swift
│   ├── Presentation/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Coordinators/
│   ├── Domain/
│   │   ├── Entities/
│   │   ├── UseCases/
│   │   └── Protocols/
│   ├── Data/
│   │   ├── Repositories/
│   │   ├── DataSources/
│   │   └── DTOs/
│   └── Infrastructure/
│       ├── Network/
│       ├── Storage/
│       └── Utils/
├── Resources/
│   ├── Assets.xcassets/
│   ├── Localizable.strings
│   └── Info.plist
└── Tests/
    ├── UnitTests/
    ├── UITests/
    └── IntegrationTests/
```

## 🎨 Customization Guide

### **Branding Customization**

#### **App Colors**
```swift
// Update in AppColors.swift
struct AppColors {
    // Primary brand colors
    static let primary = Color(hex: "#YourBrandColor")
    static let primaryDark = Color(hex: "#YourBrandDarkColor")
    static let primaryLight = Color(hex: "#YourBrandLightColor")
    
    // Secondary colors
    static let secondary = Color(hex: "#YourSecondaryColor")
    static let accent = Color(hex: "#YourAccentColor")
    
    // Semantic colors
    static let success = Color(hex: "#34C759")
    static let warning = Color(hex: "#FF9500")
    static let error = Color(hex: "#FF3B30")
}
```

#### **App Fonts**
```swift
// Update in AppFonts.swift
struct AppFonts {
    // Headings
    static let h1 = Font.custom("YourFont-Bold", size: 32)
    static let h2 = Font.custom("YourFont-Bold", size: 28)
    static let h3 = Font.custom("YourFont-Medium", size: 24)
    
    // Body text
    static let bodyLarge = Font.custom("YourFont-Regular", size: 18)
    static let body = Font.custom("YourFont-Regular", size: 16)
    static let bodySmall = Font.custom("YourFont-Regular", size: 14)
    
    // Buttons
    static let button = Font.custom("YourFont-Semibold", size: 16)
}
```

#### **App Icons**
1. **Replace App Icon**: Update `Assets.xcassets/AppIcon.appiconset`
2. **Add Custom Icons**: Create custom SF Symbols or image assets
3. **Update Launch Screen**: Customize launch screen design

### **Configuration Customization**

#### **App Configuration**
```swift
// Update in AppConfig.swift
struct AppConfig {
    static let appName = "Your App Name"
    static let appVersion = "1.0.0"
    static let buildNumber = "1"
    static let bundleIdentifier = "com.yourcompany.yourapp"
    
    // API Configuration
    static let apiBaseURL = "https://your-api.com"
    static let apiVersion = "v1"
    static let apiKey = "your-api-key"
    
    // Feature Flags
    static let enableAnalytics = true
    static let enableCrashReporting = true
    static let enablePushNotifications = true
}
```

#### **Network Configuration**
```swift
// Update in NetworkConfig.swift
struct NetworkConfig {
    static let baseURL = "https://your-api.com"
    static let timeout = 30.0
    static let retryCount = 3
    static let cachePolicy = URLRequest.CachePolicy.returnCacheDataElseLoad
}
```

#### **Database Configuration**
```swift
// Update in DatabaseConfig.swift
struct DatabaseConfig {
    static let modelName = "YourAppModel"
    static let storeType = NSSQLiteStoreType
    static let enableMigration = true
    static let enableLightweightMigration = true
}
```

## 🚀 Template Features

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

### **Template-Specific Features**

#### **Social Media Template**
```swift
// Features included
- User authentication and profiles
- Feed with posts and stories
- Comments and likes system
- Real-time updates
- Media sharing
- Direct messaging
- Notifications
```

#### **E-commerce Template**
```swift
// Features included
- Product catalog and search
- Shopping cart management
- Checkout process
- Payment integration (Stripe)
- Order tracking
- User reviews
- Wishlist
- Push notifications
```

#### **Fitness Template**
```swift
// Features included
- Workout tracking
- Progress charts
- Goal setting
- HealthKit integration
- Achievement system
- Social features
- Nutrition tracking
- Sleep monitoring
```

## 📱 UI Customization

### **Custom Components**
```swift
// Custom button styles
struct CustomButton: View {
    let title: String
    let style: ButtonStyle
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.button)
                .foregroundColor(style.textColor)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
                .background(style.backgroundColor)
                .cornerRadius(AppRadius.md)
        }
    }
}

// Custom card styles
struct CustomCard: View {
    let title: String
    let subtitle: String?
    let image: String?
    let action: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Card content
        }
        .background(AppColors.surface)
        .cornerRadius(AppRadius.md)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
```

### **Theme Support**
```swift
// Light and dark theme support
struct AppTheme {
    static let light = Theme(
        colors: LightColorPalette(),
        fonts: DefaultFontPalette(),
        spacing: DefaultSpacingPalette()
    )
    
    static let dark = Theme(
        colors: DarkColorPalette(),
        fonts: DefaultFontPalette(),
        spacing: DefaultSpacingPalette()
    )
}
```

## 🔧 Advanced Customization

### **Dependency Management**
```swift
// Swift Package Manager dependencies
dependencies: [
    .package(url: "https://github.com/your-dependency", from: "1.0.0"),
    .package(url: "https://github.com/another-dependency", from: "2.0.0")
]

// CocoaPods dependencies
pod 'YourDependency', '~> 1.0'
pod 'AnotherDependency', '~> 2.0'
```

### **Third-Party Integrations**
```swift
// Firebase configuration
struct FirebaseConfig {
    static let googleServiceInfoPlist = "GoogleService-Info"
    static let enableAnalytics = true
    static let enableCrashlytics = true
    static let enablePerformance = true
}

// Stripe configuration
struct StripeConfig {
    static let publishableKey = "pk_test_your_key"
    static let secretKey = "sk_test_your_key"
}
```

## 🚀 Deployment

### **App Store Preparation**
1. **Update Bundle Identifier**: Change in project settings
2. **Configure Code Signing**: Select development team
3. **Add App Icons**: Generate all required sizes
4. **Create Screenshots**: For all device sizes
5. **Write App Description**: Compelling app description
6. **Add Keywords**: Optimize for App Store search
7. **Set Categories**: Choose appropriate categories

### **TestFlight Distribution**
```bash
# Archive the app
xcodebuild archive -scheme YourApp -archivePath YourApp.xcarchive

# Upload to App Store Connect
xcodebuild -exportArchive -archivePath YourApp.xcarchive -exportPath ./build -exportOptionsPlist ExportOptions.plist
```

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
        run: xcodebuild test -scheme YourApp
      - name: Build Archive
        run: xcodebuild archive -scheme YourApp
```

## 📚 Next Steps

1. **Read [Getting Started](GettingStarted.md)** for quick setup
2. **Explore [Architecture Guide](Architecture.md)** for system design
3. **Check [UI Components](UIComponents.md)** for component library
4. **Review [API Reference](API.md)** for complete documentation

## 🤝 Support

- **Documentation**: [Complete Documentation](Documentation/)
- **Issues**: [GitHub Issues](https://github.com/muhittincamdali/iOSAppTemplates/issues)
- **Discussions**: [GitHub Discussions](https://github.com/muhittincamdali/iOSAppTemplates/discussions)

---

**Happy coding with iOS App Templates! 🚀** 