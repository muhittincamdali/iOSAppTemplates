import CleanArchitectureApp
import CleanArchitectureAppData
import CleanArchitectureAppDomain
import CleanArchitectureAppPresentation
import Foundation
import Testing

/// Runs the app's real object graph (sample server, file cache, repository, use cases and
/// models) the way the screens drive it, with the cache in a temporary folder.
@MainActor
@Suite("Composition root, end to end")
struct EndToEndTests {
    private let cacheURL = FileManager.default.temporaryDirectory
        .appending(path: "CleanArchitectureAppTests-\(UUID().uuidString)/directory.json")

    private func launch() -> CleanArchitectureAppContainer {
        CleanArchitectureAppContainer.sample(cacheURL: cacheURL, latency: .zero)
    }

    @Test func theSignedInAdminSeesTheWholeSampleDirectory() async {
        let app = launch()
        await app.directory.load()

        #expect(app.directory.phase == .loaded)
        #expect(app.directory.origin == .server)
        #expect(app.directory.users.count == SampleServer.seedUsers.count)
        #expect(app.directory.actingUser?.name == "Ada Lovelace")
        #expect(app.directory.summary.inactive == 2)
    }

    @Test func goingOfflineFallsBackToTheSavedCopyUntilItIsCleared() async throws {
        let app = launch()
        await app.directory.load()

        await app.settings.setServerReachable(false)
        await app.directory.load()
        guard case .cache = app.directory.origin else {
            Issue.record("Expected the saved copy, got \(String(describing: app.directory.origin))")
            return
        }
        #expect(app.directory.users.count == SampleServer.seedUsers.count)

        await app.settings.clearSavedDirectory()
        await app.directory.load()
        #expect(app.directory.phase == .failed(.offline))
        // What was on screen stays readable.
        #expect(app.directory.users.count == SampleServer.seedUsers.count)
    }

    @Test func aSavedEditSurvivesAnOfflineRelaunch() async throws {
        let app = launch()
        await app.directory.load()
        let zoe = try #require(app.directory.users.first { $0.name == "Zoë Martin" })
        let editor = try #require(app.directory.makeEditor(for: zoe))
        editor.draft.name = "Zoë Martin-Leroy"
        editor.draft.email = " Zoe.Leroy@Example.com "
        _ = try #require(await editor.save())

        // A new process starts with a fresh sample server; take it offline before loading.
        let relaunched = launch()
        await relaunched.settings.setServerReachable(false)
        await relaunched.directory.load()

        let restored = try #require(relaunched.directory.user(withID: zoe.id))
        #expect(restored.name == "Zoë Martin-Leroy")
        #expect(restored.email == "zoe.leroy@example.com")
    }

    @Test func theServerRejectsAnAddressAnotherAccountUses() async throws {
        let app = launch()
        await app.directory.load()
        let mei = try #require(app.directory.users.first { $0.name == "Mei Chen" })
        let editor = try #require(app.directory.makeEditor(for: mei))
        editor.draft.email = "ADA.LOVELACE@example.com"

        #expect(await editor.save() == nil)
        #expect(editor.saveError == .emailAlreadyInUse)
    }

    @Test func signingInAsAMemberHidesDeactivatedAccountsAndAdminActions() async throws {
        let app = launch()
        await app.directory.load()
        let priya = try #require(app.directory.users.first { $0.name == "Priya Raman" })

        await app.directory.signIn(as: priya.id)

        #expect(app.directory.users.filter { !$0.isActive }.isEmpty)
        #expect(app.directory.users.count == SampleServer.seedUsers.count - 2)
        let other = try #require(app.directory.users.first { $0.id != priya.id })
        #expect(!app.directory.canChangeActiveState(of: other))
        #expect(app.directory.makeEditor(for: other) == nil)
    }
}
