import Foundation
import SwiftUI

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager(service: LocalAuthService())
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private let service: any AuthService
    
    init(service: any AuthService) {
        self.service = service
    }
    
    func checkAuthState() async {
        apply(await service.currentSession())
    }
    
    func signIn(email: String, password: String) async throws {
        apply(try await service.signIn(email: email, password: password))
    }
    
    func signUp(username: String, email: String, password: String) async throws {
        apply(try await service.signUp(username: username, email: email, password: password))
    }
    
    func signOut() async {
        await service.signOut()
        apply(nil)
    }
    
    private func apply(_ session: AuthSession?) {
        currentUser = session.map(User.init(session:))
        isAuthenticated = session != nil
    }
}
