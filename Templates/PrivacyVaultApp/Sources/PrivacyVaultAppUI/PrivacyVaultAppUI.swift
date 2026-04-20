import SwiftUI
import PrivacyVaultAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct PrivacyVaultSummaryCard: View {
    public let snapshot: PrivacyVaultDashboardSnapshot
    public let health: PrivacyVaultOperationalHealth

    public init(
        snapshot: PrivacyVaultDashboardSnapshot,
        health: PrivacyVaultOperationalHealth
    ) {
        self.snapshot = snapshot
        self.health = health
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("\(snapshot.securedItems) secured items", systemImage: "lock.doc.fill")
            Label("\(snapshot.pendingAudits) pending audits", systemImage: "checkmark.shield.fill")
            Label("\(snapshot.sharedVaults) shared vaults", systemImage: "person.2.crop.square.stack.fill")
            Label(snapshot.protectionHealth, systemImage: "lock.shield.fill")
            Label(
                "\(health.medianUnlockSeconds) sec median unlock",
                systemImage: health.recoveryReady ? "key.fill" : "key.slash.fill"
            )
        }
        .padding(.vertical, 8)
    }
}
