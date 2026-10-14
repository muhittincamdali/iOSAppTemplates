import Foundation

/// One of the app templates stored under `Templates/`.
public struct TemplateDescriptor: Hashable, Sendable, Identifiable {
    /// Short identifier used on the command line, for example `ecommerce`.
    public let id: String
    /// Directory name under `Templates/`. It is also the package, module and
    /// type-name prefix that gets replaced when a project is scaffolded.
    public let directoryName: String
    /// Human-readable name.
    public let displayName: String
    /// Tab bar items of the app's root `TabView`, in order.
    public let tabs: [String]

    public init(id: String, directoryName: String, displayName: String, tabs: [String]) {
        self.id = id
        self.directoryName = directoryName
        self.displayName = displayName
        self.tabs = tabs
    }
}

/// The fixed list of templates that ship with this repository.
public enum TemplateCatalog {
    public static let all: [TemplateDescriptor] = [
        .init(id: "ai-assistant", directoryName: "AIAssistantApp", displayName: "AI Assistant",
              tabs: ["Workspace", "Presets", "Memory", "Tools", "Trust"]),
        .init(id: "booking", directoryName: "BookingReservationsApp", displayName: "Booking & Reservations",
              tabs: ["Home", "Calendar", "Guests", "Requests", "Profile"]),
        .init(id: "creator-video", directoryName: "CreatorShortVideoApp", displayName: "Creator Short Video",
              tabs: ["Studio", "Pipeline", "Analytics", "Moderation", "Profile"]),
        .init(id: "crm", directoryName: "CRMAdminApp", displayName: "CRM Admin",
              tabs: ["Pipeline", "Accounts", "Renewals", "Tasks", "Profile"]),
        .init(id: "ecommerce", directoryName: "EcommerceApp", displayName: "E-commerce",
              tabs: ["Shop", "Browse", "Cart", "Orders", "Profile"]),
        .init(id: "education", directoryName: "EducationApp", displayName: "Education",
              tabs: ["Home", "Courses", "Lessons", "Assessments", "Progress"]),
        .init(id: "finance", directoryName: "FinanceApp", displayName: "Personal Finance",
              tabs: ["Overview", "Accounts", "Budgets", "Activity", "Insights"]),
        .init(id: "fitness", directoryName: "FitnessApp", displayName: "Fitness",
              tabs: ["Plan", "Session", "Progress", "Recovery", "Profile"]),
        .init(id: "food-delivery", directoryName: "FoodDeliveryApp", displayName: "Food Delivery",
              tabs: ["Home", "Browse", "Cart", "Orders", "Profile"]),
        .init(id: "marketplace", directoryName: "MarketplaceApp", displayName: "Marketplace",
              tabs: ["Home", "Browse", "Seller", "Orders", "Trust"]),
        .init(id: "messaging", directoryName: "MessagingApp", displayName: "Messaging",
              tabs: ["Inbox", "Rooms", "Safety", "Profile"]),
        .init(id: "music-podcast", directoryName: "MusicPodcastApp", displayName: "Music & Podcasts",
              tabs: ["Library", "Queue", "Downloads", "Discover", "Profile"]),
        .init(id: "news-blog", directoryName: "NewsBlogApp", displayName: "News & Blog",
              tabs: ["Today", "Sections", "Saved", "Digest", "Profile"]),
        .init(id: "notes", directoryName: "NotesKnowledgeApp", displayName: "Notes & Knowledge",
              tabs: ["Capture", "Library", "Links", "Spaces", "Profile"]),
        .init(id: "privacy-vault", directoryName: "PrivacyVaultApp", displayName: "Privacy Vault",
              tabs: ["Vault", "Alerts", "Recovery", "Audit", "Profile"]),
        .init(id: "productivity", directoryName: "ProductivityApp", displayName: "Productivity",
              tabs: ["Dashboard", "Inbox", "Projects", "Focus", "Review"]),
        .init(id: "social", directoryName: "SocialMediaApp", displayName: "Social Media",
              tabs: ["Feed", "Explore", "Create", "Notifications", "Profile"]),
        .init(id: "subscription-lifestyle", directoryName: "SubscriptionLifestyleApp", displayName: "Subscription Lifestyle",
              tabs: ["Dashboard", "Programs", "Streaks", "Plans", "Profile"]),
        .init(id: "team-collaboration", directoryName: "TeamCollaborationApp", displayName: "Team Collaboration",
              tabs: ["Workspace", "Tasks", "Decisions", "Handoffs", "Profile"]),
        .init(id: "travel", directoryName: "TravelPlannerApp", displayName: "Travel Planner",
              tabs: ["Trips", "Timeline", "Bookings", "Essentials", "Profile"])
    ]

    /// Looks a template up by its command-line identifier or its directory name, ignoring case.
    public static func template(named name: String) -> TemplateDescriptor? {
        let key = name.lowercased()
        return all.first { $0.id == key || $0.directoryName.lowercased() == key }
    }
}
