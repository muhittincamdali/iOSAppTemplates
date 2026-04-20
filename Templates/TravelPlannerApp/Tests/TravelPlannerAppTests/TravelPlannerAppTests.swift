import XCTest
@testable import TravelPlannerApp

final class TravelPlannerAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(TravelPlannerQuickAction.defaultActions.count, 3)
    }
}
