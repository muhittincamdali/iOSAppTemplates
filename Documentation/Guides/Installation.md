# Installation Guide

A comprehensive guide to installing and setting up iOS App Templates in your development environment.

## =� Prerequisites

### System Requirements
- **macOS**: 14.0 (Sonoma) or later
- **Xcode**: 16.0 or later
- **Swift**: 6.0 or later
- **Storage**: At least 10 GB free space

### Platform Requirements
| Platform | Minimum Version | Recommended |
|----------|----------------|-------------|
| iOS | 17.0 | 18.0+ |
| visionOS | 1.0 | 2.0+ |
| macOS | 14.0 | 15.0+ |
| tvOS | 17.0 | 18.0+ |
| watchOS | 10.0 | 11.0+ |

### Developer Account
- Apple Developer Account (for device testing)
- GitHub Account (for repository access)
- App Store Connect access (for distribution)

## =� Installation Methods

### Method 1: Swift Package Manager (Recommended)

#### Via Xcode UI
1. Open your project in Xcode
2. Navigate to **File � Add Package Dependencies**
3. Enter the repository URL:
   ```
   https://github.com/yourusername/iOSAppTemplates.git
   ```
4. Select version: **"Up to Next Major Version"** from **2.0.0**
5. Choose the templates you need:
   - `iOSAppTemplates` - Core templates
   - `TCATemplates` - The Composable Architecture
   - `VisionOSTemplates` - Vision Pro templates
   - `AIMLTemplates` - AI/ML integration
   - `PerformanceTemplates` - Performance optimization
   - `SecurityTemplates` - Security implementations

#### Via Package.swift
Add to your `Package.swift` file:

```swift
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "YourApp",
    platforms: [
        .iOS(.v18),
        .visionOS(.v2),
        .macOS(.v15),
        .tvOS(.v18),
        .watchOS(.v11)
    ],
    dependencies: [
        .package(
            url: "https://github.com/yourusername/iOSAppTemplates.git",
            from: "2.0.0"
        )
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: [
                .product(name: "iOSAppTemplates", package: "iOSAppTemplates"),
                .product(name: "TCATemplates", package: "iOSAppTemplates"),
                .product(name: "VisionOSTemplates", package: "iOSAppTemplates")
            ]
        )
    ]
)
```

### Method 2: Git Clone

```bash
# Clone the repository
git clone https://github.com/yourusername/iOSAppTemplates.git

# Navigate to the directory
cd iOSAppTemplates

# Open in Xcode
open Package.swift
```

### Method 3: Manual Download

1. Download the latest release from [GitHub Releases](https://github.com/yourusername/iOSAppTemplates/releases)
2. Extract the archive
3. Drag the `Sources` folder into your Xcode project
4. Configure build settings as needed

## =' Configuration

### 1. Project Setup

Create a new Xcode project or open an existing one:

```bash
# Create new project using template
xcodegen generate --spec project.yml

# Or use Xcode template
open -a Xcode
# File � New � Project � iOS App Templates
```

### 2. Environment Configuration

Create `Configuration.swift`:

```swift
import iOSAppTemplates

enum AppConfiguration {
    static let environment: Environment = {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }()
    
    static let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    static let baseURL = ProcessInfo.processInfo.environment["BASE_URL"] ?? ""
}
```

### 3. Info.plist Updates

Add required permissions and configurations:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for AR features</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access for location-based features</string>

<key>NSHealthShareUsageDescription</key>
<string>This app needs health data access for fitness features</string>

<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>processing</string>
</array>
```

## <� Quick Start Examples

### Basic iOS App

```swift
import SwiftUI
import iOSAppTemplates

@main
struct MyApp: App {
    let templateManager = TemplateManager()
    
    var body: some Scene {
        WindowGroup {
            templateManager
                .createTemplate(.social)
                .configure { config in
                    config.theme = .modern
                    config.features = [.authentication, .chat, .feed]
                }
                .build()
        }
    }
}
```

### TCA App

```swift
import ComposableArchitecture
import TCATemplates

@main
struct TCAApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(
                    initialState: RootFeature.State(),
                    reducer: { RootFeature() }
                )
            )
        }
    }
}
```

### Vision Pro App

```swift
import SwiftUI
import VisionOSTemplates
import RealityKit

@main
struct VisionApp: App {
    var body: some Scene {
        WindowGroup {
            ImmersiveSpaceView()
        }
        .windowStyle(.volumetric)
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
```

## = API Keys & Secrets

### Using Environment Variables

1. Create `.env` file (don't commit to git):
```bash
API_KEY=your_api_key_here
BASE_URL=https://api.example.com
ANALYTICS_ID=your_analytics_id
```

2. Add to `.gitignore`:
```
.env
*.env
.env.*
```

3. Load in Xcode scheme:
- Edit Scheme � Run � Arguments � Environment Variables
- Add your key-value pairs

### Using Xcode Config Files

1. Create `Config.xcconfig`:
```
API_KEY = your_api_key_here
BASE_URL = https://api.example.com
```

2. Reference in build settings:
- Project � Build Settings � User-Defined
- Add entries from config file

## >� Verification

### Build Test

```bash
# Build for iOS
xcodebuild build \
    -scheme iOSAppTemplates \
    -destination "platform=iOS Simulator,name=iPhone 16"

# Build for visionOS
xcodebuild build \
    -scheme VisionOSTemplates \
    -destination "platform=visionOS Simulator,name=Apple Vision Pro"
```

### Run Tests

```bash
# Run all tests
swift test

# Run specific test
swift test --filter TemplateTests
```

### Validate Integration

```swift
import XCTest
import iOSAppTemplates

class IntegrationTests: XCTestCase {
    func testTemplateLoading() {
        let manager = TemplateManager()
        XCTAssertNotNil(manager.availableTemplates)
        XCTAssertGreaterThan(manager.availableTemplates.count, 0)
    }
}
```

## = Troubleshooting

### Common Issues

#### Package Resolution Failed
```bash
# Clear package cache
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf .build
swift package reset

# Resolve again
swift package resolve
```

#### Missing Dependencies
```bash
# Update packages
swift package update

# Or in Xcode
File � Packages � Update to Latest Package Versions
```

#### Build Errors
```bash
# Clean build folder
xcodebuild clean

# Or in Xcode
Product � Clean Build Folder (�K)
```

### Platform-Specific Issues

#### visionOS Simulator Not Available
1. Install visionOS runtime:
   - Xcode � Settings � Platforms
   - Download visionOS simulator

#### iOS 18 Features Not Working
1. Ensure Xcode 16.0+ is installed
2. Update deployment target in project settings
3. Check Swift language version is 6.0

## =� Next Steps

1. [Quick Start Guide](./QuickStart.md) - Build your first app
2. [Architecture Guide](../ArchitectureTemplatesGuide.md) - Understand the structure
3. [Template Guide](../TemplateGuide.md) - Explore available templates
4. [Best Practices](../BestPracticesGuide.md) - Learn iOS development best practices

## <� Getting Help

- **Documentation**: [Full Documentation](../README.md)
- **Issues**: [GitHub Issues](https://github.com/yourusername/iOSAppTemplates/issues)
- **Community**: [Discord Server](https://discord.gg/iosapptemplates)
- **Support**: support@iosapptemplates.dev

---

<div align="center">
  <strong>Happy Coding! =�</strong>
</div>