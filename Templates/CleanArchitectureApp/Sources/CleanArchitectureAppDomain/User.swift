import Foundation

/// A member of the directory. The domain model knows nothing about JSON, storage or SwiftUI.
public struct User: Identifiable, Hashable, Sendable {
    public let id: UUID
    public var name: String
    public var email: String
    public var role: UserRole
    public var isActive: Bool
    public let joinedAt: Date

    public init(id: UUID, name: String, email: String, role: UserRole, isActive: Bool, joinedAt: Date) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
        self.isActive = isActive
        self.joinedAt = joinedAt
    }

    /// An inactive account keeps its role but loses every permission.
    public func can(_ permission: Permission) -> Bool {
        isActive && role.permissions.contains(permission)
    }

    /// Whether this user may edit the name and email of `other`.
    public func canEditProfile(of other: User) -> Bool {
        other.id == id ? can(.editOwnProfile) : can(.manageUsers)
    }
}

/// Roles in increasing order of rank.
public enum UserRole: String, CaseIterable, Comparable, Sendable {
    case member
    case moderator
    case admin

    public var permissions: Set<Permission> {
        switch self {
        case .member: [.editOwnProfile]
        case .moderator: [.editOwnProfile, .viewInactiveUsers]
        case .admin: Set(Permission.allCases)
        }
    }

    public static func < (lhs: UserRole, rhs: UserRole) -> Bool {
        lhs.rank < rhs.rank
    }

    private var rank: Int {
        switch self {
        case .member: 0
        case .moderator: 1
        case .admin: 2
        }
    }
}

public enum Permission: String, CaseIterable, Sendable {
    case editOwnProfile
    case viewInactiveUsers
    case manageUsers
}
