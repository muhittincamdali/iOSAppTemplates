import SwiftUI
import ProductivityAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct ProductivityAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            ProductivityDashboardView(
                summary: .sample,
                actions: ProductivityQuickAction.defaultActions
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct ProductivityDashboardView: View {
    public let summary: ProductivityWorkspaceSummary
    public let actions: [ProductivityQuickAction]

    public init(
        summary: ProductivityWorkspaceSummary,
        actions: [ProductivityQuickAction]
    ) {
        self.summary = summary
        self.actions = actions
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Today") {
                    LabeledContent("Open Tasks", value: "\(summary.openTasks)")
                    LabeledContent("Projects", value: "\(summary.activeProjects)")
                    LabeledContent("Focus Minutes", value: "\(summary.focusMinutes)")
                }

                Section("Quick Actions") {
                    ForEach(actions) { action in
                        Label(action.title, systemImage: action.systemImage)
                    }
                }
            }
            .navigationTitle("ProductivityApp")
        }
    }
}

public struct ProductivityQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [ProductivityQuickAction] = [
        ProductivityQuickAction(title: "Add Task", systemImage: "plus.circle.fill"),
        ProductivityQuickAction(title: "Start Focus Session", systemImage: "timer"),
        ProductivityQuickAction(title: "Review Projects", systemImage: "folder.fill")
    ]
}
