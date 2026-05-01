import Foundation
import SwiftUI
import TravelPlannerAppCore

private enum TravelInteractionProofMode {
    static let isEnabled = ProcessInfo.processInfo.environment["IOSAPPTEMPLATES_INTERACTION_PROOF_MODE"] == "1"

    static func write(summary: String, steps: [String]) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let payload: [String: Any] = [
            "app": "TravelPlannerApp",
            "status": "completed",
            "summary": summary,
            "steps": steps,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]

        guard JSONSerialization.isValidJSONObject(payload),
              let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys]) else {
            return
        }

        try? data.write(to: documentsURL.appendingPathComponent("interaction-proof.json"), options: [.atomic])
    }
}

public struct TravelPlannerAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            TravelPlannerRuntimeRootView()
        }
    }
}

struct TravelPlannerRuntimeRootView: View {
    @StateObject private var store = TravelPlannerOperationsStore()

    var body: some View {
        TabView {
            TravelPlannerTripsWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "globe.europe.africa.fill")
                    Text("Trips")
                }

            TravelPlannerTimelineWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Timeline")
                }

            TravelPlannerBookingsWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "airplane.departure")
                    Text("Bookings")
                }

            TravelPlannerEssentialsWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "suitcase.rolling.fill")
                    Text("Essentials")
                }

            TravelPlannerProfileWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.blue)
        .onAppear {
            store.runInteractionProofIfNeeded()
        }
    }
}

@MainActor
final class TravelPlannerOperationsStore: ObservableObject {
    @Published var trips: [TravelTripRecord] = TravelTripRecord.sampleTrips
    @Published var timelineDays: [TravelTimelineDayRecord] = TravelTimelineDayRecord.sampleDays
    @Published var flights: [TravelFlightRecord] = TravelFlightRecord.sampleFlights
    @Published var stays: [TravelStayRecord] = TravelStayRecord.sampleStays
    @Published var packingTasks: [TravelPackingTaskRecord] = TravelPackingTaskRecord.sampleTasks
    @Published var documents: [TravelDocumentRecord] = TravelDocumentRecord.sampleDocuments
    @Published var alerts: [TravelAlertRecord] = TravelAlertRecord.sampleAlerts
    @Published var selectedTripID: UUID?
    @Published var operationsNote = "Check-in, airport transfer, and passport validity must close before the departure lock window."
    private var interactionProofScheduled = false

    init() {
        selectedTripID = trips.first?.id
    }

    var selectedTrip: TravelTripRecord? {
        trips.first(where: { $0.id == selectedTripID }) ?? trips.first
    }

    var nextFlight: TravelFlightRecord? {
        flights.sorted { $0.departureCode < $1.departureCode }.first
    }

    var unresolvedAlerts: Int {
        alerts.filter { !$0.isResolved }.count
    }

    var checkedInFlights: Int {
        flights.filter(\.isCheckedIn).count
    }

    var packedTasks: Int {
        packingTasks.filter(\.isPacked).count
    }

    var verifiedDocuments: Int {
        documents.filter(\.isReady).count
    }

    var rescuePackCount: Int {
        documents.filter(\.rescuePackIncluded).count
    }

    var incidentRecoveredCount: Int {
        alerts.filter { $0.incidentState == "Recovered" }.count
    }

    var readinessHeadline: String {
        if unresolvedAlerts > 0 {
            return "\(unresolvedAlerts) trip alerts still need rerouting or traveler action."
        }
        if documents.contains(where: { !$0.isReady }) {
            return "Travel documents are still incomplete for the departure window."
        }
        return "Trip operations are aligned for departure."
    }

    func selectTrip(_ tripID: UUID) {
        selectedTripID = tripID
    }

    func confirmCheckIn(_ flightID: UUID) {
        guard let index = flights.firstIndex(where: { $0.id == flightID }) else { return }
        flights[index].isCheckedIn = true
        flights[index].seat = flights[index].seat == nil ? "12A" : flights[index].seat
        flights[index].status = "Checked in"
        flights[index].protectionState = "Check-in secured"
        alerts.removeAll { $0.linkedFlightID == flightID && $0.type == .checkIn }
    }

    func assignRecoveryOwner(_ flightID: UUID, owner: String) {
        guard let index = flights.firstIndex(where: { $0.id == flightID }) else { return }
        flights[index].recoveryOwner = owner
        flights[index].protectionState = "Recovery owner assigned"
    }

    func requestRebook(_ flightID: UUID) {
        guard let index = flights.firstIndex(where: { $0.id == flightID }) else { return }
        flights[index].status = "Rebooking requested"
        flights[index].protectionState = "Connection buffer under review"
        alerts.append(
            TravelAlertRecord(
                title: "Rebook \(flights[index].route)",
                detail: "Operations requested a safer connection window with extra buffer before hotel transfer.",
                type: .disruption,
                linkedFlightID: flightID,
                escalationOwner: flights[index].recoveryOwner,
                incidentState: "Open",
                isResolved: false
            )
        )
    }

    func confirmRebook(_ flightID: UUID) {
        guard let index = flights.firstIndex(where: { $0.id == flightID }) else { return }
        flights[index].status = "Rebooked"
        flights[index].departureTime = "\(flights[index].departureTime) • +45 min buffer"
        flights[index].alternateRoute = "Protected via same carrier with extra 45-minute arrival buffer."
        flights[index].protectionState = "Protected itinerary confirmed"
        if let alertIndex = alerts.firstIndex(where: { $0.linkedFlightID == flightID && !$0.isResolved }) {
            alerts[alertIndex].detail = "Rebook accepted with a safer connection window."
            alerts[alertIndex].isResolved = true
            alerts[alertIndex].incidentState = "Recovered"
        }
    }

    func confirmStay(_ stayID: UUID) {
        guard let index = stays.firstIndex(where: { $0.id == stayID }) else { return }
        stays[index].confirmationState = "Confirmed"
        stays[index].checkInNote = "Late arrival shared with concierge and airport pickup vendor."
        stays[index].transportLocked = true
    }

    func sendArrivalNote(_ stayID: UUID) {
        guard let index = stays.firstIndex(where: { $0.id == stayID }) else { return }
        stays[index].checkInNote = "Arrival note, room preference, and concierge late check-in confirmed."
    }

    func lockAirportTransfer(_ stayID: UUID) {
        guard let index = stays.firstIndex(where: { $0.id == stayID }) else { return }
        stays[index].transportLocked = true
        stays[index].checkInNote = "Airport transfer, concierge handoff, and late arrival protocol are locked."
    }

    func moveActivityForward(_ activityID: UUID, from dayID: UUID) {
        guard let dayIndex = timelineDays.firstIndex(where: { $0.id == dayID }),
              dayIndex + 1 < timelineDays.count,
              let activityIndex = timelineDays[dayIndex].activities.firstIndex(where: { $0.id == activityID }) else {
            return
        }

        let activity = timelineDays[dayIndex].activities.remove(at: activityIndex)
        timelineDays[dayIndex + 1].activities.insert(activity, at: 0)
        timelineDays[dayIndex].summary = "Agenda rebalanced after shifting a lower-priority item."
        timelineDays[dayIndex + 1].summary = "Buffer block absorbed one moved activity from the previous day."
        timelineDays[dayIndex + 1].recoveryPlan = "Next-day buffer absorbed a moved activity to protect critical travel and meeting windows."
    }

    func lockDayPlan(_ dayID: UUID) {
        guard let dayIndex = timelineDays.firstIndex(where: { $0.id == dayID }) else { return }
        timelineDays[dayIndex].isLocked = true
        timelineDays[dayIndex].summary = "Day plan locked with transport, reservations, and meeting windows confirmed."
    }

    func unlockDayPlan(_ dayID: UUID) {
        guard let dayIndex = timelineDays.firstIndex(where: { $0.id == dayID }) else { return }
        timelineDays[dayIndex].isLocked = false
        timelineDays[dayIndex].summary = "Day plan reopened to absorb a disruption and rebalance logistics."
    }

    func publishRecoveryPlan(_ dayID: UUID) {
        guard let dayIndex = timelineDays.firstIndex(where: { $0.id == dayID }) else { return }
        timelineDays[dayIndex].recoveryPlan = "Recovery plan published with backup transport, meal window buffer, and owner-assigned incident steps."
    }

    func togglePackingTask(_ taskID: UUID) {
        guard let index = packingTasks.firstIndex(where: { $0.id == taskID }) else { return }
        packingTasks[index].isPacked.toggle()
    }

    func markDocumentReady(_ documentID: UUID) {
        guard let index = documents.firstIndex(where: { $0.id == documentID }) else { return }
        documents[index].isReady = true
        documents[index].status = "Ready"
        alerts.removeAll { $0.linkedDocumentID == documentID }
    }

    func downloadOfflineCopy(_ documentID: UUID) {
        guard let index = documents.firstIndex(where: { $0.id == documentID }) else { return }
        documents[index].status = "Offline copy saved"
    }

    func createRescuePack(_ documentID: UUID) {
        guard let index = documents.firstIndex(where: { $0.id == documentID }) else { return }
        documents[index].rescuePackIncluded = true
        documents[index].status = "Rescue pack saved"
    }

    func resolveAlert(_ alertID: UUID) {
        guard let index = alerts.firstIndex(where: { $0.id == alertID }) else { return }
        alerts[index].isResolved = true
        alerts[index].detail = "Operator action completed and traveler brief synced."
        alerts[index].incidentState = "Recovered"
    }

    func escalateAlert(_ alertID: UUID) {
        guard let index = alerts.firstIndex(where: { $0.id == alertID }) else { return }
        alerts[index].detail = "Escalated to airline or organizer desk with operator brief attached."
        alerts[index].incidentState = "Escalated"
    }

    func assignAlertOwner(_ alertID: UUID, owner: String) {
        guard let index = alerts.firstIndex(where: { $0.id == alertID }) else { return }
        alerts[index].escalationOwner = owner
    }

    func clearIncident(_ alertID: UUID) {
        guard let index = alerts.firstIndex(where: { $0.id == alertID }) else { return }
        alerts[index].isResolved = true
        alerts[index].incidentState = "Recovered"
        alerts[index].detail = "Incident closed with traveler brief, owner handoff, and recovery plan synced."
    }

    func runInteractionProofIfNeeded() {
        guard TravelInteractionProofMode.isEnabled, !interactionProofScheduled else { return }
        interactionProofScheduled = true

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 800_000_000)

            if let trip = trips.dropFirst().first ?? trips.first {
                selectTrip(trip.id)
            }

            if let flight = flights.first {
                assignRecoveryOwner(flight.id, owner: "Travel Ops - Elena")
                confirmCheckIn(flight.id)
                requestRebook(flight.id)
                confirmRebook(flight.id)
            }

            if let stay = stays.first {
                confirmStay(stay.id)
                sendArrivalNote(stay.id)
                lockAirportTransfer(stay.id)
            }

            if let day = timelineDays.first, let activity = day.activities.first {
                moveActivityForward(activity.id, from: day.id)
                publishRecoveryPlan(day.id)
                lockDayPlan(day.id)
                unlockDayPlan(day.id)
            }

            if let task = packingTasks.first {
                togglePackingTask(task.id)
            }

            if let document = documents.first {
                markDocumentReady(document.id)
                downloadOfflineCopy(document.id)
                createRescuePack(document.id)
            }

            if let alert = alerts.first(where: { !$0.isResolved }) {
                assignAlertOwner(alert.id, owner: "Travel Ops - Elena")
                escalateAlert(alert.id)
                clearIncident(alert.id)
            }

            TravelInteractionProofMode.write(
                summary: readinessHeadline,
                steps: [
                    "trip-selected",
                    "recovery-owner-assigned",
                    "flight-checkin-completed",
                    "rebook-requested-and-confirmed",
                    "stay-confirmed",
                    "arrival-note-and-transfer-locked",
                    "timeline-rebalanced-recovery-plan-published-and-lock-cycled",
                    "packing-updated",
                    "document-ready-offline-saved-and-rescue-packed",
                    "alert-owned-escalated-and-recovered"
                ]
            )
        }
    }
}

struct TravelPlannerTripsWorkspaceView: View {
    @ObservedObject var store: TravelPlannerOperationsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TravelPlannerHeroCard(store: store)
                    TravelPlannerTripPickerSection(store: store)
                    if let trip = store.selectedTrip {
                        TravelPlannerTripOverviewCard(store: store, trip: trip)
                    }
                    TravelPlannerAlertLane(store: store)
                }
                .padding(16)
            }
            .navigationTitle("Travel Planner")
        }
    }
}

struct TravelPlannerHeroCard: View {
    @ObservedObject var store: TravelPlannerOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Departure Readiness")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(store.readinessHeadline)
                .font(.system(size: 32, weight: .bold, design: .rounded))

            Text(store.operationsNote)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                TravelMetricChip(title: "Trips", value: "\(store.trips.count)")
                TravelMetricChip(title: "Checked In", value: "\(store.checkedInFlights)")
                TravelMetricChip(title: "Rescue Packs", value: "\(store.rescuePackCount)")
                TravelMetricChip(title: "Recovered", value: "\(store.incidentRecoveredCount)")
            }
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

struct TravelMetricChip: View {
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

struct TravelPlannerTripPickerSection: View {
    @ObservedObject var store: TravelPlannerOperationsStore

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(store.trips) { trip in
                    Button {
                        store.selectTrip(trip.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(trip.title)
                                .font(.headline)
                            Text("\(trip.dateRange) • \(trip.party)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(width: 220, alignment: .leading)
                        .padding()
                        .background(
                            (store.selectedTripID == trip.id ? Color.blue.opacity(0.15) : Color(.secondarySystemBackground))
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct TravelPlannerTripOverviewCard: View {
    @ObservedObject var store: TravelPlannerOperationsStore
    let trip: TravelTripRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Primary Trip")
                .font(.title3.weight(.bold))
            Text(trip.title)
                .font(.headline)
            Text("\(trip.dateRange) • \(trip.party)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Label(trip.hotel, systemImage: "bed.double.fill")
                .font(.caption)
                .foregroundStyle(.secondary)
            Label(trip.localTransport, systemImage: "tram.fill")
                .font(.caption)
                .foregroundStyle(.secondary)

            if let flight = store.nextFlight {
                HStack {
                    Button(flight.isCheckedIn ? "Checked In" : "Confirm Check-In") {
                        store.confirmCheckIn(flight.id)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(flight.isCheckedIn)

                    Button("Request Rebook") {
                        store.requestRebook(flight.id)
                    }
                    .buttonStyle(.bordered)
                }

                Text(flight.protectionState)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct TravelPlannerAlertLane: View {
    @ObservedObject var store: TravelPlannerOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Alerts")
                .font(.title3.weight(.bold))

            ForEach(store.alerts) { alert in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(alert.title)
                            .font(.headline)
                        Spacer()
                        Text(alert.isResolved ? "Resolved" : alert.type.label)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(alert.isResolved ? .green : .orange)
                    }
                    Text(alert.detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Label(alert.escalationOwner, systemImage: "person.text.rectangle.fill")
                        .font(.caption)
                    Label(alert.incidentState, systemImage: "bolt.shield.fill")
                        .font(.caption)
                    if !alert.isResolved {
                        Button("Resolve Alert") {
                            store.resolveAlert(alert.id)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

struct TravelPlannerTimelineWorkspaceView: View {
    @ObservedObject var store: TravelPlannerOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.timelineDays) { day in
                    NavigationLink {
                        TravelPlannerDayDetailView(store: store, dayID: day.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(day.title)
                                Spacer()
                                Text(day.isLocked ? "Locked" : day.weather)
                                    .font(.subheadline.weight(.semibold))
                            }
                            Text(day.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Timeline")
        }
    }
}

struct TravelPlannerDayDetailView: View {
    @ObservedObject var store: TravelPlannerOperationsStore
    let dayID: UUID

    var body: some View {
        if let day = store.timelineDays.first(where: { $0.id == dayID }) {
            List {
                Section("Day Summary") {
                    Text(day.summary)
                    Label(day.weather, systemImage: "cloud.sun.fill")
                    Label(day.isLocked ? "Locked" : "Open for changes", systemImage: day.isLocked ? "lock.fill" : "lock.open.fill")
                    Text(day.recoveryPlan)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Activities") {
                    ForEach(day.activities) { activity in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(activity.timeLabel)
                                    .font(.caption.weight(.semibold))
                                Spacer()
                                Text(activity.priority)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Text(activity.title)
                                .font(.headline)
                            Text(activity.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            if !day.isLocked {
                                Button("Move to Next Day Buffer") {
                                    store.moveActivityForward(activity.id, from: dayID)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                if !day.isLocked {
                    Section {
                        Button("Publish Recovery Plan") {
                            store.publishRecoveryPlan(dayID)
                        }
                        .buttonStyle(.bordered)

                        Button("Lock Day Plan") {
                            store.lockDayPlan(dayID)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    Section {
                        Button("Unlock For Rebalance") {
                            store.unlockDayPlan(dayID)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle(day.title)
        }
    }
}

struct TravelPlannerBookingsWorkspaceView: View {
    @ObservedObject var store: TravelPlannerOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Flights") {
                    ForEach(store.flights) { flight in
                        NavigationLink {
                            TravelPlannerFlightDetailView(store: store, flightID: flight.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(flight.route)
                                    Spacer()
                                    Text(flight.status)
                                        .font(.caption.weight(.semibold))
                                }
                                Text("\(flight.departureCode) • \(flight.departureTime)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Stays") {
                    ForEach(store.stays) { stay in
                        NavigationLink {
                            TravelPlannerStayDetailView(store: store, stayID: stay.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(stay.name)
                                    Spacer()
                                    Text(stay.confirmationState)
                                        .font(.caption.weight(.semibold))
                                }
                                Text(stay.dateRange)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bookings")
        }
    }
}

struct TravelPlannerFlightDetailView: View {
    @ObservedObject var store: TravelPlannerOperationsStore
    let flightID: UUID

    var body: some View {
        if let flight = store.flights.first(where: { $0.id == flightID }) {
            List {
                Section("Flight") {
                    LabeledContent("Route", value: flight.route)
                    LabeledContent("Departure", value: flight.departureTime)
                    LabeledContent("Seat", value: flight.seat ?? "Not assigned")
                    LabeledContent("Status", value: flight.status)
                    LabeledContent("Recovery owner", value: flight.recoveryOwner)
                    LabeledContent("Protection", value: flight.protectionState)
                    if let alternateRoute = flight.alternateRoute {
                        Text(alternateRoute)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Actions") {
                    Button(flight.isCheckedIn ? "Checked In" : "Confirm Check-In") {
                        store.confirmCheckIn(flight.id)
                    }
                    .disabled(flight.isCheckedIn)

                    Button("Assign Recovery Owner") {
                        store.assignRecoveryOwner(flight.id, owner: "Travel Ops - Elena")
                    }

                    Button("Request Rebook") {
                        store.requestRebook(flight.id)
                    }

                    if flight.status == "Rebooking requested" {
                        Button("Confirm Rebook") {
                            store.confirmRebook(flight.id)
                        }
                    }
                }
            }
            .navigationTitle("Flight")
        }
    }
}

struct TravelPlannerStayDetailView: View {
    @ObservedObject var store: TravelPlannerOperationsStore
    let stayID: UUID

    var body: some View {
        if let stay = store.stays.first(where: { $0.id == stayID }) {
            List {
                Section("Stay") {
                    LabeledContent("Hotel", value: stay.name)
                    LabeledContent("Dates", value: stay.dateRange)
                    LabeledContent("State", value: stay.confirmationState)
                    if let contingencyHotel = stay.contingencyHotel {
                        LabeledContent("Backup hotel", value: contingencyHotel)
                    }
                    LabeledContent("Transfer", value: stay.transportLocked ? "Locked" : "Needs lock")
                }

                Section("Check-In Notes") {
                    Text(stay.checkInNote)
                }

                Section {
                    Button("Confirm Stay") {
                        store.confirmStay(stay.id)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(stay.confirmationState == "Confirmed")
                    Button("Send Arrival Note") {
                        store.sendArrivalNote(stay.id)
                    }
                    .buttonStyle(.bordered)

                    Button("Lock Airport Transfer") {
                        store.lockAirportTransfer(stay.id)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .navigationTitle(stay.name)
        }
    }
}

struct TravelPlannerEssentialsWorkspaceView: View {
    @ObservedObject var store: TravelPlannerOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Packing List") {
                    ForEach(store.packingTasks) { task in
                        Button {
                            store.togglePackingTask(task.id)
                        } label: {
                            HStack {
                                Image(systemName: task.isPacked ? "checkmark.circle.fill" : "circle")
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(task.title)
                                    Text(task.note)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                Section("Documents") {
                    ForEach(store.documents) { document in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(document.title)
                                Spacer()
                                Text(document.status)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(document.isReady ? .green : .orange)
                            }
                            Text(document.note)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Label(document.rescuePackIncluded ? "Rescue pack saved" : "Rescue pack pending", systemImage: "externaldrive.badge.plus")
                                .font(.caption)
                            if !document.isReady {
                                Button("Mark Ready") {
                                    store.markDocumentReady(document.id)
                                }
                                .buttonStyle(.bordered)
                            }
                            Button("Save Offline Copy") {
                                store.downloadOfflineCopy(document.id)
                            }
                            .buttonStyle(.bordered)
                            Button("Create Rescue Pack") {
                                store.createRescuePack(document.id)
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Alerts") {
                    ForEach(store.alerts) { alert in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(alert.title)
                                Spacer()
                                Text(alert.type.label)
                                    .font(.caption.weight(.semibold))
                            }
                            Text(alert.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Label(alert.escalationOwner, systemImage: "person.text.rectangle.fill")
                                .font(.caption)
                            Label(alert.incidentState, systemImage: "bolt.shield.fill")
                                .font(.caption)
                            HStack {
                                Button("Assign Owner") { store.assignAlertOwner(alert.id, owner: "Travel Ops - Elena") }
                                Button("Escalate") { store.escalateAlert(alert.id) }
                                Button("Resolve") { store.resolveAlert(alert.id) }
                                Button("Clear Incident") { store.clearIncident(alert.id) }
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Essentials")
        }
    }
}

struct TravelPlannerProfileWorkspaceView: View {
    @ObservedObject var store: TravelPlannerOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Operations") {
                    Label("Checked-in flights: \(store.checkedInFlights)", systemImage: "airplane.circle.fill")
                    Label("Packed tasks: \(store.packedTasks)", systemImage: "suitcase.rolling.fill")
                    Label("Ready documents: \(store.verifiedDocuments)", systemImage: "doc.text.fill")
                    Label("Rescue packs: \(store.rescuePackCount)", systemImage: "externaldrive.badge.plus")
                    Label("Recovered incidents: \(store.incidentRecoveredCount)", systemImage: "checkmark.shield.fill")
                }

                Section("Policy") {
                    Text(store.operationsNote)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct TravelTripRecord: Identifiable {
    let id = UUID()
    let title: String
    let dateRange: String
    let party: String
    let hotel: String
    let localTransport: String

    static let sampleTrips: [TravelTripRecord] = [
        TravelTripRecord(title: "Barcelona Client Summit", dateRange: "May 3-7", party: "3 travelers", hotel: "Grand Central Barcelona", localTransport: "Airport pickup + metro pass"),
        TravelTripRecord(title: "Berlin Product Sprint", dateRange: "May 20-24", party: "2 travelers", hotel: "Hotel Oderberger", localTransport: "Rail + shared shuttle")
    ]
}

struct TravelTimelineDayRecord: Identifiable {
    let id = UUID()
    let title: String
    let weather: String
    var summary: String
    var isLocked: Bool
    var recoveryPlan: String
    var activities: [TravelActivityRecord]

    static let sampleDays: [TravelTimelineDayRecord] = [
        TravelTimelineDayRecord(
            title: "Day 1 • Arrival",
            weather: "21°C",
            summary: "Arrival, hotel check-in, and first partner dinner are still adjustable.",
            isLocked: false,
            recoveryPlan: "Keep airport pickup, hotel arrival, and dinner buffer flexible until flight stability is confirmed.",
            activities: [
                TravelActivityRecord(timeLabel: "09:20", title: "Arrive BCN", detail: "Airport pickup meets terminal 1 baggage claim.", priority: "Critical"),
                TravelActivityRecord(timeLabel: "13:30", title: "Hotel check-in", detail: "Drop bags, test Wi-Fi, confirm concierge late-night key support.", priority: "High"),
                TravelActivityRecord(timeLabel: "19:00", title: "Partner dinner", detail: "Opening dinner with summit hosts and product stakeholders.", priority: "Medium")
            ]
        ),
        TravelTimelineDayRecord(
            title: "Day 2 • Summit",
            weather: "24°C",
            summary: "Full summit day with extra buffer for customer breakout sessions.",
            isLocked: false,
            recoveryPlan: "Protect keynote and breakout blocks with one movable customer session and backup transit window.",
            activities: [
                TravelActivityRecord(timeLabel: "08:30", title: "Keynote prep", detail: "Check slides, audio, and badge logistics before doors open.", priority: "Critical"),
                TravelActivityRecord(timeLabel: "15:00", title: "Customer breakout", detail: "Run operator notes and success stories with CS leads.", priority: "High")
            ]
        )
    ]
}

struct TravelActivityRecord: Identifiable {
    let id = UUID()
    let timeLabel: String
    let title: String
    let detail: String
    let priority: String
}

struct TravelFlightRecord: Identifiable {
    let id = UUID()
    let route: String
    let departureCode: String
    var departureTime: String
    var seat: String?
    var status: String
    var isCheckedIn: Bool
    var recoveryOwner: String
    var alternateRoute: String?
    var protectionState: String

    static let sampleFlights: [TravelFlightRecord] = [
        TravelFlightRecord(route: "IST → BCN", departureCode: "TK1853", departureTime: "May 3 • 06:40", seat: nil, status: "Awaiting check-in", isCheckedIn: false, recoveryOwner: "Unassigned", alternateRoute: nil, protectionState: "Awaiting protection review"),
        TravelFlightRecord(route: "BCN → IST", departureCode: "TK1856", departureTime: "May 7 • 18:15", seat: "10C", status: "Confirmed", isCheckedIn: true, recoveryOwner: "Travel Ops - Elena", alternateRoute: nil, protectionState: "Return segment protected")
    ]
}

struct TravelStayRecord: Identifiable {
    let id = UUID()
    let name: String
    let dateRange: String
    var confirmationState: String
    var checkInNote: String
    var contingencyHotel: String?
    var transportLocked: Bool

    static let sampleStays: [TravelStayRecord] = [
        TravelStayRecord(name: "Grand Central Barcelona", dateRange: "May 3-7", confirmationState: "Pending operator reconfirmation", checkInNote: "Late arrival note still needs concierge confirmation.", contingencyHotel: "Hotel Rec Barcelona", transportLocked: false)
    ]
}

struct TravelPackingTaskRecord: Identifiable {
    let id = UUID()
    let title: String
    let note: String
    var isPacked: Bool

    static let sampleTasks: [TravelPackingTaskRecord] = [
        TravelPackingTaskRecord(title: "Passport + backup copy", note: "Carry-on pocket and offline backup in Files.", isPacked: true),
        TravelPackingTaskRecord(title: "Presentation adapter kit", note: "USB-C hub, HDMI backup, and portable clicker.", isPacked: false),
        TravelPackingTaskRecord(title: "Medication pouch", note: "Jet lag and allergy pack for whole party.", isPacked: false)
    ]
}

struct TravelDocumentRecord: Identifiable {
    let id = UUID()
    let title: String
    var status: String
    let note: String
    var isReady: Bool
    var rescuePackIncluded: Bool

    static let sampleDocuments: [TravelDocumentRecord] = [
        TravelDocumentRecord(title: "Passport validity", status: "Ready", note: "All travelers above 6-month validity window.", isReady: true, rescuePackIncluded: true),
        TravelDocumentRecord(title: "Hotel confirmation PDF", status: "Missing backup copy", note: "Export offline copy for concierge and pickup vendor.", isReady: false, rescuePackIncluded: false),
        TravelDocumentRecord(title: "Customer summit badge QR", status: "Pending organizer resend", note: "Organizer promised reissue before departure.", isReady: false, rescuePackIncluded: false)
    ]
}

enum TravelAlertType {
    case checkIn
    case disruption
    case document

    var label: String {
        switch self {
        case .checkIn: return "Check-in"
        case .disruption: return "Disruption"
        case .document: return "Document"
        }
    }
}

struct TravelAlertRecord: Identifiable {
    let id = UUID()
    let title: String
    var detail: String
    let type: TravelAlertType
    let linkedFlightID: UUID?
    let linkedDocumentID: UUID?
    var escalationOwner: String
    var incidentState: String
    var isResolved: Bool

    init(
        title: String,
        detail: String,
        type: TravelAlertType,
        linkedFlightID: UUID? = nil,
        linkedDocumentID: UUID? = nil,
        escalationOwner: String = "Unassigned",
        incidentState: String = "Open",
        isResolved: Bool
    ) {
        self.title = title
        self.detail = detail
        self.type = type
        self.linkedFlightID = linkedFlightID
        self.linkedDocumentID = linkedDocumentID
        self.escalationOwner = escalationOwner
        self.incidentState = incidentState
        self.isResolved = isResolved
    }

    static let sampleAlerts: [TravelAlertRecord] = {
        let flights = TravelFlightRecord.sampleFlights
        let documents = TravelDocumentRecord.sampleDocuments
        return [
            TravelAlertRecord(title: "Open airline check-in", detail: "Check-in opens tonight for IST → BCN. Seat assignment still missing.", type: .checkIn, linkedFlightID: flights[0].id, escalationOwner: "Travel Ops - Elena", incidentState: "Open", isResolved: false),
            TravelAlertRecord(title: "Badge QR missing", detail: "Organizer has not resent the summit badge pack yet.", type: .document, linkedDocumentID: documents[2].id, escalationOwner: "Event Desk", incidentState: "Open", isResolved: false)
        ]
    }()
}
