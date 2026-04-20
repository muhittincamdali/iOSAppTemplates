import SwiftUI
import NotesKnowledgeAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct NotesKnowledgeSummaryCard: View {
    public let snapshot: NotesKnowledgeDashboardSnapshot
    public let health: NotesKnowledgeOperationalHealth

    public init(
        snapshot: NotesKnowledgeDashboardSnapshot,
        health: NotesKnowledgeOperationalHealth
    ) {
        self.snapshot = snapshot
        self.health = health
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("\(snapshot.activeNotes) active notes", systemImage: "note.text")
            Label("\(snapshot.sharedSpaces) shared spaces", systemImage: "person.2.fill")
            Label("\(snapshot.capturedIdeasToday) ideas captured today", systemImage: "lightbulb.fill")
            Label(snapshot.syncHealth, systemImage: "arrow.triangle.2.circlepath")
            Label(
                "\(health.linkedReferencesToday) references linked today",
                systemImage: health.offlineReady ? "externaldrive.badge.checkmark" : "externaldrive.badge.xmark"
            )
        }
        .padding(.vertical, 8)
    }
}
