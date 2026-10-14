import ArgumentParser
import Foundation
import TemplateScaffold

@main
struct CreateIOSApp: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "create-ios-app",
        abstract: "Create a SwiftUI app package from one of the iOSAppTemplates starters.",
        version: "3.0.0",
        subcommands: [New.self, List.self],
        defaultSubcommand: New.self
    )
}

struct TemplateOptions: ParsableArguments {
    @Option(help: "Path to the Templates directory. Defaults to ./Templates or the checkout this tool was built from.")
    var templatesDir: String?

    func resolveTemplatesDirectory() throws -> URL {
        guard let directory = TemplateLocator.templatesDirectory(explicitPath: templatesDir) else {
            throw ValidationError("Could not find the Templates directory. Pass --templates-dir <path>.")
        }
        return directory
    }
}

extension CreateIOSApp {
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "List the available templates.")

        func run() {
            let idWidth = TemplateCatalog.all.map(\.id.count).max() ?? 0
            for template in TemplateCatalog.all {
                let paddedID = template.id.padding(toLength: idWidth, withPad: " ", startingAt: 0)
                print("\(paddedID)  \(template.displayName) (\(template.tabs.joined(separator: ", ")))")
            }
        }
    }

    struct New: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Create a new project from a template.")

        @Argument(help: "Name of the new package and app, for example MyShop.")
        var name: String

        @Option(name: .shortAndLong, help: "Template identifier. Run `create-ios-app list` to see them.")
        var template: String

        @Option(name: .shortAndLong, help: "Directory in which the project folder is created.")
        var output: String = "."

        @OptionGroup var templateOptions: TemplateOptions

        func run() throws {
            guard let descriptor = TemplateCatalog.template(named: template) else {
                throw ValidationError("Unknown template '\(template)'. Run `create-ios-app list`.")
            }

            let projectName: ProjectName
            do {
                projectName = try ProjectName(name)
            } catch {
                throw ValidationError(error.description)
            }

            let scaffolder = Scaffolder(templatesDirectory: try templateOptions.resolveTemplatesDirectory())
            let outputDirectory = URL(fileURLWithPath: output).standardizedFileURL

            do {
                let result = try scaffolder.scaffold(descriptor, as: projectName, in: outputDirectory)
                print("Created \(result.projectDirectory.path) from \(descriptor.displayName) (\(result.files.count) files).")
                print("""

                Next steps:
                  cd \(result.projectDirectory.path)
                  xcodebuild test -scheme \(projectName) -destination 'platform=iOS Simulator,name=iPhone 17'
                  cd App && xcodegen generate && open \(projectName).xcodeproj

                Any simulator from `xcrun simctl list devices available` works in place of iPhone 17.
                """)
            } catch let error as ScaffoldError {
                throw ValidationError(error.description)
            }
        }
    }
}
