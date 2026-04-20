import XCTest
@testable import MessagingApp

final class MessagingAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(MessagingQuickAction.defaultActions.count, 3)
    }
}
