import Foundation
import SwiftUI

@MainActor
class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var posts: [Post] = []
    @Published var trendingTopics: [String] = []
    @Published var suggestedProfiles: [SuggestedProfile] = []
    @Published var commentsByPostId: [String: [PostComment]] = [:]
    @Published var likedPostIDs: Set<String> = []
    @Published var bookmarkedPostIDs: Set<String> = []
    @Published var followedProfileIDs: Set<String> = []
    
    init() {}
    
    func initialize() async {
        if posts.isEmpty {
            seedPreviewState(currentUser: nil)
        }
    }
    
    func refreshFeed() async {
        try? await Task.sleep(for: .milliseconds(250))
        if posts.isEmpty {
            seedPreviewState(currentUser: nil)
        }
    }
    
    func addPost(content: String, author: PostAuthor) {
        let post = Post(
            id: UUID().uuidString,
            authorId: "current-user",
            authorUsername: author.username,
            authorDisplayName: author.name,
            authorAvatarURL: nil,
            authorIsVerified: author.isVerified,
            content: content,
            images: ["mountain.2.fill"],
            videoURL: nil,
            likesCount: 0,
            commentsCount: 0,
            sharesCount: 0,
            createdAt: Date(),
            updatedAt: Date()
        )
        posts.insert(post, at: 0)
        commentsByPostId[post.id] = []
    }
    
    func publishPost(content: String, author: PostAuthor, audience: String, attachmentCount: Int) {
        let decoratedContent = "[\(audience)] \(content)\n\nAttached assets: \(attachmentCount)"
        addPost(content: decoratedContent, author: author)
    }
    
    func profilePosts(for username: String) -> [Post] {
        posts.filter { $0.authorUsername == username }
    }
    
    func comments(for postId: String) -> [PostComment] {
        commentsByPostId[postId] ?? []
    }
    
    func addComment(body: String, to postId: String) {
        let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let comment = PostComment(
            id: UUID().uuidString,
            authorName: "Preview User",
            authorUsername: "preview",
            body: trimmed,
            likesCount: 0,
            createdAt: Date()
        )
        commentsByPostId[postId, default: []].append(comment)
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].commentsCount += 1
        }
    }
    
    func toggleLike(postID: String) {
        guard let index = posts.firstIndex(where: { $0.id == postID }) else { return }
        if likedPostIDs.contains(postID) {
            likedPostIDs.remove(postID)
            posts[index].likesCount = max(0, posts[index].likesCount - 1)
        } else {
            likedPostIDs.insert(postID)
            posts[index].likesCount += 1
        }
    }
    
    func toggleBookmark(postID: String) {
        if bookmarkedPostIDs.contains(postID) {
            bookmarkedPostIDs.remove(postID)
        } else {
            bookmarkedPostIDs.insert(postID)
        }
    }
    
    func sharePost(postID: String) {
        guard let index = posts.firstIndex(where: { $0.id == postID }) else { return }
        posts[index].sharesCount += 1
    }
    
    func toggleFollow(profileID: String) {
        guard let index = suggestedProfiles.firstIndex(where: { $0.id == profileID }) else { return }
        if followedProfileIDs.contains(profileID) {
            followedProfileIDs.remove(profileID)
            suggestedProfiles[index].followersCount = max(0, suggestedProfiles[index].followersCount - 1)
        } else {
            followedProfileIDs.insert(profileID)
            suggestedProfiles[index].followersCount += 1
        }
    }
    
    func seedPreviewState(currentUser: User?) {
        posts = [
            Post(
                id: "1",
                authorId: "user1",
                authorUsername: "johndoe",
                authorDisplayName: "John Doe",
                authorAvatarURL: nil,
                authorIsVerified: true,
                content: "Just launched my new app! 🚀 It's been an amazing journey building this. Can't wait to see how it helps people connect and share their stories.",
                images: ["cup.and.saucer.fill"],
                videoURL: nil,
                likesCount: 42,
                commentsCount: 8,
                sharesCount: 3,
                createdAt: Date().addingTimeInterval(-3600),
                updatedAt: Date().addingTimeInterval(-3600)
            ),
            Post(
                id: "2",
                authorId: "user2",
                authorUsername: "sarahsmith",
                authorDisplayName: "Sarah Smith",
                authorAvatarURL: nil,
                authorIsVerified: false,
                content: "Beautiful sunset today! 🌅 Nature always finds a way to amaze us. What's your favorite time of day?",
                images: ["camera.fill", "leaf.fill"],
                videoURL: nil,
                likesCount: 128,
                commentsCount: 15,
                sharesCount: 7,
                createdAt: Date().addingTimeInterval(-7200),
                updatedAt: Date().addingTimeInterval(-7200)
            ),
            Post(
                id: "3",
                authorId: "user3",
                authorUsername: "mikejohnson",
                authorDisplayName: "Mike Johnson",
                authorAvatarURL: nil,
                authorIsVerified: true,
                content: "Just finished reading an incredible book about AI and the future of technology. The insights are mind-blowing! 📚🤖",
                images: nil,
                videoURL: nil,
                likesCount: 89,
                commentsCount: 12,
                sharesCount: 5,
                createdAt: Date().addingTimeInterval(-10800),
                updatedAt: Date().addingTimeInterval(-10800)
            )
        ]
        
        if let currentUser {
            posts.insert(
                Post(
                    id: "preview-post",
                    authorId: currentUser.id,
                    authorUsername: currentUser.username,
                    authorDisplayName: currentUser.displayName,
                    authorAvatarURL: currentUser.avatarURL,
                    authorIsVerified: currentUser.isVerified,
                    content: "Small releases every week. The new profile screen is next.",
                    images: ["sun.max.fill"],
                    videoURL: nil,
                    likesCount: 64,
                    commentsCount: 9,
                    sharesCount: 4,
                    createdAt: Date().addingTimeInterval(-1800),
                    updatedAt: Date().addingTimeInterval(-1800)
                ),
                at: 0
            )
        }
        
        trendingTopics = [
            "BuildInPublic", "SwiftUI", "iOSDesign", "ProductStrategy", "AIWorkflows", "CreatorTools"
        ]
        
        suggestedProfiles = [
            SuggestedProfile(
                id: "p1",
                username: "amberdesign",
                displayName: "Amber Design",
                bio: "Mobile product designer sharing systems, motion, and interface teardown threads.",
                avatarURL: nil,
                isVerified: true,
                followersCount: 12800
            ),
            SuggestedProfile(
                id: "p2",
                username: "swiftfoundry",
                displayName: "Swift Foundry",
                bio: "Weekly SwiftUI experiments, architecture notes, and native product case studies.",
                avatarURL: nil,
                isVerified: false,
                followersCount: 7400
            ),
            SuggestedProfile(
                id: "p3",
                username: "opsforapps",
                displayName: "Ops For Apps",
                bio: "Notes on release hygiene and product operations.",
                avatarURL: nil,
                isVerified: true,
                followersCount: 18300
            )
        ]
        
        commentsByPostId = [
            "1": [
                PostComment(id: "c1", authorName: "Nina", authorUsername: "ninabuilds", body: "The onboarding flow looks much sharper now.", likesCount: 12, createdAt: Date().addingTimeInterval(-2500)),
                PostComment(id: "c2", authorName: "Leo", authorUsername: "leoproduct", body: "Would love to see the second screen interaction too.", likesCount: 6, createdAt: Date().addingTimeInterval(-1800))
            ],
            "2": [
                PostComment(id: "c3", authorName: "Maya", authorUsername: "mayastudio", body: "That color palette is unreal.", likesCount: 18, createdAt: Date().addingTimeInterval(-6000))
            ],
            "3": [
                PostComment(id: "c4", authorName: "Aria", authorUsername: "ariareads", body: "Drop the reading list when you can.", likesCount: 4, createdAt: Date().addingTimeInterval(-9000))
            ],
            "preview-post": [
                PostComment(id: "c5", authorName: "Sam", authorUsername: "samship", body: "Agreed. Small steps add up.", likesCount: 10, createdAt: Date().addingTimeInterval(-1200))
            ]
        ]
        likedPostIDs = ["2"]
        bookmarkedPostIDs = ["preview-post"]
        followedProfileIDs = ["p1"]
    }
}
