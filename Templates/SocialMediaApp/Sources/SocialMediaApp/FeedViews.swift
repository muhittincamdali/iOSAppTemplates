import Foundation
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Feed")
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
                .tag(1)
            
            CreatePostView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Create")
                }
                .tag(2)
            
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
                .badge(notificationManager.notifications.filter(\.isUnread).count)
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(.blue)
    }
}

// MARK: - Feed View
struct FeedView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showCreatePost = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(dataManager.posts) { post in
                        PostCard(post: post)
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCreatePost = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .refreshable {
                await dataManager.refreshFeed()
            }
            .sheet(isPresented: $showCreatePost) {
                CreatePostView()
            }
        }
    }
}

// MARK: - Post Card
struct PostCard: View {
    let post: Post
    @StateObject private var dataManager = DataManager.shared
    @State private var showComments = false
    
    private var currentPost: Post {
        dataManager.posts.first(where: { $0.id == post.id }) ?? post
    }
    
    private var isLiked: Bool {
        dataManager.likedPostIDs.contains(currentPost.id)
    }
    
    private var isBookmarked: Bool {
        dataManager.bookmarkedPostIDs.contains(currentPost.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                AsyncImage(url: URL(string: currentPost.authorAvatarURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.gray)
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(currentPost.authorDisplayName)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        if currentPost.authorIsVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                                .font(.caption)
                        }
                    }
                    
                    Text("@\(currentPost.authorUsername)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(currentPost.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Content
            Text(currentPost.content)
                .font(.body)
                .multilineTextAlignment(.leading)
            
            // Media
            if let images = currentPost.images, !images.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(images, id: \.self) { imageURL in
                            AsyncImage(url: URL(string: imageURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            // Actions
            HStack(spacing: 20) {
                Button {
                    dataManager.toggleLike(postID: currentPost.id)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .primary)
                        Text("\(currentPost.likesCount)")
                            .font(.caption)
                    }
                }
                
                Button {
                    showComments = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.left")
                        Text("\(currentPost.commentsCount)")
                            .font(.caption)
                    }
                }
                
                Button {
                    dataManager.sharePost(postID: currentPost.id)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrowshape.turn.up.right")
                        Text("\(currentPost.sharesCount)")
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Button {
                    dataManager.toggleBookmark(postID: currentPost.id)
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(isBookmarked ? .blue : .primary)
                }
            }
            .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
        .sheet(isPresented: $showComments) {
            CommentsView(post: currentPost)
        }
    }
}
