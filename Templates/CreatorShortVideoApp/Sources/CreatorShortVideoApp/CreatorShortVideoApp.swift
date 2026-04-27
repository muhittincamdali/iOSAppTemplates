import SwiftUI
import CreatorShortVideoAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct CreatorShortVideoAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            CreatorShortVideoWorkspaceRootView(
                snapshot: .sample,
                channels: CreatorShortVideoChannelCard.sampleCards,
                actions: CreatorShortVideoQuickAction.defaultActions,
                health: .sample,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoWorkspaceRootView: View {
    let snapshot: CreatorShortVideoDashboardSnapshot
    let channels: [CreatorShortVideoChannelCard]
    let actions: [CreatorShortVideoQuickAction]
    let health: CreatorShortVideoOperationalHealth
    let state: CreatorShortVideoWorkspaceState

    var body: some View {
        TabView {
            CreatorShortVideoDashboardView(
                snapshot: snapshot,
                channels: channels,
                actions: actions,
                health: health,
                state: state
            )
            .tabItem {
                Image(systemName: "sparkles.tv.fill")
                Text("Studio")
            }

            CreatorShortVideoDraftsView(state: state)
                .tabItem {
                    Image(systemName: "film.stack.fill")
                    Text("Drafts")
                }

            CreatorShortVideoAnalyticsView(state: state)
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Analytics")
                }

            CreatorShortVideoCommunityView(state: state)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Community")
                }

            CreatorShortVideoProfileView(snapshot: snapshot, health: health, state: state)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.pink)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoDashboardView: View {
    let snapshot: CreatorShortVideoDashboardSnapshot
    let channels: [CreatorShortVideoChannelCard]
    let actions: [CreatorShortVideoQuickAction]
    let health: CreatorShortVideoOperationalHealth
    let state: CreatorShortVideoWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CreatorShortVideoHeroCard(snapshot: snapshot, health: health, state: state)
                    CreatorShortVideoQuickActionGrid(actions: actions)
                    CreatorShortVideoPublishQueueCard(videos: state.publishQueue)
                    CreatorShortVideoChannelPulseCard(channels: channels)
                    CreatorShortVideoRetentionCard(signals: state.retentionSignals)
                }
                .padding(16)
            }
            .navigationTitle("Creator Studio")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoHeroCard: View {
    let snapshot: CreatorShortVideoDashboardSnapshot
    let health: CreatorShortVideoOperationalHealth
    let state: CreatorShortVideoWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Publishing Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(state.operatorHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(snapshot.distributionHealth)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                CreatorShortVideoMetricChip(title: "Published", value: "\(snapshot.publishedClips)")
                CreatorShortVideoMetricChip(title: "Creators", value: "\(snapshot.creatorAccounts)")
                CreatorShortVideoMetricChip(title: "Reviews", value: "\(snapshot.pendingReviews)")
            }

            HStack {
                Label(state.releaseWindow, systemImage: "clock.fill")
                Spacer()
                Text("\(health.averageUploadMinutes) min upload")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.pink)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.pink.opacity(0.18), .orange.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoMetricChip: View {
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
struct CreatorShortVideoQuickActionGrid: View {
    let actions: [CreatorShortVideoQuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions) { action in
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: action.systemImage)
                            .font(.title3)
                            .foregroundStyle(.pink)
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
struct CreatorShortVideoPublishQueueCard: View {
    let videos: [CreatorShortVideoDraft]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Publish Queue")
                .font(.title3.weight(.bold))

            ForEach(videos) { video in
                NavigationLink {
                    CreatorShortVideoDraftDetailView(video: video)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(video.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(video.status)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(video.statusColor)
                        }
                        Text(video.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                        Text("\(video.channel) • \(video.duration) • \(video.owner)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
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
struct CreatorShortVideoChannelPulseCard: View {
    let channels: [CreatorShortVideoChannelCard]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Channel Pulse")
                .font(.title3.weight(.bold))

            ForEach(channels) { channel in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(channel.title)
                            .font(.headline)
                        Text("\(channel.clipCount) active clips")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(channel.ctaLabel)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.pink)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoRetentionCard: View {
    let signals: [CreatorShortVideoRetentionSignal]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Retention Signals")
                .font(.title3.weight(.bold))

            ForEach(signals) { signal in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: signal.systemImage)
                        .foregroundStyle(signal.color)
                        .frame(width: 22)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(signal.title)
                            .font(.headline)
                        Text(signal.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoDraftsView: View {
    let state: CreatorShortVideoWorkspaceState

    var body: some View {
        NavigationStack {
            List(state.drafts) { video in
                NavigationLink {
                    CreatorShortVideoDraftDetailView(video: video)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(video.title)
                        Text(video.channel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(video.summary)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Drafts")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoAnalyticsView: View {
    let state: CreatorShortVideoWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.analyticsCards) { card in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(card.title)
                            Spacer()
                            Text(card.value)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.pink)
                        }
                        Text(card.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Analytics")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoCommunityView: View {
    let state: CreatorShortVideoWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.communityThreads) { thread in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(thread.title)
                        Text(thread.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(thread.owner) • \(thread.status)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Community")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoProfileView: View {
    let snapshot: CreatorShortVideoDashboardSnapshot
    let health: CreatorShortVideoOperationalHealth
    let state: CreatorShortVideoWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Studio Lead") {
                    Label(state.studioLead, systemImage: "person.crop.circle.fill")
                    Label(state.portfolioFocus, systemImage: "sparkles.tv.fill")
                }
                Section("Performance") {
                    Label("\(snapshot.publishedClips) published clips", systemImage: "video.fill")
                    Label("\(snapshot.creatorAccounts) creator accounts", systemImage: "person.3.fill")
                    Label("\(state.publishCadence) publish cadence", systemImage: "calendar.badge.clock")
                }
                Section("Operations") {
                    Label("\(health.moderationQueue) items in moderation", systemImage: "shield.lefthalf.filled")
                    Label(health.monetizationReady ? "Monetization ready" : "Monetization blocked", systemImage: health.monetizationReady ? "dollarsign.circle.fill" : "exclamationmark.triangle.fill")
                    Label(state.brandPolicy, systemImage: "checkmark.seal.fill")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoDraftDetailView: View {
    let video: CreatorShortVideoDraft

    var body: some View {
        List {
            Section("Clip") {
                Text(video.title)
                    .font(.title3.weight(.bold))
                Text(video.summary)
                    .foregroundStyle(.secondary)
            }
            Section("Production") {
                Label(video.channel, systemImage: "play.rectangle.fill")
                Label(video.duration, systemImage: "clock.fill")
                Label(video.owner, systemImage: "person.fill")
                Label(video.status, systemImage: "checkmark.circle.fill")
            }
            Section("Checklist") {
                ForEach(video.checklist, id: \.self) { item in
                    Label(item, systemImage: "checkmark.circle")
                }
            }
        }
        .navigationTitle("Clip Detail")
    }
}

public struct CreatorShortVideoQuickAction: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let detail: String
    public let systemImage: String

    public init(
        id: UUID = UUID(),
        title: String,
        detail: String,
        systemImage: String
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.systemImage = systemImage
    }

    public static let defaultActions: [CreatorShortVideoQuickAction] = [
        CreatorShortVideoQuickAction(title: "Open Clip Queue", detail: "Review drafts, hooks and publish timing before the evening drop.", systemImage: "video.badge.plus"),
        CreatorShortVideoQuickAction(title: "Review Community Cut", detail: "Inspect comment threads, duets and creator requests needing moderation.", systemImage: "person.3.fill"),
        CreatorShortVideoQuickAction(title: "Inspect Retention Pulse", detail: "Check first-three-second retention and replay performance by channel.", systemImage: "chart.line.uptrend.xyaxis")
    ]
}

struct CreatorShortVideoWorkspaceState {
    let operatorHeadline: String
    let releaseWindow: String
    let studioLead: String
    let portfolioFocus: String
    let publishCadence: String
    let brandPolicy: String
    let publishQueue: [CreatorShortVideoDraft]
    let drafts: [CreatorShortVideoDraft]
    let retentionSignals: [CreatorShortVideoRetentionSignal]
    let analyticsCards: [CreatorShortVideoAnalyticsCard]
    let communityThreads: [CreatorShortVideoCommunityThread]

    static let sample = CreatorShortVideoWorkspaceState(
        operatorHeadline: "Creator queue is ready for the evening push",
        releaseWindow: "Prime publish window 19:00-21:00",
        studioLead: "Ariana West",
        portfolioFocus: "Product demos, launch stories and creator collabs",
        publishCadence: "5 clips / day",
        brandPolicy: "Every clip needs one hook, one CTA and one brand-safe caption review",
        publishQueue: [
            CreatorShortVideoDraft(title: "Launch teaser cutdown", channel: "Launch Stories", duration: "0:24", owner: "Ariana", status: "Ready", summary: "Hook-first teaser for tomorrow’s feature reveal with text overlays and CTA.", checklist: ["Caption approved", "Thumbnail selected", "Audio rights cleared"]),
            CreatorShortVideoDraft(title: "Workflow demo remix", channel: "Product Demos", duration: "0:38", owner: "Noah", status: "Needs review", summary: "Screen-recording remix showing the new workspace flow and faster capture steps.", checklist: ["Trim opening 2 seconds", "Fix subtitle timing", "Add end-card CTA"])
        ],
        drafts: [
            CreatorShortVideoDraft(title: "Launch teaser cutdown", channel: "Launch Stories", duration: "0:24", owner: "Ariana", status: "Ready", summary: "Hook-first teaser for tomorrow’s feature reveal with text overlays and CTA.", checklist: ["Caption approved", "Thumbnail selected", "Audio rights cleared"]),
            CreatorShortVideoDraft(title: "Workflow demo remix", channel: "Product Demos", duration: "0:38", owner: "Noah", status: "Needs review", summary: "Screen-recording remix showing the new workspace flow and faster capture steps.", checklist: ["Trim opening 2 seconds", "Fix subtitle timing", "Add end-card CTA"]),
            CreatorShortVideoDraft(title: "Community creator spotlight", channel: "Community Highlights", duration: "0:31", owner: "Lina", status: "Draft", summary: "Creator shoutout clip with stitched UGC and brand-safe captions.", checklist: ["Collect permissions", "Select cover frame", "Add creator tag"])
        ],
        retentionSignals: [
            CreatorShortVideoRetentionSignal(title: "First 3s retention holding", summary: "Launch teasers are retaining 72% of viewers through the first beat.", systemImage: "bolt.fill", color: .green),
            CreatorShortVideoRetentionSignal(title: "Replay loop stronger on demos", summary: "Short UI reveals are outperforming talking-head cuts in repeat views.", systemImage: "repeat.circle.fill", color: .pink),
            CreatorShortVideoRetentionSignal(title: "Comment sentiment needs review", summary: "Community highlight comments spiked after the latest monetization post.", systemImage: "bubble.left.and.exclamationmark.bubble.right.fill", color: .orange)
        ],
        analyticsCards: [
            CreatorShortVideoAnalyticsCard(title: "Average watch time", value: "18.4s", summary: "Up 11% week over week on product demo content."),
            CreatorShortVideoAnalyticsCard(title: "Completion rate", value: "41%", summary: "Highest on clips under 30 seconds with one clear CTA."),
            CreatorShortVideoAnalyticsCard(title: "Shares", value: "2.8K", summary: "Community spotlight clips are driving the strongest share velocity.")
        ],
        communityThreads: [
            CreatorShortVideoCommunityThread(title: "Creator payout questions", summary: "Creators are asking for clearer timing after last week’s sponsorship drop.", owner: "Support", status: "Needs response"),
            CreatorShortVideoCommunityThread(title: "UGC permission approvals", summary: "Five clips need final consent before tomorrow’s highlight reel.", owner: "Legal", status: "Waiting"),
            CreatorShortVideoCommunityThread(title: "Caption accessibility review", summary: "Subtitle timing and contrast fixes are pending on two launch clips.", owner: "QA", status: "In progress")
        ]
    )
}

struct CreatorShortVideoDraft: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let channel: String
    let duration: String
    let owner: String
    let status: String
    let summary: String
    let checklist: [String]

    var statusColor: Color {
        switch status {
        case "Ready":
            return .green
        case "Needs review":
            return .orange
        default:
            return .secondary
        }
    }
}

struct CreatorShortVideoRetentionSignal: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let summary: String
    let systemImage: String
    let color: Color
}

struct CreatorShortVideoAnalyticsCard: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let value: String
    let summary: String
}

struct CreatorShortVideoCommunityThread: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let summary: String
    let owner: String
    let status: String
}
