import SwiftUI
import TeamCollaborationAppCore
import TeamCollaborationAppUI

@available(iOS 18.0, macOS 15.0, *)
public struct TeamCollaborationAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            TeamCollaborationDashboardView(
                snapshot: .sample,
                projects: TeamCollaborationProjectCard.sampleCards,
                actions: TeamCollaborationQuickAction.defaultActions,
                health: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct TeamCollaborationDashboardView: View {
    public let snapshot: TeamCollaborationDashboardSnapshot
    public let projects: [TeamCollaborationProjectCard]
    public let actions: [TeamCollaborationQuickAction]
    public let health: TeamCollaborationOperationalHealth

    public init(
        snapshot: TeamCollaborationDashboardSnapshot,
        projects: [TeamCollaborationProjectCard],
        actions: [TeamCollaborationQuickAction],
        health: TeamCollaborationOperationalHealth
    ) {
        self.snapshot = snapshot
        self.projects = projects
        self.actions = actions
        self.health = health
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Collaboration Overview") {
                    TeamCollaborationSummaryCard(
                        snapshot: snapshot,
                        health: health
                    )
                }

                Section("Project Streams") {
                    ForEach(projects) { project in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(project.title)
                            Text("\(project.contributorCount) contributors")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(project.ctaLabel)
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
            .navigationTitle("TeamCollaborationApp")
        }
    }
}

public struct TeamCollaborationQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [TeamCollaborationQuickAction] = [
        TeamCollaborationQuickAction(title: "Open Decision Board", systemImage: "rectangle.and.pencil.and.ellipsis"),
        TeamCollaborationQuickAction(title: "Review Async Standups", systemImage: "person.3.fill"),
        TeamCollaborationQuickAction(title: "Inspect Handoffs", systemImage: "arrow.left.arrow.right.square.fill")
    ]
}
