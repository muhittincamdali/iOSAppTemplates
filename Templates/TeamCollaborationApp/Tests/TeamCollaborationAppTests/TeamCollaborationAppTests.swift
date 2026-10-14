import Foundation
import Testing
@testable import TeamCollaborationApp

@MainActor
@Suite("TeamCollaborationOperationsStore")
struct TeamCollaborationOperationsStoreTests {
    @Test func taskMovesFromBlockedThroughReviewToDone() {
        let store = TeamCollaborationOperationsStore()
        let task = store.tasks[0]

        store.unblockTask(task.id)
        #expect(store.tasks[0].status == .review)
        #expect(store.blockedCount == 1)
        #expect(store.reviewQueue == 6)

        store.completeTask(task.id)
        #expect(store.tasks[0].status == .handoff)
        #expect(store.reviewQueue == 5)

        store.closeTask(task.id)
        #expect(store.tasks[0].status == .done)
        #expect(store.completedShipments == 13)
        #expect(!store.activeTasks.contains { $0.id == task.id })
    }

    @Test func countersNeverGoNegative() {
        let store = TeamCollaborationOperationsStore(blockedCount: 0, reviewQueue: 0)
        let task = store.tasks[0]

        store.startTask(task.id)
        store.completeTask(task.id)
        store.resolveStandup(store.standups[0].id)

        #expect(store.blockedCount == 0)
        #expect(store.reviewQueue == 0)
    }

    @Test func decisionLeavesPendingListOnlyWhenPublished() {
        let store = TeamCollaborationOperationsStore()
        let decision = store.pendingDecisions[0]
        let pending = store.pendingDecisions.count

        store.approveDecision(decision.id)
        store.alignDecision(decision.id)
        #expect(store.pendingDecisions.count == pending)

        store.publishDecision(decision.id)
        #expect(store.pendingDecisions.count == pending - 1)
        #expect(store.decisions.first { $0.id == decision.id }?.status == .published)
    }

    @Test func handoffLifecycleEndsInArchive() {
        let store = TeamCollaborationOperationsStore()
        let handoff = store.liveHandoffs[0]
        let live = store.liveHandoffs.count
        let shipments = store.completedShipments

        store.queueHandoff(handoff.id)
        store.acceptHandoff(handoff.id)
        store.completeHandoff(handoff.id)
        #expect(store.handoffs.first { $0.id == handoff.id }?.status == .verified)
        #expect(store.liveHandoffs.count == live)

        store.archiveHandoff(handoff.id)
        #expect(store.liveHandoffs.count == live - 1)
        #expect(store.completedShipments == shipments + 1)
    }

    @Test func resolvingStandupReducesBlockers() {
        let store = TeamCollaborationOperationsStore()
        let standup = store.standups[0]

        store.resolveStandup(standup.id)

        #expect(store.standups[0].status == .resolved)
        #expect(store.blockedCount == 1)
        #expect(store.operatorHeadline.contains(standup.owner))
    }

    @Test func unknownIdentifiersChangeNothing() {
        let store = TeamCollaborationOperationsStore()
        let headline = store.operatorHeadline

        store.startTask(UUID())
        store.publishDecision(UUID())
        store.archiveHandoff(UUID())

        #expect(store.operatorHeadline == headline)
        #expect(store.completedShipments == 12)
        #expect(store.blockedCount == 2)
    }
}
