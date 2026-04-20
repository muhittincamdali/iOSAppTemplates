import Foundation

public struct TeamCollaborationDashboardSnapshot: Hashable, Sendable {
    public let activeProjects: Int
    public let openDecisions: Int
    public let dailyStandups: Int
    public let workspaceHealth: String

    public init(
        activeProjects: Int,
        openDecisions: Int,
        dailyStandups: Int,
        workspaceHealth: String
    ) {
        self.activeProjects = activeProjects
        self.openDecisions = openDecisions
        self.dailyStandups = dailyStandups
        self.workspaceHealth = workspaceHealth
    }

    public static let sample = TeamCollaborationDashboardSnapshot(
        activeProjects: 12,
        openDecisions: 9,
        dailyStandups: 6,
        workspaceHealth: "Collaboration cadence on track"
    )
}

public struct TeamCollaborationProjectCard: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let contributorCount: Int
    public let ctaLabel: String

    public init(
        id: UUID = UUID(),
        title: String,
        contributorCount: Int,
        ctaLabel: String
    ) {
        self.id = id
        self.title = title
        self.contributorCount = contributorCount
        self.ctaLabel = ctaLabel
    }

    public static let sampleCards: [TeamCollaborationProjectCard] = [
        TeamCollaborationProjectCard(title: "Launch Sprint", contributorCount: 14, ctaLabel: "Open decision board"),
        TeamCollaborationProjectCard(title: "Customer Ops", contributorCount: 9, ctaLabel: "Review async updates"),
        TeamCollaborationProjectCard(title: "Design System", contributorCount: 7, ctaLabel: "Inspect blockers")
    ]
}

public struct TeamCollaborationOperationalHealth: Hashable, Sendable {
    public let reviewQueue: Int
    public let averageReplyMinutes: Int
    public let handoffReady: Bool

    public init(
        reviewQueue: Int,
        averageReplyMinutes: Int,
        handoffReady: Bool
    ) {
        self.reviewQueue = reviewQueue
        self.averageReplyMinutes = averageReplyMinutes
        self.handoffReady = handoffReady
    }

    public static let sample = TeamCollaborationOperationalHealth(
        reviewQueue: 11,
        averageReplyMinutes: 16,
        handoffReady: true
    )
}
