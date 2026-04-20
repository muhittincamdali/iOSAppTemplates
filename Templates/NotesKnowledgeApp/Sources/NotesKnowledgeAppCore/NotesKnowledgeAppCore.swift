import Foundation

public struct NotesKnowledgeDashboardSnapshot: Hashable, Sendable {
    public let activeNotes: Int
    public let sharedSpaces: Int
    public let capturedIdeasToday: Int
    public let syncHealth: String

    public init(
        activeNotes: Int,
        sharedSpaces: Int,
        capturedIdeasToday: Int,
        syncHealth: String
    ) {
        self.activeNotes = activeNotes
        self.sharedSpaces = sharedSpaces
        self.capturedIdeasToday = capturedIdeasToday
        self.syncHealth = syncHealth
    }

    public static let sample = NotesKnowledgeDashboardSnapshot(
        activeNotes: 324,
        sharedSpaces: 14,
        capturedIdeasToday: 19,
        syncHealth: "Knowledge sync stable"
    )
}

public struct NotesKnowledgeCollectionCard: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let documentCount: Int
    public let ctaLabel: String

    public init(
        id: UUID = UUID(),
        title: String,
        documentCount: Int,
        ctaLabel: String
    ) {
        self.id = id
        self.title = title
        self.documentCount = documentCount
        self.ctaLabel = ctaLabel
    }

    public static let sampleCards: [NotesKnowledgeCollectionCard] = [
        NotesKnowledgeCollectionCard(title: "Team Handbook", documentCount: 48, ctaLabel: "Open knowledge map"),
        NotesKnowledgeCollectionCard(title: "Research Notes", documentCount: 112, ctaLabel: "Review insights"),
        NotesKnowledgeCollectionCard(title: "Personal Capture", documentCount: 76, ctaLabel: "Resume inbox")
    ]
}

public struct NotesKnowledgeOperationalHealth: Hashable, Sendable {
    public let reviewQueue: Int
    public let linkedReferencesToday: Int
    public let offlineReady: Bool

    public init(
        reviewQueue: Int,
        linkedReferencesToday: Int,
        offlineReady: Bool
    ) {
        self.reviewQueue = reviewQueue
        self.linkedReferencesToday = linkedReferencesToday
        self.offlineReady = offlineReady
    }

    public static let sample = NotesKnowledgeOperationalHealth(
        reviewQueue: 9,
        linkedReferencesToday: 31,
        offlineReady: true
    )
}
