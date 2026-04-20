import XCTest
@testable import SubscriptionLifestyleApp

final class SubscriptionLifestyleAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(SubscriptionLifestyleQuickAction.defaultActions.count, 3)
    }
}
