import Foundation
import Alamofire

public struct AIAssistantWorkspaceSnapshot: Hashable, Sendable {
    public let activeContext: String
    public let modelRoute: String
    public let pendingSuggestions: Int
    public let trustStatus: String

    public init(
        activeContext: String,
        modelRoute: String,
        pendingSuggestions: Int,
        trustStatus: String
    ) {
        self.activeContext = activeContext
        self.modelRoute = modelRoute
        self.pendingSuggestions = pendingSuggestions
        self.trustStatus = trustStatus
    }

    public static let sample = AIAssistantWorkspaceSnapshot(
        activeContext: "Weekly planning",
        modelRoute: "On-device summarization",
        pendingSuggestions: 4,
        trustStatus: "Sensitive data stays local"
    )
}

public struct AIAssistantTaskCard: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let summary: String
    public let confidence: String

    public init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        confidence: String
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.confidence = confidence
    }

    public static let sampleCards: [AIAssistantTaskCard] = [
        AIAssistantTaskCard(
            title: "Summarize meeting notes",
            summary: "Turns a raw note set into a short executive brief.",
            confidence: "High"
        ),
        AIAssistantTaskCard(
            title: "Draft follow-up email",
            summary: "Builds a concise post-meeting action email.",
            confidence: "High"
        ),
        AIAssistantTaskCard(
            title: "Plan tomorrow",
            summary: "Converts deadlines into a proposed morning schedule.",
            confidence: "Medium"
        )
    ]
}

public struct AIAssistantSignal: Hashable, Sendable {
    public let title: String
    public let value: String

    public init(
        title: String,
        value: String
    ) {
        self.title = title
        self.value = value
    }

    public static let sampleSignals: [AIAssistantSignal] = [
        AIAssistantSignal(title: "On-Device Tasks", value: "3"),
        AIAssistantSignal(title: "Cloud Escalations", value: "1"),
        AIAssistantSignal(title: "Guardrail Checks", value: "Passing")
    ]
}
