// MARK: - Social Media Template
// Complete social media app with 15+ screens, full navigation, sample data
// Features: Feed, Stories, Messages, Profile, Reels, Notifications
// Dark mode ready, localized, accessible

import SwiftUI
import Foundation
import Combine

// MARK: - Models

public struct User: Identifiable, Codable, Hashable {
    public let id: UUID
    public var username: String
    public var displayName: String
    public var avatar: String?
    public var bio: String
    public var website: String?
    public var isVerified: Bool
    public var isPrivate: Bool
    public var followersCount: Int
    public var followingCount: Int
    public var postsCount: Int
    public var isFollowing: Bool
    
    public init(
        id: UUID = UUID(),
        username: String,
        displayName: String,
        avatar: String? = nil,
        bio: String = "",
        website: String? = nil,
        isVerified: Bool = false,
        isPrivate: Bool = false,
        followersCount: Int = 0,
        followingCount: Int = 0,
        postsCount: Int = 0,
        isFollowing: Bool = false
    ) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.avatar = avatar
        self.bio = bio
        self.website = website
        self.isVerified = isVerified
        self.isPrivate = isPrivate
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.postsCount = postsCount
        self.isFollowing = isFollowing
    }
}

public struct Post: Identifiable, Codable {
    public let id: UUID
    public let author: User
    public let content: String
    public let images: [String]
    public let video: String?
    public let location: String?
    public var likesCount: Int
    public var commentsCount: Int
    public var sharesCount: Int
    public var isLiked: Bool
    public var isSaved: Bool
    public let createdAt: Date
    public let hashtags: [String]
    public let mentions: [String]
    
    public init(
        id: UUID = UUID(),
        author: User,
        content: String,
        images: [String] = [],
        video: String? = nil,
        location: String? = nil,
        likesCount: Int = 0,
        commentsCount: Int = 0,
        sharesCount: Int = 0,
        isLiked: Bool = false,
        isSaved: Bool = false,
        createdAt: Date = Date(),
        hashtags: [String] = [],
        mentions: [String] = []
    ) {
        self.id = id
        self.author = author
        self.content = content
        self.images = images
        self.video = video
        self.location = location
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.sharesCount = sharesCount
        self.isLiked = isLiked
        self.isSaved = isSaved
        self.createdAt = createdAt
        self.hashtags = hashtags
        self.mentions = mentions
    }
}

public struct Story: Identifiable, Codable {
    public let id: UUID
    public let user: User
    public let items: [StoryItem]
    public var hasUnseenItems: Bool
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        user: User,
        items: [StoryItem],
        hasUnseenItems: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.user = user
        self.items = items
        self.hasUnseenItems = hasUnseenItems
        self.createdAt = createdAt
    }
}

public struct StoryItem: Identifiable, Codable {
    public let id: UUID
    public let type: StoryType
    public let mediaURL: String
    public let duration: TimeInterval
    public var viewersCount: Int
    public var isSeen: Bool
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        type: StoryType = .image,
        mediaURL: String,
        duration: TimeInterval = 5,
        viewersCount: Int = 0,
        isSeen: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.mediaURL = mediaURL
        self.duration = duration
        self.viewersCount = viewersCount
        self.isSeen = isSeen
        self.createdAt = createdAt
    }
}

public enum StoryType: String, Codable {
    case image
    case video
}

public struct Comment: Identifiable, Codable {
    public let id: UUID
    public let author: User
    public let content: String
    public var likesCount: Int
    public var isLiked: Bool
    public let createdAt: Date
    public var replies: [Comment]
    
    public init(
        id: UUID = UUID(),
        author: User,
        content: String,
        likesCount: Int = 0,
        isLiked: Bool = false,
        createdAt: Date = Date(),
        replies: [Comment] = []
    ) {
        self.id = id
        self.author = author
        self.content = content
        self.likesCount = likesCount
        self.isLiked = isLiked
        self.createdAt = createdAt
        self.replies = replies
    }
}

public struct Conversation: Identifiable, Codable {
    public let id: UUID
    public let participants: [User]
    public var messages: [Message]
    public var lastMessage: Message?
    public var unreadCount: Int
    public let createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        participants: [User],
        messages: [Message] = [],
        lastMessage: Message? = nil,
        unreadCount: Int = 0,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.participants = participants
        self.messages = messages
        self.lastMessage = lastMessage
        self.unreadCount = unreadCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct Message: Identifiable, Codable {
    public let id: UUID
    public let senderId: UUID
    public let content: String
    public let type: MessageType
    public var isRead: Bool
    public let createdAt: Date
    public var reactions: [MessageReaction]
    
    public init(
        id: UUID = UUID(),
        senderId: UUID,
        content: String,
        type: MessageType = .text,
        isRead: Bool = false,
        createdAt: Date = Date(),
        reactions: [MessageReaction] = []
    ) {
        self.id = id
        self.senderId = senderId
        self.content = content
        self.type = type
        self.isRead = isRead
        self.createdAt = createdAt
        self.reactions = reactions
    }
}

public enum MessageType: String, Codable {
    case text
    case image
    case video
    case audio
    case sticker
    case gif
}

public struct MessageReaction: Identifiable, Codable {
    public let id: UUID
    public let userId: UUID
    public let emoji: String
    
    public init(id: UUID = UUID(), userId: UUID, emoji: String) {
        self.id = id
        self.userId = userId
        self.emoji = emoji
    }
}

public struct Notification: Identifiable, Codable {
    public let id: UUID
    public let type: NotificationType
    public let user: User
    public let post: Post?
    public let content: String
    public var isRead: Bool
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        type: NotificationType,
        user: User,
        post: Post? = nil,
        content: String,
        isRead: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.user = user
        self.post = post
        self.content = content
        self.isRead = isRead
        self.createdAt = createdAt
    }
}

public enum NotificationType: String, Codable {
    case like
    case comment
    case follow
    case mention
    case tag
    case repost
    case live
}

public struct Reel: Identifiable, Codable {
    public let id: UUID
    public let author: User
    public let videoURL: String
    public let thumbnailURL: String
    public let caption: String
    public let audioName: String
    public var likesCount: Int
    public var commentsCount: Int
    public var sharesCount: Int
    public var isLiked: Bool
    public var isSaved: Bool
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        author: User,
        videoURL: String,
        thumbnailURL: String = "",
        caption: String,
        audioName: String = "Original Audio",
        likesCount: Int = 0,
        commentsCount: Int = 0,
        sharesCount: Int = 0,
        isLiked: Bool = false,
        isSaved: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.author = author
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
        self.caption = caption
        self.audioName = audioName
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.sharesCount = sharesCount
        self.isLiked = isLiked
        self.isSaved = isSaved
        self.createdAt = createdAt
    }
}

// MARK: - Sample Data

public enum SocialSampleData {
    public static let currentUser = User(
        username: "johndoe",
        displayName: "John Doe",
        bio: "Software Developer | Coffee Lover ☕ | Building awesome apps",
        website: "johndoe.dev",
        isVerified: true,
        followersCount: 12500,
        followingCount: 850,
        postsCount: 142
    )
    
    public static let users: [User] = [
        User(username: "sarahsmith", displayName: "Sarah Smith", bio: "Photographer 📸", isVerified: true, followersCount: 45000, followingCount: 320, postsCount: 567),
        User(username: "mike_tech", displayName: "Mike Chen", bio: "Tech enthusiast", isVerified: false, followersCount: 8900, followingCount: 450, postsCount: 89),
        User(username: "emma_travels", displayName: "Emma Wilson", bio: "Travel blogger ✈️🌍", isVerified: true, followersCount: 125000, followingCount: 210, postsCount: 432),
        User(username: "alex_fitness", displayName: "Alex Johnson", bio: "Fitness Coach 💪", isVerified: false, followersCount: 67000, followingCount: 180, postsCount: 289),
        User(username: "lisa_art", displayName: "Lisa Anderson", bio: "Digital Artist 🎨", isVerified: false, followersCount: 23000, followingCount: 560, postsCount: 178)
    ]
    
    public static var posts: [Post] {
        [
            Post(author: users[0], content: "Golden hour in the city 🌅 Sometimes you just need to stop and appreciate the beauty around you. #photography #citylife #goldenhour", likesCount: 2340, commentsCount: 89, sharesCount: 45, hashtags: ["photography", "citylife", "goldenhour"]),
            Post(author: users[1], content: "Just released my new iOS app! After months of hard work, it's finally live on the App Store. Check it out! 🚀📱 #iosdev #swift #appstore", likesCount: 567, commentsCount: 43, sharesCount: 23, hashtags: ["iosdev", "swift", "appstore"]),
            Post(author: users[2], content: "Exploring the hidden gems of Tokyo 🇯🇵 This little ramen shop has been here for 50 years and serves the most amazing bowls! #travel #tokyo #ramen #foodie", likesCount: 8900, commentsCount: 234, sharesCount: 156, hashtags: ["travel", "tokyo", "ramen", "foodie"]),
            Post(author: users[3], content: "Remember: Progress, not perfection. Every rep counts, every step matters. Keep pushing! 💪🔥 #fitness #motivation #gym #workout", likesCount: 4567, commentsCount: 178, sharesCount: 89, hashtags: ["fitness", "motivation", "gym", "workout"]),
            Post(author: users[4], content: "New artwork finished! This one took about 20 hours over two weeks. Really happy with how the colors turned out 🎨✨ #digitalart #illustration #artwork", likesCount: 1890, commentsCount: 67, sharesCount: 34, hashtags: ["digitalart", "illustration", "artwork"])
        ]
    }
    
    public static var stories: [Story] {
        users.map { user in
            Story(
                user: user,
                items: [
                    StoryItem(type: .image, mediaURL: "story_\(user.username)_1", viewersCount: Int.random(in: 100...5000)),
                    StoryItem(type: .image, mediaURL: "story_\(user.username)_2", viewersCount: Int.random(in: 100...5000))
                ]
            )
        }
    }
    
    public static var reels: [Reel] {
        users.map { user in
            Reel(
                author: user,
                videoURL: "reel_\(user.username)",
                caption: "Check out this amazing moment! #viral #trending",
                audioName: "Trending Sound - Artist",
                likesCount: Int.random(in: 10000...500000),
                commentsCount: Int.random(in: 100...5000),
                sharesCount: Int.random(in: 50...2000)
            )
        }
    }
    
    public static var notifications: [Notification] {
        [
            Notification(type: .like, user: users[0], content: "liked your photo", createdAt: Date().addingTimeInterval(-300)),
            Notification(type: .follow, user: users[1], content: "started following you", createdAt: Date().addingTimeInterval(-3600)),
            Notification(type: .comment, user: users[2], content: "commented: \"This is amazing!\"", createdAt: Date().addingTimeInterval(-7200)),
            Notification(type: .mention, user: users[3], content: "mentioned you in a comment", createdAt: Date().addingTimeInterval(-14400)),
            Notification(type: .like, user: users[4], content: "and 23 others liked your photo", createdAt: Date().addingTimeInterval(-28800))
        ]
    }
    
    public static var conversations: [Conversation] {
        users.map { user in
            Conversation(
                participants: [currentUser, user],
                messages: [
                    Message(senderId: user.id, content: "Hey! How's it going?", isRead: true, createdAt: Date().addingTimeInterval(-7200)),
                    Message(senderId: currentUser.id, content: "Great! Just working on some new stuff", isRead: true, createdAt: Date().addingTimeInterval(-3600)),
                    Message(senderId: user.id, content: "Nice! Would love to see it", createdAt: Date().addingTimeInterval(-1800))
                ],
                unreadCount: Int.random(in: 0...3)
            )
        }
    }
}

// MARK: - View Models

@MainActor
public class SocialStore: ObservableObject {
    @Published public var currentUser: User = SocialSampleData.currentUser
    @Published public var posts: [Post] = SocialSampleData.posts
    @Published public var stories: [Story] = SocialSampleData.stories
    @Published public var reels: [Reel] = SocialSampleData.reels
    @Published public var notifications: [Notification] = SocialSampleData.notifications
    @Published public var conversations: [Conversation] = SocialSampleData.conversations
    @Published public var suggestedUsers: [User] = SocialSampleData.users
    @Published public var savedPosts: Set<UUID> = []
    @Published public var isLoading = false
    
    public init() {}
    
    public func toggleLike(post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].isLiked.toggle()
            posts[index].likesCount += posts[index].isLiked ? 1 : -1
        }
    }
    
    public func toggleSave(post: Post) {
        if savedPosts.contains(post.id) {
            savedPosts.remove(post.id)
        } else {
            savedPosts.insert(post.id)
        }
    }
    
    public func toggleFollow(user: User) {
        if let index = suggestedUsers.firstIndex(where: { $0.id == user.id }) {
            suggestedUsers[index].isFollowing.toggle()
        }
    }
    
    public func toggleLikeReel(reel: Reel) {
        if let index = reels.firstIndex(where: { $0.id == reel.id }) {
            reels[index].isLiked.toggle()
            reels[index].likesCount += reels[index].isLiked ? 1 : -1
        }
    }
    
    public func markNotificationAsRead(_ notification: Notification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].isRead = true
        }
    }
    
    public var unreadNotificationsCount: Int {
        notifications.filter { !$0.isRead }.count
    }
    
    public var unreadMessagesCount: Int {
        conversations.reduce(0) { $0 + $1.unreadCount }
    }
}

// MARK: - Views

// 1. Main Tab View
public struct SocialMediaHomeView: View {
    @StateObject private var store = SocialStore()
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            ReelsView()
                .tabItem {
                    Label("Reels", systemImage: "play.square.stack")
                }
                .tag(2)
            
            NotificationsView()
                .tabItem {
                    Label("Activity", systemImage: selectedTab == 3 ? "heart.fill" : "heart")
                }
                .tag(3)
                .badge(store.unreadNotificationsCount > 0 ? store.unreadNotificationsCount : 0)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tag(4)
        }
        .environmentObject(store)
    }
}

// 2. Feed View
public struct FeedView: View {
    @EnvironmentObject var store: SocialStore
    @State private var showingCreatePost = false
    @State private var showingMessages = false
    @State private var showingStoryViewer: Story?
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    // Stories
                    StoriesScrollView(showingStoryViewer: $showingStoryViewer)
                    
                    Divider()
                    
                    // Posts
                    ForEach(store.posts) { post in
                        PostView(post: post)
                        Divider()
                    }
                }
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Social")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingCreatePost = true
                    } label: {
                        Image(systemName: "plus.square")
                            .font(.title3)
                    }
                    
                    Button {
                        showingMessages = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "paperplane")
                                .font(.title3)
                            
                            if store.unreadMessagesCount > 0 {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 4, y: -4)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView()
                    .environmentObject(store)
            }
            .sheet(isPresented: $showingMessages) {
                MessagesListView()
                    .environmentObject(store)
            }
            .fullScreenCover(item: $showingStoryViewer) { story in
                StoryViewerView(story: story)
                    .environmentObject(store)
            }
        }
    }
}

// 3. Stories Scroll View
struct StoriesScrollView: View {
    @EnvironmentObject var store: SocialStore
    @Binding var showingStoryViewer: Story?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                // Your Story
                VStack(spacing: 4) {
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 68, height: 68)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .foregroundColor(.secondary)
                            )
                        
                        Circle()
                            .fill(.blue)
                            .frame(width: 22, height: 22)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                            .offset(x: 2, y: 2)
                    }
                    
                    Text("Your Story")
                        .font(.caption)
                        .lineLimit(1)
                }
                
                // Other Stories
                ForEach(store.stories) { story in
                    Button {
                        showingStoryViewer = story
                    } label: {
                        VStack(spacing: 4) {
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: story.hasUnseenItems ? [.purple, .red, .orange] : [.gray],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                                .frame(width: 72, height: 72)
                                .overlay(
                                    Circle()
                                        .fill(Color(.systemGray5))
                                        .frame(width: 66, height: 66)
                                        .overlay(
                                            Text(story.user.displayName.prefix(1))
                                                .font(.title2)
                                                .fontWeight(.semibold)
                                        )
                                )
                            
                            Text(story.user.username)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// 4. Post View
struct PostView: View {
    @EnvironmentObject var store: SocialStore
    let post: Post
    @State private var showingComments = false
    @State private var showingShareSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(post.author.displayName.prefix(1))
                            .fontWeight(.semibold)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(post.author.username)
                            .fontWeight(.semibold)
                        
                        if post.author.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                                .font(.caption)
                        }
                    }
                    
                    if let location = post.location {
                        Text(location)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Menu {
                    Button("Report", systemImage: "flag") {}
                    Button("Not Interested", systemImage: "hand.thumbsdown") {}
                    Button("Mute", systemImage: "speaker.slash") {}
                    Button(role: .destructive) {} label: {
                        Label("Block", systemImage: "nosign")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal)
            
            // Image
            Rectangle()
                .fill(Color(.systemGray6))
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                )
            
            // Actions
            HStack(spacing: 16) {
                Button {
                    store.toggleLike(post: post)
                } label: {
                    Image(systemName: post.isLiked ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(post.isLiked ? .red : .primary)
                }
                .accessibilityLabel(post.isLiked ? "Unlike" : "Like")
                
                Button {
                    showingComments = true
                } label: {
                    Image(systemName: "bubble.right")
                        .font(.title2)
                }
                .accessibilityLabel("Comments")
                
                Button {
                    showingShareSheet = true
                } label: {
                    Image(systemName: "paperplane")
                        .font(.title2)
                }
                .accessibilityLabel("Share")
                
                Spacer()
                
                Button {
                    store.toggleSave(post: post)
                } label: {
                    Image(systemName: store.savedPosts.contains(post.id) ? "bookmark.fill" : "bookmark")
                        .font(.title2)
                }
                .accessibilityLabel(store.savedPosts.contains(post.id) ? "Unsave" : "Save")
            }
            .foregroundColor(.primary)
            .padding(.horizontal)
            
            // Likes
            Text("\(post.likesCount.formatted()) likes")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            // Caption
            HStack(alignment: .top) {
                Text(post.author.username)
                    .fontWeight(.semibold)
                + Text(" ")
                + Text(post.content)
            }
            .font(.subheadline)
            .padding(.horizontal)
            .lineLimit(3)
            
            // Comments link
            if post.commentsCount > 0 {
                Button {
                    showingComments = true
                } label: {
                    Text("View all \(post.commentsCount) comments")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
            
            // Timestamp
            Text(post.createdAt, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
        .sheet(isPresented: $showingComments) {
            CommentsView(post: post)
                .environmentObject(store)
        }
    }
}

// 5. Comments View
struct CommentsView: View {
    @EnvironmentObject var store: SocialStore
    @Environment(\.dismiss) private var dismiss
    let post: Post
    @State private var newComment = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        // Original post preview
                        HStack(alignment: .top, spacing: 12) {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 36, height: 36)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(post.author.username)
                                        .fontWeight(.semibold)
                                    Text(post.createdAt, style: .relative)
                                        .foregroundColor(.secondary)
                                }
                                .font(.caption)
                                
                                Text(post.content)
                                    .font(.subheadline)
                            }
                        }
                        .padding()
                        
                        Divider()
                        
                        // Sample comments
                        ForEach(SocialSampleData.users.prefix(5)) { user in
                            CommentRow(
                                user: user,
                                content: "This is amazing! Love it! 🔥",
                                timeAgo: "2h"
                            )
                        }
                    }
                }
                
                Divider()
                
                // Comment input
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 36, height: 36)
                    
                    TextField("Add a comment...", text: $newComment)
                        .textFieldStyle(.plain)
                    
                    if !newComment.isEmpty {
                        Button("Post") {
                            newComment = ""
                        }
                        .fontWeight(.semibold)
                    }
                }
                .padding()
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CommentRow: View {
    let user: User
    let content: String
    let timeAgo: String
    @State private var isLiked = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 36, height: 36)
                .overlay(
                    Text(user.displayName.prefix(1))
                        .font(.caption)
                        .fontWeight(.semibold)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(user.username)
                        .fontWeight(.semibold)
                    Text(timeAgo)
                        .foregroundColor(.secondary)
                }
                .font(.caption)
                
                Text(content)
                    .font(.subheadline)
                
                HStack(spacing: 16) {
                    Button("Reply") {}
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button {
                isLiked.toggle()
            } label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(isLiked ? .red : .secondary)
                    .font(.caption)
            }
        }
        .padding(.horizontal)
    }
}

// 6. Story Viewer View
struct StoryViewerView: View {
    @EnvironmentObject var store: SocialStore
    @Environment(\.dismiss) private var dismiss
    let story: Story
    @State private var currentIndex = 0
    @State private var progress: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                // Story content
                Rectangle()
                    .fill(Color(.systemGray6))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 80))
                            .foregroundColor(.secondary)
                    )
                
                // Progress bars
                VStack {
                    HStack(spacing: 4) {
                        ForEach(0..<story.items.count, id: \.self) { index in
                            ProgressBar(
                                progress: index < currentIndex ? 1 : (index == currentIndex ? progress : 0)
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Header
                    HStack {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 36, height: 36)
                        
                        VStack(alignment: .leading) {
                            Text(story.user.username)
                                .fontWeight(.semibold)
                            
                            Text(story.createdAt, style: .relative)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    
                    Spacer()
                    
                    // Reply input
                    HStack(spacing: 16) {
                        TextField("Send message", text: .constant(""))
                            .textFieldStyle(.plain)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(20)
                        
                        Button {
                            // Send reaction
                        } label: {
                            Image(systemName: "heart")
                        }
                        
                        Button {
                            // Share
                        } label: {
                            Image(systemName: "paperplane")
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                }
            }
            .onTapGesture { location in
                if location.x < geometry.size.width / 2 {
                    // Previous
                    if currentIndex > 0 {
                        currentIndex -= 1
                        progress = 0
                    }
                } else {
                    // Next
                    if currentIndex < story.items.count - 1 {
                        currentIndex += 1
                        progress = 0
                    } else {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ProgressBar: View {
    let progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: geometry.size.width * min(progress, 1))
            }
        }
        .frame(height: 2)
        .cornerRadius(1)
    }
}

// 7. Explore View
struct ExploreView: View {
    @EnvironmentObject var store: SocialStore
    @State private var searchText = ""
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search", text: $searchText)
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Grid
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(0..<30, id: \.self) { index in
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(
                                    Group {
                                        if index % 5 == 0 {
                                            Image(systemName: "play.fill")
                                                .foregroundColor(.white)
                                        }
                                    }
                                )
                        }
                    }
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// 8. Reels View
struct ReelsView: View {
    @EnvironmentObject var store: SocialStore
    @State private var currentIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $currentIndex) {
                ForEach(Array(store.reels.enumerated()), id: \.element.id) { index, reel in
                    ReelView(reel: reel, geometry: geometry)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
        }
    }
}

struct ReelView: View {
    @EnvironmentObject var store: SocialStore
    let reel: Reel
    let geometry: GeometryProxy
    @State private var isMuted = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
            
            // Video placeholder
            Rectangle()
                .fill(Color(.systemGray6))
                .overlay(
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white.opacity(0.5))
                )
            
            // Overlay
            HStack(alignment: .bottom) {
                // Left side - info
                VStack(alignment: .leading, spacing: 12) {
                    Spacer()
                    
                    HStack {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 36, height: 36)
                        
                        Text(reel.author.username)
                            .fontWeight(.semibold)
                        
                        if reel.author.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption)
                        }
                        
                        Button {
                            store.toggleFollow(user: reel.author)
                        } label: {
                            Text(reel.author.isFollowing ? "Following" : "Follow")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(reel.author.isFollowing ? Color(.systemGray5) : Color.white)
                                .foregroundColor(reel.author.isFollowing ? .white : .black)
                                .cornerRadius(8)
                        }
                    }
                    
                    Text(reel.caption)
                        .font(.subheadline)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "music.note")
                        Text(reel.audioName)
                            .font(.caption)
                    }
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: geometry.size.width * 0.75, alignment: .leading)
                
                // Right side - actions
                VStack(spacing: 24) {
                    Button {
                        store.toggleLikeReel(reel: reel)
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: reel.isLiked ? "heart.fill" : "heart")
                                .font(.title)
                                .foregroundColor(reel.isLiked ? .red : .white)
                            Text(formatCount(reel.likesCount))
                                .font(.caption)
                        }
                    }
                    
                    Button {} label: {
                        VStack(spacing: 4) {
                            Image(systemName: "bubble.right")
                                .font(.title)
                            Text(formatCount(reel.commentsCount))
                                .font(.caption)
                        }
                    }
                    
                    Button {} label: {
                        VStack(spacing: 4) {
                            Image(systemName: "paperplane")
                                .font(.title)
                            Text(formatCount(reel.sharesCount))
                                .font(.caption)
                        }
                    }
                    
                    Button {} label: {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                    }
                    
                    // Audio disc
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                .foregroundColor(.white)
                .padding(.trailing)
                .padding(.bottom, 16)
            }
        }
        .onTapGesture(count: 2) {
            store.toggleLikeReel(reel: reel)
        }
    }
    
    private func formatCount(_ count: Int) -> String {
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000)
        }
        return "\(count)"
    }
}

// 9. Notifications View
struct NotificationsView: View {
    @EnvironmentObject var store: SocialStore
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(store.notifications.filter { !$0.isRead }) { notification in
                        NotificationRow(notification: notification)
                            .onTapGesture {
                                store.markNotificationAsRead(notification)
                            }
                    }
                } header: {
                    Text("New")
                }
                
                Section {
                    ForEach(store.notifications.filter { $0.isRead }) { notification in
                        NotificationRow(notification: notification)
                    }
                } header: {
                    Text("Earlier")
                }
            }
            .listStyle(.plain)
            .navigationTitle("Activity")
        }
    }
}

struct NotificationRow: View {
    let notification: Notification
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 44, height: 44)
                .overlay(
                    Text(notification.user.displayName.prefix(1))
                        .fontWeight(.semibold)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.user.username)
                        .fontWeight(.semibold)
                    + Text(" ")
                    + Text(notification.content)
                }
                .font(.subheadline)
                .lineLimit(2)
                
                Text(notification.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if notification.type == .follow {
                Button {
                    // Follow back
                } label: {
                    Text("Follow")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else if notification.post != nil {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.vertical, 4)
        .background(!notification.isRead ? Color.accentColor.opacity(0.1) : Color.clear)
    }
}

// 10. Messages List View
struct MessagesListView: View {
    @EnvironmentObject var store: SocialStore
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.conversations) { conversation in
                    NavigationLink {
                        ChatView(conversation: conversation)
                            .environmentObject(store)
                    } label: {
                        ConversationRow(conversation: conversation)
                    }
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "Search")
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // New message
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}

struct ConversationRow: View {
    let conversation: Conversation
    
    var otherUser: User? {
        conversation.participants.first { $0.id != SocialSampleData.currentUser.id }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 56, height: 56)
                .overlay(
                    Text(otherUser?.displayName.prefix(1) ?? "?")
                        .font(.title3)
                        .fontWeight(.semibold)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(otherUser?.displayName ?? "Unknown")
                    .fontWeight(.semibold)
                
                if let lastMessage = conversation.messages.last {
                    Text(lastMessage.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(conversation.updatedAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if conversation.unreadCount > 0 {
                    Text("\(conversation.unreadCount)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(6)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// 11. Chat View
struct ChatView: View {
    @EnvironmentObject var store: SocialStore
    let conversation: Conversation
    @State private var messageText = ""
    
    var otherUser: User? {
        conversation.participants.first { $0.id != SocialSampleData.currentUser.id }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(conversation.messages) { message in
                        MessageBubble(
                            message: message,
                            isFromCurrentUser: message.senderId == SocialSampleData.currentUser.id
                        )
                    }
                }
                .padding()
            }
            
            Divider()
            
            // Input
            HStack(spacing: 12) {
                Button {} label: {
                    Image(systemName: "camera.fill")
                }
                
                TextField("Message...", text: $messageText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                
                if messageText.isEmpty {
                    Button {} label: {
                        Image(systemName: "mic.fill")
                    }
                    
                    Button {} label: {
                        Image(systemName: "photo")
                    }
                } else {
                    Button {
                        // Send message
                        messageText = ""
                    } label: {
                        Text("Send")
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(otherUser?.displayName ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {} label: {
                        Image(systemName: "phone")
                    }
                    
                    Button {} label: {
                        Image(systemName: "video")
                    }
                }
            }
        }
    }
}

struct MessageBubble: View {
    let message: Message
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser { Spacer() }
            
            Text(message.content)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isFromCurrentUser ? Color.accentColor : Color(.systemGray5))
                .foregroundColor(isFromCurrentUser ? .white : .primary)
                .cornerRadius(20)
            
            if !isFromCurrentUser { Spacer() }
        }
    }
}

// 12. Profile View
public struct ProfileView: View {
    @EnvironmentObject var store: SocialStore
    @State private var selectedTab = 0
    @State private var showingSettings = false
    @State private var showingEditProfile = false
    
    public init() {}
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Profile header
                    HStack(spacing: 24) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 86, height: 86)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                            )
                        
                        HStack(spacing: 24) {
                            VStack {
                                Text("\(store.currentUser.postsCount)")
                                    .font(.headline)
                                Text("Posts")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack {
                                Text(formatCount(store.currentUser.followersCount))
                                    .font(.headline)
                                Text("Followers")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack {
                                Text(formatCount(store.currentUser.followingCount))
                                    .font(.headline)
                                Text("Following")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Bio
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(store.currentUser.displayName)
                                .fontWeight(.semibold)
                            
                            if store.currentUser.isVerified {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Text(store.currentUser.bio)
                            .font(.subheadline)
                        
                        if let website = store.currentUser.website {
                            Link(website, destination: URL(string: "https://\(website)")!)
                                .font(.subheadline)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Action buttons
                    HStack(spacing: 8) {
                        Button {
                            showingEditProfile = true
                        } label: {
                            Text("Edit Profile")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        Button {} label: {
                            Text("Share Profile")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    
                    // Story highlights
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // Add highlight
                            VStack(spacing: 4) {
                                Circle()
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                                    .frame(width: 64, height: 64)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .font(.title3)
                                    )
                                
                                Text("New")
                                    .font(.caption)
                            }
                            
                            // Highlights
                            ForEach(["Travel", "Food", "Work", "Music"], id: \.self) { highlight in
                                VStack(spacing: 4) {
                                    Circle()
                                        .fill(Color(.systemGray5))
                                        .frame(width: 64, height: 64)
                                    
                                    Text(highlight)
                                        .font(.caption)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Tabs
                    HStack {
                        ForEach(["square.grid.3x3", "play.square", "person.crop.rectangle"], id: \.self) { icon in
                            Button {
                                // Tab selection
                            } label: {
                                Image(systemName: icon)
                                    .font(.title3)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    
                    Divider()
                    
                    // Grid
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(0..<15, id: \.self) { index in
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
            .navigationTitle(store.currentUser.username)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Settings", systemImage: "gearshape") {
                            showingSettings = true
                        }
                        Button("Saved", systemImage: "bookmark") {}
                        Button("Archive", systemImage: "archivebox") {}
                        Button("Your Activity", systemImage: "clock") {}
                        Button("QR Code", systemImage: "qrcode") {}
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
                    .environmentObject(store)
            }
        }
    }
    
    private func formatCount(_ count: Int) -> String {
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000)
        }
        return "\(count)"
    }
}

// 13. Edit Profile View
struct EditProfileView: View {
    @EnvironmentObject var store: SocialStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var displayName: String = ""
    @State private var username: String = ""
    @State private var bio: String = ""
    @State private var website: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.title)
                                        .foregroundColor(.secondary)
                                )
                            
                            Button("Change Photo") {}
                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
                
                Section {
                    TextField("Name", text: $displayName)
                    TextField("Username", text: $username)
                    TextField("Bio", text: $bio, axis: .vertical)
                        .lineLimit(3...5)
                    TextField("Website", text: $website)
                }
                
                Section {
                    NavigationLink("Switch to Professional Account") {}
                    NavigationLink("Personal Information Settings") {}
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Save changes
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                displayName = store.currentUser.displayName
                username = store.currentUser.username
                bio = store.currentUser.bio
                website = store.currentUser.website ?? ""
            }
        }
    }
}

// 14. Settings View
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        // Account center
                    } label: {
                        HStack {
                            Image(systemName: "person.badge.shield.checkmark")
                                .font(.title2)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading) {
                                Text("Accounts Center")
                                    .fontWeight(.semibold)
                                Text("Password, security, personal details")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section("How you use the app") {
                    NavigationLink("Saved", systemImage: "bookmark") {}
                    NavigationLink("Archive", systemImage: "archivebox") {}
                    NavigationLink("Your Activity", systemImage: "clock") {}
                    NavigationLink("Notifications", systemImage: "bell") {}
                    NavigationLink("Time Management", systemImage: "hourglass") {}
                }
                
                Section("Who can see your content") {
                    NavigationLink("Account Privacy", systemImage: "lock") {}
                    NavigationLink("Close Friends", systemImage: "star") {}
                    NavigationLink("Blocked", systemImage: "nosign") {}
                    NavigationLink("Hide Story and Live", systemImage: "eye.slash") {}
                }
                
                Section("What you see") {
                    NavigationLink("Favorites", systemImage: "heart") {}
                    NavigationLink("Muted Accounts", systemImage: "speaker.slash") {}
                    NavigationLink("Suggested Content", systemImage: "sparkles") {}
                    NavigationLink("Like and Share Counts", systemImage: "number") {}
                }
                
                Section("Your app and media") {
                    NavigationLink("Device Permissions", systemImage: "gear") {}
                    NavigationLink("Archiving and Downloading", systemImage: "arrow.down.circle") {}
                    NavigationLink("Language", systemImage: "globe") {}
                    NavigationLink("Data Usage", systemImage: "chart.bar") {}
                }
                
                Section {
                    Button("Add Account", systemImage: "person.badge.plus") {}
                    Button("Log Out", systemImage: "rectangle.portrait.and.arrow.right", role: .destructive) {}
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// 15. Create Post View
struct CreatePostView: View {
    @EnvironmentObject var store: SocialStore
    @Environment(\.dismiss) private var dismiss
    @State private var caption = ""
    @State private var selectedImage: Int?
    
    var body: some View {
        NavigationStack {
            VStack {
                // Selected image
                Rectangle()
                    .fill(Color(.systemGray6))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                    )
                
                // Caption
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 36, height: 36)
                    
                    TextField("Write a caption...", text: $caption, axis: .vertical)
                        .lineLimit(5...10)
                }
                .padding()
                
                Divider()
                
                // Options
                List {
                    NavigationLink("Tag People") {
                        // Tag people view
                    }
                    
                    NavigationLink("Add Location") {
                        // Location view
                    }
                    
                    NavigationLink("Add Music") {
                        // Music view
                    }
                    
                    Toggle("Also post to Facebook", isOn: .constant(false))
                    Toggle("Also post to Twitter", isOn: .constant(false))
                }
                .listStyle(.plain)
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Share") {
                        // Create post
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// 16. User Profile View (viewing other users)
struct UserProfileView: View {
    @EnvironmentObject var store: SocialStore
    let user: User
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Profile header
                HStack(spacing: 24) {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 86, height: 86)
                        .overlay(
                            Text(user.displayName.prefix(1))
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                        )
                    
                    HStack(spacing: 24) {
                        VStack {
                            Text("\(user.postsCount)")
                                .font(.headline)
                            Text("Posts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text(formatCount(user.followersCount))
                                .font(.headline)
                            Text("Followers")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text(formatCount(user.followingCount))
                                .font(.headline)
                            Text("Following")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Bio
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(user.displayName)
                            .fontWeight(.semibold)
                        
                        if user.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Text(user.bio)
                        .font(.subheadline)
                    
                    if let website = user.website {
                        Link(website, destination: URL(string: "https://\(website)")!)
                            .font(.subheadline)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Action buttons
                HStack(spacing: 8) {
                    Button {
                        store.toggleFollow(user: user)
                    } label: {
                        Text(user.isFollowing ? "Following" : "Follow")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(user.isFollowing ? Color(.systemGray6) : Color.accentColor)
                            .foregroundColor(user.isFollowing ? .primary : .white)
                            .cornerRadius(8)
                    }
                    
                    Button {} label: {
                        Text("Message")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .foregroundColor(.primary)
                }
                .padding(.horizontal)
                
                // Tabs and Grid
                Divider()
                
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(0..<12, id: \.self) { index in
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatCount(_ count: Int) -> String {
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000)
        }
        return "\(count)"
    }
}

// MARK: - App Entry Point

public struct SocialMediaApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            SocialMediaHomeView()
        }
    }
}
