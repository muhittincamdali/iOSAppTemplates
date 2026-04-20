import XCTest
@testable import BookingReservationsApp

final class BookingReservationsAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(BookingReservationsQuickAction.defaultActions.count, 3)
    }
}
