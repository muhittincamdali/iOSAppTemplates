import Foundation

public struct NewsBlogDashboardSnapshot: Hashable, Sendable {
    public let leadHeadline: String
    public let publishedToday: Int
    public let bookmarkedReads: Int
    public let readerModeReady: Bool

    public init(
        leadHeadline: String,
        publishedToday: Int,
        bookmarkedReads: Int,
        readerModeReady: Bool
    ) {
        self.leadHeadline = leadHeadline
        self.publishedToday = publishedToday
        self.bookmarkedReads = bookmarkedReads
        self.readerModeReady = readerModeReady
    }

    public static let sample = NewsBlogDashboardSnapshot(
        leadHeadline: "Editorial command center for daily publishing",
        publishedToday: 18,
        bookmarkedReads: 6,
        readerModeReady: true
    )
}

public struct NewsBlogCategoryCard: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let articleCount: Int
    public let ctaLabel: String

    public init(
        id: UUID = UUID(),
        title: String,
        articleCount: Int,
        ctaLabel: String
    ) {
        self.id = id
        self.title = title
        self.articleCount = articleCount
        self.ctaLabel = ctaLabel
    }

    public static let sampleCards: [NewsBlogCategoryCard] = [
        NewsBlogCategoryCard(title: "Top Stories", articleCount: 8, ctaLabel: "Open briefing"),
        NewsBlogCategoryCard(title: "Tech", articleCount: 12, ctaLabel: "Review desk"),
        NewsBlogCategoryCard(title: "Business", articleCount: 7, ctaLabel: "Check performance")
    ]
}

public struct NewsBlogPublishingHealth: Hashable, Sendable {
    public let moderationQueue: Int
    public let newsletterReady: Bool
    public let syncStatus: String

    public init(
        moderationQueue: Int,
        newsletterReady: Bool,
        syncStatus: String
    ) {
        self.moderationQueue = moderationQueue
        self.newsletterReady = newsletterReady
        self.syncStatus = syncStatus
    }

    public static let sample = NewsBlogPublishingHealth(
        moderationQueue: 3,
        newsletterReady: true,
        syncStatus: "Synchronized"
    )
}
