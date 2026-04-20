import SwiftUI
import SubscriptionLifestyleAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct SubscriptionLifestyleSummaryCard: View {
    public let snapshot: SubscriptionLifestyleDashboardSnapshot
    public let health: SubscriptionLifestyleOperationalHealth

    public init(
        snapshot: SubscriptionLifestyleDashboardSnapshot,
        health: SubscriptionLifestyleOperationalHealth
    ) {
        self.snapshot = snapshot
        self.health = health
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("\(snapshot.activeMembers) active members", systemImage: "person.crop.circle.badge.checkmark")
            Label("\(snapshot.streakPrograms) active programs", systemImage: "figure.run.circle")
            Label("\(snapshot.churnRisks) churn alerts", systemImage: "chart.line.downtrend.xyaxis")
            Label(snapshot.membershipHealth, systemImage: "heart.text.square.fill")
            Label(
                "\(health.medianRecoveryHours) hr median save window",
                systemImage: health.paywallReady ? "checkmark.circle.fill" : "xmark.circle.fill"
            )
        }
        .padding(.vertical, 8)
    }
}
