// MARK: - Finance App Template
// Complete banking/finance app with 15+ screens
// Features: Dashboard, Accounts, Cards, Transactions, Budgets, Investments
// Dark mode ready, localized, accessible, biometric security

import SwiftUI
import Foundation
import Combine
import LocalAuthentication

// MARK: - Models

public struct BankAccount: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let type: AccountType
    public let balance: Decimal
    public let currency: String
    public let accountNumber: String
    public let routingNumber: String?
    public let isPrimary: Bool
    public let color: String
    
    public init(
        id: UUID = UUID(),
        name: String,
        type: AccountType,
        balance: Decimal,
        currency: String = "USD",
        accountNumber: String = "",
        routingNumber: String? = nil,
        isPrimary: Bool = false,
        color: String = "#007AFF"
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.balance = balance
        self.currency = currency
        self.accountNumber = accountNumber
        self.routingNumber = routingNumber
        self.isPrimary = isPrimary
        self.color = color
    }
}

public enum AccountType: String, Codable, CaseIterable {
    case checking = "Checking"
    case savings = "Savings"
    case credit = "Credit"
    case investment = "Investment"
    
    public var icon: String {
        switch self {
        case .checking: return "banknote"
        case .savings: return "building.columns"
        case .credit: return "creditcard"
        case .investment: return "chart.line.uptrend.xyaxis"
        }
    }
}

public struct CreditCard: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let lastFourDigits: String
    public let expirationDate: String
    public let cardType: CardType
    public var balance: Decimal
    public let creditLimit: Decimal
    public let color: CardColor
    public var isLocked: Bool
    public let rewardsPoints: Int
    
    public init(
        id: UUID = UUID(),
        name: String,
        lastFourDigits: String,
        expirationDate: String,
        cardType: CardType = .visa,
        balance: Decimal = 0,
        creditLimit: Decimal = 5000,
        color: CardColor = .blue,
        isLocked: Bool = false,
        rewardsPoints: Int = 0
    ) {
        self.id = id
        self.name = name
        self.lastFourDigits = lastFourDigits
        self.expirationDate = expirationDate
        self.cardType = cardType
        self.balance = balance
        self.creditLimit = creditLimit
        self.color = color
        self.isLocked = isLocked
        self.rewardsPoints = rewardsPoints
    }
    
    public var availableCredit: Decimal {
        creditLimit - balance
    }
}

public enum CardType: String, Codable {
    case visa = "Visa"
    case mastercard = "Mastercard"
    case amex = "American Express"
    case discover = "Discover"
}

public enum CardColor: String, Codable, CaseIterable {
    case blue
    case purple
    case gold
    case black
    case green
    
    public var gradient: [Color] {
        switch self {
        case .blue: return [Color.blue, Color.blue.opacity(0.7)]
        case .purple: return [Color.purple, Color.pink]
        case .gold: return [Color.yellow, Color.orange]
        case .black: return [Color.black, Color.gray]
        case .green: return [Color.green, Color.teal]
        }
    }
}

public struct Transaction: Identifiable, Codable {
    public let id: UUID
    public let title: String
    public let merchant: String
    public let category: TransactionCategory
    public let amount: Decimal
    public let type: TransactionType
    public let date: Date
    public let accountId: UUID
    public let status: TransactionStatus
    public let icon: String?
    public let notes: String?
    
    public init(
        id: UUID = UUID(),
        title: String,
        merchant: String,
        category: TransactionCategory,
        amount: Decimal,
        type: TransactionType = .expense,
        date: Date = Date(),
        accountId: UUID = UUID(),
        status: TransactionStatus = .completed,
        icon: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.title = title
        self.merchant = merchant
        self.category = category
        self.amount = amount
        self.type = type
        self.date = date
        self.accountId = accountId
        self.status = status
        self.icon = icon
        self.notes = notes
    }
}

public enum TransactionCategory: String, Codable, CaseIterable {
    case food = "Food & Dining"
    case shopping = "Shopping"
    case transportation = "Transportation"
    case entertainment = "Entertainment"
    case utilities = "Utilities"
    case health = "Health"
    case travel = "Travel"
    case income = "Income"
    case transfer = "Transfer"
    case subscriptions = "Subscriptions"
    case other = "Other"
    
    public var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .shopping: return "bag"
        case .transportation: return "car"
        case .entertainment: return "film"
        case .utilities: return "bolt"
        case .health: return "heart"
        case .travel: return "airplane"
        case .income: return "arrow.down.circle"
        case .transfer: return "arrow.left.arrow.right"
        case .subscriptions: return "repeat"
        case .other: return "ellipsis.circle"
        }
    }
    
    public var color: Color {
        switch self {
        case .food: return .orange
        case .shopping: return .pink
        case .transportation: return .blue
        case .entertainment: return .purple
        case .utilities: return .yellow
        case .health: return .red
        case .travel: return .cyan
        case .income: return .green
        case .transfer: return .gray
        case .subscriptions: return .indigo
        case .other: return .secondary
        }
    }
}

public enum TransactionType: String, Codable {
    case income
    case expense
    case transfer
}

public enum TransactionStatus: String, Codable {
    case pending = "Pending"
    case completed = "Completed"
    case failed = "Failed"
    case cancelled = "Cancelled"
}

public struct Budget: Identifiable, Codable {
    public let id: UUID
    public let category: TransactionCategory
    public var limit: Decimal
    public var spent: Decimal
    public let period: BudgetPeriod
    
    public init(
        id: UUID = UUID(),
        category: TransactionCategory,
        limit: Decimal,
        spent: Decimal = 0,
        period: BudgetPeriod = .monthly
    ) {
        self.id = id
        self.category = category
        self.limit = limit
        self.spent = spent
        self.period = period
    }
    
    public var remaining: Decimal {
        limit - spent
    }
    
    public var progress: Double {
        if limit == 0 { return 0 }
        return Double(truncating: (spent / limit) as NSNumber)
    }
}

public enum BudgetPeriod: String, Codable, CaseIterable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}

public struct Investment: Identifiable, Codable {
    public let id: UUID
    public let symbol: String
    public let name: String
    public let type: InvestmentType
    public let shares: Double
    public let currentPrice: Decimal
    public let purchasePrice: Decimal
    public let change24h: Double
    
    public init(
        id: UUID = UUID(),
        symbol: String,
        name: String,
        type: InvestmentType,
        shares: Double,
        currentPrice: Decimal,
        purchasePrice: Decimal,
        change24h: Double = 0
    ) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.type = type
        self.shares = shares
        self.currentPrice = currentPrice
        self.purchasePrice = purchasePrice
        self.change24h = change24h
    }
    
    public var totalValue: Decimal {
        currentPrice * Decimal(shares)
    }
    
    public var totalGain: Decimal {
        (currentPrice - purchasePrice) * Decimal(shares)
    }
    
    public var gainPercentage: Double {
        if purchasePrice == 0 { return 0 }
        return Double(truncating: ((currentPrice - purchasePrice) / purchasePrice * 100) as NSNumber)
    }
}

public enum InvestmentType: String, Codable, CaseIterable {
    case stock = "Stock"
    case etf = "ETF"
    case crypto = "Crypto"
    case bond = "Bond"
    case mutualFund = "Mutual Fund"
}

// MARK: - Sample Data

public enum FinanceSampleData {
    public static let accounts: [BankAccount] = [
        BankAccount(name: "Main Checking", type: .checking, balance: 12456.78, accountNumber: "****4567", isPrimary: true, color: "#007AFF"),
        BankAccount(name: "Savings", type: .savings, balance: 45230.50, accountNumber: "****8901", color: "#34C759"),
        BankAccount(name: "Investment", type: .investment, balance: 89750.00, accountNumber: "****2345", color: "#5856D6")
    ]
    
    public static let cards: [CreditCard] = [
        CreditCard(name: "Premium Card", lastFourDigits: "4532", expirationDate: "12/27", cardType: .visa, balance: 1234.56, creditLimit: 10000, color: .blue, rewardsPoints: 45230),
        CreditCard(name: "Travel Card", lastFourDigits: "8765", expirationDate: "08/26", cardType: .mastercard, balance: 567.89, creditLimit: 5000, color: .gold, rewardsPoints: 12500),
        CreditCard(name: "Business Card", lastFourDigits: "3210", expirationDate: "03/28", cardType: .amex, balance: 2345.00, creditLimit: 25000, color: .black, rewardsPoints: 89000)
    ]
    
    public static let transactions: [Transaction] = [
        Transaction(title: "Apple Store", merchant: "Apple Inc.", category: .shopping, amount: 999.00, date: Date().addingTimeInterval(-3600)),
        Transaction(title: "Uber Ride", merchant: "Uber", category: .transportation, amount: 24.50, date: Date().addingTimeInterval(-7200)),
        Transaction(title: "Starbucks", merchant: "Starbucks Coffee", category: .food, amount: 6.75, date: Date().addingTimeInterval(-14400)),
        Transaction(title: "Netflix", merchant: "Netflix Inc.", category: .subscriptions, amount: 15.99, date: Date().addingTimeInterval(-86400)),
        Transaction(title: "Salary Deposit", merchant: "Employer Inc.", category: .income, amount: 5500.00, type: .income, date: Date().addingTimeInterval(-172800)),
        Transaction(title: "Electric Bill", merchant: "Power Company", category: .utilities, amount: 125.00, date: Date().addingTimeInterval(-259200)),
        Transaction(title: "Grocery Store", merchant: "Whole Foods", category: .food, amount: 156.43, date: Date().addingTimeInterval(-345600)),
        Transaction(title: "Gas Station", merchant: "Shell", category: .transportation, amount: 45.00, date: Date().addingTimeInterval(-432000))
    ]
    
    public static let budgets: [Budget] = [
        Budget(category: .food, limit: 600, spent: 423.50),
        Budget(category: .shopping, limit: 500, spent: 350.00),
        Budget(category: .transportation, limit: 300, spent: 180.00),
        Budget(category: .entertainment, limit: 200, spent: 150.00),
        Budget(category: .subscriptions, limit: 100, spent: 89.99)
    ]
    
    public static let investments: [Investment] = [
        Investment(symbol: "AAPL", name: "Apple Inc.", type: .stock, shares: 25, currentPrice: 178.50, purchasePrice: 150.00, change24h: 1.25),
        Investment(symbol: "GOOGL", name: "Alphabet Inc.", type: .stock, shares: 10, currentPrice: 142.30, purchasePrice: 125.00, change24h: -0.45),
        Investment(symbol: "VOO", name: "Vanguard S&P 500 ETF", type: .etf, shares: 15, currentPrice: 456.78, purchasePrice: 400.00, change24h: 0.82),
        Investment(symbol: "BTC", name: "Bitcoin", type: .crypto, shares: 0.5, currentPrice: 45000, purchasePrice: 35000, change24h: 2.5),
        Investment(symbol: "MSFT", name: "Microsoft Corp.", type: .stock, shares: 20, currentPrice: 378.90, purchasePrice: 320.00, change24h: 0.95)
    ]
}

// MARK: - View Models

@MainActor
public class FinanceStore: ObservableObject {
    @Published public var accounts: [BankAccount] = FinanceSampleData.accounts
    @Published public var cards: [CreditCard] = FinanceSampleData.cards
    @Published public var transactions: [Transaction] = FinanceSampleData.transactions
    @Published public var budgets: [Budget] = FinanceSampleData.budgets
    @Published public var investments: [Investment] = FinanceSampleData.investments
    @Published public var isAuthenticated = false
    @Published public var selectedAccountId: UUID?
    @Published public var searchQuery = ""
    
    public init() {}
    
    public var totalBalance: Decimal {
        accounts.reduce(0) { $0 + $1.balance }
    }
    
    public var totalInvestments: Decimal {
        investments.reduce(0) { $0 + $1.totalValue }
    }
    
    public var totalCredit: Decimal {
        cards.reduce(0) { $0 + $1.balance }
    }
    
    public var netWorth: Decimal {
        totalBalance + totalInvestments - totalCredit
    }
    
    public var monthlySpending: Decimal {
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
        return transactions
            .filter { $0.type == .expense && $0.date >= startOfMonth }
            .reduce(0) { $0 + $1.amount }
    }
    
    public var monthlyIncome: Decimal {
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
        return transactions
            .filter { $0.type == .income && $0.date >= startOfMonth }
            .reduce(0) { $0 + $1.amount }
    }
    
    public func toggleCardLock(_ card: CreditCard) {
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards[index].isLocked.toggle()
        }
    }
    
    public func authenticate() async -> Bool {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return false
        }
        
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Authenticate to access your finances"
            )
            await MainActor.run {
                self.isAuthenticated = success
            }
            return success
        } catch {
            return false
        }
    }
}

// MARK: - Views

// 1. Main Finance Home View
public struct FinanceHomeView: View {
    @StateObject private var store = FinanceStore()
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            FinanceDashboardView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            CardsView()
                .tabItem {
                    Label("Cards", systemImage: "creditcard")
                }
                .tag(1)
            
            TransactionsView()
                .tabItem {
                    Label("Activity", systemImage: "list.bullet")
                }
                .tag(2)
            
            InvestmentsView()
                .tabItem {
                    Label("Invest", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(3)
            
            FinanceProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(4)
        }
        .environmentObject(store)
    }
}

// 2. Finance Dashboard View
public struct FinanceDashboardView: View {
    @EnvironmentObject var store: FinanceStore
    @State private var showingTransfer = false
    @State private var showingPayments = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Net Worth Card
                    NetWorthCard()
                    
                    // Quick Actions
                    QuickActionsRow()
                    
                    // Accounts
                    AccountsSection()
                    
                    // Recent Transactions
                    RecentTransactionsSection()
                    
                    // Budget Overview
                    BudgetOverviewSection()
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {} label: {
                        Image(systemName: "bell")
                    }
                }
            }
        }
    }
}

// 3. Net Worth Card
struct NetWorthCard: View {
    @EnvironmentObject var store: FinanceStore
    @State private var showBalance = true
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Net Worth")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        if showBalance {
                            Text(store.netWorth, format: .currency(code: "USD"))
                                .font(.system(size: 34, weight: .bold))
                        } else {
                            Text("••••••")
                                .font(.system(size: 34, weight: .bold))
                        }
                        
                        Button {
                            showBalance.toggle()
                        } label: {
                            Image(systemName: showBalance ? "eye" : "eye.slash")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("+$2,450.00")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    Text("this month")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack(spacing: 20) {
                MiniStatView(title: "Cash", amount: store.totalBalance, color: .blue)
                MiniStatView(title: "Investments", amount: store.totalInvestments, color: .green)
                MiniStatView(title: "Credit", amount: store.totalCredit, color: .red)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .foregroundColor(.white)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

struct MiniStatView: View {
    let title: String
    let amount: Decimal
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(amount, format: .currency(code: "USD"))
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

// 4. Quick Actions Row
struct QuickActionsRow: View {
    var body: some View {
        HStack(spacing: 16) {
            QuickActionButton(icon: "arrow.left.arrow.right", title: "Transfer", color: .blue)
            QuickActionButton(icon: "qrcode", title: "Pay", color: .green)
            QuickActionButton(icon: "arrow.down.circle", title: "Request", color: .orange)
            QuickActionButton(icon: "ellipsis", title: "More", color: .gray)
        }
        .padding(.horizontal)
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.15))
                .clipShape(Circle())
            
            Text(title)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}

// 5. Accounts Section
struct AccountsSection: View {
    @EnvironmentObject var store: FinanceStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Accounts")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink("See All") {
                    AccountsListView()
                        .environmentObject(store)
                }
                .font(.subheadline)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(store.accounts) { account in
                        AccountCardSmall(account: account)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct AccountCardSmall: View {
    let account: BankAccount
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: account.type.icon)
                    .foregroundColor(.white)
                
                Spacer()
                
                if account.isPrimary {
                    Text("PRIMARY")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.white.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            Spacer()
            
            Text(account.name)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Text(account.balance, format: .currency(code: account.currency))
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(width: 160, height: 100)
        .padding()
        .background(Color(hex: account.color))
        .cornerRadius(16)
    }
}

// 6. Recent Transactions Section
struct RecentTransactionsSection: View {
    @EnvironmentObject var store: FinanceStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Activity")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink("See All") {
                    TransactionsView()
                        .environmentObject(store)
                }
                .font(.subheadline)
            }
            .padding(.horizontal)
            
            VStack(spacing: 0) {
                ForEach(store.transactions.prefix(5)) { transaction in
                    TransactionRow(transaction: transaction)
                    
                    if transaction.id != store.transactions.prefix(5).last?.id {
                        Divider()
                            .padding(.leading, 60)
                    }
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: transaction.category.icon)
                .font(.title3)
                .foregroundColor(transaction.category.color)
                .frame(width: 40, height: 40)
                .background(transaction.category.color.opacity(0.15))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(transaction.merchant)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.type == .income ? "+" : "-")
                + Text(transaction.amount, format: .currency(code: "USD"))
                    .foregroundColor(transaction.type == .income ? .green : .primary)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(transaction.date, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

// 7. Budget Overview Section
struct BudgetOverviewSection: View {
    @EnvironmentObject var store: FinanceStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Budget")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink("Manage") {
                    BudgetView()
                        .environmentObject(store)
                }
                .font(.subheadline)
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(store.budgets.prefix(3)) { budget in
                    BudgetRow(budget: budget)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
}

struct BudgetRow: View {
    let budget: Budget
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: budget.category.icon)
                        .foregroundColor(budget.category.color)
                    
                    Text(budget.category.rawValue)
                        .font(.subheadline)
                }
                
                Spacer()
                
                Text("\(budget.spent, format: .currency(code: "USD")) / \(budget.limit, format: .currency(code: "USD"))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray4))
                    
                    Rectangle()
                        .fill(budget.progress > 0.9 ? Color.red : budget.category.color)
                        .frame(width: geometry.size.width * min(budget.progress, 1))
                }
            }
            .frame(height: 6)
            .cornerRadius(3)
        }
    }
}

// 8. Cards View
public struct CardsView: View {
    @EnvironmentObject var store: FinanceStore
    @State private var selectedCardIndex = 0
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Card Carousel
                    TabView(selection: $selectedCardIndex) {
                        ForEach(Array(store.cards.enumerated()), id: \.element.id) { index, card in
                            CreditCardView(card: card)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .frame(height: 240)
                    
                    // Card Actions
                    if !store.cards.isEmpty {
                        CardActionsView(card: store.cards[selectedCardIndex])
                    }
                    
                    // Card Details
                    if !store.cards.isEmpty {
                        CardDetailsView(card: store.cards[selectedCardIndex])
                    }
                    
                    // Recent Card Transactions
                    RecentCardTransactionsView()
                }
                .padding(.vertical)
            }
            .navigationTitle("Cards")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {} label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct CreditCardView: View {
    let card: CreditCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(card.name)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: card.isLocked ? "lock.fill" : "creditcard.fill")
            }
            
            Spacer()
            
            Text("•••• •••• •••• \(card.lastFourDigits)")
                .font(.title2)
                .fontWeight(.medium)
                .tracking(2)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("EXPIRES")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                    Text(card.expirationDate)
                        .font(.subheadline)
                }
                
                Spacer()
                
                Text(card.cardType.rawValue)
                    .font(.headline)
            }
        }
        .foregroundColor(.white)
        .padding(24)
        .frame(height: 200)
        .background(
            LinearGradient(
                colors: card.color.gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct CardActionsView: View {
    @EnvironmentObject var store: FinanceStore
    let card: CreditCard
    
    var body: some View {
        HStack(spacing: 24) {
            CardActionButton(icon: "lock.fill", title: card.isLocked ? "Unlock" : "Lock") {
                store.toggleCardLock(card)
            }
            CardActionButton(icon: "doc.text", title: "Statement") {}
            CardActionButton(icon: "gearshape", title: "Settings") {}
            CardActionButton(icon: "creditcard.and.123", title: "Details") {}
        }
        .padding(.horizontal)
    }
}

struct CardActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(.primary)
    }
}

struct CardDetailsView: View {
    let card: CreditCard
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Balance")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(card.balance, format: .currency(code: "USD"))
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Available Credit")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(card.availableCredit, format: .currency(code: "USD"))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray4))
                    
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: geometry.size.width * Double(truncating: (card.balance / card.creditLimit) as NSNumber))
                }
            }
            .frame(height: 8)
            .cornerRadius(4)
            
            HStack {
                Text("Credit Limit: \(card.creditLimit, format: .currency(code: "USD"))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(card.rewardsPoints) points")
                }
                .font(.caption)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct RecentCardTransactionsView: View {
    @EnvironmentObject var store: FinanceStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Transactions")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                ForEach(store.transactions.prefix(3)) { transaction in
                    TransactionRow(transaction: transaction)
                    Divider()
                        .padding(.leading, 60)
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
}

// 9. Transactions View
public struct TransactionsView: View {
    @EnvironmentObject var store: FinanceStore
    @State private var selectedCategory: TransactionCategory?
    @State private var searchText = ""
    
    public init() {}
    
    var filteredTransactions: [Transaction] {
        var result = store.transactions
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.merchant.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryFilterChip(title: "All", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        
                        ForEach(TransactionCategory.allCases, id: \.self) { category in
                            CategoryFilterChip(
                                title: category.rawValue,
                                icon: category.icon,
                                color: category.color,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding()
                }
                
                List(filteredTransactions) { transaction in
                    NavigationLink {
                        TransactionDetailView(transaction: transaction)
                    } label: {
                        TransactionRow(transaction: transaction)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Transactions")
            .searchable(text: $searchText, prompt: "Search transactions")
        }
    }
}

struct CategoryFilterChip: View {
    let title: String
    var icon: String? = nil
    var color: Color = .blue
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? color : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

// 10. Transaction Detail View
struct TransactionDetailView: View {
    let transaction: Transaction
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Amount
                VStack(spacing: 8) {
                    Image(systemName: transaction.category.icon)
                        .font(.system(size: 50))
                        .foregroundColor(transaction.category.color)
                        .frame(width: 80, height: 80)
                        .background(transaction.category.color.opacity(0.15))
                        .clipShape(Circle())
                    
                    Text(transaction.type == .income ? "+" : "-")
                    + Text(transaction.amount, format: .currency(code: "USD"))
                        .font(.system(size: 40, weight: .bold))
                    
                    Text(transaction.status.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(12)
                }
                .padding(.top)
                
                // Details
                VStack(spacing: 0) {
                    DetailRow(title: "Merchant", value: transaction.merchant)
                    Divider()
                    DetailRow(title: "Category", value: transaction.category.rawValue)
                    Divider()
                    DetailRow(title: "Date", value: transaction.date.formatted(date: .long, time: .shortened))
                    Divider()
                    DetailRow(title: "Type", value: transaction.type.rawValue.capitalized)
                }
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Actions
                VStack(spacing: 12) {
                    Button {} label: {
                        HStack {
                            Image(systemName: "flag")
                            Text("Report Issue")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    Button {} label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Receipt")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .foregroundColor(.primary)
                .padding(.horizontal)
            }
        }
        .navigationTitle(transaction.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding()
    }
}

// 11. Budget View
struct BudgetView: View {
    @EnvironmentObject var store: FinanceStore
    @State private var showingAddBudget = false
    
    var totalBudget: Decimal {
        store.budgets.reduce(0) { $0 + $1.limit }
    }
    
    var totalSpent: Decimal {
        store.budgets.reduce(0) { $0 + $1.spent }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Overview
                VStack(spacing: 16) {
                    Text("Monthly Budget")
                        .font(.headline)
                    
                    ZStack {
                        Circle()
                            .stroke(Color(.systemGray4), lineWidth: 20)
                        
                        Circle()
                            .trim(from: 0, to: Double(truncating: (totalSpent / totalBudget) as NSNumber))
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text(totalSpent, format: .currency(code: "USD"))
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("of \(totalBudget, format: .currency(code: "USD"))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: 200, height: 200)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .padding(.horizontal)
                
                // Categories
                VStack(alignment: .leading, spacing: 16) {
                    Text("Categories")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(store.budgets) { budget in
                        BudgetCategoryCard(budget: budget)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Budget")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddBudget = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct BudgetCategoryCard: View {
    let budget: Budget
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 12) {
                    Image(systemName: budget.category.icon)
                        .font(.title3)
                        .foregroundColor(budget.category.color)
                        .frame(width: 40, height: 40)
                        .background(budget.category.color.opacity(0.15))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(budget.category.rawValue)
                            .fontWeight(.medium)
                        
                        Text(budget.period.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(budget.remaining, format: .currency(code: "USD"))
                        .fontWeight(.semibold)
                        .foregroundColor(budget.remaining < 0 ? .red : .green)
                    
                    Text("remaining")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray4))
                    
                    Rectangle()
                        .fill(budget.progress > 0.9 ? Color.red : budget.category.color)
                        .frame(width: geometry.size.width * min(budget.progress, 1))
                }
            }
            .frame(height: 8)
            .cornerRadius(4)
            
            HStack {
                Text("\(budget.spent, format: .currency(code: "USD")) spent")
                Spacer()
                Text("\(budget.limit, format: .currency(code: "USD")) limit")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// 12. Investments View
public struct InvestmentsView: View {
    @EnvironmentObject var store: FinanceStore
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Portfolio Value
                    PortfolioCard()
                    
                    // Holdings
                    HoldingsSection()
                }
                .padding(.vertical)
            }
            .navigationTitle("Investments")
        }
    }
}

struct PortfolioCard: View {
    @EnvironmentObject var store: FinanceStore
    
    var totalGain: Decimal {
        store.investments.reduce(0) { $0 + $1.totalGain }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Portfolio Value")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(store.totalInvestments, format: .currency(code: "USD"))
                .font(.system(size: 36, weight: .bold))
            
            HStack {
                Image(systemName: totalGain >= 0 ? "arrow.up.right" : "arrow.down.right")
                Text(totalGain, format: .currency(code: "USD"))
                Text("(\(String(format: "%.2f", Double(truncating: (totalGain / store.totalInvestments * 100) as NSNumber)))%)")
            }
            .font(.subheadline)
            .foregroundColor(totalGain >= 0 ? .green : .red)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.green.opacity(0.3), Color.blue.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

struct HoldingsSection: View {
    @EnvironmentObject var store: FinanceStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Holdings")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(store.investments) { investment in
                HoldingRow(investment: investment)
            }
        }
    }
}

struct HoldingRow: View {
    let investment: Investment
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(
                    Text(investment.symbol.prefix(2))
                        .font(.caption)
                        .fontWeight(.bold)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(investment.symbol)
                    .fontWeight(.semibold)
                
                Text(investment.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(investment.totalValue, format: .currency(code: "USD"))
                    .fontWeight(.semibold)
                
                HStack(spacing: 4) {
                    Image(systemName: investment.change24h >= 0 ? "arrow.up.right" : "arrow.down.right")
                    Text("\(String(format: "%.2f", abs(investment.change24h)))%")
                }
                .font(.caption)
                .foregroundColor(investment.change24h >= 0 ? .green : .red)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// 13. Accounts List View
struct AccountsListView: View {
    @EnvironmentObject var store: FinanceStore
    
    var body: some View {
        List(store.accounts) { account in
            NavigationLink {
                AccountDetailView(account: account)
                    .environmentObject(store)
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: account.type.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color(hex: account.color))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(account.name)
                            .fontWeight(.medium)
                        
                        Text(account.type.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(account.balance, format: .currency(code: account.currency))
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Accounts")
    }
}

// 14. Account Detail View
struct AccountDetailView: View {
    @EnvironmentObject var store: FinanceStore
    let account: BankAccount
    
    var accountTransactions: [Transaction] {
        store.transactions.filter { $0.accountId == account.id }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Balance Card
                VStack(spacing: 8) {
                    Text("Available Balance")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(account.balance, format: .currency(code: account.currency))
                        .font(.system(size: 40, weight: .bold))
                    
                    Text(account.accountNumber)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: account.color).opacity(0.2))
                .cornerRadius(20)
                .padding(.horizontal)
                
                // Quick Actions
                HStack(spacing: 24) {
                    QuickActionButton(icon: "arrow.up.circle", title: "Send", color: .blue)
                    QuickActionButton(icon: "arrow.down.circle", title: "Request", color: .green)
                    QuickActionButton(icon: "doc.text", title: "Statement", color: .purple)
                    QuickActionButton(icon: "gear", title: "Settings", color: .gray)
                }
                .padding(.horizontal)
                
                // Transactions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Transactions")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if accountTransactions.isEmpty {
                        Text("No transactions yet")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        VStack(spacing: 0) {
                            ForEach(accountTransactions) { transaction in
                                TransactionRow(transaction: transaction)
                                Divider()
                                    .padding(.leading, 60)
                            }
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(account.name)
    }
}

// 15. Finance Profile View
struct FinanceProfileView: View {
    @EnvironmentObject var store: FinanceStore
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text("JD")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("John Doe")
                                .font(.headline)
                            
                            Text("Premium Member")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Security") {
                    NavigationLink("Face ID & Passcode", systemImage: "faceid") {}
                    NavigationLink("Two-Factor Authentication", systemImage: "lock.shield") {}
                    NavigationLink("Login Notifications", systemImage: "bell.badge") {}
                }
                
                Section("Preferences") {
                    NavigationLink("Notifications", systemImage: "bell") {}
                    NavigationLink("Default Currency", systemImage: "dollarsign.circle") {}
                    NavigationLink("Appearance", systemImage: "paintbrush") {}
                }
                
                Section("Support") {
                    NavigationLink("Help Center", systemImage: "questionmark.circle") {}
                    NavigationLink("Contact Us", systemImage: "message") {}
                    NavigationLink("Report a Problem", systemImage: "exclamationmark.triangle") {}
                }
                
                Section {
                    Button("Sign Out", role: .destructive) {}
                }
            }
            .navigationTitle("Profile")
        }
    }
}

// MARK: - App Entry Point

public struct FinanceApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            FinanceHomeView()
        }
    }
}
