import SwiftUI
import EducationAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct EducationAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            EducationDashboardView(
                snapshot: .sample,
                actions: EducationQuickAction.defaultActions
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct EducationDashboardView: View {
    public let snapshot: EducationDashboardSnapshot
    public let actions: [EducationQuickAction]

    public init(
        snapshot: EducationDashboardSnapshot,
        actions: [EducationQuickAction]
    ) {
        self.snapshot = snapshot
        self.actions = actions
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Learning Overview") {
                    LabeledContent("Courses", value: "\(snapshot.activeCourses)")
                    LabeledContent("Completion", value: snapshot.completionRate)
                    LabeledContent("Next Milestone", value: snapshot.nextMilestone)
                }

                Section("Quick Actions") {
                    ForEach(actions) { action in
                        Label(action.title, systemImage: action.systemImage)
                    }
                }
            }
            .navigationTitle("EducationApp")
        }
    }
}

public struct EducationQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [EducationQuickAction] = [
        EducationQuickAction(title: "Continue Course", systemImage: "play.circle.fill"),
        EducationQuickAction(title: "Open Quiz", systemImage: "questionmark.circle.fill"),
        EducationQuickAction(title: "Review Progress", systemImage: "chart.bar.fill")
    ]
}
