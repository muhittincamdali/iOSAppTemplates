import Foundation
import SwiftUI
import Charts

// MARK: - Finance Templates
public struct FinanceTemplates {
    
    // MARK: - Version
    public static let version = "2.1.0"
    
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
            self.notes = notes
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
    
    public struct Account: Identifiable, Codable {
        public let id: String
        public let name: String
        public let type: AccountType
        public var balance: Double
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
    
    // MARK: - Managers
    @MainActor
    public class FinanceManager: ObservableObject {
        
        @Published public var accounts: [Account] = []
        @Published public var transactions: [Transaction] = []
        @Published public var budgets: [Budget] = []
        @Published public var isLoading = false
        
        public init() {}
        
        public func addAccount(_ account: Account) async throws {
            accounts.append(account)
        }
        
        public func getTotalBalance() -> Double {
            return accounts
                .filter { $0.isActive }
                .reduce(0) { $0 + $1.balance }
        }
    }
    
    // MARK: - UI Components
    
    public struct FinanceChartView: View {
        let transactions: [Transaction]
        
        public init(transactions: [Transaction]) {
            self.transactions = transactions
        }
        
        public var body: some View {
            Chart {
                ForEach(transactions) { transaction in
                    BarMark(
                        x: .value("Date", transaction.date, unit: .day),
                        y: .value("Amount", transaction.amount)
                    )
                    .foregroundStyle(by: .value("Category", transaction.category.displayName))
                }
            }
            .frame(height: 200)
        }
    }
    
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
                        .frame(width: 40, height: 40)
                        .background(Color.blue.opacity(0.1))
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
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.04))
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
        case networkError
        
        public var errorDescription: String? {
            switch self {
            case .accountNotFound: return "Account not found"
            case .transactionNotFound: return "Transaction not found"
            case .budgetNotFound: return "Budget not found"
            case .networkError: return "Network error occurred"
            }
        }
    }
}
