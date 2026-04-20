import SwiftUI
import AIAssistantAppCore
import AIAssistantAppUI

@available(iOS 18.0, macOS 15.0, *)
public struct AIAssistantAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            AIAssistantDashboardView(
                snapshot: .sample,
                tasks: AIAssistantTaskCard.sampleCards,
                actions: AIAssistantQuickAction.defaultActions,
                signals: AIAssistantSignal.sampleSignals
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct AIAssistantDashboardView: View {
    public let snapshot: AIAssistantWorkspaceSnapshot
    public let tasks: [AIAssistantTaskCard]
    public let actions: [AIAssistantQuickAction]
    public let signals: [AIAssistantSignal]

    public init(
        snapshot: AIAssistantWorkspaceSnapshot,
        tasks: [AIAssistantTaskCard],
        actions: [AIAssistantQuickAction],
        signals: [AIAssistantSignal]
    ) {
        self.snapshot = snapshot
        self.tasks = tasks
        self.actions = actions
        self.signals = signals
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Workspace") {
                    AIAssistantWorkspaceCard(
                        snapshot: snapshot,
                        signals: signals
                    )
                }

                Section("Suggested Tasks") {
                    ForEach(tasks) { task in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title)
                            Text(task.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Confidence: \(task.confidence)")
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
            .navigationTitle("AIAssistantApp")
        }
    }
}

public struct AIAssistantQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [AIAssistantQuickAction] = [
        AIAssistantQuickAction(title: "Summarize Notes", systemImage: "text.redaction"),
        AIAssistantQuickAction(title: "Draft Message", systemImage: "sparkles"),
        AIAssistantQuickAction(title: "Review Guardrails", systemImage: "checkmark.shield.fill")
    ]
}
