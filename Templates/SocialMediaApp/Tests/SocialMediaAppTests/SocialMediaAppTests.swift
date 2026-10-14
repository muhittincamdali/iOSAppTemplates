import Foundation
import Testing
@testable import SocialMediaApp

/// A fresh UserDefaults suite name so tests never touch the app's real defaults.
private func isolatedSuiteName() -> String {
    "SocialMediaAppTests-\(UUID().uuidString)"
}

@Suite("LocalAuthService")
struct LocalAuthServiceTests {
    let demo = LocalAuthService.demoAccount

    @Test func demoAccountSignsInAndIsRemembered() async throws {
        let suite = isolatedSuiteName()
        let service = LocalAuthService(defaultsSuiteName: suite)

        let session = try await service.signIn(email: "  DEMO@example.com ", password: demo.password)

        #expect(session.username == demo.username)
        #expect(await service.currentSession() == session)
        #expect(await LocalAuthService(defaultsSuiteName: suite).currentSession() == session, "a new instance restores the session")
    }

    @Test func wrongPasswordOrUnknownEmailIsRejected() async throws {
        let service = LocalAuthService(defaultsSuiteName: isolatedSuiteName())

        await #expect(throws: AuthError.invalidCredentials) {
            try await service.signIn(email: demo.email, password: "wrong-password")
        }
        await #expect(throws: AuthError.invalidCredentials) {
            try await service.signIn(email: "nobody@example.com", password: demo.password)
        }
        #expect(await service.currentSession() == nil)
    }

    @Test func signUpValidatesInput() async throws {
        let service = LocalAuthService(defaultsSuiteName: isolatedSuiteName())

        await #expect(throws: AuthError.usernameMissing) {
            try await service.signUp(username: "  ", email: "new@example.com", password: "password123")
        }
        await #expect(throws: AuthError.invalidEmail) {
            try await service.signUp(username: "new", email: "new@example", password: "password123")
        }
        await #expect(throws: AuthError.invalidEmail) {
            try await service.signUp(username: "new", email: "@example.com", password: "password123")
        }
        await #expect(throws: AuthError.weakPassword) {
            try await service.signUp(username: "new", email: "new@example.com", password: "short")
        }
        await #expect(throws: AuthError.emailAlreadyRegistered) {
            try await service.signUp(username: "copy", email: "Demo@Example.com", password: "password123")
        }
    }

    @Test func signUpCreatesAccountThatCanSignInAgain() async throws {
        let service = LocalAuthService(defaultsSuiteName: isolatedSuiteName())

        let created = try await service.signUp(username: " maya ", email: "Maya@Example.com", password: "password123")
        await service.signOut()
        let signedIn = try await service.signIn(email: "maya@example.com", password: "password123")

        #expect(created.username == "maya")
        #expect(created.email == "maya@example.com")
        #expect(signedIn == created)
    }

    @Test func signOutForgetsSession() async throws {
        let service = LocalAuthService(defaultsSuiteName: isolatedSuiteName())
        _ = try await service.signIn(email: demo.email, password: demo.password)

        await service.signOut()

        #expect(await service.currentSession() == nil)
    }
}

@MainActor
@Suite("AuthManager")
struct AuthManagerTests {
    @Test func publishesSignedInUserAndClearsItOnSignOut() async throws {
        let manager = AuthManager(service: LocalAuthService(defaultsSuiteName: isolatedSuiteName()))
        #expect(!manager.isAuthenticated)

        try await manager.signIn(email: LocalAuthService.demoAccount.email, password: LocalAuthService.demoAccount.password)
        #expect(manager.isAuthenticated)
        #expect(manager.currentUser?.username == LocalAuthService.demoAccount.username)

        await manager.signOut()
        #expect(!manager.isAuthenticated)
        #expect(manager.currentUser == nil)
    }

    @Test func failedSignInLeavesStateUnchanged() async throws {
        let manager = AuthManager(service: LocalAuthService(defaultsSuiteName: isolatedSuiteName()))

        await #expect(throws: AuthError.invalidCredentials) {
            try await manager.signIn(email: "x@example.com", password: "password123")
        }
        #expect(!manager.isAuthenticated)
    }
}

@MainActor
@Suite("DataManager")
struct DataManagerTests {
    private func seeded() -> DataManager {
        let manager = DataManager()
        manager.seedPreviewState(currentUser: nil)
        return manager
    }

    @Test func likeTogglesCountAndNeverGoesNegative() throws {
        let manager = seeded()
        let post = try #require(manager.posts.first { !manager.likedPostIDs.contains($0.id) })

        manager.toggleLike(postID: post.id)
        #expect(manager.posts.first { $0.id == post.id }?.likesCount == post.likesCount + 1)
        manager.toggleLike(postID: post.id)
        #expect(manager.posts.first { $0.id == post.id }?.likesCount == post.likesCount)
    }

    @Test func commentsAreTrimmedAndBlankCommentsIgnored() throws {
        let manager = seeded()
        let post = try #require(manager.posts.first)
        let comments = manager.comments(for: post.id).count

        manager.addComment(body: "   ", to: post.id)
        manager.addComment(body: "  Nice build.  ", to: post.id)

        #expect(manager.comments(for: post.id).count == comments + 1)
        #expect(manager.comments(for: post.id).last?.body == "Nice build.")
        #expect(manager.posts.first { $0.id == post.id }?.commentsCount == post.commentsCount + 1)
    }

    @Test func publishingPostPutsItFirstWithAudienceTag() {
        let manager = seeded()

        manager.publishPost(
            content: "Hello",
            author: PostAuthor(name: "Demo", username: "demo", isVerified: false),
            audience: "Friends",
            attachmentCount: 2
        )

        #expect(manager.posts[0].content.hasPrefix("[Friends] Hello"))
        #expect(manager.profilePosts(for: "demo").count == 1)
        #expect(manager.comments(for: manager.posts[0].id).isEmpty)
    }

    @Test func followToggleAdjustsFollowerCount() throws {
        let manager = seeded()
        let profile = try #require(manager.suggestedProfiles.first { !manager.followedProfileIDs.contains($0.id) })

        manager.toggleFollow(profileID: profile.id)
        #expect(manager.followedProfileIDs.contains(profile.id))
        #expect(manager.suggestedProfiles.first { $0.id == profile.id }?.followersCount == profile.followersCount + 1)

        manager.toggleFollow(profileID: profile.id)
        #expect(manager.suggestedProfiles.first { $0.id == profile.id }?.followersCount == profile.followersCount)
    }

    @Test func markAllReadClearsUnreadNotifications() {
        let notifications = NotificationManager()
        notifications.seedPreviewState()

        notifications.markAllRead()

        #expect(notifications.notifications.allSatisfy { !$0.isUnread })
    }
}
