import SwiftUI
import NotesKnowledgeAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct NotesKnowledgeAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            NotesKnowledgeWorkspaceRootView(
                snapshot: .sample,
                collections: NotesKnowledgeCollectionCard.sampleCards,
                actions: NotesKnowledgeQuickAction.defaultActions,
                health: .sample,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeWorkspaceRootView: View {
    let snapshot: NotesKnowledgeDashboardSnapshot
    let collections: [NotesKnowledgeCollectionCard]
    let actions: [NotesKnowledgeQuickAction]
    let health: NotesKnowledgeOperationalHealth
    let state: NotesKnowledgeWorkspaceState

    var body: some View {
        TabView {
            NotesKnowledgeDashboardView(
                snapshot: snapshot,
                collections: collections,
                actions: actions,
                health: health,
                state: state
            )
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Capture")
            }

            NotesKnowledgeLibraryView(state: state)
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Library")
                }

            NotesKnowledgeLinksView(state: state)
                .tabItem {
                    Image(systemName: "link.circle.fill")
                    Text("Links")
                }

            NotesKnowledgeSpacesView(state: state)
                .tabItem {
                    Image(systemName: "person.2.wave.2.fill")
                    Text("Spaces")
                }

            NotesKnowledgeProfileView(snapshot: snapshot, health: health, state: state)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.purple)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeDashboardView: View {
    let snapshot: NotesKnowledgeDashboardSnapshot
    let collections: [NotesKnowledgeCollectionCard]
    let actions: [NotesKnowledgeQuickAction]
    let health: NotesKnowledgeOperationalHealth
    let state: NotesKnowledgeWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    NotesKnowledgeHeroCard(snapshot: snapshot, health: health, state: state)
                    NotesKnowledgeQuickActionGrid(actions: actions)
                    NotesKnowledgeCaptureInboxCard(state: state)
                    NotesKnowledgeCollectionPulseCard(collections: collections)
                    NotesKnowledgeRecentHighlightsCard(notes: state.recentHighlights)
                }
                .padding(16)
            }
            .navigationTitle("Knowledge")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeHeroCard: View {
    let snapshot: NotesKnowledgeDashboardSnapshot
    let health: NotesKnowledgeOperationalHealth
    let state: NotesKnowledgeWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Knowledge Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(state.operatorHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(snapshot.syncHealth)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                NotesKnowledgeMetricChip(title: "Notes", value: "\(snapshot.activeNotes)")
                NotesKnowledgeMetricChip(title: "Spaces", value: "\(snapshot.sharedSpaces)")
                NotesKnowledgeMetricChip(title: "Captured", value: "\(snapshot.capturedIdeasToday)")
            }

            HStack {
                Label(state.reviewWindow, systemImage: "clock.fill")
                Spacer()
                Text("\(health.linkedReferencesToday) links today")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.purple)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.purple.opacity(0.18), .indigo.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeMetricChip: View {
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
struct NotesKnowledgeQuickActionGrid: View {
    let actions: [NotesKnowledgeQuickAction]

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
struct NotesKnowledgeCaptureInboxCard: View {
    let state: NotesKnowledgeWorkspaceState

    var body: some View {
        NavigationLink {
            NotesKnowledgeCaptureDetailView(captures: state.captureInbox)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                Text("Capture Inbox")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                Text(state.captureHeadline)
                    .font(.headline)
                Text(state.captureSummary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack {
                    Label("\(state.captureInbox.count) items waiting", systemImage: "tray.and.arrow.down.fill")
                    Spacer()
                    Text(state.captureOwner)
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
struct NotesKnowledgeCollectionPulseCard: View {
    let collections: [NotesKnowledgeCollectionCard]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Collection Pulse")
                .font(.title3.weight(.bold))

            ForEach(collections) { collection in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(collection.title)
                            .font(.headline)
                        Text("\(collection.documentCount) documents")
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
struct NotesKnowledgeRecentHighlightsCard: View {
    let notes: [NotesKnowledgeNote]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Highlights")
                .font(.title3.weight(.bold))

            ForEach(notes) { note in
                NavigationLink {
                    NotesKnowledgeNoteDetailView(note: note)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(note.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(note.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                        Text("\(note.collection) • \(note.updatedAt)")
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
struct NotesKnowledgeLibraryView: View {
    let state: NotesKnowledgeWorkspaceState

    var body: some View {
        NavigationStack {
            List(state.libraryNotes) { note in
                NavigationLink {
                    NotesKnowledgeNoteDetailView(note: note)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(note.title)
                        Text(note.collection)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(note.summary)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Library")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeLinksView: View {
    let state: NotesKnowledgeWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.linkMaps) { map in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(map.title)
                        Text(map.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(map.referenceCount) references • \(map.owner)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Links")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeSpacesView: View {
    let state: NotesKnowledgeWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.sharedSpaces) { space in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(space.name)
                        Text(space.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(space.members) members • \(space.syncStatus)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Spaces")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeProfileView: View {
    let snapshot: NotesKnowledgeDashboardSnapshot
    let health: NotesKnowledgeOperationalHealth
    let state: NotesKnowledgeWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Librarian") {
                    Label(state.librarianName, systemImage: "person.crop.circle.fill")
                    Label(state.scope, systemImage: "scope")
                }
                Section("Knowledge Metrics") {
                    Label("\(snapshot.activeNotes) active notes", systemImage: "doc.text.fill")
                    Label("\(snapshot.sharedSpaces) shared spaces", systemImage: "person.2.wave.2.fill")
                    Label("\(state.reviewRate) weekly review rate", systemImage: "chart.line.uptrend.xyaxis")
                }
                Section("Operations") {
                    Label("\(health.reviewQueue) items in review", systemImage: "tray.full.fill")
                    Label(health.offlineReady ? "Offline ready" : "Offline degraded", systemImage: health.offlineReady ? "icloud.and.arrow.down.fill" : "icloud.slash.fill")
                    Label(state.backlinkPolicy, systemImage: "link.circle.fill")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeCaptureDetailView: View {
    let captures: [NotesKnowledgeCapture]

    var body: some View {
        List(captures) { capture in
            VStack(alignment: .leading, spacing: 6) {
                Text(capture.title)
                    .font(.headline)
                Text(capture.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("\(capture.source) • \(capture.owner)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Capture Inbox")
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeNoteDetailView: View {
    let note: NotesKnowledgeNote

    var body: some View {
        List {
            Section("Note") {
                Text(note.title)
                    .font(.title3.weight(.bold))
                Text(note.summary)
                    .foregroundStyle(.secondary)
            }
            Section("Metadata") {
                Label(note.collection, systemImage: "folder.fill")
                Label(note.updatedAt, systemImage: "clock.fill")
                Label(note.owner, systemImage: "person.fill")
            }
            Section("Highlights") {
                ForEach(note.highlights, id: \.self) { highlight in
                    Text(highlight)
                }
            }
        }
        .navigationTitle("Note")
    }
}

public struct NotesKnowledgeQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [NotesKnowledgeQuickAction] = [
        NotesKnowledgeQuickAction(title: "Open Capture Inbox", detail: "Sort fresh notes, voice memos and clipped links before they drift.", systemImage: "tray.and.arrow.down.fill"),
        NotesKnowledgeQuickAction(title: "Review Knowledge Links", detail: "Tighten backlinks, tags and source references across active notes.", systemImage: "link.circle.fill"),
        NotesKnowledgeQuickAction(title: "Sync Shared Spaces", detail: "Verify shared docs and team spaces are aligned before review day.", systemImage: "person.2.wave.2.fill")
    ]
}

struct NotesKnowledgeWorkspaceState {
    let operatorHeadline: String
    let reviewWindow: String
    let captureHeadline: String
    let captureSummary: String
    let captureOwner: String
    let librarianName: String
    let scope: String
    let reviewRate: String
    let backlinkPolicy: String
    let captureInbox: [NotesKnowledgeCapture]
    let recentHighlights: [NotesKnowledgeNote]
    let libraryNotes: [NotesKnowledgeNote]
    let linkMaps: [NotesKnowledgeLinkMap]
    let sharedSpaces: [NotesKnowledgeSpace]

    static let sample = NotesKnowledgeWorkspaceState(
        operatorHeadline: "Knowledge inbox is under control",
        reviewWindow: "Weekly review locks at 16:30",
        captureHeadline: "Thirteen new ideas need placement",
        captureSummary: "Research clips, meeting notes and one voice memo are waiting for taxonomy cleanup.",
        captureOwner: "Owned by Mila",
        librarianName: "Mila Grant",
        scope: "Product research and operating notes",
        reviewRate: "91%",
        backlinkPolicy: "Every durable note must carry one source and one backlink",
        captureInbox: [
            NotesKnowledgeCapture(title: "Pricing interview synthesis", summary: "Five quotes from buyer calls need conversion into one decision memo.", source: "Voice memo", owner: "Mila"),
            NotesKnowledgeCapture(title: "API migration checklist", summary: "Scratchpad from incident retro still needs structure and tags.", source: "Quick note", owner: "Devon"),
            NotesKnowledgeCapture(title: "Competitive launch screenshots", summary: "Twenty screenshots clipped for onboarding research review.", source: "Web clip", owner: "Sena")
        ],
        recentHighlights: [
            NotesKnowledgeNote(title: "Retention playbook for onboarding", collection: "Team Handbook", updatedAt: "Updated 12 min ago", owner: "Mila", summary: "Maps onboarding friction to lifecycle interventions and measurement points.", highlights: ["Early activation triggers outperform discount prompts.", "Saved-state continuity reduces second-session churn."]),
            NotesKnowledgeNote(title: "Q2 research themes", collection: "Research Notes", updatedAt: "Updated 48 min ago", owner: "Devon", summary: "Clusters user pain into trust, speed and admin-control themes.", highlights: ["Trust gaps appear before pricing objections.", "Admins want better export controls."])
        ],
        libraryNotes: [
            NotesKnowledgeNote(title: "Retention playbook for onboarding", collection: "Team Handbook", updatedAt: "Updated 12 min ago", owner: "Mila", summary: "Maps onboarding friction to lifecycle interventions and measurement points.", highlights: ["Early activation triggers outperform discount prompts.", "Saved-state continuity reduces second-session churn."]),
            NotesKnowledgeNote(title: "Q2 research themes", collection: "Research Notes", updatedAt: "Updated 48 min ago", owner: "Devon", summary: "Clusters user pain into trust, speed and admin-control themes.", highlights: ["Trust gaps appear before pricing objections.", "Admins want better export controls."]),
            NotesKnowledgeNote(title: "Personal reflection archive", collection: "Personal Capture", updatedAt: "Updated yesterday", owner: "Sena", summary: "Private reflections and journaling prompts linked to weekly reviews.", highlights: ["Tag mood separately from decision notes.", "Keep one synthesis note per week."])
        ],
        linkMaps: [
            NotesKnowledgeLinkMap(title: "Onboarding > Activation > Retention", summary: "Core product chain linking setup friction to return behavior.", referenceCount: 18, owner: "Mila"),
            NotesKnowledgeLinkMap(title: "Support signals > Product fixes", summary: "Maps customer complaints into backlog-ready evidence.", referenceCount: 11, owner: "Devon"),
            NotesKnowledgeLinkMap(title: "Founder notes > Strategy memos", summary: "Connects raw founder captures to monthly operating decisions.", referenceCount: 9, owner: "Sena")
        ],
        sharedSpaces: [
            NotesKnowledgeSpace(name: "Growth Research", description: "Shared space for experiments, interviews and synthesis notes.", members: 7, syncStatus: "Synced 3 min ago"),
            NotesKnowledgeSpace(name: "Ops Handbook", description: "Operating procedures and incident response runbooks.", members: 12, syncStatus: "Synced 9 min ago"),
            NotesKnowledgeSpace(name: "Founder Journal", description: "Private strategy memos shared with the exec circle.", members: 3, syncStatus: "Synced 21 min ago")
        ]
    )
}

struct NotesKnowledgeCapture: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let summary: String
    let source: String
    let owner: String
}

struct NotesKnowledgeNote: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let collection: String
    let updatedAt: String
    let owner: String
    let summary: String
    let highlights: [String]
}

struct NotesKnowledgeLinkMap: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let summary: String
    let referenceCount: Int
    let owner: String
}

struct NotesKnowledgeSpace: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let members: Int
    let syncStatus: String
}
