import Foundation
import SwiftUI

/// The account a new post is published as.
struct PostAuthor: Sendable {
    let name: String
    let username: String
    let isVerified: Bool
}

struct Post: Identifiable, Codable {
    let id: String
    let authorId: String
    let authorUsername: String
    let authorDisplayName: String
    let authorAvatarURL: String?
    let authorIsVerified: Bool
    var content: String
    /// Image URLs. The bundled sample posts use SF Symbol names instead, so the template
    /// shows media without network access; see `PostMediaTile`.
    var images: [String]?
    let videoURL: String?
    var likesCount: Int
    var commentsCount: Int
    var sharesCount: Int
    let createdAt: Date
    let updatedAt: Date
}

struct SuggestedProfile: Identifiable {
    let id: String
    let username: String
    let displayName: String
    let bio: String
    let avatarURL: String?
    let isVerified: Bool
    var followersCount: Int
}

struct PostComment: Identifiable {
    let id: String
    let authorName: String
    let authorUsername: String
    let body: String
    let likesCount: Int
    let createdAt: Date
}

struct SocialNotificationItem: Identifiable {
    let id: String
    let actorName: String
    let message: String
    let systemImage: String
    var isUnread: Bool
    let createdAt: Date
}

struct User: Identifiable, Codable {
    let id: String
    let username: String
    let email: String
    let displayName: String
    let avatarURL: String?
    let bio: String?
    let followersCount: Int
    let followingCount: Int
    let postsCount: Int
    let isVerified: Bool
    let createdAt: Date
    let lastActiveAt: Date
}

extension User {
    init(session: AuthSession) {
        self.init(
            id: session.userID,
            username: session.username,
            email: session.email,
            displayName: session.username.capitalized,
            avatarURL: nil,
            bio: nil,
            followersCount: 0,
            followingCount: 0,
            postsCount: 0,
            isVerified: false,
            createdAt: Date(),
            lastActiveAt: Date()
        )
    }
} 
