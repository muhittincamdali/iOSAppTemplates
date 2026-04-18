import XCTest
@testable import FoodDeliveryApp

final class FoodDeliveryAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(FoodDeliveryQuickAction.defaultActions.count, 3)
    }
}
