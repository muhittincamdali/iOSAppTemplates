import XCTest
@testable import NotesKnowledgeApp

final class NotesKnowledgeAppTests: XCTestCase {
    func testQuickActionsSurfaceLoads() {
        XCTAssertEqual(NotesKnowledgeQuickAction.defaultActions.count, 3)
    }
}
