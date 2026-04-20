import XCTest
@testable import MusicPodcastApp

final class MusicPodcastAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(MusicPodcastQuickAction.defaultActions.count, 3)
    }
}
