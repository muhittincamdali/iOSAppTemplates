import CleanArchitectureAppDomain
import Foundation

/// A user with a predictable id (`…0000NN`) and join date (`NN` days after 2025-01-01).
func makeUser(
    _ number: UInt8,
    _ name: String = "User",
    role: UserRole = .member,
    isActive: Bool = true,
    email: String? = nil
) -> User {
    User(
        id: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, number)),
        name: name,
        email: email ?? "user\(number)@example.com",
        role: role,
        isActive: isActive,
        joinedAt: Date(timeIntervalSince1970: 1_735_689_600 + Double(number) * 86_400)
    )
}

/// An in-memory repository that records what the use cases save.
actor RecordingRepository: UserRepository {
    private(set) var stored: [User]
    private(set) var saved: [User] = []
    private let origin: DataOrigin
    private let failure: DirectoryError?

    init(_ users: [User], origin: DataOrigin = .server, failure: DirectoryError? = nil) {
        self.stored = users
        self.origin = origin
        self.failure = failure
    }

    func users() async throws(DirectoryError) -> DirectorySnapshot {
        if let failure { throw failure }
        return DirectorySnapshot(users: stored, origin: origin)
    }

    func save(_ user: User) async throws(DirectoryError) -> User {
        if let failure { throw failure }
        saved.append(user)
        if let index = stored.firstIndex(where: { $0.id == user.id }) {
            stored[index] = user
        }
        return user
    }
}
