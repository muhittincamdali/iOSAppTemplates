import SwiftUI
import MessagingAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct MessagingAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            MessagingWorkspaceRootView(
                snapshot: .sample,
                conversations: MessagingConversationCard.sampleCards,
                actions: MessagingQuickAction.defaultActions,
                health: .sample,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MessagingWorkspaceRootView: View {
    let snapshot: MessagingDashboardSnapshot
    let conversations: [MessagingConversationCard]
    let actions: [MessagingQuickAction]
    let health: MessagingOperationalHealth
    let state: MessagingWorkspaceState

    var body: some View {
        TabView {
            MessagingInboxView(
                snapshot: snapshot,
                conversations: conversations,
                actions: actions,
                health: health,
                state: state
            )
            .tabItem {
                Image(systemName: "tray.full.fill")
                Text("Inbox")
            }

            MessagingRoomsView(state: state)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Rooms")
                }

            MessagingSafetyView(health: health, state: state)
                .tabItem {
                    Image(systemName: "shield.lefthalf.filled")
                    Text("Safety")
                }

            MessagingProfileView(snapshot: snapshot, health: health, state: state)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.indigo)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MessagingInboxView: View {
    let snapshot: MessagingDashboardSnapshot
    let conversations: [MessagingConversationCard]
    let actions: [MessagingQuickAction]
    let health: MessagingOperationalHealth
    let state: MessagingWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    MessagingHeroCard(snapshot: snapshot, health: health, state: state)
                    MessagingQuickActionGrid(actions: actions)
                    MessagingPriorityThreadCard(thread: state.priorityThread)
                    MessagingConversationLane(title: "Priority Inbox", threads: state.priorityThreads)
                    MessagingConversationLane(title: "Recent Replies", threads: state.recentThreads)
                }
                .padding(16)
            }
            .navigationTitle("Inbox")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MessagingHeroCard: View {
    let snapshot: MessagingDashboardSnapshot
    let health: MessagingOperationalHealth
    let state: MessagingWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Messaging Control Center")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(state.operatorHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(state.statusNote)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                MessagingMetricChip(title: "Unread", value: "\(snapshot.unreadMessages)")
                MessagingMetricChip(title: "Threads", value: "\(snapshot.activeThreads)")
                MessagingMetricChip(title: "Rooms", value: "\(snapshot.communityRooms)")
            }

            HStack {
                Label(snapshot.syncHealth, systemImage: "antenna.radiowaves.left.and.right")
                Spacer()
                Text("\(health.messageDeliveryLatencyMs) ms")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.indigo)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
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

@available(iOS 18.0, macOS 15.0, *)
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

@available(iOS 18.0, macOS 15.0, *)
struct MessagingQuickActionGrid: View {
    let actions: [MessagingQuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions) { action in
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: action.systemImage)
                            .font(.title3)
                            .foregroundStyle(.indigo)
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
struct MessagingPriorityThreadCard: View {
    let thread: MessagingThread

    var body: some View {
        NavigationLink {
            MessagingThreadDetailView(thread: thread)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                Text("Priority Thread")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                Text(thread.title)
                    .font(.headline)
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

@available(iOS 18.0, macOS 15.0, *)
struct MessagingConversationLane: View {
    let title: String
    let threads: [MessagingThread]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.weight(.bold))

            ForEach(threads) { thread in
                NavigationLink {
                    MessagingThreadDetailView(thread: thread)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(thread.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            if thread.unreadCount > 0 {
                                Text("\(thread.unreadCount)")
                                    .font(.caption2.weight(.bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.indigo.opacity(0.16))
                                    .clipShape(Capsule())
                            }
                        }
                        Text(thread.latestMessage)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                        Text("\(thread.lastSender) • \(thread.lastActive)")
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
struct MessagingRoomsView: View {
    let state: MessagingWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.rooms) { room in
                    NavigationLink {
                        MessagingRoomDetailView(room: room)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(room.name)
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

@available(iOS 18.0, macOS 15.0, *)
struct MessagingSafetyView: View {
    let health: MessagingOperationalHealth
    let state: MessagingWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Moderation Queue") {
                    ForEach(state.safetyCases) { safetyCase in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(safetyCase.title)
                                Spacer()
                                Text(safetyCase.severity)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(safetyCase.severityColor)
                            }
                            Text(safetyCase.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(safetyCase.nextAction)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Operational Health") {
                    Label("\(health.moderationQueue) active reviews", systemImage: "tray.full.fill")
                    Label("\(health.messageDeliveryLatencyMs) ms delivery latency", systemImage: "bolt.horizontal.circle.fill")
                    Label(health.safetyChecksReady ? "Safety checks ready" : "Safety checks degraded", systemImage: health.safetyChecksReady ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                }
            }
            .navigationTitle("Safety")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MessagingProfileView: View {
    let snapshot: MessagingDashboardSnapshot
    let health: MessagingOperationalHealth
    let state: MessagingWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Operator") {
                    Label(state.operatorName, systemImage: "person.crop.circle.fill")
                    Label(state.coverageShift, systemImage: "clock.fill")
                }
                Section("Messaging Metrics") {
                    Label("\(snapshot.activeThreads) active threads", systemImage: "bubble.left.and.bubble.right.fill")
                    Label("\(snapshot.communityRooms) community rooms", systemImage: "person.3.fill")
                    Label("\(state.resolutionRate) resolution rate", systemImage: "chart.line.uptrend.xyaxis")
                }
                Section("Trust") {
                    Label("\(health.moderationQueue) cases waiting", systemImage: "shield.lefthalf.filled")
                    Label(state.escalationPolicy, systemImage: "exclamationmark.bubble.fill")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MessagingThreadDetailView: View {
    let thread: MessagingThread

    var body: some View {
        List {
            Section("Thread") {
                Text(thread.title)
                    .font(.title3.weight(.bold))
                Text(thread.latestMessage)
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
                Label(thread.draft, systemImage: "square.and.pencil")
                Label(thread.replyMode, systemImage: "arrowshape.turn.up.left.fill")
            }
        }
        .navigationTitle("Thread")
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MessagingRoomDetailView: View {
    let room: MessagingRoom

    var body: some View {
        List {
            Section("Room Overview") {
                Text(room.description)
                Label("\(room.members) members", systemImage: "person.3.fill")
                Label(room.activity, systemImage: "waveform.path.ecg")
            }
            Section("Rules") {
                ForEach(room.rules, id: \.self) { rule in
                    Label(rule, systemImage: "checkmark.circle.fill")
                }
            }
        }
        .navigationTitle(room.name)
    }
}

public struct MessagingQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [MessagingQuickAction] = [
        MessagingQuickAction(title: "Open Priority Inbox", detail: "Review high-signal customer and team threads before the handoff window.", systemImage: "tray.full.fill"),
        MessagingQuickAction(title: "Review Community Rooms", detail: "Check rooms with elevated activity and unanswered moderator requests.", systemImage: "person.3.fill"),
        MessagingQuickAction(title: "Moderate Safety Queue", detail: "Resolve abusive content, spam patterns and escalation requests quickly.", systemImage: "shield.lefthalf.filled")
    ]
}

struct MessagingWorkspaceState {
    let operatorHeadline: String
    let statusNote: String
    let operatorName: String
    let coverageShift: String
    let resolutionRate: String
    let escalationPolicy: String
    let priorityThread: MessagingThread
    let priorityThreads: [MessagingThread]
    let recentThreads: [MessagingThread]
    let rooms: [MessagingRoom]
    let safetyCases: [MessagingSafetyCase]

    static let sample = MessagingWorkspaceState(
        operatorHeadline: "Priority inbox is under control",
        statusNote: "Customer escalations are down, but creator community volume is rising into the evening shift.",
        operatorName: "Ivy Bennett",
        coverageShift: "EU + US overlap shift",
        resolutionRate: "94% same-day",
        escalationPolicy: "Escalate fraud, threats and minors policy breaches in under 10 min",
        priorityThread: MessagingThread(
            title: "Support Escalations",
            members: 6,
            unreadCount: 4,
            lastSender: "Maya",
            lastActive: "2 min ago",
            latestMessage: "Customer needs order refund confirmation before chargeback deadline.",
            draft: "Routing finance confirmation and attaching refund policy excerpt.",
            replyMode: "Reply to support squad",
            messages: [
                MessagingMessage(author: "Maya", timestamp: "17:18", body: "Customer needs order refund confirmation before chargeback deadline."),
                MessagingMessage(author: "Owen", timestamp: "17:14", body: "Finance already reversed the charge, we only need the receipt trail."),
                MessagingMessage(author: "Ivy", timestamp: "17:09", body: "Drafting the final response and adding account notes.")
            ]
        ),
        priorityThreads: [
            MessagingThread(title: "Support Escalations", members: 6, unreadCount: 4, lastSender: "Maya", lastActive: "2 min ago", latestMessage: "Customer needs order refund confirmation before chargeback deadline.", draft: "Routing finance confirmation and attaching refund policy excerpt.", replyMode: "Reply to support squad", messages: []),
            MessagingThread(title: "Core Product Team", members: 12, unreadCount: 2, lastSender: "Eli", lastActive: "8 min ago", latestMessage: "Need final copy approval for the new onboarding checkpoint.", draft: "Sharing revised copy with analytics context.", replyMode: "Reply in thread", messages: [])
        ],
        recentThreads: [
            MessagingThread(title: "Creator Community", members: 184, unreadCount: 12, lastSender: "Tara", lastActive: "12 min ago", latestMessage: "Creators are asking for clearer payout timing after yesterday’s incident.", draft: "Posting the payout FAQ and status page link.", replyMode: "Broadcast to room", messages: []),
            MessagingThread(title: "Ops Hand-off", members: 9, unreadCount: 0, lastSender: "Jon", lastActive: "21 min ago", latestMessage: "Evening shift inherits three moderation reviews and one policy escalation.", draft: "Summarize unresolved tickets for handoff.", replyMode: "Send handoff note", messages: [])
        ],
        rooms: [
            MessagingRoom(name: "Creator Community", description: "High-volume community room for active creators and moderators.", members: 184, activity: "Peak activity 18:00-20:00", rules: ["Pin payout updates quickly", "Escalate threats immediately", "Move billing questions into support thread"]),
            MessagingRoom(name: "Launch War Room", description: "Cross-functional room for incident triage and release-day decisions.", members: 23, activity: "War-room standby", rules: ["Keep updates timestamped", "One owner per blocker", "Close with rollback status"]),
            MessagingRoom(name: "VIP Accounts", description: "Dedicated white-glove support room for enterprise and creator partners.", members: 14, activity: "Low volume, high priority", rules: ["Acknowledge within 5 min", "Tag account owner on every escalation"])
        ],
        safetyCases: [
            MessagingSafetyCase(title: "Spam burst in Creator Community", severity: "High", summary: "Thirty-seven duplicate invite links posted in under six minutes.", nextAction: "Auto-mute new accounts and promote one moderator."),
            MessagingSafetyCase(title: "Harassment report in VIP Accounts", severity: "Critical", summary: "Partner reported direct threats in a private support thread.", nextAction: "Freeze thread, export transcript and page trust lead."),
            MessagingSafetyCase(title: "Payment phishing attempt", severity: "Medium", summary: "Suspicious fake refund instructions shared in a support DM.", nextAction: "Warn affected users and remove message template.")
        ]
    )
}

struct MessagingThread: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let members: Int
    let unreadCount: Int
    let lastSender: String
    let lastActive: String
    let latestMessage: String
    let draft: String
    let replyMode: String
    let messages: [MessagingMessage]
}

struct MessagingMessage: Identifiable, Hashable {
    let id = UUID()
    let author: String
    let timestamp: String
    let body: String
}

struct MessagingRoom: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let members: Int
    let activity: String
    let rules: [String]
}

struct MessagingSafetyCase: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let severity: String
    let summary: String
    let nextAction: String

    var severityColor: Color {
        switch severity {
        case "Critical":
            return .red
        case "High":
            return .orange
        default:
            return .yellow
        }
    }
}
