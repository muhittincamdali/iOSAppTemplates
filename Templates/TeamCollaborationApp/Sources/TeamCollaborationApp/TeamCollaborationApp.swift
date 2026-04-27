import SwiftUI
import TeamCollaborationAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct TeamCollaborationAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            TeamCollaborationWorkspaceRootView(
                snapshot: .sample,
                projects: TeamCollaborationProjectCard.sampleCards,
                actions: TeamCollaborationQuickAction.defaultActions,
                health: .sample,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationWorkspaceRootView: View {
    let snapshot: TeamCollaborationDashboardSnapshot
    let projects: [TeamCollaborationProjectCard]
    let actions: [TeamCollaborationQuickAction]
    let health: TeamCollaborationOperationalHealth
    let state: TeamCollaborationWorkspaceState

    var body: some View {
        TabView {
            TeamCollaborationDashboardView(
                snapshot: snapshot,
                projects: projects,
                actions: actions,
                health: health,
                state: state
            )
            .tabItem {
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                Text("Workspace")
            }

            TeamCollaborationTasksView(state: state)
                .tabItem {
                    Image(systemName: "checklist.checked")
                    Text("Tasks")
                }

            TeamCollaborationDecisionsView(state: state)
                .tabItem {
                    Image(systemName: "arrow.triangle.branch")
                    Text("Decisions")
                }

            TeamCollaborationHandoffsView(state: state)
                .tabItem {
                    Image(systemName: "arrow.left.arrow.right.square.fill")
                    Text("Handoffs")
                }

            TeamCollaborationProfileView(snapshot: snapshot, health: health, state: state)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.blue)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationDashboardView: View {
    let snapshot: TeamCollaborationDashboardSnapshot
    let projects: [TeamCollaborationProjectCard]
    let actions: [TeamCollaborationQuickAction]
    let health: TeamCollaborationOperationalHealth
    let state: TeamCollaborationWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TeamCollaborationHeroCard(snapshot: snapshot, health: health, state: state)
                    TeamCollaborationQuickActionGrid(actions: actions)
                    TeamCollaborationDecisionBoardCard(items: state.openDecisions)
                    TeamCollaborationProjectPulseCard(projects: projects)
                    TeamCollaborationStandupCard(updates: state.asyncStandups)
                }
                .padding(16)
            }
            .navigationTitle("Collaboration")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationHeroCard: View {
    let snapshot: TeamCollaborationDashboardSnapshot
    let health: TeamCollaborationOperationalHealth
    let state: TeamCollaborationWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Workspace Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(state.operatorHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(snapshot.workspaceHealth)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                TeamCollaborationMetricChip(title: "Projects", value: "\(snapshot.activeProjects)")
                TeamCollaborationMetricChip(title: "Decisions", value: "\(snapshot.openDecisions)")
                TeamCollaborationMetricChip(title: "Standups", value: "\(snapshot.dailyStandups)")
            }

            HStack {
                Label(state.shiftWindow, systemImage: "clock.fill")
                Spacer()
                Text("\(health.averageReplyMinutes) min reply")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.blue)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.blue.opacity(0.16), .cyan.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationMetricChip: View {
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
struct TeamCollaborationQuickActionGrid: View {
    let actions: [TeamCollaborationQuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions) { action in
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: action.systemImage)
                            .font(.title3)
                            .foregroundStyle(.blue)
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
struct TeamCollaborationDecisionBoardCard: View {
    let items: [TeamCollaborationDecision]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Decision Board")
                .font(.title3.weight(.bold))

            ForEach(items) { item in
                NavigationLink {
                    TeamCollaborationDecisionDetailView(item: item)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(item.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(item.status)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(item.statusColor)
                        }
                        Text(item.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                        Text("\(item.owner) • \(item.deadline)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
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
struct TeamCollaborationProjectPulseCard: View {
    let projects: [TeamCollaborationProjectCard]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Project Pulse")
                .font(.title3.weight(.bold))

            ForEach(projects) { project in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(project.title)
                            .font(.headline)
                        Text("\(project.contributorCount) contributors")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(project.ctaLabel)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.blue)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationStandupCard: View {
    let updates: [TeamCollaborationStandup]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Async Standups")
                .font(.title3.weight(.bold))

            ForEach(updates) { update in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.blue)
                        .frame(width: 20)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(update.owner)
                            .font(.headline)
                        Text(update.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(update.nextStep)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationTasksView: View {
    let state: TeamCollaborationWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.tasks) { task in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(task.title)
                        Text(task.project)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(task.owner) • \(task.status)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Tasks")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationDecisionsView: View {
    let state: TeamCollaborationWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.openDecisions) { item in
                    NavigationLink {
                        TeamCollaborationDecisionDetailView(item: item)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.title)
                            Text(item.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(item.owner) • \(item.deadline)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Decisions")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationHandoffsView: View {
    let state: TeamCollaborationWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.handoffs) { handoff in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(handoff.title)
                        Text(handoff.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(handoff.fromTeam) -> \(handoff.toTeam)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Handoffs")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationProfileView: View {
    let snapshot: TeamCollaborationDashboardSnapshot
    let health: TeamCollaborationOperationalHealth
    let state: TeamCollaborationWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Operator") {
                    Label(state.workspaceLead, systemImage: "person.crop.circle.fill")
                    Label(state.teamScope, systemImage: "building.2.fill")
                }
                Section("Workspace Metrics") {
                    Label("\(snapshot.activeProjects) active projects", systemImage: "rectangle.3.group.fill")
                    Label("\(snapshot.openDecisions) open decisions", systemImage: "arrow.triangle.branch")
                    Label("\(state.handoffCadence) handoff cadence", systemImage: "arrow.left.arrow.right.circle.fill")
                }
                Section("Operating Rules") {
                    Label("\(health.reviewQueue) items in review", systemImage: "tray.full.fill")
                    Label(health.handoffReady ? "Handoff ready" : "Handoff blocked", systemImage: health.handoffReady ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    Label(state.decisionPolicy, systemImage: "checkmark.seal.fill")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationDecisionDetailView: View {
    let item: TeamCollaborationDecision

    var body: some View {
        List {
            Section("Decision") {
                Text(item.title)
                    .font(.title3.weight(.bold))
                Text(item.summary)
                    .foregroundStyle(.secondary)
            }
            Section("Ownership") {
                Label(item.owner, systemImage: "person.fill")
                Label(item.deadline, systemImage: "clock.fill")
                Label(item.status, systemImage: "checkmark.circle.fill")
            }
            Section("Decision Tracks") {
                ForEach(item.tracks, id: \.self) { track in
                    Label(track, systemImage: "arrowshape.turn.up.right.circle")
                }
            }
        }
        .navigationTitle("Decision")
    }
}

public struct TeamCollaborationQuickAction: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let detail: String
    public let systemImage: String

    public init(
        id: UUID = UUID(),
        title: String,
        detail: String,
        systemImage: String
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.systemImage = systemImage
    }

    public static let defaultActions: [TeamCollaborationQuickAction] = [
        TeamCollaborationQuickAction(title: "Open Decision Board", detail: "Review pending product, design and GTM decisions before the overlap ends.", systemImage: "rectangle.and.pencil.and.ellipsis"),
        TeamCollaborationQuickAction(title: "Review Async Standups", detail: "Check blockers and updates before routing work to the next team.", systemImage: "person.3.fill"),
        TeamCollaborationQuickAction(title: "Inspect Handoffs", detail: "Validate ownership, due dates and review trails across cross-team work.", systemImage: "arrow.left.arrow.right.square.fill")
    ]
}

struct TeamCollaborationWorkspaceState {
    let operatorHeadline: String
    let shiftWindow: String
    let workspaceLead: String
    let teamScope: String
    let handoffCadence: String
    let decisionPolicy: String
    let openDecisions: [TeamCollaborationDecision]
    let asyncStandups: [TeamCollaborationStandup]
    let tasks: [TeamCollaborationTask]
    let handoffs: [TeamCollaborationHandoff]

    static let sample = TeamCollaborationWorkspaceState(
        operatorHeadline: "Cross-team handoffs are under control",
        shiftWindow: "Overlap window closes at 18:00",
        workspaceLead: "Ethan Cole",
        teamScope: "Product, design and operations alignment",
        handoffCadence: "Twice daily",
        decisionPolicy: "Every launch blocker needs one owner, one due date and one written decision log",
        openDecisions: [
            TeamCollaborationDecision(title: "Launch copy freeze", owner: "Mia", deadline: "Today 17:30", status: "Waiting", summary: "Marketing, product and legal need a final decision on headline claims.", tracks: ["Finalize approved copy", "Lock localization scope", "Ship banner assets"]),
            TeamCollaborationDecision(title: "Support routing redesign", owner: "Jon", deadline: "Tomorrow 10:00", status: "In review", summary: "Ops and support are aligning the new escalation path before rollout.", tracks: ["Agree on queue ownership", "Confirm reporting fields", "Publish runbook update"])
        ],
        asyncStandups: [
            TeamCollaborationStandup(owner: "Ava", summary: "Design system tokens are ready; waiting on product sign-off for the component merge.", nextStep: "Collect sign-off by 16:00."),
            TeamCollaborationStandup(owner: "Noah", summary: "Customer ops cleared 80% of inbox backlog after new routing rules went live.", nextStep: "Monitor for SLA drift tonight."),
            TeamCollaborationStandup(owner: "Lena", summary: "Engineering resolved the export bug and prepared the release branch.", nextStep: "Schedule rollout after QA handoff.")
        ],
        tasks: [
            TeamCollaborationTask(title: "Finalize onboarding copy", project: "Launch Sprint", owner: "Mia", status: "In review"),
            TeamCollaborationTask(title: "Audit support escalation paths", project: "Customer Ops", owner: "Jon", status: "Active"),
            TeamCollaborationTask(title: "Ship component token refresh", project: "Design System", owner: "Ava", status: "Blocked")
        ],
        handoffs: [
            TeamCollaborationHandoff(title: "Release handoff", fromTeam: "Engineering", toTeam: "QA", summary: "Feature branch is ready for final smoke and production gate review."),
            TeamCollaborationHandoff(title: "Support handoff", fromTeam: "Customer Ops", toTeam: "Evening Support", summary: "Three VIP tickets and one fraud escalation need continuity tonight."),
            TeamCollaborationHandoff(title: "Design handoff", fromTeam: "Design", toTeam: "Marketing", summary: "Approved banner system and motion assets are ready for campaign prep.")
        ]
    )
}

struct TeamCollaborationDecision: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let owner: String
    let deadline: String
    let status: String
    let summary: String
    let tracks: [String]

    var statusColor: Color {
        switch status {
        case "In review":
            return .orange
        case "Waiting":
            return .red
        default:
            return .blue
        }
    }
}

struct TeamCollaborationStandup: Identifiable, Hashable {
    let id = UUID()
    let owner: String
    let summary: String
    let nextStep: String
}

struct TeamCollaborationTask: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let project: String
    let owner: String
    let status: String
}

struct TeamCollaborationHandoff: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let fromTeam: String
    let toTeam: String
    let summary: String
}
