import SwiftUI
import FinanceAppCore

@main
struct FinanceApp: App {
    var body: some Scene {
        WindowGroup {
            FinanceRuntimeRootView()
        }
    }
}

struct FinanceRuntimeRootView: View {
    @StateObject private var store = FinanceOperatingStore()

    var body: some View {
        TabView {
            FinanceOverviewWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Overview")
                }

            FinanceAccountsWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Accounts")
                }

            FinanceBudgetsWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Budgets")
                }

            FinanceActivityWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                    Text("Activity")
                }

            FinanceInsightsWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "waveform.path.ecg")
                    Text("Insights")
                }
        }
        .tint(.green)
    }
}

@MainActor
final class FinanceOperatingStore: ObservableObject {
    @Published var accounts: [FinanceAccountRecord] = FinanceAccountRecord.sampleAccounts
    @Published var budgets: [FinanceBudgetRecord] = FinanceBudgetRecord.sampleBudgets
    @Published var transactions: [FinanceTransactionRecord] = FinanceTransactionRecord.samplePosted
    @Published var pendingTransactions: [FinanceTransactionRecord] = FinanceTransactionRecord.samplePending
    @Published var recurringBills: [FinanceRecurringBillRecord] = FinanceRecurringBillRecord.sampleBills
    @Published var composer = FinanceTransactionComposer.sample
    @Published var budgetBuffer = 650.0
    @Published var advisorNote = "Protect runway first: resolve uncategorized spend, pay critical bills, then move surplus into reserve."

    var netCash: Double {
        accounts.filter { $0.kind != .credit }.reduce(0) { $0 + $1.balance }
    }

    var totalCreditUsed: Double {
        accounts.filter { $0.kind == .credit }.reduce(0) { $0 + abs(min(0, $1.balance)) }
    }

    var monthlyIncome: Double {
        transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }

    var monthlySpend: Double {
        transactions.filter { $0.type == .expense }.reduce(0) { $0 + abs($1.amount) }
    }

    var reserveAccountID: UUID? {
        accounts.first(where: { $0.kind == .savings })?.id
    }

    var operatingAccountID: UUID? {
        accounts.first(where: { $0.kind == .checking })?.id
    }

    func account(id: UUID) -> FinanceAccountRecord? {
        accounts.first(where: { $0.id == id })
    }

    func approvePending(_ transactionID: UUID) {
        guard let pendingIndex = pendingTransactions.firstIndex(where: { $0.id == transactionID }) else { return }
        var transaction = pendingTransactions.remove(at: pendingIndex)
        transaction.status = "Posted"
        transaction.date = "Today"
        apply(transaction)
        transactions.insert(transaction, at: 0)
    }

    func deferPending(_ transactionID: UUID) {
        guard let pendingIndex = pendingTransactions.firstIndex(where: { $0.id == transactionID }) else { return }
        pendingTransactions[pendingIndex].status = "Awaiting receipt"
        pendingTransactions[pendingIndex].note = "Receipt requested from owner before posting."
    }

    func payRecurringBill(_ billID: UUID) {
        guard let billIndex = recurringBills.firstIndex(where: { $0.id == billID }),
              !recurringBills[billIndex].isPaid else { return }

        recurringBills[billIndex].isPaid = true
        let bill = recurringBills[billIndex]
        let transaction = FinanceTransactionRecord(
            merchant: bill.name,
            category: bill.category,
            amount: -bill.amount,
            date: "Today",
            accountID: bill.accountID,
            status: "Posted",
            note: bill.note,
            type: .expense
        )
        apply(transaction)
        transactions.insert(transaction, at: 0)
    }

    func moveToReserve() {
        guard let sourceID = operatingAccountID,
              let destinationID = reserveAccountID else { return }
        moveCash(amount: 1200, from: sourceID, to: destinationID, merchant: "Reserve Transfer", note: "Protected extra runway after approvals and bill coverage.")
    }

    func fundOperations() {
        guard let sourceID = reserveAccountID,
              let destinationID = operatingAccountID else { return }
        moveCash(amount: 750, from: sourceID, to: destinationID, merchant: "Operations Top-up", note: "Returned cash to operating lane for near-term obligations.")
    }

    func rebalanceBudget(_ budgetID: UUID) {
        guard let budgetIndex = budgets.firstIndex(where: { $0.id == budgetID }),
              budgetBuffer >= 150 else { return }
        budgets[budgetIndex].limit += 150
        budgetBuffer -= 150
    }

    func submitManualTransaction() {
        let merchant = composer.merchant.trimmingCharacters(in: .whitespacesAndNewlines)
        let note = composer.note.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !merchant.isEmpty,
              let accountID = composer.selectedAccountID,
              let amount = Double(composer.amountText),
              amount > 0 else {
            return
        }

        let signedAmount = composer.type == .income ? amount : -amount
        let transaction = FinanceTransactionRecord(
            merchant: merchant,
            category: composer.category,
            amount: signedAmount,
            date: "Today",
            accountID: accountID,
            status: "Posted",
            note: note.isEmpty ? "Manual operator entry." : note,
            type: composer.type
        )

        apply(transaction)
        transactions.insert(transaction, at: 0)
        composer = FinanceTransactionComposer(selectedAccountID: operatingAccountID)
    }

    private func moveCash(amount: Double, from sourceID: UUID, to destinationID: UUID, merchant: String, note: String) {
        guard let sourceIndex = accounts.firstIndex(where: { $0.id == sourceID }),
              let destinationIndex = accounts.firstIndex(where: { $0.id == destinationID }),
              accounts[sourceIndex].balance >= amount else {
            return
        }

        accounts[sourceIndex].balance -= amount
        accounts[destinationIndex].balance += amount

        let outflow = FinanceTransactionRecord(
            merchant: merchant,
            category: "Transfer",
            amount: -amount,
            date: "Today",
            accountID: sourceID,
            status: "Posted",
            note: note,
            type: .expense
        )

        let inflow = FinanceTransactionRecord(
            merchant: merchant,
            category: "Transfer",
            amount: amount,
            date: "Today",
            accountID: destinationID,
            status: "Posted",
            note: note,
            type: .income
        )

        transactions.insert(inflow, at: 0)
        transactions.insert(outflow, at: 0)
    }

    private func apply(_ transaction: FinanceTransactionRecord) {
        guard let accountIndex = accounts.firstIndex(where: { $0.id == transaction.accountID }) else { return }
        accounts[accountIndex].balance += transaction.amount

        if transaction.type == .expense,
           let budgetIndex = budgets.firstIndex(where: { $0.category == transaction.category }) {
            budgets[budgetIndex].spent += abs(transaction.amount)
        }
    }
}

struct FinanceOverviewWorkspaceView: View {
    @ObservedObject var store: FinanceOperatingStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    FinanceHeroCard(store: store)
                    FinanceLiquidityActionCard(store: store)
                    FinanceRecurringBillsCard(store: store)
                    FinanceBudgetRiskCard(store: store)
                }
                .padding(16)
            }
            .navigationTitle("Finance")
        }
    }
}

struct FinanceHeroCard: View {
    @ObservedObject var store: FinanceOperatingStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Operator Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Net cash \(store.netCash.currencyString) with \(store.pendingTransactions.count) items still waiting for review.")
                .font(.system(size: 30, weight: .bold, design: .rounded))

            Text(store.advisorNote)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                FinanceMetricTile(title: "Income", value: store.monthlyIncome.currencyString)
                FinanceMetricTile(title: "Spend", value: store.monthlySpend.currencyString)
                FinanceMetricTile(title: "Credit Used", value: store.totalCreditUsed.currencyString)
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

struct FinanceLiquidityActionCard: View {
    @ObservedObject var store: FinanceOperatingStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Liquidity Actions")
                .font(.title3.weight(.bold))

            Button("Move $1,200 to Reserve") {
                store.moveToReserve()
            }
            .buttonStyle(.borderedProminent)

            Button("Fund Operations with $750") {
                store.fundOperations()
            }
            .buttonStyle(.bordered)

            Text("Budget buffer available: \(store.budgetBuffer.currencyString)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct FinanceRecurringBillsCard: View {
    @ObservedObject var store: FinanceOperatingStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recurring Bills")
                .font(.title3.weight(.bold))

            ForEach(store.recurringBills) { bill in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(bill.name)
                            .font(.headline)
                        Spacer()
                        Text(bill.amount.currencyString)
                            .font(.subheadline.weight(.bold))
                    }
                    Text("Due \(bill.dueDate) • \(store.account(id: bill.accountID)?.name ?? "Unknown Account")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack {
                        Text(bill.category)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button(bill.isPaid ? "Paid" : "Pay Now") {
                            store.payRecurringBill(bill.id)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(bill.isPaid)
                    }
                }
                .padding()
                .background(Color(.tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct FinanceBudgetRiskCard: View {
    @ObservedObject var store: FinanceOperatingStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Budget Guardrails")
                .font(.title3.weight(.bold))

            ForEach(store.budgets.sorted(by: { $0.progress > $1.progress }).prefix(3)) { budget in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(budget.category)
                            .font(.headline)
                        Spacer()
                        Text(budget.remaining.currencyString)
                            .foregroundStyle(budget.statusColor)
                    }
                    ProgressView(value: budget.progress)
                        .tint(budget.statusColor)
                    Text(budget.note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct FinanceAccountsWorkspaceView: View {
    @ObservedObject var store: FinanceOperatingStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.accounts) { account in
                    NavigationLink {
                        FinanceAccountDetailView(store: store, accountID: account.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(account.name)
                                Spacer()
                                Text(account.balance.currencyString)
                                    .font(.headline.weight(.bold))
                            }
                            Text("\(account.institution) • \(account.kind.label)")
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

struct FinanceAccountDetailView: View {
    @ObservedObject var store: FinanceOperatingStore
    let accountID: UUID

    var body: some View {
        if let account = store.account(id: accountID) {
            List {
                Section("Account Summary") {
                    LabeledContent("Institution", value: account.institution)
                    LabeledContent("Balance", value: account.balance.currencyString)
                    LabeledContent("Type", value: account.kind.label)
                    LabeledContent("Owner", value: account.owner)
                }

                Section("Recent Activity") {
                    ForEach(store.transactions.filter { $0.accountID == accountID }.prefix(4)) { transaction in
                        FinanceTransactionRow(store: store, transaction: transaction)
                    }
                }
            }
            .navigationTitle(account.name)
        }
    }
}

struct FinanceBudgetsWorkspaceView: View {
    @ObservedObject var store: FinanceOperatingStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.budgets) { budget in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(budget.category)
                            Spacer()
                            Text(budget.statusLabel)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(budget.statusColor)
                        }
                        ProgressView(value: budget.progress)
                            .tint(budget.statusColor)
                        HStack {
                            Text("Spent \(budget.spent.currencyString)")
                            Spacer()
                            Text("Remaining \(budget.remaining.currencyString)")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        Text(budget.note)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Button("Top Up by $150") {
                            store.rebalanceBudget(budget.id)
                        }
                        .buttonStyle(.bordered)
                        .disabled(store.budgetBuffer < 150)
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Budgets")
        }
    }
}

struct FinanceActivityWorkspaceView: View {
    @ObservedObject var store: FinanceOperatingStore

    var body: some View {
        NavigationStack {
            List {
                Section("Pending Approval") {
                    ForEach(store.pendingTransactions) { transaction in
                        VStack(alignment: .leading, spacing: 8) {
                            FinanceTransactionRow(store: store, transaction: transaction)
                            HStack {
                                Button("Approve") {
                                    store.approvePending(transaction.id)
                                }
                                .buttonStyle(.borderedProminent)
                                Button("Defer") {
                                    store.deferPending(transaction.id)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Manual Entry") {
                    TextField("Merchant", text: $store.composer.merchant)
                    TextField("Amount", text: $store.composer.amountText)
                        .keyboardType(.decimalPad)
                    Picker("Type", selection: $store.composer.type) {
                        Text("Expense").tag(FinanceTransactionType.expense)
                        Text("Income").tag(FinanceTransactionType.income)
                    }
                    Picker("Account", selection: $store.composer.selectedAccountID) {
                        ForEach(store.accounts) { account in
                            Text(account.name).tag(Optional(account.id))
                        }
                    }
                    Picker("Category", selection: $store.composer.category) {
                        ForEach(FinanceTransactionComposer.categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    TextField("Note", text: $store.composer.note)
                    Button("Post Transaction") {
                        store.submitManualTransaction()
                    }
                    .buttonStyle(.borderedProminent)
                }

                Section("Latest Activity") {
                    ForEach(store.transactions.prefix(8)) { transaction in
                        FinanceTransactionRow(store: store, transaction: transaction)
                    }
                }
            }
            .navigationTitle("Activity")
        }
    }
}

struct FinanceTransactionRow: View {
    @ObservedObject var store: FinanceOperatingStore
    let transaction: FinanceTransactionRecord

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: transaction.iconName)
                .foregroundStyle(transaction.type == .income ? .green : .orange)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.merchant)
                    .font(.headline)
                Text("\(store.account(id: transaction.accountID)?.name ?? "Unknown") • \(transaction.date)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.amount.currencyString)
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

struct FinanceInsightsWorkspaceView: View {
    @ObservedObject var store: FinanceOperatingStore

    var body: some View {
        NavigationStack {
            List {
                Section("Signals") {
                    Label("Reserve covers \(store.netCash.currencyString) of non-credit liquidity.", systemImage: "lock.shield.fill")
                    Label("\(store.pendingTransactions.count) pending entries can still change month-end accuracy.", systemImage: "exclamationmark.bubble.fill")
                    Label("Budget buffer left: \(store.budgetBuffer.currencyString)", systemImage: "chart.bar.fill")
                }

                Section("Advisor Notes") {
                    Text(store.advisorNote)
                    Text("Top up any category above 85% only after receipts and recurring bills are settled.")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Insights")
        }
    }
}

enum FinanceAccountKind {
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
}

enum FinanceTransactionType {
    case income
    case expense
}

struct FinanceAccountRecord: Identifiable {
    let id = UUID()
    let name: String
    let institution: String
    var balance: Double
    let owner: String
    let kind: FinanceAccountKind

    static let sampleAccounts: [FinanceAccountRecord] = [
        FinanceAccountRecord(name: "Operating Cash", institution: "Mercury", balance: 18_420, owner: "Operations", kind: .checking),
        FinanceAccountRecord(name: "Growth Reserve", institution: "Wise", balance: 9_200, owner: "Finance", kind: .savings),
        FinanceAccountRecord(name: "Team Card", institution: "Ramp", balance: -2_160, owner: "Ops + Marketing", kind: .credit)
    ]
}

struct FinanceBudgetRecord: Identifiable {
    let id = UUID()
    let category: String
    var limit: Double
    var spent: Double
    let note: String

    var remaining: Double { max(0, limit - spent) }
    var progress: Double { limit == 0 ? 0 : min(1, spent / limit) }
    var statusLabel: String { progress >= 0.85 ? "At risk" : "Healthy" }
    var statusColor: Color { progress >= 0.85 ? .orange : .green }

    static let sampleBudgets: [FinanceBudgetRecord] = [
        FinanceBudgetRecord(category: "Travel", limit: 1_800, spent: 1_420, note: "Conference travel is above the normal pacing curve."),
        FinanceBudgetRecord(category: "Tools", limit: 2_400, spent: 1_180, note: "Tooling is healthy after vendor consolidation."),
        FinanceBudgetRecord(category: "Marketing", limit: 3_600, spent: 2_940, note: "Paid acquisition is hot but still inside target band."),
        FinanceBudgetRecord(category: "Payroll", limit: 6_800, spent: 4_900, note: "Contractor and operator coverage stay inside monthly plan.")
    ]
}

struct FinanceTransactionRecord: Identifiable {
    let id = UUID()
    let merchant: String
    let category: String
    let amount: Double
    var date: String
    let accountID: UUID
    var status: String
    var note: String
    let type: FinanceTransactionType

    var iconName: String {
        switch category {
        case "Revenue": return "arrow.down.circle.fill"
        case "Travel": return "airplane"
        case "Payroll": return "person.2.fill"
        case "Tools": return "wrench.and.screwdriver.fill"
        case "Marketing": return "megaphone.fill"
        case "Transfer": return "arrow.left.arrow.right.circle.fill"
        default: return "banknote.fill"
        }
    }

    static let samplePosted: [FinanceTransactionRecord] = {
        let accounts = FinanceAccountRecord.sampleAccounts
        return [
            FinanceTransactionRecord(merchant: "Stripe Payout", category: "Revenue", amount: 4_820, date: "Today", accountID: accounts[0].id, status: "Posted", note: "Weekly payout from subscriptions.", type: .income),
            FinanceTransactionRecord(merchant: "Delta Airlines", category: "Travel", amount: -620, date: "Yesterday", accountID: accounts[2].id, status: "Posted", note: "Flight for Berlin customer summit.", type: .expense),
            FinanceTransactionRecord(merchant: "Contractor Payroll", category: "Payroll", amount: -2_400, date: "Apr 24", accountID: accounts[0].id, status: "Posted", note: "Design and content sprint payment.", type: .expense)
        ]
    }()

    static let samplePending: [FinanceTransactionRecord] = {
        let accounts = FinanceAccountRecord.sampleAccounts
        return [
            FinanceTransactionRecord(merchant: "Notion", category: "Tools", amount: -184, date: "Pending", accountID: accounts[2].id, status: "Needs tagging", note: "Workspace renewal for product and ops.", type: .expense),
            FinanceTransactionRecord(merchant: "Reimbursement", category: "Marketing", amount: 240, date: "Pending", accountID: accounts[0].id, status: "Needs receipt", note: "Office supply reimbursement from admin.", type: .income)
        ]
    }()
}

struct FinanceRecurringBillRecord: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let dueDate: String
    let category: String
    let accountID: UUID
    var isPaid: Bool
    let note: String

    static let sampleBills: [FinanceRecurringBillRecord] = {
        let accounts = FinanceAccountRecord.sampleAccounts
        return [
            FinanceRecurringBillRecord(name: "Payroll Run", amount: 6_800, dueDate: "Mon", category: "Payroll", accountID: accounts[0].id, isPaid: false, note: "Critical operator and contractor payroll run."),
            FinanceRecurringBillRecord(name: "AWS", amount: 480, dueDate: "Tue", category: "Tools", accountID: accounts[2].id, isPaid: false, note: "Infrastructure bill for core product services."),
            FinanceRecurringBillRecord(name: "Creator Sponsorship", amount: 350, dueDate: "Thu", category: "Marketing", accountID: accounts[2].id, isPaid: false, note: "Campaign payment for creator acquisition.")
        ]
    }()
}

struct FinanceTransactionComposer {
    static let categories = ["Tools", "Travel", "Marketing", "Payroll", "Revenue", "Transfer"]

    var merchant: String
    var amountText: String
    var selectedAccountID: UUID?
    var category: String
    var note: String
    var type: FinanceTransactionType

    init(
        merchant: String = "",
        amountText: String = "",
        selectedAccountID: UUID? = FinanceAccountRecord.sampleAccounts.first?.id,
        category: String = "Tools",
        note: String = "",
        type: FinanceTransactionType = .expense
    ) {
        self.merchant = merchant
        self.amountText = amountText
        self.selectedAccountID = selectedAccountID
        self.category = category
        self.note = note
        self.type = type
    }

    static let sample = FinanceTransactionComposer()
}

private extension Double {
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "$0"
    }
}
