import SwiftUI
import MusicPodcastAppCore
import MusicPodcastAppUI

@available(iOS 18.0, macOS 15.0, *)
public struct MusicPodcastAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            MusicPodcastDashboardView(
                snapshot: .sample,
                collections: MusicPodcastCollectionCard.sampleCards,
                actions: MusicPodcastQuickAction.defaultActions,
                health: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct MusicPodcastDashboardView: View {
    public let snapshot: MusicPodcastDashboardSnapshot
    public let collections: [MusicPodcastCollectionCard]
    public let actions: [MusicPodcastQuickAction]
    public let health: MusicPodcastHealth

    public init(
        snapshot: MusicPodcastDashboardSnapshot,
        collections: [MusicPodcastCollectionCard],
        actions: [MusicPodcastQuickAction],
        health: MusicPodcastHealth
    ) {
        self.snapshot = snapshot
        self.collections = collections
        self.actions = actions
        self.health = health
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Playback Center") {
                    MusicPodcastSummaryCard(
                        snapshot: snapshot,
                        health: health
                    )
                }

                Section("Collections") {
                    ForEach(collections) { collection in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(collection.title)
                            Text("\(collection.itemCount) items")
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
            .navigationTitle("MusicPodcastApp")
        }
    }
}

public struct MusicPodcastQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [MusicPodcastQuickAction] = [
        MusicPodcastQuickAction(title: "Resume Mix", systemImage: "play.fill"),
        MusicPodcastQuickAction(title: "Open Podcast Queue", systemImage: "text.line.first.and.arrowtriangle.forward"),
        MusicPodcastQuickAction(title: "Review Downloads", systemImage: "arrow.down.circle.fill")
    ]
}
