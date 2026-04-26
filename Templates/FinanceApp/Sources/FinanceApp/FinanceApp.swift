import SwiftUI
import FinanceAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct FinanceAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            FinanceWorkspaceRootView(
                snapshot: .sample,
                actions: FinanceQuickAction.defaultActions,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceWorkspaceRootView: View {
    let snapshot: FinanceDashboardSnapshot
    let actions: [FinanceQuickAction]
    let state: FinanceWorkspaceState

    init(
        snapshot: FinanceDashboardSnapshot,
        actions: [FinanceQuickAction],
        state: FinanceWorkspaceState
    ) {
        self.snapshot = snapshot
        self.actions = actions
        self.state = state
    }

    public var body: some View {
        TabView {
            FinanceDashboardView(snapshot: snapshot, actions: actions, state: state)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Overview")
                }

            FinanceAccountsView(state: state)
                .tabItem {
                    Image(systemName: "creditcard")
                    Text("Accounts")
                }

            FinanceBudgetsView(state: state)
                .tabItem {
                    Image(systemName: "chart.pie")
                    Text("Budgets")
                }

            FinanceActivityView(state: state)
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Activity")
                }

            FinanceInsightsView(state: state)
                .tabItem {
                    Image(systemName: "waveform.path.ecg")
                    Text("Insights")
                }
        }
        .tint(.green)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceDashboardView: View {
    let snapshot: FinanceDashboardSnapshot
    let actions: [FinanceQuickAction]
    let state: FinanceWorkspaceState

    init(
        snapshot: FinanceDashboardSnapshot,
        actions: [FinanceQuickAction],
        state: FinanceWorkspaceState
    ) {
        self.snapshot = snapshot
        self.actions = actions
        self.state = state
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    FinanceHeroCard(snapshot: snapshot, state: state)
                    FinanceQuickActionGrid(actions: actions)
                    FinanceCashFlowCard(state: state)
                    FinanceBudgetHighlightsView(budgets: state.budgets)
                    FinanceRecurringPaymentsCard(recurringPayments: state.recurringPayments)
                }
                .padding(16)
            }
            .navigationTitle("Finance")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceHeroCard: View {
    let snapshot: FinanceDashboardSnapshot
    let state: FinanceWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Executive Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(snapshot.netCash)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                    Text(snapshot.reviewMessage)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    FinanceDeltaPill(title: "Income", value: state.monthlyIncome, color: .green)
                    FinanceDeltaPill(title: "Spend", value: state.monthlySpend, color: .orange)
                }
            }

            HStack(spacing: 12) {
                FinanceMetricTile(title: "Accounts", value: "\(snapshot.accounts)")
                FinanceMetricTile(title: "Budget Usage", value: snapshot.budgetUsage)
                FinanceMetricTile(title: "Bills Due", value: "\(state.dueThisWeekCount)")
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.green.opacity(0.16), .mint.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceDeltaPill: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemBackground))
        .clipShape(Capsule())
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceMetricTile: View {
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
struct FinanceQuickActionGrid: View {
    let actions: [FinanceQuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions) { action in
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: action.systemImage)
                            .font(.title3)
                            .foregroundStyle(.green)
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
struct FinanceCashFlowCard: View {
    let state: FinanceWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cash Flow")
                .font(.title3.weight(.bold))

            HStack(spacing: 12) {
                FinanceCashFlowColumn(title: "Income", value: state.monthlyIncome, subtitle: "Payroll + side revenue", accent: .green)
                FinanceCashFlowColumn(title: "Spend", value: state.monthlySpend, subtitle: "Cards + subscriptions", accent: .orange)
                FinanceCashFlowColumn(title: "Saved", value: state.monthlySaved, subtitle: "Transferred to reserve", accent: .blue)
            }

            Divider()

            ForEach(state.cashFlowBreakdown) { item in
                HStack {
                    Label(item.category, systemImage: item.systemImage)
                    Spacer()
                    Text(item.amount)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(item.accent)
                }
                .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceCashFlowColumn: View {
    let title: String
    let value: String
    let subtitle: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(accent)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceBudgetHighlightsView: View {
    let budgets: [FinanceBudget]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Budget Guardrails")
                .font(.title3.weight(.bold))

            ForEach(budgets.prefix(3)) { budget in
                NavigationLink {
                    FinanceBudgetDetailView(budget: budget)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(budget.category)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(budget.statusLabel)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(budget.statusColor)
                        }
                        ProgressView(value: budget.progress)
                            .tint(budget.statusColor)
                        HStack {
                            Text("Spent \(budget.spent)")
                            Spacer()
                            Text("Target \(budget.limit)")
                        }
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
struct FinanceRecurringPaymentsCard: View {
    let recurringPayments: [FinanceRecurringPayment]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recurring Payments")
                .font(.title3.weight(.bold))

            ForEach(recurringPayments) { payment in
                HStack(spacing: 12) {
                    Image(systemName: payment.systemImage)
                        .foregroundStyle(payment.accent)
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(payment.name)
                            .font(.headline)
                        Text("Due \(payment.dueDate) • \(payment.account)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(payment.amount)
                        .font(.subheadline.weight(.bold))
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceAccountsView: View {
    let state: FinanceWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Accounts") {
                    ForEach(state.accounts) { account in
                        NavigationLink {
                            FinanceAccountDetailView(account: account, transactions: transactions(for: account))
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(account.name)
                                    Spacer()
                                    Text(account.balance)
                                        .font(.headline.weight(.bold))
                                }
                                HStack {
                                    Label(account.kind.label, systemImage: account.kind.systemImage)
                                    Spacer()
                                    Text(account.availableLabel)
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Coverage") {
                    LabeledContent("Emergency Reserve", value: state.emergencyReserveCoverage)
                    LabeledContent("Credit Utilization", value: state.creditUtilization)
                    LabeledContent("Upcoming Transfers", value: state.upcomingTransfers)
                }
            }
            .navigationTitle("Accounts")
        }
    }

    private func transactions(for account: FinanceAccount) -> [FinanceTransaction] {
        state.transactions.filter { $0.accountName == account.name }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceBudgetsView: View {
    let state: FinanceWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Current Month") {
                    ForEach(state.budgets) { budget in
                        NavigationLink {
                            FinanceBudgetDetailView(budget: budget)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(budget.category)
                                    Spacer()
                                    Text(budget.remaining)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(budget.statusColor)
                                }
                                ProgressView(value: budget.progress)
                                    .tint(budget.statusColor)
                                Text(budget.note)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Budget Rules") {
                    ForEach(state.budgetRules, id: \.self) { rule in
                        Label(rule, systemImage: "shield.lefthalf.filled")
                    }
                }
            }
            .navigationTitle("Budgets")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceActivityView: View {
    let state: FinanceWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Pending Review") {
                    ForEach(state.pendingTransactions) { transaction in
                        NavigationLink {
                            FinanceTransactionDetailView(transaction: transaction)
                        } label: {
                            FinanceTransactionRow(transaction: transaction)
                        }
                    }
                }

                Section("Latest Activity") {
                    ForEach(state.transactions) { transaction in
                        NavigationLink {
                            FinanceTransactionDetailView(transaction: transaction)
                        } label: {
                            FinanceTransactionRow(transaction: transaction)
                        }
                    }
                }
            }
            .navigationTitle("Activity")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceTransactionRow: View {
    let transaction: FinanceTransaction

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: transaction.categoryIcon)
                .foregroundStyle(transaction.accent)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.merchant)
                    .font(.headline)
                Text("\(transaction.accountName) • \(transaction.date)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.amount)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(transaction.type == .income ? .green : .primary)
                Text(transaction.status)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceInsightsView: View {
    let state: FinanceWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Signals") {
                    ForEach(state.insights) { insight in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Label(insight.title, systemImage: insight.systemImage)
                                    .font(.headline)
                                Spacer()
                                Text(insight.level)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(insight.accent)
                            }
                            Text(insight.detail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }

                Section("Advisor Notes") {
                    ForEach(state.advisorNotes, id: \.self) { note in
                        Label(note, systemImage: "text.bubble")
                    }
                }

                Section("Profile") {
                    LabeledContent("Primary Goal", value: state.primaryGoal)
                    LabeledContent("Risk Posture", value: state.riskProfile)
                    LabeledContent("Last Review", value: state.lastReviewDate)
                }
            }
            .navigationTitle("Insights")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceAccountDetailView: View {
    let account: FinanceAccount
    let transactions: [FinanceTransaction]

    var body: some View {
        List {
            Section("Account Summary") {
                LabeledContent("Institution", value: account.institution)
                LabeledContent("Balance", value: account.balance)
                LabeledContent("Available", value: account.availableLabel)
                LabeledContent("Owner", value: account.owner)
            }

            Section("Latest Transactions") {
                ForEach(transactions.prefix(4)) { transaction in
                    FinanceTransactionRow(transaction: transaction)
                }
            }
        }
        .navigationTitle(account.name)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceBudgetDetailView: View {
    let budget: FinanceBudget

    var body: some View {
        List {
            Section("Budget") {
                LabeledContent("Category", value: budget.category)
                LabeledContent("Limit", value: budget.limit)
                LabeledContent("Spent", value: budget.spent)
                LabeledContent("Remaining", value: budget.remaining)
                ProgressView(value: budget.progress)
                    .tint(budget.statusColor)
            }

            Section("Guidance") {
                Text(budget.note)
                Text(budget.recoveryPlan)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle(budget.category)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FinanceTransactionDetailView: View {
    let transaction: FinanceTransaction

    var body: some View {
        List {
            Section("Transaction") {
                LabeledContent("Merchant", value: transaction.merchant)
                LabeledContent("Amount", value: transaction.amount)
                LabeledContent("Date", value: transaction.date)
                LabeledContent("Account", value: transaction.accountName)
                LabeledContent("Status", value: transaction.status)
            }

            Section("Details") {
                Text(transaction.note)
                Label(transaction.category, systemImage: transaction.categoryIcon)
                    .foregroundStyle(transaction.accent)
            }
        }
        .navigationTitle("Transaction")
    }
}

public struct FinanceQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [FinanceQuickAction] = [
        FinanceQuickAction(title: "Review Budget", detail: "Flag categories that are above the weekly pacing threshold.", systemImage: "chart.pie.fill"),
        FinanceQuickAction(title: "Add Transaction", detail: "Capture reimbursements, cash expenses, and one-off adjustments.", systemImage: "plus.rectangle.on.rectangle"),
        FinanceQuickAction(title: "Move Cash", detail: "Transfer reserve funds before the upcoming card payment hits.", systemImage: "arrow.left.arrow.right"),
        FinanceQuickAction(title: "Export Report", detail: "Prepare the monthly close summary for operations and tax review.", systemImage: "square.and.arrow.up")
    ]
}

struct FinanceWorkspaceState: Hashable, Sendable {
    let monthlyIncome: String
    let monthlySpend: String
    let monthlySaved: String
    let dueThisWeekCount: Int
    let emergencyReserveCoverage: String
    let creditUtilization: String
    let upcomingTransfers: String
    let primaryGoal: String
    let riskProfile: String
    let lastReviewDate: String
    let accounts: [FinanceAccount]
    let budgets: [FinanceBudget]
    let transactions: [FinanceTransaction]
    let pendingTransactions: [FinanceTransaction]
    let recurringPayments: [FinanceRecurringPayment]
    let insights: [FinanceInsight]
    let advisorNotes: [String]
    let budgetRules: [String]
    let cashFlowBreakdown: [FinanceCashFlowBreakdown]

    static let sample = FinanceWorkspaceState(
        monthlyIncome: "$14,200",
        monthlySpend: "$8,640",
        monthlySaved: "$2,750",
        dueThisWeekCount: 3,
        emergencyReserveCoverage: "5.2 months",
        creditUtilization: "18%",
        upcomingTransfers: "$1,400 scheduled",
        primaryGoal: "Build the Q3 operating reserve to $30,000.",
        riskProfile: "Balanced growth",
        lastReviewDate: "Apr 24",
        accounts: [
            FinanceAccount(name: "Operating Cash", institution: "Mercury", balance: "$18,420", availableLabel: "$18,420 available", owner: "Operations", kind: .checking),
            FinanceAccount(name: "Growth Reserve", institution: "Wise", balance: "$9,200", availableLabel: "$9,200 available", owner: "Finance", kind: .savings),
            FinanceAccount(name: "Team Card", institution: "Ramp", balance: "$-2,160", availableLabel: "$9,840 limit left", owner: "Ops + Marketing", kind: .credit)
        ],
        budgets: [
            FinanceBudget(category: "Travel", limit: "$1,800", spent: "$1,420", remaining: "$380", note: "Conference travel is above the normal pacing curve.", recoveryPlan: "Hold non-essential trips until the close review.", progress: 0.79),
            FinanceBudget(category: "Tools", limit: "$2,400", spent: "$1,180", remaining: "$1,220", note: "Tooling is healthy after vendor consolidation.", recoveryPlan: "Renegotiate the analytics renewal next week.", progress: 0.49),
            FinanceBudget(category: "Marketing", limit: "$3,600", spent: "$2,940", remaining: "$660", note: "Paid acquisition is hot but still inside the target band.", recoveryPlan: "Shift 15% to creator partnerships if CAC rises again.", progress: 0.81)
        ],
        transactions: [
            FinanceTransaction(merchant: "Stripe Payout", category: "Revenue", categoryIcon: "arrow.down.circle.fill", amount: "+$4,820", date: "Today", accountName: "Operating Cash", status: "Posted", note: "Weekly payout from subscriptions.", type: .income, accent: .green),
            FinanceTransaction(merchant: "Notion", category: "Software", categoryIcon: "doc.text.fill", amount: "-$184", date: "Today", accountName: "Team Card", status: "Needs tagging", note: "Workspace renewal for product and ops.", type: .expense, accent: .blue),
            FinanceTransaction(merchant: "Delta Airlines", category: "Travel", categoryIcon: "airplane", amount: "-$620", date: "Yesterday", accountName: "Team Card", status: "Manager review", note: "Flight for the Berlin customer summit.", type: .expense, accent: .orange),
            FinanceTransaction(merchant: "Contractor Payroll", category: "Payroll", categoryIcon: "person.2.fill", amount: "-$2,400", date: "Apr 24", accountName: "Operating Cash", status: "Posted", note: "Design and content sprint payment.", type: .expense, accent: .purple)
        ],
        pendingTransactions: [
            FinanceTransaction(merchant: "Slack", category: "Software", categoryIcon: "message.fill", amount: "-$92", date: "Pending", accountName: "Team Card", status: "Awaiting owner", note: "Needs workspace allocation.", type: .expense, accent: .blue),
            FinanceTransaction(merchant: "Reimbursement", category: "Ops", categoryIcon: "arrow.uturn.left.circle", amount: "+$240", date: "Pending", accountName: "Operating Cash", status: "Needs receipt", note: "Office supply reimbursement from admin.", type: .income, accent: .green)
        ],
        recurringPayments: [
            FinanceRecurringPayment(name: "Payroll Run", amount: "$6,800", dueDate: "Mon", account: "Operating Cash", systemImage: "building.2.fill", accent: .green),
            FinanceRecurringPayment(name: "AWS", amount: "$480", dueDate: "Tue", account: "Team Card", systemImage: "server.rack", accent: .orange),
            FinanceRecurringPayment(name: "Product Hunt Sponsorship", amount: "$350", dueDate: "Thu", account: "Team Card", systemImage: "megaphone.fill", accent: .pink)
        ],
        insights: [
            FinanceInsight(title: "Travel needs intervention", detail: "Travel spend is 14% above the mid-month pace and will miss the target without a policy hold.", systemImage: "airplane.departure", level: "Watch", accent: .orange),
            FinanceInsight(title: "Cash runway is healthy", detail: "Current reserve plus operating cash covers 5.2 months of base burn.", systemImage: "checkmark.shield", level: "Healthy", accent: .green),
            FinanceInsight(title: "Marketing efficiency improved", detail: "Paid acquisition CAC fell 9% after moving spend into remarketing cohorts.", systemImage: "chart.line.uptrend.xyaxis", level: "Improve", accent: .blue)
        ],
        advisorNotes: [
            "Delay non-essential travel approvals until the Q2 close is locked.",
            "Move the next Stripe payout directly into reserve after payroll settles.",
            "Review card tagging automation for software renewals."
        ],
        budgetRules: [
            "Any category above 80% usage by mid-month requires an owner note.",
            "All uncategorized card transactions must be resolved within 48 hours.",
            "Reserve transfers happen before discretionary spend is approved."
        ],
        cashFlowBreakdown: [
            FinanceCashFlowBreakdown(category: "Payroll", amount: "$6,800", systemImage: "person.2.fill", accent: .purple),
            FinanceCashFlowBreakdown(category: "Subscriptions", amount: "$2,140", systemImage: "repeat.circle.fill", accent: .orange),
            FinanceCashFlowBreakdown(category: "Operations", amount: "$1,120", systemImage: "shippingbox.fill", accent: .blue)
        ]
    )
}

struct FinanceAccount: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let institution: String
    let balance: String
    let availableLabel: String
    let owner: String
    let kind: FinanceAccountKind
}

enum FinanceAccountKind: String, Hashable, Sendable {
    case checking
    case savings
    case credit

    var label: String {
        switch self {
        case .checking: return "Checking"
        case .savings: return "Savings"
        case .credit: return "Credit"
        }
    }

    var systemImage: String {
        switch self {
        case .checking: return "banknote"
        case .savings: return "lock.shield"
        case .credit: return "creditcard.fill"
        }
    }
}

struct FinanceBudget: Identifiable, Hashable, Sendable {
    let id = UUID()
    let category: String
    let limit: String
    let spent: String
    let remaining: String
    let note: String
    let recoveryPlan: String
    let progress: Double

    var statusLabel: String {
        progress >= 0.8 ? "At risk" : "On track"
    }

    var statusColor: Color {
        progress >= 0.8 ? .orange : .green
    }
}

struct FinanceTransaction: Identifiable, Hashable, Sendable {
    let id = UUID()
    let merchant: String
    let category: String
    let categoryIcon: String
    let amount: String
    let date: String
    let accountName: String
    let status: String
    let note: String
    let type: FinanceTransactionType
    let accent: Color
}

enum FinanceTransactionType: Hashable, Sendable {
    case income
    case expense
}

struct FinanceRecurringPayment: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let amount: String
    let dueDate: String
    let account: String
    let systemImage: String
    let accent: Color
}

struct FinanceInsight: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let detail: String
    let systemImage: String
    let level: String
    let accent: Color
}

struct FinanceCashFlowBreakdown: Identifiable, Hashable, Sendable {
    let id = UUID()
    let category: String
    let amount: String
    let systemImage: String
    let accent: Color
}
