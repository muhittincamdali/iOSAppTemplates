import Foundation

public struct MarketplaceDashboardSnapshot: Hashable, Sendable {
    public let activeListings: Int
    public let verifiedSellers: Int
    public let openDisputes: Int
    public let payoutHealth: String

    public init(
        activeListings: Int,
        verifiedSellers: Int,
        openDisputes: Int,
        payoutHealth: String
    ) {
        self.activeListings = activeListings
        self.verifiedSellers = verifiedSellers
        self.openDisputes = openDisputes
        self.payoutHealth = payoutHealth
    }

    public static let sample = MarketplaceDashboardSnapshot(
        activeListings: 1248,
        verifiedSellers: 214,
        openDisputes: 6,
        payoutHealth: "Daily payout window healthy"
    )
}

public struct MarketplaceCategoryCard: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let listingCount: Int
    public let ctaLabel: String

    public init(
        id: UUID = UUID(),
        title: String,
        listingCount: Int,
        ctaLabel: String
    ) {
        self.id = id
        self.title = title
        self.listingCount = listingCount
        self.ctaLabel = ctaLabel
    }

    public static let sampleCards: [MarketplaceCategoryCard] = [
        MarketplaceCategoryCard(title: "Featured Tech", listingCount: 184, ctaLabel: "Review hero grid"),
        MarketplaceCategoryCard(title: "Home Studio", listingCount: 96, ctaLabel: "Open seller set"),
        MarketplaceCategoryCard(title: "Pre-owned Deals", listingCount: 231, ctaLabel: "Check trust queue")
    ]
}

public struct MarketplaceOperationalHealth: Hashable, Sendable {
    public let fraudReviewQueue: Int
    public let averageSellerResponseMinutes: Int
    public let buyerProtectionReady: Bool

    public init(
        fraudReviewQueue: Int,
        averageSellerResponseMinutes: Int,
        buyerProtectionReady: Bool
    ) {
        self.fraudReviewQueue = fraudReviewQueue
        self.averageSellerResponseMinutes = averageSellerResponseMinutes
        self.buyerProtectionReady = buyerProtectionReady
    }

    public static let sample = MarketplaceOperationalHealth(
        fraudReviewQueue: 4,
        averageSellerResponseMinutes: 18,
        buyerProtectionReady: true
    )
}
