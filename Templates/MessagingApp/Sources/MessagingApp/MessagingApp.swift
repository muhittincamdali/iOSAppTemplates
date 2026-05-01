import Foundation
import SwiftUI
import MessagingAppCore

private enum MessagingInteractionProofMode {
    static let isEnabled = ProcessInfo.processInfo.environment["IOSAPPTEMPLATES_INTERACTION_PROOF_MODE"] == "1"

    static func write(summary: String, steps: [String]) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let payload: [String: Any] = [
            "app": "MessagingApp",
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

@main
struct MessagingApp: App {
    var body: some Scene {
        WindowGroup {
            MessagingRuntimeRootView()
        }
    }
}

struct MessagingRuntimeRootView: View {
    @StateObject private var store = MessagingCommandCenterStore()

    var body: some View {
        TabView {
            MessagingInboxWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "tray.full.fill")
                    Text("Inbox")
                }

            MessagingRoomsWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Rooms")
                }

            MessagingSafetyWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "shield.lefthalf.filled")
                    Text("Safety")
                }

            MessagingProfileWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.indigo)
        .onAppear {
            store.runInteractionProofIfNeeded()
        }
    }
}

@MainActor
final class MessagingCommandCenterStore: ObservableObject {
    @Published var threads: [MessagingThreadRecord] = MessagingThreadRecord.sampleThreads
    @Published var rooms: [MessagingRoomRecord] = MessagingRoomRecord.sampleRooms
    @Published var safetyCases: [MessagingSafetyCaseRecord] = MessagingSafetyCaseRecord.sampleCases
    @Published var selectedFilter: MessagingInboxFilter = .priority
    @Published var operatorNote = "Chargeback, creator abuse, and payout phishing stay under ten-minute escalation SLA."
    private var interactionProofScheduled = false

    let operatorName = "Ivy Bennett"
    let coverageShift = "EU + US overlap shift"

    var filteredThreads: [MessagingThreadRecord] {
        threads.filter { selectedFilter.includes($0) }
    }

    var priorityThread: MessagingThreadRecord? {
        threads.first(where: \.isPinned) ?? threads.sorted { $0.unreadCount > $1.unreadCount }.first
    }

    var unreadCount: Int {
        threads.reduce(0) { $0 + $1.unreadCount }
    }

    var escalatedCaseCount: Int {
        safetyCases.filter { $0.status == .escalated }.count
    }

    var resolvedCaseCount: Int {
        safetyCases.filter { $0.status == .resolved }.count
    }

    var activeRoomRequests: Int {
        rooms.reduce(0) { $0 + $1.pendingRequests }
    }

    var containedThreadCount: Int {
        threads.filter { $0.containmentStatus != "Open lane" }.count
    }

    var legalHoldCount: Int {
        safetyCases.filter(\.legalHoldActive).count
    }

    var controlCenterHeadline: String {
        if escalatedCaseCount > 0 {
            return "\(escalatedCaseCount) trust escalations need active coverage."
        }
        if unreadCount > 10 {
            return "Inbox pressure is rising. Clear support and creator queues now."
        }
        return "Inbox is stable and room moderation is under control."
    }

    func thread(id: UUID) -> MessagingThreadRecord? {
        threads.first(where: { $0.id == id })
    }

    func updateDraft(_ threadID: UUID, text: String) {
        guard let index = threads.firstIndex(where: { $0.id == threadID }) else { return }
        threads[index].draftReply = text
    }

    func togglePin(_ threadID: UUID) {
        guard let index = threads.firstIndex(where: { $0.id == threadID }) else { return }
        threads[index].isPinned.toggle()
    }

    func assignThreadOwner(_ threadID: UUID, owner: String) {
        guard let index = threads.firstIndex(where: { $0.id == threadID }) else { return }
        threads[index].owner = owner
        threads[index].lastActive = "Owner updated"
    }

    func sendReply(to threadID: UUID) {
        guard let index = threads.firstIndex(where: { $0.id == threadID }) else { return }
        let draft = threads[index].draftReply.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !draft.isEmpty else { return }

        threads[index].messages.append(
            MessagingThreadMessage(author: operatorName, timestamp: "Now", body: draft)
        )
        threads[index].latestMessage = draft
        threads[index].lastSender = operatorName
        threads[index].lastActive = "Now"
        threads[index].unreadCount = 0
        threads[index].status = .awaitingCustomer
        threads[index].containmentStatus = "Customer follow-up sent"
        threads[index].draftReply = ""
    }

    func resolveThread(_ threadID: UUID) {
        guard let index = threads.firstIndex(where: { $0.id == threadID }) else { return }
        threads[index].status = .resolved
        threads[index].unreadCount = 0
        threads[index].lastActive = "Resolved"
        threads[index].latestMessage = "Resolution sent with final policy and next-step summary."
        threads[index].containmentStatus = "Resolution delivered"
        threads[index].recoveryPlan = "Monitor for follow-up and keep trust artifacts attached for 24 hours."
        threads[index].messages.append(
            MessagingThreadMessage(author: operatorName, timestamp: "Now", body: "Resolution sent with final policy and next-step summary.")
        )
    }

    func freezeThread(_ threadID: UUID) {
        guard let index = threads.firstIndex(where: { $0.id == threadID }) else { return }
        threads[index].status = .escalated
        threads[index].isPinned = true
        threads[index].unreadCount = 0
        threads[index].lastActive = "Containment active"
        threads[index].containmentStatus = "Thread frozen"
        threads[index].recoveryPlan = "Wait for trust lead sign-off before reopening customer contact."
    }

    func releaseThreadContainment(_ threadID: UUID) {
        guard let index = threads.firstIndex(where: { $0.id == threadID }) else { return }
        threads[index].status = .monitoring
        threads[index].lastActive = "Containment released"
        threads[index].containmentStatus = "Containment released"
        threads[index].recoveryPlan = "Room and support updates can resume under monitored mode."
    }

    func postRoomUpdate(_ roomID: UUID) {
        guard let index = rooms.firstIndex(where: { $0.id == roomID }) else { return }
        let roomName = rooms[index].name
        let update = rooms[index].operatorDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !update.isEmpty else { return }

        rooms[index].lastUpdate = "Posted now"
        rooms[index].activity = "Fresh operator broadcast"
        rooms[index].pendingRequests = max(0, rooms[index].pendingRequests - 1)
        rooms[index].announcements.insert(update, at: 0)
        rooms[index].operatorDraft = ""

        if let threadIndex = threads.firstIndex(where: { $0.roomName == roomName }) {
            threads[threadIndex].messages.append(
                MessagingThreadMessage(author: operatorName, timestamp: "Now", body: update)
            )
            threads[threadIndex].latestMessage = update
            threads[threadIndex].lastSender = operatorName
            threads[threadIndex].lastActive = "Now"
            threads[threadIndex].status = .monitoring
        }
    }

    func assignModerator(_ roomID: UUID) {
        guard let index = rooms.firstIndex(where: { $0.id == roomID }) else { return }
        rooms[index].pendingRequests = max(0, rooms[index].pendingRequests - 2)
        rooms[index].activity = "Extra moderator assigned"
    }

    func enableSlowMode(_ roomID: UUID) {
        guard let index = rooms.firstIndex(where: { $0.id == roomID }) else { return }
        rooms[index].slowModeEnabled = true
        rooms[index].activity = "Slow mode enabled"
        rooms[index].recoveryPlan = "Posting cadence is throttled while moderators clear abuse spikes."
    }

    func lockRoomInvites(_ roomID: UUID) {
        guard let index = rooms.firstIndex(where: { $0.id == roomID }) else { return }
        rooms[index].inviteGateLocked = true
        rooms[index].activity = "Invite gate locked"
        rooms[index].recoveryPlan = "New joins are paused until trust confirms the room is stable."
    }

    func publishRoomRecoveryPlan(_ roomID: UUID) {
        guard let index = rooms.firstIndex(where: { $0.id == roomID }) else { return }
        rooms[index].recoveryPlan = "Pinned recovery plan published with FAQ, moderator routing, and appeal intake lane."
        rooms[index].lastUpdate = "Recovery plan posted now"
        rooms[index].announcements.insert(rooms[index].recoveryPlan, at: 0)
    }

    func clearRoomContainment(_ roomID: UUID) {
        guard let index = rooms.firstIndex(where: { $0.id == roomID }) else { return }
        rooms[index].slowModeEnabled = false
        rooms[index].inviteGateLocked = false
        rooms[index].activity = "Containment cleared"
        rooms[index].recoveryPlan = "Room returned to normal operations under moderator watch."
    }

    func assignSafetyLead(_ caseID: UUID, lead: String) {
        guard let index = safetyCases.firstIndex(where: { $0.id == caseID }) else { return }
        safetyCases[index].assignedLead = lead
        safetyCases[index].nextAction = "Lead \(lead) owns the trust path and final customer-safe language."
    }

    func exportEvidence(_ caseID: UUID) {
        guard let index = safetyCases.firstIndex(where: { $0.id == caseID }) else { return }
        safetyCases[index].evidenceExported = true
        safetyCases[index].nextAction = "Transcript, attachments, and room actions exported for trust review."
    }

    func placeLegalHold(_ caseID: UUID) {
        guard let index = safetyCases.firstIndex(where: { $0.id == caseID }) else { return }
        safetyCases[index].legalHoldActive = true
        safetyCases[index].status = .escalated
        safetyCases[index].nextAction = "Legal hold is active. Preserve all actor history before any external response."
        syncThreadStatus(for: safetyCases[index].threadTitle, to: .escalated)
    }

    func resolveSafetyCase(_ caseID: UUID) {
        guard let index = safetyCases.firstIndex(where: { $0.id == caseID }) else { return }
        safetyCases[index].status = .resolved
        safetyCases[index].legalHoldActive = false
        safetyCases[index].nextAction = "User warned, evidence archived, and linked thread returned to monitored state."
        syncThreadStatus(for: safetyCases[index].threadTitle, to: .monitoring)
    }

    func escalateSafetyCase(_ caseID: UUID) {
        guard let index = safetyCases.firstIndex(where: { $0.id == caseID }) else { return }
        safetyCases[index].status = .escalated
        safetyCases[index].nextAction = "Escalated to trust lead and legal review with transcript export."
        syncThreadStatus(for: safetyCases[index].threadTitle, to: .escalated)
    }

    private func syncThreadStatus(for title: String, to status: MessagingThreadStatus) {
        guard let index = threads.firstIndex(where: { $0.title == title }) else { return }
        threads[index].status = status
        threads[index].isPinned = true
        threads[index].lastActive = "Escalated"
        threads[index].containmentStatus = status == .escalated ? "Trust escalation active" : "Monitoring restored"
    }

    func runInteractionProofIfNeeded() {
        guard MessagingInteractionProofMode.isEnabled, !interactionProofScheduled else { return }
        interactionProofScheduled = true

        DispatchQueue.main.async {
            var steps: [String] = []

            if let thread = self.threads.first {
                self.assignThreadOwner(thread.id, owner: "Trust Lead - Nora")
                self.updateDraft(thread.id, text: "Refund policy summary sent with next-step checklist.")
                self.freezeThread(thread.id)
                self.sendReply(to: thread.id)
                self.releaseThreadContainment(thread.id)
                self.resolveThread(thread.id)
                steps.append("Assigned thread owner, contained it, replied, and resolved it")
            }

            if let roomIndex = self.rooms.indices.first {
                let roomID = self.rooms[roomIndex].id
                self.enableSlowMode(roomID)
                self.lockRoomInvites(roomID)
                self.rooms[roomIndex].operatorDraft = "Moderator broadcast posted for abuse containment and appeal routing."
                self.postRoomUpdate(roomID)
                self.assignModerator(roomID)
                self.publishRoomRecoveryPlan(roomID)
                self.clearRoomContainment(roomID)
                steps.append("Contained room, published recovery plan, and restored it")
            }

            if let firstCase = self.safetyCases.first {
                self.assignSafetyLead(firstCase.id, lead: "Trust Lead - Nora")
                self.exportEvidence(firstCase.id)
                self.placeLegalHold(firstCase.id)
                self.escalateSafetyCase(firstCase.id)
                self.resolveSafetyCase(firstCase.id)
                steps.append("Assigned safety lead, exported evidence, placed legal hold, and resolved case")
            }

            MessagingInteractionProofMode.write(
                summary: "Messaging interaction proof completed with containment, trust escalation, and recovery chain.",
                steps: steps
            )
        }
    }
}

struct MessagingInboxWorkspaceView: View {
    @ObservedObject var store: MessagingCommandCenterStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    MessagingHeroCard(store: store)
                    MessagingInboxFilterStrip(store: store)

                    if let thread = store.priorityThread {
                        MessagingPriorityThreadCard(store: store, thread: thread)
                    }

                    MessagingThreadLane(title: "Active Threads", threads: store.filteredThreads, store: store)
                }
                .padding(16)
            }
            .navigationTitle("Inbox")
        }
    }
}

struct MessagingHeroCard: View {
    @ObservedObject var store: MessagingCommandCenterStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Messaging Control Center")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(store.controlCenterHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))

            Text(store.operatorNote)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                MessagingMetricChip(title: "Unread", value: "\(store.unreadCount)")
                MessagingMetricChip(title: "Contained", value: "\(store.containedThreadCount)")
                MessagingMetricChip(title: "Legal Holds", value: "\(store.legalHoldCount)")
                MessagingMetricChip(title: "Room Requests", value: "\(store.activeRoomRequests)")
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.indigo.opacity(0.18), .blue.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

struct MessagingMetricChip: View {
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

struct MessagingInboxFilterStrip: View {
    @ObservedObject var store: MessagingCommandCenterStore

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(MessagingInboxFilter.allCases) { filter in
                    Button(filter.title) {
                        store.selectedFilter = filter
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(store.selectedFilter == filter ? .indigo : .gray.opacity(0.35))
                }
            }
        }
    }
}

struct MessagingPriorityThreadCard: View {
    @ObservedObject var store: MessagingCommandCenterStore
    let thread: MessagingThreadRecord

    var body: some View {
        NavigationLink {
            MessagingThreadDetailView(store: store, threadID: thread.id)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Priority Thread")
                        .font(.title3.weight(.bold))
                    Spacer()
                    Text(thread.status.label)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(thread.status.tint)
                }

                Text(thread.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(thread.latestMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                HStack {
                    Label("\(thread.members) members", systemImage: "person.2.fill")
                    Spacer()
                    Text(thread.lastActive)
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

struct MessagingThreadLane: View {
    let title: String
    let threads: [MessagingThreadRecord]
    @ObservedObject var store: MessagingCommandCenterStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.weight(.bold))

            ForEach(threads) { thread in
                NavigationLink {
                    MessagingThreadDetailView(store: store, threadID: thread.id)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(thread.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(thread.status.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(thread.status.tint)
                        }

                        Text(thread.latestMessage)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)

                        HStack {
                            Text("\(thread.lastSender) • \(thread.lastActive)")
                            Spacer()
                            if thread.unreadCount > 0 {
                                Text("\(thread.unreadCount) unread")
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct MessagingRoomsWorkspaceView: View {
    @ObservedObject var store: MessagingCommandCenterStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.rooms) { room in
                    NavigationLink {
                        MessagingRoomDetailView(store: store, roomID: room.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(room.name)
                                Spacer()
                                if room.pendingRequests > 0 {
                                    Text("\(room.pendingRequests) open")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.orange)
                                }
                            }
                            Text(room.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(room.members) members • \(room.activity)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Rooms")
        }
    }
}

struct MessagingRoomDetailView: View {
    @ObservedObject var store: MessagingCommandCenterStore
    let roomID: UUID

    var body: some View {
        if let room = store.rooms.first(where: { $0.id == roomID }) {
            List {
                Section("Room Overview") {
                    Text(room.description)
                    Label("\(room.members) members", systemImage: "person.3.fill")
                    Label(room.activity, systemImage: "waveform.path.ecg")
                    Label(room.lastUpdate, systemImage: "clock.fill")
                    Label(room.slowModeEnabled ? "Slow mode active" : "Slow mode cleared", systemImage: "timer")
                    Label(room.inviteGateLocked ? "Invite gate locked" : "Invite gate open", systemImage: "person.badge.key.fill")
                    Text(room.recoveryPlan)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Operator Actions") {
                    Button("Post Room Update") {
                        store.postRoomUpdate(roomID)
                    }
                    Button("Assign Extra Moderator") {
                        store.assignModerator(roomID)
                    }
                    Button(room.slowModeEnabled ? "Clear Slow Mode" : "Enable Slow Mode") {
                        if room.slowModeEnabled {
                            store.clearRoomContainment(roomID)
                        } else {
                            store.enableSlowMode(roomID)
                        }
                    }
                    Button(room.inviteGateLocked ? "Unlock Invite Gate" : "Lock Invite Gate") {
                        if room.inviteGateLocked {
                            store.clearRoomContainment(roomID)
                        } else {
                            store.lockRoomInvites(roomID)
                        }
                    }
                    Button("Publish Recovery Plan") {
                        store.publishRoomRecoveryPlan(roomID)
                    }
                }

                Section("Broadcast Draft") {
                    TextEditor(
                        text: Binding(
                            get: { store.rooms.first(where: { $0.id == roomID })?.operatorDraft ?? "" },
                            set: { value in
                                guard let index = store.rooms.firstIndex(where: { $0.id == roomID }) else { return }
                                store.rooms[index].operatorDraft = value
                            }
                        )
                    )
                    .frame(minHeight: 120)
                }

                Section("Recent Broadcasts") {
                    ForEach(room.announcements, id: \.self) { announcement in
                        Text(announcement)
                    }
                }
            }
            .navigationTitle(room.name)
        }
    }
}

struct MessagingSafetyWorkspaceView: View {
    @ObservedObject var store: MessagingCommandCenterStore

    var body: some View {
        NavigationStack {
            List {
                Section("Moderation Queue") {
                    ForEach(store.safetyCases) { safetyCase in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(safetyCase.title)
                                Spacer()
                                Text(safetyCase.status.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(safetyCase.status.tint)
                            }
                            Text(safetyCase.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(safetyCase.nextAction)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Label(safetyCase.assignedLead, systemImage: "person.text.rectangle.fill")
                                .font(.caption)
                            Label(safetyCase.evidenceExported ? "Evidence exported" : "Evidence export pending", systemImage: "doc.on.doc.fill")
                                .font(.caption)
                            Label(safetyCase.legalHoldActive ? "Legal hold active" : "Legal hold clear", systemImage: "lock.doc.fill")
                                .font(.caption)
                            HStack {
                                Button("Resolve") {
                                    store.resolveSafetyCase(safetyCase.id)
                                }
                                .buttonStyle(.borderedProminent)

                                Button("Escalate") {
                                    store.escalateSafetyCase(safetyCase.id)
                                }
                                .buttonStyle(.bordered)

                                Button("Legal Hold") {
                                    store.placeLegalHold(safetyCase.id)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Coverage") {
                    Label("\(store.resolvedCaseCount) resolved today", systemImage: "checkmark.shield.fill")
                    Label("\(store.escalatedCaseCount) escalated cases", systemImage: "exclamationmark.shield.fill")
                    Label("\(store.legalHoldCount) legal holds active", systemImage: "lock.doc.fill")
                    Label(store.operatorNote, systemImage: "text.bubble.fill")
                }
            }
            .navigationTitle("Safety")
        }
    }
}

struct MessagingProfileWorkspaceView: View {
    @ObservedObject var store: MessagingCommandCenterStore

    var body: some View {
        NavigationStack {
            List {
                Section("Operator") {
                    Label(store.operatorName, systemImage: "person.crop.circle.fill")
                    Label(store.coverageShift, systemImage: "clock.fill")
                }

                Section("Performance") {
                    Label("\(store.unreadCount) unread messages", systemImage: "tray.full.fill")
                    Label("\(store.activeRoomRequests) room requests", systemImage: "person.3.fill")
                    Label("\(store.resolvedCaseCount) trust cases resolved", systemImage: "shield.checkered")
                    Label("\(store.containedThreadCount) contained threads", systemImage: "lock.shield.fill")
                }

                Section("Operating Rules") {
                    Text(store.operatorNote)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct MessagingThreadDetailView: View {
    @ObservedObject var store: MessagingCommandCenterStore
    let threadID: UUID

    var body: some View {
        if let thread = store.thread(id: threadID) {
            List {
                Section("Thread") {
                    Text(thread.title)
                        .font(.title3.weight(.bold))
                    Text(thread.latestMessage)
                        .foregroundStyle(.secondary)
                    Label(thread.status.label, systemImage: thread.status.systemImage)
                        .foregroundStyle(thread.status.tint)
                    Label(thread.owner, systemImage: "person.text.rectangle.fill")
                    Label(thread.containmentStatus, systemImage: "lock.shield.fill")
                    Text(thread.recoveryPlan)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Recent Messages") {
                    ForEach(thread.messages) { message in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(message.author)
                                    .font(.headline)
                                Spacer()
                                Text(message.timestamp)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Text(message.body)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Composer") {
                    TextEditor(
                        text: Binding(
                            get: { store.thread(id: threadID)?.draftReply ?? "" },
                            set: { store.updateDraft(threadID, text: $0) }
                        )
                    )
                    .frame(minHeight: 120)

                    Button("Send Reply") {
                        store.sendReply(to: threadID)
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Resolve Thread") {
                        store.resolveThread(threadID)
                    }
                    .buttonStyle(.bordered)

                    Button(thread.containmentStatus == "Thread frozen" ? "Release Containment" : "Freeze Thread") {
                        if thread.containmentStatus == "Thread frozen" {
                            store.releaseThreadContainment(threadID)
                        } else {
                            store.freezeThread(threadID)
                        }
                    }
                    .buttonStyle(.bordered)

                    Button(thread.isPinned ? "Unpin Thread" : "Pin Thread") {
                        store.togglePin(threadID)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .navigationTitle("Thread")
        }
    }
}

enum MessagingInboxFilter: String, CaseIterable, Identifiable {
    case priority
    case support
    case community
    case escalated

    var id: String { rawValue }

    var title: String {
        switch self {
        case .priority: return "Priority"
        case .support: return "Support"
        case .community: return "Community"
        case .escalated: return "Escalated"
        }
    }

    func includes(_ thread: MessagingThreadRecord) -> Bool {
        switch self {
        case .priority:
            return thread.isPinned || thread.unreadCount > 0
        case .support:
            return thread.kind == .support
        case .community:
            return thread.kind == .community
        case .escalated:
            return thread.status == .escalated
        }
    }
}

enum MessagingThreadKind {
    case support
    case community
    case internalOps
}

enum MessagingThreadStatus {
    case awaitingReply
    case awaitingCustomer
    case monitoring
    case escalated
    case resolved

    var label: String {
        switch self {
        case .awaitingReply: return "Awaiting reply"
        case .awaitingCustomer: return "Awaiting customer"
        case .monitoring: return "Monitoring"
        case .escalated: return "Escalated"
        case .resolved: return "Resolved"
        }
    }

    var tint: Color {
        switch self {
        case .awaitingReply: return .orange
        case .awaitingCustomer: return .blue
        case .monitoring: return .green
        case .escalated: return .red
        case .resolved: return .secondary
        }
    }

    var systemImage: String {
        switch self {
        case .awaitingReply: return "bubble.left.and.exclamationmark.bubble.right.fill"
        case .awaitingCustomer: return "arrow.uturn.left.circle.fill"
        case .monitoring: return "eye.fill"
        case .escalated: return "exclamationmark.triangle.fill"
        case .resolved: return "checkmark.circle.fill"
        }
    }
}

enum MessagingSafetyCaseStatus {
    case open
    case resolved
    case escalated

    var label: String {
        switch self {
        case .open: return "Open"
        case .resolved: return "Resolved"
        case .escalated: return "Escalated"
        }
    }

    var tint: Color {
        switch self {
        case .open: return .orange
        case .resolved: return .green
        case .escalated: return .red
        }
    }
}

struct MessagingThreadRecord: Identifiable {
    let id = UUID()
    let title: String
    let roomName: String?
    let members: Int
    let kind: MessagingThreadKind
    var unreadCount: Int
    var lastSender: String
    var lastActive: String
    var latestMessage: String
    var draftReply: String
    var status: MessagingThreadStatus
    var isPinned: Bool
    var owner: String
    var containmentStatus: String
    var recoveryPlan: String
    var messages: [MessagingThreadMessage]

    static let sampleThreads: [MessagingThreadRecord] = [
        MessagingThreadRecord(
            title: "Support Escalations",
            roomName: nil,
            members: 6,
            kind: .support,
            unreadCount: 4,
            lastSender: "Maya",
            lastActive: "2 min ago",
            latestMessage: "Customer needs refund confirmation before the chargeback deadline.",
            draftReply: "Finance reversal is complete. Sending the receipt trail and dispute-safe wording now.",
            status: .awaitingReply,
            isPinned: true,
            owner: "Ivy Bennett",
            containmentStatus: "Open lane",
            recoveryPlan: "Send refund proof, then keep thread under watch until chargeback timer closes.",
            messages: [
                .init(author: "Maya", timestamp: "17:18", body: "Customer needs refund confirmation before the chargeback deadline."),
                .init(author: "Owen", timestamp: "17:14", body: "Finance already reversed the charge, we only need the receipt trail."),
                .init(author: "Ivy", timestamp: "17:09", body: "Drafting the final response and adding account notes.")
            ]
        ),
        MessagingThreadRecord(
            title: "Creator Community",
            roomName: "Creator Community",
            members: 184,
            kind: .community,
            unreadCount: 12,
            lastSender: "Tara",
            lastActive: "12 min ago",
            latestMessage: "Creators are asking for clearer payout timing after yesterday’s incident.",
            draftReply: "Posting the payout FAQ, SLA, and incident recap now.",
            status: .monitoring,
            isPinned: false,
            owner: "Trust rotation",
            containmentStatus: "Open lane",
            recoveryPlan: "Broadcast the payout FAQ and throttle abuse if links spike again.",
            messages: [
                .init(author: "Tara", timestamp: "16:58", body: "Creators are asking for clearer payout timing after yesterday’s incident."),
                .init(author: "Ivy", timestamp: "16:51", body: "Preparing a broadcast with the payout FAQ and support lane.")
            ]
        ),
        MessagingThreadRecord(
            title: "Launch War Room",
            roomName: "Launch War Room",
            members: 23,
            kind: .internalOps,
            unreadCount: 3,
            lastSender: "Eli",
            lastActive: "8 min ago",
            latestMessage: "Need final copy approval for the new onboarding checkpoint before rollout.",
            draftReply: "Approving copy after analytics review and rollback note update.",
            status: .awaitingReply,
            isPinned: false,
            owner: "Release ops",
            containmentStatus: "Open lane",
            recoveryPlan: "Close the blocker only after rollback criteria are mirrored into the launch room.",
            messages: [
                .init(author: "Eli", timestamp: "17:12", body: "Need final copy approval for the new onboarding checkpoint before rollout."),
                .init(author: "Ivy", timestamp: "17:03", body: "Reviewing rollout note, metrics guardrail, and incident fallback.")
            ]
        )
    ]
}

struct MessagingThreadMessage: Identifiable {
    let id = UUID()
    let author: String
    let timestamp: String
    let body: String
}

struct MessagingRoomRecord: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let members: Int
    var activity: String
    var pendingRequests: Int
    var lastUpdate: String
    var operatorDraft: String
    var slowModeEnabled: Bool
    var inviteGateLocked: Bool
    var recoveryPlan: String
    var announcements: [String]

    static let sampleRooms: [MessagingRoomRecord] = [
        MessagingRoomRecord(
            name: "Creator Community",
            description: "High-volume community room for active creators and moderators.",
            members: 184,
            activity: "Peak activity 18:00-20:00",
            pendingRequests: 5,
            lastUpdate: "FAQ posted 42 min ago",
            operatorDraft: "Posting updated payout FAQ with precise settlement windows and escalation form.",
            slowModeEnabled: false,
            inviteGateLocked: false,
            recoveryPlan: "Room is open, but payout incidents still require fast moderator routing.",
            announcements: [
                "Reminder: route threats and payment fraud into the trust escalation lane immediately.",
                "Pinning the revised payout timing note until the incident closes."
            ]
        ),
        MessagingRoomRecord(
            name: "Launch War Room",
            description: "Cross-functional room for incident triage and release-day decisions.",
            members: 23,
            activity: "War-room standby",
            pendingRequests: 2,
            lastUpdate: "Rollback guardrail synced 19 min ago",
            operatorDraft: "Approving the onboarding rollout note and attaching rollback thresholds.",
            slowModeEnabled: false,
            inviteGateLocked: false,
            recoveryPlan: "Keep one owner per blocker and hold rollout until rollback notes are mirrored.",
            announcements: [
                "One owner per blocker. Close every thread with rollback status.",
                "Keep updates timestamped once the release window opens."
            ]
        )
    ]
}

struct MessagingSafetyCaseRecord: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let severity: String
    let threadTitle: String
    var status: MessagingSafetyCaseStatus
    var nextAction: String
    var assignedLead: String
    var evidenceExported: Bool
    var legalHoldActive: Bool

    static let sampleCases: [MessagingSafetyCaseRecord] = [
        MessagingSafetyCaseRecord(
            title: "Spam burst in Creator Community",
            summary: "Thirty-seven duplicate invite links posted in under six minutes.",
            severity: "High",
            threadTitle: "Creator Community",
            status: .open,
            nextAction: "Mute new accounts, remove links, and issue a room-wide trust notice.",
            assignedLead: "Unassigned",
            evidenceExported: false,
            legalHoldActive: false
        ),
        MessagingSafetyCaseRecord(
            title: "Harassment report in VIP support lane",
            summary: "Partner reported direct threats in a private support thread.",
            severity: "Critical",
            threadTitle: "Support Escalations",
            status: .open,
            nextAction: "Freeze the thread, export transcript, and page the trust lead.",
            assignedLead: "Unassigned",
            evidenceExported: false,
            legalHoldActive: false
        )
    ]
}
