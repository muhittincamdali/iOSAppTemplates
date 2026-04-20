import SwiftUI
import CreatorShortVideoAppCore
import CreatorShortVideoAppUI

@available(iOS 18.0, macOS 15.0, *)
public struct CreatorShortVideoAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            CreatorShortVideoDashboardView(
                snapshot: .sample,
                channels: CreatorShortVideoChannelCard.sampleCards,
                actions: CreatorShortVideoQuickAction.defaultActions,
                health: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct CreatorShortVideoDashboardView: View {
    public let snapshot: CreatorShortVideoDashboardSnapshot
    public let channels: [CreatorShortVideoChannelCard]
    public let actions: [CreatorShortVideoQuickAction]
    public let health: CreatorShortVideoOperationalHealth

    public init(
        snapshot: CreatorShortVideoDashboardSnapshot,
        channels: [CreatorShortVideoChannelCard],
        actions: [CreatorShortVideoQuickAction],
        health: CreatorShortVideoOperationalHealth
    ) {
        self.snapshot = snapshot
        self.channels = channels
        self.actions = actions
        self.health = health
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Creator Studio Overview") {
                    CreatorShortVideoSummaryCard(
                        snapshot: snapshot,
                        health: health
                    )
                }

                Section("Content Lanes") {
                    ForEach(channels) { channel in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(channel.title)
                            Text("\(channel.clipCount) clips")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(channel.ctaLabel)
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
            .navigationTitle("CreatorShortVideoApp")
        }
    }
}

public struct CreatorShortVideoQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [CreatorShortVideoQuickAction] = [
        CreatorShortVideoQuickAction(title: "Open Clip Queue", systemImage: "video.badge.plus"),
        CreatorShortVideoQuickAction(title: "Review Community Cut", systemImage: "person.3.fill"),
        CreatorShortVideoQuickAction(title: "Inspect Retention Pulse", systemImage: "chart.line.uptrend.xyaxis")
    ]
}
