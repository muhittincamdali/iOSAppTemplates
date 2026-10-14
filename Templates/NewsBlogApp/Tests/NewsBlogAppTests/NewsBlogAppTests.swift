import Foundation
import Testing
@testable import NewsBlogApp

@MainActor
@Suite("NewsBlogOperationsStore")
struct NewsBlogOperationsStoreTests {
    @Test func seededCountsMatchSampleData() {
        let store = NewsBlogOperationsStore()

        #expect(store.publishedCount == 3)
        #expect(store.savedCount == 1)
    }

    @Test func savingAndUnsavingKeepsSavedReadsInSync() throws {
        let store = NewsBlogOperationsStore()
        let unsaved = try #require(store.trendingStories.first { !$0.isSaved })

        store.toggleSave(unsaved)
        #expect(store.savedCount == 2)
        #expect(store.savedReads[0].id == unsaved.id)

        store.toggleSave(unsaved)
        #expect(store.savedCount == 1)
        #expect(!store.savedReads.contains { $0.id == unsaved.id })
    }

    @Test func savingTheLeadStory() {
        let store = NewsBlogOperationsStore()

        store.toggleSave(store.leadStory)

        #expect(store.leadStory.isSaved)
        #expect(store.savedReads[0].id == store.leadStory.id)
    }

    @Test func publishingDraftStoryIncreasesPublishedCount() throws {
        let store = NewsBlogOperationsStore()
        let draft = try #require(store.trendingStories.first { !$0.isPublished })

        store.publishArticle(draft)

        #expect(store.publishedCount == 4)
    }

    @Test func promotingSwapsLeadAndPublishesNewLead() throws {
        let store = NewsBlogOperationsStore()
        let previousLead = store.leadStory
        let draft = try #require(store.trendingStories.first { !$0.isPublished })

        store.promoteToLead(draft)

        #expect(store.leadStory.id == draft.id)
        #expect(store.leadStory.isPublished)
        #expect(store.trendingStories.contains { $0.id == previousLead.id })
        #expect(store.publishedCount == 4)
    }

    @Test func promotingUnknownArticleKeepsLead() {
        let store = NewsBlogOperationsStore()
        let lead = store.leadStory

        store.promoteToLead(lead)

        #expect(store.leadStory.id == lead.id)
    }

    @Test func digestFreezeAndPublish() {
        let store = NewsBlogOperationsStore()

        store.freezeDigest()
        #expect(store.digestFrozen)

        store.publishDigest()
        #expect(!store.digestFrozen)
        #expect(store.digestStatus.hasPrefix("Digest locked and queued"))
    }

    @Test func digestInclusionTogglesForLeadAndTrending() {
        let store = NewsBlogOperationsStore()
        let story = store.trendingStories[0]

        store.toggleDigestInclusion(store.leadStory)
        store.toggleDigestInclusion(story)

        #expect(!store.leadStory.isInDigest)
        #expect(store.trendingStories[0].isInDigest == !story.isInDigest)
    }

    @Test func moderationItemsCanBeResolvedEscalatedAndArchived() {
        let store = NewsBlogOperationsStore()
        let first = store.moderationQueue[0]
        let second = store.moderationQueue[1]

        store.resolveModeration(first)
        store.escalateModeration(second)
        #expect(store.moderationQueue[0].status == .resolved)
        #expect(store.moderationQueue[1].status == .escalated)

        store.archiveModeration(first)
        #expect(store.moderationQueue.map(\.id) == [second.id])
    }
}
