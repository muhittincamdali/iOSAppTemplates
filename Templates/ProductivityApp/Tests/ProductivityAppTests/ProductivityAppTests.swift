import Foundation
import Testing
@testable import ProductivityApp

@MainActor
@Suite("ProductivityOperationsStore")
struct ProductivityOperationsStoreTests {
    private func project(_ name: String, in store: ProductivityOperationsStore) -> ProductivityProjectRecord {
        store.projects.first { $0.name == name }!
    }

    @Test func capturedTaskIsTrimmedAndQueuedFirst() {
        let store = ProductivityOperationsStore()
        store.captureDraft = "  Draft release notes  "

        store.captureTask()

        #expect(store.inboxTasks[0].title == "Draft release notes")
        #expect(store.inboxTasks[0].status == .captured)
        #expect(store.inboxTasks[0].project == "Inbox")
        #expect(store.captureDraft.isEmpty)
    }

    @Test func blankCaptureIsIgnored() {
        let store = ProductivityOperationsStore()
        let count = store.inboxTasks.count
        store.captureDraft = "   "

        store.captureTask()

        #expect(store.inboxTasks.count == count)
    }

    @Test func routingTaskToProjectPlansItAndAddsProgress() {
        let store = ProductivityOperationsStore()
        let task = store.inboxTasks.first { $0.status == .captured }!
        let target = project("Release Ops", in: store)

        store.moveTaskToProject(task.id, projectID: target.id)

        let routed = store.inboxTasks.first { $0.id == task.id }!
        #expect(routed.project == "Release Ops")
        #expect(routed.status == .planned)
        #expect(abs(project("Release Ops", in: store).progress - (target.progress + 0.08)) < 0.0001)
    }

    @Test func completingTaskMarksProjectHealthyAboveThreshold() {
        let store = ProductivityOperationsStore()
        let task = store.inboxTasks.first { $0.project == "Release Ops" }!

        store.completeTask(task.id)

        #expect(store.completedCount == 15)
        #expect(!store.activeTasks.contains { $0.id == task.id })
        #expect(project("Release Ops", in: store).status == "Healthy", "0.72 + 0.12 crosses the 0.75 threshold")
    }

    @Test func completingTaskBelowThresholdKeepsProjectStatus() {
        let store = ProductivityOperationsStore()
        let task = store.inboxTasks.first { $0.project == "Template Portfolio" }!

        store.completeTask(task.id)

        #expect(project("Template Portfolio", in: store).status == "Needs Focus")
    }

    @Test func projectProgressIsCappedAtOne() {
        let store = ProductivityOperationsStore()
        let task = store.inboxTasks[0]
        let target = project("Proof System", in: store)

        for _ in 0..<5 { store.moveTaskToProject(task.id, projectID: target.id) }

        #expect(project("Proof System", in: store).progress == 1.0)
    }

    @Test func focusBlockLifecycle() {
        let store = ProductivityOperationsStore()
        let block = store.focusBlocks.first { $0.status != .active && $0.status != .completed }!

        store.startFocus(block.id)
        #expect(store.focusBlocks.first { $0.id == block.id }?.status == .active)

        store.completeFocus(block.id)
        #expect(store.focusBlocks.first { $0.id == block.id }?.status == .completed)
    }

    @Test func resolvingRiskAndUnknownIDs() {
        let store = ProductivityOperationsStore()
        let risk = store.reviewRisks[0]
        let headline = store.operatorHeadline

        store.completeTask(UUID())
        store.prioritizeTask(UUID())
        #expect(store.operatorHeadline == headline)

        store.resolveRisk(risk.id)
        #expect(store.reviewRisks[0].status == .resolved)
    }
}
