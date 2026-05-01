import Foundation
import SwiftUI
import CreatorShortVideoAppCore

private enum CreatorShortVideoInteractionProofMode {
    static let isEnabled = ProcessInfo.processInfo.environment["IOSAPPTEMPLATES_INTERACTION_PROOF_MODE"] == "1"

    static func write(summary: String, steps: [String]) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let payload: [String: Any] = [
            "app": "CreatorShortVideoApp",
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

public struct CreatorShortVideoAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            CreatorShortVideoRuntimeRootView()
        }
    }
}

struct CreatorShortVideoRuntimeRootView: View {
    @StateObject private var store = CreatorShortVideoStudioStore()

    var body: some View {
        TabView {
            CreatorShortVideoStudioHomeView(store: store)
                .tabItem {
                    Image(systemName: "camera.aperture")
                    Text("Studio")
                }

            CreatorShortVideoPipelineWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "film.stack.fill")
                    Text("Pipeline")
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
        .onAppear {
            store.runInteractionProofIfNeeded()
        }
    }
}

@MainActor
final class CreatorShortVideoStudioStore: ObservableObject {
    @Published var drafts: [ShortVideoDraftRecord] = ShortVideoDraftRecord.sampleDrafts
    @Published var publishedClips: [ShortVideoPublishedClipRecord] = ShortVideoPublishedClipRecord.samplePublished
    @Published var moderationCases: [ShortVideoModerationCaseRecord] = ShortVideoModerationCaseRecord.sampleCases
    @Published var creatorPrograms: [ShortVideoProgramRecord] = ShortVideoProgramRecord.samplePrograms
    @Published var experiments: [ShortVideoGrowthExperiment] = ShortVideoGrowthExperiment.sampleExperiments
    @Published var composer = ShortVideoComposerState.sample
    @Published var selectedDraftFilter: ShortVideoDraftFilter = .all
    private var interactionProofScheduled = false

    var filteredDrafts: [ShortVideoDraftRecord] {
        drafts.filter { selectedDraftFilter.includes($0.status) }
    }

    var readyDrafts: [ShortVideoDraftRecord] {
        drafts.filter { $0.status == .readyToSchedule || $0.status == .scheduled }
    }

    var highRiskCases: Int {
        moderationCases.filter { $0.severity == .high && $0.status != .resolved }.count
    }

    var activeExperimentCount: Int {
        experiments.filter { !$0.isClosed }.count
    }

    var releaseHeadline: String {
        if highRiskCases > 0 {
            return "\(highRiskCases) high-risk moderation cases can block the next release."
        }
        if readyDrafts.isEmpty {
            return "Publishing pipeline is thin. Studio needs one more ready asset."
        }
        return "Release queue is healthy and ready for the next creator drop."
    }

    func queueComposerDraft() {
        let title = composer.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let hook = composer.hook.trimmingCharacters(in: .whitespacesAndNewlines)
        let cta = composer.callToAction.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty, !hook.isEmpty, !cta.isEmpty else { return }

        drafts.insert(
            ShortVideoDraftRecord(
                title: title,
                channel: composer.channel,
                owner: composer.owner,
                summary: composer.summary,
                hook: hook,
                callToAction: cta,
                releaseWindow: composer.releaseWindow,
                sponsorName: composer.sponsorName,
                status: .editing,
                coverStyle: composer.coverStyle,
                tasks: [
                    .init(title: "Capture opening hook", isComplete: true),
                    .init(title: "Trim first two seconds", isComplete: false),
                    .init(title: "Add captions + CTA end card", isComplete: false),
                    .init(title: "Review sponsor safety claims", isComplete: composer.sponsorName.isEmpty)
                ],
                brandReviewState: composer.sponsorName.isEmpty ? .notNeeded : .pending,
                legalReviewState: composer.requiresLegalReview ? .pending : .approved,
                moderationSummary: composer.requiresLegalReview ? "Needs policy check before scheduling." : "Low moderation risk."
            ),
            at: 0
        )

        composer = .sample
        selectedDraftFilter = .all
    }

    func toggleTask(for draftID: UUID, taskID: UUID) {
        guard let draftIndex = drafts.firstIndex(where: { $0.id == draftID }),
              let taskIndex = drafts[draftIndex].tasks.firstIndex(where: { $0.id == taskID }) else {
            return
        }

        drafts[draftIndex].tasks[taskIndex].isComplete.toggle()

        if drafts[draftIndex].tasks.allSatisfy(\.isComplete),
           drafts[draftIndex].brandReviewState != .pending,
           drafts[draftIndex].legalReviewState != .pending {
            drafts[draftIndex].status = .readyToSchedule
        } else if drafts[draftIndex].status == .readyToSchedule || drafts[draftIndex].status == .scheduled {
            drafts[draftIndex].status = .editing
        }
    }

    func approveBrandReview(_ draftID: UUID) {
        guard let draftIndex = drafts.firstIndex(where: { $0.id == draftID }) else { return }
        drafts[draftIndex].brandReviewState = .approved
        refreshDraftState(draftIndex)
    }

    func approveLegalReview(_ draftID: UUID) {
        guard let draftIndex = drafts.firstIndex(where: { $0.id == draftID }) else { return }
        drafts[draftIndex].legalReviewState = .approved
        refreshDraftState(draftIndex)
    }

    func sendForReview(_ draftID: UUID) {
        guard let draftIndex = drafts.firstIndex(where: { $0.id == draftID }) else { return }
        drafts[draftIndex].status = .inReview
    }

    func schedule(_ draftID: UUID) {
        guard let draftIndex = drafts.firstIndex(where: { $0.id == draftID }) else { return }
        drafts[draftIndex].status = .scheduled
    }

    func publish(_ draftID: UUID) {
        guard let draftIndex = drafts.firstIndex(where: { $0.id == draftID }) else { return }
        let draft = drafts.remove(at: draftIndex)

        publishedClips.insert(
            ShortVideoPublishedClipRecord(
                title: draft.title,
                channel: draft.channel,
                releaseWindow: draft.releaseWindow,
                views: 24_000 + publishedClips.count * 3_600,
                shares: 1_300 + publishedClips.count * 140,
                saves: 980 + publishedClips.count * 90,
                completionRate: draft.sponsorName.isEmpty ? 67 : 61,
                outcome: "Published after studio, sponsor, and moderation sign-off."
            ),
            at: 0
        )
    }

    func launchRecoveryExperiment(for clipID: UUID) {
        guard let clipIndex = publishedClips.firstIndex(where: { $0.id == clipID }),
              !publishedClips[clipIndex].hasRecoveryExperiment else {
            return
        }

        publishedClips[clipIndex].hasRecoveryExperiment = true
        experiments.insert(
            ShortVideoGrowthExperiment(
                title: "Recover \(publishedClips[clipIndex].title)",
                hypothesis: "Swap the first-frame visual and tighten CTA timing to improve completion and saves.",
                owner: "Growth Ops",
                isClosed: false
            ),
            at: 0
        )
    }

    func closeExperiment(_ experimentID: UUID) {
        guard let index = experiments.firstIndex(where: { $0.id == experimentID }) else { return }
        experiments[index].isClosed = true
        experiments[index].hypothesis = "Experiment closed with winning hook and CTA timing recorded."
    }

    func approveModerationCase(_ caseID: UUID) {
        updateModerationCase(caseID) { moderationCase in
            moderationCase.status = .approved
            moderationCase.resolution = "Approved after transcript review and creator coaching note."
        }
    }

    func escalateModerationCase(_ caseID: UUID) {
        updateModerationCase(caseID) { moderationCase in
            moderationCase.status = .escalated
            moderationCase.resolution = "Escalated to legal and trust review before distribution."
        }
    }

    func resolveModerationCase(_ caseID: UUID) {
        updateModerationCase(caseID) { moderationCase in
            moderationCase.status = .resolved
            moderationCase.resolution = "Resolved with comment cleanup, creator reply, and policy note."
        }
    }

    private func refreshDraftState(_ index: Int) {
        let draft = drafts[index]
        let reviewsComplete = draft.brandReviewState != .pending && draft.legalReviewState != .pending
        if reviewsComplete && draft.tasks.allSatisfy(\.isComplete) {
            drafts[index].status = .readyToSchedule
        }
    }

    private func updateModerationCase(_ caseID: UUID, mutation: (inout ShortVideoModerationCaseRecord) -> Void) {
        guard let index = moderationCases.firstIndex(where: { $0.id == caseID }) else { return }
        mutation(&moderationCases[index])
    }

    func runInteractionProofIfNeeded() {
        guard CreatorShortVideoInteractionProofMode.isEnabled, !interactionProofScheduled else { return }
        interactionProofScheduled = true

        DispatchQueue.main.async {
            var steps: [String] = []

            self.queueComposerDraft()
            steps.append("Queued composer draft")

            if let draftID = self.drafts.first?.id {
                if let draft = self.drafts.first(where: { $0.id == draftID }) {
                    for task in draft.tasks where !task.isComplete {
                        self.toggleTask(for: draftID, taskID: task.id)
                    }
                }
                self.approveBrandReview(draftID)
                self.approveLegalReview(draftID)
                self.sendForReview(draftID)
                self.schedule(draftID)
                self.publish(draftID)
                steps.append("Completed draft review and published clip")
            }

            if let clipID = self.publishedClips.first?.id {
                self.launchRecoveryExperiment(for: clipID)
                steps.append("Launched recovery experiment")
            }

            if let experimentID = self.experiments.first(where: { !$0.isClosed })?.id {
                self.closeExperiment(experimentID)
                steps.append("Closed experiment")
            }

            if let moderationCaseID = self.moderationCases.first?.id {
                self.approveModerationCase(moderationCaseID)
                self.escalateModerationCase(moderationCaseID)
                self.resolveModerationCase(moderationCaseID)
                steps.append("Processed moderation chain")
            }

            CreatorShortVideoInteractionProofMode.write(
                summary: "Creator interaction proof completed with draft, publish, experiment, and moderation chain.",
                steps: steps
            )
        }
    }
}

struct CreatorShortVideoStudioHomeView: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CreatorShortVideoRuntimeHeroCard(store: store)
                    CreatorShortVideoComposerCard(store: store)
                    CreatorShortVideoReleaseQueueSection(store: store)
                    CreatorShortVideoProgramSection(programs: store.creatorPrograms)
                }
                .padding(16)
            }
            .navigationTitle("Creator Studio")
        }
    }
}

struct CreatorShortVideoRuntimeHeroCard: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Release Control")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(store.releaseHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))

            Text("\(store.readyDrafts.count) drafts are ready or scheduled. \(store.activeExperimentCount) growth experiments still running.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                CreatorSummaryChip(title: "Drafts", value: "\(store.drafts.count)")
                CreatorSummaryChip(title: "Published", value: "\(store.publishedClips.count)")
                CreatorSummaryChip(title: "Flags", value: "\(store.highRiskCases)")
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

struct CreatorSummaryChip: View {
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
                TextField("CTA", text: $store.composer.callToAction)
                    .textFieldStyle(.roundedBorder)
                TextField("Owner", text: $store.composer.owner)
                    .textFieldStyle(.roundedBorder)
            }

            HStack {
                TextField("Release window", text: $store.composer.releaseWindow)
                    .textFieldStyle(.roundedBorder)
                TextField("Sponsor", text: $store.composer.sponsorName)
                    .textFieldStyle(.roundedBorder)
            }

            TextField("Cover style", text: $store.composer.coverStyle)
                .textFieldStyle(.roundedBorder)

            Toggle("Needs legal review", isOn: $store.composer.requiresLegalReview)

            Button("Queue Draft") {
                store.queueComposerDraft()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct CreatorShortVideoReleaseQueueSection: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ready Queue")
                .font(.title3.weight(.bold))

            ForEach(store.readyDrafts) { draft in
                VStack(alignment: .leading, spacing: 8) {
                    Text(draft.title)
                        .font(.headline)
                    Text("\(draft.channel) • \(draft.releaseWindow)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack {
                        Text(draft.status.label)
                            .font(.caption.weight(.semibold))
                        Spacer()
                        Button(draft.status == .scheduled ? "Publish" : "Schedule") {
                            draft.status == .scheduled ? store.publish(draft.id) : store.schedule(draft.id)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

struct CreatorShortVideoProgramSection: View {
    let programs: [ShortVideoProgramRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Creator Programs")
                .font(.title3.weight(.bold))

            ForEach(programs) { program in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(program.title)
                            .font(.headline)
                        Spacer()
                        Text(program.status)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    Text(program.summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

struct CreatorShortVideoPipelineWorkspaceView: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        NavigationStack {
            List {
                Section("Filter") {
                    Picker("Status", selection: $store.selectedDraftFilter) {
                        ForEach(ShortVideoDraftFilter.allCases) { filter in
                            Text(filter.title).tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Drafts") {
                    ForEach(store.filteredDrafts) { draft in
                        NavigationLink {
                            CreatorShortVideoDraftDetailView(store: store, draftID: draft.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(draft.title)
                                    Spacer()
                                    Text(draft.status.label)
                                        .font(.caption.weight(.semibold))
                                }
                                Text("\(draft.channel) • \(draft.releaseWindow)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Pipeline")
        }
    }
}

struct CreatorShortVideoDraftDetailView: View {
    @ObservedObject var store: CreatorShortVideoStudioStore
    let draftID: UUID

    var body: some View {
        if let draft = store.drafts.first(where: { $0.id == draftID }) {
            List {
                Section("Draft") {
                    Text(draft.summary)
                    Label("Brand review: \(draft.brandReviewState.label)", systemImage: "megaphone.fill")
                    Label("Legal review: \(draft.legalReviewState.label)", systemImage: "doc.text.magnifyingglass")
                    Label(draft.moderationSummary, systemImage: "shield.lefthalf.filled")
                }

                Section("Checklist") {
                    ForEach(draft.tasks) { task in
                        Button {
                            store.toggleTask(for: draft.id, taskID: task.id)
                        } label: {
                            HStack {
                                Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                                Text(task.title)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                Section("Actions") {
                    if draft.brandReviewState == .pending {
                        Button("Approve Brand Review") {
                            store.approveBrandReview(draft.id)
                        }
                    }
                    if draft.legalReviewState == .pending {
                        Button("Approve Legal Review") {
                            store.approveLegalReview(draft.id)
                        }
                    }
                    if draft.status == .editing {
                        Button("Send for Review") {
                            store.sendForReview(draft.id)
                        }
                    }
                    if draft.status == .readyToSchedule {
                        Button("Schedule Release") {
                            store.schedule(draft.id)
                        }
                    }
                    if draft.status == .scheduled {
                        Button("Publish Now") {
                            store.publish(draft.id)
                        }
                    }
                }
            }
            .navigationTitle(draft.title)
        }
    }
}

struct CreatorShortVideoAnalyticsWorkspaceView: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        NavigationStack {
            List {
                Section("Published Clips") {
                    ForEach(store.publishedClips) { clip in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(clip.title)
                                    .font(.headline)
                                Spacer()
                                Text("\(clip.completionRate)% completion")
                                    .font(.caption.weight(.semibold))
                            }
                            Text("\(clip.views) views • \(clip.saves) saves • \(clip.shares) shares")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(clip.outcome)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            if !clip.hasRecoveryExperiment {
                                Button("Launch Recovery Experiment") {
                                    store.launchRecoveryExperiment(for: clip.id)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Growth Experiments") {
                    ForEach(store.experiments) { experiment in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(experiment.title)
                                    .font(.headline)
                                Spacer()
                                Text(experiment.isClosed ? "Closed" : "Running")
                                    .font(.caption.weight(.semibold))
                            }
                            Text(experiment.hypothesis)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            if !experiment.isClosed {
                                Button("Close Experiment") {
                                    store.closeExperiment(experiment.id)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Analytics")
        }
    }
}

struct CreatorShortVideoModerationWorkspaceView: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        NavigationStack {
            List {
                Section("Moderation Queue") {
                    ForEach(store.moderationCases) { moderationCase in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(moderationCase.title)
                                    .font(.headline)
                                Spacer()
                                Text(moderationCase.status.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(moderationCase.status.tint)
                            }
                            Text(moderationCase.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(moderationCase.resolution)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            HStack {
                                Button("Approve") {
                                    store.approveModerationCase(moderationCase.id)
                                }
                                .buttonStyle(.borderedProminent)
                                Button("Escalate") {
                                    store.escalateModerationCase(moderationCase.id)
                                }
                                .buttonStyle(.bordered)
                                Button("Resolve") {
                                    store.resolveModerationCase(moderationCase.id)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Moderation")
        }
    }
}

struct CreatorShortVideoStudioProfileView: View {
    @ObservedObject var store: CreatorShortVideoStudioStore

    var body: some View {
        NavigationStack {
            List {
                Section("Operations") {
                    Label("\(store.drafts.count) total drafts", systemImage: "film.stack.fill")
                    Label("\(store.publishedClips.count) published clips", systemImage: "chart.bar.fill")
                    Label("\(store.activeExperimentCount) active experiments", systemImage: "wand.and.stars")
                }

                Section("Release Standard") {
                    Text("Every clip needs task completion, required review approvals, moderation pass, and a clear release window.")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

enum ShortVideoDraftStatus: CaseIterable {
    case editing
    case inReview
    case readyToSchedule
    case scheduled

    var label: String {
        switch self {
        case .editing: return "Editing"
        case .inReview: return "In Review"
        case .readyToSchedule: return "Ready"
        case .scheduled: return "Scheduled"
        }
    }
}

enum ShortVideoReviewState {
    case pending
    case approved
    case notNeeded

    var label: String {
        switch self {
        case .pending: return "Pending"
        case .approved: return "Approved"
        case .notNeeded: return "Not needed"
        }
    }
}

enum ShortVideoDraftFilter: String, CaseIterable, Identifiable {
    case all
    case editing
    case review
    case ready

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return "All"
        case .editing: return "Editing"
        case .review: return "Review"
        case .ready: return "Ready"
        }
    }

    func includes(_ status: ShortVideoDraftStatus) -> Bool {
        switch self {
        case .all: return true
        case .editing: return status == .editing
        case .review: return status == .inReview
        case .ready: return status == .readyToSchedule || status == .scheduled
        }
    }
}

struct ShortVideoComposerState {
    var title: String
    var summary: String
    var hook: String
    var callToAction: String
    var owner: String
    var releaseWindow: String
    var sponsorName: String
    var coverStyle: String
    var requiresLegalReview: Bool
    var channel: String

    static let sample = ShortVideoComposerState(
        title: "Creator workflow reset",
        summary: "Break down the new filming workflow and show how operators keep the release queue healthy.",
        hook: "Creators lose retention when the hook misses in the first second.",
        callToAction: "Comment your current bottleneck.",
        owner: "Mia",
        releaseWindow: "Tonight • 21:15",
        sponsorName: "",
        coverStyle: "Bold white subtitle over studio close-up",
        requiresLegalReview: false,
        channel: "TikTok"
    )
}

struct ShortVideoDraftRecord: Identifiable {
    let id = UUID()
    let title: String
    let channel: String
    let owner: String
    let summary: String
    let hook: String
    let callToAction: String
    let releaseWindow: String
    let sponsorName: String
    var status: ShortVideoDraftStatus
    let coverStyle: String
    var tasks: [ShortVideoTask]
    var brandReviewState: ShortVideoReviewState
    var legalReviewState: ShortVideoReviewState
    var moderationSummary: String

    static let sampleDrafts: [ShortVideoDraftRecord] = [
        ShortVideoDraftRecord(
            title: "72-hour creator sprint",
            channel: "TikTok",
            owner: "Mia",
            summary: "Show how creators can ship a three-day sprint without burning out their editing loop.",
            hook: "If your draft sits longer than 72 hours, it probably dies.",
            callToAction: "Save this and build your own sprint.",
            releaseWindow: "Tonight • 21:15",
            sponsorName: "",
            status: .readyToSchedule,
            coverStyle: "Contrast subtitle over studio close-up",
            tasks: [
                ShortVideoTask(title: "Capture opening hook", isComplete: true),
                ShortVideoTask(title: "Trim first two seconds", isComplete: true),
                ShortVideoTask(title: "Add captions + CTA end card", isComplete: true)
            ],
            brandReviewState: .notNeeded,
            legalReviewState: .approved,
            moderationSummary: "Low moderation risk."
        ),
        ShortVideoDraftRecord(
            title: "Sponsor-safe desk setup",
            channel: "Reels",
            owner: "Ava",
            summary: "Break down a sponsor-safe desk setup with compliance callouts.",
            hook: "Most sponsored creator clips fail in the legal pass, not the edit.",
            callToAction: "Drop your current sponsor QA checklist.",
            releaseWindow: "Tomorrow • 18:00",
            sponsorName: "Orbit Desk",
            status: .inReview,
            coverStyle: "Product close-up with pink compliance label",
            tasks: [
                ShortVideoTask(title: "Capture B-roll", isComplete: true),
                ShortVideoTask(title: "Approve product claims", isComplete: false),
                ShortVideoTask(title: "Insert sponsor CTA", isComplete: true)
            ],
            brandReviewState: .pending,
            legalReviewState: .pending,
            moderationSummary: "Needs sponsor and legal pass."
        )
    ]
}

struct ShortVideoTask: Identifiable {
    let id = UUID()
    let title: String
    var isComplete: Bool
}

struct ShortVideoPublishedClipRecord: Identifiable {
    let id = UUID()
    let title: String
    let channel: String
    let releaseWindow: String
    let views: Int
    let shares: Int
    let saves: Int
    let completionRate: Int
    let outcome: String
    var hasRecoveryExperiment: Bool = false

    static let samplePublished: [ShortVideoPublishedClipRecord] = [
        ShortVideoPublishedClipRecord(title: "Launch-day creator checklist", channel: "TikTok", releaseWindow: "Yesterday • 20:00", views: 41_800, shares: 2_240, saves: 1_740, completionRate: 69, outcome: "Strong save rate after subtitle timing cleanup."),
        ShortVideoPublishedClipRecord(title: "Studio sound fix in 20 seconds", channel: "Shorts", releaseWindow: "Apr 27 • 19:00", views: 19_300, shares: 840, saves: 520, completionRate: 54, outcome: "Underperformed on completion. First-frame experiment recommended.")
    ]
}

enum ShortVideoModerationStatus {
    case open
    case approved
    case escalated
    case resolved

    var label: String {
        switch self {
        case .open: return "Open"
        case .approved: return "Approved"
        case .escalated: return "Escalated"
        case .resolved: return "Resolved"
        }
    }

    var tint: Color {
        switch self {
        case .open: return .orange
        case .approved: return .green
        case .escalated: return .red
        case .resolved: return .secondary
        }
    }
}

struct ShortVideoModerationCaseRecord: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let severity: ShortVideoSeverity
    var status: ShortVideoModerationStatus
    var resolution: String

    static let sampleCases: [ShortVideoModerationCaseRecord] = [
        ShortVideoModerationCaseRecord(title: "Medical claim in fitness sponsor cut", summary: "Caption implies a guaranteed health outcome without evidence.", severity: .high, status: .open, resolution: "Waiting for sponsor-safe rewrite."),
        ShortVideoModerationCaseRecord(title: "Creator comment pile-on", summary: "Audience thread escalated after a controversial reply clip.", severity: .medium, status: .open, resolution: "Creator coaching note prepared for next publish window.")
    ]
}

enum ShortVideoSeverity {
    case high
    case medium
    case low
}

struct ShortVideoProgramRecord: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let status: String

    static let samplePrograms: [ShortVideoProgramRecord] = [
        ShortVideoProgramRecord(title: "Q2 Creator Sprint", summary: "Three weekly drops focused on repeatable creator workflows and studio systems.", status: "On track"),
        ShortVideoProgramRecord(title: "Sponsor Safety Series", summary: "Short-form series teaching sponsor-safe production and legal review discipline.", status: "Needs one approved draft")
    ]
}

struct ShortVideoGrowthExperiment: Identifiable {
    let id = UUID()
    let title: String
    var hypothesis: String
    let owner: String
    var isClosed: Bool

    static let sampleExperiments: [ShortVideoGrowthExperiment] = [
        ShortVideoGrowthExperiment(title: "Subtitle tempo test", hypothesis: "Reduce subtitle density in the first 1.5 seconds to improve completion.", owner: "Growth Ops", isClosed: false)
    ]
}
