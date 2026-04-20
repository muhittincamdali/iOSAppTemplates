import SwiftUI
import TeamCollaborationAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct TeamCollaborationSummaryCard: View {
    public let snapshot: TeamCollaborationDashboardSnapshot
    public let health: TeamCollaborationOperationalHealth

    public init(
        snapshot: TeamCollaborationDashboardSnapshot,
        health: TeamCollaborationOperationalHealth
    ) {
        self.snapshot = snapshot
        self.health = health
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("\(snapshot.activeProjects) active projects", systemImage: "square.grid.3x3.fill")
            Label("\(snapshot.openDecisions) open decisions", systemImage: "checklist.checked")
            Label("\(snapshot.dailyStandups) standups today", systemImage: "person.3.sequence.fill")
            Label(snapshot.workspaceHealth, systemImage: "bubble.left.and.exclamationmark.bubble.right.fill")
            Label(
                "\(health.averageReplyMinutes) min average reply time",
                systemImage: health.handoffReady ? "checkmark.circle.fill" : "xmark.circle.fill"
            )
        }
        .padding(.vertical, 8)
    }
}
