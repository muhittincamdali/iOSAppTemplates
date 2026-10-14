import Foundation
import Testing
@testable import ProductivityApp

@MainActor
@Suite("ProductivityOperationsStore")
struct ProductivityOperationsStoreTests {
    private func project(_ name: String, in store: ProductivityOperationsStore) throws -> ProductivityProjectRecord {
        try #require(store.projects.first { $0.name == name })
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

    @Test func routingTaskToProjectPlansItAndAddsProgress() throws {
        let store = ProductivityOperationsStore()
        let task = try #require(store.inboxTasks.first { $0.status == .captured })
        let target = try project("Release Ops", in: store)

        store.moveTaskToProject(task.id, projectID: target.id)

        let routed = try #require(store.inboxTasks.first { $0.id == task.id })
        #expect(routed.project == "Release Ops")
        #expect(routed.status == .planned)
        #expect(abs(try project("Release Ops", in: store).progress - (target.progress + 0.08)) < 0.0001)
    }

    @Test func completingTaskMarksProjectHealthyAboveThreshold() throws {
        let store = ProductivityOperationsStore()
        let task = try #require(store.inboxTasks.first { $0.project == "Release Ops" })

        store.completeTask(task.id)

        #expect(store.completedCount == 15)
        #expect(!store.activeTasks.contains { $0.id == task.id })
        #expect(try project("Release Ops", in: store).status == "Healthy", "0.72 + 0.12 crosses the 0.75 threshold")
    }

    @Test func completingTaskBelowThresholdKeepsProjectStatus() throws {
        let store = ProductivityOperationsStore()
        let task = try #require(store.inboxTasks.first { $0.project == "Roadmap" })

        store.completeTask(task.id)

        #expect(try project("Roadmap", in: store).status == "Needs Focus")
    }

    @Test func projectProgressIsCappedAtOne() throws {
        let store = ProductivityOperationsStore()
        let task = store.inboxTasks[0]
        let target = try project("Growth Experiments", in: store)

        for _ in 0..<5 { store.moveTaskToProject(task.id, projectID: target.id) }

        #expect(try project("Growth Experiments", in: store).progress == 1.0)
    }

    @Test func focusBlockLifecycle() throws {
        let store = ProductivityOperationsStore()
        let block = try #require(store.focusBlocks.first { $0.status != .active && $0.status != .completed })

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
