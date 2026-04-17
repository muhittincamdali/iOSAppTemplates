#!/usr/bin/env swift

// MARK: - iOS App Template Generator CLI
// Generate ready-to-use iOS app templates with a single command
// Usage: swift TemplateGenerator.swift --template ecommerce --name "MyShop" --output ~/Desktop

import Foundation

// MARK: - Template Types

enum TemplateType: String, CaseIterable {
    case ecommerce = "ecommerce"
    case socialMedia = "social"
    case newsBlog = "news"
    case fitness = "fitness"
    case finance = "finance"
    case education = "education"
    case foodDelivery = "food"
    case travel = "travel"
    case music = "music"
    case productivity = "productivity"
    
    var displayName: String {
        switch self {
        case .ecommerce: return "E-Commerce"
        case .socialMedia: return "Social Media"
        case .newsBlog: return "News/Blog"
        case .fitness: return "Fitness & Health"
        case .finance: return "Finance"
        case .education: return "Education"
        case .foodDelivery: return "Food Delivery"
        case .travel: return "Travel"
        case .music: return "Music/Podcast"
        case .productivity: return "Productivity"
        }
    }
    
    var features: [String] {
        switch self {
        case .ecommerce:
            return ["Product Listing", "Shopping Cart", "Checkout", "Order History", "User Profile", "Search & Filter", "Wishlist", "Reviews"]
        case .socialMedia:
            return ["Feed", "Stories", "Messages", "Profile", "Reels", "Notifications", "Search", "Settings"]
        case .newsBlog:
            return ["Article Feed", "Categories", "Bookmarks", "Reader Mode", "Search", "Author Profiles", "Comments", "Sharing"]
        case .fitness:
            return ["Workouts", "Activity Tracking", "Nutrition", "Progress Charts", "Goals", "Achievements", "Water Tracker", "Apple Health"]
        case .finance:
            return ["Dashboard", "Accounts", "Cards", "Transactions", "Budgets", "Investments", "Analytics", "Biometric Auth"]
        case .education:
            return ["Courses", "Lessons", "Quizzes", "Progress", "Certificates", "Notes", "Streak Tracking", "Offline Mode"]
        case .foodDelivery:
            return ["Restaurant List", "Menu", "Cart", "Checkout", "Order Tracking", "Reviews", "Favorites", "Promo Codes"]
        case .travel:
            return ["Destinations", "Flights", "Hotels", "Bookings", "Itinerary", "Maps", "Reviews", "Saved Places"]
        case .music:
            return ["Music Player", "Playlists", "Library", "Search", "Podcasts", "Queue", "Lyrics", "Offline Mode"]
        case .productivity:
            return ["Tasks", "Projects", "Notes", "Focus Mode", "Habits", "Calendar", "Tags", "Reminders"]
        }
    }
    
    var screens: Int {
        switch self {
        case .ecommerce: return 16
        case .socialMedia: return 16
        case .newsBlog: return 14
        case .fitness: return 15
        case .finance: return 15
        case .education: return 14
        case .foodDelivery: return 17
        case .travel: return 12
        case .music: return 14
        case .productivity: return 12
        }
    }
}

// MARK: - CLI Arguments

struct CLIArguments {
    var template: TemplateType?
    var projectName: String?
    var outputPath: String?
    var bundleIdentifier: String?
    var showHelp: Bool = false
    var listTemplates: Bool = false
    var interactive: Bool = false
    
    static func parse(_ args: [String]) -> CLIArguments {
        var result = CLIArguments()
        var i = 1 // Skip script name
        
        while i < args.count {
            let arg = args[i]
            
            switch arg {
            case "-h", "--help":
                result.showHelp = true
            case "-l", "--list":
                result.listTemplates = true
            case "-i", "--interactive":
                result.interactive = true
            case "-t", "--template":
                if i + 1 < args.count {
                    result.template = TemplateType(rawValue: args[i + 1])
                    i += 1
                }
            case "-n", "--name":
                if i + 1 < args.count {
                    result.projectName = args[i + 1]
                    i += 1
                }
            case "-o", "--output":
                if i + 1 < args.count {
                    result.outputPath = args[i + 1]
                    i += 1
                }
            case "-b", "--bundle-id":
                if i + 1 < args.count {
                    result.bundleIdentifier = args[i + 1]
                    i += 1
                }
            default:
                break
            }
            i += 1
        }
        
        return result
    }
}

// MARK: - Template Generator

class TemplateGenerator {
    let template: TemplateType
    let projectName: String
    let outputPath: String
    let bundleIdentifier: String
    let generatedHomeViewName: String
    
    init(template: TemplateType, projectName: String, outputPath: String, bundleIdentifier: String?) {
        self.template = template
        self.projectName = projectName
        self.outputPath = outputPath
        self.bundleIdentifier = bundleIdentifier ?? "com.example.\(projectName.lowercased().replacingOccurrences(of: " ", with: ""))"
        self.generatedHomeViewName = template.displayName
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "/", with: "")
            .replacingOccurrences(of: "&", with: "")
    }
    
    func generate() throws {
        print("🚀 Generating \(template.displayName) template...")
        print("   Project: \(projectName)")
        print("   Bundle ID: \(bundleIdentifier)")
        print("   Output: \(outputPath)")
        print("")
        
        // Create project directory
        let projectPath = "\(outputPath)/\(projectName)"
        try createDirectory(at: projectPath)
        
        // Create project structure
        try createProjectStructure(at: projectPath)
        
        // Generate Package.swift
        try generatePackageSwift(at: projectPath)
        
        // Generate main app files
        try generateAppFiles(at: projectPath)
        
        // Copy template source
        try generateTemplateSource(at: projectPath)
        
        // Generate README
        try generateReadme(at: projectPath)
        
        print("✅ Template generated successfully!")
        print("")
        print("Next steps:")
        print("  1. cd \(projectPath)")
        print("  2. open Package.swift")
        print("  3. Build and run!")
    }
    
    private func createDirectory(at path: String) throws {
        let fileManager = FileManager.default
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
    }
    
    private func createProjectStructure(at path: String) throws {
        let directories = [
            "Sources/\(projectName)",
            "Sources/\(projectName)/Views",
            "Sources/\(projectName)/Models",
            "Sources/\(projectName)/ViewModels",
            "Sources/\(projectName)/Services",
            "Sources/\(projectName)/Extensions",
            "Sources/\(projectName)/Resources",
            "Tests/\(projectName)Tests"
        ]
        
        for dir in directories {
            try createDirectory(at: "\(path)/\(dir)")
        }
    }
    
    private func generatePackageSwift(at path: String) throws {
        let content = """
        // swift-tools-version: 6.0
        import PackageDescription
        
        let package = Package(
            name: "\(projectName)",
            platforms: [
                .iOS(.v18),
                .macOS(.v15),
                .tvOS(.v18),
                .watchOS(.v11),
                .visionOS(.v2)
            ],
            products: [
                .executable(name: "\(projectName)", targets: ["\(projectName)"])
            ],
            dependencies: [],
            targets: [
                .executableTarget(
                    name: "\(projectName)",
                    dependencies: [],
                    path: "Sources/\(projectName)"
                ),
                .testTarget(
                    name: "\(projectName)Tests",
                    dependencies: ["\(projectName)"],
                    path: "Tests/\(projectName)Tests"
                )
            ]
        )
        """
        
        try content.write(toFile: "\(path)/Package.swift", atomically: true, encoding: .utf8)
    }
    
    private func generateAppFiles(at path: String) throws {
        let appContent = """
        import SwiftUI
        
        @main
        struct \(projectName)App: App {
            var body: some Scene {
                WindowGroup {
                    ContentView()
                }
            }
        }
        """
        
        try appContent.write(toFile: "\(path)/Sources/\(projectName)/\(projectName)App.swift", atomically: true, encoding: .utf8)
        
        let contentViewContent = """
        import SwiftUI
        
        struct ContentView: View {
            var body: some View {
                \(generatedHomeViewName)HomeView()
            }
        }
        
        #Preview {
            ContentView()
        }
        """
        
        try contentViewContent.write(toFile: "\(path)/Sources/\(projectName)/Views/ContentView.swift", atomically: true, encoding: .utf8)

        let testContent = """
        import Testing
        @testable import \(projectName)

        @Test
        func generatedStarterCompiles() {
            _ = ContentView()
        }
        """

        try testContent.write(toFile: "\(path)/Tests/\(projectName)Tests/\(projectName)Tests.swift", atomically: true, encoding: .utf8)
    }
    
    private func generateTemplateSource(at path: String) throws {
        let featuresLiteral = template.features
            .map { "\"\($0)\"" }
            .joined(separator: ", ")
        
        let content = """
        // MARK: - \(template.displayName) Template
        // This template includes \(template.screens)+ screens with the following features:
        // \(template.features.joined(separator: ", "))
        //
        // For full implementation, copy from:
        // iOSAppTemplates/Sources/\(templateSourcePath())
        
        import SwiftUI
        import Foundation
        
        // Generated starter shell - replace or extend with the lane-specific implementation.
        public struct \(generatedHomeViewName)HomeView: View {
            public init() {}
            
            public var body: some View {
                NavigationStack {
                    VStack(spacing: 20) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        
                        Text("\(template.displayName)")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Template with \(template.screens)+ screens")
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Features:")
                                .fontWeight(.semibold)
                            
                            ForEach(Array(features.prefix(5)), id: \\.self) { feature in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text(feature)
                                }
                            }
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.12))
                        .cornerRadius(12)
                    }
                    .padding()
                    .navigationTitle("\(projectName)")
                }
            }
            
            private var features: [String] {
                [\(featuresLiteral)]
            }
        }
        """
        
        try content.write(toFile: "\(path)/Sources/\(projectName)/Views/\(generatedHomeViewName)HomeView.swift", atomically: true, encoding: .utf8)
    }
    
    private func templateSourcePath() -> String {
        switch template {
        case .ecommerce: return "CommerceTemplates/ECommerceTemplate.swift"
        case .socialMedia: return "SocialTemplates/SocialMediaTemplate.swift"
        case .newsBlog: return "NewsTemplates/NewsBlogTemplate.swift"
        case .fitness: return "HealthTemplates/FitnessHealthTemplate.swift"
        case .finance: return "FinanceTemplates/FinanceAppTemplate.swift"
        case .education: return "EducationTemplates/EducationAppTemplate.swift"
        case .foodDelivery: return "FoodTemplates/FoodDeliveryTemplate.swift"
        case .travel: return "TravelTemplates/TravelAppTemplate.swift"
        case .music: return "MusicTemplates/MusicPodcastTemplate.swift"
        case .productivity: return "ProductivityTemplates/ProductivityAppTemplate.swift"
        }
    }
    
    private func generateReadme(at path: String) throws {
        let content = """
        # \(projectName)
        
        A \(template.displayName) starter generated with iOSAppTemplates.
        
        ## Features
        
        \(template.features.map { "- \($0)" }.joined(separator: "\n"))
        
        ## Requirements
        
        - iOS 18.0+
        - macOS 15.0+ for package inspection
        - Xcode 16.0+
        - Swift 6.0+
        
        ## Getting Started
        
        1. Open `Package.swift` in Xcode
        2. Build and run the project
        3. Replace the generated shell with the lane-specific source as needed
        
        ## Project Structure
        
        ```
        \(projectName)/
        ├── Sources/
        │   └── \(projectName)/
        │       ├── Views/
        │       ├── Models/
        │       ├── ViewModels/
        │       ├── Services/
        │       └── Extensions/
        └── Tests/
        ```
        
        ## License
        
        MIT License
        
        ---
        
        Generated with [iOSAppTemplates](https://github.com/muhittincamdali/iOSAppTemplates)
        
        See also:
        - `iOSAppTemplates/Documentation/Complete-App-Standard.md`
        - `iOSAppTemplates/Documentation/TemplateGuide.md`
        """
        
        try content.write(toFile: "\(path)/README.md", atomically: true, encoding: .utf8)
    }
}

// MARK: - CLI Interface

func printHelp() {
    print("""
    
    🎨 iOS App Template Generator
    ═══════════════════════════════
    
    Generate structured iOS app template scaffolds with a single command.
    
    USAGE:
        swift TemplateGenerator.swift [OPTIONS]
    
    OPTIONS:
        -t, --template <type>    Template type (see --list)
        -n, --name <name>        Project name
        -o, --output <path>      Output directory (default: current)
        -b, --bundle-id <id>     Bundle identifier
        -i, --interactive        Interactive mode
        -l, --list               List available templates
        -h, --help               Show this help
    
    EXAMPLES:
        swift TemplateGenerator.swift -t ecommerce -n "MyShop" -o ~/Desktop
        swift TemplateGenerator.swift --interactive
        swift TemplateGenerator.swift --list
    
    """)
}

func listTemplates() {
    print("""
    
    📦 Available Templates
    ═══════════════════════════════
    
    """)
    
    for template in TemplateType.allCases {
        print("  \(template.rawValue.padding(toLength: 12, withPad: " ", startingAt: 0)) │ \(template.displayName)")
        print("               │ \(template.screens)+ screens")
        print("               │ Features: \(template.features.prefix(4).joined(separator: ", "))...")
        print("")
    }
}

func interactiveMode() {
    print("""
    
    🎨 iOS App Template Generator - Interactive Mode
    ═══════════════════════════════════════════════════
    
    """)
    
    // Select template
    print("Available templates:")
    for (index, template) in TemplateType.allCases.enumerated() {
        print("  \(index + 1). \(template.displayName) (\(template.screens)+ screens)")
    }
    
    print("")
    print("Select template (1-\(TemplateType.allCases.count)): ", terminator: "")
    
    guard let input = readLine(),
          let selection = Int(input),
          selection >= 1 && selection <= TemplateType.allCases.count else {
        print("Invalid selection")
        return
    }
    
    let template = TemplateType.allCases[selection - 1]
    
    // Get project name
    print("Project name: ", terminator: "")
    guard let projectName = readLine(), !projectName.isEmpty else {
        print("Project name is required")
        return
    }
    
    // Get output path
    print("Output directory (press Enter for current): ", terminator: "")
    let outputPath = readLine() ?? "."
    let finalPath = outputPath.isEmpty ? "." : outputPath
    
    // Generate
    do {
        let generator = TemplateGenerator(
            template: template,
            projectName: projectName,
            outputPath: finalPath,
            bundleIdentifier: nil
        )
        try generator.generate()
    } catch {
        print("❌ Error: \(error.localizedDescription)")
    }
}

// MARK: - Main

func main() {
    let args = CLIArguments.parse(CommandLine.arguments)
    
    if args.showHelp {
        printHelp()
        return
    }
    
    if args.listTemplates {
        listTemplates()
        return
    }
    
    if args.interactive {
        interactiveMode()
        return
    }
    
    // Validate required arguments
    guard let template = args.template else {
        print("❌ Error: Template type is required. Use --list to see available templates.")
        return
    }
    
    guard let projectName = args.projectName else {
        print("❌ Error: Project name is required. Use --name <name>")
        return
    }
    
    let outputPath = args.outputPath ?? "."
    
    do {
        let generator = TemplateGenerator(
            template: template,
            projectName: projectName,
            outputPath: outputPath,
            bundleIdentifier: args.bundleIdentifier
        )
        try generator.generate()
    } catch {
        print("❌ Error: \(error.localizedDescription)")
    }
}

main()
