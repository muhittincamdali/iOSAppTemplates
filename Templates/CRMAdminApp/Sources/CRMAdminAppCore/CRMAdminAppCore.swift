import Foundation

public struct CRMAdminDashboardSnapshot: Hashable, Sendable {
    public let openAccounts: Int
    public let atRiskDeals: Int
    public let renewalQueue: Int
    public let pipelineHealth: String

    public init(
        openAccounts: Int,
        atRiskDeals: Int,
        renewalQueue: Int,
        pipelineHealth: String
    ) {
        self.openAccounts = openAccounts
        self.atRiskDeals = atRiskDeals
        self.renewalQueue = renewalQueue
        self.pipelineHealth = pipelineHealth
    }

    public static let sample = CRMAdminDashboardSnapshot(
        openAccounts: 148,
        atRiskDeals: 12,
        renewalQueue: 19,
        pipelineHealth: "Renewal pipeline stable"
    )
}

public struct CRMAdminWorkspaceCard: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let ownerCount: Int
    public let ctaLabel: String

    public init(
        id: UUID = UUID(),
        title: String,
        ownerCount: Int,
        ctaLabel: String
    ) {
        self.id = id
        self.title = title
        self.ownerCount = ownerCount
        self.ctaLabel = ctaLabel
    }

    public static let sampleCards: [CRMAdminWorkspaceCard] = [
        CRMAdminWorkspaceCard(title: "Enterprise Renewals", ownerCount: 6, ctaLabel: "Open pipeline review"),
        CRMAdminWorkspaceCard(title: "SMB Expansion", ownerCount: 4, ctaLabel: "Inspect at-risk accounts"),
        CRMAdminWorkspaceCard(title: "Partner Ops", ownerCount: 3, ctaLabel: "Review SLA board")
    ]
}

public struct CRMAdminOperationalHealth: Hashable, Sendable {
    public let slaBreaches: Int
    public let medianFirstReplyMinutes: Int
    public let automationReady: Bool

    public init(
        slaBreaches: Int,
        medianFirstReplyMinutes: Int,
        automationReady: Bool
    ) {
        self.slaBreaches = slaBreaches
        self.medianFirstReplyMinutes = medianFirstReplyMinutes
        self.automationReady = automationReady
    }

    public static let sample = CRMAdminOperationalHealth(
        slaBreaches: 2,
        medianFirstReplyMinutes: 14,
        automationReady: true
    )
}
