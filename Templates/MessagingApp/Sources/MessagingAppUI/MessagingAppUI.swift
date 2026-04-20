import SwiftUI
import MessagingAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct MessagingSummaryCard: View {
    public let snapshot: MessagingDashboardSnapshot
    public let health: MessagingOperationalHealth

    public init(
        snapshot: MessagingDashboardSnapshot,
        health: MessagingOperationalHealth
    ) {
        self.snapshot = snapshot
        self.health = health
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("\(snapshot.activeThreads) active threads", systemImage: "bubble.left.and.bubble.right.fill")
            Label("\(snapshot.unreadMessages) unread messages", systemImage: "bell.badge.fill")
            Label("\(snapshot.communityRooms) community rooms", systemImage: "person.3.sequence.fill")
            Label(snapshot.syncHealth, systemImage: "antenna.radiowaves.left.and.right")
            Label(
                "\(health.messageDeliveryLatencyMs) ms delivery latency",
                systemImage: health.safetyChecksReady ? "checkmark.shield.fill" : "xmark.shield.fill"
            )
        }
        .padding(.vertical, 8)
    }
}
