import CleanArchitectureAppDomain
import Foundation

/// Server first, device copy as a fallback.
///
/// - Reading: a successful fetch replaces the saved copy. When the server cannot be
///   reached or fails with a 5xx status, the saved copy is returned instead, marked with
///   ``DataOrigin/cache(savedAt:)``. Other errors, such as `401`, are passed on, because a
///   stale copy would hide them.
/// - Writing: changes go to the server only; there is no offline queue. A successful save
///   also updates the saved copy, so the change survives a later offline start.
/// - Records with a role this app version does not know are left out.
public struct DefaultUserRepository: UserRepository {
    private let api: UsersAPI
    private let cache: any UserCache
    private let now: @Sendable () -> Date

    public init(api: UsersAPI, cache: any UserCache, now: @escaping @Sendable () -> Date = Date.init) {
        self.api = api
        self.cache = cache
        self.now = now
    }

    public func users() async throws(DirectoryError) -> DirectorySnapshot {
        do {
            let records = try await api.fetchUsers()
            try? await cache.save(CachedDirectory(savedAt: now(), users: records))
            return DirectorySnapshot(users: records.compactMap(\.domainUser), origin: .server)
        } catch {
            guard Self.allowsFallback(error), let saved = await cache.load() else { throw error }
            return DirectorySnapshot(users: saved.users.compactMap(\.domainUser), origin: .cache(savedAt: saved.savedAt))
        }
    }

    public func save(_ user: User) async throws(DirectoryError) -> User {
        let stored = try await api.update(UserDTO(user))
        guard let storedUser = stored.domainUser else { throw .invalidResponse }
        if var saved = await cache.load() {
            if let index = saved.users.firstIndex(where: { $0.id == stored.id }) {
                saved.users[index] = stored
            } else {
                saved.users.append(stored)
            }
            try? await cache.save(saved)
        }
        return storedUser
    }

    static func allowsFallback(_ error: DirectoryError) -> Bool {
        switch error {
        case .offline: true
        case .server(let statusCode): (500..<600).contains(statusCode)
        default: false
        }
    }
}
