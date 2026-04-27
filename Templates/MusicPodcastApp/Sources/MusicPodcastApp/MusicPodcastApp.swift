import SwiftUI
import MusicPodcastAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct MusicPodcastAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            MusicPodcastWorkspaceRootView(
                snapshot: .sample,
                collections: MusicPodcastCollectionCard.sampleCards,
                actions: MusicPodcastQuickAction.defaultActions,
                health: .sample,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastWorkspaceRootView: View {
    let snapshot: MusicPodcastDashboardSnapshot
    let collections: [MusicPodcastCollectionCard]
    let actions: [MusicPodcastQuickAction]
    let health: MusicPodcastHealth
    let state: MusicPodcastWorkspaceState

    var body: some View {
        TabView {
            MusicPodcastLibraryView(
                snapshot: snapshot,
                collections: collections,
                actions: actions,
                health: health,
                state: state
            )
            .tabItem {
                Image(systemName: "music.note.house.fill")
                Text("Library")
            }

            MusicPodcastQueueView(state: state)
                .tabItem {
                    Image(systemName: "text.line.first.and.arrowtriangle.forward")
                    Text("Queue")
                }

            MusicPodcastDownloadsView(state: state, health: health)
                .tabItem {
                    Image(systemName: "arrow.down.circle.fill")
                    Text("Downloads")
                }

            MusicPodcastDiscoverView(state: state)
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Discover")
                }

            MusicPodcastProfileView(snapshot: snapshot, health: health, state: state)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .tint(.purple)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastLibraryView: View {
    let snapshot: MusicPodcastDashboardSnapshot
    let collections: [MusicPodcastCollectionCard]
    let actions: [MusicPodcastQuickAction]
    let health: MusicPodcastHealth
    let state: MusicPodcastWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    MusicPodcastHeroCard(snapshot: snapshot, health: health, state: state)
                    MusicPodcastQuickActionGrid(actions: actions)
                    MusicPodcastContinueListeningCard(episodes: state.continueListening)
                    MusicPodcastCollectionStrip(collections: collections)
                    MusicPodcastFeaturedShowsCard(shows: state.featuredShows)
                }
                .padding(16)
            }
            .navigationTitle("Audio Hub")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastHeroCard: View {
    let snapshot: MusicPodcastDashboardSnapshot
    let health: MusicPodcastHealth
    let state: MusicPodcastWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Now Playing")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(snapshot.nowPlaying)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(state.playbackHeadline)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                MusicPodcastMetricChip(title: "Listeners", value: "\(snapshot.activeListeners)")
                MusicPodcastMetricChip(title: "Queue", value: "\(snapshot.queuedEpisodes)")
                MusicPodcastMetricChip(title: "Buffered", value: "\(health.bufferedMinutes)m")
            }

            HStack {
                Label(state.currentDevice, systemImage: "airpodsmax")
                Spacer()
                Text(health.syncStatus)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(health.subscriptionReady ? .green : .orange)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.purple.opacity(0.16), .pink.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastMetricChip: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastQuickActionGrid: View {
    let actions: [MusicPodcastQuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions) { action in
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: action.systemImage)
                            .font(.title3)
                            .foregroundStyle(.purple)
                        Text(action.title)
                            .font(.subheadline.weight(.semibold))
                        Text(action.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastContinueListeningCard: View {
    let episodes: [MusicPodcastEpisode]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Continue Listening")
                .font(.title3.weight(.bold))

            ForEach(episodes) { episode in
                NavigationLink {
                    MusicPodcastEpisodeDetailView(episode: episode)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(episode.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("\(episode.showTitle) - \(episode.duration)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        ProgressView(value: episode.progress)
                            .tint(.purple)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastCollectionStrip: View {
    let collections: [MusicPodcastCollectionCard]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Collections")
                .font(.title3.weight(.bold))

            ForEach(collections) { collection in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(collection.title)
                            .font(.headline)
                        Text("\(collection.itemCount) items")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(collection.ctaLabel)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.purple)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastFeaturedShowsCard: View {
    let shows: [MusicPodcastShow]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Shows")
                .font(.title3.weight(.bold))

            ForEach(shows) { show in
                NavigationLink {
                    MusicPodcastShowDetailView(show: show)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(show.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text(show.host)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(show.releaseDay)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.purple)
                        }
                        Text(show.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastQueueView: View {
    let state: MusicPodcastWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Up Next") {
                    ForEach(state.queue) { entry in
                        NavigationLink {
                            MusicPodcastEpisodeDetailView(episode: entry.episode)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(entry.episode.title)
                                    Spacer()
                                    Text(entry.eta)
                                        .font(.subheadline.weight(.semibold))
                                }
                                Text("\(entry.episode.showTitle) - \(entry.context)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Playback Controls") {
                    ForEach(state.playbackControls, id: \.self) { control in
                        Label(control, systemImage: "slider.horizontal.3")
                    }
                }
            }
            .navigationTitle("Queue")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastDownloadsView: View {
    let state: MusicPodcastWorkspaceState
    let health: MusicPodcastHealth

    var body: some View {
        NavigationStack {
            List {
                Section("Offline Ready") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(state.offlineSummary)
                            .font(.headline)
                        Text("Buffered \(health.bufferedMinutes) minutes across commute and focus playlists.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Downloads") {
                    ForEach(state.downloads) { download in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(download.title)
                                Spacer()
                                Text(download.size)
                                    .font(.subheadline.weight(.semibold))
                            }
                            Text(download.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(download.status)
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(.purple)
                        }
                    }
                }
            }
            .navigationTitle("Downloads")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastDiscoverView: View {
    let state: MusicPodcastWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Browse Categories") {
                    ForEach(state.discoverCategories, id: \.self) { category in
                        Label(category, systemImage: "dot.radiowaves.left.and.right")
                    }
                }

                Section("Fresh Picks") {
                    ForEach(state.freshPicks) { episode in
                        NavigationLink {
                            MusicPodcastEpisodeDetailView(episode: episode)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(episode.title)
                                Text("\(episode.showTitle) - \(episode.duration)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Discover")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastProfileView: View {
    let snapshot: MusicPodcastDashboardSnapshot
    let health: MusicPodcastHealth
    let state: MusicPodcastWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Listener Profile") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(state.listenerName)
                            .font(.headline)
                        Text(state.planSummary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Label(state.currentDevice, systemImage: "iphone.gen3")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Playback Health") {
                    Label("Now playing: \(snapshot.nowPlaying)", systemImage: "play.circle.fill")
                    Label("Offline ready: \(snapshot.offlineReady ? "Yes" : "No")", systemImage: "arrow.down.circle.fill")
                    Label("Subscription ready: \(health.subscriptionReady ? "Yes" : "No")", systemImage: "checkmark.seal.fill")
                }

                Section("Listening Insights") {
                    ForEach(state.insights, id: \.label) { insight in
                        HStack {
                            Text(insight.label)
                            Spacer()
                            Text(insight.value)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.purple)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastShowDetailView: View {
    let show: MusicPodcastShow

    var body: some View {
        List {
            Section("Show") {
                Text(show.name)
                    .font(.headline)
                Text(show.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Meta") {
                Label(show.host, systemImage: "mic.fill")
                Label(show.releaseDay, systemImage: "calendar")
                Label(show.followers, systemImage: "person.2.fill")
            }
        }
        .navigationTitle(show.name)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastEpisodeDetailView: View {
    let episode: MusicPodcastEpisode

    var body: some View {
        List {
            Section("Episode") {
                Text(episode.title)
                    .font(.headline)
                Text(episode.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Playback") {
                Label(episode.showTitle, systemImage: "music.note.list")
                Label(episode.duration, systemImage: "clock.fill")
                Label("\(Int(episode.progress * 100))% complete", systemImage: "waveform")
            }
        }
        .navigationTitle("Episode")
    }
}

public struct MusicPodcastQuickAction: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let systemImage: String
    public let detail: String

    public init(
        id: UUID = UUID(),
        title: String,
        systemImage: String,
        detail: String
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.detail = detail
    }

    public static let defaultActions: [MusicPodcastQuickAction] = [
        MusicPodcastQuickAction(
            title: "Resume Mix",
            systemImage: "play.fill",
            detail: "Jump back into the current focus playlist from the last saved timestamp."
        ),
        MusicPodcastQuickAction(
            title: "Review Queue",
            systemImage: "text.line.first.and.arrowtriangle.forward",
            detail: "Reorder upcoming episodes and pin the next briefing block."
        ),
        MusicPodcastQuickAction(
            title: "Refresh Downloads",
            systemImage: "arrow.down.circle.fill",
            detail: "Sync commute episodes and trim expired offline packs before travel."
        ),
        MusicPodcastQuickAction(
            title: "Open Discover",
            systemImage: "sparkles",
            detail: "Inspect new editorial picks and promoted creator drops for this week."
        )
    ]
}

struct MusicPodcastWorkspaceState: Hashable, Sendable {
    let playbackHeadline: String
    let currentDevice: String
    let offlineSummary: String
    let listenerName: String
    let planSummary: String
    let continueListening: [MusicPodcastEpisode]
    let featuredShows: [MusicPodcastShow]
    let queue: [MusicPodcastQueueEntry]
    let downloads: [MusicPodcastDownload]
    let freshPicks: [MusicPodcastEpisode]
    let discoverCategories: [String]
    let playbackControls: [String]
    let insights: [MusicPodcastInsight]

    static let sample = MusicPodcastWorkspaceState(
        playbackHeadline: "Your current queue blends product briefings, long-form interviews and deep focus playlists.",
        currentDevice: "iPhone 17 Pro + HomePod stereo pair",
        offlineSummary: "12 episodes and 3 playlists are safe for flights and low-signal mornings.",
        listenerName: "Mia Chen",
        planSummary: "Premium Family - Spatial audio and lossless downloads enabled",
        continueListening: [
            MusicPodcastEpisode(
                title: "Operator Handoffs That Actually Stick",
                showTitle: "Scale Systems",
                duration: "48 min",
                description: "A field guide to cleaner project handoffs and measurable ownership transitions.",
                progress: 0.64
            ),
            MusicPodcastEpisode(
                title: "Designing Better Morning Playlists",
                showTitle: "Moodboard Radio",
                duration: "32 min",
                description: "Curating calm openers, high-focus transitions and low-noise wrap-up tracks.",
                progress: 0.41
            )
        ],
        featuredShows: [
            MusicPodcastShow(
                name: "Scale Systems",
                host: "Rina Patel",
                summary: "Operations interviews for teams that care about process quality and delivery speed.",
                releaseDay: "Every Tuesday",
                followers: "182K followers"
            ),
            MusicPodcastShow(
                name: "Signal in the Noise",
                host: "Jules Mercer",
                summary: "Deep-dive editorial briefings on product, AI and software craft.",
                releaseDay: "Daily briefing",
                followers: "94K followers"
            ),
            MusicPodcastShow(
                name: "Midnight Commute",
                host: "DJ Arlo",
                summary: "Beat-driven focus mixes tuned for late-night reviews and uninterrupted shipping.",
                releaseDay: "Weekend drops",
                followers: "61K followers"
            )
        ],
        queue: [
            MusicPodcastQueueEntry(
                episode: MusicPodcastEpisode(
                    title: "The 2026 SaaS Retention Map",
                    showTitle: "Signal in the Noise",
                    duration: "19 min",
                    description: "Benchmarks, churn traps and recovery motions from top operators.",
                    progress: 0.0
                ),
                context: "Pinned for morning briefing",
                eta: "Next"
            ),
            MusicPodcastQueueEntry(
                episode: MusicPodcastEpisode(
                    title: "Quiet House Focus Mix",
                    showTitle: "Midnight Commute",
                    duration: "55 min",
                    description: "A no-vocal focus sequence for inbox zero and roadmap cleanup.",
                    progress: 0.0
                ),
                context: "Auto-play after briefing",
                eta: "19 min"
            )
        ],
        downloads: [
            MusicPodcastDownload(
                title: "Weekly Product Design Review",
                detail: "Lossless album download - refreshed 22 minutes ago",
                size: "284 MB",
                status: "Ready offline"
            ),
            MusicPodcastDownload(
                title: "Scale Systems Back Catalog",
                detail: "8 archived episodes for cross-country travel",
                size: "1.3 GB",
                status: "Pinned for 30 days"
            )
        ],
        freshPicks: [
            MusicPodcastEpisode(
                title: "How Creator Revenue Splits Actually Work",
                showTitle: "Signal in the Noise",
                duration: "27 min",
                description: "Editorial breakdown of platform cuts, sponsor inventory and fan support.",
                progress: 0.0
            ),
            MusicPodcastEpisode(
                title: "Commute Reset: Sunday Night Edit",
                showTitle: "Midnight Commute",
                duration: "42 min",
                description: "A softer mix built for planning tomorrow's sprint without cognitive fatigue.",
                progress: 0.0
            )
        ],
        discoverCategories: [
            "Editorial Briefings",
            "Focus Mixes",
            "Founder Interviews",
            "Design Podcasts",
            "Daily News Capsules"
        ],
        playbackControls: [
            "Crossfade set to 4 seconds",
            "Smart speed enabled for spoken-word podcasts",
            "Normalize volume across queues",
            "Download over Wi-Fi only"
        ],
        insights: [
            MusicPodcastInsight(label: "Weekly listening", value: "11h 40m"),
            MusicPodcastInsight(label: "Downloaded shows", value: "15"),
            MusicPodcastInsight(label: "Saved episodes", value: "28")
        ]
    )
}

struct MusicPodcastEpisode: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let showTitle: String
    let duration: String
    let description: String
    let progress: Double

    init(
        id: UUID = UUID(),
        title: String,
        showTitle: String,
        duration: String,
        description: String,
        progress: Double
    ) {
        self.id = id
        self.title = title
        self.showTitle = showTitle
        self.duration = duration
        self.description = description
        self.progress = progress
    }
}

struct MusicPodcastShow: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let host: String
    let summary: String
    let releaseDay: String
    let followers: String

    init(
        id: UUID = UUID(),
        name: String,
        host: String,
        summary: String,
        releaseDay: String,
        followers: String
    ) {
        self.id = id
        self.name = name
        self.host = host
        self.summary = summary
        self.releaseDay = releaseDay
        self.followers = followers
    }
}

struct MusicPodcastQueueEntry: Identifiable, Hashable, Sendable {
    let id: UUID
    let episode: MusicPodcastEpisode
    let context: String
    let eta: String

    init(
        id: UUID = UUID(),
        episode: MusicPodcastEpisode,
        context: String,
        eta: String
    ) {
        self.id = id
        self.episode = episode
        self.context = context
        self.eta = eta
    }
}

struct MusicPodcastDownload: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let detail: String
    let size: String
    let status: String

    init(
        id: UUID = UUID(),
        title: String,
        detail: String,
        size: String,
        status: String
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.size = size
        self.status = status
    }
}

struct MusicPodcastInsight: Hashable, Sendable {
    let label: String
    let value: String
}
