import XCTest
@testable import ProductivityApp

final class ProductivityAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(ProductivityQuickAction.defaultActions.count, 3)
    }
}
