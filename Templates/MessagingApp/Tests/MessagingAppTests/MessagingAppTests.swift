import Foundation
import Testing
@testable import MessagingApp

@MainActor
@Suite("MessagingCommandCenterStore")
struct MessagingCommandCenterStoreTests {
    private func thread(_ title: String, in store: MessagingCommandCenterStore) -> MessagingThreadRecord {
        store.threads.first { $0.title == title }!
    }

    @Test func seededCountersMatchSampleData() {
        let store = MessagingCommandCenterStore()

        #expect(store.unreadCount == 19)
        #expect(store.activeRoomRequests == 7)
        #expect(store.priorityThread?.title == "Support Escalations")
        #expect(store.controlCenterHeadline.hasPrefix("Inbox pressure"))
    }

    @Test func filtersSelectMatchingThreads() {
        let store = MessagingCommandCenterStore()

        store.selectedFilter = .support
        #expect(store.filteredThreads.map(\.title) == ["Support Escalations"])
        store.selectedFilter = .community
        #expect(store.filteredThreads.map(\.title) == ["Creator Community"])
        store.selectedFilter = .escalated
        #expect(store.filteredThreads.isEmpty)
    }

    @Test func sendingReplyClearsUnreadAndDraft() {
        let store = MessagingCommandCenterStore()
        let support = thread("Support Escalations", in: store)
        let messages = support.messages.count

        store.updateDraft(support.id, text: "  Refund approved.  ")
        store.sendReply(to: support.id)

        let updated = thread("Support Escalations", in: store)
        #expect(updated.messages.count == messages + 1)
        #expect(updated.latestMessage == "Refund approved.")
        #expect(updated.unreadCount == 0)
        #expect(updated.status == .awaitingCustomer)
        #expect(updated.draftReply.isEmpty)
        #expect(store.containedThreadCount == 1)
    }

    @Test func blankReplyIsNotSent() {
        let store = MessagingCommandCenterStore()
        let support = thread("Support Escalations", in: store)

        store.updateDraft(support.id, text: " \n ")
        store.sendReply(to: support.id)

        #expect(thread("Support Escalations", in: store).messages.count == support.messages.count)
        #expect(thread("Support Escalations", in: store).unreadCount == support.unreadCount)
    }

    @Test func freezingThenReleasingContainment() {
        let store = MessagingCommandCenterStore()
        let community = thread("Creator Community", in: store)

        store.freezeThread(community.id)
        #expect(thread("Creator Community", in: store).status == .escalated)
        #expect(thread("Creator Community", in: store).isPinned)
        store.selectedFilter = .escalated
        #expect(store.filteredThreads.map(\.title) == ["Creator Community"])

        store.releaseThreadContainment(community.id)
        #expect(thread("Creator Community", in: store).status == .monitoring)
    }

    @Test func roomUpdateIsBroadcastToLinkedThread() {
        let store = MessagingCommandCenterStore()
        let room = store.rooms[0]

        store.postRoomUpdate(room.id)

        #expect(store.rooms[0].pendingRequests == room.pendingRequests - 1)
        #expect(store.rooms[0].announcements.first == room.operatorDraft)
        #expect(store.rooms[0].operatorDraft.isEmpty)
        #expect(thread("Creator Community", in: store).latestMessage == room.operatorDraft)
    }

    @Test func emptyRoomDraftPostsNothing() {
        let store = MessagingCommandCenterStore()
        let room = store.rooms[0]
        store.postRoomUpdate(room.id)
        let announcements = store.rooms[0].announcements.count

        store.postRoomUpdate(room.id)

        #expect(store.rooms[0].announcements.count == announcements)
    }

    @Test func moderatorAssignmentNeverMakesRequestsNegative() {
        let store = MessagingCommandCenterStore()
        let room = store.rooms.first { $0.name == "Launch War Room" }!

        store.assignModerator(room.id)
        store.assignModerator(room.id)

        #expect(store.rooms.first { $0.id == room.id }?.pendingRequests == 0)
    }

    @Test func roomContainmentCanBeCleared() {
        let store = MessagingCommandCenterStore()
        let room = store.rooms[0]

        store.enableSlowMode(room.id)
        store.lockRoomInvites(room.id)
        #expect(store.rooms[0].slowModeEnabled && store.rooms[0].inviteGateLocked)

        store.clearRoomContainment(room.id)
        #expect(!store.rooms[0].slowModeEnabled && !store.rooms[0].inviteGateLocked)
    }

    @Test func legalHoldEscalatesLinkedThreadAndResolveRestoresIt() {
        let store = MessagingCommandCenterStore()
        let safetyCase = store.safetyCases.first { $0.threadTitle == "Support Escalations" }!

        store.placeLegalHold(safetyCase.id)
        #expect(store.legalHoldCount == 1)
        #expect(store.escalatedCaseCount == 1)
        #expect(thread("Support Escalations", in: store).status == .escalated)
        #expect(store.controlCenterHeadline.hasPrefix("1 trust escalations"))

        store.resolveSafetyCase(safetyCase.id)
        #expect(store.legalHoldCount == 0)
        #expect(store.resolvedCaseCount == 1)
        #expect(thread("Support Escalations", in: store).status == .monitoring)
    }

    @Test func evidenceExportAndLeadAssignment() {
        let store = MessagingCommandCenterStore()
        let safetyCase = store.safetyCases[0]

        store.exportEvidence(safetyCase.id)
        store.assignSafetyLead(safetyCase.id, lead: "Nora")

        #expect(store.safetyCases[0].evidenceExported)
        #expect(store.safetyCases[0].assignedLead == "Nora")
    }
}
