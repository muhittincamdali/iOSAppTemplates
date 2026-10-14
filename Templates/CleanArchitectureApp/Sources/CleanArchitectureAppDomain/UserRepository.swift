import Foundation

/// Where users come from. The Data layer implements it; the domain only depends on this protocol.
public protocol UserRepository: Sendable {
    /// The full directory, from the server or, when the server cannot be reached, from the
    /// last copy saved on the device.
    func users() async throws(DirectoryError) -> DirectorySnapshot
    /// Saves `user` on the server and returns the stored version.
    func save(_ user: User) async throws(DirectoryError) -> User
}

public struct DirectorySnapshot: Equatable, Sendable {
    public let users: [User]
    public let origin: DataOrigin

    public init(users: [User], origin: DataOrigin) {
        self.users = users
        self.origin = origin
    }
}

public enum DataOrigin: Equatable, Sendable {
    /// Fetched from the server just now.
    case server
    /// Read from the device because the server could not be reached.
    case cache(savedAt: Date)
}

/// Every failure the domain distinguishes. The Data layer maps transport errors onto these.
public enum DirectoryError: Error, Equatable, Sendable {
    /// No connection, and no saved copy to fall back to.
    case offline
    /// The server rejected the credentials.
    case unauthorized
    /// The user does not exist on the server.
    case notFound
    /// Another account already uses the email address.
    case emailAlreadyInUse
    /// The server answered with a status code the app does not handle.
    case server(statusCode: Int)
    /// The response could not be read.
    case invalidResponse
    /// The acting user lacks the permission.
    case permissionDenied(Permission)
    /// The edited profile breaks one or more rules.
    case invalid([ValidationIssue])
    /// The change would leave the directory without an active admin.
    case lastActiveAdmin
}
