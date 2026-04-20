import Foundation

public struct MessagingDashboardSnapshot: Hashable, Sendable {
    public let activeThreads: Int
    public let unreadMessages: Int
    public let communityRooms: Int
    public let syncHealth: String

    public init(
        activeThreads: Int,
        unreadMessages: Int,
        communityRooms: Int,
        syncHealth: String
    ) {
        self.activeThreads = activeThreads
        self.unreadMessages = unreadMessages
        self.communityRooms = communityRooms
        self.syncHealth = syncHealth
    }

    public static let sample = MessagingDashboardSnapshot(
        activeThreads: 28,
        unreadMessages: 146,
        communityRooms: 9,
        syncHealth: "Realtime sync healthy"
    )
}

public struct MessagingConversationCard: Identifiable, Hashable, Sendable {
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

    public static let sampleCards: [MessagingConversationCard] = [
        MessagingConversationCard(title: "Core Product Team", participantCount: 12, ctaLabel: "Open daily standup"),
        MessagingConversationCard(title: "Support Escalations", participantCount: 6, ctaLabel: "Review priority inbox"),
        MessagingConversationCard(title: "Creator Community", participantCount: 184, ctaLabel: "Moderate live chat")
    ]
}

public struct MessagingOperationalHealth: Hashable, Sendable {
    public let moderationQueue: Int
    public let messageDeliveryLatencyMs: Int
    public let safetyChecksReady: Bool

    public init(
        moderationQueue: Int,
        messageDeliveryLatencyMs: Int,
        safetyChecksReady: Bool
    ) {
        self.moderationQueue = moderationQueue
        self.messageDeliveryLatencyMs = messageDeliveryLatencyMs
        self.safetyChecksReady = safetyChecksReady
    }

    public static let sample = MessagingOperationalHealth(
        moderationQueue: 5,
        messageDeliveryLatencyMs: 120,
        safetyChecksReady: true
    )
}
