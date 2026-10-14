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
        let files = try Self.copyableFiles(in: source).map { path in
            TemplateFile(path: path, data: try Data(contentsOf: source.appendingPathComponent(path)))
        }
        let conflicts = Self.nameConflicts(in: files, renamer: renamer)
        guard conflicts.isEmpty else {
            throw ScaffoldError.nameConflict(name.rawValue, conflicts)
        }

        try fileManager.createDirectory(at: destination, withIntermediateDirectories: true)
        do {
            var written: [String] = []
            for file in files {
                let target = renamer.renamePath(file.path)
                try write(file, to: destination.appendingPathComponent(target), renamer: renamer)
                written.append(target)
            }
            return ScaffoldResult(projectDirectory: destination, files: written.sorted())
        } catch {
            try? fileManager.removeItem(at: destination)
            throw error
        }
    }

    /// Names the rename would turn into a name the template already uses for something else.
    ///
    /// Renaming `EcommerceApp` to `CommerceStore` would give the module the name of the
    /// existing `CommerceStore` class, and `EcommerceApp.swift` would overwrite
    /// `CommerceStore.swift`. Only file and folder names and names declared in Swift files
    /// count as taken; words in strings and comments do not. Paths are also compared
    /// ignoring case, because the default macOS file system treats `Models.swift` and
    /// `models.swift` as the same file.
    static func nameConflicts(in files: [TemplateFile], renamer: IdentifierRenamer) -> [String] {
        var allNames = Set<String>()
        var takenNames = Set<String>()
        for file in files {
            let pathNames = IdentifierRenamer.identifiers(in: file.path)
            allNames.formUnion(pathNames)
            takenNames.formUnion(pathNames)
            guard let text = file.text else { continue }
            allNames.formUnion(IdentifierRenamer.identifiers(in: text))
            if file.path.hasSuffix(".swift") {
                takenNames.formUnion(declaredNames(in: text))
            }
        }
        let renamed = Set(allNames.compactMap { name -> String? in
            let result = renamer.rename(name)
            return result == name ? nil : result
        })
        var conflicts = renamed.intersection(takenNames.filter { renamer.rename($0) == $0 })

        let targets = Dictionary(grouping: files.map { renamer.renamePath($0.path) }, by: { $0.lowercased() })
        for paths in targets.values where paths.count > 1 {
            conflicts.formUnion(paths)
        }
        return conflicts.sorted()
    }

    /// Names introduced by declarations such as `final class CommerceStore` or `case shipped`.
    static func declaredNames(in source: String) -> Set<String> {
        let pattern = /\b(?:class|struct|enum|protocol|actor|typealias|func|var|let|case)\s+`?([A-Za-z_][A-Za-z0-9_]*)/
        return Set(source.matches(of: pattern).map { String($0.output.1) })
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

    private func write(_ file: TemplateFile, to destination: URL, renamer: IdentifierRenamer) throws {
        try FileManager.default.createDirectory(
            at: destination.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        guard let text = file.text else {
            try file.data.write(to: destination)
            return
        }
        try Data(renamer.rename(text).utf8).write(to: destination)
    }
}

/// A template file read into memory, so names can be checked before anything is written.
struct TemplateFile: Sendable {
    let path: String
    let data: Data

    /// The contents as UTF-8 text, or nil for binary files, which are copied byte for byte.
    var text: String? { String(data: data, encoding: .utf8) }
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
    /// The project name would collide with names the template already uses.
    case nameConflict(String, [String])

    public var description: String {
        switch self {
        case .templateNotFound(let url):
            return "No template package found at \(url.path)."
        case .destinationExists(let url):
            return "\(url.path) already exists. Choose another name or output directory."
        case .unreadable(let url):
            return "Could not read \(url.path)."
        case let .nameConflict(name, names):
            return "\(name) cannot be used with this template: renaming would produce names it already has "
                + "(\(names.joined(separator: ", "))). Choose another name."
        }
    }
}
