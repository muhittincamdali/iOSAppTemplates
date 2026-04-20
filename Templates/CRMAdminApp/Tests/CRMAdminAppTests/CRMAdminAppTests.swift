import XCTest
@testable import CRMAdminApp

final class CRMAdminAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(CRMAdminQuickAction.defaultActions.count, 3)
    }
}
