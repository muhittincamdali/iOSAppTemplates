import SwiftUI
import SubscriptionLifestyleAppCore
import SubscriptionLifestyleAppUI

@available(iOS 18.0, macOS 15.0, *)
public struct SubscriptionLifestyleAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            SubscriptionLifestyleDashboardView(
                snapshot: .sample,
                programs: SubscriptionLifestyleProgramCard.sampleCards,
                actions: SubscriptionLifestyleQuickAction.defaultActions,
                health: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct SubscriptionLifestyleDashboardView: View {
    public let snapshot: SubscriptionLifestyleDashboardSnapshot
    public let programs: [SubscriptionLifestyleProgramCard]
    public let actions: [SubscriptionLifestyleQuickAction]
    public let health: SubscriptionLifestyleOperationalHealth

    public init(
        snapshot: SubscriptionLifestyleDashboardSnapshot,
        programs: [SubscriptionLifestyleProgramCard],
        actions: [SubscriptionLifestyleQuickAction],
        health: SubscriptionLifestyleOperationalHealth
    ) {
        self.snapshot = snapshot
        self.programs = programs
        self.actions = actions
        self.health = health
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Subscription Overview") {
                    SubscriptionLifestyleSummaryCard(
                        snapshot: snapshot,
                        health: health
                    )
                }

                Section("Program Lanes") {
                    ForEach(programs) { program in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(program.title)
                            Text("\(program.participantCount) participants")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(program.ctaLabel)
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
            .navigationTitle("SubscriptionLifestyleApp")
        }
    }
}

public struct SubscriptionLifestyleQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [SubscriptionLifestyleQuickAction] = [
        SubscriptionLifestyleQuickAction(title: "Review Churn Watchlist", systemImage: "person.crop.circle.badge.xmark"),
        SubscriptionLifestyleQuickAction(title: "Open Paywall Experiments", systemImage: "creditcard.circle.fill"),
        SubscriptionLifestyleQuickAction(title: "Inspect Habit Ladder", systemImage: "chart.bar.doc.horizontal.fill")
    ]
}
