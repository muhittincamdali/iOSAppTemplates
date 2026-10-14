import CleanArchitectureAppDomain
import CleanArchitectureAppPresentation
import Foundation
import Testing

@MainActor
@Suite("ProfileEditorModel")
struct ProfileEditorModelTests {
    private func editor(
        for target: User,
        actingAs actor: User,
        repository: FakeRepository = FakeRepository()
    ) async throws -> ProfileEditorModel {
        let directory = makeDirectory(repository, actingAs: actor)
        await directory.load()
        return try #require(directory.makeEditor(for: target))
    }

    @Test func issuesStayHiddenUntilTheFirstSaveAttempt() async throws {
        let repository = FakeRepository()
        let editor = try await editor(for: zoe, actingAs: zoe, repository: repository)
        editor.draft.name = "Z"
        editor.draft.email = "not-an-address"

        #expect(editor.issues(for: .name).isEmpty)
        #expect(editor.hasChanges)

        #expect(await editor.save() == nil)

        #expect(editor.issues(for: .name) == [.nameTooShort(minimum: 2)])
        #expect(editor.issues(for: .email) == [.emailInvalid])
        #expect(await repository.saveCount == 0)
    }

    @Test func onlyAdminsMayChangeTheRole() async throws {
        #expect(try await editor(for: zoe, actingAs: zoe).canChangeRole == false)
        #expect(try await editor(for: alan, actingAs: alan).canChangeRole == false)
        #expect(try await editor(for: zoe, actingAs: ada).canChangeRole)
    }

    @Test func aServerRefusalIsShownAndTheDraftIsKept() async throws {
        let repository = FakeRepository()
        await repository.setSaveFailure(.emailAlreadyInUse)
        let editor = try await editor(for: zoe, actingAs: zoe, repository: repository)
        editor.draft.email = "ada@example.com"

        #expect(await editor.save() == nil)

        #expect(editor.saveError == .emailAlreadyInUse)
        #expect(editor.draft.email == "ada@example.com")
        #expect(editor.isSaving == false)
    }

    @Test func aSuccessfulSaveClearsTheEarlierError() async throws {
        let repository = FakeRepository()
        await repository.setSaveFailure(.offline)
        let editor = try await editor(for: zoe, actingAs: zoe, repository: repository)
        editor.draft.name = "Zoë Martin"
        _ = await editor.save()
        #expect(editor.saveError == .offline)

        await repository.setSaveFailure(nil)
        let saved = try #require(await editor.save())

        #expect(saved.name == "Zoë Martin")
        #expect(editor.saveError == nil)
    }
}

/// Stands in for the composition root's controls.
actor FakeBackendControls: BackendControls {
    private(set) var reachable = true
    private(set) var clearCount = 0
    var clearFailure: (any Error)?

    func setClearFailure(_ error: (any Error)?) { clearFailure = error }
    func isServerReachable() -> Bool { reachable }
    func setServerReachable(_ reachable: Bool) { self.reachable = reachable }

    func clearSavedDirectory() throws {
        if let clearFailure { throw clearFailure }
        clearCount += 1
    }
}

@MainActor
@Suite("SettingsModel")
struct SettingsModelTests {
    @Test func theSwitchFollowsTheBackend() async {
        let controls = FakeBackendControls()
        let model = SettingsModel(controls: controls)

        await model.setServerReachable(false)
        #expect(model.isServerReachable == false)
        #expect(await controls.reachable == false)

        await controls.setServerReachable(true)
        await model.refresh()
        #expect(model.isServerReachable)
    }

    @Test func clearingReportsSuccessAndFailure() async {
        let controls = FakeBackendControls()
        let model = SettingsModel(controls: controls)

        await model.clearSavedDirectory()
        #expect(model.cacheMessage == "The saved copy was deleted.")
        #expect(await controls.clearCount == 1)

        await controls.setClearFailure(CocoaError(.fileWriteNoPermission))
        await model.clearSavedDirectory()
        #expect(model.cacheMessage?.hasPrefix("The saved copy could not be deleted") == true)
    }
}
