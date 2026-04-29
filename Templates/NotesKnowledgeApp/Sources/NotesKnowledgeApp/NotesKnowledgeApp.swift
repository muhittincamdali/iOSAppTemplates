import SwiftUI
import NotesKnowledgeAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct NotesKnowledgeAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            NotesKnowledgeRuntimeRootView()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeRuntimeRootView: View {
    @StateObject private var store = NotesKnowledgeOperationsStore()

    var body: some View {
        TabView {
            NotesKnowledgeDashboardView(store: store)
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Capture")
                }
            NotesKnowledgeLibraryView(store: store)
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Library")
                }
            NotesKnowledgeLinksView(store: store)
                .tabItem {
                    Image(systemName: "link.circle.fill")
                    Text("Links")
                }
            NotesKnowledgeSpacesView(store: store)
                .tabItem {
                    Image(systemName: "person.2.wave.2.fill")
                    Text("Spaces")
                }
            NotesKnowledgeProfileView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.purple)
    }
}

@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class NotesKnowledgeOperationsStore: ObservableObject {
    @Published var captureDraft = "Customer onboarding interview synthesis and two trust friction quotes."
    @Published var captures: [NotesCaptureRecord]
    @Published var libraryNotes: [KnowledgeNoteRecord]
    @Published var linkMaps: [KnowledgeLinkRecord]
    @Published var spaces: [KnowledgeSpaceRecord]
    @Published var operatorHeadline = "Knowledge inbox is under control and review drift is low."
    @Published var reviewWindow = "Weekly review locks at 16:30"

    init() {
        self.captures = [
            NotesCaptureRecord(title: "Pricing interview synthesis", summary: "Five quotes from buyer calls need conversion into one decision memo.", source: "Voice memo", owner: "Mila", isFiled: false),
            NotesCaptureRecord(title: "API migration checklist", summary: "Scratchpad from incident retro still needs structure and tags.", source: "Quick note", owner: "Devon", isFiled: false),
            NotesCaptureRecord(title: "Competitive launch screenshots", summary: "Twenty screenshots clipped for onboarding research review.", source: "Web clip", owner: "Sena", isFiled: false)
        ]
        self.libraryNotes = [
            KnowledgeNoteRecord(title: "Retention playbook for onboarding", collection: "Team Handbook", updatedAt: "Updated 12 min ago", owner: "Mila", summary: "Maps onboarding friction to lifecycle interventions and measurement points.", highlightCount: 2, isPinned: true),
            KnowledgeNoteRecord(title: "Q2 research themes", collection: "Research Notes", updatedAt: "Updated 48 min ago", owner: "Devon", summary: "Clusters user pain into trust, speed and admin-control themes.", highlightCount: 2, isPinned: false),
            KnowledgeNoteRecord(title: "Personal reflection archive", collection: "Personal Capture", updatedAt: "Updated yesterday", owner: "Sena", summary: "Private reflections and journaling prompts linked to weekly reviews.", highlightCount: 2, isPinned: false)
        ]
        self.linkMaps = [
            KnowledgeLinkRecord(title: "Onboarding > Activation > Retention", summary: "Core product chain linking setup friction to return behavior.", referenceCount: 18, owner: "Mila", isHealthy: true),
            KnowledgeLinkRecord(title: "Support signals > Product fixes", summary: "Maps customer complaints into backlog-ready evidence.", referenceCount: 11, owner: "Devon", isHealthy: true),
            KnowledgeLinkRecord(title: "Founder notes > Strategy memos", summary: "Connects raw founder captures to monthly operating decisions.", referenceCount: 9, owner: "Sena", isHealthy: false)
        ]
        self.spaces = [
            KnowledgeSpaceRecord(name: "Growth Research", description: "Shared space for experiments, interviews and synthesis notes.", members: 7, syncStatus: .synced),
            KnowledgeSpaceRecord(name: "Ops Handbook", description: "Operating procedures and incident response runbooks.", members: 12, syncStatus: .synced),
            KnowledgeSpaceRecord(name: "Founder Journal", description: "Private strategy memos shared with the exec circle.", members: 3, syncStatus: .needsSync)
        ]
    }

    var openCaptureCount: Int {
        captures.filter { !$0.isFiled }.count
    }

    func addCapture() {
        let trimmed = captureDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        captures.insert(
            NotesCaptureRecord(
                title: "Operator capture",
                summary: trimmed,
                source: "Manual entry",
                owner: "Mila",
                isFiled: false
            ),
            at: 0
        )
        captureDraft = ""
    }

    func fileCapture(_ capture: NotesCaptureRecord) {
        guard let index = captures.firstIndex(where: { $0.id == capture.id }) else { return }
        captures[index].isFiled = true
        libraryNotes.insert(
            KnowledgeNoteRecord(
                title: capture.title,
                collection: "Inbox Filed",
                updatedAt: "Just now",
                owner: capture.owner,
                summary: capture.summary,
                highlightCount: 1,
                isPinned: false
            ),
            at: 0
        )
        operatorHeadline = "\(capture.title) filed into the library and linked for review."
    }

    func pinNote(_ note: KnowledgeNoteRecord) {
        guard let index = libraryNotes.firstIndex(where: { $0.id == note.id }) else { return }
        libraryNotes[index].isPinned.toggle()
    }

    func promoteHighlight(_ note: KnowledgeNoteRecord) {
        guard let index = libraryNotes.firstIndex(where: { $0.id == note.id }) else { return }
        libraryNotes[index].highlightCount += 1
        libraryNotes[index].updatedAt = "Updated just now"
    }

    func refreshLinkMap(_ map: KnowledgeLinkRecord) {
        guard let index = linkMaps.firstIndex(where: { $0.id == map.id }) else { return }
        linkMaps[index].referenceCount += 1
        linkMaps[index].isHealthy = true
    }

    func syncSpace(_ space: KnowledgeSpaceRecord) {
        guard let index = spaces.firstIndex(where: { $0.id == space.id }) else { return }
        spaces[index].syncStatus = .synced
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeDashboardView: View {
    @ObservedObject var store: NotesKnowledgeOperationsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Knowledge Snapshot")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text(store.operatorHeadline)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text(store.reviewWindow)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 12) {
                            NotesKnowledgeMetricChip(title: "Inbox", value: "\(store.openCaptureCount)")
                            NotesKnowledgeMetricChip(title: "Notes", value: "\(store.libraryNotes.count)")
                            NotesKnowledgeMetricChip(title: "Links", value: "\(store.linkMaps.count)")
                        }
                    }
                    .padding(20)
                    .background(LinearGradient(colors: [.purple.opacity(0.18), .indigo.opacity(0.10)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 22))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Capture Inbox")
                            .font(.title3.weight(.bold))
                        TextField("Capture new note", text: $store.captureDraft, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(2...5)
                        Button("Add Capture") {
                            store.addCapture()
                        }
                        .buttonStyle(.borderedProminent)

                        ForEach(store.captures) { capture in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(capture.title)
                                        .font(.headline)
                                    Spacer()
                                    Text(capture.isFiled ? "Filed" : "Inbox")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(capture.isFiled ? .green : .orange)
                                }
                                Text(capture.summary)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                if !capture.isFiled {
                                    Button("File To Library") {
                                        store.fileCapture(capture)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Knowledge")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeLibraryView: View {
    @ObservedObject var store: NotesKnowledgeOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.libraryNotes) { note in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(note.title)
                            Spacer()
                            Text(note.collection)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                        Text(note.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HStack {
                            Button(note.isPinned ? "Unpin" : "Pin") {
                                store.pinNote(note)
                            }
                            .buttonStyle(.bordered)
                            Button("Promote Highlight") {
                                store.promoteHighlight(note)
                            }
                            .buttonStyle(.borderedProminent)
                            Text("\(note.highlightCount) highlights")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Library")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeLinksView: View {
    @ObservedObject var store: NotesKnowledgeOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.linkMaps) { map in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(map.title)
                            Spacer()
                            Text(map.isHealthy ? "Healthy" : "Needs repair")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(map.isHealthy ? .green : .orange)
                        }
                        Text(map.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HStack {
                            Text("\(map.referenceCount) refs")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Button("Refresh Links") {
                                store.refreshLinkMap(map)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Links")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeSpacesView: View {
    @ObservedObject var store: NotesKnowledgeOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.spaces) { space in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(space.name)
                            Spacer()
                            Text(space.syncStatus.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(space.syncStatus.color)
                        }
                        Text(space.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Button("Sync Space") {
                            store.syncSpace(space)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Spaces")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct NotesKnowledgeProfileView: View {
    @ObservedObject var store: NotesKnowledgeOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Librarian") {
                    Label("Mila Grant", systemImage: "person.crop.circle.fill")
                    Label("Product research and operating notes", systemImage: "scope")
                }
                Section("Knowledge Metrics") {
                    Label("\(store.libraryNotes.count) active notes", systemImage: "doc.text.fill")
                    Label("\(store.spaces.count) shared spaces", systemImage: "person.2.wave.2.fill")
                    Label("\(store.linkMaps.filter(\.isHealthy).count) healthy link maps", systemImage: "chart.line.uptrend.xyaxis")
                }
                Section("Operations") {
                    Label("\(store.openCaptureCount) items in review", systemImage: "tray.full.fill")
                    Label(store.reviewWindow, systemImage: "clock.fill")
                    Label(store.operatorHeadline, systemImage: "link.circle.fill")
                }
            }
            .navigationTitle("Profile")
        }
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

struct NotesCaptureRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let summary: String
    let source: String
    let owner: String
    var isFiled: Bool
}

struct KnowledgeNoteRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let collection: String
    var updatedAt: String
    let owner: String
    let summary: String
    var highlightCount: Int
    var isPinned: Bool
}

struct KnowledgeLinkRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let summary: String
    var referenceCount: Int
    let owner: String
    var isHealthy: Bool
}

enum KnowledgeSpaceSyncStatus: Hashable, Sendable {
    case synced
    case needsSync

    var label: String {
        switch self {
        case .synced: return "Synced"
        case .needsSync: return "Needs sync"
        }
    }

    var color: Color {
        switch self {
        case .synced: return .green
        case .needsSync: return .orange
        }
    }
}

struct KnowledgeSpaceRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let description: String
    let members: Int
    var syncStatus: KnowledgeSpaceSyncStatus
}
