import XCTest
@testable import FinanceApp

final class FinanceAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(FinanceQuickAction.defaultActions.count, 3)
    }
}
