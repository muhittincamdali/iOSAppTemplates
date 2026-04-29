import SwiftUI
import ProductivityAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct ProductivityAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            ProductivityRuntimeRootView()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityRuntimeRootView: View {
    @StateObject private var store = ProductivityOperationsStore()

    var body: some View {
        TabView {
            ProductivityDashboardView(store: store)
                .tabItem {
                    Image(systemName: "rectangle.3.group.bubble.left")
                    Text("Dashboard")
                }

            ProductivityInboxView(store: store)
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Inbox")
                }

            ProductivityProjectsView(store: store)
                .tabItem {
                    Image(systemName: "folder")
                    Text("Projects")
                }

            ProductivityFocusView(store: store)
                .tabItem {
                    Image(systemName: "timer")
                    Text("Focus")
                }

            ProductivityReviewView(store: store)
                .tabItem {
                    Image(systemName: "chart.bar.doc.horizontal")
                    Text("Review")
                }
        }
        .tint(.indigo)
    }
}

@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class ProductivityOperationsStore: ObservableObject {
    @Published var captureDraft = ""
    @Published var inboxTasks: [ProductivityTaskRecord]
    @Published var projects: [ProductivityProjectRecord]
    @Published var focusBlocks: [ProductivityFocusBlock]
    @Published var reviewRisks: [ProductivityRiskRecord]
    @Published var operatorHeadline: String
    @Published var focusRule: String
    @Published var completedCount: Int

    init(
        inboxTasks: [ProductivityTaskRecord] = ProductivityTaskRecord.samples,
        projects: [ProductivityProjectRecord] = ProductivityProjectRecord.samples,
        focusBlocks: [ProductivityFocusBlock] = ProductivityFocusBlock.samples,
        reviewRisks: [ProductivityRiskRecord] = ProductivityRiskRecord.samples,
        operatorHeadline: String = "Launch review is on track, but two high-cost tasks still need routing.",
        focusRule: String = "One priority block at a time. No parallel task drift.",
        completedCount: Int = 14
    ) {
        self.inboxTasks = inboxTasks
        self.projects = projects
        self.focusBlocks = focusBlocks
        self.reviewRisks = reviewRisks
        self.operatorHeadline = operatorHeadline
        self.focusRule = focusRule
        self.completedCount = completedCount
    }

    var activeTasks: [ProductivityTaskRecord] {
        inboxTasks.filter { $0.status != .done }
    }

    func captureTask() {
        let trimmed = captureDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        inboxTasks.insert(
            ProductivityTaskRecord(
                id: UUID(),
                title: trimmed,
                detail: "Captured from the operator inbox and waiting for routing.",
                project: "Inbox",
                priority: .high,
                dueLabel: "Today",
                status: .captured
            ),
            at: 0
        )
        operatorHeadline = "New inbound task captured before it slipped."
        captureDraft = ""
    }

    func prioritizeTask(_ taskID: UUID) {
        guard let index = inboxTasks.firstIndex(where: { $0.id == taskID }) else { return }
        inboxTasks[index].status = .prioritized
        inboxTasks[index].detail = "Promoted into the priority lane for immediate action."
        operatorHeadline = "\(inboxTasks[index].title) moved into the priority lane."
    }

    func moveTaskToProject(_ taskID: UUID, projectID: UUID) {
        guard
            let taskIndex = inboxTasks.firstIndex(where: { $0.id == taskID }),
            let projectIndex = projects.firstIndex(where: { $0.id == projectID })
        else { return }

        inboxTasks[taskIndex].project = projects[projectIndex].name
        inboxTasks[taskIndex].status = .planned
        projects[projectIndex].progress = min(1.0, projects[projectIndex].progress + 0.08)
        operatorHeadline = "\(inboxTasks[taskIndex].title) routed into \(projects[projectIndex].name)."
    }

    func completeTask(_ taskID: UUID) {
        guard let index = inboxTasks.firstIndex(where: { $0.id == taskID }) else { return }
        let projectName = inboxTasks[index].project
        inboxTasks[index].status = .done
        inboxTasks[index].detail = "Completed and logged into the weekly review."
        completedCount += 1
        if let projectIndex = projects.firstIndex(where: { $0.name == projectName }) {
            projects[projectIndex].progress = min(1.0, projects[projectIndex].progress + 0.12)
            projects[projectIndex].status = projects[projectIndex].progress > 0.75 ? "Healthy" : projects[projectIndex].status
        }
        operatorHeadline = "\(inboxTasks[index].title) closed cleanly."
    }

    func startFocus(_ blockID: UUID) {
        guard let index = focusBlocks.firstIndex(where: { $0.id == blockID }) else { return }
        focusBlocks[index].status = .active
        operatorHeadline = "Focus session started for \(focusBlocks[index].title.lowercased())."
    }

    func completeFocus(_ blockID: UUID) {
        guard let index = focusBlocks.firstIndex(where: { $0.id == blockID }) else { return }
        focusBlocks[index].status = .completed
        operatorHeadline = "\(focusBlocks[index].title) focus block completed."
    }

    func resolveRisk(_ riskID: UUID) {
        guard let index = reviewRisks.firstIndex(where: { $0.id == riskID }) else { return }
        reviewRisks[index].status = .resolved
        reviewRisks[index].mitigation = "Risk closed and documented in the review log."
        operatorHeadline = "Review risk closed: \(reviewRisks[index].title)."
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityDashboardView: View {
    @ObservedObject var store: ProductivityOperationsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ProductivityHeroCard(store: store)
                    HStack(spacing: 12) {
                        ProductivityMetricChip(title: "Open Tasks", value: "\(store.activeTasks.count)")
                        ProductivityMetricChip(title: "Projects", value: "\(store.projects.count)")
                        ProductivityMetricChip(title: "Completed", value: "\(store.completedCount)")
                    }
                    ProductivityCaptureCard(store: store)
                    ProductivityPriorityLane(store: store)
                    ProductivityTimelineLane(store: store)
                }
                .padding(16)
            }
            .navigationTitle("Workspace")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityHeroCard: View {
    @ObservedObject var store: ProductivityOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Operator Pulse")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text(store.operatorHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(store.focusRule)
                .font(.subheadline)
                .foregroundStyle(.secondary)
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
struct ProductivityCaptureCard: View {
    @ObservedObject var store: ProductivityOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Capture")
                .font(.title3.weight(.bold))
            TextField("Capture a task", text: $store.captureDraft)
                .textFieldStyle(.roundedBorder)
            Button("Capture Into Inbox") {
                store.captureTask()
            }
            .buttonStyle(.borderedProminent)
            .disabled(store.captureDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityPriorityLane: View {
    @ObservedObject var store: ProductivityOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Priority Lane")
                .font(.title3.weight(.bold))
            ForEach(store.inboxTasks.prefix(3)) { task in
                NavigationLink {
                    ProductivityTaskDetailView(store: store, taskID: task.id)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(task.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(task.status.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(task.status.color)
                        }
                        Text(task.detail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("\(task.project) • \(task.dueLabel)")
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
struct ProductivityTimelineLane: View {
    @ObservedObject var store: ProductivityOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Focus Timeline")
                .font(.title3.weight(.bold))
            ForEach(store.focusBlocks) { block in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(block.time)
                            .font(.headline)
                        Spacer()
                        Text(block.status.label)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(block.status.color)
                    }
                    Text(block.title)
                    Text(block.detail)
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
    @ObservedObject var store: ProductivityOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.inboxTasks) { task in
                    NavigationLink {
                        ProductivityTaskDetailView(store: store, taskID: task.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(task.title)
                                Spacer()
                                Text(task.status.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(task.status.color)
                            }
                            Text(task.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
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
    @ObservedObject var store: ProductivityOperationsStore

    var body: some View {
        NavigationStack {
            List(store.projects) { project in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(project.name)
                        Spacer()
                        Text(project.status)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(project.statusColor)
                    }
                    ProgressView(value: project.progress)
                    Text(project.owner)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Projects")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityFocusView: View {
    @ObservedObject var store: ProductivityOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.focusBlocks) { block in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(block.title)
                            Spacer()
                            Text(block.status.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(block.status.color)
                        }
                        Text(block.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if block.status == .queued {
                            Button("Start Focus Block") { store.startFocus(block.id) }
                        } else if block.status == .active {
                            Button("Complete Focus Block") { store.completeFocus(block.id) }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Focus")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityReviewView: View {
    @ObservedObject var store: ProductivityOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.reviewRisks) { risk in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(risk.title)
                            Spacer()
                            Text(risk.status.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(risk.status.color)
                        }
                        Text(risk.mitigation)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if risk.status == .open {
                            Button("Resolve Risk") { store.resolveRisk(risk.id) }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Review")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct ProductivityTaskDetailView: View {
    @ObservedObject var store: ProductivityOperationsStore
    let taskID: UUID

    var body: some View {
        if let task = store.inboxTasks.first(where: { $0.id == taskID }) {
            List {
                Section("Task") {
                    Text(task.title)
                        .font(.title3.weight(.bold))
                    Text(task.detail)
                        .foregroundStyle(.secondary)
                }
                Section("Routing") {
                    Label(task.project, systemImage: "folder.fill")
                    Label(task.dueLabel, systemImage: "calendar")
                    Label(task.status.label, systemImage: "checkmark.circle.fill")
                }
                Section("Actions") {
                    if task.status == .captured {
                        Button("Prioritize Task") { store.prioritizeTask(task.id) }
                    }
                    if task.status == .prioritized, let project = store.projects.first {
                        Button("Move To \(project.name)") { store.moveTaskToProject(task.id, projectID: project.id) }
                    }
                    if task.status == .planned || task.status == .prioritized {
                        Button("Complete Task") { store.completeTask(task.id) }
                    }
                }
            }
            .navigationTitle("Task")
        }
    }
}

enum ProductivityTaskStatus: String, Hashable {
    case captured
    case prioritized
    case planned
    case done

    var label: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .captured: return .orange
        case .prioritized: return .blue
        case .planned: return .indigo
        case .done: return .green
        }
    }
}

struct ProductivityTaskRecord: Identifiable, Hashable {
    let id: UUID
    let title: String
    var detail: String
    var project: String
    let priority: ProductivityPriority
    let dueLabel: String
    var status: ProductivityTaskStatus

    static let samples: [ProductivityTaskRecord] = [
        ProductivityTaskRecord(id: UUID(), title: "Finalize launch review narrative", detail: "Go/no-go review still needs the final risk table.", project: "Release Ops", priority: .critical, dueLabel: "Today 16:00", status: .prioritized),
        ProductivityTaskRecord(id: UUID(), title: "Review screenshot host collisions", detail: "Parallel runtime capture still needs one clean regression pass.", project: "Proof System", priority: .high, dueLabel: "Today 18:30", status: .planned),
        ProductivityTaskRecord(id: UUID(), title: "Prepare next flagship backlog", detail: "Map the next rebuild wave into the portfolio board.", project: "Template Portfolio", priority: .medium, dueLabel: "Tomorrow", status: .captured)
    ]
}

struct ProductivityProjectRecord: Identifiable, Hashable {
    let id: UUID
    let name: String
    let owner: String
    var progress: Double
    var status: String

    static let samples: [ProductivityProjectRecord] = [
        ProductivityProjectRecord(id: UUID(), name: "Release Ops", owner: "Muhittin", progress: 0.72, status: "At Risk"),
        ProductivityProjectRecord(id: UUID(), name: "Proof System", owner: "Muhittin", progress: 0.84, status: "Healthy"),
        ProductivityProjectRecord(id: UUID(), name: "Template Portfolio", owner: "Muhittin", progress: 0.58, status: "Needs Focus")
    ]

    var statusColor: Color {
        switch status {
        case "Healthy": return .green
        case "At Risk": return .orange
        default: return .indigo
        }
    }
}

enum ProductivityFocusStatus: String, Hashable {
    case queued
    case active
    case completed

    var label: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .queued: return .orange
        case .active: return .blue
        case .completed: return .green
        }
    }
}

struct ProductivityFocusBlock: Identifiable, Hashable {
    let id: UUID
    let time: String
    let title: String
    let detail: String
    var status: ProductivityFocusStatus

    static let samples: [ProductivityFocusBlock] = [
        ProductivityFocusBlock(id: UUID(), time: "09:00", title: "Deep Work", detail: "Finish flagship app rebuild batch.", status: .completed),
        ProductivityFocusBlock(id: UUID(), time: "11:30", title: "Review Window", detail: "Check build, launch, and runtime assets.", status: .active),
        ProductivityFocusBlock(id: UUID(), time: "16:00", title: "Launch Review", detail: "Finalize evidence and publish status.", status: .queued)
    ]
}

enum ProductivityRiskStatus: String, Hashable {
    case open
    case resolved

    var label: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .open: return .red
        case .resolved: return .green
        }
    }
}

struct ProductivityRiskRecord: Identifiable, Hashable {
    let id: UUID
    let title: String
    var mitigation: String
    var status: ProductivityRiskStatus

    static let samples: [ProductivityRiskRecord] = [
        ProductivityRiskRecord(id: UUID(), title: "Asset pipeline contention", mitigation: "One temporary runtime host path still needs protection under parallel execution.", status: .open),
        ProductivityRiskRecord(id: UUID(), title: "Flagship backlog drift", mitigation: "Three deepened apps still need follow-up interaction chains.", status: .open)
    ]
}

public enum ProductivityPriority: String, Hashable, Sendable {
    case critical
    case high
    case medium
}
