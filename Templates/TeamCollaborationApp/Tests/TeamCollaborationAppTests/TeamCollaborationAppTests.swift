import XCTest
@testable import TeamCollaborationApp

final class TeamCollaborationAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(TeamCollaborationQuickAction.defaultActions.count, 3)
    }
}
