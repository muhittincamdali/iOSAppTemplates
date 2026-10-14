@testable import CleanArchitectureAppDomain
import Foundation
import Testing

@Suite("ListUsersUseCase")
struct ListUsersUseCaseTests {
    private let member = makeUser(1, role: .member)
    private let moderator = makeUser(2, role: .moderator)
    private let deactivated = makeUser(3, isActive: false)
    private let deactivatedModerator = makeUser(4, role: .moderator, isActive: false)

    private var everyone: [User] { [member, moderator, deactivated, deactivatedModerator] }

    @Test func membersSeeOnlyActiveAccounts() async throws {
        let snapshot = try await ListUsersUseCase(repository: RecordingRepository(everyone)).execute(as: member.id)
        #expect(snapshot.users == [member, moderator])
    }

    @Test func moderatorsSeeDeactivatedAccountsToo() async throws {
        let snapshot = try await ListUsersUseCase(repository: RecordingRepository(everyone)).execute(as: moderator.id)
        #expect(snapshot.users == everyone)
    }

    @Test func aDeactivatedModeratorLosesTheWiderView() async throws {
        let snapshot = try await ListUsersUseCase(repository: RecordingRepository(everyone))
            .execute(as: deactivatedModerator.id)
        #expect(snapshot.users == [member, moderator])
    }

    @Test func unknownOrMissingActorSeesOnlyActiveAccounts() async throws {
        let useCase = ListUsersUseCase(repository: RecordingRepository(everyone))
        #expect(try await useCase.execute(as: nil).users == [member, moderator])
        #expect(try await useCase.execute(as: UUID()).users == [member, moderator])
    }

    @Test func keepsTheOriginOfTheData() async throws {
        let savedAt = Date(timeIntervalSince1970: 1_000)
        let repository = RecordingRepository(everyone, origin: .cache(savedAt: savedAt))
        #expect(try await ListUsersUseCase(repository: repository).execute(as: member.id).origin == .cache(savedAt: savedAt))
    }

    @Test func passesRepositoryErrorsOn() async {
        let useCase = ListUsersUseCase(repository: RecordingRepository([], failure: .offline))
        await #expect(throws: DirectoryError.offline) { try await useCase.execute(as: nil) }
    }
}

@Suite("UpdateProfileUseCase")
struct UpdateProfileUseCaseTests {
    private let admin = makeUser(1, "Ada Lovelace", role: .admin)
    private let secondAdmin = makeUser(2, "Grace Hopper", role: .admin)
    private let member = makeUser(3, "Mei Chen")
    private let otherMember = makeUser(4, "Priya Raman")

    private var directory: [User] { [admin, secondAdmin, member, otherMember] }

    @Test func savesNormalizedValuesAndReturnsTheStoredUser() async throws {
        let repository = RecordingRepository(directory)
        var draft = ProfileDraft(member)
        draft.name = "  Mei   Chen-Li "
        draft.email = " MEI@Example.com "

        let saved = try await UpdateProfileUseCase(repository: repository).execute(draft, for: member, by: member, in: directory)

        #expect(saved.name == "Mei Chen-Li")
        #expect(saved.email == "mei@example.com")
        #expect(await repository.saved == [saved])
    }

    @Test func doesNotCallTheServerWhenNothingChanged() async throws {
        let repository = RecordingRepository(directory)
        var draft = ProfileDraft(member)
        draft.name = " \(member.name) "
        let saved = try await UpdateProfileUseCase(repository: repository).execute(draft, for: member, by: member, in: directory)
        #expect(saved == member)
        #expect(await repository.saved.isEmpty)
    }

    @Test func memberCannotEditSomeoneElse() async {
        let repository = RecordingRepository(directory)
        await #expect(throws: DirectoryError.permissionDenied(.manageUsers)) {
            try await UpdateProfileUseCase(repository: repository)
                .execute(ProfileDraft(otherMember), for: otherMember, by: member, in: directory)
        }
        #expect(await repository.saved.isEmpty)
    }

    @Test func deactivatedUserCannotEditOwnProfile() async {
        let inactive = makeUser(5, isActive: false)
        var draft = ProfileDraft(inactive)
        draft.name = "New Name"
        await #expect(throws: DirectoryError.permissionDenied(.editOwnProfile)) {
            try await UpdateProfileUseCase(repository: RecordingRepository([inactive]))
                .execute(draft, for: inactive, by: inactive, in: [inactive])
        }
    }

    @Test func memberCannotPromoteThemself() async {
        var draft = ProfileDraft(member)
        draft.role = .admin
        await #expect(throws: DirectoryError.permissionDenied(.manageUsers)) {
            try await UpdateProfileUseCase(repository: RecordingRepository(directory))
                .execute(draft, for: member, by: member, in: directory)
        }
    }

    @Test func adminCanDemoteAnotherAdminWhileOneRemains() async throws {
        var draft = ProfileDraft(secondAdmin)
        draft.role = .moderator
        let saved = try await UpdateProfileUseCase(repository: RecordingRepository(directory))
            .execute(draft, for: secondAdmin, by: admin, in: directory)
        #expect(saved.role == .moderator)
    }

    @Test func lastActiveAdminCannotBeDemoted() async {
        let inactiveAdmin = makeUser(6, role: .admin, isActive: false)
        let directory = [admin, member, inactiveAdmin]
        var draft = ProfileDraft(admin)
        draft.role = .member
        let repository = RecordingRepository(directory)
        await #expect(throws: DirectoryError.lastActiveAdmin) {
            try await UpdateProfileUseCase(repository: repository).execute(draft, for: admin, by: admin, in: directory)
        }
        #expect(await repository.saved.isEmpty)
    }

    @Test func permissionIsCheckedBeforeValidation() async {
        var draft = ProfileDraft(otherMember)
        draft.email = "not an address"
        await #expect(throws: DirectoryError.permissionDenied(.manageUsers)) {
            try await UpdateProfileUseCase(repository: RecordingRepository(directory))
                .execute(draft, for: otherMember, by: member, in: directory)
        }
    }

    @Test func invalidDraftIsRejectedWithEveryIssue() async {
        var draft = ProfileDraft(member)
        draft.name = "M"
        draft.email = "mei@"
        let repository = RecordingRepository(directory)
        await #expect(throws: DirectoryError.invalid([.nameTooShort(minimum: 2), .emailInvalid])) {
            try await UpdateProfileUseCase(repository: repository).execute(draft, for: member, by: member, in: directory)
        }
        #expect(await repository.saved.isEmpty)
    }

    @Test func passesServerErrorsOn() async {
        var draft = ProfileDraft(member)
        draft.email = "priya@example.com"
        await #expect(throws: DirectoryError.emailAlreadyInUse) {
            try await UpdateProfileUseCase(repository: RecordingRepository(directory, failure: .emailAlreadyInUse))
                .execute(draft, for: member, by: member, in: directory)
        }
    }
}

@Suite("SetUserActiveUseCase")
struct SetUserActiveUseCaseTests {
    private let admin = makeUser(1, role: .admin)
    private let moderator = makeUser(2, role: .moderator)
    private let member = makeUser(3)

    @Test func adminDeactivatesAndReactivatesAMember() async throws {
        let repository = RecordingRepository([admin, member])
        let useCase = SetUserActiveUseCase(repository: repository)
        let off = try await useCase.execute(false, for: member, by: admin, in: [admin, member])
        let on = try await useCase.execute(true, for: off, by: admin, in: [admin, off])
        #expect(!off.isActive)
        #expect(on.isActive)
        #expect(await repository.saved.count == 2)
    }

    @Test func onlyAdminsChangeAccountState() async {
        await #expect(throws: DirectoryError.permissionDenied(.manageUsers)) {
            try await SetUserActiveUseCase(repository: RecordingRepository([moderator, member]))
                .execute(false, for: member, by: moderator, in: [moderator, member])
        }
    }

    @Test func noChangeMeansNoSave() async throws {
        let repository = RecordingRepository([admin, member])
        let result = try await SetUserActiveUseCase(repository: repository).execute(true, for: member, by: admin, in: [admin, member])
        #expect(result == member)
        #expect(await repository.saved.isEmpty)
    }

    @Test func lastActiveAdminCannotBeDeactivated() async {
        await #expect(throws: DirectoryError.lastActiveAdmin) {
            try await SetUserActiveUseCase(repository: RecordingRepository([admin, member]))
                .execute(false, for: admin, by: admin, in: [admin, member])
        }
    }

    @Test func anAdminMayBeDeactivatedWhileAnotherActiveAdminRemains() async throws {
        let other = makeUser(4, role: .admin)
        let result = try await SetUserActiveUseCase(repository: RecordingRepository([admin, other]))
            .execute(false, for: other, by: admin, in: [admin, other])
        #expect(!result.isActive)
    }
}

@Suite("DirectorySummary")
struct DirectorySummaryTests {
    @Test func countsStatesAndRolesAndFindsTheNewestMember() {
        let users = [
            makeUser(1, role: .admin),
            makeUser(2, role: .moderator, isActive: false),
            makeUser(3),
            makeUser(9, "Newest")
        ]
        let summary = DirectorySummary(users: users)
        #expect(summary.total == 4)
        #expect(summary.active == 3)
        #expect(summary.inactive == 1)
        #expect(summary.count(of: .admin) == 1)
        #expect(summary.count(of: .moderator) == 1)
        #expect(summary.count(of: .member) == 2)
        #expect(summary.newestMember?.name == "Newest")
    }

    @Test func emptyDirectoryHasZeroCountsAndNoNewestMember() {
        let summary = DirectorySummary(users: [])
        #expect(summary.total == 0)
        #expect(summary.inactive == 0)
        #expect(UserRole.allCases.allSatisfy { summary.count(of: $0) == 0 })
        #expect(summary.newestMember == nil)
    }
}
