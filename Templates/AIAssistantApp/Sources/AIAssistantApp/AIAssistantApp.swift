import Foundation
import SwiftUI
import AIAssistantAppCore

private enum AIAssistantInteractionProofMode {
    static let isEnabled = ProcessInfo.processInfo.environment["IOSAPPTEMPLATES_INTERACTION_PROOF_MODE"] == "1"

    static func write(summary: String, steps: [String]) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let payload: [String: Any] = [
            "app": "AIAssistantApp",
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

@available(iOS 18.0, macOS 15.0, *)
public struct AIAssistantAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            AIAssistantRuntimeRootView()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantRuntimeRootView: View {
    @StateObject private var store = AIAssistantOperationsStore()

    var body: some View {
        TabView {
            AIAssistantWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Workspace")
                }

            AIAssistantPresetsView(store: store)
                .tabItem {
                    Image(systemName: "wand.and.stars")
                    Text("Presets")
                }

            AIAssistantMemoryView(store: store)
                .tabItem {
                    Image(systemName: "tray.full.fill")
                    Text("Memory")
                }

            AIAssistantToolsView(store: store)
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Tools")
                }

            AIAssistantTrustView(store: store)
                .tabItem {
                    Image(systemName: "checkmark.shield.fill")
                    Text("Trust")
                }
        }
        .tint(.indigo)
        .onAppear {
            store.runInteractionProofIfNeeded()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class AIAssistantOperationsStore: ObservableObject {
    @Published var draftPrompt = "Draft a stakeholder-ready recovery update for the shipping delay while redacting the partner name."
    @Published var memoryDraft = "Customer updates should stay concise and commit to a next checkpoint within 24 hours."
    @Published var conversation: [AIAssistantConversationEntry]
    @Published var presets: [AIAssistantPresetRecord]
    @Published var memoryItems: [AIAssistantMemoryRecord]
    @Published var tools: [AIAssistantToolRecord]
    @Published var approvalRequests: [AIAssistantApprovalRecord]
    @Published var trustCases: [AIAssistantTrustCase]
    @Published var guardrailEvents: [String]
    @Published var currentGoal: String
    @Published var workspaceStatus: String
    private var interactionProofScheduled = false

    init() {
        self.currentGoal = "Ship a customer-safe recovery message without leaking partner identity."
        self.workspaceStatus = "Local route active"
        self.conversation = [
            AIAssistantConversationEntry(role: .user, title: "Recovery brief", body: "Prepare a calm update for the customer and keep the vendor name private.", footnote: "Input • 09:12"),
            AIAssistantConversationEntry(role: .assistant, title: "Draft plan", body: "I prepared a two-step response: explain the delay, offer a next checkpoint and keep the supplier unnamed.", footnote: "Assistant • local-only"),
            AIAssistantConversationEntry(role: .assistant, title: "Trust note", body: "External-send approval is required before the message can leave the workspace.", footnote: "Guardrail • enforced")
        ]
        self.presets = [
            AIAssistantPresetRecord(title: "Weekly Planning", mode: "Local-first", summary: "Turn raw notes into a sequenced execution plan.", steps: ["Summarize notes", "Detect deadlines", "Build blocks"], lastRunStatus: "Ready"),
            AIAssistantPresetRecord(title: "Customer Recovery", mode: "Approval required", summary: "Draft a customer-safe response and wait for approval.", steps: ["Extract issue", "Draft response", "Redact vendor identity", "Queue approval"], lastRunStatus: "Needs approval"),
            AIAssistantPresetRecord(title: "Meeting Debrief", mode: "Local", summary: "Convert transcript fragments into decisions and owners.", steps: ["Find decisions", "Assign owners", "Publish recap"], lastRunStatus: "Ready")
        ]
        self.memoryItems = [
            AIAssistantMemoryRecord(title: "Writing style", detail: "Use compact bullet summaries with one clear next step.", scope: "Personal", isPinned: true),
            AIAssistantMemoryRecord(title: "Vendor handling", detail: "Never expose supplier names in outbound recovery copy.", scope: "Guardrail", isPinned: true),
            AIAssistantMemoryRecord(title: "Escalation threshold", detail: "Route finance, legal or HR topics through trust review first.", scope: "Workspace", isPinned: false)
        ]
        self.tools = [
            AIAssistantToolRecord(name: "Calendar Reader", summary: "Reads meeting load before suggesting send windows.", status: .enabled, boundaries: ["Read-only", "No external write", "Local cache only"]),
            AIAssistantToolRecord(name: "Task Router", summary: "Maps work into priority lanes and owner queues.", status: .enabled, boundaries: ["Workspace-only", "No third-party sync"]),
            AIAssistantToolRecord(name: "External Drafting", summary: "Creates outbound drafts behind an approval gate.", status: .approvalRequired, boundaries: ["Manual send approval", "PII redaction enforced"]),
            AIAssistantToolRecord(name: "Knowledge Recall", summary: "Pulls scoped memory and prior decisions into context.", status: .scoped, boundaries: ["Time-boxed retention", "Workspace-only"])
        ]
        self.approvalRequests = [
            AIAssistantApprovalRecord(title: "Customer delay message", route: "External email", status: .pending, summary: "Customer-safe recovery draft queued for manual approval.", approvalOwner: "Ops Reviewer - Mira", rollbackState: "Rollback not prepared"),
            AIAssistantApprovalRecord(title: "Vendor escalation brief", route: "Internal escalation", status: .approved, summary: "Operations team recap already approved for internal send.", approvalOwner: "Ops Reviewer - Mira", rollbackState: "Rollback ready")
        ]
        self.trustCases = [
            AIAssistantTrustCase(title: "PII redaction audit", detail: "A recovery draft touched protected customer fields and needs a trust pass.", severity: .high, status: .open, assignedOwner: "Trust Lead - Nora", legalHoldActive: false, recoveryPlan: "Keep outbound blocked until the redaction audit and rollback note are both complete."),
            AIAssistantTrustCase(title: "Cloud route request", detail: "One long-form transcript asked for a cloud summarize path beyond local budget.", severity: .medium, status: .monitoring, assignedOwner: "Platform Review", legalHoldActive: false, recoveryPlan: "Monitor demand and keep the route local until a scoped cloud trust review clears.")
        ]
        self.guardrailEvents = [
            "Outbound sends stay blocked until an approval request is cleared.",
            "PII and vendor identifiers are redacted before any external route.",
            "Trust cases are logged before the model route can expand."
        ]
    }

    var enabledToolCount: Int {
        tools.filter { $0.status == .enabled }.count
    }

    var pinnedMemoryCount: Int {
        memoryItems.filter(\.isPinned).count
    }

    var openTrustCaseCount: Int {
        trustCases.filter { $0.status == .open || $0.status == .monitoring }.count
    }

    var pendingApprovalCount: Int {
        approvalRequests.filter { $0.status == .pending }.count
    }

    var legalHoldCount: Int {
        trustCases.filter(\.legalHoldActive).count
    }

    var rollbackReadyCount: Int {
        approvalRequests.filter { $0.rollbackState == "Rollback ready" }.count
    }

    func runPreset(_ preset: AIAssistantPresetRecord) {
        guard let index = presets.firstIndex(where: { $0.id == preset.id }) else { return }
        presets[index].lastRunStatus = preset.mode == "Approval required" ? "Queued for approval" : "Completed locally"
        workspaceStatus = preset.mode == "Approval required" ? "Approval gate waiting" : "Preset completed"
        currentGoal = "Executed \(preset.title) with current workspace guardrails."
        conversation.append(
            AIAssistantConversationEntry(
                role: .assistant,
                title: "\(preset.title) executed",
                body: "The preset completed its workflow and updated the workspace state for the next action.",
                footnote: "Preset • \(presets[index].lastRunStatus)"
            )
        )

        if preset.mode == "Approval required" {
            approvalRequests.insert(
                AIAssistantApprovalRecord(
                    title: "\(preset.title) outbound draft",
                    route: "External draft",
                    status: .pending,
                    summary: "A new outbound draft is waiting for operator approval.",
                    approvalOwner: "Unassigned",
                    rollbackState: "Rollback not prepared"
                ),
                at: 0
            )
        }
    }

    func sendDraftForApproval() {
        guard !draftPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        conversation.append(
            AIAssistantConversationEntry(
                role: .user,
                title: "Operator draft request",
                body: draftPrompt,
                footnote: "Queued • review requested"
            )
        )
        approvalRequests.insert(
            AIAssistantApprovalRecord(
                title: "Workspace outbound draft",
                route: "External send",
                status: .pending,
                summary: "Draft prepared from the workspace prompt and held for manual approval.",
                approvalOwner: "Unassigned",
                rollbackState: "Rollback not prepared"
            ),
            at: 0
        )
        workspaceStatus = "Approval gate waiting"
        draftPrompt = ""
    }

    func assignApprovalOwner(_ request: AIAssistantApprovalRecord, owner: String) {
        guard let index = approvalRequests.firstIndex(where: { $0.id == request.id }) else { return }
        approvalRequests[index].approvalOwner = owner
        workspaceStatus = "Approval owner assigned"
    }

    func prepareRollback(_ request: AIAssistantApprovalRecord) {
        guard let index = approvalRequests.firstIndex(where: { $0.id == request.id }) else { return }
        approvalRequests[index].rollbackState = "Rollback ready"
        workspaceStatus = "Rollback route prepared"
    }

    func approveRequest(_ request: AIAssistantApprovalRecord) {
        guard let index = approvalRequests.firstIndex(where: { $0.id == request.id }) else { return }
        approvalRequests[index].status = .approved
        workspaceStatus = "Approved for external send"
        conversation.append(
            AIAssistantConversationEntry(
                role: .assistant,
                title: "Approval granted",
                body: "\(approvalRequests[index].title) is now cleared for the outbound route.",
                footnote: "Approval • completed"
            )
        )
    }

    func dispatchApprovedRequest(_ request: AIAssistantApprovalRecord) {
        guard let index = approvalRequests.firstIndex(where: { $0.id == request.id }) else { return }
        approvalRequests[index].status = .sent
        approvalRequests[index].rollbackState = "Rollback ready"
        workspaceStatus = "Outbound route sent safely"
        currentGoal = "Closed the approval chain and logged the outbound send."
        conversation.append(
            AIAssistantConversationEntry(
                role: .assistant,
                title: "Outbound dispatched",
                body: "\(approvalRequests[index].title) left the workspace after guardrail checks and approval.",
                footnote: "Outbound • sent"
            )
        )
        memoryItems.insert(
            AIAssistantMemoryRecord(
                title: "Outbound send pattern",
                detail: "Approved recovery copy shipped after trust checks and preserved the redaction boundary.",
                scope: "Workspace",
                isPinned: false
            ),
            at: 0
        )
    }

    func denyRequest(_ request: AIAssistantApprovalRecord) {
        guard let index = approvalRequests.firstIndex(where: { $0.id == request.id }) else { return }
        approvalRequests[index].status = .denied
        workspaceStatus = "Outbound route denied"
        trustCases.insert(
            AIAssistantTrustCase(
                title: "Denied outbound draft",
                detail: "\(approvalRequests[index].title) was denied and requires a safer rewrite.",
                severity: .medium,
                status: .open,
                assignedOwner: "Trust Lead - Nora",
                legalHoldActive: false,
                recoveryPlan: "Rewrite with stricter redaction and validate rollback language before retry."
            ),
            at: 0
        )
    }

    func rewriteDeniedRequest(_ request: AIAssistantApprovalRecord) {
        guard let index = approvalRequests.firstIndex(where: { $0.id == request.id }) else { return }
        draftPrompt = "Rewrite \(approvalRequests[index].title.lowercased()) with stricter redaction and a shorter customer-safe next step."
        approvalRequests[index].status = .pending
        workspaceStatus = "Denied draft returned to rewrite queue"
        conversation.append(
            AIAssistantConversationEntry(
                role: .assistant,
                title: "Rewrite queued",
                body: "The denied outbound draft is back in review with a tighter redaction and trust-safe route.",
                footnote: "Rewrite • pending"
            )
        )
    }

    func saveMemoryDraft() {
        let trimmed = memoryDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        memoryItems.insert(
            AIAssistantMemoryRecord(
                title: "Operator memory note",
                detail: trimmed,
                scope: "Workspace",
                isPinned: false
            ),
            at: 0
        )
        memoryDraft = ""
        workspaceStatus = "Memory updated"
    }

    func togglePinnedMemory(_ item: AIAssistantMemoryRecord) {
        guard let index = memoryItems.firstIndex(where: { $0.id == item.id }) else { return }
        memoryItems[index].isPinned.toggle()
    }

    func promoteMemoryToGuardrail(_ item: AIAssistantMemoryRecord) {
        guard let index = memoryItems.firstIndex(where: { $0.id == item.id }) else { return }
        memoryItems[index].scope = "Guardrail"
        memoryItems[index].isPinned = true
        workspaceStatus = "Memory rule promoted into guardrail scope"
        guardrailEvents.insert("Promoted \(memoryItems[index].title.lowercased()) into the active guardrail set.", at: 0)
    }

    func quarantineTool(_ tool: AIAssistantToolRecord) {
        guard let index = tools.firstIndex(where: { $0.id == tool.id }) else { return }
        tools[index].status = .quarantined
        workspaceStatus = "Tool quarantined pending trust clearance"
    }

    func restoreTool(_ tool: AIAssistantToolRecord) {
        guard let index = tools.firstIndex(where: { $0.id == tool.id }) else { return }
        tools[index].status = .scoped
        workspaceStatus = "Tool restored under scoped trust controls"
    }

    func toggleTool(_ tool: AIAssistantToolRecord) {
        guard let index = tools.firstIndex(where: { $0.id == tool.id }) else { return }
        switch tools[index].status {
        case .enabled:
            tools[index].status = .scoped
        case .scoped:
            tools[index].status = .enabled
        case .approvalRequired:
            workspaceStatus = "Approval gate unchanged"
        case .quarantined:
            tools[index].status = .scoped
            workspaceStatus = "Tool restored under scoped trust controls"
        }
    }

    func resolveTrustCase(_ trustCase: AIAssistantTrustCase) {
        guard let index = trustCases.firstIndex(where: { $0.id == trustCase.id }) else { return }
        trustCases[index].status = .resolved
        trustCases[index].legalHoldActive = false
        trustCases[index].recoveryPlan = "Case closed. Guardrails and outbound rollback remain documented."
        workspaceStatus = "Trust queue reduced"
    }

    func monitorTrustCase(_ trustCase: AIAssistantTrustCase) {
        guard let index = trustCases.firstIndex(where: { $0.id == trustCase.id }) else { return }
        trustCases[index].status = .monitoring
        trustCases[index].recoveryPlan = "Monitoring after guardrail breach review. Keep outbound route scoped."
        workspaceStatus = "Trust case moved into monitoring"
    }

    func escalateTrustCase(_ trustCase: AIAssistantTrustCase) {
        guard let index = trustCases.firstIndex(where: { $0.id == trustCase.id }) else { return }
        trustCases[index].status = .escalated
        trustCases[index].recoveryPlan = "Escalated for trust lead review and outbound freeze."
        workspaceStatus = "Escalated to operator review"
    }

    func assignTrustOwner(_ trustCase: AIAssistantTrustCase, owner: String) {
        guard let index = trustCases.firstIndex(where: { $0.id == trustCase.id }) else { return }
        trustCases[index].assignedOwner = owner
    }

    func placeLegalHold(_ trustCase: AIAssistantTrustCase) {
        guard let index = trustCases.firstIndex(where: { $0.id == trustCase.id }) else { return }
        trustCases[index].legalHoldActive = true
        trustCases[index].status = .escalated
        trustCases[index].recoveryPlan = "Legal hold active. Preserve prompt, approval, and outbound artifacts before retry."
        workspaceStatus = "Legal hold active"
    }

    func runInteractionProofIfNeeded() {
        guard AIAssistantInteractionProofMode.isEnabled, !interactionProofScheduled else { return }
        interactionProofScheduled = true

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 800_000_000)

            if let preset = presets.first(where: { $0.mode == "Approval required" }) {
                runPreset(preset)
            }

            sendDraftForApproval()

            if let pending = approvalRequests.first(where: { $0.status == .pending }) {
                assignApprovalOwner(pending, owner: "Ops Reviewer - Mira")
                prepareRollback(pending)
                approveRequest(pending)
            }

            if let approved = approvalRequests.first(where: { $0.status == .approved }) {
                dispatchApprovedRequest(approved)
            }

            saveMemoryDraft()

            if let memory = memoryItems.first(where: { $0.scope != "Guardrail" }) {
                promoteMemoryToGuardrail(memory)
            }

            if let tool = tools.first(where: { $0.status == .enabled }) {
                quarantineTool(tool)
                restoreTool(tool)
            }

            if let trustCase = trustCases.first(where: { $0.status == .open }) {
                assignTrustOwner(trustCase, owner: "Trust Lead - Nora")
                monitorTrustCase(trustCase)
                placeLegalHold(trustCase)
                escalateTrustCase(trustCase)
                resolveTrustCase(trustCase)
            }

            AIAssistantInteractionProofMode.write(
                summary: workspaceStatus,
                steps: [
                    "preset-run",
                    "draft-sent-for-approval",
                    "approval-owner-assigned",
                    "rollback-prepared",
                    "approval-granted",
                    "outbound-dispatched",
                    "memory-saved",
                    "memory-promoted-to-guardrail",
                    "tool-quarantined-and-restored",
                    "trust-owner-assigned",
                    "trust-case-monitored-legal-hold-escalated-resolved"
                ]
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantWorkspaceView: View {
    @ObservedObject var store: AIAssistantOperationsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Active Context")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text(store.currentGoal)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text(store.workspaceStatus)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.indigo)

                        HStack(spacing: 12) {
                            AIAssistantMetricChip(title: "Tools", value: "\(store.enabledToolCount)")
                            AIAssistantMetricChip(title: "Rollback", value: "\(store.rollbackReadyCount)")
                            AIAssistantMetricChip(title: "Pending", value: "\(store.pendingApprovalCount)")
                            AIAssistantMetricChip(title: "Legal Holds", value: "\(store.legalHoldCount)")
                        }
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

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Conversation")
                            .font(.title3.weight(.bold))
                        ForEach(store.conversation) { entry in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(entry.title)
                                        .font(.headline)
                                    Spacer()
                                    Text(entry.role == .assistant ? "Assistant" : "Operator")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(entry.role == .assistant ? .indigo : .secondary)
                                }
                                Text(entry.body)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(entry.footnote)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Outbound Draft")
                            .font(.title3.weight(.bold))
                        TextField("Draft request", text: $store.draftPrompt, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3...6)
                        Button("Send For Approval") {
                            store.sendDraftForApproval()
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Approval Queue")
                            .font(.title3.weight(.bold))
                        ForEach(store.approvalRequests) { request in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(request.title)
                                            .font(.headline)
                                        Text(request.route)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(request.status.label)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(request.status.color)
                                }
                                Text(request.summary)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Label(request.approvalOwner, systemImage: "person.text.rectangle.fill")
                                    .font(.caption)
                                Label(request.rollbackState, systemImage: "arrow.uturn.backward.circle.fill")
                                    .font(.caption)
                                if request.status == .pending {
                                    HStack {
                                        Button("Assign Owner") {
                                            store.assignApprovalOwner(request, owner: "Ops Reviewer - Mira")
                                        }
                                        .buttonStyle(.bordered)
                                        Button("Prep Rollback") {
                                            store.prepareRollback(request)
                                        }
                                        .buttonStyle(.bordered)
                                        Button("Approve") {
                                            store.approveRequest(request)
                                        }
                                        .buttonStyle(.borderedProminent)
                                        Button("Deny") {
                                            store.denyRequest(request)
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                } else if request.status == .approved {
                                    Button("Send Outbound") {
                                        store.dispatchApprovedRequest(request)
                                    }
                                    .buttonStyle(.borderedProminent)
                                } else if request.status == .denied {
                                    Button("Rewrite") {
                                        store.rewriteDeniedRequest(request)
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
            .navigationTitle("AI Assistant")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantPresetsView: View {
    @ObservedObject var store: AIAssistantOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Prompt Presets") {
                    ForEach(store.presets) { preset in
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
                            Text(preset.lastRunStatus)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                            Button("Run Preset") {
                                store.runPreset(preset)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Presets")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantMemoryView: View {
    @ObservedObject var store: AIAssistantOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Saved Memory") {
                    ForEach(store.memoryItems) { item in
                        VStack(alignment: .leading, spacing: 8) {
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
                            Button(item.isPinned ? "Unpin" : "Pin") {
                                store.togglePinnedMemory(item)
                            }
                            .buttonStyle(.bordered)
                            if item.scope != "Guardrail" {
                                Button("Promote to Guardrail") {
                                    store.promoteMemoryToGuardrail(item)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Capture New Memory") {
                    TextField("New memory rule", text: $store.memoryDraft, axis: .vertical)
                        .lineLimit(2...4)
                    Button("Save Memory") {
                        store.saveMemoryDraft()
                    }
                }
            }
            .navigationTitle("Memory")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantToolsView: View {
    @ObservedObject var store: AIAssistantOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Enabled Tools") {
                    ForEach(store.tools) { tool in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(tool.name)
                                Spacer()
                                Text(tool.status.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(tool.status.color)
                            }
                            Text(tool.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            ForEach(tool.boundaries, id: \.self) { boundary in
                                Label(boundary, systemImage: "shield.lefthalf.filled")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            if tool.status == .quarantined {
                                Button("Restore Scoped Tool") {
                                    store.restoreTool(tool)
                                }
                                .buttonStyle(.borderedProminent)
                            } else if tool.status != .approvalRequired {
                                Button(tool.status == .enabled ? "Scope Tool" : "Enable Fully") {
                                    store.toggleTool(tool)
                                }
                                .buttonStyle(.bordered)
                                if tool.status == .enabled {
                                    Button("Quarantine Tool") {
                                        store.quarantineTool(tool)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Tools")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct AIAssistantTrustView: View {
    @ObservedObject var store: AIAssistantOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Trust Surface") {
                    LabeledContent("Pending approvals", value: "\(store.pendingApprovalCount)")
                    LabeledContent("Pinned memory", value: "\(store.pinnedMemoryCount)")
                    LabeledContent("Open trust cases", value: "\(store.openTrustCaseCount)")
                    LabeledContent("Legal holds", value: "\(store.legalHoldCount)")
                }

                Section("Trust Cases") {
                    ForEach(store.trustCases) { trustCase in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(trustCase.title)
                                Spacer()
                                Text(trustCase.status.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(trustCase.status.color)
                            }
                            Text(trustCase.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(trustCase.severity.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(trustCase.severity.color)
                            Label(trustCase.assignedOwner, systemImage: "person.text.rectangle.fill")
                                .font(.caption)
                            Label(trustCase.legalHoldActive ? "Legal hold active" : "Legal hold clear", systemImage: "lock.doc.fill")
                                .font(.caption)
                            Text(trustCase.recoveryPlan)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            if trustCase.status == .open || trustCase.status == .monitoring {
                                HStack {
                                    Button("Assign Owner") {
                                        store.assignTrustOwner(trustCase, owner: "Trust Lead - Nora")
                                    }
                                    .buttonStyle(.bordered)
                                    Button("Resolve") {
                                        store.resolveTrustCase(trustCase)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    if trustCase.status == .open {
                                        Button("Monitor") {
                                            store.monitorTrustCase(trustCase)
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                    Button("Escalate") {
                                        store.escalateTrustCase(trustCase)
                                    }
                                    .buttonStyle(.bordered)
                                    Button("Legal Hold") {
                                        store.placeLegalHold(trustCase)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            } else if trustCase.status == .escalated {
                                HStack {
                                    Button("Move To Monitoring") {
                                        store.monitorTrustCase(trustCase)
                                    }
                                    .buttonStyle(.bordered)
                                    Button("Resolve") {
                                        store.resolveTrustCase(trustCase)
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Guardrails") {
                    ForEach(store.guardrailEvents, id: \.self) { event in
                        Label(event, systemImage: "checkmark.shield")
                    }
                }
            }
            .navigationTitle("Trust")
        }
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

enum AIAssistantConversationRole: Hashable, Sendable {
    case user
    case assistant
}

struct AIAssistantConversationEntry: Identifiable, Hashable, Sendable {
    let id = UUID()
    let role: AIAssistantConversationRole
    let title: String
    let body: String
    let footnote: String
}

struct AIAssistantPresetRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let mode: String
    let summary: String
    let steps: [String]
    var lastRunStatus: String
}

struct AIAssistantMemoryRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let detail: String
    var scope: String
    var isPinned: Bool
}

enum AIAssistantToolStatus: String, Hashable, Sendable {
    case enabled
    case approvalRequired
    case scoped
    case quarantined

    var label: String {
        switch self {
        case .enabled:
            return "Enabled"
        case .approvalRequired:
            return "Approval gate"
        case .scoped:
            return "Scoped"
        case .quarantined:
            return "Quarantined"
        }
    }

    var color: Color {
        switch self {
        case .enabled:
            return .green
        case .approvalRequired:
            return .orange
        case .scoped:
            return .blue
        case .quarantined:
            return .red
        }
    }
}

struct AIAssistantToolRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let summary: String
    var status: AIAssistantToolStatus
    let boundaries: [String]
}

enum AIAssistantApprovalStatus: Hashable, Sendable {
    case pending
    case approved
    case denied
    case sent

    var label: String {
        switch self {
        case .pending:
            return "Pending"
        case .approved:
            return "Approved"
        case .denied:
            return "Denied"
        case .sent:
            return "Sent"
        }
    }

    var color: Color {
        switch self {
        case .pending:
            return .orange
        case .approved:
            return .green
        case .denied:
            return .red
        case .sent:
            return .blue
        }
    }
}

struct AIAssistantApprovalRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let route: String
    var status: AIAssistantApprovalStatus
    let summary: String
    var approvalOwner: String
    var rollbackState: String
}

enum AIAssistantTrustSeverity: Hashable, Sendable {
    case medium
    case high

    var label: String {
        switch self {
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }

    var color: Color {
        switch self {
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
}

enum AIAssistantTrustStatus: Hashable, Sendable {
    case open
    case monitoring
    case escalated
    case resolved

    var label: String {
        switch self {
        case .open:
            return "Open"
        case .monitoring:
            return "Monitoring"
        case .escalated:
            return "Escalated"
        case .resolved:
            return "Resolved"
        }
    }

    var color: Color {
        switch self {
        case .open:
            return .red
        case .monitoring:
            return .orange
        case .escalated:
            return .indigo
        case .resolved:
            return .green
        }
    }
}

struct AIAssistantTrustCase: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let detail: String
    let severity: AIAssistantTrustSeverity
    var status: AIAssistantTrustStatus
    var assignedOwner: String
    var legalHoldActive: Bool
    var recoveryPlan: String
}
