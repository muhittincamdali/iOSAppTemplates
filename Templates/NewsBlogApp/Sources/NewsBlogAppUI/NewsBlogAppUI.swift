import SwiftUI
import NewsBlogAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct NewsBlogSummaryCard: View {
    public let snapshot: NewsBlogDashboardSnapshot
    public let health: NewsBlogPublishingHealth

    public init(
        snapshot: NewsBlogDashboardSnapshot,
        health: NewsBlogPublishingHealth
    ) {
        self.snapshot = snapshot
        self.health = health
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(snapshot.leadHeadline)
                .font(.headline)

            Label("\(snapshot.publishedToday) articles published today", systemImage: "newspaper.fill")
            Label("\(snapshot.bookmarkedReads) saved reads queued", systemImage: "bookmark.fill")
            Label(health.syncStatus, systemImage: health.newsletterReady ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
            Label("\(health.moderationQueue) items in moderation", systemImage: "tray.full.fill")
        }
        .padding(.vertical, 8)
    }
}
