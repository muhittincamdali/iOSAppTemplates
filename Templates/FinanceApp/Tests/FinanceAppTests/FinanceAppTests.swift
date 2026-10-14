import Foundation
import Testing
@testable import FinanceApp

@MainActor
@Suite("FinanceOperatingStore")
struct FinanceOperatingStoreTests {
    private func balance(_ id: UUID?, in store: FinanceOperatingStore) throws -> Double {
        let accountID = try #require(id)
        return try #require(store.account(id: accountID)).balance
    }

    private func budgetSpent(_ category: String, in store: FinanceOperatingStore) throws -> Double {
        try #require(store.budgets.first { $0.category == category }).spent
    }

    @Test func netCashExcludesCreditAndCreditUsageIsPositive() {
        let store = FinanceOperatingStore()

        #expect(store.netCash == 18_420 + 9_200)
        #expect(store.totalCreditUsed == 2_160)
    }

    @Test func reserveTransferMovesCashAndLogsBothLegs() throws {
        let store = FinanceOperatingStore()
        let netCash = store.netCash
        let transactions = store.transactions.count

        store.moveToReserve()

        #expect(try balance(store.operatingAccountID, in: store) == 18_420 - 1_200)
        #expect(try balance(store.reserveAccountID, in: store) == 9_200 + 1_200)
        #expect(store.netCash == netCash)
        #expect(store.transactions.count == transactions + 2)
        #expect(store.transactions[0].amount == -1_200)
        #expect(store.transactions[1].amount == 1_200)
    }

    @Test func transferIsSkippedWhenSourceCannotCoverIt() throws {
        let store = FinanceOperatingStore()
        let index = try #require(store.accounts.firstIndex { $0.id == store.operatingAccountID })
        store.accounts[index].balance = 1_000
        let transactions = store.transactions.count

        store.moveToReserve()

        #expect(store.accounts[index].balance == 1_000)
        #expect(store.transactions.count == transactions)
    }

    @Test func fundingOperationsMovesFromReserve() throws {
        let store = FinanceOperatingStore()

        store.fundOperations()

        #expect(try balance(store.operatingAccountID, in: store) == 18_420 + 750)
        #expect(try balance(store.reserveAccountID, in: store) == 9_200 - 750)
    }

    @Test func approvingPendingExpensePostsItAndChargesBudget() throws {
        let store = FinanceOperatingStore()
        let pending = try #require(store.pendingTransactions.first { $0.merchant == "Notion" })
        let accountBalance = try balance(pending.accountID, in: store)
        let toolsSpent = try budgetSpent("Tools", in: store)

        store.approvePending(pending.id)

        #expect(!store.pendingTransactions.contains { $0.id == pending.id })
        #expect(store.transactions[0].merchant == "Notion")
        #expect(store.transactions[0].status == "Posted")
        #expect(try balance(pending.accountID, in: store) == accountBalance - 184)
        #expect(try budgetSpent("Tools", in: store) == toolsSpent + 184)
    }

    @Test func deferringKeepsTransactionPending() {
        let store = FinanceOperatingStore()
        let pending = store.pendingTransactions[0]

        store.deferPending(pending.id)

        #expect(store.pendingTransactions[0].status == "Awaiting receipt")
    }

    @Test func recurringBillIsChargedOnlyOnce() throws {
        let store = FinanceOperatingStore()
        let aws = try #require(store.recurringBills.first { $0.name == "AWS" })
        let cardBalance = try balance(aws.accountID, in: store)

        store.payRecurringBill(aws.id)
        store.payRecurringBill(aws.id)

        #expect(try balance(aws.accountID, in: store) == cardBalance - 480)
        #expect(store.totalCreditUsed == 2_160 + 480)
        #expect(store.recurringBills.first { $0.id == aws.id }?.isPaid == true)
    }

    @Test func rebalancingSpendsBufferInStepsOfOneHundredFifty() {
        let store = FinanceOperatingStore()
        let budget = store.budgets[0]

        store.rebalanceBudget(budget.id)
        #expect(store.budgets[0].limit == budget.limit + 150)
        #expect(store.budgetBuffer == 500)

        store.budgetBuffer = 149
        store.rebalanceBudget(budget.id)
        #expect(store.budgets[0].limit == budget.limit + 150)
    }

    @Test func manualIncomeIncreasesBalanceWithoutTouchingBudgets() throws {
        let store = FinanceOperatingStore()
        let budgets = store.budgets.map(\.spent)
        store.composer = FinanceTransactionComposer(merchant: " Client A ", amountText: "250", type: .income)

        store.submitManualTransaction()

        #expect(try balance(store.operatingAccountID, in: store) == 18_420 + 250)
        #expect(store.transactions[0].merchant == "Client A")
        #expect(store.transactions[0].note == "Manual operator entry.")
        #expect(store.budgets.map(\.spent) == budgets)
        #expect(store.composer.merchant.isEmpty)
    }

    @Test(arguments: ["", "abc", "0", "-25"])
    func manualTransactionRejectsInvalidAmounts(_ amountText: String) {
        let store = FinanceOperatingStore()
        let transactions = store.transactions.count
        store.composer = FinanceTransactionComposer(merchant: "Vendor", amountText: amountText)

        store.submitManualTransaction()

        #expect(store.transactions.count == transactions)
    }

    @Test func manualTransactionRequiresMerchant() {
        let store = FinanceOperatingStore()
        let transactions = store.transactions.count
        store.composer = FinanceTransactionComposer(merchant: "   ", amountText: "40")

        store.submitManualTransaction()

        #expect(store.transactions.count == transactions)
    }
}
