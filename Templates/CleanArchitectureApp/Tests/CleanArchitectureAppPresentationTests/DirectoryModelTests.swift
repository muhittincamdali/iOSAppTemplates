import CleanArchitectureAppDomain
import CleanArchitectureAppPresentation
import Testing

@MainActor
@Suite("DirectoryModel")
struct DirectoryModelTests {
    @Test func loadingShowsWhatTheActingUserMaySee() async {
        let member = makeDirectory(FakeRepository(), actingAs: zoe)
        await member.load()
        #expect(member.phase == .loaded)
        #expect(member.origin == .server)
        #expect(!member.users.contains(lars))

        let admin = makeDirectory(FakeRepository(), actingAs: ada)
        await admin.load()
        #expect(admin.users == team)
        #expect(admin.actingUser == ada)
    }

    @Test func aFailedFirstLoadIsShownAsAnError() async {
        let repository = FakeRepository()
        await repository.setLoadFailure(.offline)
        let model = makeDirectory(repository, actingAs: ada)

        await model.load()

        #expect(model.phase == .failed(.offline))
        #expect(model.users.isEmpty)
    }

    @Test func aFailedReloadKeepsTheUsersOnScreen() async {
        let repository = FakeRepository()
        let model = makeDirectory(repository, actingAs: ada)
        await model.load()
        await repository.setLoadFailure(.server(statusCode: 503))

        await model.load()

        #expect(model.phase == .failed(.server(statusCode: 503)))
        #expect(model.users == team)
    }

    @Test func anOlderResponseCannotOverwriteANewerOne() async throws {
        let repository = FakeRepository()
        await repository.holdLoads()
        let model = makeDirectory(repository, actingAs: ada)

        let first = Task { await model.signIn(as: zoe.id) }
        let held1 = await eventually { await repository.heldLoadCount == 1 }
        try #require(held1)
        let second = Task { await model.signIn(as: ada.id) }
        let held2 = await eventually { await repository.heldLoadCount == 2 }
        try #require(held2)

        await repository.releaseLoad(at: 1)
        await second.value
        await repository.releaseLoad(at: 0)
        await first.value

        // The member's response arrived last but was started first, so the admin view stays.
        #expect(model.actingUserID == ada.id)
        #expect(model.users == team)
    }

    @Test func searchFilterAndSortApplyToTheVisibleUsers() async {
        let model = makeDirectory(FakeRepository(), actingAs: ada)
        await model.load()

        model.query = UserQuery(searchText: "zoe")
        #expect(model.visibleUsers == [zoe])

        model.query = UserQuery(filter: .inactive)
        #expect(model.visibleUsers == [lars])

        model.query = UserQuery(sortOrder: .role)
        #expect(model.visibleUsers.map(\.name) == ["Ada", "Grace", "Alan", "Lars", "Zoë"])
    }

    @Test func onlyAdminsChangeAccountStateAndNeverTheirOwn() async {
        let admin = makeDirectory(FakeRepository(), actingAs: ada)
        await admin.load()
        #expect(admin.canChangeActiveState(of: zoe))
        #expect(!admin.canChangeActiveState(of: ada))

        let member = makeDirectory(FakeRepository(), actingAs: zoe)
        await member.load()
        #expect(!member.canChangeActiveState(of: alan))

        let signedOut = makeDirectory(FakeRepository(), actingAs: nil)
        await signedOut.load()
        #expect(!signedOut.canChangeActiveState(of: zoe))
    }

    @Test func deactivatingUpdatesTheListAndTheSummary() async throws {
        let repository = FakeRepository()
        let model = makeDirectory(repository, actingAs: ada)
        await model.load()

        #expect(await model.setActive(false, for: zoe))

        #expect(model.user(withID: zoe.id)?.isActive == false)
        #expect(model.summary.inactive == 2)
        #expect(await repository.saveCount == 1)
        #expect(model.actionError == nil)
    }

    @Test func aRefusedActionIsKeptForTheAlert() async throws {
        let repository = FakeRepository([ada, zoe])
        let model = makeDirectory(repository, actingAs: ada)
        await model.load()

        #expect(await model.setActive(false, for: ada) == false)

        #expect(model.actionError == .lastActiveAdmin)
        #expect(model.user(withID: ada.id)?.isActive == true)
        #expect(await repository.saveCount == 0)
    }

    @Test func editorsAreOfferedOnlyWhereTheActingUserMayEdit() async {
        let member = makeDirectory(FakeRepository(), actingAs: zoe)
        await member.load()
        #expect(member.makeEditor(for: zoe) != nil)
        #expect(member.makeEditor(for: alan) == nil)

        let admin = makeDirectory(FakeRepository(), actingAs: ada)
        await admin.load()
        #expect(admin.makeEditor(for: lars) != nil)
    }

    @Test func demotingYourselfReloadsWhatYouMaySee() async throws {
        let repository = FakeRepository()
        let model = makeDirectory(repository, actingAs: ada)
        await model.load()
        #expect(model.users.contains(lars))
        let editor = try #require(model.makeEditor(for: ada))

        editor.draft.role = .member
        let saved = try #require(await editor.save())

        #expect(saved.role == .member)
        #expect(model.actingUser?.role == .member)
        #expect(!model.users.contains(lars))
        #expect(await repository.loadCount == 2)
    }

    @Test func editingSomeoneElseUpdatesTheRowWithoutReloading() async throws {
        let repository = FakeRepository()
        let model = makeDirectory(repository, actingAs: ada)
        await model.load()
        let editor = try #require(model.makeEditor(for: alan))

        editor.draft.name = "  Alan   M.  Turing "
        _ = try #require(await editor.save())

        #expect(model.user(withID: alan.id)?.name == "Alan M. Turing")
        #expect(await repository.loadCount == 1)
    }
}
