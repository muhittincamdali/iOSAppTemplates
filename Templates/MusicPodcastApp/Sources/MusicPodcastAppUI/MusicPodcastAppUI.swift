import SwiftUI
import MusicPodcastAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct MusicPodcastSummaryCard: View {
    public let snapshot: MusicPodcastDashboardSnapshot
    public let health: MusicPodcastHealth

    public init(
        snapshot: MusicPodcastDashboardSnapshot,
        health: MusicPodcastHealth
    ) {
        self.snapshot = snapshot
        self.health = health
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(snapshot.nowPlaying)
                .font(.headline)

            Label("\(snapshot.activeListeners) active listeners", systemImage: "headphones")
            Label("\(snapshot.queuedEpisodes) queued episodes", systemImage: "mic.fill")
            Label("\(health.bufferedMinutes) minutes cached offline", systemImage: "arrow.down.circle.fill")
            Label(health.syncStatus, systemImage: health.subscriptionReady ? "checkmark.circle.fill" : "xmark.circle.fill")
        }
        .padding(.vertical, 8)
    }
}
