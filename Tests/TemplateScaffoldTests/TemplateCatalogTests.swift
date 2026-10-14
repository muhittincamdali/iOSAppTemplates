import Foundation
import Testing
@testable import TemplateScaffold

@Suite("TemplateCatalog")
struct TemplateCatalogTests {
    @Test func identifiersAndDirectoriesAreUnique() {
        #expect(Set(TemplateCatalog.all.map(\.id)).count == TemplateCatalog.all.count)
        #expect(Set(TemplateCatalog.all.map(\.directoryName)).count == TemplateCatalog.all.count)
    }

    @Test func catalogMatchesTemplatesDirectory() throws {
        let onDisk = try FileManager.default
            .contentsOfDirectory(atPath: TestSupport.templatesDirectory.path)
            .filter { !$0.hasPrefix(".") }
        #expect(Set(onDisk) == Set(TemplateCatalog.all.map(\.directoryName)))
    }

    @Test(arguments: TemplateCatalog.all)
    func listedTabsExistInTemplateSource(_ template: TemplateDescriptor) throws {
        let source = try TestSupport.read(
            "Templates/\(template.directoryName)/Sources/\(template.directoryName)/\(template.directoryName).swift",
            in: TestSupport.repositoryRoot
        )
        for tab in template.tabs {
            #expect(source.contains("Text(\"\(tab)\")"), "\(template.directoryName) has no tab labelled \(tab)")
        }
    }

    @Test func lookupAcceptsIdentifierOrDirectoryNameInAnyCase() {
        #expect(TemplateCatalog.template(named: "ecommerce")?.directoryName == "EcommerceApp")
        #expect(TemplateCatalog.template(named: "EcommerceApp")?.id == "ecommerce")
        #expect(TemplateCatalog.template(named: "ECOMMERCEAPP")?.id == "ecommerce")
        #expect(TemplateCatalog.template(named: "Travel")?.directoryName == "TravelPlannerApp")
    }

    @Test func lookupOfUnknownNameReturnsNil() {
        #expect(TemplateCatalog.template(named: "") == nil)
        #expect(TemplateCatalog.template(named: "banking") == nil)
    }
}
