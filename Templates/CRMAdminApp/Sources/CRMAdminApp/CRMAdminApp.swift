import SwiftUI
import CRMAdminAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct CRMAdminAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            CRMAdminWorkspaceRootView(
                snapshot: .sample,
                workspaces: CRMAdminWorkspaceCard.sampleCards,
                actions: CRMAdminQuickAction.defaultActions,
                health: .sample,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMAdminWorkspaceRootView: View {
    let snapshot: CRMAdminDashboardSnapshot
    let workspaces: [CRMAdminWorkspaceCard]
    let actions: [CRMAdminQuickAction]
    let health: CRMAdminOperationalHealth
    let state: CRMAdminWorkspaceState

    var body: some View {
        TabView {
            CRMAdminPipelineView(
                snapshot: snapshot,
                workspaces: workspaces,
                actions: actions,
                health: health,
                state: state
            )
            .tabItem {
                Image(systemName: "chart.bar.xaxis")
                Text("Pipeline")
            }

            CRMAdminAccountsView(state: state)
                .tabItem {
                    Image(systemName: "building.2.fill")
                    Text("Accounts")
                }

            CRMAdminRenewalsView(state: state)
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Renewals")
                }

            CRMAdminTasksView(state: state)
                .tabItem {
                    Image(systemName: "checklist.checked")
                    Text("Tasks")
                }

            CRMAdminProfileView(snapshot: snapshot, health: health, state: state)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.indigo)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMAdminPipelineView: View {
    let snapshot: CRMAdminDashboardSnapshot
    let workspaces: [CRMAdminWorkspaceCard]
    let actions: [CRMAdminQuickAction]
    let health: CRMAdminOperationalHealth
    let state: CRMAdminWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CRMAdminHeroCard(snapshot: snapshot, health: health, state: state)
                    CRMAdminQuickActionGrid(actions: actions)
                    CRMAdminAtRiskAccountsCard(accounts: state.atRiskAccounts)
                    CRMAdminWorkspaceLaneView(workspaces: workspaces)
                    CRMAdminOperationsCard(health: health, state: state)
                }
                .padding(16)
            }
            .navigationTitle("CRM Desk")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMAdminHeroCard: View {
    let snapshot: CRMAdminDashboardSnapshot
    let health: CRMAdminOperationalHealth
    let state: CRMAdminWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Revenue Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(state.operatorHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(snapshot.pipelineHealth)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                CRMAdminMetricChip(title: "Open Accounts", value: "\(snapshot.openAccounts)")
                CRMAdminMetricChip(title: "At Risk", value: "\(snapshot.atRiskDeals)")
                CRMAdminMetricChip(title: "Renewals", value: "\(snapshot.renewalQueue)")
            }

            HStack {
                Label(state.coverageWindow, systemImage: "clock.fill")
                Spacer()
                Text(state.targetQuarter)
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
struct CRMAdminMetricChip: View {
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
struct CRMAdminQuickActionGrid: View {
    let actions: [CRMAdminQuickAction]

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
struct CRMAdminAtRiskAccountsCard: View {
    let accounts: [CRMAdminAccount]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("At-Risk Accounts")
                .font(.title3.weight(.bold))

            ForEach(accounts) { account in
                NavigationLink {
                    CRMAdminAccountDetailView(account: account)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(account.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text("\(account.segment) - \(account.owner)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(account.riskLevel)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(account.riskColor)
                        }
                        Text(account.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                        HStack {
                            Label(account.arrValue, systemImage: "dollarsign.circle.fill")
                            Label(account.renewalDate, systemImage: "calendar")
                        }
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
struct CRMAdminWorkspaceLaneView: View {
    let workspaces: [CRMAdminWorkspaceCard]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Coverage Lanes")
                .font(.title3.weight(.bold))

            ForEach(workspaces) { workspace in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(workspace.title)
                            .font(.headline)
                        Text(workspace.ctaLabel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("\(workspace.ownerCount) owners")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.indigo)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMAdminOperationsCard: View {
    let health: CRMAdminOperationalHealth
    let state: CRMAdminWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Operations")
                .font(.title3.weight(.bold))

            HStack(spacing: 12) {
                CRMAdminOperationTile(title: "SLA Breaches", value: "\(health.slaBreaches)")
                CRMAdminOperationTile(title: "First Reply", value: "\(health.medianFirstReplyMinutes)m")
                CRMAdminOperationTile(title: "Automation", value: health.automationReady ? "Ready" : "Paused")
            }

            ForEach(state.operationsNotes, id: \.self) { note in
                Label(note, systemImage: "arrow.right.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMAdminOperationTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.headline.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMAdminAccountsView: View {
    let state: CRMAdminWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.accounts) { account in
                    NavigationLink {
                        CRMAdminAccountDetailView(account: account)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(account.name)
                                Spacer()
                                Text(account.arrValue)
                                    .font(.subheadline.weight(.bold))
                            }
                            Text("\(account.segment) - \(account.owner)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(account.summary)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Accounts")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMAdminRenewalsView: View {
    let state: CRMAdminWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.renewals) { renewal in
                    NavigationLink {
                        CRMAdminRenewalDetailView(renewal: renewal)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(renewal.accountName)
                                Spacer()
                                Text(renewal.stage)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(renewal.stageColor)
                            }
                            Text("\(renewal.amount) - \(renewal.deadline)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(renewal.nextAction)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Renewals")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMAdminTasksView: View {
    let state: CRMAdminWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.tasks) { task in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(task.title)
                        Text("\(task.accountName) - \(task.owner)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(task.priority) priority - due \(task.deadline)")
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
struct CRMAdminProfileView: View {
    let snapshot: CRMAdminDashboardSnapshot
    let health: CRMAdminOperationalHealth
    let state: CRMAdminWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Operator") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(state.operatorName)
                            .font(.headline)
                        Text(state.roleSummary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Label(state.coverageWindow, systemImage: "person.3.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Book Health") {
                    Label("Open accounts: \(snapshot.openAccounts)", systemImage: "building.2.fill")
                    Label("At-risk deals: \(snapshot.atRiskDeals)", systemImage: "exclamationmark.triangle.fill")
                    Label("Automation ready: \(health.automationReady ? "Yes" : "No")", systemImage: "gearshape.2.fill")
                }

                Section("Coverage Metrics") {
                    ForEach(state.profileMetrics, id: \.label) { metric in
                        HStack {
                            Text(metric.label)
                            Spacer()
                            Text(metric.value)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.indigo)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMAdminAccountDetailView: View {
    let account: CRMAdminAccount

    var body: some View {
        List {
            Section("Account") {
                Text(account.name)
                    .font(.headline)
                Text(account.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Signals") {
                Label(account.segment, systemImage: "building.columns.fill")
                Label(account.owner, systemImage: "person.fill")
                Label(account.renewalDate, systemImage: "calendar")
                Label(account.arrValue, systemImage: "dollarsign.circle.fill")
            }

            Section("Next Step") {
                Text(account.nextStep)
                    .font(.body)
            }
        }
        .navigationTitle(account.name)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CRMAdminRenewalDetailView: View {
    let renewal: CRMAdminRenewal

    var body: some View {
        List {
            Section("Renewal") {
                Text(renewal.accountName)
                    .font(.headline)
                Text(renewal.nextAction)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Commercial") {
                Label(renewal.amount, systemImage: "creditcard.fill")
                Label(renewal.deadline, systemImage: "calendar.badge.clock")
                Label(renewal.stage, systemImage: "flag.fill")
            }

            Section("Owner Notes") {
                Text(renewal.ownerNote)
                    .font(.body)
            }
        }
        .navigationTitle("Renewal")
    }
}

public struct CRMAdminQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [CRMAdminQuickAction] = [
        CRMAdminQuickAction(
            title: "Review At-Risk Accounts",
            systemImage: "person.crop.circle.badge.exclamationmark",
            detail: "Start the morning with accounts that show usage drops, sponsor change or budget pressure."
        ),
        CRMAdminQuickAction(
            title: "Open Renewal Queue",
            systemImage: "calendar.badge.clock",
            detail: "Sort upcoming renewals by ARR, deadline confidence and executive escalation need."
        ),
        CRMAdminQuickAction(
            title: "Inspect SLA Board",
            systemImage: "checklist",
            detail: "Check breached reply windows, overdue follow-ups and owner rebalancing opportunities."
        ),
        CRMAdminQuickAction(
            title: "Prep QBR Brief",
            systemImage: "doc.text.magnifyingglass",
            detail: "Assemble expansion notes, adoption wins and risk signals for this week's exec reviews."
        )
    ]
}

struct CRMAdminWorkspaceState: Hashable, Sendable {
    let operatorHeadline: String
    let operatorName: String
    let roleSummary: String
    let targetQuarter: String
    let coverageWindow: String
    let operationsNotes: [String]
    let atRiskAccounts: [CRMAdminAccount]
    let accounts: [CRMAdminAccount]
    let renewals: [CRMAdminRenewal]
    let tasks: [CRMAdminTask]
    let profileMetrics: [CRMAdminMetric]

    static let sample = CRMAdminWorkspaceState(
        operatorHeadline: "Enterprise retention is on track, but three expansion paths need executive help this week.",
        operatorName: "Elena Brooks",
        roleSummary: "Senior Revenue Operations Manager covering enterprise renewals and strategic expansions",
        targetQuarter: "Q3 target: 118% NRR",
        coverageWindow: "North America enterprise book",
        operationsNotes: [
            "Two platinum accounts need pricing approvals before Friday.",
            "Automation rules caught 14 overdue health check tasks overnight.",
            "Customer success and sales leadership share one risk review on Thursday."
        ],
        atRiskAccounts: [
            CRMAdminAccount(
                name: "Northstar Health",
                segment: "Enterprise",
                owner: "Sam Rivera",
                arrValue: "$420K ARR",
                renewalDate: "Renews in 24 days",
                riskLevel: "High Risk",
                summary: "Champion left the company and weekly active seats are down 18% month over month.",
                nextStep: "Book sponsor rescue call and confirm interim rollout owner.",
                riskColorName: "red"
            ),
            CRMAdminAccount(
                name: "Atlas Freight",
                segment: "Mid-Market",
                owner: "Nora White",
                arrValue: "$188K ARR",
                renewalDate: "Renews in 41 days",
                riskLevel: "Watch",
                summary: "Legal redlines are open and procurement paused signature pending usage proof.",
                nextStep: "Send adoption packet and finance-approved discount guardrails.",
                riskColorName: "orange"
            )
        ],
        accounts: [
            CRMAdminAccount(
                name: "Northstar Health",
                segment: "Enterprise",
                owner: "Sam Rivera",
                arrValue: "$420K ARR",
                renewalDate: "May 21",
                riskLevel: "High Risk",
                summary: "Sponsor turnover plus declining activation in two business units.",
                nextStep: "Escalate to VP sponsor and lock rescue plan by Wednesday.",
                riskColorName: "red"
            ),
            CRMAdminAccount(
                name: "Halcyon Capital",
                segment: "Enterprise",
                owner: "Priya Shah",
                arrValue: "$610K ARR",
                renewalDate: "June 02",
                riskLevel: "Healthy",
                summary: "Expansion addendum is in legal review with adoption at a quarterly high.",
                nextStep: "Prepare QBR storyline and expansion SKU rollout plan.",
                riskColorName: "green"
            ),
            CRMAdminAccount(
                name: "Atlas Freight",
                segment: "Mid-Market",
                owner: "Nora White",
                arrValue: "$188K ARR",
                renewalDate: "June 08",
                riskLevel: "Watch",
                summary: "Finance wants ROI evidence before renewal approval.",
                nextStep: "Deliver procurement memo with usage-to-outcome mapping.",
                riskColorName: "orange"
            )
        ],
        renewals: [
            CRMAdminRenewal(
                accountName: "Northstar Health",
                amount: "$420K ARR",
                deadline: "24 days left",
                stage: "Exec Rescue",
                nextAction: "Finalize sponsor call agenda and prepare recovery narrative.",
                ownerNote: "Escalate if seat recovery stays below 8% by next Monday.",
                stageColorName: "red"
            ),
            CRMAdminRenewal(
                accountName: "Halcyon Capital",
                amount: "$610K ARR",
                deadline: "36 days left",
                stage: "Expansion Ready",
                nextAction: "Bundle analytics add-on into multi-year proposal.",
                ownerNote: "Legal expects final clause review by end of week.",
                stageColorName: "green"
            ),
            CRMAdminRenewal(
                accountName: "Atlas Freight",
                amount: "$188K ARR",
                deadline: "41 days left",
                stage: "Commercial Review",
                nextAction: "Align procurement packet with CFO objection log.",
                ownerNote: "Do not approve extra discount until ROI memo lands.",
                stageColorName: "orange"
            )
        ],
        tasks: [
            CRMAdminTask(
                title: "Update executive risk board",
                accountName: "Northstar Health",
                owner: "Elena Brooks",
                priority: "Critical",
                deadline: "Today 17:00"
            ),
            CRMAdminTask(
                title: "Review usage export before QBR",
                accountName: "Halcyon Capital",
                owner: "Priya Shah",
                priority: "High",
                deadline: "Tomorrow"
            ),
            CRMAdminTask(
                title: "Send procurement ROI memo",
                accountName: "Atlas Freight",
                owner: "Nora White",
                priority: "High",
                deadline: "Tomorrow 13:00"
            )
        ],
        profileMetrics: [
            CRMAdminMetric(label: "Managed ARR", value: "$4.8M"),
            CRMAdminMetric(label: "Renewals this quarter", value: "19"),
            CRMAdminMetric(label: "Expansion candidates", value: "7")
        ]
    )
}

struct CRMAdminAccount: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let segment: String
    let owner: String
    let arrValue: String
    let renewalDate: String
    let riskLevel: String
    let summary: String
    let nextStep: String
    let riskColorName: String

    init(
        id: UUID = UUID(),
        name: String,
        segment: String,
        owner: String,
        arrValue: String,
        renewalDate: String,
        riskLevel: String,
        summary: String,
        nextStep: String,
        riskColorName: String
    ) {
        self.id = id
        self.name = name
        self.segment = segment
        self.owner = owner
        self.arrValue = arrValue
        self.renewalDate = renewalDate
        self.riskLevel = riskLevel
        self.summary = summary
        self.nextStep = nextStep
        self.riskColorName = riskColorName
    }

    var riskColor: Color {
        switch riskColorName {
        case "red":
            return .red
        case "orange":
            return .orange
        default:
            return .green
        }
    }
}

struct CRMAdminRenewal: Identifiable, Hashable, Sendable {
    let id: UUID
    let accountName: String
    let amount: String
    let deadline: String
    let stage: String
    let nextAction: String
    let ownerNote: String
    let stageColorName: String

    init(
        id: UUID = UUID(),
        accountName: String,
        amount: String,
        deadline: String,
        stage: String,
        nextAction: String,
        ownerNote: String,
        stageColorName: String
    ) {
        self.id = id
        self.accountName = accountName
        self.amount = amount
        self.deadline = deadline
        self.stage = stage
        self.nextAction = nextAction
        self.ownerNote = ownerNote
        self.stageColorName = stageColorName
    }

    var stageColor: Color {
        switch stageColorName {
        case "red":
            return .red
        case "orange":
            return .orange
        default:
            return .green
        }
    }
}

struct CRMAdminTask: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let accountName: String
    let owner: String
    let priority: String
    let deadline: String

    init(
        id: UUID = UUID(),
        title: String,
        accountName: String,
        owner: String,
        priority: String,
        deadline: String
    ) {
        self.id = id
        self.title = title
        self.accountName = accountName
        self.owner = owner
        self.priority = priority
        self.deadline = deadline
    }
}

struct CRMAdminMetric: Hashable, Sendable {
    let label: String
    let value: String
}
