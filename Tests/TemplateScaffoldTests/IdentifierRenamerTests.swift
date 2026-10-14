import Testing
@testable import TemplateScaffold

@Suite("IdentifierRenamer")
struct IdentifierRenamerTests {
    let renamer = IdentifierRenamer(from: "EcommerceApp", to: "MyShop")

    @Test func renamesNameAndSuffixedModules() {
        #expect(renamer.rename("EcommerceApp") == "MyShop")
        #expect(renamer.rename("EcommerceAppShell.main()") == "MyShopShell.main()")
        #expect(renamer.rename("@testable import EcommerceApp\nEcommerceAppTests") == "@testable import MyShop\nMyShopTests")
    }

    @Test func renamesAfterPunctuationAndQuotes() {
        let manifest = #".testTarget(name: "EcommerceAppTests", dependencies: ["EcommerceApp"])"#
        #expect(renamer.rename(manifest) == #".testTarget(name: "MyShopTests", dependencies: ["MyShop"])"#)
        #expect(renamer.rename("com.example.EcommerceApp") == "com.example.MyShop")
    }

    @Test func leavesLongerIdentifiersAlone() {
        #expect(renamer.rename("MyEcommerceApp") == "MyEcommerceApp")
        #expect(renamer.rename("_EcommerceApp") == "_EcommerceApp")
        #expect(renamer.rename("Ecommerce2EcommerceApp") == "Ecommerce2EcommerceApp")
    }

    @Test func textWithoutMatchesIsUnchanged() {
        let text = "struct CommerceStore {}\n// Ecommerce app"
        #expect(renamer.rename(text) == text)
        #expect(renamer.rename("") == "")
    }

    @Test func renamesEveryOccurrenceIncludingAdjacentOnes() {
        #expect(renamer.rename("EcommerceApp EcommerceApp.EcommerceApp") == "MyShop MyShop.MyShop")
    }

    @Test func handlesMultiByteCharactersAroundMatches() {
        #expect(renamer.rename("é EcommerceApp — ✓") == "é MyShop — ✓")
        #expect(renamer.rename("éEcommerceApp") == "éEcommerceApp")
    }

    @Test func renamesEachPathComponent() {
        #expect(
            renamer.renamePath("Tests/EcommerceAppTests/EcommerceAppTests.swift")
                == "Tests/MyShopTests/MyShopTests.swift"
        )
        #expect(renamer.renamePath("App/project.yml") == "App/project.yml")
    }
}
