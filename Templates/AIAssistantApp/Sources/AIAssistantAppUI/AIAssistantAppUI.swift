import SwiftUI
import AIAssistantAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct AIAssistantWorkspaceCard: View {
    public let snapshot: AIAssistantWorkspaceSnapshot
    public let signals: [AIAssistantSignal]

    public init(
        snapshot: AIAssistantWorkspaceSnapshot,
        signals: [AIAssistantSignal]
    ) {
        self.snapshot = snapshot
        self.signals = signals
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(snapshot.activeContext)
                .font(.title2.bold())

            LabeledContent("Model Route", value: snapshot.modelRoute)
            LabeledContent("Trust Status", value: snapshot.trustStatus)

            ForEach(signals, id: \.title) { signal in
                LabeledContent(signal.title, value: signal.value)
            }
        }
    }
}
