import Foundation
import Testing
@testable import TemplateScaffold

@Suite("Scaffolder")
struct ScaffolderTests {
    let fixture = TemplateDescriptor(id: "fixture", directoryName: "FixtureApp", displayName: "Fixture", tabs: [])

    /// Writes a minimal template named FixtureApp into `templates`.
    func makeFixture(in templates: URL) throws {
        let root = templates.appendingPathComponent("FixtureApp")
        try TestSupport.write(#"let package = Package(name: "FixtureApp")"#, to: "Package.swift", in: root)
        try TestSupport.write("public struct FixtureAppShell {}", to: "Sources/FixtureApp/FixtureApp.swift", in: root)
        try TestSupport.write("public enum FixtureAppCoreValue {}", to: "Sources/FixtureAppCore/FixtureAppCore.swift", in: root)
        try TestSupport.write("@testable import FixtureApp", to: "Tests/FixtureAppTests/FixtureAppTests.swift", in: root)
        try TestSupport.write("cache", to: ".build/debug/FixtureApp.o", in: root)
        try TestSupport.write("state", to: ".swiftpm/xcode/FixtureApp.xcworkspace", in: root)
        try TestSupport.write("generated", to: "App/FixtureApp.xcodeproj/project.pbxproj", in: root)
        try TestSupport.write("name: FixtureApp", to: "App/project.yml", in: root)
    }

    @Test func copiesAndRenamesPathsAndContents() throws {
        try TestSupport.withTemporaryDirectory { directory in
            let templates = directory.appendingPathComponent("Templates")
            let output = directory.appendingPathComponent("Output")
            try makeFixture(in: templates)

            let result = try Scaffolder(templatesDirectory: templates)
                .scaffold(fixture, as: try ProjectName("Demo"), in: output)

            #expect(result.projectDirectory.lastPathComponent == "Demo")
            #expect(result.files == [
                "App/project.yml",
                "Package.swift",
                "Sources/Demo/Demo.swift",
                "Sources/DemoCore/DemoCore.swift",
                "Tests/DemoTests/DemoTests.swift"
            ])
            let project = result.projectDirectory
            #expect(try TestSupport.read("Package.swift", in: project) == #"let package = Package(name: "Demo")"#)
            #expect(try TestSupport.read("Sources/Demo/Demo.swift", in: project) == "public struct DemoShell {}")
            #expect(try TestSupport.read("Tests/DemoTests/DemoTests.swift", in: project) == "@testable import Demo")
            #expect(try TestSupport.read("App/project.yml", in: project) == "name: Demo")
        }
    }

    @Test func skipsBuildArtifactsAndGeneratedProjects() throws {
        try TestSupport.withTemporaryDirectory { directory in
            try makeFixture(in: directory)
            let files = try Scaffolder.copyableFiles(in: directory.appendingPathComponent("FixtureApp"))
            #expect(!files.contains { $0.hasPrefix(".build") || $0.hasPrefix(".swiftpm") || $0.contains(".xcodeproj") })
            #expect(files.count == 5)
        }
    }

    @Test func copiesNonUTF8FilesByteForByte() throws {
        try TestSupport.withTemporaryDirectory { directory in
            let templates = directory.appendingPathComponent("Templates")
            try makeFixture(in: templates)
            let bytes = Data([0xFF, 0xFE, 0x00, 0x46, 0x69, 0x78])
            try bytes.write(to: templates.appendingPathComponent("FixtureApp/icon.bin"))

            let result = try Scaffolder(templatesDirectory: templates)
                .scaffold(fixture, as: try ProjectName("Demo"), in: directory)

            #expect(try Data(contentsOf: result.projectDirectory.appendingPathComponent("icon.bin")) == bytes)
        }
    }

    @Test func refusesToOverwriteAnExistingDirectory() throws {
        try TestSupport.withTemporaryDirectory { directory in
            let templates = directory.appendingPathComponent("Templates")
            try makeFixture(in: templates)
            try TestSupport.write("keep me", to: "Demo/notes.txt", in: directory)

            let destination = directory.appendingPathComponent("Demo", isDirectory: true)
            #expect(throws: ScaffoldError.destinationExists(destination)) {
                try Scaffolder(templatesDirectory: templates).scaffold(fixture, as: try ProjectName("Demo"), in: directory)
            }
            #expect(try TestSupport.read("Demo/notes.txt", in: directory) == "keep me")
        }
    }

    @Test func reportsMissingTemplate() throws {
        try TestSupport.withTemporaryDirectory { directory in
            let expected = directory.appendingPathComponent("FixtureApp", isDirectory: true)
            #expect(throws: ScaffoldError.templateNotFound(expected)) {
                try Scaffolder(templatesDirectory: directory).scaffold(fixture, as: try ProjectName("Demo"), in: directory)
            }
            #expect(!FileManager.default.fileExists(atPath: directory.appendingPathComponent("Demo").path))
        }
    }

    @Test(arguments: TemplateCatalog.all)
    func scaffoldsEveryBundledTemplateWithoutLeftoverNames(_ template: TemplateDescriptor) throws {
        try TestSupport.withTemporaryDirectory { directory in
            let result = try Scaffolder(templatesDirectory: TestSupport.templatesDirectory)
                .scaffold(template, as: try ProjectName("Acme"), in: directory)
            let project = result.projectDirectory

            #expect(result.files.contains("Package.swift"))
            #expect(result.files.contains("Sources/Acme/Acme.swift"))
            #expect(result.files.contains("App/AcmeHost.swift"))
            #expect(try TestSupport.read("Package.swift", in: project).contains(#"name: "Acme""#))
            #expect(try TestSupport.read("App/AcmeHost.swift", in: project).contains("AcmeShell.main()"))

            let leftover = IdentifierRenamer(from: template.directoryName, to: "\u{0}")
            for file in result.files {
                let text = try TestSupport.read(file, in: project)
                #expect(!leftover.rename(text).contains("\u{0}"), "\(file) still references \(template.directoryName)")
            }
        }
    }
}

@Suite("TemplateLocator")
struct TemplateLocatorTests {
    @Test func findsTemplatesNextToThePackageSources() {
        #expect(TemplateLocator.templatesDirectory(workingDirectory: URL(fileURLWithPath: "/")) != nil)
    }

    @Test func prefersTemplatesInTheWorkingDirectory() {
        let found = TemplateLocator.templatesDirectory(workingDirectory: TestSupport.repositoryRoot, sourceFile: "/nowhere/Sources/X/Y.swift")
        #expect(found?.standardizedFileURL == TestSupport.templatesDirectory.standardizedFileURL)
    }

    @Test func acceptsAnExplicitPathOnlyWhenItContainsTemplates() throws {
        let explicit = TemplateLocator.templatesDirectory(explicitPath: TestSupport.templatesDirectory.path)
        #expect(explicit != nil)

        try TestSupport.withTemporaryDirectory { empty in
            #expect(TemplateLocator.templatesDirectory(explicitPath: empty.path) == nil)
        }
    }

    @Test func returnsNilWhenNothingIsFound() {
        #expect(TemplateLocator.templatesDirectory(workingDirectory: URL(fileURLWithPath: "/"), sourceFile: "/nowhere/Sources/X/Y.swift") == nil)
    }
}
