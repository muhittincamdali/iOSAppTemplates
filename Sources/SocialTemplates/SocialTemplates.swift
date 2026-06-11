import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif

private func jpegData(from image: PlatformImage, compressionQuality: Double) -> Data? {
#if canImport(UIKit)
    image.jpegData(compressionQuality: compressionQuality)
#elseif canImport(AppKit)
    guard let tiffData = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiffData) else {
        return nil
    }
    return bitmap.representation(
        using: .jpeg,
        properties: [.compressionFactor: compressionQuality]
    )
#endif
}

// MARK: - Social Templates
public struct SocialTemplates {
    
    // MARK: - Version
    public static let version = "2.1.0"
    
    // MARK: - Initialization
    public static func initialize() {
        print("📱 Social Templates v\(version) initialized")
    }
}

// MARK: - Social Media App Template
public struct SocialMediaAppTemplate {
    
    // MARK: - Models
    public struct User: Identifiable, Codable {
        public let id: String
        public let username: String
        public let email: String
        public let displayName: String
        public let avatarURL: String?
        public let bio: String?
        public let followersCount: Int
        public let followingCount: Int
        public let postsCount: Int
        public let isVerified: Bool
        public let createdAt: Date
        public let lastActiveAt: Date
        
        public init(
            id: String,
            username: String,
            email: String,
            displayName: String,
            avatarURL: String? = nil,
            bio: String? = nil,
            followersCount: Int = 0,
            followingCount: Int = 0,
            postsCount: Int = 0,
            isVerified: Bool = false,
            createdAt: Date = Date(),
            lastActiveAt: Date = Date()
        ) {
            self.id = id
            self.username = username
            self.email = email
            self.displayName = displayName
            self.avatarURL = avatarURL
            self.bio = bio
            self.followersCount = followersCount
            self.followingCount = followingCount
            self.postsCount = postsCount
            self.isVerified = isVerified
            self.createdAt = createdAt
            self.lastActiveAt = lastActiveAt
        }
    }
    
    public struct Post: Identifiable, Codable {
        public let id: String
        public let authorId: String
        public let authorUsername: String
        public let authorDisplayName: String
        public let authorAvatarURL: String?
        public let content: String
        public let images: [String]?
        public let videoURL: String?
        public var likesCount: Int
        public let commentsCount: Int
        public let sharesCount: Int
        public var isLiked: Bool
        public let isBookmarked: Bool
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String,
            authorId: String,
            authorUsername: String,
            authorDisplayName: String,
            authorAvatarURL: String? = nil,
            content: String,
            images: [String]? = nil,
            videoURL: String? = nil,
            likesCount: Int = 0,
            commentsCount: Int = 0,
            sharesCount: Int = 0,
            isLiked: Bool = false,
            isBookmarked: Bool = false,
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.authorId = authorId
            self.authorUsername = authorUsername
            self.authorDisplayName = authorDisplayName
            self.authorAvatarURL = authorAvatarURL
            self.content = content
            self.images = images
            self.videoURL = videoURL
            self.likesCount = likesCount
            self.commentsCount = commentsCount
            self.sharesCount = sharesCount
            self.isLiked = isLiked
            self.isBookmarked = isBookmarked
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
    
    // MARK: - Managers
    @MainActor
    public class SocialAuthManager: ObservableObject {
        
        @Published public var currentUser: User?
        @Published public var isAuthenticated = false
        @Published public var isLoading = false
        
        public init() {}
        
        // MARK: - Authentication Methods
        
        public func signUp(email: String, password: String, username: String, displayName: String) async throws -> User {
            isLoading = true
            defer { isLoading = false }
            
            // Native implementation stub
            let userData = User(
                id: UUID().uuidString,
                username: username,
                email: email,
                displayName: displayName
            )
            
            currentUser = userData
            isAuthenticated = true
            
            return userData
        }
        
        public func signIn(email: String, password: String) async throws -> User {
            isLoading = true
            defer { isLoading = false }
            
            // Native implementation stub
            let userData = User(
                id: UUID().uuidString,
                username: "demo_user",
                email: email,
                displayName: "Demo User"
            )
            
            currentUser = userData
            isAuthenticated = true
            
            return userData
        }
        
        public func signOut() throws {
            currentUser = nil
            isAuthenticated = false
        }
        
        public func resetPassword(email: String) async throws {
            // Native implementation stub
        }
    }
    
    @MainActor
    public class SocialPostManager: ObservableObject {
        
        @Published public var posts: [Post] = []
        @Published public var isLoading = false
        
        public init() {}
        
        // MARK: - Post Methods
        
        public func createPost(content: String, images: [PlatformImage]? = nil) async throws -> Post {
            isLoading = true
            defer { isLoading = false }
            
            let post = Post(
                id: UUID().uuidString,
                authorId: "current_user",
                authorUsername: "user",
                authorDisplayName: "User",
                content: content
            )
            
            posts.insert(post, at: 0)
            return post
        }
        
        public func fetchPosts() async throws {
            isLoading = true
            defer { isLoading = false }
            
            // Native implementation stub
            self.posts = [
                Post(id: "1", authorId: "1", authorUsername: "swift_guru", authorDisplayName: "Swift Guru", content: "Native is better than bloated SDKs!"),
                Post(id: "2", authorId: "2", authorUsername: "ios_ninja", authorDisplayName: "iOS Ninja", content: "Purged 300MB of Firebase from this template.")
            ]
        }
        
        public func likePost(_ post: Post) async throws {
            if let index = posts.firstIndex(where: { $0.id == post.id }) {
                posts[index].isLiked.toggle()
                posts[index].likesCount += posts[index].isLiked ? 1 : -1
            }
        }
        
        public func deletePost(_ post: Post) async throws {
            posts.removeAll { $0.id == post.id }
        }
    }
    
    // MARK: - UI Components
    
    public struct PostCard: View {
        let post: Post
        let onLike: () -> Void
        let onComment: () -> Void
        let onShare: () -> Void
        let onBookmark: () -> Void
        
        public init(
            post: Post,
            onLike: @escaping () -> Void,
            onComment: @escaping () -> Void,
            onShare: @escaping () -> Void,
            onBookmark: @escaping () -> Void
        ) {
            self.post = post
            self.onLike = onLike
            self.onComment = onComment
            self.onShare = onShare
            self.onBookmark = onBookmark
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    if let avatarURL = post.authorAvatarURL {
                        AsyncImage(url: URL(string: avatarURL)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(post.authorDisplayName)
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        Text("@\(post.authorUsername)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(post.createdAt, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Content
                Text(post.content)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
                // Images
                if let images = post.images, !images.isEmpty {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: min(images.count, 3)), spacing: 8) {
                        ForEach(images.prefix(3), id: \.self) { imageURL in
                            AsyncImage(url: URL(string: imageURL)) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray.opacity(0.1)
                            }
                            .frame(height: 120)
                            .clipped()
                            .cornerRadius(8)
                        }
                    }
                }
                
                // Actions
                HStack(spacing: 20) {
                    Button(action: onLike) {
                        HStack(spacing: 4) {
                            Image(systemName: post.isLiked ? "heart.fill" : "heart")
                                .foregroundColor(post.isLiked ? .red : .primary)
                            Text("\(post.likesCount)")
                                .font(.caption)
                        }
                    }
                    
                    Button(action: onComment) {
                        HStack(spacing: 4) {
                            Image(systemName: "bubble.left")
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: onBookmark) {
                        Image(systemName: post.isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(post.isBookmarked ? .blue : .primary)
                    }
                }
                .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.04))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Errors
    
    public enum SocialError: LocalizedError {
        case userNotFound
        case userNotAuthenticated
        case unauthorized
        case networkError
        case invalidData
        
        public var errorDescription: String? {
            switch self {
            case .userNotFound:
                return "User not found"
            case .userNotAuthenticated:
                return "User not authenticated"
            case .unauthorized:
                return "Unauthorized action"
            case .networkError:
                return "Network error occurred"
            case .invalidData:
                return "Invalid data"
            }
        }
    }
} 
