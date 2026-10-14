import CleanArchitectureAppDomain
import Foundation

/// A user as the server sends it. Keys are snake_case and the role is a plain string,
/// so an unknown role from a newer server is a mapping failure, not a decoding crash.
public struct UserDTO: Codable, Equatable, Sendable {
    public var id: UUID
    public var fullName: String
    public var email: String
    public var role: String
    public var isActive: Bool
    public var joinedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case role
        case isActive = "is_active"
        case joinedAt = "joined_at"
    }

    public init(id: UUID, fullName: String, email: String, role: String, isActive: Bool, joinedAt: Date) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.role = role
        self.isActive = isActive
        self.joinedAt = joinedAt
    }

    public init(_ user: User) {
        self.init(
            id: user.id,
            fullName: user.name,
            email: user.email,
            role: user.role.rawValue,
            isActive: user.isActive,
            joinedAt: user.joinedAt
        )
    }

    /// The domain user, or nil when the record has a role this app version does not know.
    public var domainUser: User? {
        guard let role = UserRole(rawValue: role) else { return nil }
        return User(id: id, name: fullName, email: email, role: role, isActive: isActive, joinedAt: joinedAt)
    }
}

/// The body of `GET /v1/users`.
struct UserListDTO: Codable, Sendable {
    var users: [UserDTO]
}

/// The body of an error response, for example `{"error": "email_taken"}`.
struct ErrorDTO: Codable, Sendable {
    var error: String
}

enum JSONCoding {
    static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    static func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }
}
