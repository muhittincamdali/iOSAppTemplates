import SwiftUI
import NewsBlogAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct NewsBlogAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            NewsBlogRuntimeRootView()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogRuntimeRootView: View {
    @StateObject private var store = NewsBlogOperationsStore()

    var body: some View {
        TabView {
            NewsBlogTodayView(store: store)
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("Today")
                }
            NewsBlogSectionsView(store: store)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Sections")
                }
            NewsBlogSavedView(store: store)
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Saved")
                }
            NewsBlogDigestView(store: store)
                .tabItem {
                    Image(systemName: "envelope.open.fill")
                    Text("Digest")
                }
            NewsBlogProfileView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .tint(.orange)
    }
}

@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class NewsBlogOperationsStore: ObservableObject {
    @Published var leadStory: NewsBlogArticleRecord
    @Published var trendingStories: [NewsBlogArticleRecord]
    @Published var savedReads: [NewsBlogArticleRecord]
    @Published var sections: [NewsBlogSectionRecord]
    @Published var digestItems: [NewsBlogDigestItem]
    @Published var moderationQueue: [NewsBlogModerationItem]
    @Published var editorNote = "Morning desk is leaning into AI infrastructure, labor policy and platform trust."
    @Published var digestStatus = "Digest draft open"
    @Published var newsletterSubscribers = 148_000

    init() {
        let leadStory = NewsBlogArticleRecord(title: "AI infrastructure spending reshapes the cloud leaderboard", section: "Business", author: "Ava Chen", readTime: "6 min", summary: "Capital allocation is moving from experiments to long-term GPU and energy bets across hyperscalers.", takeaways: ["Cloud margins are under short-term pressure.", "Enterprise buyers want multi-model contracts.", "Power procurement is now a newsroom headline."], isSaved: false, isPublished: true, isInDigest: true)
        let trendingStories = [
            NewsBlogArticleRecord(title: "How reader mode improves long-form retention", section: "Product", author: "Noah Reed", readTime: "4 min", summary: "Typography and progress cues are increasing completion rates on weekend editions.", takeaways: ["Session depth rises with cleaner layout.", "Pinned pull-quotes drive sharing."], isSaved: true, isPublished: true, isInDigest: false),
            NewsBlogArticleRecord(title: "Election explainers outperform breaking updates at lunch", section: "Politics", author: "Lena Torres", readTime: "5 min", summary: "Readers are choosing context packages over minute-by-minute live blogs.", takeaways: ["Explainers keep bounce lower.", "Digest CTR climbs with one anchor analysis."], isSaved: false, isPublished: false, isInDigest: false),
            NewsBlogArticleRecord(title: "Climate risk disclosures move into the CFO stack", section: "Policy", author: "Sofia Karim", readTime: "7 min", summary: "Regulators are converging on stricter transition-risk language across markets.", takeaways: ["Disclosure templates are tightening.", "Investor relations teams need new tooling."], isSaved: false, isPublished: true, isInDigest: false)
        ]
        self.leadStory = leadStory
        self.trendingStories = trendingStories
        self.savedReads = trendingStories.filter(\.isSaved)
        self.sections = [
            NewsBlogSectionRecord(name: "Top Stories", description: "Main homepage package balancing urgency, trust and completion.", storyCount: 8, focusPoints: ["Pair one breaking lead with one explainers package.", "Never bury the trust angle."]),
            NewsBlogSectionRecord(name: "Tech", description: "Platform, AI and developer economy coverage with product literacy.", storyCount: 12, focusPoints: ["Separate vendor claims from source-backed facts.", "Keep monetization angle explicit."]),
            NewsBlogSectionRecord(name: "Business", description: "Markets, macro and operator-focused reporting for daily decision makers.", storyCount: 7, focusPoints: ["Frame impact before price action.", "Use comparisons instead of isolated moves."])
        ]
        self.digestItems = [
            NewsBlogDigestItem(title: "Lead with one decisive market angle", isIncluded: true),
            NewsBlogDigestItem(title: "Bundle three saved reads into the weekend package", isIncluded: true),
            NewsBlogDigestItem(title: "Keep sponsor below the second story", isIncluded: false)
        ]
        self.moderationQueue = [
            NewsBlogModerationItem(title: "Breaking policy update", detail: "Needs source confirmation before homepage push.", status: .review),
            NewsBlogModerationItem(title: "Election explainer package", detail: "Headline approved, waiting on graphics sync.", status: .blocked)
        ]
    }

    var publishedCount: Int {
        ([leadStory] + trendingStories).filter(\.isPublished).count
    }

    var savedCount: Int {
        savedReads.count
    }

    func toggleSave(_ article: NewsBlogArticleRecord) {
        if leadStory.id == article.id {
            leadStory.isSaved.toggle()
            syncSavedReads(with: leadStory)
            return
        }
        guard let index = trendingStories.firstIndex(where: { $0.id == article.id }) else { return }
        trendingStories[index].isSaved.toggle()
        syncSavedReads(with: trendingStories[index])
    }

    func promoteToLead(_ article: NewsBlogArticleRecord) {
        guard let index = trendingStories.firstIndex(where: { $0.id == article.id }) else { return }
        let previousLead = leadStory
        leadStory = trendingStories[index]
        leadStory.isPublished = true
        trendingStories[index] = previousLead
        digestStatus = "Lead updated for next homepage refresh"
    }

    func publishArticle(_ article: NewsBlogArticleRecord) {
        guard let index = trendingStories.firstIndex(where: { $0.id == article.id }) else { return }
        trendingStories[index].isPublished = true
        digestStatus = "Story published and ready for digest consideration"
    }

    func toggleDigestInclusion(_ article: NewsBlogArticleRecord) {
        if leadStory.id == article.id {
            leadStory.isInDigest.toggle()
            return
        }
        guard let index = trendingStories.firstIndex(where: { $0.id == article.id }) else { return }
        trendingStories[index].isInDigest.toggle()
    }

    func toggleDigestPriority(_ item: NewsBlogDigestItem) {
        guard let index = digestItems.firstIndex(where: { $0.id == item.id }) else { return }
        digestItems[index].isIncluded.toggle()
    }

    func publishDigest() {
        digestStatus = "Digest locked and queued for \(newsletterSubscribers.formatted()) readers"
    }

    func resolveModeration(_ item: NewsBlogModerationItem) {
        guard let index = moderationQueue.firstIndex(where: { $0.id == item.id }) else { return }
        moderationQueue[index].status = .resolved
    }

    func escalateModeration(_ item: NewsBlogModerationItem) {
        guard let index = moderationQueue.firstIndex(where: { $0.id == item.id }) else { return }
        moderationQueue[index].status = .escalated
        digestStatus = "Moderation escalated before digest lock"
    }

    private func syncSavedReads(with article: NewsBlogArticleRecord) {
        savedReads.removeAll(where: { $0.id == article.id })
        if article.isSaved {
            savedReads.insert(article, at: 0)
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogTodayView: View {
    @ObservedObject var store: NewsBlogOperationsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Publishing Snapshot")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text(store.leadStory.title)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        Text(store.editorNote)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 12) {
                            NewsBlogMetricChip(title: "Published", value: "\(store.publishedCount)")
                            NewsBlogMetricChip(title: "Saved", value: "\(store.savedCount)")
                            NewsBlogMetricChip(title: "Queue", value: "\(store.moderationQueue.filter { $0.status != .resolved }.count)")
                        }
                    }
                    .padding(20)
                    .background(LinearGradient(colors: [.orange.opacity(0.18), .red.opacity(0.10)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 22))

                    NewsBlogArticleCard(article: store.leadStory, primaryLabel: "Lead Story", onSave: { store.toggleSave(store.leadStory) }, onPrimaryAction: nil, primaryButtonTitle: nil)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Trending Now")
                            .font(.title3.weight(.bold))
                        ForEach(store.trendingStories) { article in
                            NewsBlogArticleCard(article: article, primaryLabel: article.section, onSave: { store.toggleSave(article) }, onPrimaryAction: {
                                if article.isPublished {
                                    store.promoteToLead(article)
                                } else {
                                    store.publishArticle(article)
                                }
                            }, primaryButtonTitle: article.isPublished ? "Promote To Lead" : "Publish")
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Editorial Desk")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogSectionsView: View {
    @ObservedObject var store: NewsBlogOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Sections") {
                    ForEach(store.sections) { section in
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

                Section("Moderation Queue") {
                    ForEach(store.moderationQueue) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(item.title)
                                Spacer()
                                Text(item.status.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(item.status.color)
                            }
                            Text(item.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            if item.status != .resolved {
                                HStack {
                                    Button("Resolve") { store.resolveModeration(item) }
                                        .buttonStyle(.borderedProminent)
                                    Button("Escalate") { store.escalateModeration(item) }
                                        .buttonStyle(.bordered)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Sections")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogSavedView: View {
    @ObservedObject var store: NewsBlogOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.savedReads) { article in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(article.title)
                            .font(.headline)
                        Text(article.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HStack {
                            Button(article.isInDigest ? "Remove From Digest" : "Add To Digest") {
                                store.toggleDigestInclusion(article)
                            }
                            .buttonStyle(.bordered)
                            Button("Unsave") {
                                store.toggleSave(article)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Saved Reads")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogDigestView: View {
    @ObservedObject var store: NewsBlogOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Digest Status") {
                    Text(store.digestStatus)
                }

                Section("Digest Stories") {
                    ForEach(([store.leadStory] + store.trendingStories).filter(\.isPublished)) { article in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(article.title)
                                Text(article.section)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button(article.isInDigest ? "Included" : "Exclude") {
                                store.toggleDigestInclusion(article)
                            }
                        }
                    }
                }

                Section("Newsletter Priorities") {
                    ForEach(store.digestItems) { item in
                        HStack {
                            Text(item.title)
                            Spacer()
                            Button(item.isIncluded ? "On" : "Off") {
                                store.toggleDigestPriority(item)
                            }
                        }
                    }
                }

                Section {
                    Button("Publish Digest") {
                        store.publishDigest()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Digest")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NewsBlogProfileView: View {
    @ObservedObject var store: NewsBlogOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Editor") {
                    Label("Mila Hart", systemImage: "person.crop.circle.fill")
                    Label("Global tech, business and policy", systemImage: "scope")
                }
                Section("Publishing Health") {
                    Label("\(store.publishedCount) stories live", systemImage: "newspaper.fill")
                    Label("\(store.moderationQueue.filter { $0.status != .resolved }.count) moderation items", systemImage: "tray.full.fill")
                    Label("\(store.newsletterSubscribers.formatted()) active readers", systemImage: "person.2.fill")
                }
                Section("Operating Rhythm") {
                    Label(store.digestStatus, systemImage: "clock.fill")
                    Label("\(store.savedCount) saved reads tracked", systemImage: "bookmark.fill")
                }
            }
            .navigationTitle("Profile")
        }
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
struct NewsBlogArticleCard: View {
    let article: NewsBlogArticleRecord
    let primaryLabel: String
    let onSave: () -> Void
    let onPrimaryAction: (() -> Void)?
    let primaryButtonTitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(primaryLabel)
                .font(.title3.weight(.bold))
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
            HStack {
                Button(article.isSaved ? "Unsave" : "Save") { onSave() }
                    .buttonStyle(.bordered)
                if let onPrimaryAction, let primaryButtonTitle {
                    Button(primaryButtonTitle) { onPrimaryAction() }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct NewsBlogArticleRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let section: String
    let author: String
    let readTime: String
    let summary: String
    let takeaways: [String]
    var isSaved: Bool
    var isPublished: Bool
    var isInDigest: Bool
}

struct NewsBlogSectionRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let description: String
    let storyCount: Int
    let focusPoints: [String]
}

struct NewsBlogDigestItem: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    var isIncluded: Bool
}

enum NewsBlogModerationStatus: Hashable, Sendable {
    case review
    case blocked
    case escalated
    case resolved

    var label: String {
        switch self {
        case .review: return "Review"
        case .blocked: return "Blocked"
        case .escalated: return "Escalated"
        case .resolved: return "Resolved"
        }
    }

    var color: Color {
        switch self {
        case .review: return .orange
        case .blocked: return .red
        case .escalated: return .indigo
        case .resolved: return .green
        }
    }
}

struct NewsBlogModerationItem: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let detail: String
    var status: NewsBlogModerationStatus
}
