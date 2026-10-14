import CleanArchitectureAppDomain
import CleanArchitectureAppPresentation
import Foundation

func makeUser(_ number: UInt8, _ name: String, role: UserRole = .member, isActive: Bool = true) -> User {
    User(
        id: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, number)),
        name: name,
        email: "user\(number)@example.com",
        role: role,
        isActive: isActive,
        joinedAt: Date(timeIntervalSince1970: 1_735_689_600 + Double(number) * 86_400)
    )
}

let ada = makeUser(1, "Ada", role: .admin)
let grace = makeUser(2, "Grace", role: .admin)
let alan = makeUser(3, "Alan", role: .moderator)
let zoe = makeUser(4, "Zoë")
let lars = makeUser(5, "Lars", isActive: false)
let team = [ada, grace, alan, zoe, lars]

/// An in-memory repository. Saves can be made to fail, and loads can be held until the
/// test releases them, to reproduce responses that arrive out of order.
actor FakeRepository: UserRepository {
    private(set) var stored: [User]
    private(set) var saveCount = 0
    private(set) var loadCount = 0
    var loadFailure: DirectoryError?
    var saveFailure: DirectoryError?
    private var holdsLoads = false
    private var heldLoads: [CheckedContinuation<Void, Never>] = []

    init(_ users: [User] = team) {
        stored = users
    }

    func setLoadFailure(_ error: DirectoryError?) { loadFailure = error }
    func setSaveFailure(_ error: DirectoryError?) { saveFailure = error }
    func holdLoads() { holdsLoads = true }
    var heldLoadCount: Int { heldLoads.count }

    func releaseLoad(at index: Int) {
        heldLoads.remove(at: index).resume()
    }

    func users() async throws(DirectoryError) -> DirectorySnapshot {
        loadCount += 1
        if holdsLoads {
            await withCheckedContinuation { heldLoads.append($0) }
        }
        if let loadFailure { throw loadFailure }
        return DirectorySnapshot(users: stored, origin: .server)
    }

    func save(_ user: User) async throws(DirectoryError) -> User {
        if let saveFailure { throw saveFailure }
        saveCount += 1
        if let index = stored.firstIndex(where: { $0.id == user.id }) {
            stored[index] = user
        }
        return user
    }
}

@MainActor
func makeDirectory(_ repository: FakeRepository, actingAs actor: User?) -> DirectoryModel {
    DirectoryModel(
        listUsers: ListUsersUseCase(repository: repository),
        updateProfile: UpdateProfileUseCase(repository: repository),
        setUserActive: SetUserActiveUseCase(repository: repository),
        actingUserID: actor?.id
    )
}

/// Waits until `condition` holds, yielding to other tasks in between. Fails the wait after
/// a fixed number of turns instead of hanging the test run.
@MainActor
func eventually(_ condition: () async -> Bool) async -> Bool {
    for _ in 0..<10_000 {
        if await condition() { return true }
        await Task.yield()
    }
    return false
}
