import Foundation
import SwiftUI
import MusicPodcastAppCore

private enum MusicPodcastInteractionProofMode {
    static let isEnabled = ProcessInfo.processInfo.environment["IOSAPPTEMPLATES_INTERACTION_PROOF_MODE"] == "1"

    static func write(summary: String, steps: [String]) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let payload: [String: Any] = [
            "app": "MusicPodcastApp",
            "status": "completed",
            "summary": summary,
            "steps": steps,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]

        guard JSONSerialization.isValidJSONObject(payload),
              let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys]) else {
            return
        }

        try? data.write(to: documentsURL.appendingPathComponent("interaction-proof.json"), options: [.atomic])
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct MusicPodcastAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            MusicPodcastRuntimeRootView()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastRuntimeRootView: View {
    @StateObject private var store = MusicPodcastOperationsStore()

    var body: some View {
        TabView {
            MusicPodcastLibraryView(store: store)
                .tabItem {
                    Image(systemName: "music.note.house.fill")
                    Text("Library")
                }
            MusicPodcastQueueView(store: store)
                .tabItem {
                    Image(systemName: "text.line.first.and.arrowtriangle.forward")
                    Text("Queue")
                }
            MusicPodcastDownloadsView(store: store)
                .tabItem {
                    Image(systemName: "arrow.down.circle.fill")
                    Text("Downloads")
                }
            MusicPodcastDiscoverView(store: store)
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Discover")
                }
            MusicPodcastProfileView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .tint(.purple)
        .onAppear {
            store.runInteractionProofIfNeeded()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class MusicPodcastOperationsStore: ObservableObject {
    @Published var nowPlaying: MusicPodcastEpisodeRecord
    @Published var continueListening: [MusicPodcastEpisodeRecord]
    @Published var featuredShows: [MusicPodcastShowRecord]
    @Published var queue: [MusicPodcastQueueRecord]
    @Published var downloads: [MusicPodcastDownloadRecord]
    @Published var freshPicks: [MusicPodcastEpisodeRecord]
    @Published var playbackHeadline = "Your queue mixes briefings, long-form interviews and focus playlists."
    @Published var currentDevice = "iPhone 17 Pro + HomePod stereo pair"
    @Published var planSummary = "Premium Family • Spatial audio and lossless downloads enabled"
    private var interactionProofScheduled = false

    init() {
        let nowPlaying = MusicPodcastEpisodeRecord(title: "Operator Handoffs That Actually Stick", showTitle: "Scale Systems", duration: "48 min", description: "A field guide to cleaner project handoffs and measurable ownership transitions.", progress: 0.64, isDownloaded: false, isLiked: true)
        let continueListening = [
            nowPlaying,
            MusicPodcastEpisodeRecord(title: "Designing Better Morning Playlists", showTitle: "Moodboard Radio", duration: "32 min", description: "Curating calm openers, high-focus transitions and low-noise wrap-up tracks.", progress: 0.41, isDownloaded: true, isLiked: false)
        ]
        self.nowPlaying = nowPlaying
        self.continueListening = continueListening
        self.featuredShows = [
            MusicPodcastShowRecord(name: "Scale Systems", host: "Rina Patel", summary: "Operations interviews for teams that care about process quality and delivery speed.", releaseDay: "Every Tuesday", followers: 182_000, isFollowed: true),
            MusicPodcastShowRecord(name: "Signal in the Noise", host: "Jules Mercer", summary: "Deep-dive editorial briefings on product, AI and software craft.", releaseDay: "Daily briefing", followers: 94_000, isFollowed: false),
            MusicPodcastShowRecord(name: "Midnight Commute", host: "DJ Arlo", summary: "Beat-driven focus mixes tuned for late-night review sessions.", releaseDay: "Weekend drops", followers: 61_000, isFollowed: true)
        ]
        self.queue = [
            MusicPodcastQueueRecord(episode: MusicPodcastEpisodeRecord(title: "The 2026 SaaS Retention Map", showTitle: "Signal in the Noise", duration: "19 min", description: "Benchmarks, churn traps and recovery motions from top operators.", progress: 0, isDownloaded: false, isLiked: false), context: "Pinned for morning briefing", eta: "Next"),
            MusicPodcastQueueRecord(episode: MusicPodcastEpisodeRecord(title: "Quiet House Focus Mix", showTitle: "Midnight Commute", duration: "55 min", description: "A no-vocal focus sequence for inbox zero and roadmap cleanup.", progress: 0, isDownloaded: true, isLiked: true), context: "Auto-play after briefing", eta: "19 min")
        ]
        self.downloads = [
            MusicPodcastDownloadRecord(title: "Weekly Product Design Review", detail: "Lossless album download refreshed 22 minutes ago.", size: "284 MB", status: .ready),
            MusicPodcastDownloadRecord(title: "Scale Systems Back Catalog", detail: "8 archived episodes for cross-country travel.", size: "1.3 GB", status: .pinned)
        ]
        self.freshPicks = [
            MusicPodcastEpisodeRecord(title: "How Creator Revenue Splits Actually Work", showTitle: "Signal in the Noise", duration: "27 min", description: "Editorial breakdown of platform cuts, sponsor inventory and fan support.", progress: 0, isDownloaded: false, isLiked: false),
            MusicPodcastEpisodeRecord(title: "Commute Reset: Sunday Night Edit", showTitle: "Midnight Commute", duration: "42 min", description: "A softer mix built for planning tomorrow's sprint without cognitive fatigue.", progress: 0, isDownloaded: false, isLiked: true)
        ]
    }

    var activeDownloadsCount: Int {
        downloads.filter { $0.status == .ready || $0.status == .pinned }.count
    }

    func playEpisode(_ episode: MusicPodcastEpisodeRecord) {
        nowPlaying = episode
        playbackHeadline = "Now playing \(episode.title) on \(currentDevice)."
    }

    func toggleLike(_ episode: MusicPodcastEpisodeRecord) {
        if nowPlaying.id == episode.id {
            nowPlaying.isLiked.toggle()
            return
        }
        if let index = continueListening.firstIndex(where: { $0.id == episode.id }) {
            continueListening[index].isLiked.toggle()
            return
        }
        if let index = freshPicks.firstIndex(where: { $0.id == episode.id }) {
            freshPicks[index].isLiked.toggle()
        }
    }

    func advanceProgress(_ episode: MusicPodcastEpisodeRecord) {
        if nowPlaying.id == episode.id {
            nowPlaying.progress = min(1, nowPlaying.progress + 0.2)
            return
        }
        if let index = continueListening.firstIndex(where: { $0.id == episode.id }) {
            continueListening[index].progress = min(1, continueListening[index].progress + 0.2)
        }
    }

    func queueEpisode(_ episode: MusicPodcastEpisodeRecord) {
        queue.insert(MusicPodcastQueueRecord(episode: episode, context: "Queued from discover", eta: "After current item"), at: 0)
        playbackHeadline = "\(episode.title) moved into the up-next stack."
    }

    func playQueueItem(_ item: MusicPodcastQueueRecord) {
        nowPlaying = item.episode
        queue.removeAll { $0.id == item.id }
        playbackHeadline = "\(item.episode.title) moved from queue into active playback."
    }

    func moveQueueItemForward(_ item: MusicPodcastQueueRecord) {
        guard let index = queue.firstIndex(where: { $0.id == item.id }), index > 0 else { return }
        queue.swapAt(index, index - 1)
    }

    func removeQueueItem(_ item: MusicPodcastQueueRecord) {
        queue.removeAll(where: { $0.id == item.id })
    }

    func toggleDownload(_ episode: MusicPodcastEpisodeRecord) {
        if let index = downloads.firstIndex(where: { $0.title == episode.title }) {
            downloads.remove(at: index)
        } else {
            downloads.insert(MusicPodcastDownloadRecord(title: episode.title, detail: "\(episode.showTitle) offline pack created.", size: "118 MB", status: .ready), at: 0)
        }
    }

    func pinNowPlayingOffline() {
        if let index = downloads.firstIndex(where: { $0.title == nowPlaying.title }) {
            downloads[index].status = .pinned
        } else {
            downloads.insert(
                MusicPodcastDownloadRecord(
                    title: nowPlaying.title,
                    detail: "\(nowPlaying.showTitle) pinned from the active listening session.",
                    size: "118 MB",
                    status: .pinned
                ),
                at: 0
            )
        }
        playbackHeadline = "\(nowPlaying.title) is pinned for offline travel playback."
    }

    func completeNowPlaying() {
        nowPlaying.progress = 1
        playbackHeadline = "Completed \(nowPlaying.title) and prepared the next listening block."
        if !continueListening.contains(where: { $0.id == nowPlaying.id }) {
            continueListening.insert(nowPlaying, at: 0)
        }
    }

    func pinDownload(_ download: MusicPodcastDownloadRecord) {
        guard let index = downloads.firstIndex(where: { $0.id == download.id }) else { return }
        downloads[index].status = downloads[index].status == .pinned ? .ready : .pinned
    }

    func followShow(_ show: MusicPodcastShowRecord) {
        guard let index = featuredShows.firstIndex(where: { $0.id == show.id }) else { return }
        featuredShows[index].isFollowed.toggle()
    }

    func runInteractionProofIfNeeded() {
        guard MusicPodcastInteractionProofMode.isEnabled, !interactionProofScheduled else { return }
        interactionProofScheduled = true

        DispatchQueue.main.async {
            var steps: [String] = []

            let libraryEpisode = self.continueListening.first ?? self.nowPlaying
            self.playEpisode(libraryEpisode)
            self.toggleLike(libraryEpisode)
            self.advanceProgress(libraryEpisode)
            steps.append("Played and advanced library episode")

            if let discoverEpisode = self.freshPicks.first {
                self.queueEpisode(discoverEpisode)
                self.toggleDownload(discoverEpisode)
                steps.append("Queued and downloaded discover episode")
            }

            if let firstQueueItem = self.queue.first {
                self.moveQueueItemForward(firstQueueItem)
                self.playQueueItem(firstQueueItem)
                steps.append("Promoted queue item into playback")
            }

            self.completeNowPlaying()
            self.pinNowPlayingOffline()
            steps.append("Completed now playing and pinned offline")

            if let download = self.downloads.first {
                self.pinDownload(download)
                steps.append("Toggled download pin")
            }

            if let show = self.featuredShows.first {
                self.followShow(show)
                steps.append("Toggled show follow")
            }

            MusicPodcastInteractionProofMode.write(
                summary: "Music interaction proof completed with playback, queue, download, and follow chain.",
                steps: steps
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastLibraryView: View {
    @ObservedObject var store: MusicPodcastOperationsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Now Playing")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text(store.nowPlaying.title)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        Text(store.playbackHeadline)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 12) {
                            MusicPodcastMetricChip(title: "Queue", value: "\(store.queue.count)")
                            MusicPodcastMetricChip(title: "Downloads", value: "\(store.activeDownloadsCount)")
                            MusicPodcastMetricChip(title: "Followed", value: "\(store.featuredShows.filter(\.isFollowed).count)")
                        }
                    }
                    .padding(20)
                    .background(LinearGradient(colors: [.purple.opacity(0.16), .pink.opacity(0.10)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 22))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Continue Listening")
                            .font(.title3.weight(.bold))
                        ForEach(store.continueListening) { episode in
                            MusicPodcastEpisodeCard(episode: episode, onPlay: { store.playEpisode(episode) }, onLike: { store.toggleLike(episode) }, onAction: { store.advanceProgress(episode) }, actionTitle: "Advance 20%")
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Playback Controls")
                            .font(.title3.weight(.bold))
                        HStack {
                            Button("Complete Episode") {
                                store.completeNowPlaying()
                            }
                            .buttonStyle(.borderedProminent)
                            Button("Pin Offline") {
                                store.pinNowPlayingOffline()
                            }
                            .buttonStyle(.bordered)
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Featured Shows")
                            .font(.title3.weight(.bold))
                        ForEach(store.featuredShows) { show in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(show.name)
                                        .font(.headline)
                                    Spacer()
                                    Text(show.releaseDay)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.purple)
                                }
                                Text(show.summary)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Button(show.isFollowed ? "Unfollow" : "Follow") {
                                    store.followShow(show)
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Audio Hub")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastQueueView: View {
    @ObservedObject var store: MusicPodcastOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Up Next") {
                    ForEach(store.queue) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.episode.title)
                                .font(.headline)
                            Text("\(item.episode.showTitle) • \(item.context)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            HStack {
                                Button("Play Now") { store.playQueueItem(item) }
                                    .buttonStyle(.borderedProminent)
                                Button("Move Up") { store.moveQueueItemForward(item) }
                                    .buttonStyle(.bordered)
                                Button("Remove") { store.removeQueueItem(item) }
                                    .buttonStyle(.bordered)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Queue")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastDownloadsView: View {
    @ObservedObject var store: MusicPodcastOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Offline Ready") {
                    Text("\(store.activeDownloadsCount) active downloads are ready for commute and travel.")
                }
                Section("Downloads") {
                    ForEach(store.downloads) { download in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(download.title)
                                Spacer()
                                Text(download.size)
                                    .font(.subheadline.weight(.semibold))
                            }
                            Text(download.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Button(download.status == .pinned ? "Unpin" : "Pin For Travel") {
                                store.pinDownload(download)
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Downloads")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastDiscoverView: View {
    @ObservedObject var store: MusicPodcastOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Fresh Picks") {
                    ForEach(store.freshPicks) { episode in
                        MusicPodcastEpisodeRow(episode: episode, onQueue: { store.queueEpisode(episode) }, onDownload: { store.toggleDownload(episode) }, onLike: { store.toggleLike(episode) })
                    }
                }
            }
            .navigationTitle("Discover")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastProfileView: View {
    @ObservedObject var store: MusicPodcastOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Listener Profile") {
                    Label("Mia Chen", systemImage: "person.crop.circle.fill")
                    Label(store.planSummary, systemImage: "crown.fill")
                    Label(store.currentDevice, systemImage: "iphone.gen3")
                }
                Section("Playback Health") {
                    Label("Now playing: \(store.nowPlaying.title)", systemImage: "play.circle.fill")
                    Label("Queue depth: \(store.queue.count)", systemImage: "text.line.first.and.arrowtriangle.forward")
                    Label("Downloads ready: \(store.activeDownloadsCount)", systemImage: "arrow.down.circle.fill")
                }
            }
            .navigationTitle("Profile")
        }
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
struct MusicPodcastEpisodeCard: View {
    let episode: MusicPodcastEpisodeRecord
    let onPlay: () -> Void
    let onLike: () -> Void
    let onAction: () -> Void
    let actionTitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(episode.title)
                .font(.headline)
            Text("\(episode.showTitle) • \(episode.duration)")
                .font(.caption)
                .foregroundStyle(.secondary)
            ProgressView(value: episode.progress)
                .tint(.purple)
            HStack {
                Button("Play") { onPlay() }
                    .buttonStyle(.borderedProminent)
                Button(episode.isLiked ? "Unlike" : "Like") { onLike() }
                    .buttonStyle(.bordered)
                Button(actionTitle) { onAction() }
                    .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MusicPodcastEpisodeRow: View {
    let episode: MusicPodcastEpisodeRecord
    let onQueue: () -> Void
    let onDownload: () -> Void
    let onLike: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(episode.title)
            Text("\(episode.showTitle) • \(episode.duration)")
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack {
                Button("Queue") { onQueue() }
                    .buttonStyle(.borderedProminent)
                Button("Download") { onDownload() }
                    .buttonStyle(.bordered)
                Button(episode.isLiked ? "Unlike" : "Like") { onLike() }
                    .buttonStyle(.bordered)
            }
        }
        .padding(.vertical, 4)
    }
}

struct MusicPodcastEpisodeRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let showTitle: String
    let duration: String
    let description: String
    var progress: Double
    var isDownloaded: Bool
    var isLiked: Bool
}

struct MusicPodcastShowRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let host: String
    let summary: String
    let releaseDay: String
    let followers: Int
    var isFollowed: Bool
}

struct MusicPodcastQueueRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let episode: MusicPodcastEpisodeRecord
    let context: String
    let eta: String
}

enum MusicPodcastDownloadStatus: Hashable, Sendable {
    case ready
    case pinned

    var label: String {
        switch self {
        case .ready: return "Ready offline"
        case .pinned: return "Pinned for travel"
        }
    }
}

struct MusicPodcastDownloadRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let detail: String
    let size: String
    var status: MusicPodcastDownloadStatus
}
