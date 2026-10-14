import Foundation

/// Search text, filter and sort order for the directory list.
public struct UserQuery: Hashable, Sendable {
    public var searchText: String
    public var filter: UserFilter
    public var sortOrder: UserSortOrder

    public init(searchText: String = "", filter: UserFilter = .all, sortOrder: UserSortOrder = .name) {
        self.searchText = searchText
        self.filter = filter
        self.sortOrder = sortOrder
    }

    /// The users that match, in the requested order.
    ///
    /// Search ignores case and diacritics and matches the name or the email address.
    /// Ties are broken by id, so the order is the same on every call.
    public func apply(to users: [User]) -> [User] {
        let term = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return users
            .filter { filter.includes($0) && (term.isEmpty || Self.matches($0, term: term)) }
            .sorted { lhs, rhs in
                let order = sortOrder.compare(lhs, rhs)
                return order == .orderedSame ? lhs.id.uuidString < rhs.id.uuidString : order == .orderedAscending
            }
    }

    private static func matches(_ user: User, term: String) -> Bool {
        let options: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
        return user.name.range(of: term, options: options) != nil
            || user.email.range(of: term, options: options) != nil
    }
}

public enum UserFilter: Hashable, Sendable {
    case all
    case active
    case inactive
    case role(UserRole)

    public static let allCases: [UserFilter] = [.all, .active, .inactive] + UserRole.allCases.map(UserFilter.role)

    func includes(_ user: User) -> Bool {
        switch self {
        case .all: true
        case .active: user.isActive
        case .inactive: !user.isActive
        case .role(let role): user.role == role
        }
    }
}

public enum UserSortOrder: String, CaseIterable, Sendable {
    /// Alphabetical, using the same rules as the Finder.
    case name
    /// Highest role first, then by name.
    case role
    /// Most recently joined first.
    case recentlyJoined

    func compare(_ lhs: User, _ rhs: User) -> ComparisonResult {
        switch self {
        case .name:
            return lhs.name.localizedStandardCompare(rhs.name)
        case .role:
            if lhs.role != rhs.role { return lhs.role > rhs.role ? .orderedAscending : .orderedDescending }
            return lhs.name.localizedStandardCompare(rhs.name)
        case .recentlyJoined:
            if lhs.joinedAt == rhs.joinedAt { return .orderedSame }
            return lhs.joinedAt > rhs.joinedAt ? .orderedAscending : .orderedDescending
        }
    }
}
