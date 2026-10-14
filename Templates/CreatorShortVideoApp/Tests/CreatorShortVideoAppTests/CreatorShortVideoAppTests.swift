import Foundation
import Testing
@testable import CreatorShortVideoApp

@MainActor
@Suite("CreatorShortVideoStudioStore")
struct CreatorShortVideoStudioStoreTests {
    @Test func composerDraftIsQueuedAtTheTopAndComposerResets() {
        let store = CreatorShortVideoStudioStore()
        let count = store.drafts.count
        store.composer.title = "  Morning routine  "
        store.selectedDraftFilter = .ready

        store.queueComposerDraft()

        #expect(store.drafts.count == count + 1)
        #expect(store.drafts[0].title == "Morning routine")
        #expect(store.drafts[0].status == .editing)
        #expect(store.drafts[0].brandReviewState == .notNeeded, "no sponsor means no brand review")
        #expect(store.composer.title == ShortVideoComposerState.sample.title)
        #expect(store.selectedDraftFilter == .all)
    }

    @Test func composerDraftNeedsTitleHookAndCallToAction() {
        let store = CreatorShortVideoStudioStore()
        let count = store.drafts.count
        store.composer.callToAction = "   "

        store.queueComposerDraft()

        #expect(store.drafts.count == count)
    }

    @Test func sponsoredDraftWaitsForBrandReview() {
        let store = CreatorShortVideoStudioStore()
        store.composer.sponsorName = "Acme Audio"
        store.composer.requiresLegalReview = true

        store.queueComposerDraft()

        #expect(store.drafts[0].brandReviewState == .pending)
        #expect(store.drafts[0].legalReviewState == .pending)
    }

    @Test func draftBecomesReadyOnlyWhenTasksAndReviewsAreDone() throws {
        let store = CreatorShortVideoStudioStore()
        let draft = try #require(store.drafts.first { $0.title == "Sponsor-safe desk setup" })
        let openTask = try #require(draft.tasks.first { !$0.isComplete })

        store.toggleTask(for: draft.id, taskID: openTask.id)
        #expect(store.drafts.first { $0.id == draft.id }?.status != .readyToSchedule, "reviews still pending")

        store.approveBrandReview(draft.id)
        #expect(store.drafts.first { $0.id == draft.id }?.status != .readyToSchedule)

        store.approveLegalReview(draft.id)
        #expect(store.drafts.first { $0.id == draft.id }?.status == .readyToSchedule)
    }

    @Test func reopeningATaskMovesReadyDraftBackToEditing() throws {
        let store = CreatorShortVideoStudioStore()
        let ready = try #require(store.drafts.first { $0.status == .readyToSchedule })

        store.toggleTask(for: ready.id, taskID: ready.tasks[0].id)

        #expect(store.drafts.first { $0.id == ready.id }?.status == .editing)
    }

    @Test func filterMatchesDraftStatus() {
        let store = CreatorShortVideoStudioStore()

        store.selectedDraftFilter = .ready
        #expect(store.filteredDrafts.allSatisfy { $0.status == .readyToSchedule || $0.status == .scheduled })
        store.selectedDraftFilter = .review
        #expect(store.filteredDrafts.allSatisfy { $0.status == .inReview })
        store.selectedDraftFilter = .all
        #expect(store.filteredDrafts.count == store.drafts.count)
    }

    @Test func publishingMovesDraftToPublishedClips() {
        let store = CreatorShortVideoStudioStore()
        let draft = store.drafts[0]
        let publishedCount = store.publishedClips.count

        store.schedule(draft.id)
        store.publish(draft.id)

        #expect(!store.drafts.contains { $0.id == draft.id })
        #expect(store.publishedClips.count == publishedCount + 1)
        #expect(store.publishedClips[0].title == draft.title)
    }

    @Test func recoveryExperimentLaunchesOncePerClip() {
        let store = CreatorShortVideoStudioStore()
        let clip = store.publishedClips[0]
        let experiments = store.experiments.count

        store.launchRecoveryExperiment(for: clip.id)
        store.launchRecoveryExperiment(for: clip.id)

        #expect(store.experiments.count == experiments + 1)
        #expect(store.publishedClips[0].hasRecoveryExperiment)
    }

    @Test func closingExperimentReducesActiveCount() throws {
        let store = CreatorShortVideoStudioStore()
        let active = store.activeExperimentCount
        let open = try #require(store.experiments.first { !$0.isClosed })

        store.closeExperiment(open.id)

        #expect(store.activeExperimentCount == active - 1)
    }

    @Test func resolvingHighRiskCasesClearsReleaseBlocker() {
        let store = CreatorShortVideoStudioStore()
        for moderationCase in store.moderationCases where moderationCase.severity == .high {
            store.resolveModerationCase(moderationCase.id)
        }

        #expect(store.highRiskCases == 0)
        #expect(!store.releaseHeadline.contains("high-risk"))
    }
}
