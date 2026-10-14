@testable import CleanArchitectureAppDomain
import Foundation
import Testing

@Suite("ProfileDraft")
struct ProfileDraftTests {
    private func draft(name: String = "Ada Lovelace", email: String = "ada@example.com") -> ProfileDraft {
        ProfileDraft(name: name, email: email, role: .member)
    }

    @Test func normalizesWhitespaceInNameAndCaseInEmail() {
        let value = draft(name: "  Ada \t\n  Lovelace ", email: "  ADA@Example.COM \n")
        #expect(value.normalizedName == "Ada Lovelace")
        #expect(value.normalizedEmail == "ada@example.com")
        #expect(value.issues.isEmpty)
    }

    @Test func nameLengthIsCheckedAfterNormalizingAtBothBounds() {
        #expect(draft(name: " A ").issues == [.nameTooShort(minimum: 2)])
        #expect(draft(name: "Al").issues.isEmpty)
        #expect(draft(name: String(repeating: "a", count: 60)).issues.isEmpty)
        #expect(draft(name: String(repeating: "a", count: 61)).issues == [.nameTooLong(maximum: 60)])
        // Twenty spaces between two letters collapse to one, so the name is 3 characters.
        #expect(draft(name: "A" + String(repeating: " ", count: 70) + "B").issues.isEmpty)
    }

    @Test func nameLengthCountsCharactersNotBytes() {
        // 60 characters, 240 UTF-8 bytes.
        #expect(draft(name: String(repeating: "😀", count: 60)).issues.isEmpty)
    }

    @Test(arguments: ["Ada\u{0}Lovelace", "Ada\u{1B}[31m", "Ada \u{202E}ecalevoL", "\u{2066}Ada\u{2069}"])
    func rejectsControlAndBidiOverrideCharactersInName(_ name: String) {
        #expect(draft(name: name).issues == [.nameInvalidCharacters])
    }

    @Test func keepsZeroWidthNonJoinerUsedInPersianNames() {
        #expect(draft(name: "می\u{200C}خواهم").issues.isEmpty)
    }

    @Test(arguments: ["Ada\u{200E}", "\u{200F}Ada", "Ada\u{061C}Lovelace"])
    func rejectsBidirectionalMarksInName(_ name: String) {
        #expect(draft(name: name).issues == [.nameInvalidCharacters])
    }

    @Test(arguments: [
        "\u{200B}\u{200B}", // zero-width spaces
        "\u{FEFF}\u{2060}", // byte order mark and word joiner
        "\u{200C}\u{200C}\u{200C}", // zero-width non-joiners
        "\u{3164}\u{3164}", // Hangul fillers
        "\u{2800}\u{2800}", // Braille pattern blanks
        "A\u{200B}" // one visible letter
    ])
    func namesWithoutTwoVisibleCharactersAreTooShort(_ name: String) {
        #expect(draft(name: name).issues == [.nameTooShort(minimum: 2)])
    }

    @Test func stackedCombiningMarksCannotHideAnOversizedName() {
        // Two characters, but a million and two scalars (about 2 MB of UTF-8).
        let zalgo = "Ab" + String(repeating: "\u{0301}", count: 1_000_000)
        #expect(zalgo.count == 2)
        #expect(draft(name: zalgo).issues == [.nameTooLong(maximum: 60)])
    }

    @Test func scalarLimitLeavesRoomForDecomposedAccents() {
        let limit = ProfileDraft.maximumNameScalarCount
        // "e" plus three combining marks: 4 scalars per character, 240 in total.
        let accented = String(repeating: "e\u{0301}\u{0323}\u{0302}", count: limit / 4)
        #expect(accented.unicodeScalars.count == limit)
        #expect(draft(name: accented).issues.isEmpty)
        #expect(draft(name: accented + "\u{0301}").issues == [.nameTooLong(maximum: 60)])
        // Decomposed Vietnamese: "Nguyễn" typed as base letters and combining marks.
        #expect(draft(name: "Nguye\u{0302}\u{0303}n Va\u{0306}n A").issues.isEmpty)
    }

    @Test func emptyEmailIsMissingNotInvalid() {
        #expect(draft(email: "   ").issues == [.emailMissing])
    }

    @Test(arguments: [
        "ada@example.com",
        "ada.lovelace+test@mail.example.co.uk",
        "a@b-c.de",
        "1234@example.io"
    ])
    func acceptsOrdinaryAddresses(_ email: String) {
        #expect(ProfileDraft.isValidEmail(email))
    }

    @Test(arguments: [
        "ada",
        "ada@",
        "@example.com",
        "ada@@example.com",
        "ada@example@com",
        "ada@example",
        "ada@example.c",
        "ada@example.c0m",
        "ada@.example.com",
        "ada@example..com",
        "ada@-example.com",
        "ada@example-.com",
        "ada@exa_mple.com",
        "ada@exämple.com",
        ".ada@example.com",
        "ada.@example.com",
        "a..da@example.com",
        "a da@example.com",
        "ada\u{0}@example.com",
        "ada\u{202E}@example.com"
    ])
    func rejectsMalformedAddresses(_ email: String) {
        #expect(!ProfileDraft.isValidEmail(email))
    }

    @Test func localPartLimitIs64Bytes() {
        let at64 = String(repeating: "a", count: 64) + "@example.com"
        let at65 = String(repeating: "a", count: 65) + "@example.com"
        // "é" is two bytes in UTF-8: 32 of them fit, 33 are 66 bytes although only 33 characters.
        #expect(ProfileDraft.isValidEmail(at64))
        #expect(!ProfileDraft.isValidEmail(at65))
        #expect(ProfileDraft.isValidEmail(String(repeating: "é", count: 32) + "@example.com"))
        #expect(!ProfileDraft.isValidEmail(String(repeating: "é", count: 33) + "@example.com"))
    }

    @Test func domainLabelLimitIs63Bytes() {
        #expect(ProfileDraft.isValidEmail("a@" + String(repeating: "b", count: 63) + ".com"))
        #expect(!ProfileDraft.isValidEmail("a@" + String(repeating: "b", count: 64) + ".com"))
    }

    @Test func addressesOver254BytesAreTooLongBeforeTheyAreParsed() {
        let at254 = "a@" + [62, 61, 61, 61].map { String(repeating: "b", count: $0) }.joined(separator: ".") + ".com"
        #expect(at254.utf8.count == 254)
        #expect(draft(email: at254).issues.isEmpty)
        #expect(draft(email: "a" + at254).issues == [.emailTooLong(maximum: 254)])
        // A pasted megabyte is reported as too long, without splitting it into labels.
        #expect(draft(email: String(repeating: "x", count: 1_000_000)).issues == [.emailTooLong(maximum: 254)])
    }

    @Test func reportsNameAndEmailIssuesTogetherWithTheirFields() {
        let issues = draft(name: "", email: "nope").issues
        #expect(issues == [.nameTooShort(minimum: 2), .emailInvalid])
        #expect(issues.map(\.field) == [.name, .email])
    }
}

@Suite("User and roles")
struct UserRoleTests {
    @Test func rolesAreOrderedByRank() {
        #expect(UserRole.member < .moderator)
        #expect(UserRole.moderator < .admin)
        #expect(UserRole.allCases.sorted() == [.member, .moderator, .admin])
    }

    @Test func permissionsGrowWithRank() {
        #expect(UserRole.member.permissions == [.editOwnProfile])
        #expect(UserRole.moderator.permissions == [.editOwnProfile, .viewInactiveUsers])
        #expect(UserRole.admin.permissions == Set(Permission.allCases))
    }

    @Test func deactivatedAccountKeepsItsRoleButLosesEveryPermission() {
        let admin = makeUser(1, role: .admin, isActive: false)
        #expect(admin.role == .admin)
        #expect(Permission.allCases.allSatisfy { !admin.can($0) })
        #expect(!admin.canEditProfile(of: admin))
    }

    @Test func membersEditOnlyTheirOwnProfileAndAdminsEditAnyone() {
        let member = makeUser(1)
        let other = makeUser(2)
        let admin = makeUser(3, role: .admin)
        #expect(member.canEditProfile(of: member))
        #expect(!member.canEditProfile(of: other))
        #expect(!makeUser(4, role: .moderator).canEditProfile(of: other))
        #expect(admin.canEditProfile(of: other))
    }
}

@Suite("UserQuery")
struct UserQueryTests {
    private let users = [
        makeUser(1, "Zoë Martin", role: .member, email: "zoe@example.com"),
        makeUser(2, "Ada Lovelace", role: .admin, email: "ada@example.com"),
        makeUser(3, "alan Turing", role: .moderator, email: "turing@lab.example"),
        makeUser(4, "Lars Eriksson", role: .member, isActive: false, email: "lars@example.com"),
        makeUser(5, "File 10", role: .member),
        makeUser(6, "File 9", role: .member)
    ]

    @Test func searchIgnoresCaseAndDiacriticsAndMatchesEmail() {
        #expect(UserQuery(searchText: "zoe").apply(to: users).map(\.name) == ["Zoë Martin"])
        #expect(UserQuery(searchText: "ALAN").apply(to: users).map(\.name) == ["alan Turing"])
        #expect(UserQuery(searchText: "lab.example").apply(to: users).map(\.name) == ["alan Turing"])
        #expect(UserQuery(searchText: "  ada  ").apply(to: users).map(\.name) == ["Ada Lovelace"])
        #expect(UserQuery(searchText: "nobody").apply(to: users).isEmpty)
    }

    @Test func whitespaceOnlySearchMatchesEveryone() {
        #expect(UserQuery(searchText: " \n ").apply(to: users).count == users.count)
    }

    @Test func filtersByStateAndRole() {
        #expect(UserQuery(filter: .inactive).apply(to: users).map(\.name) == ["Lars Eriksson"])
        #expect(UserQuery(filter: .active).apply(to: users).count == 5)
        #expect(UserQuery(filter: .role(.admin)).apply(to: users).map(\.name) == ["Ada Lovelace"])
        #expect(UserFilter.allCases.count == 3 + UserRole.allCases.count)
    }

    @Test func nameOrderComparesNumbersLikeTheFinderAndIgnoresCase() {
        let names = UserQuery(sortOrder: .name).apply(to: users).map(\.name)
        #expect(names == ["Ada Lovelace", "alan Turing", "File 9", "File 10", "Lars Eriksson", "Zoë Martin"])
    }

    @Test func roleOrderPutsHighestRankFirstThenSortsByName() {
        let names = UserQuery(sortOrder: .role).apply(to: users).map(\.name)
        #expect(names == ["Ada Lovelace", "alan Turing", "File 9", "File 10", "Lars Eriksson", "Zoë Martin"])
    }

    @Test func recentlyJoinedPutsNewestFirst() {
        let numbers = UserQuery(sortOrder: .recentlyJoined).apply(to: users).map(\.email)
        #expect(numbers.first == "user6@example.com")
        #expect(numbers.last == "zoe@example.com")
    }

    @Test func tiesAreBrokenByIDSoTheOrderIsStable() {
        let twins = [makeUser(9, "Same"), makeUser(3, "Same"), makeUser(7, "Same")]
        let first = UserQuery(sortOrder: .name).apply(to: twins).map(\.id)
        let second = UserQuery(sortOrder: .name).apply(to: twins.reversed()).map(\.id)
        #expect(first == second)
        #expect(first == twins.map(\.id).sorted { $0.uuidString < $1.uuidString })
    }
}
