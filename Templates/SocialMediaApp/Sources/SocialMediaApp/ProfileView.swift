import Foundation
import SwiftUI

struct ProfileView: View {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let user = authManager.currentUser {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(user.displayName)
                                    .font(.title2.weight(.bold))
                                if user.isVerified {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            Text("@\(user.username)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(user.bio ?? "No bio yet.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.blue.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                            SocialMetricCard(title: "Followers", value: "\(user.followersCount)")
                            SocialMetricCard(title: "Following", value: "\(user.followingCount)")
                            SocialMetricCard(title: "Posts", value: "\(dataManager.profilePosts(for: user.username).count)")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Posts")
                            .font(.headline)
                        ForEach(dataManager.profilePosts(for: authManager.currentUser?.username ?? "preview").prefix(3)) { post in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(post.content)
                                    .font(.subheadline)
                                    .lineLimit(3)
                                HStack {
                                    Label("\(post.likesCount)", systemImage: "heart")
                                    Label("\(post.commentsCount)", systemImage: "bubble.left")
                                    Spacer()
                                    Text(post.createdAt, style: .relative)
                                }
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Creator Tools")
                            .font(.headline)
                        ProfileActionRow(title: "Draft queue", subtitle: "2 posts waiting for publish review", icon: "square.and.pencil")
                        ProfileActionRow(title: "Audience insights", subtitle: "Best posting time: 7:30 PM", icon: "chart.bar")
                        ProfileActionRow(title: "Monetization", subtitle: "Brand kit linked and ready", icon: "dollarsign.circle")
                    }
                }
                .padding(16)
            }
            .navigationTitle("Profile")
        }
    }
}

struct SocialMetricCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title3.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct ChecklistRow: View {
    let title: String
    let isDone: Bool
    
    var body: some View {
        Label(title, systemImage: isDone ? "checkmark.circle.fill" : "circle")
            .foregroundColor(isDone ? .green : .secondary)
    }
}

struct ProfileActionRow: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}
