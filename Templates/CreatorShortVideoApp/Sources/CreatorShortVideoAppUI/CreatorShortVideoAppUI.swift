import SwiftUI
import CreatorShortVideoAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct CreatorShortVideoSummaryCard: View {
    public let snapshot: CreatorShortVideoDashboardSnapshot
    public let health: CreatorShortVideoOperationalHealth

    public init(
        snapshot: CreatorShortVideoDashboardSnapshot,
        health: CreatorShortVideoOperationalHealth
    ) {
        self.snapshot = snapshot
        self.health = health
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("\(snapshot.publishedClips) published clips", systemImage: "play.rectangle.fill")
            Label("\(snapshot.creatorAccounts) active creators", systemImage: "person.2.crop.square.stack.fill")
            Label("\(snapshot.pendingReviews) clips in review", systemImage: "exclamationmark.video.fill")
            Label(snapshot.distributionHealth, systemImage: "waveform.and.magnifyingglass")
            Label(
                "\(health.averageUploadMinutes) min average upload cycle",
                systemImage: health.monetizationReady ? "checkmark.circle.fill" : "xmark.circle.fill"
            )
        }
        .padding(.vertical, 8)
    }
}
