import XCTest
@testable import MarketplaceApp

final class MarketplaceAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(MarketplaceQuickAction.defaultActions.count, 3)
    }
}
