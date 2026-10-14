import Foundation

/// Copies a template into a new directory and renames it.
public struct Scaffolder: Sendable {
    /// Directory and file names that are never copied.
    static let skippedNames: Set<String> = [".build", ".swiftpm", ".DS_Store", "xcuserdata", "DerivedData"]
    static let skippedExtensions: Set<String> = ["xcodeproj", "xcworkspace"]

    public let templatesDirectory: URL

    public init(templatesDirectory: URL) {
        self.templatesDirectory = templatesDirectory
    }

    /// Creates `<outputDirectory>/<name>` from `template`.
    ///
    /// Every occurrence of the template's directory name that starts an identifier is
    /// replaced with `name`, both in file contents and in file and folder names.
    /// If anything fails after the destination was created, the destination is removed.
    @discardableResult
    public func scaffold(
        _ template: TemplateDescriptor,
        as name: ProjectName,
        in outputDirectory: URL
    ) throws -> ScaffoldResult {
        let fileManager = FileManager.default
        let source = templatesDirectory.appendingPathComponent(template.directoryName, isDirectory: true)
        let destination = outputDirectory.appendingPathComponent(name.rawValue, isDirectory: true)

        guard fileManager.fileExists(atPath: source.appendingPathComponent("Package.swift").path) else {
            throw ScaffoldError.templateNotFound(source)
        }
        guard !fileManager.fileExists(atPath: destination.path) else {
            throw ScaffoldError.destinationExists(destination)
        }

        let renamer = IdentifierRenamer(from: template.directoryName, to: name.rawValue)
        let relativePaths = try Self.copyableFiles(in: source)

        try fileManager.createDirectory(at: destination, withIntermediateDirectories: true)
        do {
            var written: [String] = []
            for relativePath in relativePaths {
                let target = renamer.renamePath(relativePath)
                try copyFile(
                    from: source.appendingPathComponent(relativePath),
                    to: destination.appendingPathComponent(target),
                    renamer: renamer
                )
                written.append(target)
            }
            return ScaffoldResult(projectDirectory: destination, files: written.sorted())
        } catch {
            try? fileManager.removeItem(at: destination)
            throw error
        }
    }

    /// Relative paths of the regular files that make up a template, sorted.
    static func copyableFiles(in directory: URL) throws -> [String] {
        let base = directory.standardizedFileURL.resolvingSymlinksInPath().path
        guard let enumerator = FileManager.default.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isRegularFileKey, .isDirectoryKey]
        ) else {
            throw ScaffoldError.unreadable(directory)
        }

        var paths: [String] = []
        for case let url as URL in enumerator {
            if skippedNames.contains(url.lastPathComponent) || skippedExtensions.contains(url.pathExtension) {
                enumerator.skipDescendants()
                continue
            }
            guard try url.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile == true else { continue }
            let fullPath = url.standardizedFileURL.resolvingSymlinksInPath().path
            paths.append(String(fullPath.dropFirst(base.count + 1)))
        }
        return paths.sorted()
    }

    private func copyFile(from source: URL, to destination: URL, renamer: IdentifierRenamer) throws {
        try FileManager.default.createDirectory(
            at: destination.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        let data = try Data(contentsOf: source)
        guard let text = String(data: data, encoding: .utf8) else {
            try data.write(to: destination)
            return
        }
        try Data(renamer.rename(text).utf8).write(to: destination)
    }
}

public struct ScaffoldResult: Equatable, Sendable {
    public let projectDirectory: URL
    /// Paths of the created files, relative to `projectDirectory`.
    public let files: [String]
}

public enum ScaffoldError: Error, Equatable, CustomStringConvertible {
    case templateNotFound(URL)
    case destinationExists(URL)
    case unreadable(URL)

    public var description: String {
        switch self {
        case .templateNotFound(let url):
            return "No template package found at \(url.path)."
        case .destinationExists(let url):
            return "\(url.path) already exists. Choose another name or output directory."
        case .unreadable(let url):
            return "Could not read \(url.path)."
        }
    }
}
