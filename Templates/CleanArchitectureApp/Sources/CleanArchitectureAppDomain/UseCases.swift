import Foundation

/// Loads the directory as `actor` is allowed to see it.
public struct ListUsersUseCase: Sendable {
    private let repository: any UserRepository

    public init(repository: any UserRepository) {
        self.repository = repository
    }

    /// Users without ``Permission/viewInactiveUsers`` do not see deactivated accounts.
    /// The permission is read from the freshly loaded record of `actorID`, so a role change
    /// made elsewhere takes effect on the next load. A nil or unknown `actorID` sees only
    /// active accounts.
    public func execute(as actorID: User.ID?) async throws(DirectoryError) -> DirectorySnapshot {
        let snapshot = try await repository.users()
        guard snapshot.users.contains(where: { $0.id == actorID && $0.can(.viewInactiveUsers) }) else {
            return DirectorySnapshot(users: snapshot.users.filter(\.isActive), origin: snapshot.origin)
        }
        return snapshot
    }
}

/// Checks and saves a profile change.
public struct UpdateProfileUseCase: Sendable {
    private let repository: any UserRepository

    public init(repository: any UserRepository) {
        self.repository = repository
    }

    /// Validates `draft`, checks that `actor` may make the change, and saves it.
    ///
    /// - Parameter directory: the users the app has loaded, used to make sure the change
    ///   does not remove the last active admin.
    public func execute(
        _ draft: ProfileDraft,
        for target: User,
        by actor: User,
        in directory: [User]
    ) async throws(DirectoryError) -> User {
        guard actor.canEditProfile(of: target) else {
            throw .permissionDenied(actor.id == target.id ? .editOwnProfile : .manageUsers)
        }
        if draft.role != target.role {
            guard actor.can(.manageUsers) else { throw .permissionDenied(.manageUsers) }
            if target.role == .admin, target.isActive, DirectoryRules.activeAdmins(in: directory, excluding: target.id) == 0 {
                throw .lastActiveAdmin
            }
        }
        let issues = draft.issues
        guard issues.isEmpty else { throw .invalid(issues) }

        var updated = target
        updated.name = draft.normalizedName
        updated.email = draft.normalizedEmail
        updated.role = draft.role
        guard updated != target else { return target }
        return try await repository.save(updated)
    }
}

/// Activates or deactivates an account.
public struct SetUserActiveUseCase: Sendable {
    private let repository: any UserRepository

    public init(repository: any UserRepository) {
        self.repository = repository
    }

    public func execute(_ isActive: Bool, for target: User, by actor: User, in directory: [User]) async throws(DirectoryError) -> User {
        guard actor.can(.manageUsers) else { throw .permissionDenied(.manageUsers) }
        guard target.isActive != isActive else { return target }
        if !isActive, target.role == .admin, DirectoryRules.activeAdmins(in: directory, excluding: target.id) == 0 {
            throw .lastActiveAdmin
        }
        var updated = target
        updated.isActive = isActive
        return try await repository.save(updated)
    }
}

/// Counts shown on the Summary tab.
public struct DirectorySummary: Equatable, Sendable {
    public let total: Int
    public let active: Int
    public let countsByRole: [UserRole: Int]
    public let newestMember: User?

    public init(users: [User]) {
        total = users.count
        active = users.count(where: \.isActive)
        countsByRole = Dictionary(grouping: users, by: \.role).mapValues(\.count)
        newestMember = users.max { $0.joinedAt < $1.joinedAt }
    }

    public var inactive: Int { total - active }

    public func count(of role: UserRole) -> Int {
        countsByRole[role] ?? 0
    }
}

enum DirectoryRules {
    static func activeAdmins(in users: [User], excluding id: User.ID) -> Int {
        users.count { $0.id != id && $0.isActive && $0.role == .admin }
    }
}
