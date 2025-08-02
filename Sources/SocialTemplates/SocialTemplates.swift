import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Kingfisher

// MARK: - Social Templates
public struct SocialTemplates {
    
    // MARK: - Version
    public static let version = "1.0.0"
    
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
        public let likesCount: Int
        public let commentsCount: Int
        public let sharesCount: Int
        public let isLiked: Bool
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
    
    public struct Comment: Identifiable, Codable {
        public let id: String
        public let postId: String
        public let authorId: String
        public let authorUsername: String
        public let authorDisplayName: String
        public let authorAvatarURL: String?
        public let content: String
        public let likesCount: Int
        public let isLiked: Bool
        public let createdAt: Date
        
        public init(
            id: String,
            postId: String,
            authorId: String,
            authorUsername: String,
            authorDisplayName: String,
            authorAvatarURL: String? = nil,
            content: String,
            likesCount: Int = 0,
            isLiked: Bool = false,
            createdAt: Date = Date()
        ) {
            self.id = id
            self.postId = postId
            self.authorId = authorId
            self.authorUsername = authorUsername
            self.authorDisplayName = authorDisplayName
            self.authorAvatarURL = authorAvatarURL
            self.content = content
            self.likesCount = likesCount
            self.isLiked = isLiked
            self.createdAt = createdAt
        }
    }
    
    // MARK: - Managers
    public class SocialAuthManager: ObservableObject {
        
        @Published public var currentUser: User?
        @Published public var isAuthenticated = false
        @Published public var isLoading = false
        
        private let auth = Auth.auth()
        private let db = Firestore.firestore()
        
        public init() {}
        
        // MARK: - Authentication Methods
        
        public func signUp(email: String, password: String, username: String, displayName: String) async throws -> User {
            isLoading = true
            defer { isLoading = false }
            
            let result = try await auth.createUser(withEmail: email, password: password)
            let user = result.user
            
            let userData = User(
                id: user.uid,
                username: username,
                email: email,
                displayName: displayName
            )
            
            try await saveUserToFirestore(userData)
            currentUser = userData
            isAuthenticated = true
            
            return userData
        }
        
        public func signIn(email: String, password: String) async throws -> User {
            isLoading = true
            defer { isLoading = false }
            
            let result = try await auth.signIn(withEmail: email, password: password)
            let user = result.user
            
            let userData = try await getUserFromFirestore(userId: user.uid)
            currentUser = userData
            isAuthenticated = true
            
            return userData
        }
        
        public func signOut() throws {
            try auth.signOut()
            currentUser = nil
            isAuthenticated = false
        }
        
        public func resetPassword(email: String) async throws {
            try await auth.sendPasswordReset(withEmail: email)
        }
        
        // MARK: - Firestore Methods
        
        private func saveUserToFirestore(_ user: User) async throws {
            try await db.collection("users").document(user.id).setData([
                "username": user.username,
                "email": user.email,
                "displayName": user.displayName,
                "avatarURL": user.avatarURL ?? "",
                "bio": user.bio ?? "",
                "followersCount": user.followersCount,
                "followingCount": user.followingCount,
                "postsCount": user.postsCount,
                "isVerified": user.isVerified,
                "createdAt": user.createdAt,
                "lastActiveAt": user.lastActiveAt
            ])
        }
        
        private func getUserFromFirestore(userId: String) async throws -> User {
            let document = try await db.collection("users").document(userId).getDocument()
            
            guard let data = document.data() else {
                throw SocialError.userNotFound
            }
            
            return User(
                id: userId,
                username: data["username"] as? String ?? "",
                email: data["email"] as? String ?? "",
                displayName: data["displayName"] as? String ?? "",
                avatarURL: data["avatarURL"] as? String,
                bio: data["bio"] as? String,
                followersCount: data["followersCount"] as? Int ?? 0,
                followingCount: data["followingCount"] as? Int ?? 0,
                postsCount: data["postsCount"] as? Int ?? 0,
                isVerified: data["isVerified"] as? Bool ?? false,
                createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                lastActiveAt: (data["lastActiveAt"] as? Timestamp)?.dateValue() ?? Date()
            )
        }
    }
    
    public class SocialPostManager: ObservableObject {
        
        @Published public var posts: [Post] = []
        @Published public var isLoading = false
        
        private let db = Firestore.firestore()
        private let storage = Storage.storage()
        
        public init() {}
        
        // MARK: - Post Methods
        
        public func createPost(content: String, images: [UIImage]? = nil) async throws -> Post {
            guard let currentUser = SocialAuthManager().currentUser else {
                throw SocialError.userNotAuthenticated
            }
            
            isLoading = true
            defer { isLoading = false }
            
            var imageURLs: [String] = []
            
            if let images = images {
                for (index, image) in images.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        let fileName = "posts/\(UUID().uuidString)_\(index).jpg"
                        let imageRef = storage.reference().child(fileName)
                        let _ = try await imageRef.putDataAsync(imageData)
                        let downloadURL = try await imageRef.downloadURL()
                        imageURLs.append(downloadURL.absoluteString)
                    }
                }
            }
            
            let post = Post(
                id: UUID().uuidString,
                authorId: currentUser.id,
                authorUsername: currentUser.username,
                authorDisplayName: currentUser.displayName,
                authorAvatarURL: currentUser.avatarURL,
                content: content,
                images: imageURLs.isEmpty ? nil : imageURLs
            )
            
            try await savePostToFirestore(post)
            posts.insert(post, at: 0)
            
            return post
        }
        
        public func fetchPosts() async throws {
            isLoading = true
            defer { isLoading = false }
            
            let snapshot = try await db.collection("posts")
                .order(by: "createdAt", descending: true)
                .limit(to: 50)
                .getDocuments()
            
            posts = snapshot.documents.compactMap { document in
                let data = document.data()
                
                return Post(
                    id: document.documentID,
                    authorId: data["authorId"] as? String ?? "",
                    authorUsername: data["authorUsername"] as? String ?? "",
                    authorDisplayName: data["authorDisplayName"] as? String ?? "",
                    authorAvatarURL: data["authorAvatarURL"] as? String,
                    content: data["content"] as? String ?? "",
                    images: data["images"] as? [String],
                    videoURL: data["videoURL"] as? String,
                    likesCount: data["likesCount"] as? Int ?? 0,
                    commentsCount: data["commentsCount"] as? Int ?? 0,
                    sharesCount: data["sharesCount"] as? Int ?? 0,
                    isLiked: data["isLiked"] as? Bool ?? false,
                    isBookmarked: data["isBookmarked"] as? Bool ?? false,
                    createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                    updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
                )
            }
        }
        
        public func likePost(_ post: Post) async throws {
            guard let currentUser = SocialAuthManager().currentUser else {
                throw SocialError.userNotAuthenticated
            }
            
            let postRef = db.collection("posts").document(post.id)
            let likeRef = postRef.collection("likes").document(currentUser.id)
            
            if post.isLiked {
                try await likeRef.delete()
                try await postRef.updateData([
                    "likesCount": FieldValue.increment(Int64(-1))
                ])
            } else {
                try await likeRef.setData([
                    "userId": currentUser.id,
                    "createdAt": FieldValue.serverTimestamp()
                ])
                try await postRef.updateData([
                    "likesCount": FieldValue.increment(Int64(1))
                ])
            }
            
            // Update local state
            if let index = posts.firstIndex(where: { $0.id == post.id }) {
                posts[index].isLiked.toggle()
                posts[index].likesCount += posts[index].isLiked ? 1 : -1
            }
        }
        
        public func deletePost(_ post: Post) async throws {
            guard let currentUser = SocialAuthManager().currentUser,
                  post.authorId == currentUser.id else {
                throw SocialError.unauthorized
            }
            
            try await db.collection("posts").document(post.id).delete()
            posts.removeAll { $0.id == post.id }
        }
        
        // MARK: - Firestore Methods
        
        private func savePostToFirestore(_ post: Post) async throws {
            try await db.collection("posts").document(post.id).setData([
                "authorId": post.authorId,
                "authorUsername": post.authorUsername,
                "authorDisplayName": post.authorDisplayName,
                "authorAvatarURL": post.authorAvatarURL ?? "",
                "content": post.content,
                "images": post.images ?? [],
                "videoURL": post.videoURL ?? "",
                "likesCount": post.likesCount,
                "commentsCount": post.commentsCount,
                "sharesCount": post.sharesCount,
                "isLiked": post.isLiked,
                "isBookmarked": post.isBookmarked,
                "createdAt": post.createdAt,
                "updatedAt": post.updatedAt
            ])
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
                        KFImage(URL(string: avatarURL))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
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
                            
                            if post.authorUsername == "verified" {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                            }
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
                            KFImage(URL(string: imageURL))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
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
                            Text("\(post.commentsCount)")
                                .font(.caption)
                        }
                    }
                    
                    Button(action: onShare) {
                        HStack(spacing: 4) {
                            Image(systemName: "square.and.arrow.up")
                            Text("\(post.sharesCount)")
                                .font(.caption)
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
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
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