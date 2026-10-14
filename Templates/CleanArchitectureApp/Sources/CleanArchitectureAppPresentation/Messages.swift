import CleanArchitectureAppDomain
import Foundation

extension DirectoryError {
    /// Text for the person using the app. The domain only names the failure.
    public var message: String {
        switch self {
        case .offline:
            "You are offline and there is no saved copy of the directory yet."
        case .unauthorized:
            "The server did not accept your sign-in."
        case .notFound:
            "This person is no longer in the directory."
        case .emailAlreadyInUse:
            "Another account already uses this email address."
        case .server(let statusCode):
            "The server could not complete the request (HTTP \(statusCode))."
        case .invalidResponse:
            "The server sent a response the app could not read."
        case .invalidRequest:
            "The change could not be prepared for the server, so nothing was sent."
        case .permissionDenied(.editOwnProfile):
            "Your account is not allowed to edit its profile."
        case .permissionDenied:
            "Only an admin can do this."
        case .invalid:
            "Some fields need attention."
        case .lastActiveAdmin:
            "The directory needs at least one active admin."
        }
    }
}

extension ValidationIssue {
    public var message: String {
        switch self {
        case .nameInvalidCharacters:
            "Remove invisible or control characters from the name."
        case .nameTooShort(let minimum):
            "Enter a name of at least \(minimum) characters."
        case .nameTooLong(let maximum):
            "Use at most \(maximum) characters for the name."
        case .nameTooComplex:
            "Use fewer accents or emoji in the name."
        case .emailMissing:
            "Enter an email address."
        case .emailInvalid:
            "Enter an email address such as name@example.com."
        case .emailTooLong(let maximum):
            "Use at most \(maximum) characters for the email address."
        }
    }
}

extension UserRole {
    public var title: String {
        switch self {
        case .member: "Member"
        case .moderator: "Moderator"
        case .admin: "Admin"
        }
    }
}

extension Permission {
    public var title: String {
        switch self {
        case .editOwnProfile: "Edit own profile"
        case .viewInactiveUsers: "See deactivated accounts"
        case .manageUsers: "Manage roles and accounts"
        }
    }
}

extension UserFilter {
    public var title: String {
        switch self {
        case .all: "Everyone"
        case .active: "Active"
        case .inactive: "Deactivated"
        case .role(let role): role.title + "s"
        }
    }
}

extension UserSortOrder {
    public var title: String {
        switch self {
        case .name: "Name"
        case .role: "Role"
        case .recentlyJoined: "Recently joined"
        }
    }
}
