import SwiftUI
import ProductivityAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct ProductivityAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            ProductivityWorkspaceRootView(
                summary: .sample,
                actions: ProductivityQuickAction.defaultActions,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct ProductivityWorkspaceRootView: View {
    public let summary: ProductivityWorkspaceSummary
    public let actions: [ProductivityQuickAction]
    public let state: ProductivityWorkspaceState

    public init(
        summary: ProductivityWorkspaceSummary,
        actions: [ProductivityQuickAction],
        state: ProductivityWorkspaceState
    ) {
        self.summary = summary
        self.actions = actions
        self.state = state
    }

    public var body: some View {
        TabView {
            ProductivityDashboardView(summary: summary, actions: actions, state: state)
                .tabItem {
                    Image(systemName: "rectangle.3.group.bubble.left")
                    Text("Dashboard")
                }

            ProductivityInboxView(state: state)
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Inbox")
                }

            ProductivityProjectsView(state: state)
                .tabItem {
                    Image(systemName: "folder")
                    Text("Projects")
                }

            ProductivityFocusView(state: state)
                .tabItem {
                    Image(systemName: "timer")
                    Text("Focus")
                }

            ProductivityReviewView(state: state)
                .tabItem {
                    Image(systemName: "chart.bar.doc.horizontal")
                    Text("Review")
                }
        }
        .tint(.indigo)
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct ProductivityDashboardView: View {
    public let summary: ProductivityWorkspaceSummary
    public let actions: [ProductivityQuickAction]
    public let state: ProductivityWorkspaceState

    public init(
        summary: ProductivityWorkspaceSummary,
        actions: [ProductivityQuickAction],
        state: ProductivityWorkspaceState
    ) {
        self.summary = summary
        self.actions = actions
        self.state = state
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ProductivityHeroCard(summary: summary, state: state)
                    ProductivityQuickActionGrid(actions: actions)
                    ProductivityPriorityStrip(tasks: state.priorityTasks)
                    ProductivityTimelineCard(blocks: state.todayTimeline)
                    ProductivityProjectHealthCard(projects: state.projects)
                }
                .padding(16)
            }
            .navigationTitle("Workspace")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityHeroCard: View {
    let summary: ProductivityWorkspaceSummary
    let state: ProductivityWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today")
                .font(.headline)
                .foregroundStyle(.secondary)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(summary.upcomingDeadline)
                        .font(.title2.weight(.bold))
                    Text("Keep the launch review on track and protect the deep-work block before it.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "bolt.badge.clock")
                    .font(.system(size: 32))
                    .foregroundStyle(.indigo)
            }

            HStack(spacing: 12) {
                ProductivityMetricChip(title: "Open Tasks", value: "\(summary.openTasks)")
                ProductivityMetricChip(title: "Projects", value: "\(summary.activeProjects)")
                ProductivityMetricChip(title: "Focus", value: "\(summary.focusMinutes)m")
            }

            HStack {
                Text("Team load")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(state.teamLoadStatus)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.indigo.opacity(0.15), .blue.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityMetricChip: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityQuickActionGrid: View {
    let actions: [ProductivityQuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions) { action in
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: action.systemImage)
                            .font(.title3)
                            .foregroundStyle(.indigo)
                        Text(action.title)
                            .font(.subheadline.weight(.semibold))
                        Text(action.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityPriorityStrip: View {
    let tasks: [ProductivityTask]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Priority Queue")
                .font(.title3.weight(.bold))

            ForEach(tasks) { task in
                NavigationLink {
                    ProductivityTaskDetailView(task: task)
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        Circle()
                            .fill(task.priority.color)
                            .frame(width: 10, height: 10)
                            .padding(.top, 6)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(task.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text(task.detail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                            HStack {
                                Label(task.project, systemImage: "folder")
                                Label(task.dueLabel, systemImage: "calendar")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityTimelineCard: View {
    let blocks: [ProductivityTimelineBlock]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today Timeline")
                .font(.title3.weight(.bold))

            ForEach(blocks) { block in
                HStack(alignment: .top, spacing: 12) {
                    Text(block.time)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 56, alignment: .leading)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(block.color)
                        .frame(width: 6, height: 42)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(block.title)
                            .font(.subheadline.weight(.semibold))
                        Text(block.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityProjectHealthCard: View {
    let projects: [ProductivityProject]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Project Health")
                .font(.title3.weight(.bold))

            ForEach(projects) { project in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(project.name)
                            .font(.headline)
                        Spacer()
                        Text(project.status)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(project.statusColor)
                    }
                    ProgressView(value: project.progress)
                        .tint(project.statusColor)
                    HStack {
                        Text(project.owner)
                        Spacer()
                        Text("\(Int(project.progress * 100))% complete")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityInboxView: View {
    let state: ProductivityWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Needs Attention") {
                    ForEach(state.priorityTasks) { task in
                        NavigationLink {
                            ProductivityTaskDetailView(task: task)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(task.title)
                                Text(task.detail)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Later Today") {
                    ForEach(state.backlogTasks) { task in
                        NavigationLink {
                            ProductivityTaskDetailView(task: task)
                        } label: {
                            HStack {
                                Text(task.title)
                                Spacer()
                                Text(task.priority.label)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Inbox")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityProjectsView: View {
    let state: ProductivityWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.projects) { project in
                    NavigationLink {
                        ProductivityProjectDetailView(project: project, tasks: tasks(for: project))
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(project.name)
                                    .font(.headline)
                                Spacer()
                                Text(project.status)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(project.statusColor)
                            }
                            Text(project.owner)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            ProgressView(value: project.progress)
                                .tint(project.statusColor)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Projects")
        }
    }

    private func tasks(for project: ProductivityProject) -> [ProductivityTask] {
        (state.priorityTasks + state.backlogTasks).filter { $0.project == project.name }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityFocusView: View {
    let state: ProductivityWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Focus Session")
                            .font(.title3.weight(.bold))
                        Text("52 minutes")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                        Text("Current target: Finalize the launch review deck and decision notes.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Focus Rules")
                            .font(.title3.weight(.bold))
                        ForEach(state.focusRules, id: \.self) { rule in
                            Label(rule, systemImage: "checkmark.circle")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Deep Work Queue")
                            .font(.title3.weight(.bold))
                        ForEach(state.focusQueue) { task in
                            ProductivityFocusTaskRow(task: task)
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Focus")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityFocusTaskRow: View {
    let task: ProductivityTask

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "bolt.fill")
                .foregroundStyle(.indigo)
                .padding(.top, 4)
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                Text(task.detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityReviewView: View {
    let state: ProductivityWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Weekly Review") {
                    LabeledContent("Completed Tasks", value: "21")
                    LabeledContent("Focus Hours", value: "7.5h")
                    LabeledContent("Blocked Items", value: "2")
                }

                Section("Risks") {
                    ForEach(state.reviewRisks, id: \.self) { risk in
                        Label(risk, systemImage: "exclamationmark.triangle")
                    }
                }

                Section("Next Moves") {
                    ForEach(state.reviewActions, id: \.self) { action in
                        Label(action, systemImage: "arrow.right.circle")
                    }
                }
            }
            .navigationTitle("Review")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityTaskDetailView: View {
    let task: ProductivityTask

    var body: some View {
        List {
            Section("Task") {
                Text(task.title)
                    .font(.headline)
                Text(task.detail)
                    .foregroundStyle(.secondary)
            }

            Section("Execution") {
                LabeledContent("Project", value: task.project)
                LabeledContent("Priority", value: task.priority.label)
                LabeledContent("Due", value: task.dueLabel)
                LabeledContent("Owner", value: task.owner)
            }

            Section("Definition of Done") {
                ForEach(task.doneCriteria, id: \.self) { criterion in
                    Label(criterion, systemImage: "checkmark.circle")
                }
            }
        }
        .navigationTitle("Task")
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityProjectDetailView: View {
    let project: ProductivityProject
    let tasks: [ProductivityTask]

    var body: some View {
        List {
            Section("Overview") {
                LabeledContent("Owner", value: project.owner)
                LabeledContent("Status", value: project.status)
                LabeledContent("Progress", value: "\(Int(project.progress * 100))%")
            }

            Section("Open Work") {
                ForEach(tasks) { task in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                        Text(task.dueLabel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle(project.name)
    }
}

public struct ProductivityQuickAction: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let systemImage: String
    public let detail: String

    public init(
        id: UUID = UUID(),
        title: String,
        systemImage: String,
        detail: String
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.detail = detail
    }

    public static let defaultActions: [ProductivityQuickAction] = [
        ProductivityQuickAction(title: "Add Task", systemImage: "plus.circle.fill", detail: "Capture a new inbound task before it gets lost."),
        ProductivityQuickAction(title: "Start Focus Session", systemImage: "timer", detail: "Lock a deep-work block and hide notification noise."),
        ProductivityQuickAction(title: "Review Projects", systemImage: "folder.fill", detail: "Audit health, risks, and owners across active work."),
        ProductivityQuickAction(title: "Plan Tomorrow", systemImage: "calendar.badge.clock", detail: "Queue the next day before context disappears.")
    ]
}

public struct ProductivityWorkspaceState: Hashable, Sendable {
    public let priorityTasks: [ProductivityTask]
    public let backlogTasks: [ProductivityTask]
    public let projects: [ProductivityProject]
    public let todayTimeline: [ProductivityTimelineBlock]
    public let focusRules: [String]
    public let focusQueue: [ProductivityTask]
    public let reviewRisks: [String]
    public let reviewActions: [String]
    public let teamLoadStatus: String

    public static let sample = ProductivityWorkspaceState(
        priorityTasks: [
            ProductivityTask(
                title: "Finalize launch review narrative",
                detail: "Tighten the go/no-go decision surface and add the missing rollout risks.",
                project: "Release Ops",
                priority: .critical,
                dueLabel: "Today · 16:00",
                owner: "Muhittin",
                doneCriteria: ["Decision notes updated", "Risk section reviewed", "Links validated"]
            ),
            ProductivityTask(
                title: "Review screenshot host collisions",
                detail: "Make the runtime host pipeline safe under parallel asset generation.",
                project: "Proof System",
                priority: .high,
                dueLabel: "Today · 18:30",
                owner: "Muhittin",
                doneCriteria: ["Unique temp path", "No XcodeGen collisions", "Regression proof added"]
            )
        ],
        backlogTasks: [
            ProductivityTask(
                title: "Prepare next flagship backlog",
                detail: "Map Productivity and Finance rebuilds against current shell gaps.",
                project: "Template Portfolio",
                priority: .medium,
                dueLabel: "Tomorrow",
                owner: "Muhittin",
                doneCriteria: ["Gap matrix written", "Priority order set"]
            ),
            ProductivityTask(
                title: "Refine issue intake labels",
                detail: "Split runtime, docs, and app quality defects into separate routes.",
                project: "Repo Ops",
                priority: .medium,
                dueLabel: "Tomorrow",
                owner: "Muhittin",
                doneCriteria: ["Labels cleaned", "Templates updated"]
            )
        ],
        projects: [
            ProductivityProject(name: "Release Ops", owner: "Muhittin", progress: 0.72, status: "At Risk"),
            ProductivityProject(name: "Proof System", owner: "Muhittin", progress: 0.84, status: "Healthy"),
            ProductivityProject(name: "Template Portfolio", owner: "Muhittin", progress: 0.58, status: "Needs Focus")
        ],
        todayTimeline: [
            ProductivityTimelineBlock(time: "09:00", title: "Deep Work", detail: "Finish flagship app rebuild batch", color: .indigo),
            ProductivityTimelineBlock(time: "11:30", title: "Review Window", detail: "Check build, launch, and runtime assets", color: .blue),
            ProductivityTimelineBlock(time: "14:00", title: "Decision Session", detail: "Finalize next flagship priorities", color: .orange),
            ProductivityTimelineBlock(time: "16:00", title: "Launch Review", detail: "Go/no-go with updated evidence", color: .green)
        ],
        focusRules: [
            "Mute non-critical notifications during the 52-minute block.",
            "Keep one active task only; everything else goes to inbox.",
            "Capture blockers immediately instead of context switching."
        ],
        focusQueue: [
            ProductivityTask(
                title: "Polish interaction scenario proof",
                detail: "Turn first-screen proof into meaningful second-step automation.",
                project: "Proof System",
                priority: .high,
                dueLabel: "This afternoon",
                owner: "Muhittin",
                doneCriteria: ["Second-step path recorded", "Docs updated"]
            )
        ],
        reviewRisks: [
            "Asset pipeline still shares a single temporary runtime host path.",
            "Flagship three improved, but finance and productivity shells are still shallow."
        ],
        reviewActions: [
            "Rebuild ProductivityApp task/project/focus flows.",
            "Follow with FinanceApp account/transaction/budget flows.",
            "Add parallel-safe runtime host generation."
        ],
        teamLoadStatus: "1 owner across 3 active flagship rebuilds"
    )
}

public struct ProductivityTask: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let detail: String
    public let project: String
    public let priority: ProductivityPriority
    public let dueLabel: String
    public let owner: String
    public let doneCriteria: [String]

    public init(
        id: UUID = UUID(),
        title: String,
        detail: String,
        project: String,
        priority: ProductivityPriority,
        dueLabel: String,
        owner: String,
        doneCriteria: [String]
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.project = project
        self.priority = priority
        self.dueLabel = dueLabel
        self.owner = owner
        self.doneCriteria = doneCriteria
    }
}

public struct ProductivityProject: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let name: String
    public let owner: String
    public let progress: Double
    public let status: String

    public init(
        id: UUID = UUID(),
        name: String,
        owner: String,
        progress: Double,
        status: String
    ) {
        self.id = id
        self.name = name
        self.owner = owner
        self.progress = progress
        self.status = status
    }

    var statusColor: Color {
        switch status {
        case "Healthy": return .green
        case "At Risk": return .orange
        default: return .indigo
        }
    }
}

public struct ProductivityTimelineBlock: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let time: String
    public let title: String
    public let detail: String
    public let colorName: String

    public init(
        id: UUID = UUID(),
        time: String,
        title: String,
        detail: String,
        color: Color
    ) {
        self.id = id
        self.time = time
        self.title = title
        self.detail = detail
        self.colorName = color.description
    }

    var color: Color {
        switch colorName {
        case "blue": return .blue
        case "orange": return .orange
        case "green": return .green
        default: return .indigo
        }
    }
}

public enum ProductivityPriority: String, Hashable, Sendable {
    case critical
    case high
    case medium

    var label: String {
        rawValue.capitalized
    }

    var color: Color {
        switch self {
        case .critical: return .red
        case .high: return .orange
        case .medium: return .blue
        }
    }
}
