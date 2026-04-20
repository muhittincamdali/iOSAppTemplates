import SwiftUI
import CRMAdminAppCore
import CRMAdminAppUI

@available(iOS 18.0, macOS 15.0, *)
public struct CRMAdminAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            CRMAdminDashboardView(
                snapshot: .sample,
                workspaces: CRMAdminWorkspaceCard.sampleCards,
                actions: CRMAdminQuickAction.defaultActions,
                health: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct CRMAdminDashboardView: View {
    public let snapshot: CRMAdminDashboardSnapshot
    public let workspaces: [CRMAdminWorkspaceCard]
    public let actions: [CRMAdminQuickAction]
    public let health: CRMAdminOperationalHealth

    public init(
        snapshot: CRMAdminDashboardSnapshot,
        workspaces: [CRMAdminWorkspaceCard],
        actions: [CRMAdminQuickAction],
        health: CRMAdminOperationalHealth
    ) {
        self.snapshot = snapshot
        self.workspaces = workspaces
        self.actions = actions
        self.health = health
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("CRM Overview") {
                    CRMAdminSummaryCard(
                        snapshot: snapshot,
                        health: health
                    )
                }

                Section("Workspace Lanes") {
                    ForEach(workspaces) { workspace in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(workspace.title)
                            Text("\(workspace.ownerCount) owners")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(workspace.ctaLabel)
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
            .navigationTitle("CRMAdminApp")
        }
    }
}

public struct CRMAdminQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [CRMAdminQuickAction] = [
        CRMAdminQuickAction(title: "Review At-Risk Accounts", systemImage: "person.crop.circle.badge.exclamationmark"),
        CRMAdminQuickAction(title: "Open Renewal Queue", systemImage: "calendar.badge.clock"),
        CRMAdminQuickAction(title: "Inspect SLA Board", systemImage: "checklist")
    ]
}
