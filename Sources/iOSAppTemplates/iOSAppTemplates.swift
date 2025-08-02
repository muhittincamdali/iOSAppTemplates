import Foundation
import SwiftUI

// MARK: - iOS App Templates
public struct iOSAppTemplates {
    
    // MARK: - Version
    public static let version = "1.0.0"
    
    // MARK: - Initialization
    public static func initialize() {
        print("🚀 iOS App Templates v\(version) initialized")
    }
    
    // MARK: - Configuration
    public static func configure(
        templatesEnabled: Bool = true,
        documentationEnabled: Bool = true,
        examplesEnabled: Bool = true
    ) {
        print("⚙️ iOS App Templates configured")
        print("   - Templates: \(templatesEnabled ? "✅" : "❌")")
        print("   - Documentation: \(documentationEnabled ? "✅" : "❌")")
        print("   - Examples: \(examplesEnabled ? "✅" : "❌")")
    }
}

// MARK: - Template Manager
public class TemplateManager: ObservableObject {
    
    // MARK: - Singleton
    public static let shared = TemplateManager()
    
    // MARK: - Published Properties
    @Published public var availableTemplates: [AppTemplate] = []
    @Published public var selectedTemplate: AppTemplate?
    
    // MARK: - Private Properties
    private var templates: [AppTemplate] = []
    
    // MARK: - Initialization
    private init() {
        loadTemplates()
    }
    
    // MARK: - Public Methods
    
    /// Load all available templates
    public func loadTemplates() {
        templates = [
            AppTemplate(
                id: "social-media",
                name: "Social Media App",
                description: "Complete social media application with user profiles, posts, and real-time features",
                category: .social,
                features: ["User Authentication", "Feed", "Posts", "Comments", "Real-time Updates"],
                technologies: ["SwiftUI", "Firebase", "Alamofire"],
                complexity: .intermediate,
                estimatedTime: "4-6 weeks"
            ),
            AppTemplate(
                id: "ecommerce",
                name: "E-commerce App",
                description: "Full-featured e-commerce application with product catalog, shopping cart, and payment integration",
                category: .commerce,
                features: ["Product Catalog", "Shopping Cart", "Payment Integration", "Order Management", "User Reviews"],
                technologies: ["SwiftUI", "Stripe", "Firebase", "Alamofire"],
                complexity: .advanced,
                estimatedTime: "6-8 weeks"
            ),
            AppTemplate(
                id: "fitness",
                name: "Fitness App",
                description: "Comprehensive fitness tracking application with workout plans, progress tracking, and health integration",
                category: .health,
                features: ["Workout Tracking", "Progress Charts", "HealthKit Integration", "Goal Setting", "Social Features"],
                technologies: ["SwiftUI", "HealthKit", "Charts", "Firebase"],
                complexity: .intermediate,
                estimatedTime: "5-7 weeks"
            )
        ]
        
        availableTemplates = templates
    }
    
    /// Get template by ID
    public func getTemplate(id: String) -> AppTemplate? {
        return templates.first { $0.id == id }
    }
    
    /// Get templates by category
    public func getTemplates(category: TemplateCategory) -> [AppTemplate] {
        return templates.filter { $0.category == category }
    }
    
    /// Get templates by complexity
    public func getTemplates(complexity: TemplateComplexity) -> [AppTemplate] {
        return templates.filter { $0.complexity == complexity }
    }
    
    /// Search templates
    public func searchTemplates(query: String) -> [AppTemplate] {
        let lowercasedQuery = query.lowercased()
        return templates.filter { template in
            template.name.lowercased().contains(lowercasedQuery) ||
            template.description.lowercased().contains(lowercasedQuery) ||
            template.features.contains { $0.lowercased().contains(lowercasedQuery) }
        }
    }
    
    /// Select template
    public func selectTemplate(_ template: AppTemplate) {
        selectedTemplate = template
    }
    
    /// Clear selection
    public func clearSelection() {
        selectedTemplate = nil
    }
}

// MARK: - Supporting Types

/// App Template
public struct AppTemplate: Identifiable, Codable {
    public let id: String
    public let name: String
    public let description: String
    public let category: TemplateCategory
    public let features: [String]
    public let technologies: [String]
    public let complexity: TemplateComplexity
    public let estimatedTime: String
    
    public init(
        id: String,
        name: String,
        description: String,
        category: TemplateCategory,
        features: [String],
        technologies: [String],
        complexity: TemplateComplexity,
        estimatedTime: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.features = features
        self.technologies = technologies
        self.complexity = complexity
        self.estimatedTime = estimatedTime
    }
}

/// Template Category
public enum TemplateCategory: String, CaseIterable, Codable {
    case social = "Social"
    case commerce = "Commerce"
    case health = "Health"
    case productivity = "Productivity"
    case entertainment = "Entertainment"
    case education = "Education"
    case finance = "Finance"
    case travel = "Travel"
    
    public var icon: String {
        switch self {
        case .social:
            return "person.2.fill"
        case .commerce:
            return "cart.fill"
        case .health:
            return "heart.fill"
        case .productivity:
            return "briefcase.fill"
        case .entertainment:
            return "play.fill"
        case .education:
            return "book.fill"
        case .finance:
            return "dollarsign.circle.fill"
        case .travel:
            return "airplane"
        }
    }
    
    public var color: String {
        switch self {
        case .social:
            return "blue"
        case .commerce:
            return "green"
        case .health:
            return "red"
        case .productivity:
            return "orange"
        case .entertainment:
            return "purple"
        case .education:
            return "yellow"
        case .finance:
            return "mint"
        case .travel:
            return "cyan"
        }
    }
}

/// Template Complexity
public enum TemplateComplexity: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
    
    public var description: String {
        switch self {
        case .beginner:
            return "Suitable for developers new to iOS development"
        case .intermediate:
            return "Requires basic iOS development knowledge"
        case .advanced:
            return "Requires solid iOS development experience"
        case .expert:
            return "Requires advanced iOS development skills"
        }
    }
    
    public var estimatedExperience: String {
        switch self {
        case .beginner:
            return "0-1 years"
        case .intermediate:
            return "1-3 years"
        case .advanced:
            return "3-5 years"
        case .expert:
            return "5+ years"
        }
    }
}

/// Template Error
public enum TemplateError: LocalizedError {
    case templateNotFound(String)
    case invalidTemplate(String)
    case generationFailed(String)
    case configurationError(String)
    
    public var errorDescription: String? {
        switch self {
        case .templateNotFound(let id):
            return "Template with ID '\(id)' not found"
        case .invalidTemplate(let reason):
            return "Invalid template: \(reason)"
        case .generationFailed(let reason):
            return "Template generation failed: \(reason)"
        case .configurationError(let reason):
            return "Configuration error: \(reason)"
        }
    }
} 