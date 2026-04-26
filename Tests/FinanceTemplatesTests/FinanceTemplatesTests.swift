import XCTest
@testable import FinanceTemplates

@MainActor
final class FinanceTemplatesTests: XCTestCase {
    func testFinanceTemplatesInitialization() {
        XCTAssertEqual(FinanceTemplates.version, "2.1.0")
    }

    func testTransactionInitialization() {
        let transaction = PersonalFinanceAppTemplate.Transaction(
            id: "txn-1",
            amount: 149.99,
            type: .expense,
            category: .shopping,
            description: "Headphones",
            accountId: "account-1",
            tags: ["tech", "accessory"]
        )

        XCTAssertEqual(transaction.id, "txn-1")
        XCTAssertEqual(transaction.amount, 149.99)
        XCTAssertEqual(transaction.type, .expense)
        XCTAssertEqual(transaction.category, .shopping)
        XCTAssertEqual(transaction.accountId, "account-1")
        XCTAssertEqual(transaction.tags, ["tech", "accessory"])
    }

    func testBudgetCalculations() {
        let budget = PersonalFinanceAppTemplate.Budget(
            name: "Monthly Budget",
            amount: 5000,
            spent: 3250,
            period: .monthly,
            startDate: Date(),
            endDate: Date().addingTimeInterval(30 * 24 * 60 * 60)
        )

        XCTAssertEqual(budget.remaining, 1750)
        XCTAssertEqual(budget.percentageSpent, 65, accuracy: 0.001)
        XCTAssertFalse(budget.isOverBudget)
    }

    func testBudgetCategoryCalculations() {
        let category = PersonalFinanceAppTemplate.BudgetCategory(
            name: "Food",
            allocated: 800,
            spent: 520,
            category: .food
        )

        XCTAssertEqual(category.remaining, 280)
        XCTAssertEqual(category.percentageSpent, 65, accuracy: 0.001)
        XCTAssertEqual(category.category, .food)
    }

    func testTransactionTypeProperties() {
        XCTAssertEqual(PersonalFinanceAppTemplate.TransactionType.income.displayName, "Income")
        XCTAssertEqual(PersonalFinanceAppTemplate.TransactionType.income.color, "green")
        XCTAssertEqual(PersonalFinanceAppTemplate.TransactionType.expense.displayName, "Expense")
        XCTAssertEqual(PersonalFinanceAppTemplate.TransactionType.expense.color, "red")
        XCTAssertEqual(PersonalFinanceAppTemplate.TransactionType.transfer.displayName, "Transfer")
        XCTAssertEqual(PersonalFinanceAppTemplate.TransactionType.transfer.color, "blue")
    }

    func testFinanceManagerInitialization() {
        let manager = PersonalFinanceAppTemplate.FinanceManager()

        XCTAssertTrue(manager.accounts.isEmpty)
        XCTAssertTrue(manager.transactions.isEmpty)
        XCTAssertTrue(manager.budgets.isEmpty)
        XCTAssertTrue(manager.goals.isEmpty)
        XCTAssertTrue(manager.investments.isEmpty)
        XCTAssertFalse(manager.isLoading)
    }
}
