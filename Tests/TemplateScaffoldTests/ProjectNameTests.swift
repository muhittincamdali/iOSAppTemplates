import Testing
@testable import TemplateScaffold

@Suite("ProjectName")
struct ProjectNameTests {
    @Test(arguments: ["MyShop", "Shop2", "my_shop", "A", "TravelPlannerApp"])
    func acceptsSwiftIdentifiers(_ candidate: String) throws {
        #expect(try ProjectName(candidate).rawValue == candidate)
    }

    @Test func trimsSurroundingWhitespace() throws {
        #expect(try ProjectName("  MyShop\n").rawValue == "MyShop")
    }

    @Test(arguments: ["", "   ", "\n"])
    func rejectsEmptyNames(_ candidate: String) {
        #expect(throws: ProjectNameError.empty) { try ProjectName(candidate) }
    }

    @Test func rejectsLeadingDigitOrUnderscore() {
        #expect(throws: ProjectNameError.invalidFirstCharacter("2")) { try ProjectName("2Shop") }
        #expect(throws: ProjectNameError.invalidFirstCharacter("_")) { try ProjectName("_Shop") }
    }

    @Test func rejectsCharactersOutsideIdentifiers() {
        #expect(throws: ProjectNameError.invalidCharacter("-")) { try ProjectName("My-Shop") }
        #expect(throws: ProjectNameError.invalidCharacter(" ")) { try ProjectName("My Shop") }
        #expect(throws: ProjectNameError.invalidCharacter("ş")) { try ProjectName("Alisveriş") }
    }

    @Test func rejectsNonASCIILeadingLetter() {
        #expect(throws: ProjectNameError.invalidFirstCharacter("É")) { try ProjectName("École") }
    }

    @Test(arguments: ["App", "View", "SwiftUI", "Foundation", "class", "self"])
    func rejectsReservedNames(_ candidate: String) {
        #expect(throws: ProjectNameError.reserved(candidate)) { try ProjectName(candidate) }
    }

    @Test(arguments: ["guard", "if", "for", "case", "switch", "static", "public", "while", "try", "Any"])
    func rejectsKeywordsThatCannotFollowImport(_ candidate: String) {
        #expect(throws: ProjectNameError.reserved(candidate)) { try ProjectName(candidate) }
    }

    @Test(arguments: ProjectName.swiftKeywords.sorted())
    func rejectsEverySwiftKeyword(_ keyword: String) {
        #expect(throws: ProjectNameError.reserved(keyword)) { try ProjectName(keyword) }
    }

    @Test(arguments: ["Guard", "Public", "open", "async", "some"])
    func acceptsContextualKeywordsAndCapitalizedKeywords(_ candidate: String) throws {
        #expect(try ProjectName(candidate).rawValue == candidate)
    }

    @Test func enforcesMaximumLength() throws {
        let longest = "A" + String(repeating: "b", count: ProjectName.maximumLength - 1)
        #expect(try ProjectName(longest).rawValue.count == ProjectName.maximumLength)
        #expect(throws: ProjectNameError.tooLong(maximum: ProjectName.maximumLength)) {
            try ProjectName(longest + "c")
        }
    }

    @Test func errorsDescribeTheProblem() {
        #expect(ProjectNameError.invalidCharacter("-").description.contains("'-'"))
        #expect(ProjectNameError.reserved("App").description.contains("'App'"))
    }
}
