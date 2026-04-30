import Foundation
import SwiftUI
import CRMAdminAppCore

private enum CRMInteractionProofMode {
    static let isEnabled = ProcessInfo.processInfo.environment["IOSAPPTEMPLATES_INTERACTION_PROOF_MODE"] == "1"

    static func write(summary: String, steps: [String]) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let payload: [String: Any] = [
            "app": "CRMAdminApp",
            "status": "completed",
            "summary": summary,
            "steps": steps,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]

        guard JSONSerialization.isValidJSONObject(payload),
              let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys]) else {
            return
        }

        try? data.write(to: documentsURL.appendingPathComponent("interaction-proof.json"), options: [.atomic])
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct CRMAdminAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            CRMRuntimeRootView()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMRuntimeRootView: View {
    @StateObject private var store = CRMOperationsStore()

    var body: some View {
        TabView {
            CRMPipelineView(store: store)
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Pipeline")
                }

            CRMAccountsView(store: store)
                .tabItem {
                    Image(systemName: "building.2.fill")
                    Text("Accounts")
                }

            CRMRenewalsView(store: store)
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Renewals")
                }

            CRMTasksView(store: store)
                .tabItem {
                    Image(systemName: "checklist.checked")
                    Text("Tasks")
                }

            CRMProfileView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.indigo)
        .onAppear {
            store.runInteractionProofIfNeeded()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class CRMOperationsStore: ObservableObject {
    @Published var accounts: [CRMAccountRecord]
    @Published var renewals: [CRMRenewalRecord]
    @Published var tasks: [CRMTaskRecord]
    @Published var operatorHeadline: String
    @Published var coverageWindow: String
    @Published var targetQuarter: String
    @Published var managedARR: Int
    @Published var rescueARR: Int
    @Published var expansionARR: Int
    private var interactionProofScheduled = false

    init(
        accounts: [CRMAccountRecord] = CRMAccountRecord.samples,
        renewals: [CRMRenewalRecord] = CRMRenewalRecord.samples,
        tasks: [CRMTaskRecord] = CRMTaskRecord.samples,
        operatorHeadline: String = "Northstar Health needs a rescue path before Friday's sponsor call.",
        coverageWindow: String = "Coverage window closes in 3 hours",
        targetQuarter: String = "Q2 revenue save plan",
        managedARR: Int = 4_800_000,
        rescueARR: Int = 420_000,
        expansionARR: Int = 610_000
    ) {
        self.accounts = accounts
        self.renewals = renewals
        self.tasks = tasks
        self.operatorHeadline = operatorHeadline
        self.coverageWindow = coverageWindow
        self.targetQuarter = targetQuarter
        self.managedARR = managedARR
        self.rescueARR = rescueARR
        self.expansionARR = expansionARR
    }

    var atRiskAccounts: [CRMAccountRecord] {
        accounts.filter { $0.risk != .healthy }
    }

    func logSponsorRecovery(_ accountID: UUID) {
        guard let index = accounts.firstIndex(where: { $0.id == accountID }) else { return }
        accounts[index].risk = .watch
        accounts[index].summary = "Sponsor recovery logged and executive rescue plan moved to watch."
        accounts[index].nextStep = "Review weekly usage rebound with the account team."
        operatorHeadline = "\(accounts[index].name) moved from high risk to watch."
        rescueARR = max(0, rescueARR - 120_000)
    }

    func resolveRisk(_ accountID: UUID) {
        guard let index = accounts.firstIndex(where: { $0.id == accountID }) else { return }
        accounts[index].risk = .healthy
        accounts[index].summary = "Risk cleared after adoption, sponsor recovery and finance approval."
        accounts[index].nextStep = "Prepare healthy renewal story for the next QBR."
        operatorHeadline = "\(accounts[index].name) is back to healthy."
    }

    func approveDiscount(_ renewalID: UUID) {
        guard let index = renewals.firstIndex(where: { $0.id == renewalID }) else { return }
        renewals[index].stage = .commercialReview
        renewals[index].nextAction = "Approved guardrail discount is ready for final proposal packaging."
        renewals[index].ownerNote = "Do not exceed the approved discount envelope."
        operatorHeadline = "Discount guardrail approved for \(renewals[index].accountName)."
    }

    func sendProposal(_ renewalID: UUID) {
        guard let index = renewals.firstIndex(where: { $0.id == renewalID }) else { return }
        renewals[index].stage = .proposalSent
        renewals[index].nextAction = "Proposal delivered and waiting on customer signature workflow."
        renewals[index].ownerNote = "Follow up with procurement if signature stalls for 48 hours."
        operatorHeadline = "Proposal sent to \(renewals[index].accountName)."
    }

    func signRenewal(_ renewalID: UUID) {
        guard let renewalIndex = renewals.firstIndex(where: { $0.id == renewalID }) else { return }
        let renewal = renewals[renewalIndex]
        renewals[renewalIndex].stage = .signed
        renewals[renewalIndex].nextAction = "Renewal signed and handoff sent to revenue operations."
        renewals[renewalIndex].ownerNote = "Track onboarding tasks for the new commercial term."
        operatorHeadline = "\(renewal.accountName) signed renewal."

        if let accountIndex = accounts.firstIndex(where: { $0.name == renewal.accountName }) {
            accounts[accountIndex].risk = .healthy
            accounts[accountIndex].summary = "Renewal signed and risk retired."
            accounts[accountIndex].nextStep = "Move focus to expansion adoption."
        }
    }

    func createExpansion(_ accountID: UUID) {
        guard let index = accounts.firstIndex(where: { $0.id == accountID }) else { return }
        accounts[index].summary = "Expansion motion opened with analytics add-on and multi-year structure."
        accounts[index].nextStep = "Route expansion pack to legal and procurement."
        operatorHeadline = "Expansion created for \(accounts[index].name)."
        expansionARR += 80_000
    }

    func reassignTask(_ taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].owner = "Revenue Operations"
        tasks[index].status = .inFlight
        tasks[index].note = "Task reassigned to operations for immediate follow-through."
        operatorHeadline = "\(tasks[index].title) reassigned to Revenue Operations."
    }

    func completeTask(_ taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].status = .done
        tasks[index].note = "Task completed and logged into the revenue desk timeline."
        operatorHeadline = "\(tasks[index].title) completed."
    }

    func runInteractionProofIfNeeded() {
        guard CRMInteractionProofMode.isEnabled, !interactionProofScheduled else { return }
        interactionProofScheduled = true

        DispatchQueue.main.async {
            var steps: [String] = []

            if let atRiskAccountID = self.atRiskAccounts.first?.id {
                self.logSponsorRecovery(atRiskAccountID)
                self.resolveRisk(atRiskAccountID)
                self.createExpansion(atRiskAccountID)
                steps.append("Recovered risk and opened expansion")
            }

            if let renewalID = self.renewals.first?.id {
                self.approveDiscount(renewalID)
                self.sendProposal(renewalID)
                self.signRenewal(renewalID)
                steps.append("Approved, proposed, and signed renewal")
            }

            if let taskID = self.tasks.first?.id {
                self.reassignTask(taskID)
                self.completeTask(taskID)
                steps.append("Reassigned and completed task")
            }

            CRMInteractionProofMode.write(
                summary: "CRM interaction proof completed with risk recovery, renewal, expansion, and task chain.",
                steps: steps
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMPipelineView: View {
    @ObservedObject var store: CRMOperationsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CRMPipelineHeroCard(store: store)
                    CRMMetricRow(store: store)
                    CRMAtRiskBoard(store: store)
                    CRMRenewalBoard(store: store)
                }
                .padding(16)
            }
            .navigationTitle("CRM Desk")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMPipelineHeroCard: View {
    @ObservedObject var store: CRMOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Revenue Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(store.operatorHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(store.targetQuarter)
                .foregroundStyle(.secondary)

            HStack {
                Label(store.coverageWindow, systemImage: "clock.fill")
                Spacer()
                Text("$\(store.rescueARR.formatted()) rescue ARR")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.indigo)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.indigo.opacity(0.16), .blue.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMMetricRow: View {
    @ObservedObject var store: CRMOperationsStore

    var body: some View {
        HStack(spacing: 12) {
            CRMMetricChip(title: "Managed ARR", value: "$\(store.managedARR.formatted())")
            CRMMetricChip(title: "At Risk", value: "\(store.atRiskAccounts.count)")
            CRMMetricChip(title: "Expansion", value: "$\(store.expansionARR.formatted())")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMMetricChip: View {
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
struct CRMAtRiskBoard: View {
    @ObservedObject var store: CRMOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("At-Risk Accounts")
                .font(.title3.weight(.bold))

            ForEach(store.accounts) { account in
                NavigationLink {
                    CRMAccountDetailView(store: store, accountID: account.id)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(account.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text("\(account.segment) • \(account.owner)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(account.risk.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(account.risk.color)
                        }
                        Text(account.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(account.nextStep)
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
struct CRMRenewalBoard: View {
    @ObservedObject var store: CRMOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Renewal Queue")
                .font(.title3.weight(.bold))

            ForEach(store.renewals) { renewal in
                NavigationLink {
                    CRMRenewalDetailView(store: store, renewalID: renewal.id)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(renewal.accountName)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(renewal.stage.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(renewal.stage.color)
                        }
                        Text("\(renewal.amount) • \(renewal.deadline)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(renewal.nextAction)
                            .font(.subheadline)
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
struct CRMAccountsView: View {
    @ObservedObject var store: CRMOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.accounts) { account in
                    NavigationLink {
                        CRMAccountDetailView(store: store, accountID: account.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(account.name)
                                Spacer()
                                Text(account.risk.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(account.risk.color)
                            }
                            Text(account.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Accounts")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMRenewalsView: View {
    @ObservedObject var store: CRMOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.renewals) { renewal in
                    NavigationLink {
                        CRMRenewalDetailView(store: store, renewalID: renewal.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(renewal.accountName)
                                Spacer()
                                Text(renewal.stage.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(renewal.stage.color)
                            }
                            Text(renewal.nextAction)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Renewals")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMTasksView: View {
    @ObservedObject var store: CRMOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.tasks) { task in
                    NavigationLink {
                        CRMTaskDetailView(store: store, taskID: task.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(task.title)
                                Spacer()
                                Text(task.status.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(task.status.color)
                            }
                            Text("\(task.accountName) • \(task.owner)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(task.note)
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
struct CRMProfileView: View {
    @ObservedObject var store: CRMOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Operator") {
                    Label("Elena Brooks", systemImage: "person.crop.circle.fill")
                    Label(store.targetQuarter, systemImage: "chart.line.uptrend.xyaxis")
                }
                Section("Metrics") {
                    Label("$\(store.managedARR.formatted()) managed ARR", systemImage: "dollarsign.circle.fill")
                    Label("$\(store.rescueARR.formatted()) rescue ARR", systemImage: "lifepreserver")
                    Label("$\(store.expansionARR.formatted()) expansion ARR", systemImage: "arrow.up.right.circle.fill")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMAccountDetailView: View {
    @ObservedObject var store: CRMOperationsStore
    let accountID: UUID

    var body: some View {
        if let account = store.accounts.first(where: { $0.id == accountID }) {
            List {
                Section("Account") {
                    Text(account.name)
                        .font(.title3.weight(.bold))
                    Text(account.summary)
                        .foregroundStyle(.secondary)
                    Text(account.nextStep)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Section("Commercial") {
                    Label(account.arrValue, systemImage: "dollarsign.circle.fill")
                    Label(account.renewalDate, systemImage: "calendar")
                    Label(account.risk.label, systemImage: "exclamationmark.triangle.fill")
                }
                Section("Actions") {
                    if account.risk == .high {
                        Button("Log Sponsor Recovery") { store.logSponsorRecovery(account.id) }
                    }
                    if account.risk != .healthy {
                        Button("Resolve Risk") { store.resolveRisk(account.id) }
                    }
                    Button("Create Expansion Motion") { store.createExpansion(account.id) }
                }
            }
            .navigationTitle("Account")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMRenewalDetailView: View {
    @ObservedObject var store: CRMOperationsStore
    let renewalID: UUID

    var body: some View {
        if let renewal = store.renewals.first(where: { $0.id == renewalID }) {
            List {
                Section("Renewal") {
                    Text(renewal.accountName)
                        .font(.title3.weight(.bold))
                    Text(renewal.nextAction)
                        .foregroundStyle(.secondary)
                    Text(renewal.ownerNote)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Section("Status") {
                    Label(renewal.amount, systemImage: "dollarsign.circle.fill")
                    Label(renewal.deadline, systemImage: "clock.fill")
                    Label(renewal.stage.label, systemImage: "checkmark.circle.fill")
                }
                Section("Actions") {
                    if renewal.stage == .rescue {
                        Button("Approve Discount Guardrail") { store.approveDiscount(renewal.id) }
                    }
                    if renewal.stage == .commercialReview {
                        Button("Send Proposal") { store.sendProposal(renewal.id) }
                    }
                    if renewal.stage == .proposalSent {
                        Button("Mark Signed") { store.signRenewal(renewal.id) }
                    }
                }
            }
            .navigationTitle("Renewal")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMTaskDetailView: View {
    @ObservedObject var store: CRMOperationsStore
    let taskID: UUID

    var body: some View {
        if let task = store.tasks.first(where: { $0.id == taskID }) {
            List {
                Section("Task") {
                    Text(task.title)
                        .font(.title3.weight(.bold))
                    Text(task.note)
                        .foregroundStyle(.secondary)
                }
                Section("Ownership") {
                    Label(task.accountName, systemImage: "building.2.fill")
                    Label(task.owner, systemImage: "person.fill")
                    Label(task.deadline, systemImage: "calendar")
                }
                Section("Actions") {
                    if task.status == .queued {
                        Button("Reassign to RevOps") { store.reassignTask(task.id) }
                    }
                    if task.status != .done {
                        Button("Complete Task") { store.completeTask(task.id) }
                    }
                }
            }
            .navigationTitle("Task")
        }
    }
}

enum CRMRiskLevel: String, Hashable {
    case healthy
    case watch
    case high

    var label: String {
        switch self {
        case .healthy: return "Healthy"
        case .watch: return "Watch"
        case .high: return "High Risk"
        }
    }

    var color: Color {
        switch self {
        case .healthy: return .green
        case .watch: return .orange
        case .high: return .red
        }
    }
}

struct CRMAccountRecord: Identifiable, Hashable {
    let id: UUID
    let name: String
    let segment: String
    let owner: String
    let arrValue: String
    let renewalDate: String
    var risk: CRMRiskLevel
    var summary: String
    var nextStep: String

    static let samples: [CRMAccountRecord] = [
        CRMAccountRecord(id: UUID(), name: "Northstar Health", segment: "Enterprise", owner: "Sam Rivera", arrValue: "$420K ARR", renewalDate: "May 21", risk: .high, summary: "Sponsor turnover plus declining activation in two business units.", nextStep: "Escalate to VP sponsor and lock rescue plan by Wednesday."),
        CRMAccountRecord(id: UUID(), name: "Halcyon Capital", segment: "Enterprise", owner: "Priya Shah", arrValue: "$610K ARR", renewalDate: "June 02", risk: .healthy, summary: "Expansion addendum is in legal review with adoption at a quarterly high.", nextStep: "Prepare QBR storyline and expansion SKU rollout plan."),
        CRMAccountRecord(id: UUID(), name: "Atlas Freight", segment: "Mid-Market", owner: "Nora White", arrValue: "$188K ARR", renewalDate: "June 08", risk: .watch, summary: "Finance wants ROI evidence before renewal approval.", nextStep: "Deliver procurement memo with usage-to-outcome mapping.")
    ]
}

enum CRMRenewalStage: String, Hashable {
    case rescue
    case commercialReview
    case proposalSent
    case signed

    var label: String {
        switch self {
        case .rescue: return "Exec Rescue"
        case .commercialReview: return "Commercial Review"
        case .proposalSent: return "Proposal Sent"
        case .signed: return "Signed"
        }
    }

    var color: Color {
        switch self {
        case .rescue: return .red
        case .commercialReview: return .orange
        case .proposalSent: return .blue
        case .signed: return .green
        }
    }
}

struct CRMRenewalRecord: Identifiable, Hashable {
    let id: UUID
    let accountName: String
    let amount: String
    let deadline: String
    var stage: CRMRenewalStage
    var nextAction: String
    var ownerNote: String

    static let samples: [CRMRenewalRecord] = [
        CRMRenewalRecord(id: UUID(), accountName: "Northstar Health", amount: "$420K ARR", deadline: "24 days left", stage: .rescue, nextAction: "Finalize sponsor call agenda and prepare recovery narrative.", ownerNote: "Escalate if seat recovery stays below 8% by next Monday."),
        CRMRenewalRecord(id: UUID(), accountName: "Halcyon Capital", amount: "$610K ARR", deadline: "36 days left", stage: .commercialReview, nextAction: "Bundle analytics add-on into multi-year proposal.", ownerNote: "Legal expects final clause review by end of week."),
        CRMRenewalRecord(id: UUID(), accountName: "Atlas Freight", amount: "$188K ARR", deadline: "41 days left", stage: .proposalSent, nextAction: "Align procurement packet with CFO objection log.", ownerNote: "Follow up after proposal lands in procurement.")
    ]
}

enum CRMTaskStatus: String, Hashable {
    case queued
    case inFlight
    case done

    var label: String {
        switch self {
        case .queued: return "Queued"
        case .inFlight: return "In Flight"
        case .done: return "Done"
        }
    }

    var color: Color {
        switch self {
        case .queued: return .orange
        case .inFlight: return .blue
        case .done: return .green
        }
    }
}

struct CRMTaskRecord: Identifiable, Hashable {
    let id: UUID
    let title: String
    let accountName: String
    var owner: String
    let deadline: String
    var status: CRMTaskStatus
    var note: String

    static let samples: [CRMTaskRecord] = [
        CRMTaskRecord(id: UUID(), title: "Update executive risk board", accountName: "Northstar Health", owner: "Elena Brooks", deadline: "Today 17:00", status: .queued, note: "Board is waiting for the latest sponsor risk notes."),
        CRMTaskRecord(id: UUID(), title: "Review usage export before QBR", accountName: "Halcyon Capital", owner: "Priya Shah", deadline: "Tomorrow", status: .inFlight, note: "Usage proof is being prepared for the QBR narrative."),
        CRMTaskRecord(id: UUID(), title: "Send procurement ROI memo", accountName: "Atlas Freight", owner: "Nora White", deadline: "Tomorrow 13:00", status: .queued, note: "Finance blocked the deal until the ROI memo lands.")
    ]
}
