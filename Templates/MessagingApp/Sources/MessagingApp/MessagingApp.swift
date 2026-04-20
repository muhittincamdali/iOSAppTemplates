import SwiftUI
import MessagingAppCore
import MessagingAppUI

@available(iOS 18.0, macOS 15.0, *)
public struct MessagingAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            MessagingDashboardView(
                snapshot: .sample,
                conversations: MessagingConversationCard.sampleCards,
                actions: MessagingQuickAction.defaultActions,
                health: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct MessagingDashboardView: View {
    public let snapshot: MessagingDashboardSnapshot
    public let conversations: [MessagingConversationCard]
    public let actions: [MessagingQuickAction]
    public let health: MessagingOperationalHealth

    public init(
        snapshot: MessagingDashboardSnapshot,
        conversations: [MessagingConversationCard],
        actions: [MessagingQuickAction],
        health: MessagingOperationalHealth
    ) {
        self.snapshot = snapshot
        self.conversations = conversations
        self.actions = actions
        self.health = health
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Messaging Overview") {
                    MessagingSummaryCard(
                        snapshot: snapshot,
                        health: health
                    )
                }

                Section("Conversations") {
                    ForEach(conversations) { conversation in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(conversation.title)
                            Text("\(conversation.participantCount) participants")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(conversation.ctaLabel)
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
            .navigationTitle("MessagingApp")
        }
    }
}

public struct MessagingQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [MessagingQuickAction] = [
        MessagingQuickAction(title: "Open Priority Inbox", systemImage: "tray.full.fill"),
        MessagingQuickAction(title: "Review Community Rooms", systemImage: "person.3.fill"),
        MessagingQuickAction(title: "Moderate Safety Queue", systemImage: "shield.lefthalf.filled")
    ]
}
