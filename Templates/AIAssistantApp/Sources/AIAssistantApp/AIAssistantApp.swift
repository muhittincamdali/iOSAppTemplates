import SwiftUI
import AIAssistantAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct AIAssistantAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            AIAssistantWorkspaceRootView(
                snapshot: .sample,
                tasks: AIAssistantTaskCard.sampleCards,
                actions: AIAssistantQuickAction.defaultActions,
                signals: AIAssistantSignal.sampleSignals,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantWorkspaceRootView: View {
    let snapshot: AIAssistantWorkspaceSnapshot
    let tasks: [AIAssistantTaskCard]
    let actions: [AIAssistantQuickAction]
    let signals: [AIAssistantSignal]
    let state: AIAssistantWorkspaceState

    var body: some View {
        TabView {
            AIAssistantDashboardView(
                snapshot: snapshot,
                tasks: tasks,
                actions: actions,
                signals: signals,
                state: state
            )
            .tabItem {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                Text("Workspace")
            }

            AIAssistantPresetsView(state: state)
                .tabItem {
                    Image(systemName: "wand.and.stars")
                    Text("Presets")
                }

            AIAssistantMemoryView(state: state)
                .tabItem {
                    Image(systemName: "tray.full.fill")
                    Text("Memory")
                }

            AIAssistantToolsView(state: state)
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Tools")
                }

            AIAssistantTrustView(snapshot: snapshot, state: state)
                .tabItem {
                    Image(systemName: "checkmark.shield.fill")
                    Text("Trust")
                }
        }
        .tint(.indigo)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantDashboardView: View {
    let snapshot: AIAssistantWorkspaceSnapshot
    let tasks: [AIAssistantTaskCard]
    let actions: [AIAssistantQuickAction]
    let signals: [AIAssistantSignal]
    let state: AIAssistantWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    AIAssistantHeroCard(snapshot: snapshot, state: state)
                    AIAssistantConversationCard(messages: state.messages)
                    AIAssistantSuggestedTasksView(tasks: tasks)
                    AIAssistantQuickActionGrid(actions: actions)
                    AIAssistantSignalBoard(signals: signals)
                }
                .padding(16)
            }
            .navigationTitle("AI Assistant")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantHeroCard: View {
    let snapshot: AIAssistantWorkspaceSnapshot
    let state: AIAssistantWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Active Context")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(snapshot.activeContext)
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text(snapshot.trustStatus)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                AIAssistantMetricChip(title: "Route", value: snapshot.modelRoute)
                AIAssistantMetricChip(title: "Pending", value: "\(snapshot.pendingSuggestions)")
                AIAssistantMetricChip(title: "Tools", value: "\(state.enabledToolCount)")
            }

            HStack {
                Label(state.primaryGoal, systemImage: "target")
                Spacer()
                Text(state.guardrailStatus)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.indigo)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.indigo.opacity(0.16), .blue.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantMetricChip: View {
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
struct AIAssistantConversationCard: View {
    let messages: [AIAssistantMessage]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Conversation")
                .font(.title3.weight(.bold))

            ForEach(messages) { message in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: message.role == .assistant ? "sparkles" : "person.fill")
                        .foregroundStyle(message.role == .assistant ? .indigo : .secondary)
                        .frame(width: 20)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(message.title)
                            .font(.headline)
                        Text(message.body)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(message.footnote)
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
struct AIAssistantSuggestedTasksView: View {
    let tasks: [AIAssistantTaskCard]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Suggested Tasks")
                .font(.title3.weight(.bold))

            ForEach(tasks) { task in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(task.title)
                            .font(.headline)
                        Spacer()
                        Text(task.confidence)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.indigo)
                    }
                    Text(task.summary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantQuickActionGrid: View {
    let actions: [AIAssistantQuickAction]

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
struct AIAssistantSignalBoard: View {
    let signals: [AIAssistantSignal]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Signals")
                .font(.title3.weight(.bold))

            ForEach(Array(signals.enumerated()), id: \.offset) { _, signal in
                HStack {
                    Text(signal.title)
                    Spacer()
                    Text(signal.value)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.indigo)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantPresetsView: View {
    let state: AIAssistantWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Prompt Presets") {
                    ForEach(state.presets) { preset in
                        NavigationLink {
                            AIAssistantPresetDetailView(preset: preset)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(preset.title)
                                    Spacer()
                                    Text(preset.mode)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.indigo)
                                }
                                Text(preset.summary)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Presets")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantMemoryView: View {
    let state: AIAssistantWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Saved Memory") {
                    ForEach(state.memoryItems) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(item.title)
                                Spacer()
                                Text(item.scope)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }
                            Text(item.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Retention Rules") {
                    ForEach(state.retentionRules, id: \.self) { rule in
                        Label(rule, systemImage: "tray.full.fill")
                    }
                }
            }
            .navigationTitle("Memory")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantToolsView: View {
    let state: AIAssistantWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Enabled Tools") {
                    ForEach(state.tools) { tool in
                        NavigationLink {
                            AIAssistantToolDetailView(tool: tool)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(tool.name)
                                    Spacer()
                                    Text(tool.status)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(tool.statusColor)
                                }
                                Text(tool.summary)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Tools")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantTrustView: View {
    let snapshot: AIAssistantWorkspaceSnapshot
    let state: AIAssistantWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Trust") {
                    LabeledContent("Status", value: snapshot.trustStatus)
                    LabeledContent("Redaction", value: state.redactionPolicy)
                    LabeledContent("Approval Mode", value: state.approvalMode)
                    LabeledContent("Audit Coverage", value: state.auditCoverage)
                }

                Section("Guardrails") {
                    ForEach(state.guardrails, id: \.self) { guardrail in
                        Label(guardrail, systemImage: "checkmark.shield")
                    }
                }

                Section("Escalations") {
                    ForEach(state.escalationRules, id: \.self) { rule in
                        Label(rule, systemImage: "arrow.up.right.circle")
                    }
                }
            }
            .navigationTitle("Trust")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantPresetDetailView: View {
    let preset: AIAssistantPreset

    var body: some View {
        List {
            Section("Preset") {
                LabeledContent("Title", value: preset.title)
                LabeledContent("Mode", value: preset.mode)
                Text(preset.summary)
                    .foregroundStyle(.secondary)
            }

            Section("Prompt Outline") {
                ForEach(preset.steps, id: \.self) { step in
                    Label(step, systemImage: "text.bubble")
                }
            }
        }
        .navigationTitle("Preset")
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantToolDetailView: View {
    let tool: AIAssistantTool

    var body: some View {
        List {
            Section("Tool") {
                LabeledContent("Name", value: tool.name)
                LabeledContent("Status", value: tool.status)
                Text(tool.summary)
                    .foregroundStyle(.secondary)
            }

            Section("Boundaries") {
                ForEach(tool.boundaries, id: \.self) { boundary in
                    Label(boundary, systemImage: "shield.lefthalf.filled")
                }
            }
        }
        .navigationTitle("Tool")
    }
}

public struct AIAssistantQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [AIAssistantQuickAction] = [
        AIAssistantQuickAction(title: "Summarize Notes", detail: "Turn long notes into a short executive brief with action items.", systemImage: "text.redaction"),
        AIAssistantQuickAction(title: "Draft Message", detail: "Generate a concise follow-up while keeping sensitive names redacted.", systemImage: "sparkles"),
        AIAssistantQuickAction(title: "Review Guardrails", detail: "Inspect what the assistant can store, call, and escalate.", systemImage: "checkmark.shield.fill"),
        AIAssistantQuickAction(title: "Run Planning Flow", detail: "Convert deadlines into a focused plan with protected deep-work blocks.", systemImage: "calendar.badge.clock")
    ]
}

struct AIAssistantWorkspaceState: Hashable, Sendable {
    let primaryGoal: String
    let guardrailStatus: String
    let enabledToolCount: Int
    let redactionPolicy: String
    let approvalMode: String
    let auditCoverage: String
    let messages: [AIAssistantMessage]
    let presets: [AIAssistantPreset]
    let memoryItems: [AIAssistantMemoryItem]
    let tools: [AIAssistantTool]
    let retentionRules: [String]
    let guardrails: [String]
    let escalationRules: [String]

    static let sample = AIAssistantWorkspaceState(
        primaryGoal: "Turn weekly planning notes into a clear, high-trust execution plan.",
        guardrailStatus: "Guardrails passing",
        enabledToolCount: 4,
        redactionPolicy: "PII redacted before cloud escalation",
        approvalMode: "Manual approval for external sends",
        auditCoverage: "100% logged",
        messages: [
            AIAssistantMessage(role: .user, title: "Planning Input", body: "I have eight open tasks, two deadlines and one sensitive vendor thread. Build me a focused day plan.", footnote: "User prompt • 09:10"),
            AIAssistantMessage(role: .assistant, title: "Draft Plan", body: "I grouped the work into a 90-minute planning block, a protected deep-work session, and a late-day vendor follow-up window.", footnote: "Assistant response • local route"),
            AIAssistantMessage(role: .assistant, title: "Guardrail Note", body: "Vendor names were redacted before suggesting the external email draft.", footnote: "Trust event • logged")
        ],
        presets: [
            AIAssistantPreset(title: "Weekly Planning", mode: "Local-first", summary: "Turns raw notes into a prioritized plan with energy-aware sequencing.", steps: ["Summarize inputs", "Detect deadlines", "Build time blocks", "Flag escalations"]),
            AIAssistantPreset(title: "Customer Follow-up", mode: "Approval required", summary: "Drafts a reply, highlights risk and waits for manual send approval.", steps: ["Extract context", "Draft response", "Redact sensitive fields", "Hold for approval"]),
            AIAssistantPreset(title: "Meeting Debrief", mode: "Local", summary: "Converts transcripts into decisions, owners and next steps.", steps: ["Cluster decisions", "Assign owners", "Generate recap"])
        ],
        memoryItems: [
            AIAssistantMemoryItem(title: "Planning Style", detail: "Prefer two deep-work blocks before 15:00 and short admin clusters afterward.", scope: "Workspace"),
            AIAssistantMemoryItem(title: "Vendor Handling", detail: "Never send external vendor messages without user approval.", scope: "Guardrail"),
            AIAssistantMemoryItem(title: "Preferred Summary", detail: "Use compact bullet summaries with explicit action owners.", scope: "Personal")
        ],
        tools: [
            AIAssistantTool(name: "Calendar Reader", status: "Enabled", statusColor: .green, summary: "Reads events to place work around meetings and travel.", boundaries: ["Read-only", "No write access", "Local cache only"]),
            AIAssistantTool(name: "Task Router", status: "Enabled", statusColor: .green, summary: "Maps tasks into projects, priorities and execution windows.", boundaries: ["Uses local task graph", "No external sharing"]),
            AIAssistantTool(name: "External Drafting", status: "Approval gate", statusColor: .orange, summary: "Prepares outbound drafts but never sends automatically.", boundaries: ["Manual approval required", "PII redaction enforced"]),
            AIAssistantTool(name: "Knowledge Recall", status: "Scoped", statusColor: .blue, summary: "Retrieves prior notes and memory entries with scope limits.", boundaries: ["Workspace-only", "Time-boxed retention"])
        ],
        retentionRules: [
            "Sensitive memory expires after the active planning cycle closes.",
            "Conversation state is trimmed to the minimum context required for the next tool call.",
            "External-draft traces remain auditable but redacted."
        ],
        guardrails: [
            "No outbound message is sent without explicit confirmation.",
            "PII and vendor identifiers are redacted before cloud routes.",
            "High-risk suggestions require a trust review card."
        ],
        escalationRules: [
            "Escalate to a cloud route only if the local route cannot satisfy the task.",
            "Escalate to the user when legal, HR, finance or vendor risk appears.",
            "Escalate tool use when attachments or external sharing are requested."
        ]
    )
}

enum AIAssistantMessageRole: Hashable, Sendable {
    case user
    case assistant
}

struct AIAssistantMessage: Identifiable, Hashable, Sendable {
    let id = UUID()
    let role: AIAssistantMessageRole
    let title: String
    let body: String
    let footnote: String
}

struct AIAssistantPreset: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let mode: String
    let summary: String
    let steps: [String]
}

struct AIAssistantMemoryItem: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let detail: String
    let scope: String
}

struct AIAssistantTool: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let status: String
    let statusColor: Color
    let summary: String
    let boundaries: [String]
}
