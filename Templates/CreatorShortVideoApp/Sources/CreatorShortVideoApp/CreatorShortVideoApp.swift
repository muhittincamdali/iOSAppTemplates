import SwiftUI
import CreatorShortVideoAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct CreatorShortVideoAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            CreatorShortVideoRuntimeRootView()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoRuntimeRootView: View {
    @StateObject private var store = CreatorShortVideoStudioStore()

    var body: some View {
        TabView {
            CreatorShortVideoStudioHomeView(store: store)
                .tabItem {
                    Image(systemName: "camera.aperture")
                    Text("Studio")
                }

            CreatorShortVideoDraftBoardView(store: store)
                .tabItem {
                    Image(systemName: "film.stack.fill")
                    Text("Drafts")
                }

            CreatorShortVideoAnalyticsWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Analytics")
                }

            CreatorShortVideoModerationWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "shield.lefthalf.filled")
                    Text("Moderation")
                }

            CreatorShortVideoStudioProfileView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.pink)
    }
}

@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class CreatorShortVideoStudioStore: ObservableObject {
    @Published var drafts: [CreatorShortVideoDraftRecord]
    @Published var publishedClips: [CreatorShortVideoPublishedClip]
    @Published var moderationCases: [CreatorShortVideoModerationCase]
    @Published var communityQueues: [CreatorShortVideoCommunityQueue]
    @Published var creatorPrograms: [CreatorShortVideoProgram]
    @Published var composer = CreatorShortVideoComposerState.sample
    @Published var selectedDraftFilter: CreatorShortVideoDraftFilter = .all

    init(
        drafts: [CreatorShortVideoDraftRecord] = CreatorShortVideoDraftRecord.sampleDrafts,
        publishedClips: [CreatorShortVideoPublishedClip] = CreatorShortVideoPublishedClip.samplePublished,
        moderationCases: [CreatorShortVideoModerationCase] = CreatorShortVideoModerationCase.sampleCases,
        communityQueues: [CreatorShortVideoCommunityQueue] = CreatorShortVideoCommunityQueue.sampleQueues,
        creatorPrograms: [CreatorShortVideoProgram] = CreatorShortVideoProgram.samplePrograms
    ) {
        self.drafts = drafts
        self.publishedClips = publishedClips
        self.moderationCases = moderationCases
        self.communityQueues = communityQueues
        self.creatorPrograms = creatorPrograms
    }

    var readyDrafts: [CreatorShortVideoDraftRecord] {
        drafts.filter { $0.status == .ready || $0.status == .scheduled }
    }

    var filteredDrafts: [CreatorShortVideoDraftRecord] {
        drafts.filter { selectedDraftFilter.includes($0.status) }
    }

    var totalViews: Int {
        publishedClips.reduce(0) { $0 + $1.views }
    }

    var totalShares: Int {
        publishedClips.reduce(0) { $0 + $1.shares }
    }

    var averageCompletionRate: Int {
        guard !publishedClips.isEmpty else { return 0 }
        let total = publishedClips.reduce(0) { $0 + $1.completionRate }
        return total / publishedClips.count
    }

    var highRiskCases: Int {
        moderationCases.filter { $0.severity == .high }.count
    }

    var backlogHealthText: String {
        if highRiskCases > 0 {
            return "\(highRiskCases) high-risk moderation cases need escalation."
        }

        if readyDrafts.count >= 3 {
            return "Publishing queue is healthy for the next release window."
        }

        return "Draft pipeline is thin. Creator capture sprint should start now."
    }

    var nextReleaseWindow: String {
        readyDrafts.first?.releaseWindow ?? "Build a new clip for tonight's drop"
    }

    func queueComposerDraft() {
        let normalizedTitle = composer.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedHook = composer.hook.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedCTA = composer.callToAction.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !normalizedTitle.isEmpty, !normalizedHook.isEmpty, !normalizedCTA.isEmpty else {
            return
        }

        let newDraft = CreatorShortVideoDraftRecord(
            title: normalizedTitle,
            channel: composer.channel,
            duration: composer.duration,
            owner: composer.owner,
            status: .editing,
            summary: composer.summary,
            hook: normalizedHook,
            callToAction: normalizedCTA,
            coverStyle: composer.coverStyle,
            releaseWindow: composer.releaseWindow,
            tasks: [
                .init(title: "Capture A-roll hook", isComplete: true),
                .init(title: "Trim first 2 seconds", isComplete: false),
                .init(title: "Add captions and CTA end card", isComplete: false),
                .init(title: "Brand safety and legal pass", isComplete: !composer.requiresLegalReview)
            ],
            needsLegalReview: composer.requiresLegalReview,
            commentRisk: composer.requiresLegalReview ? "Needs policy review before scheduling." : "Low comment risk."
        )

        drafts.insert(newDraft, at: 0)
        composer = .sample
        selectedDraftFilter = .all
    }

    func toggleTask(for draftID: UUID, taskID: UUID) {
        guard let draftIndex = drafts.firstIndex(where: { $0.id == draftID }),
              let taskIndex = drafts[draftIndex].tasks.firstIndex(where: { $0.id == taskID }) else {
            return
        }

        drafts[draftIndex].tasks[taskIndex].isComplete.toggle()

        if drafts[draftIndex].tasks.allSatisfy(\.isComplete) {
            drafts[draftIndex].status = drafts[draftIndex].needsLegalReview ? .review : .ready
        } else if drafts[draftIndex].status == .ready || drafts[draftIndex].status == .scheduled {
            drafts[draftIndex].status = .editing
        }
    }

    func sendForReview(_ draftID: UUID) {
        guard let draftIndex = drafts.firstIndex(where: { $0.id == draftID }) else {
            return
        }

        drafts[draftIndex].status = .review
    }

    func schedule(_ draftID: UUID) {
        guard let draftIndex = drafts.firstIndex(where: { $0.id == draftID }) else {
            return
        }

        drafts[draftIndex].status = .scheduled
    }

    func publish(_ draftID: UUID) {
        guard let draftIndex = drafts.firstIndex(where: { $0.id == draftID }) else {
            return
        }

        let draft = drafts[draftIndex]
        drafts[draftIndex].status = .published

        let newClip = CreatorShortVideoPublishedClip(
            title: draft.title,
            channel: draft.channel,
            views: 24_000 + publishedClips.count * 2_700,
            completionRate: draft.needsLegalReview ? 54 : 67,
            shares: 1_400 + publishedClips.count * 120,
            summary: draft.summary,
            outcome: "Published from studio queue after caption, CTA, and moderation checks."
        )

        publishedClips.insert(newClip, at: 0)
        drafts.remove(at: draftIndex)
    }

    func approveModerationCase(_ caseID: UUID) {
        updateModerationCase(caseID) { moderationCase in
            moderationCase.status = .approved
            moderationCase.resolution = "Approved for publishing after policy pass and caption review."
        }
    }

    func escalateModerationCase(_ caseID: UUID) {
        updateModerationCase(caseID) { moderationCase in
            moderationCase.status = .escalated
            moderationCase.resolution = "Escalated to legal and brand safety review before release."
        }
    }

    func resolveCommunityQueue(_ queueID: UUID) {
        guard let queueIndex = communityQueues.firstIndex(where: { $0.id == queueID }) else {
            return
        }

        communityQueues[queueIndex].status = "Resolved"
        communityQueues[queueIndex].summary = "Queue cleared and routed into tonight's creator operations update."
    }

    private func updateModerationCase(_ caseID: UUID, mutation: (inout CreatorShortVideoModerationCase) -> Void) {
        guard let caseIndex = moderationCases.firstIndex(where: { $0.id == caseID }) else {
            return
        }

        mutation(&moderationCases[caseIndex])
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoStudioHomeView: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CreatorShortVideoRuntimeHeroCard(store: store)
                    CreatorShortVideoComposerCard(store: store)
                    CreatorShortVideoReadyQueueSection(store: store)
                    CreatorShortVideoProgramSection(programs: store.creatorPrograms)
                }
                .padding(16)
            }
            .navigationTitle("Creator Studio")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoRuntimeHeroCard: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Release Control")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(store.backlogHealthText)
                .font(.system(size: 30, weight: .bold, design: .rounded))

            Text("Next window: \(store.nextReleaseWindow)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                CreatorShortVideoSummaryChip(title: "Drafts", value: "\(store.drafts.count)")
                CreatorShortVideoSummaryChip(title: "Published", value: "\(store.publishedClips.count)")
                CreatorShortVideoSummaryChip(title: "Flags", value: "\(store.highRiskCases)")
            }
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
struct CreatorShortVideoSummaryChip: View {
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
struct CreatorShortVideoComposerCard: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Compose New Clip")
                .font(.title3.weight(.bold))

            TextField("Clip title", text: $store.composer.title)
                .textFieldStyle(.roundedBorder)

            TextField("Hook", text: $store.composer.hook)
                .textFieldStyle(.roundedBorder)

            TextField("Summary", text: $store.composer.summary, axis: .vertical)
                .lineLimit(3, reservesSpace: true)
                .textFieldStyle(.roundedBorder)

            HStack {
                Picker("Channel", selection: $store.composer.channel) {
                    ForEach(CreatorShortVideoChannel.allCases, id: \.self) { channel in
                        Text(channel.rawValue).tag(channel)
                    }
                }

                Picker("Duration", selection: $store.composer.duration) {
                    ForEach(CreatorShortVideoDuration.allCases, id: \.self) { duration in
                        Text(duration.rawValue).tag(duration)
                    }
                }
            }

            HStack {
                TextField("CTA", text: $store.composer.callToAction)
                    .textFieldStyle(.roundedBorder)
                TextField("Owner", text: $store.composer.owner)
                    .textFieldStyle(.roundedBorder)
            }

            HStack {
                TextField("Cover style", text: $store.composer.coverStyle)
                    .textFieldStyle(.roundedBorder)
                TextField("Release window", text: $store.composer.releaseWindow)
                    .textFieldStyle(.roundedBorder)
            }

            Toggle("Requires legal review", isOn: $store.composer.requiresLegalReview)

            Button {
                store.queueComposerDraft()
            } label: {
                Label("Queue Draft", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoReadyQueueSection: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ready To Ship")
                .font(.title3.weight(.bold))

            if store.readyDrafts.isEmpty {
                ContentUnavailableView(
                    "No clips ready",
                    systemImage: "tray",
                    description: Text("Finish editing or queue a new clip to fill tonight's release window.")
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                ForEach(store.readyDrafts) { draft in
                    NavigationLink {
                        CreatorShortVideoDraftDetailView(store: store, draftID: draft.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(draft.title)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text(draft.status.rawValue)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(draft.status.tint)
                            }

                            Text(draft.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)

                            Text("\(draft.channel.rawValue) • \(draft.duration.rawValue) • \(draft.releaseWindow)")
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
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoProgramSection: View {
    let programs: [CreatorShortVideoProgram]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Creator Programs")
                .font(.title3.weight(.bold))

            ForEach(programs) { program in
                NavigationLink {
                    CreatorShortVideoProgramDetailView(program: program)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(program.name)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(program.deliveryHealth)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(program.healthColor)
                        }
                        Text(program.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("\(program.creators) creators • \(program.weeklyClips) clips / week")
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
struct CreatorShortVideoDraftBoardView: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        NavigationStack {
            List {
                Picker("Filter", selection: $store.selectedDraftFilter) {
                    ForEach(CreatorShortVideoDraftFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)

                ForEach(store.filteredDrafts) { draft in
                    NavigationLink {
                        CreatorShortVideoDraftDetailView(store: store, draftID: draft.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(draft.title)
                                    .font(.headline)
                                Spacer()
                                Text(draft.status.rawValue)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(draft.status.tint)
                            }
                            Text(draft.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("\(draft.channel.rawValue) • \(draft.releaseWindow)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Draft Board")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoDraftDetailView: View {
    @ObservedObject var store: CreatorShortVideoStudioStore
    let draftID: UUID

    private var draft: CreatorShortVideoDraftRecord? {
        store.drafts.first { $0.id == draftID }
    }

    var body: some View {
        Group {
            if let draft {
                List {
                    Section("Clip") {
                        Text(draft.title)
                            .font(.title3.weight(.bold))
                        Text(draft.summary)
                            .foregroundStyle(.secondary)
                        Label("Hook: \(draft.hook)", systemImage: "sparkles")
                        Label("CTA: \(draft.callToAction)", systemImage: "megaphone.fill")
                        Label("Cover: \(draft.coverStyle)", systemImage: "photo.fill")
                    }

                    Section("Release") {
                        Label(draft.channel.rawValue, systemImage: "play.rectangle.fill")
                        Label(draft.duration.rawValue, systemImage: "clock.fill")
                        Label(draft.owner, systemImage: "person.fill")
                        Label(draft.releaseWindow, systemImage: "calendar.badge.clock")
                        Label(draft.status.rawValue, systemImage: "flag.fill")
                            .foregroundStyle(draft.status.tint)
                    }

                    Section("Checklist") {
                        ForEach(draft.tasks) { task in
                            Button {
                                store.toggleTask(for: draft.id, taskID: task.id)
                            } label: {
                                HStack {
                                    Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(task.isComplete ? .green : .secondary)
                                    Text(task.title)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Section("Risk") {
                        Label(draft.commentRisk, systemImage: draft.needsLegalReview ? "exclamationmark.triangle.fill" : "checkmark.shield.fill")
                            .foregroundStyle(draft.needsLegalReview ? .orange : .green)
                    }

                    Section("Actions") {
                        Button("Send To Review") {
                            store.sendForReview(draft.id)
                        }

                        Button("Schedule Release") {
                            store.schedule(draft.id)
                        }
                        .disabled(draft.tasks.contains(where: { !$0.isComplete }))

                        Button("Publish Now") {
                            store.publish(draft.id)
                        }
                        .disabled(draft.status != .ready && draft.status != .scheduled)
                        .foregroundStyle(.pink)
                    }
                }
                .navigationTitle("Draft Detail")
            } else {
                ContentUnavailableView(
                    "Draft removed",
                    systemImage: "checkmark.seal",
                    description: Text("This clip is no longer in the draft board. It was likely published.")
                )
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoAnalyticsWorkspaceView: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        NavigationStack {
            List {
                Section("Studio Metrics") {
                    Label("\(store.totalViews) total views", systemImage: "play.circle.fill")
                    Label("\(store.totalShares) total shares", systemImage: "arrowshape.turn.up.right.fill")
                    Label("\(store.averageCompletionRate)% average completion", systemImage: "chart.line.uptrend.xyaxis")
                }

                Section("Published Clips") {
                    ForEach(store.publishedClips) { clip in
                        NavigationLink {
                            CreatorShortVideoPublishedClipDetailView(clip: clip)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(clip.title)
                                    .font(.headline)
                                Text(clip.summary)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text("\(clip.channel.rawValue) • \(clip.views) views • \(clip.completionRate)% completion")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Analytics")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoModerationWorkspaceView: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        NavigationStack {
            List {
                Section("Moderation Queue") {
                    ForEach(store.moderationCases) { moderationCase in
                        NavigationLink {
                            CreatorShortVideoModerationCaseDetailView(store: store, caseID: moderationCase.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(moderationCase.title)
                                        .font(.headline)
                                    Spacer()
                                    Text(moderationCase.severity.rawValue)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(moderationCase.severity.tint)
                                }
                                Text(moderationCase.summary)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text("\(moderationCase.owner) • \(moderationCase.status.rawValue)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Community Operations") {
                    ForEach(store.communityQueues) { queue in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(queue.title)
                                .font(.headline)
                            Text(queue.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            HStack {
                                Text(queue.owner)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(queue.status)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(queue.status == "Resolved" ? .green : .pink)
                            }
                            Button("Resolve Queue") {
                                store.resolveCommunityQueue(queue.id)
                            }
                            .buttonStyle(.bordered)
                            .tint(.pink)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Moderation")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoModerationCaseDetailView: View {
    @ObservedObject var store: CreatorShortVideoStudioStore
    let caseID: UUID

    private var moderationCase: CreatorShortVideoModerationCase? {
        store.moderationCases.first { $0.id == caseID }
    }

    var body: some View {
        Group {
            if let moderationCase {
                List {
                    Section("Case") {
                        Text(moderationCase.title)
                            .font(.title3.weight(.bold))
                        Text(moderationCase.summary)
                            .foregroundStyle(.secondary)
                    }

                    Section("Review") {
                        Label(moderationCase.severity.rawValue, systemImage: "exclamationmark.shield.fill")
                            .foregroundStyle(moderationCase.severity.tint)
                        Label(moderationCase.owner, systemImage: "person.fill")
                        Label(moderationCase.status.rawValue, systemImage: "flag.fill")
                    }

                    Section("Resolution") {
                        Text(moderationCase.resolution)
                            .foregroundStyle(.secondary)
                    }

                    Section("Actions") {
                        Button("Approve") {
                            store.approveModerationCase(moderationCase.id)
                        }

                        Button("Escalate") {
                            store.escalateModerationCase(moderationCase.id)
                        }
                        .foregroundStyle(.orange)
                    }
                }
                .navigationTitle("Moderation Case")
            } else {
                ContentUnavailableView("Case removed", systemImage: "checkmark.shield", description: Text("This moderation item has already been processed."))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoPublishedClipDetailView: View {
    let clip: CreatorShortVideoPublishedClip

    var body: some View {
        List {
            Section("Clip") {
                Text(clip.title)
                    .font(.title3.weight(.bold))
                Text(clip.summary)
                    .foregroundStyle(.secondary)
                Label(clip.channel.rawValue, systemImage: "play.rectangle.fill")
            }

            Section("Performance") {
                Label("\(clip.views) views", systemImage: "play.circle.fill")
                Label("\(clip.shares) shares", systemImage: "arrowshape.turn.up.right.fill")
                Label("\(clip.completionRate)% completion", systemImage: "chart.line.uptrend.xyaxis")
            }

            Section("Outcome") {
                Text(clip.outcome)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Published Clip")
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoProgramDetailView: View {
    let program: CreatorShortVideoProgram

    var body: some View {
        List {
            Section("Program") {
                Text(program.name)
                    .font(.title3.weight(.bold))
                Text(program.summary)
                    .foregroundStyle(.secondary)
            }

            Section("Coverage") {
                Label("\(program.creators) creators", systemImage: "person.3.fill")
                Label("\(program.weeklyClips) clips per week", systemImage: "video.fill")
                Label(program.deliveryHealth, systemImage: "bolt.fill")
                    .foregroundStyle(program.healthColor)
            }

            Section("Operating Rules") {
                ForEach(program.operatingRules, id: \.self) { rule in
                    Label(rule, systemImage: "checkmark.circle")
                }
            }
        }
        .navigationTitle("Program")
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct CreatorShortVideoStudioProfileView: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        NavigationStack {
            List {
                Section("Studio Lead") {
                    Label("Ariana West", systemImage: "person.crop.circle.fill")
                    Label("Launch, creator, and community operations", systemImage: "sparkles.tv.fill")
                }

                Section("Publishing Health") {
                    Label("\(store.readyDrafts.count) clips ready for release", systemImage: "paperplane.fill")
                    Label("\(store.highRiskCases) high-risk cases", systemImage: "exclamationmark.triangle.fill")
                    Label("\(store.averageCompletionRate)% completion baseline", systemImage: "chart.bar.fill")
                }

                Section("Trust Rules") {
                    Label("Every clip needs a hook, CTA, and caption review", systemImage: "checkmark.seal.fill")
                    Label("Brand safety review blocks risky monetization copy", systemImage: "hand.raised.fill")
                    Label("Escalated creator issues stay in moderation until resolved", systemImage: "shield.fill")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

public enum CreatorShortVideoChannel: String, CaseIterable, Hashable, Sendable {
    case launchStories = "Launch Stories"
    case productDemos = "Product Demos"
    case communityHighlights = "Community Highlights"
    case creatorEducation = "Creator Education"
}

public enum CreatorShortVideoDuration: String, CaseIterable, Hashable, Sendable {
    case fifteenSeconds = "0:15"
    case twentyFourSeconds = "0:24"
    case thirtySeconds = "0:30"
    case fortyFiveSeconds = "0:45"
}

enum CreatorShortVideoDraftStatus: String, CaseIterable, Hashable {
    case concept = "Concept"
    case editing = "Editing"
    case review = "Review"
    case ready = "Ready"
    case scheduled = "Scheduled"
    case published = "Published"

    var tint: Color {
        switch self {
        case .concept:
            return .secondary
        case .editing:
            return .blue
        case .review:
            return .orange
        case .ready:
            return .green
        case .scheduled:
            return .pink
        case .published:
            return .purple
        }
    }
}

enum CreatorShortVideoDraftFilter: String, CaseIterable, Hashable {
    case all = "All"
    case editing = "Editing"
    case review = "Review"
    case ready = "Ready"

    func includes(_ status: CreatorShortVideoDraftStatus) -> Bool {
        switch self {
        case .all:
            return true
        case .editing:
            return status == .concept || status == .editing
        case .review:
            return status == .review
        case .ready:
            return status == .ready || status == .scheduled
        }
    }
}

struct CreatorShortVideoComposerState: Hashable {
    var title: String
    var hook: String
    var summary: String
    var channel: CreatorShortVideoChannel
    var duration: CreatorShortVideoDuration
    var callToAction: String
    var owner: String
    var coverStyle: String
    var releaseWindow: String
    var requiresLegalReview: Bool

    static let sample = CreatorShortVideoComposerState(
        title: "Creator revenue reset teaser",
        hook: "Show the money leak in the first second",
        summary: "Fast teaser showing why creators are losing watch time on monetized clips.",
        channel: .launchStories,
        duration: .twentyFourSeconds,
        callToAction: "Comment 'audit' to get the checklist",
        owner: "Ariana",
        coverStyle: "Contrast title + face crop",
        releaseWindow: "Tonight 20:30",
        requiresLegalReview: true
    )
}

struct CreatorShortVideoTask: Identifiable, Hashable {
    let id: UUID
    let title: String
    var isComplete: Bool

    init(id: UUID = UUID(), title: String, isComplete: Bool) {
        self.id = id
        self.title = title
        self.isComplete = isComplete
    }
}

struct CreatorShortVideoDraftRecord: Identifiable, Hashable {
    let id: UUID
    var title: String
    var channel: CreatorShortVideoChannel
    var duration: CreatorShortVideoDuration
    var owner: String
    var status: CreatorShortVideoDraftStatus
    var summary: String
    var hook: String
    var callToAction: String
    var coverStyle: String
    var releaseWindow: String
    var tasks: [CreatorShortVideoTask]
    var needsLegalReview: Bool
    var commentRisk: String

    init(
        id: UUID = UUID(),
        title: String,
        channel: CreatorShortVideoChannel,
        duration: CreatorShortVideoDuration,
        owner: String,
        status: CreatorShortVideoDraftStatus,
        summary: String,
        hook: String,
        callToAction: String,
        coverStyle: String,
        releaseWindow: String,
        tasks: [CreatorShortVideoTask],
        needsLegalReview: Bool,
        commentRisk: String
    ) {
        self.id = id
        self.title = title
        self.channel = channel
        self.duration = duration
        self.owner = owner
        self.status = status
        self.summary = summary
        self.hook = hook
        self.callToAction = callToAction
        self.coverStyle = coverStyle
        self.releaseWindow = releaseWindow
        self.tasks = tasks
        self.needsLegalReview = needsLegalReview
        self.commentRisk = commentRisk
    }

    static let sampleDrafts: [CreatorShortVideoDraftRecord] = [
        CreatorShortVideoDraftRecord(
            title: "Launch cutdown with hook overlay",
            channel: .launchStories,
            duration: .twentyFourSeconds,
            owner: "Ariana",
            status: .ready,
            summary: "First-look teaser for tomorrow's product reveal with end-card CTA.",
            hook: "Show the painful before state first",
            callToAction: "Save this for tomorrow's drop",
            coverStyle: "Split-screen before/after",
            releaseWindow: "Tonight 19:40",
            tasks: [
                .init(title: "Hook cut approved", isComplete: true),
                .init(title: "Caption timing approved", isComplete: true),
                .init(title: "CTA end card added", isComplete: true)
            ],
            needsLegalReview: false,
            commentRisk: "Low comment risk. Organic conversation expected."
        ),
        CreatorShortVideoDraftRecord(
            title: "Workspace demo remix",
            channel: .productDemos,
            duration: .thirtySeconds,
            owner: "Noah",
            status: .review,
            summary: "Screen-recorded tutorial showing how faster capture changes creator output.",
            hook: "Cut directly to the workflow speed-up",
            callToAction: "Share this with your ops lead",
            coverStyle: "UI close-up with bold stat",
            releaseWindow: "Tonight 20:15",
            tasks: [
                .init(title: "Remove dead intro seconds", isComplete: true),
                .init(title: "Subtitle timing review", isComplete: true),
                .init(title: "Brand safety pass", isComplete: false)
            ],
            needsLegalReview: true,
            commentRisk: "Paid creator claims need legal review."
        ),
        CreatorShortVideoDraftRecord(
            title: "Community spotlight stitch",
            channel: .communityHighlights,
            duration: .fifteenSeconds,
            owner: "Lina",
            status: .editing,
            summary: "Fast reaction clip that stitches top user-generated submissions into one CTA loop.",
            hook: "Lead with the highest energy reaction frame",
            callToAction: "Comment your version for tomorrow's feature",
            coverStyle: "Creator face + reaction meter",
            releaseWindow: "Tomorrow 18:30",
            tasks: [
                .init(title: "Collect permission confirmations", isComplete: true),
                .init(title: "Choose cover frame", isComplete: false),
                .init(title: "Export creator tags", isComplete: false)
            ],
            needsLegalReview: false,
            commentRisk: "Medium community volume expected."
        )
    ]
}

enum CreatorShortVideoCaseSeverity: String, Hashable {
    case medium = "Medium"
    case high = "High"

    var tint: Color {
        switch self {
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
}

enum CreatorShortVideoCaseStatus: String, Hashable {
    case pending = "Pending"
    case approved = "Approved"
    case escalated = "Escalated"
}

struct CreatorShortVideoModerationCase: Identifiable, Hashable {
    let id: UUID
    let title: String
    let summary: String
    let owner: String
    let severity: CreatorShortVideoCaseSeverity
    var status: CreatorShortVideoCaseStatus
    var resolution: String

    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        owner: String,
        severity: CreatorShortVideoCaseSeverity,
        status: CreatorShortVideoCaseStatus,
        resolution: String
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.owner = owner
        self.severity = severity
        self.status = status
        self.resolution = resolution
    }

    static let sampleCases: [CreatorShortVideoModerationCase] = [
        CreatorShortVideoModerationCase(
            title: "Sponsorship claim review",
            summary: "Sponsored clip includes a performance claim that needs legal confirmation.",
            owner: "Legal",
            severity: .high,
            status: .pending,
            resolution: "Awaiting legal wording confirmation."
        ),
        CreatorShortVideoModerationCase(
            title: "Caption accessibility pass",
            summary: "Subtitle contrast and timing on one product demo needs QA review.",
            owner: "QA",
            severity: .medium,
            status: .pending,
            resolution: "Awaiting corrected caption export."
        )
    ]
}

struct CreatorShortVideoCommunityQueue: Identifiable, Hashable {
    let id: UUID
    let title: String
    var summary: String
    let owner: String
    var status: String

    init(id: UUID = UUID(), title: String, summary: String, owner: String, status: String) {
        self.id = id
        self.title = title
        self.summary = summary
        self.owner = owner
        self.status = status
    }

    static let sampleQueues: [CreatorShortVideoCommunityQueue] = [
        .init(
            title: "UGC permission queue",
            summary: "Five creator submissions need final permission tags before highlight publishing.",
            owner: "Community Ops",
            status: "Needs action"
        ),
        .init(
            title: "Monetization comment sweep",
            summary: "Sensitive monetization comments need response templates before tomorrow's launch.",
            owner: "Support",
            status: "In progress"
        )
    ]
}

struct CreatorShortVideoPublishedClip: Identifiable, Hashable {
    let id: UUID
    let title: String
    let channel: CreatorShortVideoChannel
    let views: Int
    let completionRate: Int
    let shares: Int
    let summary: String
    let outcome: String

    init(
        id: UUID = UUID(),
        title: String,
        channel: CreatorShortVideoChannel,
        views: Int,
        completionRate: Int,
        shares: Int,
        summary: String,
        outcome: String
    ) {
        self.id = id
        self.title = title
        self.channel = channel
        self.views = views
        self.completionRate = completionRate
        self.shares = shares
        self.summary = summary
        self.outcome = outcome
    }

    static let samplePublished: [CreatorShortVideoPublishedClip] = [
        .init(
            title: "Feature reveal teaser",
            channel: .launchStories,
            views: 92_400,
            completionRate: 68,
            shares: 4_200,
            summary: "Launch teaser that used a before/after hook with a save CTA.",
            outcome: "Strong first-three-second retention and above-baseline saves."
        ),
        .init(
            title: "Creator ops workflow",
            channel: .creatorEducation,
            views: 54_600,
            completionRate: 62,
            shares: 2_400,
            summary: "Educational short that explains how creator teams batch production.",
            outcome: "Higher than expected shares from creator operators."
        )
    ]
}

struct CreatorShortVideoProgram: Identifiable, Hashable {
    let id: UUID
    let name: String
    let summary: String
    let creators: Int
    let weeklyClips: Int
    let deliveryHealth: String
    let healthColor: Color
    let operatingRules: [String]

    init(
        id: UUID = UUID(),
        name: String,
        summary: String,
        creators: Int,
        weeklyClips: Int,
        deliveryHealth: String,
        healthColor: Color,
        operatingRules: [String]
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.creators = creators
        self.weeklyClips = weeklyClips
        self.deliveryHealth = deliveryHealth
        self.healthColor = healthColor
        self.operatingRules = operatingRules
    }

    static let samplePrograms: [CreatorShortVideoProgram] = [
        .init(
            name: "Launch Stories",
            summary: "High-intent teasers designed to drive save rate and reveal anticipation.",
            creators: 6,
            weeklyClips: 18,
            deliveryHealth: "On track",
            healthColor: .green,
            operatingRules: [
                "Hook must land in the first second",
                "Each clip needs one clear CTA",
                "No product claims without legal clearance"
            ]
        ),
        .init(
            name: "Product Demos",
            summary: "Screen-recorded explainers focused on workflow, value, and repeat views.",
            creators: 4,
            weeklyClips: 11,
            deliveryHealth: "Needs faster reviews",
            healthColor: .orange,
            operatingRules: [
                "Remove dead intro time",
                "Use captions on every scene",
                "Show the value moment before narration"
            ]
        )
    ]
}
