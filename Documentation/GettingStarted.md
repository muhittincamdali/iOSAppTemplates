# 🚀 Getting Started with iOS App Templates

<!-- TOC START -->
## Table of Contents
- [🚀 Getting Started with iOS App Templates](#-getting-started-with-ios-app-templates)
- [📋 Table of Contents](#-table-of-contents)
- [📦 Installation](#-installation)
  - [**Prerequisites**](#prerequisites)
  - [**Clone Repository**](#clone-repository)
- [Clone the repository](#clone-the-repository)
- [Navigate to the project](#navigate-to-the-project)
  - [**Select Template**](#select-template)
- [List available templates](#list-available-templates)
- [Navigate to specific template](#navigate-to-specific-template)
- [🎯 Template Selection](#-template-selection)
  - [**Social Media App Template**](#social-media-app-template)
  - [**E-commerce App Template**](#e-commerce-app-template)
  - [**Fitness App Template**](#fitness-app-template)
- [⚙️ Customization](#-customization)
  - [**Branding**](#branding)
  - [**Configuration**](#configuration)
  - [**Dependencies**](#dependencies)
- [🚀 Deployment](#-deployment)
  - [**App Store Preparation**](#app-store-preparation)
  - [**TestFlight Distribution**](#testflight-distribution)
- [Archive the app](#archive-the-app)
- [Upload to App Store Connect](#upload-to-app-store-connect)
- [🔧 Troubleshooting](#-troubleshooting)
  - [**Common Issues**](#common-issues)
    - [**Build Errors**](#build-errors)
- [Clean build folder](#clean-build-folder)
- [Reset package cache](#reset-package-cache)
    - [**Dependency Issues**](#dependency-issues)
- [Update Swift Package Manager](#update-swift-package-manager)
- [Or manually](#or-manually)
    - [**Code Signing Issues**](#code-signing-issues)
- [📚 Next Steps](#-next-steps)
- [🤝 Support](#-support)
<!-- TOC END -->


Quick start guide for using iOS App Templates Collection.

## 📋 Table of Contents

- [Installation](#installation)
- [Template Selection](#template-selection)
- [Customization](#customization)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)

## 📦 Installation

### **Prerequisites**
- Xcode 15.0+
- iOS 15.0+ deployment target
- Swift 5.9+
- macOS 13.0+

### **Clone Repository**
```bash
# Clone the repository
git clone https://github.com/muhittincamdali/iOSAppTemplates.git

# Navigate to the project
cd iOSAppTemplates
```

### **Select Template**
```bash
# List available templates
ls Templates/

# Navigate to specific template
cd Templates/SocialMediaApp
```

## 🎯 Template Selection

### **Social Media App Template**
```bash
cd Templates/SocialMediaApp
open SocialMediaApp.xcodeproj
```

**Features:**
- User authentication
- Feed with posts
- Comments and likes
- User profiles
- Real-time updates

### **E-commerce App Template**
```bash
cd Templates/EcommerceApp
open EcommerceApp.xcodeproj
```

**Features:**
- Product catalog
- Shopping cart
- Checkout process
- Payment integration
- Order management

### **Fitness App Template**
```bash
cd Templates/FitnessApp
open FitnessApp.xcodeproj
```

**Features:**
- Workout tracking
- Progress charts
- Goal setting
- HealthKit integration
- Achievement system

## ⚙️ Customization

### **Branding**
```swift
// Update app colors in AppColors.swift
struct AppColors {
    static let primary = Color(hex: "#YourBrandColor")
    static let secondary = Color(hex: "#YourSecondaryColor")
    static let accent = Color(hex: "#YourAccentColor")
}

// Update app fonts in AppFonts.swift
struct AppFonts {
    static let title = Font.custom("YourFont-Bold", size: 24)
    static let body = Font.custom("YourFont-Regular", size: 16)
}
```

### **Configuration**
```swift
// Update API configuration in APIConfig.swift
struct APIConfig {
    static let baseURL = "https://your-api.com"
    static let apiKey = "your-api-key"
    static let timeout = 30.0
}

// Update app settings in AppConfig.swift
struct AppConfig {
    static let appName = "Your App Name"
    static let appVersion = "1.0.0"
    static let buildNumber = "1"
    static let bundleIdentifier = "com.yourcompany.yourapp"
}
```

### **Dependencies**
```swift
// Update dependencies in Package.swift
dependencies: [
    .package(url: "https://github.com/your-dependency", from: "1.0.0")
]
```

## 🚀 Deployment

### **App Store Preparation**
1. **Update Bundle Identifier**
2. **Configure Code Signing**
3. **Add App Icons**
4. **Create Screenshots**
5. **Write App Description**

### **TestFlight Distribution**
```bash
# Archive the app
xcodebuild archive -scheme YourApp -archivePath YourApp.xcarchive

# Upload to App Store Connect
xcodebuild -exportArchive -archivePath YourApp.xcarchive -exportPath ./build -exportOptionsPlist ExportOptions.plist
```

## 🔧 Troubleshooting

### **Common Issues**

#### **Build Errors**
```bash
# Clean build folder
xcodebuild clean -scheme YourApp

# Reset package cache
rm -rf ~/Library/Developer/Xcode/DerivedData
```

#### **Dependency Issues**
```bash
# Update Swift Package Manager
File → Packages → Reset Package Caches

# Or manually
rm -rf .build
swift package resolve
```

#### **Code Signing Issues**
1. Check team selection in project settings
2. Verify provisioning profiles
3. Ensure bundle identifier is unique
4. Check Apple Developer account status

## 📚 Next Steps

1. **Read [Template Guide](TemplateGuide.md)** for detailed customization
2. **Explore [Architecture Guide](Architecture.md)** for system design
3. **Check [UI Components](UIComponents.md)** for component library
4. **Review [API Reference](API.md)** for complete documentation

## 🤝 Support

- **Documentation**: [Complete Documentation](Documentation/)
- **Issues**: [GitHub Issues](https://github.com/muhittincamdali/iOSAppTemplates/issues)
- **Discussions**: [GitHub Discussions](https://github.com/muhittincamdali/iOSAppTemplates/discussions)

---

**Happy coding with iOS App Templates! 🚀** 