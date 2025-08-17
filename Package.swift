// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSAppTemplates",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2)
    ],
    products: [
        // Main library
        .library(
            name: "iOSAppTemplates",
            targets: ["iOSAppTemplates"]
        ),
        
        // Template categories
        .library(
            name: "SocialTemplates",
            targets: ["SocialTemplates"]
        ),
        .library(
            name: "CommerceTemplates", 
            targets: ["CommerceTemplates"]
        ),
        .library(
            name: "HealthTemplates",
            targets: ["HealthTemplates"]
        ),
        .library(
            name: "ProductivityTemplates",
            targets: ["ProductivityTemplates"]
        ),
        .library(
            name: "EntertainmentTemplates",
            targets: ["EntertainmentTemplates"]
        ),
        .library(
            name: "EducationTemplates",
            targets: ["EducationTemplates"]
        ),
        .library(
            name: "FinanceTemplates",
            targets: ["FinanceTemplates"]
        ),
        .library(
            name: "TravelTemplates",
            targets: ["TravelTemplates"]
        ),
        
        // Modern Architecture Templates
        .library(
            name: "TCATemplates",
            targets: ["TCATemplates"]
        ),
        .library(
            name: "VisionOSTemplates",
            targets: ["VisionOSTemplates"]
        ),
        .library(
            name: "AITemplates",
            targets: ["AITemplates"]
        ),
        .library(
            name: "PerformanceTemplates",
            targets: ["PerformanceTemplates"]
        ),
        .library(
            name: "SecurityTemplates",
            targets: ["SecurityTemplates"]
        )
    ],
    dependencies: [
        // Modern Swift
        .package(url: "https://github.com/apple/swift-markdown", from: "0.5.0"),
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.1.0"),
        
        // Architecture
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.15.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.4.0"),
        
        // Networking
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.9.0"),
        
        // Firebase
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.0.0"),
        
        // UI & Visualization
        .package(url: "https://github.com/danielgindi/Charts", from: "5.1.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "8.0.0"),
        
        // Code Quality
        .package(url: "https://github.com/realm/SwiftLint", from: "0.56.0"),
        
        // Vision Pro - RealityKit is a system framework, removing external dependency
        
        // AI/ML
        .package(url: "https://github.com/apple/ml-stable-diffusion", from: "1.0.0")
    ],
    targets: [
        // Main target
        .target(
            name: "iOSAppTemplates",
            dependencies: [
                "SocialTemplates",
                "CommerceTemplates", 
                "HealthTemplates",
                "ProductivityTemplates",
                "EntertainmentTemplates",
                "EducationTemplates",
                "FinanceTemplates",
                "TravelTemplates"
            ],
            path: "Sources/iOSAppTemplates"
        ),
        
        // Template category targets
        .target(
            name: "SocialTemplates",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ],
            path: "Sources/SocialTemplates"
        ),
        
        .target(
            name: "CommerceTemplates",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ],
            path: "Sources/CommerceTemplates"
        ),
        
        .target(
            name: "HealthTemplates",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "Charts", package: "Charts")
            ],
            path: "Sources/HealthTemplates"
        ),
        
        .target(
            name: "ProductivityTemplates",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ],
            path: "Sources/ProductivityTemplates"
        ),
        
        .target(
            name: "EntertainmentTemplates",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ],
            path: "Sources/EntertainmentTemplates"
        ),
        
        .target(
            name: "EducationTemplates",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk")
            ],
            path: "Sources/EducationTemplates"
        ),
        
        .target(
            name: "FinanceTemplates",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "Charts", package: "Charts")
            ],
            path: "Sources/FinanceTemplates"
        ),
        
        .target(
            name: "TravelTemplates",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ],
            path: "Sources/TravelTemplates"
        ),
        
        // Modern Architecture targets
        .target(
            name: "TCATemplates",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            path: "Sources/TCATemplates"
        ),
        
        .target(
            name: "VisionOSTemplates",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/VisionOSTemplates"
        ),
        
        .target(
            name: "AITemplates",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "StableDiffusion", package: "ml-stable-diffusion")
            ],
            path: "Sources/AITemplates"
        ),
        
        .target(
            name: "PerformanceTemplates",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms")
            ],
            path: "Sources/PerformanceTemplates"
        ),
        
        .target(
            name: "SecurityTemplates",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ],
            path: "Sources/SecurityTemplates"
        ),
        
        // Test targets
        .testTarget(
            name: "iOSAppTemplatesTests",
            dependencies: ["iOSAppTemplates"],
            path: "Tests/iOSAppTemplatesTests"
        ),
        
        .testTarget(
            name: "SocialTemplatesTests",
            dependencies: ["SocialTemplates"],
            path: "Tests/SocialTemplatesTests"
        ),
        
        .testTarget(
            name: "CommerceTemplatesTests",
            dependencies: ["CommerceTemplates"],
            path: "Tests/CommerceTemplatesTests"
        ),
        
        .testTarget(
            name: "HealthTemplatesTests",
            dependencies: ["HealthTemplates"],
            path: "Tests/HealthTemplatesTests"
        ),
        
        .testTarget(
            name: "ProductivityTemplatesTests",
            dependencies: ["ProductivityTemplates"],
            path: "Tests/ProductivityTemplatesTests"
        ),
        
        .testTarget(
            name: "EntertainmentTemplatesTests",
            dependencies: ["EntertainmentTemplates"],
            path: "Tests/EntertainmentTemplatesTests"
        ),
        
        .testTarget(
            name: "EducationTemplatesTests",
            dependencies: ["EducationTemplates"],
            path: "Tests/EducationTemplatesTests"
        ),
        
        .testTarget(
            name: "FinanceTemplatesTests",
            dependencies: ["FinanceTemplates"],
            path: "Tests/FinanceTemplatesTests"
        ),
        
        .testTarget(
            name: "TravelTemplatesTests",
            dependencies: ["TravelTemplates"],
            path: "Tests/TravelTemplatesTests"
        ),
        
        // Modern Architecture test targets
        .testTarget(
            name: "TCATemplatesTests",
            dependencies: ["TCATemplates"],
            path: "Tests/TCATemplatesTests"
        ),
        
        .testTarget(
            name: "VisionOSTemplatesTests",
            dependencies: ["VisionOSTemplates"],
            path: "Tests/VisionOSTemplatesTests"
        ),
        
        .testTarget(
            name: "AITemplatesTests",
            dependencies: ["AITemplates"],
            path: "Tests/AITemplatesTests"
        ),
        
        .testTarget(
            name: "PerformanceTemplatesTests",
            dependencies: ["PerformanceTemplates"],
            path: "Tests/PerformanceTemplatesTests"
        ),
        
        .testTarget(
            name: "SecurityTemplatesTests",
            dependencies: ["SecurityTemplates"],
            path: "Tests/SecurityTemplatesTests"
        ),
        
        // Performance Benchmark Tests - Enterprise Standards Compliance
        .testTarget(
            name: "PerformanceBenchmarkTests",
            dependencies: [
                "iOSAppTemplates",
                "PerformanceTemplates"
            ],
            path: "Tests/PerformanceBenchmarkTests"
        )
    ]
) 