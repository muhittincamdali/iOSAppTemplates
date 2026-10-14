import Foundation
import Testing
@testable import AIAssistantApp

@MainActor
@Suite("AIAssistantOperationsStore")
struct AIAssistantOperationsStoreTests {
    @Test func seededCountersMatchSampleData() {
        let store = AIAssistantOperationsStore()

        #expect(store.enabledToolCount == 2)
        #expect(store.pinnedMemoryCount == 2)
        #expect(store.pendingApprovalCount == 1)
        #expect(store.openTrustCaseCount == 2)
        #expect(store.legalHoldCount == 0)
    }

    @Test func approvalPresetQueuesAnOutboundDraft() throws {
        let store = AIAssistantOperationsStore()
        let preset = try #require(store.presets.first { $0.mode == "Approval required" })

        store.runPreset(preset)

        #expect(store.presets.first { $0.id == preset.id }?.lastRunStatus == "Queued for approval")
        #expect(store.approvalRequests[0].title == "Customer Recovery outbound draft")
        #expect(store.pendingApprovalCount == 2)
    }

    @Test func localPresetCompletesWithoutApproval() throws {
        let store = AIAssistantOperationsStore()
        let preset = try #require(store.presets.first { $0.mode == "Local-first" })

        store.runPreset(preset)

        #expect(store.presets.first { $0.id == preset.id }?.lastRunStatus == "Completed locally")
        #expect(store.pendingApprovalCount == 1)
    }

    @Test func sendingDraftClearsPromptAndAddsPendingRequest() {
        let store = AIAssistantOperationsStore()

        store.sendDraftForApproval()

        #expect(store.draftPrompt.isEmpty)
        #expect(store.approvalRequests[0].status == .pending)
        #expect(store.conversation.last?.role == .user)
    }

    @Test func blankDraftIsNotSent() {
        let store = AIAssistantOperationsStore()
        store.draftPrompt = "  \n"
        let requests = store.approvalRequests.count

        store.sendDraftForApproval()

        #expect(store.approvalRequests.count == requests)
    }

    @Test func approvedRequestDispatchRecordsMemoryAndRollback() throws {
        let store = AIAssistantOperationsStore()
        let request = try #require(store.approvalRequests.first { $0.status == .pending })
        let memories = store.memoryItems.count

        store.approveRequest(request)
        store.dispatchApprovedRequest(request)

        let sent = try #require(store.approvalRequests.first { $0.id == request.id })
        #expect(sent.status == .sent)
        #expect(sent.rollbackState == "Rollback ready")
        #expect(store.memoryItems.count == memories + 1)
        #expect(store.pendingApprovalCount == 0)
    }

    @Test func denyingOpensTrustCaseAndRewriteReturnsToPending() throws {
        let store = AIAssistantOperationsStore()
        let request = try #require(store.approvalRequests.first { $0.status == .pending })
        let trustCases = store.trustCases.count

        store.denyRequest(request)
        #expect(store.approvalRequests.first { $0.id == request.id }?.status == .denied)
        #expect(store.trustCases.count == trustCases + 1)

        store.rewriteDeniedRequest(request)
        #expect(store.approvalRequests.first { $0.id == request.id }?.status == .pending)
        #expect(store.draftPrompt.hasPrefix("Rewrite customer delay message"))
    }

    @Test func memoryDraftIsTrimmedAndBlankDraftIgnored() {
        let store = AIAssistantOperationsStore()
        store.memoryDraft = "  Keep summaries short.  "

        store.saveMemoryDraft()
        #expect(store.memoryItems[0].detail == "Keep summaries short.")
        #expect(store.memoryDraft.isEmpty)

        let count = store.memoryItems.count
        store.saveMemoryDraft()
        #expect(store.memoryItems.count == count)
    }

    @Test func promotingMemoryPinsItAsGuardrail() throws {
        let store = AIAssistantOperationsStore()
        let item = try #require(store.memoryItems.first { !$0.isPinned })

        store.promoteMemoryToGuardrail(item)

        let promoted = try #require(store.memoryItems.first { $0.id == item.id })
        #expect(promoted.scope == "Guardrail")
        #expect(promoted.isPinned)
        #expect(store.guardrailEvents[0].contains("escalation threshold"))
    }

    @Test func toggleToolCyclesEnabledAndScopedButNotApprovalGate() throws {
        let store = AIAssistantOperationsStore()
        let enabled = try #require(store.tools.first { $0.status == .enabled })
        let gated = try #require(store.tools.first { $0.status == .approvalRequired })

        store.toggleTool(enabled)
        #expect(store.tools.first { $0.id == enabled.id }?.status == .scoped)
        store.toggleTool(enabled)
        #expect(store.tools.first { $0.id == enabled.id }?.status == .enabled)

        store.toggleTool(gated)
        #expect(store.tools.first { $0.id == gated.id }?.status == .approvalRequired)
    }

    @Test func quarantinedToolRestoresToScoped() {
        let store = AIAssistantOperationsStore()
        let tool = store.tools[0]

        store.quarantineTool(tool)
        #expect(store.enabledToolCount == 1)
        store.toggleTool(tool)
        #expect(store.tools[0].status == .scoped)
    }

    @Test func legalHoldEscalatesAndResolveClearsIt() {
        let store = AIAssistantOperationsStore()
        let trustCase = store.trustCases[0]

        store.placeLegalHold(trustCase)
        #expect(store.legalHoldCount == 1)
        #expect(store.trustCases[0].status == .escalated)

        store.resolveTrustCase(trustCase)
        #expect(store.legalHoldCount == 0)
        #expect(store.openTrustCaseCount == 1)
    }
}
