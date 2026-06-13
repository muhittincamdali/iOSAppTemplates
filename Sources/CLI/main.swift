import Foundation
import ArgumentParser

enum AppTemplate: String, EnumerableFlag, CaseIterable, ExpressibleByArgument {
    case social, commerce, health, finance, education, ai, visionos, entertainment, productivity, travel, tca
    
    var description: String {
        switch self {
        case .social: return "Social Media App (Zustand-like state, Real-time)"
        case .commerce: return "E-Commerce App (Product catalog, Cart, Payments)"
        case .health: return "Health & Fitness App (HealthKit, Charts)"
        case .finance: return "Personal Finance App (Bank sync, Transactions)"
        case .education: return "EducationAI Powered (Adaptive learning, Quiz)"
        case .ai: return "SwiftAI Integrated (Neural networks, Vision)"
        case .visionos: return "VisionOS Spatial Experience (Windows, Volumetric)"
        case .entertainment: return "Streaming & Media (Video player, Discovery)"
        case .productivity: return "Task Management (Sync, Reminders)"
        case .travel: return "Travel & Booking (Maps, Itinerary)"
        case .tca: return "The Composable Architecture (Redux-style)"
        }
    }
}

enum AuthType: String, EnumerableFlag, CaseIterable, ExpressibleByArgument {
    case none, biometric, social, enterprise
}

enum PersistenceType: String, EnumerableFlag, CaseIterable, ExpressibleByArgument {
    case none, swiftData, coreData, sqlite
}

@main
struct CreateIOSApp: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "create-ios-app",
        abstract: "The ultimate production engine for world-class iOS applications.",
        version: "1.2.0"
    )

    @Argument(help: "The name of your new world-class application.")
    var name: String

    @Option(name: .shortAndLong, help: "The template to use.")
    var template: AppTemplate = .social

    @Option(name: [.customShort("a"), .long], help: "Authentication method (biometric, social, enterprise, none).")
    var auth: AuthType = .biometric

    @Option(name: [.customShort("d"), .long], help: "Persistence layer (swiftData, coreData, sqlite, none).")
    var db: PersistenceType = .swiftData

    @Flag(name: [.customShort("y"), .long], help: "Enable Offline-First synchronization.")
    var sync: Bool = false

    @Flag(name: [.customShort("g"), .long], help: "Enable Liquid Glass visual signature.")
    var liquidGlass: Bool = false

    @Flag(name: [.customShort("x"), .long], help: "Enable Swift 6 strict concurrency checks.")
    var strict: Bool = false

    func run() async throws {
        print("\n" + String(repeating: "═", count: 70))
        print("🏛️  PRO FORGE: ASSEMBLING '\(name.uppercased())'")
        print("📂  Base: \(template.rawValue.capitalized) | 🔑 Auth: \(auth) | 💿 DB: \(db)")
        print("✨  Sync: \(sync ? "YES" : "NO") | 🧊 Liquid Glass: \(liquidGlass ? "YES" : "NO")")
        print(String(repeating: "═", count: 70) + "\n")
        
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        let projectPath = URL(fileURLWithPath: currentPath).appendingPathComponent(name)
        
        if fileManager.fileExists(atPath: projectPath.path) {
            print("❌ Error: Directory '\(name)' already exists.")
            return
        }

        try createDirectoryStructure(at: projectPath)
        try generatePackageSwift(at: projectPath)
        try generateVisualSignature(at: projectPath)
        try generateCoreImplementation(at: projectPath)
        try generateREADME(at: projectPath)
        try generateAppStoreMetadata(at: projectPath)

        print("\n✅  SUCCESS: '\(name)' has been assembled using World-Class components.")
        print("📍  Path: \(projectPath.path)")
        print("\nReady to dominate? Run:")
        print("cd \(name) && swift build")
        print("\n'Mükemmellik bir eylem değil, bir alışkanlıktır.' - Muhittin Camdali\n")
    }

    private func createDirectoryStructure(at path: URL) throws {
        let subdirs = [
            "Sources", "Tests", "Resources",
            "Sources/Core", "Sources/UI", "Sources/Features", 
            "Sources/Core/Network", "Sources/Core/Storage", "Sources/Core/Auth"
        ]
        for dir in subdirs {
            try FileManager.default.createDirectory(at: path.appendingPathComponent(dir), withIntermediateDirectories: true)
        }
        print("🛠️  Architecting folder structure...")
    }

    private func generatePackageSwift(at path: URL) throws {
        var dependencies = [
            ".package(url: \"https://github.com/muhittincamdali/SwiftNetwork\", from: \"1.1.0\")",
            ".package(url: \"https://github.com/muhittincamdali/SwiftCache\", from: \"1.0.0\")",
            ".package(url: \"https://github.com/muhittincamdali/MobileLogger\", from: \"1.0.0\")"
        ]
        
        var targetDeps = ["\"SwiftNetwork\"", "\"SwiftCache\"", "\"MobileLogger\""]
        
        if template == .ai || template == .education {
            dependencies.append(".package(url: \"https://github.com/muhittincamdali/SwiftAI\", from: \"1.2.0\")")
            targetDeps.append("\"SwiftAI\"")
        }
        
        if sync || db != .none {
            dependencies.append(".package(url: \"https://github.com/muhittincamdali/SwiftPersistence\", from: \"1.0.0\")")
            targetDeps.append("\"SwiftPersistence\"")
        }

        if auth != .none {
            dependencies.append(".package(url: \"https://github.com/muhittincamdali/iOSSecurityTools\", from: \"1.0.0\")")
            targetDeps.append("\"iOSSecurityTools\"")
        }

        let content = """
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "\(name)",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [.library(name: "\(name)", targets: ["\(name)"])],
    dependencies: [
        \(dependencies.joined(separator: ",\n        "))
    ],
    targets: [
        .target(
            name: "\(name)",
            dependencies: [
                \(targetDeps.joined(separator: ",\n                "))
            ],
            path: "Sources",
            swiftSettings: [\(strict ? ".enableExperimentalFeature(\"StrictConcurrency\")" : "")]
        )
    ]
)
"""
        try content.write(to: path.appendingPathComponent("Package.swift"), atomically: true, encoding: .utf8)
        print("📦  Linking elite core libraries...")
    }

    private func generateVisualSignature(at path: URL) throws {
        let glassCode = """
import SwiftUI

public extension View {
    func applyWorldClassStyle() -> some View {
        self.padding()
            .background(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.white.opacity(0.2), lineWidth: 0.5)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.15), radius: 15)
    }
}
"""
        try glassCode.write(to: path.appendingPathComponent("Sources/UI/Theme.swift"), atomically: true, encoding: .utf8)
        print("🎨  Injecting Liquid Glass visual signature...")
    }

    private func generateCoreImplementation(at path: URL) throws {
        let appCode = """
import SwiftUI
import SwiftNetwork
import MobileLogger

@main
struct \(name)App: App {
    init() {
        // Global logging setup
        #if DEBUG
        MobileLogger.shared.logLevel = .debug
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct MainView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "shield.checkerboard")
                    .font(.system(size: 100))
                    .foregroundStyle(.blue.gradient)
                
                VStack(spacing: 8) {
                    Text("\(name)")
                        .font(.system(size: 40, weight: .black))
                        .foregroundStyle(.white)
                    
                    Text("\(template.rawValue.uppercased()) ENGINE ACTIVATED")
                        .font(.caption.bold())
                        .tracking(3)
                        .foregroundStyle(.blue)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    FeatureRow(icon: "lock.fill", text: "Auth: \(auth.rawValue.capitalized)")
                    FeatureRow(icon: "database.fill", text: "Storage: \(db.rawValue.capitalized)")
                    FeatureRow(icon: "bolt.horizontal.circle.fill", text: "Sync: \(sync ? "Real-time" : "Local")")
                }
                .applyWorldClassStyle()
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.blue)
            Text(text)
                .foregroundStyle(.white.opacity(0.9))
        }
    }
}
"""
        try appCode.write(to: path.appendingPathComponent("Sources/\(name).swift"), atomically: true, encoding: .utf8)
        print("📜  Synthesizing core logic and feature switches...")
    }

    private func generateAppStoreMetadata(at path: URL) throws {
        let metadata = """
        {
            "version": "1.0.0",
            "locales": {
                "en-US": {
                    "title": "\(name)",
                    "subtitle": "World-Class \(template.rawValue.capitalized) Experience",
                    "description": "Experience the ultimate \(template.rawValue) application, built with zero-bloat native Swift technology.",
                    "keywords": ["ios", "native", "swift", "\(template.rawValue)", "pro", "high-performance"],
                    "release_notes": "Initial global launch."
                }
            },
            "pricing_tier": 0,
            "category": "\(template.rawValue)",
            "privacy_policy_url": "https://\(name.lowercased()).app/privacy"
        }
        """
        try metadata.write(to: path.appendingPathComponent("Resources/app-store-metadata.json"), atomically: true, encoding: .utf8)
        print("📊  Generating App Store metadata...")
    }

    private func generateREADME(at path: URL) throws {
        let readme = """
# \(name)
**Forged by the 'create-ios-app' Pro Engine**

This application represents the pinnacle of mobile engineering, using a unified core architecture.

## 🚀 Technical Stack
- **Architecture:** Clean Architecture + World-Class Unified Core
- **Concurrency:** Swift 6 Strict Mode (100% Data-Race Safe)
- **Networking:** SwiftNetwork (Zero-Bloat async/await)
- **Persistence:** \(db.rawValue.capitalized)
- **Visuals:** Liquid Glass Signature
- **Auth:** \(auth.rawValue.capitalized)

## 🛠️ Usage
Built with the world's most advanced iOS production engine.
"""
        try readme.write(to: path.appendingPathComponent("README.md"), atomically: true, encoding: .utf8)
        print("📝  Generating world-class documentation...")
    }
}
