import SwiftUI
import FinanceAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct FinanceAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            FinanceDashboardView(
                snapshot: .sample,
                actions: FinanceQuickAction.defaultActions
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct FinanceDashboardView: View {
    public let snapshot: FinanceDashboardSnapshot
    public let actions: [FinanceQuickAction]

    public init(
        snapshot: FinanceDashboardSnapshot,
        actions: [FinanceQuickAction]
    ) {
        self.snapshot = snapshot
        self.actions = actions
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Overview") {
                    LabeledContent("Accounts", value: "\(snapshot.accounts)")
                    LabeledContent("Budget Usage", value: snapshot.budgetUsage)
                    LabeledContent("Net Cash", value: snapshot.netCash)
                }

                Section("Quick Actions") {
                    ForEach(actions) { action in
                        Label(action.title, systemImage: action.systemImage)
                    }
                }
            }
            .navigationTitle("FinanceApp")
        }
    }
}

public struct FinanceQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [FinanceQuickAction] = [
        FinanceQuickAction(title: "Review Budget", systemImage: "chart.pie.fill"),
        FinanceQuickAction(title: "Add Transaction", systemImage: "plus.rectangle.on.rectangle"),
        FinanceQuickAction(title: "Check Cash Flow", systemImage: "arrow.left.arrow.right")
    ]
}
