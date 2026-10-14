import Foundation

public struct PrivacyVaultDashboardSnapshot: Hashable, Sendable {
    public let securedItems: Int
    public let pendingAudits: Int
    public let sharedVaults: Int
    public let protectionHealth: String

    public init(
        securedItems: Int,
        pendingAudits: Int,
        sharedVaults: Int,
        protectionHealth: String
    ) {
        self.securedItems = securedItems
        self.pendingAudits = pendingAudits
        self.sharedVaults = sharedVaults
        self.protectionHealth = protectionHealth
    }

    public static let sample = PrivacyVaultDashboardSnapshot(
        securedItems: 842,
        pendingAudits: 5,
        sharedVaults: 11,
        protectionHealth: "Vault integrity healthy"
    )
}

public struct PrivacyVaultCollectionCard: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let itemCount: Int
    public let ctaLabel: String

    public init(
        id: UUID = UUID(),
        title: String,
        itemCount: Int,
        ctaLabel: String
    ) {
        self.id = id
        self.title = title
        self.itemCount = itemCount
        self.ctaLabel = ctaLabel
    }

    public static let sampleCards: [PrivacyVaultCollectionCard] = [
        PrivacyVaultCollectionCard(title: "Identity Vault", itemCount: 118, ctaLabel: "Open recovery checks"),
        PrivacyVaultCollectionCard(title: "Document Safe", itemCount: 247, ctaLabel: "Inspect sync health"),
        PrivacyVaultCollectionCard(title: "Shared Family Vault", itemCount: 39, ctaLabel: "Review access grants")
    ]
}

public struct PrivacyVaultOperationalHealth: Hashable, Sendable {
    public let accessAlerts: Int
    public let medianUnlockSeconds: Int
    public let recoveryReady: Bool

    public init(
        accessAlerts: Int,
        medianUnlockSeconds: Int,
        recoveryReady: Bool
    ) {
        self.accessAlerts = accessAlerts
        self.medianUnlockSeconds = medianUnlockSeconds
        self.recoveryReady = recoveryReady
    }

    public static let sample = PrivacyVaultOperationalHealth(
        accessAlerts: 1,
        medianUnlockSeconds: 2,
        recoveryReady: true
    )
}
