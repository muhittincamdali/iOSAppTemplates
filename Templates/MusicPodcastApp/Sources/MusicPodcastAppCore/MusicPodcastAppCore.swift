import Foundation

public struct MusicPodcastDashboardSnapshot: Hashable, Sendable {
    public let nowPlaying: String
    public let activeListeners: Int
    public let queuedEpisodes: Int
    public let offlineReady: Bool

    public init(
        nowPlaying: String,
        activeListeners: Int,
        queuedEpisodes: Int,
        offlineReady: Bool
    ) {
        self.nowPlaying = nowPlaying
        self.activeListeners = activeListeners
        self.queuedEpisodes = queuedEpisodes
        self.offlineReady = offlineReady
    }

    public static let sample = MusicPodcastDashboardSnapshot(
        nowPlaying: "Weekly Product Design Review",
        activeListeners: 12840,
        queuedEpisodes: 5,
        offlineReady: true
    )
}

public struct MusicPodcastCollectionCard: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let itemCount: Int
    public let ctaLabel: String

    public init(
        id: UUID = UUID(),
        title: String,
        itemCount: Int,
        ctaLabel: String
    ) {
        self.id = id
        self.title = title
        self.itemCount = itemCount
        self.ctaLabel = ctaLabel
    }

    public static let sampleCards: [MusicPodcastCollectionCard] = [
        MusicPodcastCollectionCard(title: "Morning Mix", itemCount: 24, ctaLabel: "Resume queue"),
        MusicPodcastCollectionCard(title: "Top Podcasts", itemCount: 12, ctaLabel: "Review episodes"),
        MusicPodcastCollectionCard(title: "Offline Downloads", itemCount: 37, ctaLabel: "Manage storage")
    ]
}

public struct MusicPodcastHealth: Hashable, Sendable {
    public let syncStatus: String
    public let bufferedMinutes: Int
    public let subscriptionReady: Bool

    public init(
        syncStatus: String,
        bufferedMinutes: Int,
        subscriptionReady: Bool
    ) {
        self.syncStatus = syncStatus
        self.bufferedMinutes = bufferedMinutes
        self.subscriptionReady = subscriptionReady
    }

    public static let sample = MusicPodcastHealth(
        syncStatus: "Synced across devices",
        bufferedMinutes: 96,
        subscriptionReady: true
    )
}
