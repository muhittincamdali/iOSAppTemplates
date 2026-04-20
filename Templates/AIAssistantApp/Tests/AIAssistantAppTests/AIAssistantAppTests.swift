import XCTest
@testable import AIAssistantApp

final class AIAssistantAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(AIAssistantQuickAction.defaultActions.count, 3)
    }
}
