import SwiftUI
import TravelPlannerAppCore
import TravelPlannerAppUI

@available(iOS 18.0, macOS 15.0, *)
public struct TravelPlannerAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            TravelPlannerDashboardView(
                snapshot: .sample,
                cards: TravelPlannerItineraryCard.sampleCards,
                actions: TravelPlannerQuickAction.defaultActions,
                health: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct TravelPlannerDashboardView: View {
    public let snapshot: TravelPlannerDashboardSnapshot
    public let cards: [TravelPlannerItineraryCard]
    public let actions: [TravelPlannerQuickAction]
    public let health: TravelPlannerBookingHealth

    public init(
        snapshot: TravelPlannerDashboardSnapshot,
        cards: [TravelPlannerItineraryCard],
        actions: [TravelPlannerQuickAction],
        health: TravelPlannerBookingHealth
    ) {
        self.snapshot = snapshot
        self.cards = cards
        self.actions = actions
        self.health = health
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Trip Overview") {
                    TravelPlannerSummaryCard(
                        snapshot: snapshot,
                        health: health
                    )
                }

                Section("Itinerary") {
                    ForEach(cards) { card in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(card.title)
                            Text(card.timeLabel)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(card.status)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Quick Actions") {
                    ForEach(actions) { action in
                        Label(action.title, systemImage: action.systemImage)
                    }
                }
            }
            .navigationTitle("TravelPlannerApp")
        }
    }
}

public struct TravelPlannerQuickAction: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let systemImage: String

    public init(
        id: UUID = UUID(),
        title: String,
        systemImage: String
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
    }

    public static let defaultActions: [TravelPlannerQuickAction] = [
        TravelPlannerQuickAction(title: "Open Itinerary", systemImage: "map.fill"),
        TravelPlannerQuickAction(title: "Review Flights", systemImage: "airplane"),
        TravelPlannerQuickAction(title: "Manage Hotels", systemImage: "bed.double.fill")
    ]
}
