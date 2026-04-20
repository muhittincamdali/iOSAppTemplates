import XCTest
@testable import PrivacyVaultApp

final class PrivacyVaultAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(PrivacyVaultQuickAction.defaultActions.count, 3)
    }
}
