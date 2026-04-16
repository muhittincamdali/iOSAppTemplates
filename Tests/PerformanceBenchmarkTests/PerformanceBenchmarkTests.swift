import XCTest
@testable import iOSAppTemplates

@MainActor
final class PerformanceBenchmarkTests: XCTestCase {
    func testTemplateLoadingPerformance() {
        let manager = TemplateManager.shared

        measure {
            manager.loadTemplates()
        }

        XCTAssertFalse(manager.availableTemplates.isEmpty)
    }

    func testTemplateSearchPerformance() {
        let manager = TemplateManager.shared
        manager.loadTemplates()

        measure {
            _ = manager.searchTemplates(query: "social")
        }
    }
}
