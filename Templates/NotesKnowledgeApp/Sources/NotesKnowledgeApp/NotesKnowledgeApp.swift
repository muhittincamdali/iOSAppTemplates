import SwiftUI
import NotesKnowledgeAppCore
import NotesKnowledgeAppUI

@available(iOS 18.0, macOS 15.0, *)
public struct NotesKnowledgeAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            NotesKnowledgeDashboardView(
                snapshot: .sample,
                collections: NotesKnowledgeCollectionCard.sampleCards,
                actions: NotesKnowledgeQuickAction.defaultActions,
                health: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct NotesKnowledgeDashboardView: View {
    public let snapshot: NotesKnowledgeDashboardSnapshot
    public let collections: [NotesKnowledgeCollectionCard]
    public let actions: [NotesKnowledgeQuickAction]
    public let health: NotesKnowledgeOperationalHealth

    public init(
        snapshot: NotesKnowledgeDashboardSnapshot,
        collections: [NotesKnowledgeCollectionCard],
        actions: [NotesKnowledgeQuickAction],
        health: NotesKnowledgeOperationalHealth
    ) {
        self.snapshot = snapshot
        self.collections = collections
        self.actions = actions
        self.health = health
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Knowledge Overview") {
                    NotesKnowledgeSummaryCard(
                        snapshot: snapshot,
                        health: health
                    )
                }

                Section("Collections") {
                    ForEach(collections) { collection in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(collection.title)
                            Text("\(collection.documentCount) documents")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(collection.ctaLabel)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Quick Actions") {
                    ForEach(actions) { action in
                        Label(action.title, systemImage: action.systemImage)
                    }
                }
            }
            .navigationTitle("NotesKnowledgeApp")
        }
    }
}

public struct NotesKnowledgeQuickAction: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let systemImage: String

    public init(
        id: UUID = UUID(),
        title: String,
        systemImage: String
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
    }

    public static let defaultActions: [NotesKnowledgeQuickAction] = [
        NotesKnowledgeQuickAction(title: "Open Capture Inbox", systemImage: "tray.and.arrow.down.fill"),
        NotesKnowledgeQuickAction(title: "Review Knowledge Links", systemImage: "link.circle.fill"),
        NotesKnowledgeQuickAction(title: "Sync Shared Spaces", systemImage: "person.2.wave.2.fill")
    ]
}
