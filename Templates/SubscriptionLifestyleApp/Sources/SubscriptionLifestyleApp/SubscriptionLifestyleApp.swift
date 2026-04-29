import SwiftUI
import SubscriptionLifestyleAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct SubscriptionLifestyleAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            SubscriptionLifestyleRuntimeRootView()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestyleRuntimeRootView: View {
    @StateObject private var store = SubscriptionLifestyleOperationsStore()

    var body: some View {
        TabView {
            SubscriptionLifestyleDashboardView(store: store)
                .tabItem {
                    Image(systemName: "sun.max.fill")
                    Text("Dashboard")
                }

            SubscriptionLifestyleProgramsView(store: store)
                .tabItem {
                    Image(systemName: "figure.run.circle")
                    Text("Programs")
                }

            SubscriptionLifestyleStreaksView(store: store)
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("Streaks")
                }

            SubscriptionLifestylePlansView(store: store)
                .tabItem {
                    Image(systemName: "creditcard.circle.fill")
                    Text("Plans")
                }

            SubscriptionLifestyleProfileView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.pink)
    }
}

@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class SubscriptionLifestyleOperationsStore: ObservableObject {
    @Published var programs: [SubscriptionProgramRecord]
    @Published var risks: [SubscriptionRiskRecord]
    @Published var streaks: [SubscriptionStreakRecord]
    @Published var plans: [SubscriptionPlanRecord]
    @Published var experiments: [SubscriptionExperimentRecord]
    @Published var operatorHeadline: String
    @Published var paywallTrack: String
    @Published var totalMembers: Int

    init(
        programs: [SubscriptionProgramRecord] = SubscriptionProgramRecord.samples,
        risks: [SubscriptionRiskRecord] = SubscriptionRiskRecord.samples,
        streaks: [SubscriptionStreakRecord] = SubscriptionStreakRecord.samples,
        plans: [SubscriptionPlanRecord] = SubscriptionPlanRecord.samples,
        experiments: [SubscriptionExperimentRecord] = SubscriptionExperimentRecord.samples,
        operatorHeadline: String = "Annual upgrade momentum depends on faster streak recovery this week.",
        paywallTrack: String = "Annual plan lift target: +9%",
        totalMembers: Int = 1842
    ) {
        self.programs = programs
        self.risks = risks
        self.streaks = streaks
        self.plans = plans
        self.experiments = experiments
        self.operatorHeadline = operatorHeadline
        self.paywallTrack = paywallTrack
        self.totalMembers = totalMembers
    }

    func enroll(_ programID: UUID) {
        guard let index = programs.firstIndex(where: { $0.id == programID }) else { return }
        programs[index].status = .enrolled
        programs[index].nextStep = "Enrollment recorded and welcome sequence sent."
        operatorHeadline = "Member enrolled into \(programs[index].title)."
    }

    func completeSession(_ programID: UUID) {
        guard let programIndex = programs.firstIndex(where: { $0.id == programID }) else { return }
        programs[programIndex].status = .active
        programs[programIndex].nextStep = "Session completed; next milestone is now unlocked."
        if let streakIndex = streaks.firstIndex(where: { $0.programTitle == programs[programIndex].title }) {
            streaks[streakIndex].days += 1
            streaks[streakIndex].status = .healthy
        }
        operatorHeadline = "\(programs[programIndex].title) session completed and streak extended."
    }

    func recoverRisk(_ riskID: UUID) {
        guard let index = risks.firstIndex(where: { $0.id == riskID }) else { return }
        risks[index].status = .offerSent
        risks[index].nextAction = "Save offer sent with a paused-billing recovery path."
        operatorHeadline = "Recovery offer sent to \(risks[index].name)."
    }

    func resolveRisk(_ riskID: UUID) {
        guard let index = risks.firstIndex(where: { $0.id == riskID }) else { return }
        risks[index].status = .saved
        risks[index].nextAction = "Member recovered and returned to the healthy journey."
        operatorHeadline = "\(risks[index].name) recovered and returned to the program."
    }

    func recoverStreak(_ streakID: UUID) {
        guard let index = streaks.firstIndex(where: { $0.id == streakID }) else { return }
        streaks[index].days += 2
        streaks[index].status = .healthy
        operatorHeadline = "\(streaks[index].programTitle) streak recovered."
    }

    func switchPlan(_ planID: UUID) {
        for index in plans.indices {
            plans[index].isCurrent = plans[index].id == planID
        }
        if let current = plans.first(where: { $0.id == planID }) {
            operatorHeadline = "Primary plan switched to \(current.name)."
        }
    }

    func launchExperiment(_ experimentID: UUID) {
        guard let index = experiments.firstIndex(where: { $0.id == experimentID }) else { return }
        experiments[index].status = .running
        operatorHeadline = "\(experiments[index].title) experiment launched."
    }

    func closeExperiment(_ experimentID: UUID) {
        guard let index = experiments.firstIndex(where: { $0.id == experimentID }) else { return }
        experiments[index].status = .won
        operatorHeadline = "\(experiments[index].title) experiment closed as winner."
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestyleDashboardView: View {
    @ObservedObject var store: SubscriptionLifestyleOperationsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SubscriptionHeroCard(store: store)
                    HStack(spacing: 12) {
                        SubscriptionMetricChip(title: "Members", value: "\(store.totalMembers)")
                        SubscriptionMetricChip(title: "Programs", value: "\(store.programs.count)")
                        SubscriptionMetricChip(title: "At Risk", value: "\(store.risks.filter { $0.status != .saved }.count)")
                    }
                    SubscriptionProgramLane(store: store)
                    SubscriptionRecoveryLane(store: store)
                    SubscriptionExperimentLane(store: store)
                }
                .padding(16)
            }
            .navigationTitle("Lifestyle")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionHeroCard: View {
    @ObservedObject var store: SubscriptionLifestyleOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Membership Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text(store.operatorHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(store.paywallTrack)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.pink.opacity(0.16), .purple.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionMetricChip: View {
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
struct SubscriptionProgramLane: View {
    @ObservedObject var store: SubscriptionLifestyleOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Programs")
                .font(.title3.weight(.bold))
            ForEach(store.programs) { program in
                NavigationLink {
                    SubscriptionProgramDetailView(store: store, programID: program.id)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(program.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(program.status.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(program.status.color)
                        }
                        Text(program.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(program.nextStep)
                            .font(.caption)
                            .foregroundStyle(.secondary)
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
struct SubscriptionRecoveryLane: View {
    @ObservedObject var store: SubscriptionLifestyleOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recovery Queue")
                .font(.title3.weight(.bold))
            ForEach(store.risks) { risk in
                NavigationLink {
                    SubscriptionRiskDetailView(store: store, riskID: risk.id)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(risk.name)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(risk.status.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(risk.status.color)
                        }
                        Text(risk.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(risk.nextAction)
                            .font(.caption)
                            .foregroundStyle(.secondary)
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
struct SubscriptionExperimentLane: View {
    @ObservedObject var store: SubscriptionLifestyleOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Experiments")
                .font(.title3.weight(.bold))
            ForEach(store.experiments) { experiment in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(experiment.title)
                            .font(.headline)
                        Spacer()
                        Text(experiment.status.label)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(experiment.status.color)
                    }
                    Text(experiment.summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if experiment.status == .draft {
                        Button("Launch Experiment") { store.launchExperiment(experiment.id) }
                    } else if experiment.status == .running {
                        Button("Close As Winner") { store.closeExperiment(experiment.id) }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestyleProgramsView: View {
    @ObservedObject var store: SubscriptionLifestyleOperationsStore

    var body: some View {
        NavigationStack {
            List(store.programs) { program in
                NavigationLink {
                    SubscriptionProgramDetailView(store: store, programID: program.id)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(program.title)
                            Spacer()
                            Text(program.status.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(program.status.color)
                        }
                        Text(program.nextStep)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Programs")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestyleStreaksView: View {
    @ObservedObject var store: SubscriptionLifestyleOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.streaks) { streak in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(streak.programTitle)
                            Spacer()
                            Text("\(streak.days) days")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(streak.status.color)
                        }
                        Text(streak.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Button("Recover Streak") { store.recoverStreak(streak.id) }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Streaks")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestylePlansView: View {
    @ObservedObject var store: SubscriptionLifestyleOperationsStore

    var body: some View {
        NavigationStack {
            List(store.plans) { plan in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(plan.name)
                        Spacer()
                        if plan.isCurrent {
                            Text("Current")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.green)
                        }
                    }
                    Text(plan.price)
                        .font(.headline)
                    Text(plan.summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if !plan.isCurrent {
                        Button("Switch To This Plan") { store.switchPlan(plan.id) }
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Plans")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestyleProfileView: View {
    @ObservedObject var store: SubscriptionLifestyleOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Operator") {
                    Label("Avery Quinn", systemImage: "person.crop.circle.fill")
                    Label(store.paywallTrack, systemImage: "chart.line.uptrend.xyaxis")
                }
                Section("Metrics") {
                    Label("\(store.totalMembers) active members", systemImage: "person.3.fill")
                    Label("\(store.programs.filter { $0.status == .active }.count) live programs", systemImage: "figure.run.circle.fill")
                    Label("\(store.experiments.filter { $0.status == .running }.count) running experiments", systemImage: "testtube.2")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionProgramDetailView: View {
    @ObservedObject var store: SubscriptionLifestyleOperationsStore
    let programID: UUID

    var body: some View {
        if let program = store.programs.first(where: { $0.id == programID }) {
            List {
                Section("Program") {
                    Text(program.title)
                        .font(.title3.weight(.bold))
                    Text(program.summary)
                        .foregroundStyle(.secondary)
                    Text(program.nextStep)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Section("Actions") {
                    if program.status == .draft {
                        Button("Enroll Member") { store.enroll(program.id) }
                    }
                    Button("Complete Session") { store.completeSession(program.id) }
                }
            }
            .navigationTitle("Program")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionRiskDetailView: View {
    @ObservedObject var store: SubscriptionLifestyleOperationsStore
    let riskID: UUID

    var body: some View {
        if let risk = store.risks.first(where: { $0.id == riskID }) {
            List {
                Section("Member") {
                    Text(risk.name)
                        .font(.title3.weight(.bold))
                    Text(risk.summary)
                        .foregroundStyle(.secondary)
                    Text(risk.nextAction)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Section("Actions") {
                    if risk.status == .open {
                        Button("Send Save Offer") { store.recoverRisk(risk.id) }
                    }
                    if risk.status == .offerSent {
                        Button("Mark As Recovered") { store.resolveRisk(risk.id) }
                    }
                }
            }
            .navigationTitle("Recovery")
        }
    }
}

enum SubscriptionProgramStatus: String, Hashable {
    case draft
    case enrolled
    case active

    var label: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .draft: return .orange
        case .enrolled: return .blue
        case .active: return .green
        }
    }
}

struct SubscriptionProgramRecord: Identifiable, Hashable {
    let id: UUID
    let title: String
    let summary: String
    var nextStep: String
    var status: SubscriptionProgramStatus

    static let samples: [SubscriptionProgramRecord] = [
        SubscriptionProgramRecord(id: UUID(), title: "Morning Reset", summary: "Hydration, journaling and movement prompts for consistency.", nextStep: "Push coach recap to members who missed two sessions.", status: .active),
        SubscriptionProgramRecord(id: UUID(), title: "Wellness Streak", summary: "Progressive habit sequence built around recovery and momentum.", nextStep: "Test updated streak recovery message against day-three inactive members.", status: .enrolled),
        SubscriptionProgramRecord(id: UUID(), title: "Premium Coaching", summary: "Private weekly review and deeper accountability path.", nextStep: "Prepare annual upgrade path for high-adherence members.", status: .draft)
    ]
}

enum SubscriptionRiskStatus: String, Hashable {
    case open
    case offerSent
    case saved

    var label: String {
        switch self {
        case .open: return "Open"
        case .offerSent: return "Offer Sent"
        case .saved: return "Saved"
        }
    }

    var color: Color {
        switch self {
        case .open: return .red
        case .offerSent: return .orange
        case .saved: return .green
        }
    }
}

struct SubscriptionRiskRecord: Identifiable, Hashable {
    let id: UUID
    let name: String
    let summary: String
    var nextAction: String
    var status: SubscriptionRiskStatus

    static let samples: [SubscriptionRiskRecord] = [
        SubscriptionRiskRecord(id: UUID(), name: "Nadia Torres", summary: "Missed three sessions and abandoned annual upgrade at checkout.", nextAction: "Offer a 14-day reset path plus paused billing option.", status: .open),
        SubscriptionRiskRecord(id: UUID(), name: "Owen Reed", summary: "Progress stalled after day six and recap open rate fell sharply.", nextAction: "Send coach prompt and shorten the next milestone challenge.", status: .offerSent)
    ]
}

enum SubscriptionStreakStatus: String, Hashable {
    case healthy
    case watch

    var color: Color {
        switch self {
        case .healthy: return .green
        case .watch: return .orange
        }
    }
}

struct SubscriptionStreakRecord: Identifiable, Hashable {
    let id: UUID
    let programTitle: String
    var days: Int
    let summary: String
    var status: SubscriptionStreakStatus

    static let samples: [SubscriptionStreakRecord] = [
        SubscriptionStreakRecord(id: UUID(), programTitle: "Morning Reset", days: 21, summary: "Day 21 members convert to annual at the strongest rate.", status: .healthy),
        SubscriptionStreakRecord(id: UUID(), programTitle: "Wellness Streak", days: 14, summary: "Recovery around day 14 protects month-two retention.", status: .watch)
    ]
}

struct SubscriptionPlanRecord: Identifiable, Hashable {
    let id: UUID
    let name: String
    let price: String
    let summary: String
    var isCurrent: Bool

    static let samples: [SubscriptionPlanRecord] = [
        SubscriptionPlanRecord(id: UUID(), name: "Monthly Momentum", price: "$14.99/mo", summary: "Core routines, streak tracking and weekly recaps.", isCurrent: true),
        SubscriptionPlanRecord(id: UUID(), name: "Annual Reset", price: "$119/yr", summary: "Full plan access, retention bonuses and deeper coach touchpoints.", isCurrent: false),
        SubscriptionPlanRecord(id: UUID(), name: "Coaching Plus", price: "$39.99/mo", summary: "Private coaching reviews and personalized program tuning.", isCurrent: false)
    ]
}

enum SubscriptionExperimentStatus: String, Hashable {
    case draft
    case running
    case won

    var label: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .draft: return .secondary
        case .running: return .blue
        case .won: return .green
        }
    }
}

struct SubscriptionExperimentRecord: Identifiable, Hashable {
    let id: UUID
    let title: String
    let summary: String
    var status: SubscriptionExperimentStatus

    static let samples: [SubscriptionExperimentRecord] = [
        SubscriptionExperimentRecord(id: UUID(), title: "Annual hero copy", summary: "Commitment-framed annual paywall headline vs control.", status: .draft),
        SubscriptionExperimentRecord(id: UUID(), title: "Pause instead of cancel", summary: "Save path that offers paused billing before churn.", status: .running)
    ]
}
