import Foundation

/// The signed-in account as seen by the UI layer.
struct AuthSession: Codable, Equatable, Sendable {
    let userID: String
    let username: String
    let email: String
}

enum AuthError: LocalizedError, Equatable {
    case invalidEmail
    case weakPassword
    case usernameMissing
    case emailAlreadyRegistered
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Enter a valid email address."
        case .weakPassword:
            return "Passwords need at least \(LocalAuthService.minimumPasswordLength) characters."
        case .usernameMissing:
            return "Choose a username."
        case .emailAlreadyRegistered:
            return "An account with this email already exists."
        case .invalidCredentials:
            return "The email or password is incorrect."
        }
    }
}

/// Boundary between the app and an identity provider.
///
/// The template ships with `LocalAuthService`. To use Firebase Auth, Sign in with Apple
/// or your own backend, add a type that conforms to this protocol and pass it to
/// `AuthManager(service:)`.
protocol AuthService: Sendable {
    func currentSession() async -> AuthSession?
    func signIn(email: String, password: String) async throws -> AuthSession
    func signUp(username: String, email: String, password: String) async throws -> AuthSession
    func signOut() async
}

/// In-memory accounts with the signed-in email remembered in `UserDefaults`.
actor LocalAuthService: AuthService {
    struct Account: Sendable {
        let userID: String
        let username: String
        let email: String
        let password: String
    }

    static let minimumPasswordLength = 8
    static let signedInEmailKey = "SocialMediaApp.signedInEmail"
    static let demoAccount = Account(
        userID: "preview-user",
        username: "preview",
        email: "demo@example.com",
        password: "password123"
    )

    private var accountsByEmail: [String: Account]
    private let defaults: UserDefaults

    init(accounts: [Account] = [LocalAuthService.demoAccount], defaults: UserDefaults = .standard) {
        self.accountsByEmail = Dictionary(
            accounts.map { (Self.normalized($0.email), $0) },
            uniquingKeysWith: { first, _ in first }
        )
        self.defaults = defaults
    }

    func currentSession() async -> AuthSession? {
        guard let email = defaults.string(forKey: Self.signedInEmailKey),
              let account = accountsByEmail[Self.normalized(email)] else {
            return nil
        }
        return Self.session(for: account)
    }

    func signIn(email: String, password: String) async throws -> AuthSession {
        guard let account = accountsByEmail[Self.normalized(email)],
              account.password == password else {
            throw AuthError.invalidCredentials
        }
        defaults.set(account.email, forKey: Self.signedInEmailKey)
        return Self.session(for: account)
    }

    func signUp(username: String, email: String, password: String) async throws -> AuthSession {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedEmail = Self.normalized(email)

        guard !trimmedUsername.isEmpty else { throw AuthError.usernameMissing }
        guard Self.isPlausibleEmail(normalizedEmail) else { throw AuthError.invalidEmail }
        guard password.count >= Self.minimumPasswordLength else { throw AuthError.weakPassword }
        guard accountsByEmail[normalizedEmail] == nil else { throw AuthError.emailAlreadyRegistered }

        let account = Account(
            userID: UUID().uuidString,
            username: trimmedUsername,
            email: normalizedEmail,
            password: password
        )
        accountsByEmail[normalizedEmail] = account
        defaults.set(account.email, forKey: Self.signedInEmailKey)
        return Self.session(for: account)
    }

    func signOut() async {
        defaults.removeObject(forKey: Self.signedInEmailKey)
    }

    private static func session(for account: Account) -> AuthSession {
        AuthSession(userID: account.userID, username: account.username, email: account.email)
    }

    private static func normalized(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private static func isPlausibleEmail(_ email: String) -> Bool {
        let parts = email.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2, !parts[0].isEmpty else { return false }
        let domain = parts[1]
        return domain.contains(".") && !domain.hasPrefix(".") && !domain.hasSuffix(".")
    }
}
