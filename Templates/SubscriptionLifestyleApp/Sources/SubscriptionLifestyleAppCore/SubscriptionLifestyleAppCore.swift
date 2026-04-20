import Foundation

public struct SubscriptionLifestyleDashboardSnapshot: Hashable, Sendable {
    public let activeMembers: Int
    public let streakPrograms: Int
    public let churnRisks: Int
    public let membershipHealth: String

    public init(
        activeMembers: Int,
        streakPrograms: Int,
        churnRisks: Int,
        membershipHealth: String
    ) {
        self.activeMembers = activeMembers
        self.streakPrograms = streakPrograms
        self.churnRisks = churnRisks
        self.membershipHealth = membershipHealth
    }

    public static let sample = SubscriptionLifestyleDashboardSnapshot(
        activeMembers: 3204,
        streakPrograms: 8,
        churnRisks: 54,
        membershipHealth: "Subscription health stable"
    )
}

public struct SubscriptionLifestyleProgramCard: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let participantCount: Int
    public let ctaLabel: String

    public init(
        id: UUID = UUID(),
        title: String,
        participantCount: Int,
        ctaLabel: String
    ) {
        self.id = id
        self.title = title
        self.participantCount = participantCount
        self.ctaLabel = ctaLabel
    }

    public static let sampleCards: [SubscriptionLifestyleProgramCard] = [
        SubscriptionLifestyleProgramCard(title: "Morning Reset", participantCount: 942, ctaLabel: "Review retention curve"),
        SubscriptionLifestyleProgramCard(title: "Wellness Streak", participantCount: 1284, ctaLabel: "Open habit ladder"),
        SubscriptionLifestyleProgramCard(title: "Premium Coaching", participantCount: 311, ctaLabel: "Inspect renewal flow")
    ]
}

public struct SubscriptionLifestyleOperationalHealth: Hashable, Sendable {
    public let churnWatchQueue: Int
    public let medianRecoveryHours: Int
    public let paywallReady: Bool

    public init(
        churnWatchQueue: Int,
        medianRecoveryHours: Int,
        paywallReady: Bool
    ) {
        self.churnWatchQueue = churnWatchQueue
        self.medianRecoveryHours = medianRecoveryHours
        self.paywallReady = paywallReady
    }

    public static let sample = SubscriptionLifestyleOperationalHealth(
        churnWatchQueue: 23,
        medianRecoveryHours: 6,
        paywallReady: true
    )
}
