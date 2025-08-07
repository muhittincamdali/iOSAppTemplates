import SwiftUI
import iOSAppTemplates

@main
struct QuickStartApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @StateObject private var templateManager = TemplateManager()
    @State private var selectedTemplate: TemplateType = .swiftUI
    @State private var appName = ""
    @State private var bundleId = ""
    @State private var isGenerating = false
    @State private var generatedApp: GeneratedApp?
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "app.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("iOS App Templates")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Quick Start Example")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Template Selection
                VStack(alignment: .leading, spacing: 10) {
                    Text("Choose Template Type")
                        .font(.headline)
                    
                    Picker("Template Type", selection: $selectedTemplate) {
                        ForEach(TemplateType.allCases, id: \.self) { template in
                            Text(template.displayName).tag(template)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)
                
                // App Configuration
                VStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("App Name")
                            .font(.headline)
                        
                        TextField("My Awesome App", text: $appName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Bundle Identifier")
                            .font(.headline)
                        
                        TextField("com.company.appname", text: $bundleId)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .padding(.horizontal)
                
                // Generate Button
                Button(action: generateApp) {
                    HStack {
                        if isGenerating {
                            ProgressView()
                                .scaleEffect(0.8)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "wand.and.stars")
                        }
                        
                        Text(isGenerating ? "Generating..." : "Generate App")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
                .disabled(isGenerating || appName.isEmpty || bundleId.isEmpty)
                .padding(.horizontal)
                
                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                // Generated App Info
                if let generatedApp = generatedApp {
                    GeneratedAppView(app: generatedApp)
                }
                
                Spacer()
            }
            .navigationTitle("Quick Start")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func generateApp() {
        isGenerating = true
        errorMessage = nil
        
        let configuration = AppConfiguration(
            name: appName,
            bundleId: bundleId,
            templateType: selectedTemplate,
            features: [.userAuthentication, .dataPersistence, .networkLayer],
            uiFramework: selectedTemplate.uiFramework,
            architecture: .mvvm
        )
        
        Task {
            do {
                let app = try await templateManager.generateApp(with: configuration)
                await MainActor.run {
                    self.generatedApp = app
                    self.isGenerating = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isGenerating = false
                }
            }
        }
    }
}

struct GeneratedAppView: View {
    let app: GeneratedApp
    
    var body: some View {
        VStack(spacing: 15) {
            // Success Icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.green)
            
            Text("App Generated Successfully!")
                .font(.title2)
                .fontWeight(.bold)
            
            // App Details
            VStack(spacing: 10) {
                DetailRow(title: "App Name", value: app.name)
                DetailRow(title: "Bundle ID", value: app.bundleId)
                DetailRow(title: "Template", value: app.templateType.displayName)
                DetailRow(title: "UI Framework", value: app.uiFramework.displayName)
                DetailRow(title: "Architecture", value: app.architecture.displayName)
                DetailRow(title: "Features", value: "\(app.features.count) features")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Action Buttons
            HStack(spacing: 15) {
                Button("Open in Xcode") {
                    openInXcode()
                }
                .buttonStyle(.borderedProminent)
                
                Button("View Files") {
                    viewFiles()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    
    private func openInXcode() {
        // Implementation to open project in Xcode
        print("Opening project in Xcode...")
    }
    
    private func viewFiles() {
        // Implementation to show generated files
        print("Showing generated files...")
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

// MARK: - Supporting Types

enum TemplateType: CaseIterable {
    case swiftUI
    case uiKit
    case hybrid
    
    var displayName: String {
        switch self {
        case .swiftUI: return "SwiftUI"
        case .uiKit: return "UIKit"
        case .hybrid: return "Hybrid"
        }
    }
    
    var uiFramework: UIFramework {
        switch self {
        case .swiftUI: return .swiftUI
        case .uiKit: return .uiKit
        case .hybrid: return .hybrid
        }
    }
}

enum UIFramework {
    case swiftUI
    case uiKit
    case hybrid
    
    var displayName: String {
        switch self {
        case .swiftUI: return "SwiftUI"
        case .uiKit: return "UIKit"
        case .hybrid: return "SwiftUI + UIKit"
        }
    }
}

enum Architecture {
    case mvvm
    case mvc
    case clean
    
    var displayName: String {
        switch self {
        case .mvvm: return "MVVM"
        case .mvc: return "MVC"
        case .clean: return "Clean Architecture"
        }
    }
}

enum AppFeature: CaseIterable {
    case userAuthentication
    case dataPersistence
    case networkLayer
    case pushNotifications
    case analytics
    case crashReporting
    
    var displayName: String {
        switch self {
        case .userAuthentication: return "User Authentication"
        case .dataPersistence: return "Data Persistence"
        case .networkLayer: return "Network Layer"
        case .pushNotifications: return "Push Notifications"
        case .analytics: return "Analytics"
        case .crashReporting: return "Crash Reporting"
        }
    }
}

struct AppConfiguration {
    let name: String
    let bundleId: String
    let templateType: TemplateType
    let features: [AppFeature]
    let uiFramework: UIFramework
    let architecture: Architecture
}

struct GeneratedApp {
    let name: String
    let bundleId: String
    let templateType: TemplateType
    let uiFramework: UIFramework
    let architecture: Architecture
    let features: [AppFeature]
    let projectPath: String
    let generatedFiles: [String]
}

// MARK: - Template Manager Extension

extension TemplateManager {
    func generateApp(with configuration: AppConfiguration) async throws -> GeneratedApp {
        // Simulate app generation process
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        let generatedFiles = [
            "\(configuration.name)/\(configuration.name).xcodeproj",
            "\(configuration.name)/\(configuration.name)/AppDelegate.swift",
            "\(configuration.name)/\(configuration.name)/SceneDelegate.swift",
            "\(configuration.name)/\(configuration.name)/ContentView.swift",
            "\(configuration.name)/\(configuration.name)/Models/",
            "\(configuration.name)/\(configuration.name)/Views/",
            "\(configuration.name)/\(configuration.name)/ViewModels/",
            "\(configuration.name)/\(configuration.name)/Services/",
            "\(configuration.name)/\(configuration.name)/Resources/",
            "\(configuration.name)/\(configuration.name).entitlements",
            "\(configuration.name)/Info.plist"
        ]
        
        return GeneratedApp(
            name: configuration.name,
            bundleId: configuration.bundleId,
            templateType: configuration.templateType,
            uiFramework: configuration.uiFramework,
            architecture: configuration.architecture,
            features: configuration.features,
            projectPath: "/Users/developer/Projects/\(configuration.name)",
            generatedFiles: generatedFiles
        )
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
