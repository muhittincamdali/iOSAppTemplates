import XCTest
@testable import NewsBlogApp

final class NewsBlogAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(NewsBlogQuickAction.defaultActions.count, 3)
    }
}
