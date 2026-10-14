import Foundation

/// Edited profile values as typed by the user, before they are checked.
public struct ProfileDraft: Hashable, Sendable {
    /// Allowed length of the normalized name, in characters.
    public static let nameLength = 2...60
    /// RFC 5321 limits a forward path to 256 octets including the angle brackets, which
    /// leaves 254 octets (UTF-8 bytes, not characters) for the address.
    public static let maximumEmailLength = 254
    /// RFC 5321 limit for the part before the `@`, in octets.
    public static let maximumEmailLocalPartLength = 64
    /// RFC 1035 limit for one dot-separated domain label, in octets.
    static let maximumDomainLabelLength = 63

    public var name: String
    public var email: String
    public var role: UserRole

    public init(name: String, email: String, role: UserRole) {
        self.name = name
        self.email = email
        self.role = role
    }

    public init(_ user: User) {
        self.init(name: user.name, email: user.email, role: user.role)
    }

    /// The name with surrounding whitespace removed and inner runs of whitespace collapsed.
    public var normalizedName: String {
        name.split(whereSeparator: \.isWhitespace).joined(separator: " ")
    }

    /// The email with surrounding whitespace removed, in lowercase.
    public var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    /// Every rule the draft breaks; empty when the draft can be saved.
    public var issues: [ValidationIssue] {
        var issues: [ValidationIssue] = []
        let name = normalizedName
        let nameLength = name.count
        if name.unicodeScalars.contains(where: Self.isUnsafe) {
            issues.append(.nameInvalidCharacters)
        } else if nameLength < Self.nameLength.lowerBound {
            issues.append(.nameTooShort(minimum: Self.nameLength.lowerBound))
        } else if nameLength > Self.nameLength.upperBound {
            issues.append(.nameTooLong(maximum: Self.nameLength.upperBound))
        }
        let email = normalizedEmail
        if email.isEmpty {
            issues.append(.emailMissing)
        } else if email.utf8.count > Self.maximumEmailLength {
            issues.append(.emailTooLong(maximum: Self.maximumEmailLength))
        } else if !Self.isValidEmail(email) {
            issues.append(.emailInvalid)
        }
        return issues
    }

    /// A deliberately small check: one `@`, a non-empty local part of at most 64 bytes without
    /// spaces, control characters or misplaced dots, and a domain of dot-separated ASCII labels
    /// made of letters, digits and inner hyphens, ending in a top-level domain of at least two
    /// letters. The server stays the final authority.
    static func isValidEmail(_ email: String) -> Bool {
        let parts = email.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2 else { return false }
        let local = parts[0]
        let labels = parts[1].split(separator: ".", omittingEmptySubsequences: false)
        guard !local.isEmpty, local.utf8.count <= maximumEmailLocalPartLength,
              !local.contains(where: \.isWhitespace),
              !local.unicodeScalars.contains(where: isUnsafe),
              !local.hasPrefix("."), !local.hasSuffix("."), !local.contains(".."),
              labels.count >= 2, let topLevel = labels.last,
              topLevel.count >= 2, topLevel.allSatisfy(\.isLetter)
        else { return false }
        return labels.allSatisfy(isValidDomainLabel)
    }

    private static func isValidDomainLabel(_ label: Substring) -> Bool {
        guard let first = label.first, let last = label.last, label.utf8.count <= maximumDomainLabelLength else {
            return false
        }
        return first != "-" && last != "-"
            && label.allSatisfy { $0.isASCII && ($0.isLetter || $0.isNumber || $0 == "-") }
    }

    /// Control characters (such as NUL or escape) and the bidirectional embedding, override
    /// and isolate characters are invisible in the form and can make a stored value read
    /// differently from what was typed. Other format characters, such as the zero-width
    /// non-joiner used in Persian names, stay allowed.
    private static func isUnsafe(_ scalar: Unicode.Scalar) -> Bool {
        scalar.properties.generalCategory == .control
            || (0x202A...0x202E).contains(scalar.value)
            || (0x2066...0x2069).contains(scalar.value)
    }
}

public enum ValidationIssue: Hashable, Sendable {
    case nameInvalidCharacters
    case nameTooShort(minimum: Int)
    case nameTooLong(maximum: Int)
    case emailMissing
    case emailInvalid
    case emailTooLong(maximum: Int)

    public enum Field: Sendable {
        case name
        case email
    }

    public var field: Field {
        switch self {
        case .nameInvalidCharacters, .nameTooShort, .nameTooLong: .name
        case .emailMissing, .emailInvalid, .emailTooLong: .email
        }
    }
}
