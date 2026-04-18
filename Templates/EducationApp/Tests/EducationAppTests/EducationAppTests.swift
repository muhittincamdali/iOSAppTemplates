import XCTest
@testable import EducationApp

final class EducationAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(EducationQuickAction.defaultActions.count, 3)
    }
}
