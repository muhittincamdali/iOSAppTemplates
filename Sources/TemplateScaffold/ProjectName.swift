import Foundation

/// A validated name for a new project.
///
/// The name becomes the Swift package name, the module names (`<Name>`, `<Name>UI`,
/// `<Name>Core`) and the prefix of the app's entry type, so it has to be a valid
/// Swift identifier that does not shadow a module or type the templates rely on.
public struct ProjectName: Hashable, Sendable, CustomStringConvertible {
    public static let maximumLength = 64

    /// Names that would collide with Swift keywords or with modules and types the templates import.
    static let reservedNames: Set<String> = [
        "App", "Scene", "View", "SwiftUI", "Foundation", "Combine", "Observation", "UIKit",
        "XCTest", "Testing", "Swift", "Self", "Type", "Protocol", "Any",
        "class", "struct", "enum", "protocol", "extension", "func", "import", "let", "var",
        "init", "deinit", "return", "self", "super", "true", "false", "nil"
    ]

    public let rawValue: String

    public var description: String { rawValue }

    public init(_ candidate: String) throws(ProjectNameError) {
        let name = candidate.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let first = name.first else { throw .empty }
        guard name.count <= Self.maximumLength else { throw .tooLong(maximum: Self.maximumLength) }
        guard first.isASCII, first.isLetter else { throw .invalidFirstCharacter(first) }
        if let invalid = name.first(where: { !($0.isASCII && ($0.isLetter || $0.isNumber || $0 == "_")) }) {
            throw .invalidCharacter(invalid)
        }
        guard !Self.reservedNames.contains(name) else { throw .reserved(name) }

        rawValue = name
    }
}

public enum ProjectNameError: Error, Equatable, CustomStringConvertible {
    case empty
    case tooLong(maximum: Int)
    case invalidFirstCharacter(Character)
    case invalidCharacter(Character)
    case reserved(String)

    public var description: String {
        switch self {
        case .empty:
            return "The project name is empty."
        case .tooLong(let maximum):
            return "The project name is longer than \(maximum) characters."
        case .invalidFirstCharacter(let character):
            return "The project name must start with an ASCII letter, not '\(character)'."
        case .invalidCharacter(let character):
            return "The project name may contain only ASCII letters, digits and underscores; found '\(character)'."
        case .reserved(let name):
            return "'\(name)' is a Swift keyword or clashes with a framework the templates import."
        }
    }
}
