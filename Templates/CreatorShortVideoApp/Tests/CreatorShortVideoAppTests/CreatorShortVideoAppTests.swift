import XCTest
@testable import CreatorShortVideoApp

final class CreatorShortVideoAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(CreatorShortVideoQuickAction.defaultActions.count, 3)
    }
}
