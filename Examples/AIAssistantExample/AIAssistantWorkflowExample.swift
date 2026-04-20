import Foundation

struct AIAssistantWorkflowExample {
    let activeContext: String
    let suggestedAction: String
    let trustMode: String
}

let aiAssistantExample = AIAssistantWorkflowExample(
    activeContext: "Weekly planning review",
    suggestedAction: "Draft follow-up email",
    trustMode: "Sensitive data stays local"
)
