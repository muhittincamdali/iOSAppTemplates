import Foundation
import SwiftUI

struct ExploreView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SearchBar(text: $searchText, placeholder: "Search creators, topics, or posts")
                        .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Trending Topics")
                            .font(.title3.weight(.bold))
                            .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(filteredTopics, id: \.self) { topic in
                                    Text("#\(topic)")
                                        .font(.subheadline.weight(.semibold))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .background(Color.blue.opacity(0.12))
                                        .clipShape(Capsule())
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Suggested Creators")
                            .font(.title3.weight(.bold))
                            .padding(.horizontal, 16)
                        
                        ForEach(filteredProfiles) { profile in
                            SuggestedProfileRow(profile: profile)
                                .padding(.horizontal, 16)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Discover Posts")
                            .font(.title3.weight(.bold))
                            .padding(.horizontal, 16)
                        
                        ForEach(filteredPosts) { post in
                            PostCard(post: post)
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Explore")
        }
    }
    
    private var filteredTopics: [String] {
        if searchText.isEmpty {
            return dataManager.trendingTopics
        }
        return dataManager.trendingTopics.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    private var filteredProfiles: [SuggestedProfile] {
        if searchText.isEmpty {
            return dataManager.suggestedProfiles
        }
        return dataManager.suggestedProfiles.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
            $0.username.localizedCaseInsensitiveContains(searchText) ||
            $0.bio.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var filteredPosts: [Post] {
        if searchText.isEmpty {
            return dataManager.posts
        }
        return dataManager.posts.filter {
            $0.content.localizedCaseInsensitiveContains(searchText) ||
            $0.authorDisplayName.localizedCaseInsensitiveContains(searchText) ||
            $0.authorUsername.localizedCaseInsensitiveContains(searchText)
        }
        .prefix(3)
        .map { $0 }
    }
}

struct SuggestedProfileRow: View {
    let profile: SuggestedProfile
    @StateObject private var dataManager = DataManager.shared
    
    private var isFollowing: Bool {
        dataManager.followedProfileIDs.contains(profile.id)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: profile.avatarURL ?? "")) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
            .frame(width: 52, height: 52)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(profile.displayName)
                        .font(.headline)
                    if profile.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
                Text("@\(profile.username)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(profile.bio)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button(isFollowing ? "Following" : "Follow") {
                dataManager.toggleFollow(profileID: profile.id)
            }
            .font(.subheadline.weight(.semibold))
            .foregroundColor(isFollowing ? .blue : .white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isFollowing ? Color.blue.opacity(0.12) : Color.blue)
            .clipShape(Capsule())
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}
