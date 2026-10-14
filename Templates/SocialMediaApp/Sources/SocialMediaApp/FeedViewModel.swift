import Foundation
import SwiftUI

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        loadMockData()
    }
    
    func refreshFeed() async {
        await MainActor.run {
            isLoading = true
        }
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await MainActor.run {
            loadMockData()
            isLoading = false
        }
    }
    
    private func loadMockData() {
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
    }
}
