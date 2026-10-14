import Foundation

/// Finds the `Templates/` directory of a checkout of this repository.
public enum TemplateLocator {
    /// Searches, in order: `explicitPath`, `./Templates` under `workingDirectory`,
    /// and `Templates/` next to the package that compiled `sourceFile`.
    ///
    /// The last candidate makes `swift run create-ios-app` work from any directory
    /// as long as the binary was built from a checkout.
    public static func templatesDirectory(
        explicitPath: String? = nil,
        workingDirectory: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath),
        sourceFile: String = #filePath
    ) -> URL? {
        if let explicitPath {
            let url = URL(fileURLWithPath: explicitPath, relativeTo: workingDirectory).standardizedFileURL
            return containsTemplates(url) ? url : nil
        }

        // `sourceFile` is Sources/<Target>/<File>.swift; three levels up is the package root.
        let packageRoot = URL(fileURLWithPath: sourceFile)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let candidates = [
            workingDirectory.appendingPathComponent("Templates", isDirectory: true),
            packageRoot.appendingPathComponent("Templates", isDirectory: true)
        ]
        return candidates.first(where: containsTemplates)
    }

    static func containsTemplates(_ directory: URL) -> Bool {
        TemplateCatalog.all.contains { template in
            FileManager.default.fileExists(
                atPath: directory
                    .appendingPathComponent(template.directoryName)
                    .appendingPathComponent("Package.swift").path
            )
        }
    }
}
