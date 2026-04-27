import SwiftUI
import NewsBlogAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct NewsBlogAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            NewsBlogWorkspaceRootView(
                snapshot: .sample,
                categories: NewsBlogCategoryCard.sampleCards,
                actions: NewsBlogQuickAction.defaultActions,
                health: .sample,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogWorkspaceRootView: View {
    let snapshot: NewsBlogDashboardSnapshot
    let categories: [NewsBlogCategoryCard]
    let actions: [NewsBlogQuickAction]
    let health: NewsBlogPublishingHealth
    let state: NewsBlogWorkspaceState

    var body: some View {
        TabView {
            NewsBlogTodayView(
                snapshot: snapshot,
                categories: categories,
                actions: actions,
                health: health,
                state: state
            )
            .tabItem {
                Image(systemName: "newspaper.fill")
                Text("Today")
            }

            NewsBlogSectionsView(state: state)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Sections")
                }

            NewsBlogSavedView(state: state)
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Saved")
                }

            NewsBlogDigestView(state: state)
                .tabItem {
                    Image(systemName: "envelope.open.fill")
                    Text("Digest")
                }

            NewsBlogProfileView(snapshot: snapshot, health: health, state: state)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .tint(.orange)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogTodayView: View {
    let snapshot: NewsBlogDashboardSnapshot
    let categories: [NewsBlogCategoryCard]
    let actions: [NewsBlogQuickAction]
    let health: NewsBlogPublishingHealth
    let state: NewsBlogWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    NewsBlogHeroCard(snapshot: snapshot, health: health, state: state)
                    NewsBlogQuickActionGrid(actions: actions)
                    NewsBlogLeadStoryCard(article: state.leadStory)
                    NewsBlogSectionStrip(categories: categories)
                    NewsBlogTrendingStoriesCard(articles: state.trendingStories)
                }
                .padding(16)
            }
            .navigationTitle("Editorial Desk")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogHeroCard: View {
    let snapshot: NewsBlogDashboardSnapshot
    let health: NewsBlogPublishingHealth
    let state: NewsBlogWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Publishing Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(snapshot.leadHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(state.editorNote)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                NewsBlogMetricChip(title: "Published", value: "\(snapshot.publishedToday)")
                NewsBlogMetricChip(title: "Saved", value: "\(snapshot.bookmarkedReads)")
                NewsBlogMetricChip(title: "Queue", value: "\(health.moderationQueue)")
            }

            HStack {
                Label(state.newsletterWindow, systemImage: "clock.fill")
                Spacer()
                Text(health.syncStatus)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(health.newsletterReady ? .green : .orange)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.orange.opacity(0.18), .red.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogMetricChip: View {
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
struct NewsBlogQuickActionGrid: View {
    let actions: [NewsBlogQuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions) { action in
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: action.systemImage)
                            .font(.title3)
                            .foregroundStyle(.orange)
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
struct NewsBlogLeadStoryCard: View {
    let article: NewsBlogArticle

    var body: some View {
        NavigationLink {
            NewsBlogArticleDetailView(article: article)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                Text("Lead Story")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                Text(article.title)
                    .font(.headline)
                Text(article.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack {
                    Label(article.section, systemImage: "bookmark.square.fill")
                    Spacer()
                    Text(article.readTime)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogSectionStrip: View {
    let categories: [NewsBlogCategoryCard]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sections")
                .font(.title3.weight(.bold))

            ForEach(categories) { category in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.title)
                            .font(.headline)
                        Text("\(category.articleCount) ready stories")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(category.ctaLabel)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogTrendingStoriesCard: View {
    let articles: [NewsBlogArticle]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trending Now")
                .font(.title3.weight(.bold))

            ForEach(articles) { article in
                NavigationLink {
                    NewsBlogArticleDetailView(article: article)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(article.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(article.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                        Text("\(article.author) • \(article.readTime)")
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
struct NewsBlogSectionsView: View {
    let state: NewsBlogWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.sections) { section in
                    NavigationLink {
                        NewsBlogSectionDetailView(section: section)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(section.name)
                            Text(section.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(section.storyCount) queued stories")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Sections")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogSavedView: View {
    let state: NewsBlogWorkspaceState

    var body: some View {
        NavigationStack {
            List(state.savedReads) { article in
                NavigationLink(article.title) {
                    NewsBlogArticleDetailView(article: article)
                }
            }
            .navigationTitle("Saved Reads")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogDigestView: View {
    let state: NewsBlogWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Morning Digest") {
                    Text(state.morningDigest)
                }
                Section("Evening Digest") {
                    Text(state.eveningDigest)
                }
                Section("Newsletter Priorities") {
                    ForEach(state.digestPriorities, id: \.self) { priority in
                        Label(priority, systemImage: "envelope.badge.fill")
                    }
                }
            }
            .navigationTitle("Digest")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogProfileView: View {
    let snapshot: NewsBlogDashboardSnapshot
    let health: NewsBlogPublishingHealth
    let state: NewsBlogWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Editor") {
                    Label(state.editorName, systemImage: "person.crop.circle.fill")
                    Label(state.coverageFocus, systemImage: "scope")
                }
                Section("Publishing Health") {
                    Label("\(snapshot.publishedToday) stories today", systemImage: "newspaper.fill")
                    Label("\(health.moderationQueue) moderation items", systemImage: "tray.full.fill")
                    Label(state.newsletterSubscribers, systemImage: "person.2.fill")
                }
                Section("Operating Rhythm") {
                    Label(state.newsletterWindow, systemImage: "clock.fill")
                    Label(state.readingGoal, systemImage: "bookmark.fill")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogArticleDetailView: View {
    let article: NewsBlogArticle

    var body: some View {
        List {
            Section("Headline") {
                Text(article.title)
                    .font(.title3.weight(.bold))
                Text(article.summary)
                    .foregroundStyle(.secondary)
            }
            Section("Metadata") {
                Label(article.section, systemImage: "bookmark.square.fill")
                Label(article.author, systemImage: "person.fill")
                Label(article.readTime, systemImage: "clock.fill")
            }
            Section("Key Takeaways") {
                ForEach(article.takeaways, id: \.self) { takeaway in
                    Text(takeaway)
                }
            }
        }
        .navigationTitle("Reader")
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogSectionDetailView: View {
    let section: NewsBlogSection

    var body: some View {
        List {
            Section("Brief") {
                Text(section.description)
            }
            Section("Coverage Goals") {
                ForEach(section.focusPoints, id: \.self) { focus in
                    Label(focus, systemImage: "checkmark.circle.fill")
                }
            }
        }
        .navigationTitle(section.name)
    }
}

public struct NewsBlogQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [NewsBlogQuickAction] = [
        NewsBlogQuickAction(title: "Open Reader Mode", detail: "Preview long-form stories with distraction-free typography.", systemImage: "text.justify"),
        NewsBlogQuickAction(title: "Review Breaking Queue", detail: "Inspect embargo, moderation and live updates before publish.", systemImage: "bolt.fill"),
        NewsBlogQuickAction(title: "Schedule Newsletter", detail: "Lock the next digest with sections and sponsor placements.", systemImage: "envelope.fill")
    ]
}

struct NewsBlogWorkspaceState {
    let editorNote: String
    let newsletterWindow: String
    let editorName: String
    let coverageFocus: String
    let newsletterSubscribers: String
    let readingGoal: String
    let leadStory: NewsBlogArticle
    let trendingStories: [NewsBlogArticle]
    let savedReads: [NewsBlogArticle]
    let sections: [NewsBlogSection]
    let morningDigest: String
    let eveningDigest: String
    let digestPriorities: [String]

    static let sample = NewsBlogWorkspaceState(
        editorNote: "Morning desk is heavy on markets, AI policy and election explainers.",
        newsletterWindow: "Digest locks at 17:30",
        editorName: "Mila Hart",
        coverageFocus: "Global tech, business and policy",
        newsletterSubscribers: "148K active readers",
        readingGoal: "12 must-read stories saved",
        leadStory: NewsBlogArticle(
            title: "AI infrastructure spending reshapes the cloud leaderboard",
            section: "Business",
            author: "Ava Chen",
            readTime: "6 min read",
            summary: "Capital allocation is moving from experiments to long-term GPU and energy bets across hyperscalers.",
            takeaways: ["Cloud margins are under short-term pressure.", "Enterprise buyers want multi-model contracts.", "Power procurement is now a newsroom headline."]
        ),
        trendingStories: [
            NewsBlogArticle(title: "How reader mode improves long-form retention", section: "Product", author: "Noah Reed", readTime: "4 min read", summary: "Typography and progress cues are increasing completion rates on weekend editions.", takeaways: ["Session depth rises with cleaner layout.", "Pinned pull-quotes drive sharing."]),
            NewsBlogArticle(title: "Election explainers outperform breaking updates at lunch", section: "Politics", author: "Lena Torres", readTime: "5 min read", summary: "Readers are choosing context packages over minute-by-minute live blogs.", takeaways: ["Explainers keep bounce lower.", "Digest CTR climbs with one anchor analysis."])
        ],
        savedReads: [
            NewsBlogArticle(title: "The next wave of climate risk disclosures", section: "Policy", author: "Sofia Karim", readTime: "7 min read", summary: "Global regulators are converging on stricter transition-risk language.", takeaways: ["Disclosure templates are tightening.", "Investor relations teams need new tooling."]),
            NewsBlogArticle(title: "Why audio summaries belong in every editorial workflow", section: "Media", author: "Daniel Park", readTime: "3 min read", summary: "Short audio cuts are turning text stories into multi-format packages.", takeaways: ["Audio expands commute usage.", "Editorial reuse keeps cost efficient."])
        ],
        sections: [
            NewsBlogSection(name: "Top Stories", description: "The main homepage package with reader intent, urgency and trust balance.", storyCount: 8, focusPoints: ["Lead with one decisive thesis.", "Pair breaking story with one explainer."]),
            NewsBlogSection(name: "Tech", description: "Platform, AI and developer economy coverage with product literacy.", storyCount: 12, focusPoints: ["Keep vendor claims sourced.", "Separate model news from monetization angle."]),
            NewsBlogSection(name: "Business", description: "Markets, macro and operator-focused reporting for daily decision makers.", storyCount: 7, focusPoints: ["Frame impact before price action.", "Prefer sector comparisons over isolated moves."])
        ],
        morningDigest: "Open with the AI infrastructure thesis, then rotate to one market wrap and one policy explainer.",
        eveningDigest: "Close the day with executive summary, saved reads reminder and tomorrow watchlist.",
        digestPriorities: ["Lead with one decisive market angle", "Bundle three saved reads into weekend package", "Keep newsletter sponsor below the second story"]
    )
}

struct NewsBlogArticle: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let section: String
    let author: String
    let readTime: String
    let summary: String
    let takeaways: [String]
}

struct NewsBlogSection: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let storyCount: Int
    let focusPoints: [String]
}
