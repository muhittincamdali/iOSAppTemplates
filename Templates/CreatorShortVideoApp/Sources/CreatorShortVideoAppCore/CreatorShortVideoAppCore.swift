import Foundation

public struct CreatorShortVideoDashboardSnapshot: Hashable, Sendable {
    public let publishedClips: Int
    public let creatorAccounts: Int
    public let pendingReviews: Int
    public let distributionHealth: String

    public init(
        publishedClips: Int,
        creatorAccounts: Int,
        pendingReviews: Int,
        distributionHealth: String
    ) {
        self.publishedClips = publishedClips
        self.creatorAccounts = creatorAccounts
        self.pendingReviews = pendingReviews
        self.distributionHealth = distributionHealth
    }

    public static let sample = CreatorShortVideoDashboardSnapshot(
        publishedClips: 86,
        creatorAccounts: 24,
        pendingReviews: 5,
        distributionHealth: "Publishing pipeline healthy"
    )
}

public struct CreatorShortVideoChannelCard: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let clipCount: Int
    public let ctaLabel: String

    public init(
        id: UUID = UUID(),
        title: String,
        clipCount: Int,
        ctaLabel: String
    ) {
        self.id = id
        self.title = title
        self.clipCount = clipCount
        self.ctaLabel = ctaLabel
    }

    public static let sampleCards: [CreatorShortVideoChannelCard] = [
        CreatorShortVideoChannelCard(title: "Launch Stories", clipCount: 18, ctaLabel: "Open creator queue"),
        CreatorShortVideoChannelCard(title: "Product Demos", clipCount: 27, ctaLabel: "Review publishing plan"),
        CreatorShortVideoChannelCard(title: "Community Highlights", clipCount: 14, ctaLabel: "Inspect engagement")
    ]
}

public struct CreatorShortVideoOperationalHealth: Hashable, Sendable {
    public let moderationQueue: Int
    public let averageUploadMinutes: Int
    public let monetizationReady: Bool

    public init(
        moderationQueue: Int,
        averageUploadMinutes: Int,
        monetizationReady: Bool
    ) {
        self.moderationQueue = moderationQueue
        self.averageUploadMinutes = averageUploadMinutes
        self.monetizationReady = monetizationReady
    }

    public static let sample = CreatorShortVideoOperationalHealth(
        moderationQueue: 7,
        averageUploadMinutes: 9,
        monetizationReady: true
    )
}
