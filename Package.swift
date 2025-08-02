// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSAppTemplates",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
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
        )
    ],
    dependencies: [
        // SwiftUI for UI components
        .package(url: "https://github.com/apple/swift-markdown", from: "0.3.0"),
        
        // Networking
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.0"),
        
        // Firebase (optional)
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.0.0"),
        
        // Charts
        .package(url: "https://github.com/danielgindi/Charts", from: "5.0.0"),
        
        // Image loading
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.0.0"),
        
        // Code quality
        .package(url: "https://github.com/realm/SwiftLint", from: "0.50.0")
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
        )
    ]
) 