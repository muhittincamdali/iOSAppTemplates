import Testing
@testable import TemplateScaffold

@Suite("IdentifierRenamer")
struct IdentifierRenamerTests {
    let renamer = IdentifierRenamer(from: "EcommerceApp", to: "MyShop")

    @Test func renamesNameAndSuffixedModules() {
        #expect(renamer.rename("EcommerceApp") == "MyShop")
        #expect(renamer.rename("import EcommerceAppCore") == "import MyShopCore")
        #expect(renamer.rename("@testable import EcommerceApp\nEcommerceAppTests") == "@testable import MyShop\nMyShopTests")
    }

    @Test func renamesAfterPunctuationAndQuotes() {
        let manifest = #".target(name: "EcommerceAppUI", dependencies: ["EcommerceAppCore"])"#
        #expect(renamer.rename(manifest) == #".target(name: "MyShopUI", dependencies: ["MyShopCore"])"#)
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
            renamer.renamePath("Sources/EcommerceAppCore/EcommerceAppCore.swift")
                == "Sources/MyShopCore/MyShopCore.swift"
        )
        #expect(renamer.renamePath("App/project.yml") == "App/project.yml")
    }
}
