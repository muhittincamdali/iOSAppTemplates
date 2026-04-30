import SwiftUI
import TeamCollaborationAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct TeamCollaborationAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            TeamCollaborationRuntimeRootView()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationRuntimeRootView: View {
    @StateObject private var store = TeamCollaborationOperationsStore()

    var body: some View {
        TabView {
            TeamCollaborationWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "rectangle.3.group.bubble.left.fill")
                    Text("Workspace")
                }

            TeamCollaborationTasksView(store: store)
                .tabItem {
                    Image(systemName: "checklist.checked")
                    Text("Tasks")
                }

            TeamCollaborationDecisionsView(store: store)
                .tabItem {
                    Image(systemName: "arrow.triangle.branch")
                    Text("Decisions")
                }

            TeamCollaborationHandoffsView(store: store)
                .tabItem {
                    Image(systemName: "arrow.left.arrow.right.square.fill")
                    Text("Handoffs")
                }

            TeamCollaborationProfileView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.blue)
    }
}

@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class TeamCollaborationOperationsStore: ObservableObject {
    @Published var standups: [TeamStandup]
    @Published var tasks: [CollaborationTask]
    @Published var decisions: [CollaborationDecision]
    @Published var handoffs: [CollaborationHandoff]
    @Published var operatorHeadline: String
    @Published var overlapWindow: String
    @Published var workspaceLead: String
    @Published var teamScope: String
    @Published var decisionPolicy: String
    @Published var completedShipments: Int
    @Published var blockedCount: Int
    @Published var reviewQueue: Int

    init(
        standups: [TeamStandup] = TeamStandup.samples,
        tasks: [CollaborationTask] = CollaborationTask.samples,
        decisions: [CollaborationDecision] = CollaborationDecision.samples,
        handoffs: [CollaborationHandoff] = CollaborationHandoff.samples,
        operatorHeadline: String = "Two launch blockers need sign-off before overlap closes.",
        overlapWindow: String = "Overlap window closes at 18:00",
        workspaceLead: String = "Ethan Cole",
        teamScope: String = "Product, design, support and GTM coordination",
        decisionPolicy: String = "Every blocker needs one owner, one decision and one receiving team.",
        completedShipments: Int = 12,
        blockedCount: Int = 2,
        reviewQueue: Int = 5
    ) {
        self.standups = standups
        self.tasks = tasks
        self.decisions = decisions
        self.handoffs = handoffs
        self.operatorHeadline = operatorHeadline
        self.overlapWindow = overlapWindow
        self.workspaceLead = workspaceLead
        self.teamScope = teamScope
        self.decisionPolicy = decisionPolicy
        self.completedShipments = completedShipments
        self.blockedCount = blockedCount
        self.reviewQueue = reviewQueue
    }

    var activeTasks: [CollaborationTask] {
        tasks.filter { $0.status != .done }
    }

    var pendingDecisions: [CollaborationDecision] {
        decisions.filter { $0.status != .published }
    }

    var liveHandoffs: [CollaborationHandoff] {
        handoffs.filter { $0.status != .completed }
    }

    func startTask(_ taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].status = .active
        tasks[index].update = "Execution resumed and owner accepted the current plan."
        operatorHeadline = "\(tasks[index].title) is back in execution."
        blockedCount = max(0, blockedCount - 1)
    }

    func unblockTask(_ taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].status = .review
        tasks[index].update = "Blocker removed and task moved to review lane."
        operatorHeadline = "\(tasks[index].owner) cleared a blocker for \(tasks[index].project)."
        blockedCount = max(0, blockedCount - 1)
        reviewQueue += 1
    }

    func completeTask(_ taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].status = .handoff
        tasks[index].update = "Task passed review and is now waiting for downstream handoff closure."
        operatorHeadline = "\(tasks[index].title) is ready for downstream handoff."
        reviewQueue = max(0, reviewQueue - 1)
    }

    func closeTask(_ taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].status = .done
        tasks[index].update = "Downstream team confirmed receipt and the task closed cleanly."
        operatorHeadline = "\(tasks[index].title) closed after downstream confirmation."
        completedShipments += 1
    }

    func approveDecision(_ decisionID: UUID) {
        guard let index = decisions.firstIndex(where: { $0.id == decisionID }) else { return }
        decisions[index].status = .approved
        decisions[index].note = "Decision approved by product, design and support."
        operatorHeadline = "\(decisions[index].title) is approved and ready for publication."
    }

    func alignDecision(_ decisionID: UUID) {
        guard let index = decisions.firstIndex(where: { $0.id == decisionID }) else { return }
        decisions[index].status = .aligned
        decisions[index].note = "Receiving teams aligned on rollout timing and acknowledgement order."
        operatorHeadline = "\(decisions[index].title) is aligned across receiving teams."
    }

    func publishDecision(_ decisionID: UUID) {
        guard let index = decisions.firstIndex(where: { $0.id == decisionID }) else { return }
        decisions[index].status = .published
        decisions[index].note = "Decision published to the workspace and routed to every receiving team."
        operatorHeadline = "\(decisions[index].title) was published to all teams."
        reviewQueue = max(0, reviewQueue - 1)
    }

    func queueHandoff(_ handoffID: UUID) {
        guard let index = handoffs.firstIndex(where: { $0.id == handoffID }) else { return }
        handoffs[index].status = .queued
        handoffs[index].note = "Assets and notes packaged for receiving team."
        operatorHeadline = "\(handoffs[index].title) is queued for receiver confirmation."
    }

    func acceptHandoff(_ handoffID: UUID) {
        guard let index = handoffs.firstIndex(where: { $0.id == handoffID }) else { return }
        handoffs[index].status = .accepted
        handoffs[index].note = "Receiving team accepted ownership and SLA."
        operatorHeadline = "\(handoffs[index].toTeam) accepted \(handoffs[index].title.lowercased())."
    }

    func completeHandoff(_ handoffID: UUID) {
        guard let index = handoffs.firstIndex(where: { $0.id == handoffID }) else { return }
        handoffs[index].status = .verified
        handoffs[index].note = "Receiving team verified assets, notes and SLA before final archive."
        operatorHeadline = "\(handoffs[index].title) verified by the receiving team."
    }

    func archiveHandoff(_ handoffID: UUID) {
        guard let index = handoffs.firstIndex(where: { $0.id == handoffID }) else { return }
        handoffs[index].status = .completed
        handoffs[index].note = "Handoff archived after both teams signed the completion trail."
        operatorHeadline = "\(handoffs[index].title) closed cleanly."
        completedShipments += 1
    }

    func resolveStandup(_ standupID: UUID) {
        guard let index = standups.firstIndex(where: { $0.id == standupID }) else { return }
        standups[index].status = .resolved
        standups[index].nextStep = "Owner confirmed the blocker is closed and the lane is green."
        operatorHeadline = "\(standups[index].owner) closed a standup blocker."
        blockedCount = max(0, blockedCount - 1)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationWorkspaceView: View {
    @ObservedObject var store: TeamCollaborationOperationsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TeamWorkspaceHeroCard(store: store)
                    TeamMetricRow(store: store)
                    TeamStandupBoard(store: store)
                    TeamDecisionLane(store: store)
                    TeamHandoffLane(store: store)
                }
                .padding(16)
            }
            .navigationTitle("Collaboration")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamWorkspaceHeroCard: View {
    @ObservedObject var store: TeamCollaborationOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Workspace Pulse")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(store.operatorHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(store.teamScope)
                .foregroundStyle(.secondary)

            HStack {
                Label(store.overlapWindow, systemImage: "clock.fill")
                Spacer()
                Text("\(store.reviewQueue) items in review")
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
struct TeamMetricRow: View {
    @ObservedObject var store: TeamCollaborationOperationsStore

    var body: some View {
        HStack(spacing: 12) {
            TeamMetricChip(title: "Active Tasks", value: "\(store.activeTasks.count)")
            TeamMetricChip(title: "Pending Decisions", value: "\(store.pendingDecisions.count)")
            TeamMetricChip(title: "Closed Shipments", value: "\(store.completedShipments)")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamMetricChip: View {
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
struct TeamStandupBoard: View {
    @ObservedObject var store: TeamCollaborationOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Async Standups")
                .font(.title3.weight(.bold))

            ForEach(store.standups) { standup in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(standup.owner)
                            .font(.headline)
                        Spacer()
                        Text(standup.status.label)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(standup.status.color)
                    }
                    Text(standup.summary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(standup.nextStep)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if standup.status != .resolved {
                        Button("Resolve Blocker") {
                            store.resolveStandup(standup.id)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamDecisionLane: View {
    @ObservedObject var store: TeamCollaborationOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Decision Lane")
                .font(.title3.weight(.bold))

            ForEach(store.decisions) { decision in
                NavigationLink {
                    TeamDecisionDetailView(store: store, decisionID: decision.id)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(decision.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(decision.status.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(decision.status.color)
                        }
                        Text(decision.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(decision.note)
                            .font(.caption)
                            .foregroundStyle(.secondary)
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
struct TeamHandoffLane: View {
    @ObservedObject var store: TeamCollaborationOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Handoff Lane")
                .font(.title3.weight(.bold))

            ForEach(store.handoffs) { handoff in
                NavigationLink {
                    TeamHandoffDetailView(store: store, handoffID: handoff.id)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(handoff.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(handoff.status.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(handoff.status.color)
                        }
                        Text("\(handoff.fromTeam) -> \(handoff.toTeam)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(handoff.note)
                            .font(.caption)
                            .foregroundStyle(.secondary)
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
struct TeamCollaborationTasksView: View {
    @ObservedObject var store: TeamCollaborationOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.tasks) { task in
                    NavigationLink {
                        TeamTaskDetailView(store: store, taskID: task.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(task.title)
                                Spacer()
                                Text(task.status.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(task.status.color)
                            }
                            Text("\(task.project) • \(task.owner)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(task.update)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Tasks")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationDecisionsView: View {
    @ObservedObject var store: TeamCollaborationOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.decisions) { decision in
                    NavigationLink {
                        TeamDecisionDetailView(store: store, decisionID: decision.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(decision.title)
                            Text(decision.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(decision.note)
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
    @ObservedObject var store: TeamCollaborationOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.handoffs) { handoff in
                    NavigationLink {
                        TeamHandoffDetailView(store: store, handoffID: handoff.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(handoff.title)
                                Spacer()
                                Text(handoff.status.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(handoff.status.color)
                            }
                            Text("\(handoff.fromTeam) -> \(handoff.toTeam)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(handoff.note)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Handoffs")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamCollaborationProfileView: View {
    @ObservedObject var store: TeamCollaborationOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Operator") {
                    Label(store.workspaceLead, systemImage: "person.crop.circle.fill")
                    Label(store.teamScope, systemImage: "building.2.fill")
                }
                Section("Operating Metrics") {
                    Label("\(store.completedShipments) completed shipments", systemImage: "shippingbox.fill")
                    Label("\(store.blockedCount) blockers open", systemImage: "exclamationmark.triangle.fill")
                    Label("\(store.reviewQueue) items in review", systemImage: "tray.full.fill")
                }
                Section("Rules") {
                    Text(store.decisionPolicy)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamTaskDetailView: View {
    @ObservedObject var store: TeamCollaborationOperationsStore
    let taskID: UUID

    var body: some View {
        if let task = store.tasks.first(where: { $0.id == taskID }) {
            List {
                Section("Task") {
                    Text(task.title)
                        .font(.title3.weight(.bold))
                    Text(task.update)
                        .foregroundStyle(.secondary)
                }
                Section("Ownership") {
                    Label(task.project, systemImage: "folder.fill")
                    Label(task.owner, systemImage: "person.fill")
                    Label(task.status.label, systemImage: "checkmark.circle.fill")
                }
                Section("Actions") {
                    if task.status == .blocked {
                        Button("Start Task") { store.startTask(task.id) }
                        Button("Unblock Task") { store.unblockTask(task.id) }
                    } else if task.status == .active {
                        Button("Send to Review") { store.unblockTask(task.id) }
                    } else if task.status == .review {
                        Button("Route to Handoff") { store.completeTask(task.id) }
                    } else if task.status == .handoff {
                        Button("Close Task") { store.closeTask(task.id) }
                    }
                }
            }
            .navigationTitle("Task")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamDecisionDetailView: View {
    @ObservedObject var store: TeamCollaborationOperationsStore
    let decisionID: UUID

    var body: some View {
        if let decision = store.decisions.first(where: { $0.id == decisionID }) {
            List {
                Section("Decision") {
                    Text(decision.title)
                        .font(.title3.weight(.bold))
                    Text(decision.summary)
                        .foregroundStyle(.secondary)
                    Text(decision.note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Section("Tracks") {
                    ForEach(decision.tracks, id: \.self) { track in
                        Label(track, systemImage: "arrowshape.turn.up.right.circle")
                    }
                }
                Section("Actions") {
                    if decision.status == .review {
                        Button("Approve Decision") { store.approveDecision(decision.id) }
                    }
                    if decision.status == .approved {
                        Button("Align Receiving Teams") { store.alignDecision(decision.id) }
                    }
                    if decision.status == .aligned {
                        Button("Publish Decision") { store.publishDecision(decision.id) }
                    }
                }
            }
            .navigationTitle("Decision")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TeamHandoffDetailView: View {
    @ObservedObject var store: TeamCollaborationOperationsStore
    let handoffID: UUID

    var body: some View {
        if let handoff = store.handoffs.first(where: { $0.id == handoffID }) {
            List {
                Section("Handoff") {
                    Text(handoff.title)
                        .font(.title3.weight(.bold))
                    Text(handoff.summary)
                        .foregroundStyle(.secondary)
                    Text(handoff.note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Section("Routing") {
                    Label(handoff.fromTeam, systemImage: "arrow.up.circle.fill")
                    Label(handoff.toTeam, systemImage: "arrow.down.circle.fill")
                    Label(handoff.status.label, systemImage: "checkmark.circle.fill")
                }
                Section("Actions") {
                    if handoff.status == .draft {
                        Button("Queue Handoff") { store.queueHandoff(handoff.id) }
                    }
                    if handoff.status == .queued {
                        Button("Accept Handoff") { store.acceptHandoff(handoff.id) }
                    }
                    if handoff.status == .accepted {
                        Button("Verify Handoff") { store.completeHandoff(handoff.id) }
                    }
                    if handoff.status == .verified {
                        Button("Archive Handoff") { store.archiveHandoff(handoff.id) }
                    }
                }
            }
            .navigationTitle("Handoff")
        }
    }
}

enum CollaborationTaskStatus: String, CaseIterable, Hashable {
    case blocked
    case active
    case review
    case handoff
    case done

    var label: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .blocked: return .red
        case .active: return .orange
        case .review: return .blue
        case .handoff: return .indigo
        case .done: return .green
        }
    }
}

struct CollaborationTask: Identifiable, Hashable {
    let id: UUID
    let title: String
    let project: String
    let owner: String
    var status: CollaborationTaskStatus
    var update: String

    static let samples: [CollaborationTask] = [
        CollaborationTask(id: UUID(), title: "Finalize onboarding copy", project: "Launch Sprint", owner: "Mia", status: .review, update: "Legal comments landed and product is waiting for final review."),
        CollaborationTask(id: UUID(), title: "Audit support escalation paths", project: "Customer Ops", owner: "Jon", status: .active, update: "Ops is mapping the last three VIP cases into the new route."),
        CollaborationTask(id: UUID(), title: "Ship component token refresh", project: "Design System", owner: "Ava", status: .blocked, update: "Engineering needs final accessibility sign-off before merge.")
    ]
}

enum CollaborationDecisionStatus: String, Hashable {
    case review
    case approved
    case aligned
    case published

    var label: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .review: return .red
        case .approved: return .orange
        case .aligned: return .indigo
        case .published: return .green
        }
    }
}

struct CollaborationDecision: Identifiable, Hashable {
    let id: UUID
    let title: String
    let summary: String
    let tracks: [String]
    var status: CollaborationDecisionStatus
    var note: String

    static let samples: [CollaborationDecision] = [
        CollaborationDecision(id: UUID(), title: "Launch copy freeze", summary: "Marketing, product and legal need a final decision on claim language.", tracks: ["Finalize approved copy", "Lock localization scope", "Ship banner assets"], status: .review, note: "Awaiting one final legal pass."),
        CollaborationDecision(id: UUID(), title: "Support routing redesign", summary: "Ops and support are aligning the new escalation path before rollout.", tracks: ["Agree on queue ownership", "Confirm reporting fields", "Publish runbook update"], status: .approved, note: "Core routing approved; documentation not yet published.")
    ]
}

enum CollaborationHandoffStatus: String, Hashable {
    case draft
    case queued
    case accepted
    case verified
    case completed

    var label: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .draft: return .secondary
        case .queued: return .orange
        case .accepted: return .blue
        case .verified: return .indigo
        case .completed: return .green
        }
    }
}

struct CollaborationHandoff: Identifiable, Hashable {
    let id: UUID
    let title: String
    let fromTeam: String
    let toTeam: String
    let summary: String
    var status: CollaborationHandoffStatus
    var note: String

    static let samples: [CollaborationHandoff] = [
        CollaborationHandoff(id: UUID(), title: "Release handoff", fromTeam: "Engineering", toTeam: "QA", summary: "Feature branch is ready for final smoke and production gate review.", status: .queued, note: "Waiting on QA acknowledgement."),
        CollaborationHandoff(id: UUID(), title: "Support handoff", fromTeam: "Customer Ops", toTeam: "Evening Support", summary: "Three VIP tickets and one fraud escalation need continuity tonight.", status: .accepted, note: "Receiving team owns response SLA."),
        CollaborationHandoff(id: UUID(), title: "Design handoff", fromTeam: "Design", toTeam: "Marketing", summary: "Approved banner system and motion assets are ready for campaign prep.", status: .draft, note: "Packaging notes still need final export list.")
    ]
}

enum StandupStatus: String, Hashable {
    case blocked
    case review
    case resolved

    var label: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .blocked: return .red
        case .review: return .orange
        case .resolved: return .green
        }
    }
}

struct TeamStandup: Identifiable, Hashable {
    let id: UUID
    let owner: String
    let summary: String
    var nextStep: String
    var status: StandupStatus

    static let samples: [TeamStandup] = [
        TeamStandup(id: UUID(), owner: "Ava", summary: "Design system tokens are ready; waiting on product sign-off for the component merge.", nextStep: "Collect sign-off by 16:00.", status: .review),
        TeamStandup(id: UUID(), owner: "Noah", summary: "Customer ops cleared most of the inbox backlog, but VIP fraud review is still blocked.", nextStep: "Route fraud decision before the evening handoff.", status: .blocked),
        TeamStandup(id: UUID(), owner: "Lena", summary: "Engineering resolved the export bug and prepared the release branch.", nextStep: "Schedule rollout after QA handoff.", status: .resolved)
    ]
}
