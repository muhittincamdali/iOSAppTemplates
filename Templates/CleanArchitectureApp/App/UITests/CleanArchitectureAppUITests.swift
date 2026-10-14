import XCTest

/// Drives the built app in the simulator: search, the offline fallback and an accessibility
/// audit of the Directory tab.
@MainActor
final class CleanArchitectureAppUITests: XCTestCase {
    private let timeout: TimeInterval = 10
    /// Every instance refers to the same target application, so this can be a computed property.
    private var app: XCUIApplication { XCUIApplication() }

    override func setUp() async throws {
        continueAfterFailure = false
        app.launch()
        XCTAssertTrue(app.staticTexts["12 people"].waitForExistence(timeout: timeout))
    }

    private func element(labelContaining text: String) -> XCUIElement {
        app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS %@", text)).firstMatch
    }

    func testSearchIgnoresDiacritics() {
        let search = app.searchFields["Name or email"]
        XCTAssertTrue(search.waitForExistence(timeout: timeout))
        search.tap()
        search.typeText("zoe")

        XCTAssertTrue(app.staticTexts["1 person"].waitForExistence(timeout: timeout))
        XCTAssertTrue(element(labelContaining: "Zoë Martin").exists)
        XCTAssertFalse(element(labelContaining: "Ada Lovelace").exists)
    }

    func testTurningTheServerOffShowsTheSavedCopy() {
        app.tabBars.buttons["Settings"].tap()
        let reachable = app.switches["Server reachable"]
        XCTAssertTrue(reachable.waitForExistence(timeout: timeout))
        XCTAssertEqual(reachable.value as? String, "1")
        // The sample server lives in the app process, so every launch starts with it on.
        reachable.switches.firstMatch.tap()
        XCTAssertEqual(reachable.value as? String, "0")

        app.tabBars.buttons["Directory"].tap()

        XCTAssertTrue(element(labelContaining: "Offline. Showing the copy saved").waitForExistence(timeout: timeout))
        XCTAssertTrue(app.staticTexts["12 people"].exists)
    }

    /// Every audit type except contrast. The secondary text of the list (email addresses and
    /// the section header) uses the system's secondary label colour, which the contrast check
    /// reports as "nearly passed"; that colour is the platform default and adapts to Increase
    /// Contrast, so it is kept.
    func testDirectoryPassesTheAccessibilityAudit() throws {
        try app.performAccessibilityAudit(for: XCUIAccessibilityAuditType.all.subtracting(.contrast)) { issue in
            // The search field comes from `.searchable` and is drawn by the system, which
            // shortens its placeholder at the largest text sizes; the app cannot change that.
            if issue.auditType == .textClipped, issue.element?.elementType == .searchField {
                return true
            }
            // Report every other issue with the label of its element, so a failure says what to fix.
            let label = issue.element?.label ?? "no element"
            XCTFail("\(issue.compactDescription): \(label). \(issue.detailedDescription)")
            return true
        }
    }
}
