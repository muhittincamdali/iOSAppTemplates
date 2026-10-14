import Foundation
import Testing
@testable import MusicPodcastApp

@MainActor
@Suite("MusicPodcastOperationsStore")
struct MusicPodcastOperationsStoreTests {
    @Test func progressAdvancesInStepsAndIsCappedAtOne() {
        let store = MusicPodcastOperationsStore()
        let episode = store.nowPlaying

        for _ in 0..<5 { store.advanceProgress(episode) }

        #expect(store.nowPlaying.progress == 1)
    }

    @Test func likeTogglesTheMatchingCopy() {
        let store = MusicPodcastOperationsStore()
        let pick = store.freshPicks[0]

        store.toggleLike(store.nowPlaying)
        store.toggleLike(pick)

        #expect(store.nowPlaying.isLiked == false, "sample episode starts liked")
        #expect(store.freshPicks[0].isLiked == !pick.isLiked)
    }

    @Test func queuedEpisodeGoesToTopAndPlayingRemovesIt() {
        let store = MusicPodcastOperationsStore()
        let pick = store.freshPicks[0]
        let queueCount = store.queue.count

        store.queueEpisode(pick)
        #expect(store.queue.count == queueCount + 1)
        #expect(store.queue[0].episode.id == pick.id)

        store.playQueueItem(store.queue[0])
        #expect(store.nowPlaying.id == pick.id)
        #expect(store.queue.count == queueCount)
    }

    @Test func movingQueueItemForwardSwapsWithPrevious() {
        let store = MusicPodcastOperationsStore()
        let first = store.queue[0]
        let second = store.queue[1]

        store.moveQueueItemForward(second)
        #expect(store.queue.map(\.id) == [second.id, first.id])

        store.moveQueueItemForward(second)
        #expect(store.queue.map(\.id) == [second.id, first.id], "the head of the queue cannot move further")
    }

    @Test func downloadToggleAddsThenRemoves() {
        let store = MusicPodcastOperationsStore()
        let pick = store.freshPicks[0]
        let downloads = store.downloads.count

        store.toggleDownload(pick)
        #expect(store.downloads.count == downloads + 1)
        #expect(store.downloads[0].status == .ready)

        store.toggleDownload(pick)
        #expect(store.downloads.count == downloads)
    }

    @Test func pinningNowPlayingCreatesPinnedDownloadOnce() {
        let store = MusicPodcastOperationsStore()
        let active = store.activeDownloadsCount

        store.pinNowPlayingOffline()
        store.pinNowPlayingOffline()

        #expect(store.downloads.filter { $0.title == store.nowPlaying.title }.count == 1)
        #expect(store.downloads[0].status == .pinned)
        #expect(store.activeDownloadsCount == active + 1)
    }

    @Test func pinDownloadTogglesBetweenReadyAndPinned() throws {
        let store = MusicPodcastOperationsStore()
        let ready = try #require(store.downloads.first { $0.status == .ready })

        store.pinDownload(ready)
        #expect(store.downloads.first { $0.id == ready.id }?.status == .pinned)
        store.pinDownload(ready)
        #expect(store.downloads.first { $0.id == ready.id }?.status == .ready)
    }

    @Test func completingNewEpisodeAddsItToContinueListening() {
        let store = MusicPodcastOperationsStore()
        let pick = store.freshPicks[0]
        let continueCount = store.continueListening.count

        store.playEpisode(pick)
        store.completeNowPlaying()
        store.completeNowPlaying()

        #expect(store.nowPlaying.progress == 1)
        #expect(store.continueListening.count == continueCount + 1)
        #expect(store.continueListening[0].id == pick.id)
    }

    @Test func followingShowToggles() {
        let store = MusicPodcastOperationsStore()
        let show = store.featuredShows[0]

        store.followShow(show)

        #expect(store.featuredShows[0].isFollowed == !show.isFollowed)
    }
}
