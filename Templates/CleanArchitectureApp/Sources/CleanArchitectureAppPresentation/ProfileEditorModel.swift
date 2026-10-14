import CleanArchitectureAppDomain
import Foundation
import Observation

/// State of the profile form. Rule messages appear after the first save attempt, so the
/// form does not complain while it is still being filled in.
@MainActor
@Observable
public final class ProfileEditorModel {
    public let original: User
    public var draft: ProfileDraft
    public private(set) var isSaving = false
    public private(set) var showsIssues = false
    /// A failure reported by the server or by a rule, shown under the form.
    public private(set) var saveError: DirectoryError?

    private let actor: User
    private let directory: [User]
    private let updateProfile: UpdateProfileUseCase
    private let onSaved: @MainActor (User) async -> Void

    init(
        user: User,
        actor: User,
        directory: [User],
        updateProfile: UpdateProfileUseCase,
        onSaved: @escaping @MainActor (User) async -> Void
    ) {
        self.original = user
        self.draft = ProfileDraft(user)
        self.actor = actor
        self.directory = directory
        self.updateProfile = updateProfile
        self.onSaved = onSaved
    }

    /// Only admins change roles.
    public var canChangeRole: Bool { actor.can(.manageUsers) }

    public var hasChanges: Bool { draft != ProfileDraft(original) }

    public func issues(for field: ValidationIssue.Field) -> [ValidationIssue] {
        showsIssues ? draft.issues.filter { $0.field == field } : []
    }

    /// Saves the draft and returns the stored user, or nil if nothing was saved.
    public func save() async -> User? {
        showsIssues = true
        saveError = nil
        guard draft.issues.isEmpty, !isSaving else { return nil }
        isSaving = true
        defer { isSaving = false }
        do {
            let saved = try await updateProfile.execute(draft, for: original, by: actor, in: directory)
            await onSaved(saved)
            return saved
        } catch {
            saveError = error
            return nil
        }
    }
}
