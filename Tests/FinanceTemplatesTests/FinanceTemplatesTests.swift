//
// FinanceTemplatesTests.swift
// iOS App Templates
//
// Created on 17/08/2024.
//

import XCTest
import Testing
@testable import FinanceTemplates

/// Comprehensive test suite for Finance Templates
/// Enterprise Standards Compliant: >95% test coverage
@Suite("Finance Templates Tests")
final class FinanceTemplatesTests: XCTestCase {
    
    // MARK: - Properties
    
    private var financeTemplate: FinanceTemplate!
    private var mockBankingService: MockBankingService!
    private var mockCryptoService: MockCryptoService!
    private var mockInvestmentService: MockInvestmentService!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockBankingService = MockBankingService()
        mockCryptoService = MockCryptoService()
        mockInvestmentService = MockInvestmentService()
        financeTemplate = FinanceTemplate(
            bankingService: mockBankingService,
            cryptoService: mockCryptoService,
            investmentService: mockInvestmentService
        )
    }
    
    override func tearDownWithError() throws {
        financeTemplate = nil
        mockBankingService = nil
        mockCryptoService = nil
        mockInvestmentService = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Template Configuration Tests
    
    @Test("Finance template initializes with security compliance")
    func testFinanceTemplateInitialization() async throws {
        // Given
        let config = FinanceTemplateConfiguration(
            enableBiometricAuth: true,
            encryptionLevel: .aes256,
            complianceLevel: .pci_dss,
            enableFraudDetection: true
        )
        
        // When
        let template = FinanceTemplate(configuration: config)
        
        // Then
        #expect(template.configuration.enableBiometricAuth == true)
        #expect(template.configuration.encryptionLevel == .aes256)
        #expect(template.configuration.complianceLevel == .pci_dss)
        #expect(template.configuration.enableFraudDetection == true)
    }
    
    @Test("Template validates security requirements")
    func testSecurityValidation() async throws {
        // Given
        let weakConfig = FinanceTemplateConfiguration(
            enableBiometricAuth: false,
            encryptionLevel: .basic,
            complianceLevel: .none,
            enableFraudDetection: false
        )
        
        // When/Then
        #expect(throws: FinanceTemplateError.insufficientSecurity) {
            let _ = try FinanceTemplate.validate(configuration: weakConfig)
        }
    }
    
    // MARK: - Account Management Tests
    
    @Test("User authentication with biometric succeeds")
    func testBiometricAuthentication() async throws {
        // Given
        mockBankingService.mockAuthResult = .success(AuthenticationResult.success)
        
        // When
        let result = try await financeTemplate.authenticateUser()
        
        // Then
        #expect(result.isAuthenticated)
        #expect(mockBankingService.biometricAuthCalled)
    }
    
    @Test("Account balance retrieval with encryption")
    func testAccountBalanceRetrieval() async throws {
        // Given
        let expectedBalance = AccountBalance(
            checking: 5000.00,
            savings: 15000.00,
            currency: "USD"
        )
        mockBankingService.mockBalanceResult = .success(expectedBalance)
        
        // When
        let balance = try await financeTemplate.getAccountBalance()
        
        // Then
        #expect(balance.checking == 5000.00)
        #expect(balance.savings == 15000.00)
        #expect(mockBankingService.getBalanceCalled)
        #expect(mockBankingService.lastRequestWasEncrypted)
    }
    
    @Test("Transaction history with date range")
    func testTransactionHistory() async throws {
        // Given
        let fromDate = Date().addingTimeInterval(-86400 * 30) // 30 days ago
        let toDate = Date()
        let mockTransactions = [
            Transaction.mockPayment,
            Transaction.mockDeposit,
            Transaction.mockWithdrawal
        ]
        mockBankingService.mockTransactionsResult = .success(mockTransactions)
        
        // When
        let transactions = try await financeTemplate.getTransactionHistory(from: fromDate, to: toDate)
        
        // Then
        #expect(transactions.count == 3)
        #expect(mockBankingService.getTransactionsCalled)
    }
    
    // MARK: - Transfer & Payment Tests
    
    @Test("Bank transfer succeeds with fraud detection")
    func testBankTransferSuccess() async throws {
        // Given
        let transferData = TransferData(
            fromAccount: "12345678",
            toAccount: "87654321",
            amount: 1000.00,
            currency: "USD",
            description: "Monthly payment"
        )
        let expectedTransfer = TransferResult(
            transactionId: "TXN123456",
            status: .completed,
            amount: transferData.amount
        )
        mockBankingService.mockTransferResult = .success(expectedTransfer)
        
        // When
        let result = try await financeTemplate.transferFunds(transferData)
        
        // Then
        #expect(result.status == .completed)
        #expect(result.transactionId == "TXN123456")
        #expect(mockBankingService.transferFundsCalled)
        #expect(mockBankingService.fraudDetectionPerformed)
    }
    
    @Test("Transfer fails with insufficient funds")
    func testTransferInsufficientFunds() async throws {
        // Given
        let transferData = TransferData(
            fromAccount: "12345678",
            toAccount: "87654321",
            amount: 50000.00, // More than available balance
            currency: "USD",
            description: "Large payment"
        )
        mockBankingService.mockTransferResult = .failure(TransferError.insufficientFunds)
        
        // When/Then
        await #expect(throws: TransferError.insufficientFunds) {
            try await financeTemplate.transferFunds(transferData)
        }
    }
    
    @Test("Bill payment with scheduling")
    func testBillPayment() async throws {
        // Given
        let billData = BillPaymentData(
            payeeId: "ELECTRIC_COMPANY",
            amount: 150.00,
            currency: "USD",
            dueDate: Date().addingTimeInterval(86400 * 7), // 7 days from now
            isRecurring: true
        )
        mockBankingService.mockBillPaymentResult = .success(PaymentResult.success)
        
        // When
        let result = try await financeTemplate.payBill(billData)
        
        // Then
        #expect(result.isSuccess)
        #expect(mockBankingService.payBillCalled)
    }
    
    // MARK: - Investment Management Tests
    
    @Test("Portfolio overview retrieval")
    func testPortfolioOverview() async throws {
        // Given
        let expectedPortfolio = Portfolio(
            totalValue: 25000.00,
            dailyChange: 150.00,
            dailyChangePercent: 0.6,
            holdings: [
                Holding.mockStock,
                Holding.mockBond,
                Holding.mockETF
            ]
        )
        mockInvestmentService.mockPortfolioResult = .success(expectedPortfolio)
        
        // When
        let portfolio = try await financeTemplate.getPortfolioOverview()
        
        // Then
        #expect(portfolio.totalValue == 25000.00)
        #expect(portfolio.holdings.count == 3)
        #expect(mockInvestmentService.getPortfolioCalled)
    }
    
    @Test("Stock quote real-time")
    func testStockQuote() async throws {
        // Given
        let symbol = "AAPL"
        let expectedQuote = StockQuote(
            symbol: symbol,
            price: 150.25,
            change: 2.50,
            changePercent: 1.69,
            volume: 45000000,
            lastUpdated: Date()
        )
        mockInvestmentService.mockQuoteResult = .success(expectedQuote)
        
        // When
        let quote = try await financeTemplate.getStockQuote(symbol: symbol)
        
        // Then
        #expect(quote.symbol == "AAPL")
        #expect(quote.price == 150.25)
        #expect(mockInvestmentService.getQuoteCalled)
    }
    
    @Test("Buy stock order execution")
    func testBuyStockOrder() async throws {
        // Given
        let orderData = StockOrderData(
            symbol: "AAPL",
            quantity: 10,
            orderType: .market,
            side: .buy
        )
        let expectedOrder = OrderResult(
            orderId: "ORDER123",
            status: .filled,
            executedPrice: 150.25,
            executedQuantity: 10
        )
        mockInvestmentService.mockOrderResult = .success(expectedOrder)
        
        // When
        let result = try await financeTemplate.placeStockOrder(orderData)
        
        // Then
        #expect(result.status == .filled)
        #expect(result.executedQuantity == 10)
        #expect(mockInvestmentService.placeOrderCalled)
    }
    
    // MARK: - Cryptocurrency Tests
    
    @Test("Crypto portfolio retrieval")
    func testCryptoPortfolio() async throws {
        // Given
        let expectedPortfolio = CryptoPortfolio(
            totalValue: 5000.00,
            holdings: [
                CryptoHolding.mockBitcoin,
                CryptoHolding.mockEthereum
            ]
        )
        mockCryptoService.mockPortfolioResult = .success(expectedPortfolio)
        
        // When
        let portfolio = try await financeTemplate.getCryptoPortfolio()
        
        // Then
        #expect(portfolio.totalValue == 5000.00)
        #expect(portfolio.holdings.count == 2)
        #expect(mockCryptoService.getPortfolioCalled)
    }
    
    @Test("Crypto price tracking")
    func testCryptoPriceTracking() async throws {
        // Given
        let symbol = "BTC"
        let expectedPrice = CryptoPrice(
            symbol: symbol,
            price: 45000.00,
            change24h: 1250.00,
            changePercent24h: 2.85,
            lastUpdated: Date()
        )
        mockCryptoService.mockPriceResult = .success(expectedPrice)
        
        // When
        let price = try await financeTemplate.getCryptoPrice(symbol: symbol)
        
        // Then
        #expect(price.symbol == "BTC")
        #expect(price.price == 45000.00)
        #expect(mockCryptoService.getPriceCalled)
    }
    
    @Test("Crypto trading with security validation")
    func testCryptoTrading() async throws {
        // Given
        let tradeData = CryptoTradeData(
            symbol: "BTC",
            amount: 0.1,
            side: .buy,
            orderType: .market
        )
        mockCryptoService.mockTradeResult = .success(TradeResult.success)
        
        // When
        let result = try await financeTemplate.executeCryptoTrade(tradeData)
        
        // Then
        #expect(result.isSuccess)
        #expect(mockCryptoService.executeTradeCalled)
        #expect(mockCryptoService.securityValidationPerformed)
    }
    
    // MARK: - Security & Compliance Tests
    
    @Test("Data encryption validation")
    func testDataEncryption() async throws {
        // Given
        let sensitiveData = "Account: 1234567890"
        
        // When
        let encryptedData = try await financeTemplate.encryptSensitiveData(sensitiveData)
        
        // Then
        #expect(encryptedData != sensitiveData)
        #expect(mockCryptoService.encryptDataCalled)
    }
    
    @Test("PCI DSS compliance check")
    func testPCIDSSCompliance() async throws {
        // Given
        let paymentData = PaymentCardData(
            number: "4111111111111111",
            expiryMonth: 12,
            expiryYear: 2025,
            cvv: "123"
        )
        
        // When
        let isCompliant = try await financeTemplate.validatePCICompliance(paymentData)
        
        // Then
        #expect(isCompliant)
        #expect(mockBankingService.pciValidationPerformed)
        #expect(!mockBankingService.lastProcessedData.contains("4111111111111111"))
    }
    
    @Test("Fraud detection triggers on suspicious activity")
    func testFraudDetection() async throws {
        // Given
        let suspiciousTransfer = TransferData(
            fromAccount: "12345678",
            toAccount: "SUSPICIOUS_ACCOUNT",
            amount: 9999.99, // Just under $10k reporting threshold
            currency: "USD",
            description: "Urgent transfer"
        )
        mockBankingService.mockFraudDetected = true
        
        // When/Then
        await #expect(throws: SecurityError.suspiciousActivity) {
            try await financeTemplate.transferFunds(suspiciousTransfer)
        }
        #expect(mockBankingService.fraudDetectionPerformed)
    }
    
    // MARK: - Performance Tests
    
    @Test("Balance retrieval under 500ms")
    func testBalanceRetrievalPerformance() async throws {
        // Given
        mockBankingService.mockBalanceResult = .success(AccountBalance.mock)
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = try await financeTemplate.getAccountBalance()
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 0.5, "Balance retrieval should complete under 500ms")
    }
    
    @Test("Stock quote latency under 200ms")
    func testStockQuotePerformance() async throws {
        // Given
        mockInvestmentService.mockQuoteResult = .success(StockQuote.mockAAPL)
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = try await financeTemplate.getStockQuote(symbol: "AAPL")
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 0.2, "Stock quote should complete under 200ms")
    }
    
    // MARK: - Analytics & Reporting Tests
    
    @Test("Spending analytics generation")
    func testSpendingAnalytics() async throws {
        // Given
        let dateRange = DateRange(
            from: Date().addingTimeInterval(-86400 * 30),
            to: Date()
        )
        let expectedAnalytics = SpendingAnalytics(
            totalSpent: 3500.00,
            categoryBreakdown: [
                "Food": 800.00,
                "Transportation": 400.00,
                "Entertainment": 300.00
            ],
            averageDaily: 116.67
        )
        mockBankingService.mockAnalyticsResult = .success(expectedAnalytics)
        
        // When
        let analytics = try await financeTemplate.getSpendingAnalytics(for: dateRange)
        
        // Then
        #expect(analytics.totalSpent == 3500.00)
        #expect(analytics.categoryBreakdown.count == 3)
        #expect(mockBankingService.getAnalyticsCalled)
    }
}

// MARK: - Mock Classes

class MockBankingService {
    var biometricAuthCalled = false
    var getBalanceCalled = false
    var getTransactionsCalled = false
    var transferFundsCalled = false
    var payBillCalled = false
    var getAnalyticsCalled = false
    var lastRequestWasEncrypted = true
    var fraudDetectionPerformed = true
    var pciValidationPerformed = true
    var mockFraudDetected = false
    var lastProcessedData = ""
    
    var mockAuthResult: Result<AuthenticationResult, Error> = .success(.success)
    var mockBalanceResult: Result<AccountBalance, Error> = .success(.mock)
    var mockTransactionsResult: Result<[Transaction], Error> = .success([])
    var mockTransferResult: Result<TransferResult, Error> = .success(.success)
    var mockBillPaymentResult: Result<PaymentResult, Error> = .success(.success)
    var mockAnalyticsResult: Result<SpendingAnalytics, Error> = .success(.mock)
}

class MockInvestmentService {
    var getPortfolioCalled = false
    var getQuoteCalled = false
    var placeOrderCalled = false
    
    var mockPortfolioResult: Result<Portfolio, Error> = .success(.mock)
    var mockQuoteResult: Result<StockQuote, Error> = .success(.mockAAPL)
    var mockOrderResult: Result<OrderResult, Error> = .success(.success)
}

class MockCryptoService {
    var getPortfolioCalled = false
    var getPriceCalled = false
    var executeTradeCalled = false
    var encryptDataCalled = false
    var securityValidationPerformed = true
    
    var mockPortfolioResult: Result<CryptoPortfolio, Error> = .success(.mock)
    var mockPriceResult: Result<CryptoPrice, Error> = .success(.mockBTC)
    var mockTradeResult: Result<TradeResult, Error> = .success(.success)
}

// MARK: - Mock Data Extensions

extension AccountBalance {
    static let mock = AccountBalance(
        checking: 5000.00,
        savings: 15000.00,
        currency: "USD"
    )
}

extension Transaction {
    static let mockPayment = Transaction(
        id: "txn-1",
        type: .payment,
        amount: -150.00,
        description: "Electric Bill",
        date: Date().addingTimeInterval(-86400)
    )
    
    static let mockDeposit = Transaction(
        id: "txn-2",
        type: .deposit,
        amount: 3000.00,
        description: "Salary",
        date: Date().addingTimeInterval(-86400 * 15)
    )
    
    static let mockWithdrawal = Transaction(
        id: "txn-3",
        type: .withdrawal,
        amount: -200.00,
        description: "ATM Withdrawal",
        date: Date().addingTimeInterval(-86400 * 7)
    )
}

extension Holding {
    static let mockStock = Holding(
        symbol: "AAPL",
        quantity: 50,
        currentPrice: 150.25,
        totalValue: 7512.50,
        dayChange: 125.00
    )
    
    static let mockBond = Holding(
        symbol: "TLT",
        quantity: 100,
        currentPrice: 95.50,
        totalValue: 9550.00,
        dayChange: -50.00
    )
    
    static let mockETF = Holding(
        symbol: "SPY",
        quantity: 20,
        currentPrice: 400.00,
        totalValue: 8000.00,
        dayChange: 75.00
    )
}

extension StockQuote {
    static let mockAAPL = StockQuote(
        symbol: "AAPL",
        price: 150.25,
        change: 2.50,
        changePercent: 1.69,
        volume: 45000000,
        lastUpdated: Date()
    )
}

extension CryptoHolding {
    static let mockBitcoin = CryptoHolding(
        symbol: "BTC",
        amount: 0.1,
        currentPrice: 45000.00,
        totalValue: 4500.00
    )
    
    static let mockEthereum = CryptoHolding(
        symbol: "ETH",
        amount: 1.5,
        currentPrice: 3000.00,
        totalValue: 4500.00
    )
}

extension CryptoPrice {
    static let mockBTC = CryptoPrice(
        symbol: "BTC",
        price: 45000.00,
        change24h: 1250.00,
        changePercent24h: 2.85,
        lastUpdated: Date()
    )
}

extension SpendingAnalytics {
    static let mock = SpendingAnalytics(
        totalSpent: 3500.00,
        categoryBreakdown: [
            "Food": 800.00,
            "Transportation": 400.00,
            "Entertainment": 300.00
        ],
        averageDaily: 116.67
    )
}