import SwiftUI
import TravelPlannerAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct TravelPlannerAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            TravelPlannerWorkspaceRootView(
                snapshot: .sample,
                cards: TravelPlannerItineraryCard.sampleCards,
                actions: TravelPlannerQuickAction.defaultActions,
                health: .sample,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerWorkspaceRootView: View {
    let snapshot: TravelPlannerDashboardSnapshot
    let cards: [TravelPlannerItineraryCard]
    let actions: [TravelPlannerQuickAction]
    let health: TravelPlannerBookingHealth
    let state: TravelPlannerWorkspaceState

    var body: some View {
        TabView {
            TravelPlannerDashboardView(
                snapshot: snapshot,
                cards: cards,
                actions: actions,
                health: health,
                state: state
            )
            .tabItem {
                Image(systemName: "globe.europe.africa.fill")
                Text("Trips")
            }

            TravelPlannerTimelineView(state: state)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Timeline")
                }

            TravelPlannerBookingsView(state: state)
                .tabItem {
                    Image(systemName: "airplane.departure")
                    Text("Bookings")
                }

            TravelPlannerEssentialsView(state: state)
                .tabItem {
                    Image(systemName: "suitcase.rolling.fill")
                    Text("Essentials")
                }

            TravelPlannerProfileView(state: state)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .tint(.blue)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerDashboardView: View {
    let snapshot: TravelPlannerDashboardSnapshot
    let cards: [TravelPlannerItineraryCard]
    let actions: [TravelPlannerQuickAction]
    let health: TravelPlannerBookingHealth
    let state: TravelPlannerWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TravelPlannerHeroCard(snapshot: snapshot, health: health, state: state)
                    TravelPlannerQuickActionGrid(actions: actions)
                    TravelPlannerTripOverviewCard(trip: state.primaryTrip)
                    TravelPlannerDailyAgendaCard(cards: cards)
                    TravelPlannerTravelerSignalsCard(signals: state.signals)
                }
                .padding(16)
            }
            .navigationTitle("Travel Planner")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerHeroCard: View {
    let snapshot: TravelPlannerDashboardSnapshot
    let health: TravelPlannerBookingHealth
    let state: TravelPlannerWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upcoming Journey")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(snapshot.nextDestination)
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Text(snapshot.upcomingFlight)
                .font(.title3.weight(.semibold))
            Text(snapshot.itineraryStatus)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                TravelPlannerMetricChip(title: "Trips", value: "\(snapshot.activeTrips)")
                TravelPlannerMetricChip(title: "Flights", value: "\(health.flightsConfirmed)")
                TravelPlannerMetricChip(title: "Alerts", value: "\(health.alerts)")
            }

            HStack {
                Label(state.homeAirport, systemImage: "airplane.circle.fill")
                Spacer()
                Text(state.membershipTier)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.blue)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.blue.opacity(0.16), .cyan.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerMetricChip: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerQuickActionGrid: View {
    let actions: [TravelPlannerQuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions) { action in
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: action.systemImage)
                            .font(.title3)
                            .foregroundStyle(.blue)
                        Text(action.title)
                            .font(.subheadline.weight(.semibold))
                        Text(action.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerTripOverviewCard: View {
    let trip: TravelPlannerTrip

    var body: some View {
        NavigationLink {
            TravelPlannerTripDetailView(trip: trip)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                Text("Primary Trip")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                Text(trip.title)
                    .font(.headline)
                Text("\(trip.dateRange) • \(trip.party)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack {
                    Label(trip.hotel, systemImage: "bed.double.fill")
                    Spacer()
                    Label(trip.localTransport, systemImage: "tram.fill")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerDailyAgendaCard: View {
    let cards: [TravelPlannerItineraryCard]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today Timeline")
                .font(.title3.weight(.bold))

            ForEach(cards) { card in
                HStack(alignment: .top, spacing: 12) {
                    Text(card.timeLabel)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 58, alignment: .leading)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue)
                        .frame(width: 6, height: 42)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(card.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(card.status)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerTravelerSignalsCard: View {
    let signals: [TravelPlannerSignal]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Traveler Signals")
                .font(.title3.weight(.bold))

            ForEach(signals) { signal in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: signal.systemImage)
                        .foregroundStyle(signal.accent)
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(signal.title)
                            .font(.headline)
                        Text(signal.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerTimelineView: View {
    let state: TravelPlannerWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Agenda") {
                    ForEach(state.timelineDays) { day in
                        NavigationLink {
                            TravelPlannerDayDetailView(day: day)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(day.title)
                                    Spacer()
                                    Text(day.weather)
                                        .font(.subheadline.weight(.semibold))
                                }
                                Text(day.summary)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Timeline")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerBookingsView: View {
    let state: TravelPlannerWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Flights") {
                    ForEach(state.flights) { flight in
                        NavigationLink {
                            TravelPlannerFlightDetailView(flight: flight)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(flight.route)
                                    Spacer()
                                    Text(flight.time)
                                        .font(.subheadline.weight(.semibold))
                                }
                                Text("\(flight.status) • \(flight.seat)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Hotels") {
                    ForEach(state.hotels) { hotel in
                        NavigationLink {
                            TravelPlannerHotelDetailView(hotel: hotel)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(hotel.name)
                                    Spacer()
                                    Text(hotel.nights)
                                        .font(.subheadline.weight(.semibold))
                                }
                                Text("\(hotel.status) • \(hotel.roomType)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Bookings")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerEssentialsView: View {
    let state: TravelPlannerWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Packing Checklist") {
                    ForEach(state.checklist) { item in
                        HStack {
                            Image(systemName: item.packed ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(item.packed ? .green : .secondary)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                Text(item.group)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                    }
                }

                Section("Documents") {
                    ForEach(state.documents, id: \.self) { document in
                        Label(document, systemImage: "doc.text.fill")
                    }
                }
            }
            .navigationTitle("Essentials")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerProfileView: View {
    let state: TravelPlannerWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Traveler") {
                    LabeledContent("Membership", value: state.membershipTier)
                    LabeledContent("Home Airport", value: state.homeAirport)
                    LabeledContent("Insurance", value: state.insuranceStatus)
                }

                Section("Preferences") {
                    LabeledContent("Seat Preference", value: state.seatPreference)
                    LabeledContent("Hotel Preference", value: state.hotelPreference)
                    LabeledContent("Transfers", value: state.transferPreference)
                }

                Section("Actions") {
                    ForEach(state.profileActions, id: \.self) { action in
                        Label(action, systemImage: "arrow.right.circle")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerTripDetailView: View {
    let trip: TravelPlannerTrip

    var body: some View {
        List {
            Section("Trip") {
                LabeledContent("Title", value: trip.title)
                LabeledContent("Dates", value: trip.dateRange)
                LabeledContent("Party", value: trip.party)
                LabeledContent("Hotel", value: trip.hotel)
                LabeledContent("Transport", value: trip.localTransport)
            }

            Section("Goals") {
                ForEach(trip.goals, id: \.self) { goal in
                    Label(goal, systemImage: "star.circle")
                }
            }
        }
        .navigationTitle("Trip")
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerDayDetailView: View {
    let day: TravelPlannerDay

    var body: some View {
        List {
            Section("Day Plan") {
                LabeledContent("Date", value: day.title)
                LabeledContent("Weather", value: day.weather)
                Text(day.summary)
                    .foregroundStyle(.secondary)
            }

            Section("Stops") {
                ForEach(day.stops, id: \.self) { stop in
                    Label(stop, systemImage: "mappin.circle.fill")
                }
            }
        }
        .navigationTitle(day.title)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerFlightDetailView: View {
    let flight: TravelPlannerFlight

    var body: some View {
        List {
            Section("Flight") {
                LabeledContent("Route", value: flight.route)
                LabeledContent("Time", value: flight.time)
                LabeledContent("Status", value: flight.status)
                LabeledContent("Seat", value: flight.seat)
                LabeledContent("Fare Class", value: flight.fareClass)
            }
        }
        .navigationTitle("Flight")
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct TravelPlannerHotelDetailView: View {
    let hotel: TravelPlannerHotel

    var body: some View {
        List {
            Section("Hotel") {
                LabeledContent("Name", value: hotel.name)
                LabeledContent("Room", value: hotel.roomType)
                LabeledContent("Stay", value: hotel.nights)
                LabeledContent("Status", value: hotel.status)
                LabeledContent("District", value: hotel.district)
            }
        }
        .navigationTitle("Hotel")
    }
}

public struct TravelPlannerQuickAction: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let detail: String
    public let systemImage: String

    public init(
        id: UUID = UUID(),
        title: String,
        detail: String,
        systemImage: String
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.systemImage = systemImage
    }

    public static let defaultActions: [TravelPlannerQuickAction] = [
        TravelPlannerQuickAction(title: "Open Itinerary", detail: "Review today's schedule and protect airport transfer timing.", systemImage: "map.fill"),
        TravelPlannerQuickAction(title: "Review Flights", detail: "Check seat, gate and baggage details before leaving for the airport.", systemImage: "airplane"),
        TravelPlannerQuickAction(title: "Manage Hotels", detail: "Confirm check-in, late arrival notes and room preferences.", systemImage: "bed.double.fill"),
        TravelPlannerQuickAction(title: "Pack Essentials", detail: "Close remaining checklist items before departure morning.", systemImage: "suitcase.rolling.fill")
    ]
}

struct TravelPlannerWorkspaceState: Hashable, Sendable {
    let membershipTier: String
    let homeAirport: String
    let insuranceStatus: String
    let seatPreference: String
    let hotelPreference: String
    let transferPreference: String
    let primaryTrip: TravelPlannerTrip
    let signals: [TravelPlannerSignal]
    let timelineDays: [TravelPlannerDay]
    let flights: [TravelPlannerFlight]
    let hotels: [TravelPlannerHotel]
    let checklist: [TravelPlannerChecklistItem]
    let documents: [String]
    let profileActions: [String]

    static let sample = TravelPlannerWorkspaceState(
        membershipTier: "Gold Traveler",
        homeAirport: "IST",
        insuranceStatus: "Premium coverage active",
        seatPreference: "Aisle seat",
        hotelPreference: "Late check-in, high floor",
        transferPreference: "Private airport transfer",
        primaryTrip: TravelPlannerTrip(
            title: "Tokyo Product Sprint",
            dateRange: "Apr 29 - May 4",
            party: "2 travelers",
            hotel: "Hotel Toranomon Hills",
            localTransport: "Suica + airport transfer",
            goals: [
                "Close partner meetings before Thursday evening.",
                "Protect two local exploration blocks for context gathering.",
                "Keep departure morning under a 45-minute packing load."
            ]
        ),
        signals: [
            TravelPlannerSignal(title: "Airport transfer ready", detail: "Driver assigned and pickup note shared with the hotel concierge.", systemImage: "car.fill", accent: .green),
            TravelPlannerSignal(title: "Rain expected on Friday", detail: "Move the outdoor photo walk to Thursday evening and keep umbrellas packed.", systemImage: "cloud.rain.fill", accent: .blue),
            TravelPlannerSignal(title: "One meal booking still open", detail: "Reserve the Friday team dinner before the 20:00 local rush window.", systemImage: "fork.knife.circle.fill", accent: .orange)
        ],
        timelineDays: [
            TravelPlannerDay(title: "Apr 29", weather: "17° / light rain", summary: "Arrival, hotel check-in and evening food tour in Shibuya.", stops: ["IST departure", "Haneda arrival", "Hotel check-in", "Shibuya food tour"]),
            TravelPlannerDay(title: "Apr 30", weather: "20° / clear", summary: "Partner sessions in Minato and team dinner in Ginza.", stops: ["Breakfast brief", "Partner meeting", "Design review", "Ginza dinner"]),
            TravelPlannerDay(title: "May 1", weather: "19° / cloudy", summary: "Buffer day for workspace sprint, museum walk and remote check-ins.", stops: ["Sprint block", "Museum walk", "Remote review"])
        ],
        flights: [
            TravelPlannerFlight(route: "IST → HND", time: "08:45", status: "Confirmed", seat: "14C", fareClass: "Economy Flex"),
            TravelPlannerFlight(route: "HND → IST", time: "22:10", status: "Confirmed", seat: "15C", fareClass: "Economy Flex")
        ],
        hotels: [
            TravelPlannerHotel(name: "Hotel Toranomon Hills", roomType: "Deluxe King", nights: "5 nights", status: "Confirmed", district: "Minato"),
            TravelPlannerHotel(name: "Airport Lounge Stay", roomType: "Day room backup", nights: "Optional", status: "Hold until Apr 28", district: "Haneda")
        ],
        checklist: [
            TravelPlannerChecklistItem(title: "Passport", group: "Documents", packed: true),
            TravelPlannerChecklistItem(title: "Universal adapter", group: "Electronics", packed: true),
            TravelPlannerChecklistItem(title: "Rain jacket", group: "Clothing", packed: false),
            TravelPlannerChecklistItem(title: "Printed meeting deck", group: "Work", packed: false)
        ],
        documents: [
            "Passport copy",
            "Flight confirmations",
            "Hotel reservation PDF",
            "Insurance certificate",
            "Meeting itinerary export"
        ],
        profileActions: [
            "Share the final itinerary with the traveling team.",
            "Confirm roaming package before departure morning.",
            "Review the checklist one last time after the meeting deck is printed."
        ]
    )
}

struct TravelPlannerTrip: Hashable, Sendable {
    let title: String
    let dateRange: String
    let party: String
    let hotel: String
    let localTransport: String
    let goals: [String]
}

struct TravelPlannerSignal: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let detail: String
    let systemImage: String
    let accent: Color
}

struct TravelPlannerDay: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let weather: String
    let summary: String
    let stops: [String]
}

struct TravelPlannerFlight: Identifiable, Hashable, Sendable {
    let id = UUID()
    let route: String
    let time: String
    let status: String
    let seat: String
    let fareClass: String
}

struct TravelPlannerHotel: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let roomType: String
    let nights: String
    let status: String
    let district: String
}

struct TravelPlannerChecklistItem: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let group: String
    let packed: Bool
}
