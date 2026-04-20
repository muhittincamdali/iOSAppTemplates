import SwiftUI
import NewsBlogAppCore
import NewsBlogAppUI

@available(iOS 18.0, macOS 15.0, *)
public struct NewsBlogAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            NewsBlogDashboardView(
                snapshot: .sample,
                categories: NewsBlogCategoryCard.sampleCards,
                actions: NewsBlogQuickAction.defaultActions,
                health: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct NewsBlogDashboardView: View {
    public let snapshot: NewsBlogDashboardSnapshot
    public let categories: [NewsBlogCategoryCard]
    public let actions: [NewsBlogQuickAction]
    public let health: NewsBlogPublishingHealth

    public init(
        snapshot: NewsBlogDashboardSnapshot,
        categories: [NewsBlogCategoryCard],
        actions: [NewsBlogQuickAction],
        health: NewsBlogPublishingHealth
    ) {
        self.snapshot = snapshot
        self.categories = categories
        self.actions = actions
        self.health = health
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Editorial Briefing") {
                    NewsBlogSummaryCard(
                        snapshot: snapshot,
                        health: health
                    )
                }

                Section("Sections") {
                    ForEach(categories) { category in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(category.title)
                            Text("\(category.articleCount) ready items")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(category.ctaLabel)
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
            .navigationTitle("NewsBlogApp")
        }
    }
}

public struct NewsBlogQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [NewsBlogQuickAction] = [
        NewsBlogQuickAction(title: "Open Reader Mode", systemImage: "text.justify"),
        NewsBlogQuickAction(title: "Review Breaking Queue", systemImage: "bolt.fill"),
        NewsBlogQuickAction(title: "Schedule Newsletter", systemImage: "envelope.fill")
    ]
}
