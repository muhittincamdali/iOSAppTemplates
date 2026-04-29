import SwiftUI
import BookingReservationsAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct BookingReservationsAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            BookingRuntimeRootView()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingRuntimeRootView: View {
    @StateObject private var store = BookingOperationsStore()

    var body: some View {
        TabView {
            BookingDashboardView(store: store)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            BookingCalendarView(store: store)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            BookingGuestsView(store: store)
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Guests")
                }
            BookingRequestsView(store: store)
                .tabItem {
                    Image(systemName: "message.badge.fill")
                    Text("Requests")
                }
            BookingProfileView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.mint)
    }
}

@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class BookingOperationsStore: ObservableObject {
    @Published var stays: [BookingStayRecord]
    @Published var guestRequests: [BookingRequestRecord]
    @Published var calendarDays: [BookingCalendarRecord]
    @Published var operatorHeadline = "Weekend arrivals are on track and checkout risk is contained."
    @Published var shiftSummary = "Morning desk covers 42 arrivals, 11 departures and 3 VIP recovery cases."

    init() {
        self.stays = [
            BookingStayRecord(guestName: "Liam Carter", property: "City Loft", dateRange: "Apr 27 - Apr 30", status: .arrivalReady, departureTime: "Checkout 11:00", note: "Needs early key handoff and parking code.", preferences: ["Quiet room", "Late dinner recommendations"], identityVerified: true, checkedIn: false),
            BookingStayRecord(guestName: "Mila Harper", property: "Coastal Retreat", dateRange: "Apr 27 - May 1", status: .awaitingID, departureTime: "Checkout 10:00", note: "Passport upload pending before self check-in.", preferences: ["Crib in room", "Ocean-view request"], identityVerified: false, checkedIn: false),
            BookingStayRecord(guestName: "Oliver Reed", property: "Business Suites", dateRange: "Apr 24 - Apr 27", status: .checkoutToday, departureTime: "Departs 09:30", note: "Invoice copy requested before departure.", preferences: ["Invoice PDF", "Airport taxi"], identityVerified: true, checkedIn: true),
            BookingStayRecord(guestName: "Ava Collins", property: "City Loft", dateRange: "Apr 25 - Apr 27", status: .pendingReview, departureTime: "Departs 12:00", note: "Housekeeping flagged minibar reconciliation.", preferences: ["Late checkout", "Digital receipt"], identityVerified: true, checkedIn: true)
        ]
        self.guestRequests = [
            BookingRequestRecord(title: "Late checkout approval", guest: "Ava Collins • City Loft", priority: .high, nextAction: "Confirm cleaning slot before 18:00 arrival.", status: .open),
            BookingRequestRecord(title: "Airport transfer update", guest: "Liam Carter • City Loft", priority: .medium, nextAction: "Send driver contact and pickup window.", status: .open),
            BookingRequestRecord(title: "Family crib setup", guest: "Mila Harper • Coastal Retreat", priority: .high, nextAction: "Housekeeping to confirm room setup before 14:00.", status: .open)
        ]
        self.calendarDays = [
            BookingCalendarRecord(label: "Today", occupancy: 92, summary: "42 arrivals, 11 departures, 3 VIP stays.", isLocked: false),
            BookingCalendarRecord(label: "Tomorrow", occupancy: 88, summary: "High leisure demand on the coastal segment.", isLocked: false),
            BookingCalendarRecord(label: "Friday", occupancy: 96, summary: "Business Suites nearly sold out for conference week.", isLocked: true)
        ]
    }

    var arrivals: [BookingStayRecord] {
        stays.filter { $0.status == .arrivalReady || $0.status == .awaitingID }
    }

    var checkouts: [BookingStayRecord] {
        stays.filter { $0.status == .checkoutToday || $0.status == .pendingReview }
    }

    var openRequestCount: Int {
        guestRequests.filter { $0.status != .resolved }.count
    }

    func verifyIdentity(for stay: BookingStayRecord) {
        guard let index = stays.firstIndex(where: { $0.id == stay.id }) else { return }
        stays[index].identityVerified = true
        if stays[index].status == .awaitingID {
            stays[index].status = .arrivalReady
        }
    }

    func checkInGuest(_ stay: BookingStayRecord) {
        guard let index = stays.firstIndex(where: { $0.id == stay.id }) else { return }
        stays[index].checkedIn = true
        stays[index].status = .inHouse
        operatorHeadline = "\(stays[index].guestName) checked in and the arrival queue moved forward."
    }

    func completeCheckout(_ stay: BookingStayRecord) {
        guard let index = stays.firstIndex(where: { $0.id == stay.id }) else { return }
        stays[index].status = .checkedOut
        operatorHeadline = "\(stays[index].guestName) checked out and the room is ready for turnover."
    }

    func approveRequest(_ request: BookingRequestRecord) {
        guard let index = guestRequests.firstIndex(where: { $0.id == request.id }) else { return }
        guestRequests[index].status = .approved
    }

    func resolveRequest(_ request: BookingRequestRecord) {
        guard let index = guestRequests.firstIndex(where: { $0.id == request.id }) else { return }
        guestRequests[index].status = .resolved
    }

    func lockDay(_ day: BookingCalendarRecord) {
        guard let index = calendarDays.firstIndex(where: { $0.id == day.id }) else { return }
        calendarDays[index].isLocked.toggle()
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingDashboardView: View {
    @ObservedObject var store: BookingOperationsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Operations Snapshot")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text(store.operatorHeadline)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text(store.shiftSummary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 12) {
                            BookingMetricChip(title: "Arrivals", value: "\(store.arrivals.count)")
                            BookingMetricChip(title: "Checkouts", value: "\(store.checkouts.count)")
                            BookingMetricChip(title: "Requests", value: "\(store.openRequestCount)")
                        }
                    }
                    .padding(20)
                    .background(LinearGradient(colors: [.mint.opacity(0.18), .teal.opacity(0.10)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 22))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Arrival Board")
                            .font(.title3.weight(.bold))
                        ForEach(store.arrivals) { stay in
                            BookingStayCard(
                                stay: stay,
                                primaryActionTitle: stay.identityVerified ? "Check In" : "Verify ID",
                                primaryAction: {
                                    stay.identityVerified ? store.checkInGuest(stay) : store.verifyIdentity(for: stay)
                                }
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Checkout Watch")
                            .font(.title3.weight(.bold))
                        ForEach(store.checkouts) { stay in
                            BookingStayCard(stay: stay, primaryActionTitle: "Complete Checkout", primaryAction: {
                                store.completeCheckout(stay)
                            })
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Reservations")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingCalendarView: View {
    @ObservedObject var store: BookingOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.calendarDays) { day in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(day.label)
                            Spacer()
                            Text("\(day.occupancy)%")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(day.occupancy > 90 ? .green : .orange)
                        }
                        Text(day.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Button(day.isLocked ? "Unlock Inventory" : "Lock Inventory") {
                            store.lockDay(day)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Calendar")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingGuestsView: View {
    @ObservedObject var store: BookingOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.stays) { stay in
                    BookingStayCard(stay: stay, primaryActionTitle: stay.status == .checkoutToday ? "Complete Checkout" : stay.checkedIn ? "Checked In" : "Check In", primaryAction: {
                        if stay.status == .checkoutToday {
                            store.completeCheckout(stay)
                        } else if !stay.checkedIn {
                            store.checkInGuest(stay)
                        }
                    }, disablePrimary: stay.checkedIn && stay.status != .checkoutToday)
                }
            }
            .navigationTitle("Guests")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingRequestsView: View {
    @ObservedObject var store: BookingOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.guestRequests) { request in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(request.title)
                            Spacer()
                            Text(request.priority.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(request.priority.color)
                        }
                        Text(request.guest)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(request.nextAction)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        HStack {
                            Button("Approve") { store.approveRequest(request) }
                                .buttonStyle(.bordered)
                            Button("Resolve") { store.resolveRequest(request) }
                                .buttonStyle(.borderedProminent)
                            Text(request.status.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(request.status.color)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Requests")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct BookingProfileView: View {
    @ObservedObject var store: BookingOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Operator") {
                    Label("Nora Fields", systemImage: "person.crop.circle.fill")
                    Label("Europe coastal portfolio", systemImage: "globe")
                }
                Section("Performance") {
                    Label("\(store.stays.count) active stays", systemImage: "building.2.fill")
                    Label("\(store.arrivals.count) arrivals still in queue", systemImage: "door.left.hand.open")
                    Label("\(store.openRequestCount) open requests", systemImage: "timer")
                }
                Section("Shift State") {
                    Label(store.shiftSummary, systemImage: "clock.fill")
                    Label(store.operatorHeadline, systemImage: "waveform.path.ecg")
                }
            }
            .navigationTitle("Profile")
        }
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
struct BookingStayCard: View {
    let stay: BookingStayRecord
    let primaryActionTitle: String
    let primaryAction: () -> Void
    var disablePrimary = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(stay.guestName)
                    .font(.headline)
                Spacer()
                Text(stay.status.label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(stay.status.color)
            }
            Text("\(stay.property) • \(stay.dateRange)")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(stay.note)
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack {
                Button(primaryActionTitle, action: primaryAction)
                    .buttonStyle(.borderedProminent)
                    .disabled(disablePrimary)
                if !stay.identityVerified {
                    Text("ID pending")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

enum BookingStayStatus: Hashable, Sendable {
    case arrivalReady
    case awaitingID
    case inHouse
    case checkoutToday
    case pendingReview
    case checkedOut

    var label: String {
        switch self {
        case .arrivalReady: return "Ready"
        case .awaitingID: return "Awaiting ID"
        case .inHouse: return "In House"
        case .checkoutToday: return "Checkout Today"
        case .pendingReview: return "Pending Review"
        case .checkedOut: return "Checked Out"
        }
    }

    var color: Color {
        switch self {
        case .arrivalReady, .inHouse, .checkedOut: return .green
        case .awaitingID, .pendingReview: return .orange
        case .checkoutToday: return .blue
        }
    }
}

struct BookingStayRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let guestName: String
    let property: String
    let dateRange: String
    var status: BookingStayStatus
    let departureTime: String
    let note: String
    let preferences: [String]
    var identityVerified: Bool
    var checkedIn: Bool
}

enum BookingRequestPriority: Hashable, Sendable {
    case high
    case medium
    case low

    var label: String {
        switch self {
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        }
    }

    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .blue
        }
    }
}

enum BookingRequestStatus: Hashable, Sendable {
    case open
    case approved
    case resolved

    var label: String {
        switch self {
        case .open: return "Open"
        case .approved: return "Approved"
        case .resolved: return "Resolved"
        }
    }

    var color: Color {
        switch self {
        case .open: return .orange
        case .approved: return .mint
        case .resolved: return .green
        }
    }
}

struct BookingRequestRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let guest: String
    let priority: BookingRequestPriority
    let nextAction: String
    var status: BookingRequestStatus
}

struct BookingCalendarRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let label: String
    let occupancy: Int
    let summary: String
    var isLocked: Bool
}
