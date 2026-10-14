import Foundation
import Testing
@testable import NotesKnowledgeApp

@MainActor
@Suite("NotesKnowledgeOperationsStore")
struct NotesKnowledgeOperationsStoreTests {
    @Test func addingCaptureTrimsDraftAndClearsIt() {
        let store = NotesKnowledgeOperationsStore()
        store.captureDraft = "  Interview notes  "

        store.addCapture()

        #expect(store.captures[0].summary == "Interview notes")
        #expect(!store.captures[0].isFiled)
        #expect(store.captureDraft.isEmpty)
        #expect(store.openCaptureCount == 4)
    }

    @Test func blankCaptureIsIgnored() {
        let store = NotesKnowledgeOperationsStore()
        let count = store.captures.count
        store.captureDraft = " \n "

        store.addCapture()

        #expect(store.captures.count == count)
    }

    @Test func filingCaptureCreatesLibraryNote() {
        let store = NotesKnowledgeOperationsStore()
        let capture = store.captures[0]
        let notes = store.libraryNotes.count

        store.fileCapture(capture)

        #expect(store.captures[0].isFiled)
        #expect(store.openCaptureCount == 2)
        #expect(store.libraryNotes.count == notes + 1)
        #expect(store.libraryNotes[0].title == capture.title)
        #expect(store.libraryNotes[0].collection == "Inbox Filed")
    }

    @Test func pinningAndHighlighting() {
        let store = NotesKnowledgeOperationsStore()
        let note = store.libraryNotes[1]

        store.pinNote(note)
        store.promoteHighlight(note)

        #expect(store.libraryNotes[1].isPinned)
        #expect(store.libraryNotes[1].highlightCount == note.highlightCount + 1)
    }

    @Test func refreshingUnhealthyLinkMapMarksItHealthy() {
        let store = NotesKnowledgeOperationsStore()
        let unhealthy = store.linkMaps.first { !$0.isHealthy }!

        store.refreshLinkMap(unhealthy)

        let refreshed = store.linkMaps.first { $0.id == unhealthy.id }!
        #expect(refreshed.isHealthy)
        #expect(refreshed.referenceCount == unhealthy.referenceCount + 1)
    }

    @Test func syncingSpaceClearsNeedsSync() {
        let store = NotesKnowledgeOperationsStore()
        let pending = store.spaces.first { $0.syncStatus == .needsSync }!

        store.syncSpace(pending)

        #expect(store.spaces.allSatisfy { $0.syncStatus == .synced })
    }
}
