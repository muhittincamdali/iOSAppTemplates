import SwiftUI
import BookingReservationsAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct BookingReservationsAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            BookingWorkspaceRootView(
                snapshot: .sample,
                properties: BookingPropertyCard.sampleCards,
                actions: BookingReservationsQuickAction.defaultActions,
                health: .sample,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingWorkspaceRootView: View {
    let snapshot: BookingReservationsDashboardSnapshot
    let properties: [BookingPropertyCard]
    let actions: [BookingReservationsQuickAction]
    let health: BookingOperationsHealth
    let state: BookingWorkspaceState

    var body: some View {
        TabView {
            BookingDashboardView(
                snapshot: snapshot,
                properties: properties,
                actions: actions,
                health: health,
                state: state
            )
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            BookingCalendarView(state: state)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }

            BookingGuestsView(state: state)
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Guests")
                }

            BookingRequestsView(state: state)
                .tabItem {
                    Image(systemName: "message.badge.fill")
                    Text("Requests")
                }

            BookingProfileView(snapshot: snapshot, health: health, state: state)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.mint)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingDashboardView: View {
    let snapshot: BookingReservationsDashboardSnapshot
    let properties: [BookingPropertyCard]
    let actions: [BookingReservationsQuickAction]
    let health: BookingOperationsHealth
    let state: BookingWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    BookingHeroCard(snapshot: snapshot, health: health, state: state)
                    BookingQuickActionGrid(actions: actions)
                    BookingArrivalBoardCard(arrivals: state.arrivals)
                    BookingPropertyPerformanceCard(properties: properties)
                    BookingCheckoutBoardCard(checkouts: state.checkouts)
                }
                .padding(16)
            }
            .navigationTitle("Reservations")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingHeroCard: View {
    let snapshot: BookingReservationsDashboardSnapshot
    let health: BookingOperationsHealth
    let state: BookingWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Operations Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(state.operatorHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(snapshot.occupancyHealth)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                BookingMetricChip(title: "Check-ins", value: "\(snapshot.checkInsToday)")
                BookingMetricChip(title: "Properties", value: "\(snapshot.managedProperties)")
                BookingMetricChip(title: "Requests", value: "\(snapshot.pendingRequests)")
            }

            HStack {
                Label(state.shiftSummary, systemImage: "clock.fill")
                Spacer()
                Text("\(health.averageResponseMinutes) min avg")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.mint)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.mint.opacity(0.18), .teal.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingMetricChip: View {
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
struct BookingQuickActionGrid: View {
    let actions: [BookingReservationsQuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions) { action in
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: action.systemImage)
                            .font(.title3)
                            .foregroundStyle(.mint)
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
struct BookingArrivalBoardCard: View {
    let arrivals: [BookingGuestStay]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Arrival Board")
                .font(.title3.weight(.bold))

            ForEach(arrivals) { stay in
                NavigationLink {
                    BookingStayDetailView(stay: stay)
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(stay.guestName)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text("\(stay.property) • \(stay.dateRange)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(stay.note)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(stay.status)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(stay.statusColor)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingPropertyPerformanceCard: View {
    let properties: [BookingPropertyCard]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Property Pulse")
                .font(.title3.weight(.bold))

            ForEach(properties) { property in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(property.title)
                            .font(.headline)
                        Text("\(property.reservationCount) active reservations")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(property.ctaLabel)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.mint)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingCheckoutBoardCard: View {
    let checkouts: [BookingGuestStay]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Checkout Watch")
                .font(.title3.weight(.bold))

            ForEach(checkouts) { stay in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "suitcase.rolling.fill")
                        .foregroundStyle(.mint)
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(stay.guestName)
                            .font(.headline)
                        Text("\(stay.property) • departs \(stay.departureTime)")
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
struct BookingCalendarView: View {
    let state: BookingWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.calendarDays) { day in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(day.label)
                            Spacer()
                            Text(day.occupancy)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(day.occupancyColor)
                        }
                        Text(day.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Calendar")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingGuestsView: View {
    let state: BookingWorkspaceState

    var body: some View {
        NavigationStack {
            List(state.guests) { stay in
                NavigationLink {
                    BookingStayDetailView(stay: stay)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(stay.guestName)
                        Text("\(stay.property) • \(stay.dateRange)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(stay.note)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Guests")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingRequestsView: View {
    let state: BookingWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.requests) { request in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(request.title)
                            Spacer()
                            Text(request.priority)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(request.priorityColor)
                        }
                        Text(request.guest)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(request.nextAction)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Requests")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingProfileView: View {
    let snapshot: BookingReservationsDashboardSnapshot
    let health: BookingOperationsHealth
    let state: BookingWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Operator") {
                    Label(state.operatorName, systemImage: "person.crop.circle.fill")
                    Label(state.region, systemImage: "globe")
                }
                Section("Performance") {
                    Label("\(snapshot.managedProperties) managed properties", systemImage: "building.2.fill")
                    Label("\(snapshot.checkInsToday) check-ins today", systemImage: "door.left.hand.open")
                    Label("\(health.averageResponseMinutes) min avg response", systemImage: "timer")
                }
                Section("Finance & Support") {
                    Label(health.paymentCaptureReady ? "Payment capture healthy" : "Payment capture degraded", systemImage: health.paymentCaptureReady ? "creditcard.fill" : "exclamationmark.triangle.fill")
                    Label("\(health.supportEscalations) escalations open", systemImage: "headphones.circle.fill")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingStayDetailView: View {
    let stay: BookingGuestStay

    var body: some View {
        List {
            Section("Reservation") {
                Text(stay.guestName)
                    .font(.title3.weight(.bold))
                Text(stay.property)
                Text(stay.dateRange)
                    .foregroundStyle(.secondary)
            }
            Section("Stay Notes") {
                Text(stay.note)
                Label(stay.status, systemImage: "checkmark.circle.fill")
                Label(stay.departureTime, systemImage: "clock.fill")
            }
            Section("Guest Preferences") {
                ForEach(stay.preferences, id: \.self) { preference in
                    Label(preference, systemImage: "sparkles")
                }
            }
        }
        .navigationTitle("Stay Detail")
    }
}

public struct BookingReservationsQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [BookingReservationsQuickAction] = [
        BookingReservationsQuickAction(title: "Open Arrival Board", detail: "Review today’s arrivals, key exchange timing and VIP handling.", systemImage: "calendar"),
        BookingReservationsQuickAction(title: "Review Guest Requests", detail: "Resolve late checkout, transport and amenity requests before handoff.", systemImage: "message.badge.fill"),
        BookingReservationsQuickAction(title: "Inspect Occupancy Pulse", detail: "Check high-demand properties and close the last pricing gaps.", systemImage: "waveform.path.ecg")
    ]
}

struct BookingWorkspaceState {
    let operatorHeadline: String
    let shiftSummary: String
    let operatorName: String
    let region: String
    let arrivals: [BookingGuestStay]
    let checkouts: [BookingGuestStay]
    let guests: [BookingGuestStay]
    let requests: [BookingGuestRequest]
    let calendarDays: [BookingCalendarDay]

    static let sample = BookingWorkspaceState(
        operatorHeadline: "Weekend arrivals are on track",
        shiftSummary: "Morning desk covers 42 arrivals and 11 departures",
        operatorName: "Nora Fields",
        region: "Europe coastal portfolio",
        arrivals: [
            BookingGuestStay(guestName: "Liam Carter", property: "City Loft", dateRange: "Apr 27 - Apr 30", status: "Ready", departureTime: "Checkout 11:00", note: "Needs early key handoff and parking code.", preferences: ["Quiet room", "Late dinner recommendations"]),
            BookingGuestStay(guestName: "Mila Harper", property: "Coastal Retreat", dateRange: "Apr 27 - May 1", status: "Awaiting ID", departureTime: "Checkout 10:00", note: "Passport upload pending before self check-in.", preferences: ["Crib in room", "Ocean-view request"])
        ],
        checkouts: [
            BookingGuestStay(guestName: "Oliver Reed", property: "Business Suites", dateRange: "Apr 24 - Apr 27", status: "Checkout Today", departureTime: "Departs 09:30", note: "Invoice copy requested before departure.", preferences: ["Invoice PDF", "Airport taxi"]),
            BookingGuestStay(guestName: "Ava Collins", property: "City Loft", dateRange: "Apr 25 - Apr 27", status: "Pending Review", departureTime: "Departs 12:00", note: "Housekeeping flagged minibar reconciliation.", preferences: ["Late checkout", "Digital receipt"])
        ],
        guests: [
            BookingGuestStay(guestName: "Liam Carter", property: "City Loft", dateRange: "Apr 27 - Apr 30", status: "Ready", departureTime: "Checkout 11:00", note: "Needs early key handoff and parking code.", preferences: ["Quiet room", "Late dinner recommendations"]),
            BookingGuestStay(guestName: "Mila Harper", property: "Coastal Retreat", dateRange: "Apr 27 - May 1", status: "Awaiting ID", departureTime: "Checkout 10:00", note: "Passport upload pending before self check-in.", preferences: ["Crib in room", "Ocean-view request"]),
            BookingGuestStay(guestName: "Oliver Reed", property: "Business Suites", dateRange: "Apr 24 - Apr 27", status: "Checkout Today", departureTime: "Departs 09:30", note: "Invoice copy requested before departure.", preferences: ["Invoice PDF", "Airport taxi"])
        ],
        requests: [
            BookingGuestRequest(title: "Late checkout approval", guest: "Ava Collins • City Loft", priority: "High", nextAction: "Confirm cleaning slot before 18:00 arrival."),
            BookingGuestRequest(title: "Airport transfer update", guest: "Liam Carter • City Loft", priority: "Medium", nextAction: "Send driver contact and pickup window."),
            BookingGuestRequest(title: "Family crib setup", guest: "Mila Harper • Coastal Retreat", priority: "High", nextAction: "Housekeeping to confirm room setup before 14:00.")
        ],
        calendarDays: [
            BookingCalendarDay(label: "Today", occupancy: "92%", summary: "42 arrivals, 11 departures, 3 VIP stays."),
            BookingCalendarDay(label: "Tomorrow", occupancy: "88%", summary: "High leisure demand on the coastal segment."),
            BookingCalendarDay(label: "Friday", occupancy: "96%", summary: "Business Suites nearly sold out for conference week.")
        ]
    )
}

struct BookingGuestStay: Identifiable, Hashable {
    let id = UUID()
    let guestName: String
    let property: String
    let dateRange: String
    let status: String
    let departureTime: String
    let note: String
    let preferences: [String]

    var statusColor: Color {
        switch status {
        case "Ready":
            return .green
        case "Awaiting ID":
            return .orange
        default:
            return .blue
        }
    }
}

struct BookingGuestRequest: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let guest: String
    let priority: String
    let nextAction: String

    var priorityColor: Color {
        switch priority {
        case "High":
            return .red
        case "Medium":
            return .orange
        default:
            return .blue
        }
    }
}

struct BookingCalendarDay: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let occupancy: String
    let summary: String

    var occupancyColor: Color {
        if occupancy.hasPrefix("9") {
            return .green
        }
        return .orange
    }
}
