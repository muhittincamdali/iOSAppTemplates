import SwiftUI
import CRMAdminAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct CRMAdminSummaryCard: View {
    public let snapshot: CRMAdminDashboardSnapshot
    public let health: CRMAdminOperationalHealth

    public init(
        snapshot: CRMAdminDashboardSnapshot,
        health: CRMAdminOperationalHealth
    ) {
        self.snapshot = snapshot
        self.health = health
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("\(snapshot.openAccounts) active accounts", systemImage: "person.2.fill")
            Label("\(snapshot.atRiskDeals) at-risk deals", systemImage: "exclamationmark.triangle.fill")
            Label("\(snapshot.renewalQueue) renewals this month", systemImage: "arrow.clockwise.circle.fill")
            Label(snapshot.pipelineHealth, systemImage: "chart.bar.xaxis")
            Label(
                "\(health.medianFirstReplyMinutes) min median first reply",
                systemImage: health.automationReady ? "checkmark.seal.fill" : "xmark.seal.fill"
            )
        }
        .padding(.vertical, 8)
    }
}
