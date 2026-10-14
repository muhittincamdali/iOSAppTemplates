import Foundation
import Testing
import TemplateScaffold

// Keep this function identical to the snippet in README.md and TemplateScaffold.docc,
// so the documented example is compiled and executed by the test suite.
func makeShop(templates: URL, output: URL) throws -> ScaffoldResult {
    guard let template = TemplateCatalog.template(named: "ecommerce") else {
        throw CocoaError(.fileNoSuchFile)
    }
    let name = try ProjectName("MyShop")
    return try Scaffolder(templatesDirectory: templates).scaffold(template, as: name, in: output)
}

@Suite("Documentation snippets")
struct DocumentationSnippetTests {
    @Test func libraryExampleCreatesTheProject() throws {
        try TestSupport.withTemporaryDirectory { output in
            let result = try makeShop(templates: TestSupport.templatesDirectory, output: output)

            #expect(result.projectDirectory.lastPathComponent == "MyShop")
            #expect(result.files.contains("Sources/MyShop/MyShop.swift"))
        }
    }

    @Test func snippetInDocsMatchesThisFile() throws {
        let snippet = try TestSupport.read("Tests/TemplateScaffoldTests/DocumentationSnippetTests.swift", in: TestSupport.repositoryRoot)
            .components(separatedBy: "func makeShop")[1]
            .components(separatedBy: "\n}\n")[0]
        for document in ["README.md", "Sources/TemplateScaffold/TemplateScaffold.docc/TemplateScaffold.md"] {
            let text = try TestSupport.read(document, in: TestSupport.repositoryRoot)
            #expect(text.contains("func makeShop" + snippet + "\n}"), "\(document) is out of date")
        }
    }

    @Test func quickStartInDocsMatchesTheExampleApp() throws {
        let example = try TestSupport.read("Examples/QuickStart/QuickStart/QuickStartApp.swift", in: TestSupport.repositoryRoot)
        for document in ["Sources/TemplateScaffold/TemplateScaffold.docc/AddingATemplateToAnApp.md"] {
            let text = try TestSupport.read(document, in: TestSupport.repositoryRoot)
            #expect(text.contains("```swift\n" + example + "```"), "\(document) is out of date")
        }
    }
}
