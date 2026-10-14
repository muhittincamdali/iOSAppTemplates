import CleanArchitectureAppDomain
import Foundation
import Observation

/// State behind the Directory, Summary and Settings tabs. Views read it and call its
/// methods; all rules live in the use cases it is given.
@MainActor
@Observable
public final class DirectoryModel {
    public enum Phase: Equatable {
        case idle
        case loading
        case loaded
        case failed(DirectoryError)
    }

    public private(set) var phase: Phase = .idle
    /// Every user the acting user may see, in server order.
    public private(set) var users: [User] = []
    public private(set) var origin: DataOrigin?
    public private(set) var actingUserID: User.ID?
    /// The last failed action (activate, deactivate), shown as an alert.
    public var actionError: DirectoryError?
    public var query = UserQuery()

    /// Incremented by every ``load()``, so a slow response cannot overwrite a newer one,
    /// for example after switching the acting user twice in a row.
    private var loadGeneration = 0
    private let listUsers: ListUsersUseCase
    private let updateProfile: UpdateProfileUseCase
    private let setUserActive: SetUserActiveUseCase

    public init(
        listUsers: ListUsersUseCase,
        updateProfile: UpdateProfileUseCase,
        setUserActive: SetUserActiveUseCase,
        actingUserID: User.ID?
    ) {
        self.listUsers = listUsers
        self.updateProfile = updateProfile
        self.setUserActive = setUserActive
        self.actingUserID = actingUserID
    }

    public var visibleUsers: [User] { query.apply(to: users) }
    public var actingUser: User? { users.first { $0.id == actingUserID } }
    public var summary: DirectorySummary { DirectorySummary(users: users) }

    public func user(withID id: User.ID) -> User? {
        users.first { $0.id == id }
    }

    /// Loads the directory. Users already on screen stay visible while it loads and if it fails.
    public func load() async {
        loadGeneration += 1
        let generation = loadGeneration
        if users.isEmpty { phase = .loading }
        do {
            let snapshot = try await listUsers.execute(as: actingUserID)
            guard generation == loadGeneration else { return }
            users = snapshot.users
            origin = snapshot.origin
            phase = .loaded
        } catch {
            guard generation == loadGeneration else { return }
            phase = .failed(error)
        }
    }

    /// Switches the acting user and reloads, because what is visible depends on the role.
    public func signIn(as id: User.ID) async {
        actingUserID = id
        await load()
    }

    public func canChangeActiveState(of user: User) -> Bool {
        guard let actor = actingUser else { return false }
        return actor.can(.manageUsers) && actor.id != user.id
    }

    @discardableResult
    public func setActive(_ isActive: Bool, for user: User) async -> Bool {
        guard let actor = actingUser else { return false }
        do {
            apply(try await setUserActive.execute(isActive, for: user, by: actor, in: users))
            return true
        } catch {
            actionError = error
            return false
        }
    }

    /// An editor for `user`, or nil if the acting user may not edit that profile.
    public func makeEditor(for user: User) -> ProfileEditorModel? {
        guard let actor = actingUser, actor.canEditProfile(of: user) else { return nil }
        return ProfileEditorModel(
            user: user,
            actor: actor,
            directory: users,
            updateProfile: updateProfile
        ) { [weak self] saved in
            await self?.didSave(saved)
        }
    }

    /// Shows a saved change. When the acting user changed their own role, what they may see
    /// changes too, so the directory is loaded again.
    func didSave(_ saved: User) async {
        let previousRole = user(withID: saved.id)?.role
        apply(saved)
        if saved.id == actingUserID, saved.role != previousRole {
            await load()
        }
    }

    func apply(_ saved: User) {
        guard let index = users.firstIndex(where: { $0.id == saved.id }) else { return }
        users[index] = saved
    }
}
