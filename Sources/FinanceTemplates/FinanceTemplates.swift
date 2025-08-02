import Foundation
import SwiftUI
import Charts

// MARK: - Finance Templates
public struct FinanceTemplates {
    
    // MARK: - Version
    public static let version = "1.0.0"
    
    // MARK: - Initialization
    public static func initialize() {
        print("💰 Finance Templates v\(version) initialized")
    }
}

// MARK: - Personal Finance App Template
public struct PersonalFinanceAppTemplate {
    
    // MARK: - Models
    public struct Transaction: Identifiable, Codable {
        public let id: String
        public let amount: Double
        public let type: TransactionType
        public let category: TransactionCategory
        public let description: String?
        public let date: Date
        public let accountId: String
        public let isRecurring: Bool
        public let recurringInterval: RecurringInterval?
        public let tags: [String]
        public let attachments: [TransactionAttachment]
        public let notes: String?
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            amount: Double,
            type: TransactionType,
            category: TransactionCategory,
            description: String? = nil,
            date: Date = Date(),
            accountId: String,
            isRecurring: Bool = false,
            recurringInterval: RecurringInterval? = nil,
            tags: [String] = [],
            attachments: [TransactionAttachment] = [],
            notes: String? = nil,
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.amount = amount
            self.type = type
            self.category = category
            self.description = description
            self.date = date
            self.accountId = accountId
            self.isRecurring = isRecurring
            self.recurringInterval = recurringInterval
            self.tags = tags
            self.attachments = attachments
            self.notes = notes
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
    
    public struct Account: Identifiable, Codable {
        public let id: String
        public let name: String
        public let type: AccountType
        public let balance: Double
        public let currency: String
        public let institution: String?
        public let accountNumber: String?
        public let isActive: Bool
        public let color: String
        public let icon: String
        public let transactions: [Transaction]
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            type: AccountType,
            balance: Double = 0.0,
            currency: String = "USD",
            institution: String? = nil,
            accountNumber: String? = nil,
            isActive: Bool = true,
            color: String = "blue",
            icon: String = "creditcard",
            transactions: [Transaction] = [],
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.name = name
            self.type = type
            self.balance = balance
            self.currency = currency
            self.institution = institution
            self.accountNumber = accountNumber
            self.isActive = isActive
            self.color = color
            self.icon = icon
            self.transactions = transactions
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
    
    public struct Budget: Identifiable, Codable {
        public let id: String
        public let name: String
        public let amount: Double
        public let spent: Double
        public let period: BudgetPeriod
        public let categories: [BudgetCategory]
        public let startDate: Date
        public let endDate: Date
        public let isActive: Bool
        public let notifications: Bool
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            amount: Double,
            spent: Double = 0.0,
            period: BudgetPeriod,
            categories: [BudgetCategory] = [],
            startDate: Date,
            endDate: Date,
            isActive: Bool = true,
            notifications: Bool = true,
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.name = name
            self.amount = amount
            self.spent = spent
            self.period = period
            self.categories = categories
            self.startDate = startDate
            self.endDate = endDate
            self.isActive = isActive
            self.notifications = notifications
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
        
        public var remaining: Double {
            return amount - spent
        }
        
        public var percentageSpent: Double {
            return amount > 0 ? (spent / amount) * 100 : 0
        }
        
        public var isOverBudget: Bool {
            return spent > amount
        }
    }
    
    public struct BudgetCategory: Identifiable, Codable {
        public let id: String
        public let name: String
        public let allocated: Double
        public let spent: Double
        public let category: TransactionCategory
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            allocated: Double,
            spent: Double = 0.0,
            category: TransactionCategory
        ) {
            self.id = id
            self.name = name
            self.allocated = allocated
            self.spent = spent
            self.category = category
        }
        
        public var remaining: Double {
            return allocated - spent
        }
        
        public var percentageSpent: Double {
            return allocated > 0 ? (spent / allocated) * 100 : 0
        }
    }
    
    public struct Goal: Identifiable, Codable {
        public let id: String
        public let name: String
        public let description: String?
        public let targetAmount: Double
        public let currentAmount: Double
        public let currency: String
        public let deadline: Date?
        public let type: GoalType
        public let isActive: Bool
        public let color: String
        public let icon: String
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            description: String? = nil,
            targetAmount: Double,
            currentAmount: Double = 0.0,
            currency: String = "USD",
            deadline: Date? = nil,
            type: GoalType,
            isActive: Bool = true,
            color: String = "blue",
            icon: String = "target",
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.targetAmount = targetAmount
            self.currentAmount = currentAmount
            self.currency = currency
            self.deadline = deadline
            self.type = type
            self.isActive = isActive
            self.color = color
            self.icon = icon
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
        
        public var progress: Double {
            return targetAmount > 0 ? (currentAmount / targetAmount) * 100 : 0
        }
        
        public var remaining: Double {
            return targetAmount - currentAmount
        }
        
        public var isCompleted: Bool {
            return currentAmount >= targetAmount
        }
    }
    
    public struct Investment: Identifiable, Codable {
        public let id: String
        public let name: String
        public let symbol: String?
        public let type: InvestmentType
        public let amount: Double
        public let shares: Double?
        public let purchasePrice: Double?
        public let currentPrice: Double?
        public let purchaseDate: Date?
        public let accountId: String
        public let isActive: Bool
        public let notes: String?
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            symbol: String? = nil,
            type: InvestmentType,
            amount: Double,
            shares: Double? = nil,
            purchasePrice: Double? = nil,
            currentPrice: Double? = nil,
            purchaseDate: Date? = nil,
            accountId: String,
            isActive: Bool = true,
            notes: String? = nil,
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.name = name
            self.symbol = symbol
            self.type = type
            self.amount = amount
            self.shares = shares
            self.purchasePrice = purchasePrice
            self.currentPrice = currentPrice
            self.purchaseDate = purchaseDate
            self.accountId = accountId
            self.isActive = isActive
            self.notes = notes
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
        
        public var currentValue: Double {
            guard let currentPrice = currentPrice, let shares = shares else { return amount }
            return currentPrice * shares
        }
        
        public var gainLoss: Double {
            return currentValue - amount
        }
        
        public var gainLossPercentage: Double {
            return amount > 0 ? (gainLoss / amount) * 100 : 0
        }
    }
    
    public struct TransactionAttachment: Identifiable, Codable {
        public let id: String
        public let name: String
        public let url: String
        public let type: AttachmentType
        public let size: Int64
        public let uploadedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            url: String,
            type: AttachmentType,
            size: Int64,
            uploadedAt: Date = Date()
        ) {
            self.id = id
            self.name = name
            self.url = url
            self.type = type
            self.size = size
            self.uploadedAt = uploadedAt
        }
    }
    
    // MARK: - Enums
    public enum TransactionType: String, CaseIterable, Codable {
        case income = "income"
        case expense = "expense"
        case transfer = "transfer"
        
        public var displayName: String {
            switch self {
            case .income: return "Income"
            case .expense: return "Expense"
            case .transfer: return "Transfer"
            }
        }
        
        public var color: String {
            switch self {
            case .income: return "green"
            case .expense: return "red"
            case .transfer: return "blue"
            }
        }
    }
    
    public enum TransactionCategory: String, CaseIterable, Codable {
        case food = "food"
        case transportation = "transportation"
        case housing = "housing"
        case utilities = "utilities"
        case entertainment = "entertainment"
        case healthcare = "healthcare"
        case education = "education"
        case shopping = "shopping"
        case travel = "travel"
        case insurance = "insurance"
        case taxes = "taxes"
        case salary = "salary"
        case investment = "investment"
        case gift = "gift"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .food: return "Food & Dining"
            case .transportation: return "Transportation"
            case .housing: return "Housing"
            case .utilities: return "Utilities"
            case .entertainment: return "Entertainment"
            case .healthcare: return "Healthcare"
            case .education: return "Education"
            case .shopping: return "Shopping"
            case .travel: return "Travel"
            case .insurance: return "Insurance"
            case .taxes: return "Taxes"
            case .salary: return "Salary"
            case .investment: return "Investment"
            case .gift: return "Gift"
            case .other: return "Other"
            }
        }
        
        public var icon: String {
            switch self {
            case .food: return "fork.knife"
            case .transportation: return "car.fill"
            case .housing: return "house.fill"
            case .utilities: return "bolt.fill"
            case .entertainment: return "gamecontroller.fill"
            case .healthcare: return "heart.fill"
            case .education: return "book.fill"
            case .shopping: return "cart.fill"
            case .travel: return "airplane"
            case .insurance: return "shield.fill"
            case .taxes: return "doc.text.fill"
            case .salary: return "dollarsign.circle.fill"
            case .investment: return "chart.line.uptrend.xyaxis"
            case .gift: return "gift.fill"
            case .other: return "ellipsis.circle"
            }
        }
    }
    
    public enum AccountType: String, CaseIterable, Codable {
        case checking = "checking"
        case savings = "savings"
        case credit = "credit"
        case investment = "investment"
        case loan = "loan"
        case cash = "cash"
        
        public var displayName: String {
            switch self {
            case .checking: return "Checking"
            case .savings: return "Savings"
            case .credit: return "Credit Card"
            case .investment: return "Investment"
            case .loan: return "Loan"
            case .cash: return "Cash"
            }
        }
    }
    
    public enum BudgetPeriod: String, CaseIterable, Codable {
        case weekly = "weekly"
        case monthly = "monthly"
        case yearly = "yearly"
        
        public var displayName: String {
            switch self {
            case .weekly: return "Weekly"
            case .monthly: return "Monthly"
            case .yearly: return "Yearly"
            }
        }
    }
    
    public enum GoalType: String, CaseIterable, Codable {
        case savings = "savings"
        case debt = "debt"
        case emergency = "emergency"
        case vacation = "vacation"
        case home = "home"
        case car = "car"
        case education = "education"
        case retirement = "retirement"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .savings: return "Savings"
            case .debt: return "Debt Payoff"
            case .emergency: return "Emergency Fund"
            case .vacation: return "Vacation"
            case .home: return "Home"
            case .car: return "Car"
            case .education: return "Education"
            case .retirement: return "Retirement"
            case .other: return "Other"
            }
        }
    }
    
    public enum InvestmentType: String, CaseIterable, Codable {
        case stock = "stock"
        case bond = "bond"
        case mutualFund = "mutual_fund"
        case etf = "etf"
        case crypto = "crypto"
        case realEstate = "real_estate"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .stock: return "Stock"
            case .bond: return "Bond"
            case .mutualFund: return "Mutual Fund"
            case .etf: return "ETF"
            case .crypto: return "Cryptocurrency"
            case .realEstate: return "Real Estate"
            case .other: return "Other"
            }
        }
    }
    
    public enum RecurringInterval: String, CaseIterable, Codable {
        case daily = "daily"
        case weekly = "weekly"
        case monthly = "monthly"
        case yearly = "yearly"
        
        public var displayName: String {
            switch self {
            case .daily: return "Daily"
            case .weekly: return "Weekly"
            case .monthly: return "Monthly"
            case .yearly: return "Yearly"
            }
        }
    }
    
    public enum AttachmentType: String, CaseIterable, Codable {
        case receipt = "receipt"
        case invoice = "invoice"
        case statement = "statement"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .receipt: return "Receipt"
            case .invoice: return "Invoice"
            case .statement: return "Statement"
            case .other: return "Other"
            }
        }
    }
    
    // MARK: - Managers
    public class FinanceManager: ObservableObject {
        
        @Published public var accounts: [Account] = []
        @Published public var transactions: [Transaction] = []
        @Published public var budgets: [Budget] = []
        @Published public var goals: [Goal] = []
        @Published public var investments: [Investment] = []
        @Published public var isLoading = false
        
        private let dataManager = DataManager()
        private let analyticsManager = AnalyticsManager()
        
        public init() {}
        
        // MARK: - Account Methods
        
        public func addAccount(_ account: Account) async throws {
            isLoading = true
            defer { isLoading = false }
            
            accounts.append(account)
            try await dataManager.saveAccounts(accounts)
        }
        
        public func updateAccount(_ account: Account) async throws {
            guard let index = accounts.firstIndex(where: { $0.id == account.id }) else {
                throw FinanceError.accountNotFound
            }
            
            isLoading = true
            defer { isLoading = false }
            
            accounts[index] = account
            try await dataManager.saveAccounts(accounts)
        }
        
        public func deleteAccount(_ accountId: String) async throws {
            guard let index = accounts.firstIndex(where: { $0.id == accountId }) else {
                throw FinanceError.accountNotFound
            }
            
            isLoading = true
            defer { isLoading = false }
            
            accounts.remove(at: index)
            try await dataManager.saveAccounts(accounts)
        }
        
        public func getTotalBalance() -> Double {
            return accounts
                .filter { $0.isActive }
                .reduce(0) { $0 + $1.balance }
        }
        
        // MARK: - Transaction Methods
        
        public func addTransaction(_ transaction: Transaction) async throws {
            isLoading = true
            defer { isLoading = false }
            
            transactions.append(transaction)
            
            // Update account balance
            if let accountIndex = accounts.firstIndex(where: { $0.id == transaction.accountId }) {
                var account = accounts[accountIndex]
                switch transaction.type {
                case .income:
                    account.balance += transaction.amount
                case .expense:
                    account.balance -= transaction.amount
                case .transfer:
                    // Handle transfer logic
                    break
                }
                accounts[accountIndex] = account
                try await dataManager.saveAccounts(accounts)
            }
            
            try await dataManager.saveTransactions(transactions)
            try await analyticsManager.updateAnalytics()
        }
        
        public func updateTransaction(_ transaction: Transaction) async throws {
            guard let index = transactions.firstIndex(where: { $0.id == transaction.id }) else {
                throw FinanceError.transactionNotFound
            }
            
            isLoading = true
            defer { isLoading = false }
            
            transactions[index] = transaction
            try await dataManager.saveTransactions(transactions)
            try await analyticsManager.updateAnalytics()
        }
        
        public func deleteTransaction(_ transactionId: String) async throws {
            guard let index = transactions.firstIndex(where: { $0.id == transactionId }) else {
                throw FinanceError.transactionNotFound
            }
            
            isLoading = true
            defer { isLoading = false }
            
            let transaction = transactions[index]
            transactions.remove(at: index)
            
            // Update account balance
            if let accountIndex = accounts.firstIndex(where: { $0.id == transaction.accountId }) {
                var account = accounts[accountIndex]
                switch transaction.type {
                case .income:
                    account.balance -= transaction.amount
                case .expense:
                    account.balance += transaction.amount
                case .transfer:
                    // Handle transfer logic
                    break
                }
                accounts[accountIndex] = account
                try await dataManager.saveAccounts(accounts)
            }
            
            try await dataManager.saveTransactions(transactions)
            try await analyticsManager.updateAnalytics()
        }
        
        public func getTransactionsByAccount(_ accountId: String) -> [Transaction] {
            return transactions.filter { $0.accountId == accountId }
        }
        
        public func getTransactionsByCategory(_ category: TransactionCategory) -> [Transaction] {
            return transactions.filter { $0.category == category }
        }
        
        public func getTransactionsByDateRange(from startDate: Date, to endDate: Date) -> [Transaction] {
            return transactions.filter { transaction in
                transaction.date >= startDate && transaction.date <= endDate
            }
        }
        
        // MARK: - Budget Methods
        
        public func addBudget(_ budget: Budget) async throws {
            budgets.append(budget)
            try await dataManager.saveBudgets(budgets)
        }
        
        public func updateBudget(_ budget: Budget) async throws {
            guard let index = budgets.firstIndex(where: { $0.id == budget.id }) else {
                throw FinanceError.budgetNotFound
            }
            
            budgets[index] = budget
            try await dataManager.saveBudgets(budgets)
        }
        
        public func deleteBudget(_ budgetId: String) async throws {
            guard let index = budgets.firstIndex(where: { $0.id == budgetId }) else {
                throw FinanceError.budgetNotFound
            }
            
            budgets.remove(at: index)
            try await dataManager.saveBudgets(budgets)
        }
        
        public func getActiveBudgets() -> [Budget] {
            return budgets.filter { $0.isActive }
        }
        
        // MARK: - Goal Methods
        
        public func addGoal(_ goal: Goal) async throws {
            goals.append(goal)
            try await dataManager.saveGoals(goals)
        }
        
        public func updateGoal(_ goal: Goal) async throws {
            guard let index = goals.firstIndex(where: { $0.id == goal.id }) else {
                throw FinanceError.goalNotFound
            }
            
            goals[index] = goal
            try await dataManager.saveGoals(goals)
        }
        
        public func deleteGoal(_ goalId: String) async throws {
            guard let index = goals.firstIndex(where: { $0.id == goalId }) else {
                throw FinanceError.goalNotFound
            }
            
            goals.remove(at: index)
            try await dataManager.saveGoals(goals)
        }
        
        public func getActiveGoals() -> [Goal] {
            return goals.filter { $0.isActive }
        }
        
        // MARK: - Investment Methods
        
        public func addInvestment(_ investment: Investment) async throws {
            investments.append(investment)
            try await dataManager.saveInvestments(investments)
        }
        
        public func updateInvestment(_ investment: Investment) async throws {
            guard let index = investments.firstIndex(where: { $0.id == investment.id }) else {
                throw FinanceError.investmentNotFound
            }
            
            investments[index] = investment
            try await dataManager.saveInvestments(investments)
        }
        
        public func deleteInvestment(_ investmentId: String) async throws {
            guard let index = investments.firstIndex(where: { $0.id == investmentId }) else {
                throw FinanceError.investmentNotFound
            }
            
            investments.remove(at: index)
            try await dataManager.saveInvestments(investments)
        }
        
        public func getTotalInvestmentValue() -> Double {
            return investments
                .filter { $0.isActive }
                .reduce(0) { $0 + $1.currentValue }
        }
    }
    
    public class DataManager {
        
        private let userDefaults = UserDefaults.standard
        
        public init() {}
        
        public func saveAccounts(_ accounts: [Account]) async throws {
            let data = try JSONEncoder().encode(accounts)
            userDefaults.set(data, forKey: "saved_accounts")
        }
        
        public func loadAccounts() async throws -> [Account] {
            guard let data = userDefaults.data(forKey: "saved_accounts") else {
                return []
            }
            
            return try JSONDecoder().decode([Account].self, from: data)
        }
        
        public func saveTransactions(_ transactions: [Transaction]) async throws {
            let data = try JSONEncoder().encode(transactions)
            userDefaults.set(data, forKey: "saved_transactions")
        }
        
        public func loadTransactions() async throws -> [Transaction] {
            guard let data = userDefaults.data(forKey: "saved_transactions") else {
                return []
            }
            
            return try JSONDecoder().decode([Transaction].self, from: data)
        }
        
        public func saveBudgets(_ budgets: [Budget]) async throws {
            let data = try JSONEncoder().encode(budgets)
            userDefaults.set(data, forKey: "saved_budgets")
        }
        
        public func loadBudgets() async throws -> [Budget] {
            guard let data = userDefaults.data(forKey: "saved_budgets") else {
                return []
            }
            
            return try JSONDecoder().decode([Budget].self, from: data)
        }
        
        public func saveGoals(_ goals: [Goal]) async throws {
            let data = try JSONEncoder().encode(goals)
            userDefaults.set(data, forKey: "saved_goals")
        }
        
        public func loadGoals() async throws -> [Goal] {
            guard let data = userDefaults.data(forKey: "saved_goals") else {
                return []
            }
            
            return try JSONDecoder().decode([Goal].self, from: data)
        }
        
        public func saveInvestments(_ investments: [Investment]) async throws {
            let data = try JSONEncoder().encode(investments)
            userDefaults.set(data, forKey: "saved_investments")
        }
        
        public func loadInvestments() async throws -> [Investment] {
            guard let data = userDefaults.data(forKey: "saved_investments") else {
                return []
            }
            
            return try JSONDecoder().decode([Investment].self, from: data)
        }
    }
    
    public class AnalyticsManager {
        
        public init() {}
        
        public func updateAnalytics() async throws {
            // Implementation for updating analytics
        }
        
        public func getMonthlySpending() -> [String: Double] {
            // Implementation for getting monthly spending by category
            return [:]
        }
        
        public func getIncomeVsExpense() -> (income: Double, expense: Double) {
            // Implementation for getting income vs expense
            return (income: 0, expense: 0)
        }
    }
    
    // MARK: - UI Components
    
    public struct AccountCard: View {
        let account: Account
        let onTap: () -> Void
        
        public init(account: Account, onTap: @escaping () -> Void) {
            self.account = account
            self.onTap = onTap
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    Image(systemName: account.icon)
                        .font(.title2)
                        .foregroundColor(Color(account.color))
                        .frame(width: 40, height: 40)
                        .background(Color(account.color).opacity(0.1))
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text(account.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(account.type.displayName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("$\(String(format: "%.2f", account.balance))")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(account.balance >= 0 ? .green : .red)
                        
                        Text(account.currency)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Recent transactions
                let recentTransactions = account.transactions.prefix(3)
                if !recentTransactions.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Recent Transactions")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        ForEach(Array(recentTransactions), id: \.id) { transaction in
                            HStack {
                                Image(systemName: transaction.category.icon)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                
                                Text(transaction.description ?? transaction.category.displayName)
                                    .font(.caption)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Text("$\(String(format: "%.2f", transaction.amount))")
                                    .font(.caption)
                                    .foregroundColor(transaction.type == .income ? .green : .red)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            .onTapGesture {
                onTap()
            }
        }
    }
    
    public struct TransactionCard: View {
        let transaction: Transaction
        let onTap: () -> Void
        
        public init(transaction: Transaction, onTap: @escaping () -> Void) {
            self.transaction = transaction
            self.onTap = onTap
        }
        
        public var body: some View {
            HStack(spacing: 12) {
                // Category icon
                Image(systemName: transaction.category.icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 40, height: 40)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.description ?? transaction.category.displayName)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(transaction.category.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(transaction.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.2f", transaction.amount))")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(transaction.type == .income ? .green : .red)
                    
                    Text(transaction.type.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 1)
            .onTapGesture {
                onTap()
            }
        }
    }
    
    public struct BudgetCard: View {
        let budget: Budget
        let onTap: () -> Void
        
        public init(budget: Budget, onTap: @escaping () -> Void) {
            self.budget = budget
            self.onTap = onTap
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(budget.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(budget.period.displayName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("$\(String(format: "%.2f", budget.amount))")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Budget")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Progress
                VStack(alignment: .leading) {
                    HStack {
                        Text("Spent")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("$\(String(format: "%.2f", budget.spent))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    ProgressView(value: budget.percentageSpent / 100)
                        .progressViewStyle(LinearProgressViewStyle())
                        .accentColor(budget.isOverBudget ? .red : .blue)
                    
                    HStack {
                        Text("Remaining")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("$\(String(format: "%.2f", budget.remaining))")
                            .font(.caption)
                            .foregroundColor(budget.isOverBudget ? .red : .green)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            .onTapGesture {
                onTap()
            }
        }
    }
    
    // MARK: - Errors
    
    public enum FinanceError: LocalizedError {
        case accountNotFound
        case transactionNotFound
        case budgetNotFound
        case goalNotFound
        case investmentNotFound
        case invalidAmount
        case insufficientFunds
        case networkError
        case saveError
        
        public var errorDescription: String? {
            switch self {
            case .accountNotFound:
                return "Account not found"
            case .transactionNotFound:
                return "Transaction not found"
            case .budgetNotFound:
                return "Budget not found"
            case .goalNotFound:
                return "Goal not found"
            case .investmentNotFound:
                return "Investment not found"
            case .invalidAmount:
                return "Invalid amount"
            case .insufficientFunds:
                return "Insufficient funds"
            case .networkError:
                return "Network error occurred"
            case .saveError:
                return "Failed to save data"
            }
        }
    }
} 