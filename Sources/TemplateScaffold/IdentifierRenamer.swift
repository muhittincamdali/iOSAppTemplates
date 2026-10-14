import Foundation

/// Replaces a template's name prefix with a new project name.
///
/// A match is replaced only when it starts an identifier, that is when the preceding
/// character is not a letter, digit or underscore. Characters after the match are left
/// alone, so `EcommerceApp`, `EcommerceAppCore` and `EcommerceAppTests` all follow the
/// rename while `MyEcommerceApp` does not.
public struct IdentifierRenamer: Sendable {
    public let oldName: String
    public let newName: String

    public init(from oldName: String, to newName: String) {
        precondition(!oldName.isEmpty, "The name being replaced must not be empty.")
        self.oldName = oldName
        self.newName = newName
    }

    public func rename(_ text: String) -> String {
        var result = ""
        result.reserveCapacity(text.utf8.count)
        var cursor = text.startIndex

        for range in text.ranges(of: oldName) {
            result += text[cursor..<range.lowerBound]
            let startsIdentifier = range.lowerBound == text.startIndex
                || !Self.isIdentifierCharacter(text[text.index(before: range.lowerBound)])
            result += startsIdentifier ? newName : String(text[range])
            cursor = range.upperBound
        }

        result += text[cursor...]
        return result
    }

    /// Renames each component of a relative path such as `Sources/EcommerceAppCore/EcommerceAppCore.swift`.
    public func renamePath(_ relativePath: String) -> String {
        relativePath
            .split(separator: "/", omittingEmptySubsequences: false)
            .map { rename(String($0)) }
            .joined(separator: "/")
    }

    private static func isIdentifierCharacter(_ character: Character) -> Bool {
        character.isLetter || character.isNumber || character == "_"
    }
}
