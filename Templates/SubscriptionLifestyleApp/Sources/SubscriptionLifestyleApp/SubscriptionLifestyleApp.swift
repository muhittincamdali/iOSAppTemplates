import SwiftUI
import SubscriptionLifestyleAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct SubscriptionLifestyleAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            SubscriptionLifestyleWorkspaceRootView(
                snapshot: .sample,
                programs: SubscriptionLifestyleProgramCard.sampleCards,
                actions: SubscriptionLifestyleQuickAction.defaultActions,
                health: .sample,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestyleWorkspaceRootView: View {
    let snapshot: SubscriptionLifestyleDashboardSnapshot
    let programs: [SubscriptionLifestyleProgramCard]
    let actions: [SubscriptionLifestyleQuickAction]
    let health: SubscriptionLifestyleOperationalHealth
    let state: SubscriptionLifestyleWorkspaceState

    var body: some View {
        TabView {
            SubscriptionLifestyleDashboardView(
                snapshot: snapshot,
                programs: programs,
                actions: actions,
                health: health,
                state: state
            )
            .tabItem {
                Image(systemName: "sun.max.fill")
                Text("Dashboard")
            }

            SubscriptionLifestyleProgramsView(state: state)
                .tabItem {
                    Image(systemName: "figure.run.circle")
                    Text("Programs")
                }

            SubscriptionLifestyleStreaksView(state: state)
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("Streaks")
                }

            SubscriptionLifestylePlansView(state: state)
                .tabItem {
                    Image(systemName: "creditcard.circle.fill")
                    Text("Plans")
                }

            SubscriptionLifestyleProfileView(snapshot: snapshot, health: health, state: state)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.pink)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestyleDashboardView: View {
    let snapshot: SubscriptionLifestyleDashboardSnapshot
    let programs: [SubscriptionLifestyleProgramCard]
    let actions: [SubscriptionLifestyleQuickAction]
    let health: SubscriptionLifestyleOperationalHealth
    let state: SubscriptionLifestyleWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SubscriptionLifestyleHeroCard(snapshot: snapshot, health: health, state: state)
                    SubscriptionLifestyleQuickActionGrid(actions: actions)
                    SubscriptionLifestyleFeaturedProgramsCard(programs: state.featuredPrograms)
                    SubscriptionLifestyleRecoveryCard(state: state)
                    SubscriptionLifestyleMomentumCard(programs: programs)
                }
                .padding(16)
            }
            .navigationTitle("Lifestyle")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestyleHeroCard: View {
    let snapshot: SubscriptionLifestyleDashboardSnapshot
    let health: SubscriptionLifestyleOperationalHealth
    let state: SubscriptionLifestyleWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Membership Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(state.membershipHeadline)
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text(snapshot.membershipHealth)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                SubscriptionLifestyleMetricChip(title: "Members", value: "\(snapshot.activeMembers)")
                SubscriptionLifestyleMetricChip(title: "Programs", value: "\(snapshot.streakPrograms)")
                SubscriptionLifestyleMetricChip(title: "Churn Risks", value: "\(snapshot.churnRisks)")
            }

            HStack {
                Label(state.focusWindow, systemImage: "clock.fill")
                Spacer()
                Text(state.paywallTrack)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.pink)
            }
            .font(.caption)
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
struct SubscriptionLifestyleMetricChip: View {
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
struct SubscriptionLifestyleQuickActionGrid: View {
    let actions: [SubscriptionLifestyleQuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions) { action in
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: action.systemImage)
                            .font(.title3)
                            .foregroundStyle(.pink)
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
struct SubscriptionLifestyleFeaturedProgramsCard: View {
    let programs: [SubscriptionLifestyleProgram]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Programs")
                .font(.title3.weight(.bold))

            ForEach(programs) { program in
                NavigationLink {
                    SubscriptionLifestyleProgramDetailView(program: program)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(program.title)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text("\(program.coach) - \(program.schedule)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(program.retentionLabel)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.pink)
                        }
                        Text(program.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
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
struct SubscriptionLifestyleRecoveryCard: View {
    let state: SubscriptionLifestyleWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recovery Queue")
                .font(.title3.weight(.bold))

            HStack(spacing: 12) {
                SubscriptionLifestyleOperationTile(title: "Watchlist", value: "\(state.recoveryWatchlist.count)")
                SubscriptionLifestyleOperationTile(title: "Save Offers", value: "\(state.saveOffers)")
                SubscriptionLifestyleOperationTile(title: "Avg Winback", value: state.winbackWindow)
            }

            ForEach(state.recoveryWatchlist) { member in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(member.name)
                            .font(.headline)
                        Spacer()
                        Text(member.riskLevel)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(member.riskColor)
                    }
                    Text(member.summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(member.nextAction)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestyleOperationTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.headline.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestyleMomentumCard: View {
    let programs: [SubscriptionLifestyleProgramCard]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Program Momentum")
                .font(.title3.weight(.bold))

            ForEach(programs) { program in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(program.title)
                            .font(.headline)
                        Text(program.ctaLabel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("\(program.participantCount)")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.pink)
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
    let state: SubscriptionLifestyleWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                ForEach(state.allPrograms) { program in
                    NavigationLink {
                        SubscriptionLifestyleProgramDetailView(program: program)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(program.title)
                                Spacer()
                                Text(program.retentionLabel)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.pink)
                            }
                            Text("\(program.coach) - \(program.schedule)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(program.summary)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Programs")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestyleStreaksView: View {
    let state: SubscriptionLifestyleWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Top Streaks") {
                    ForEach(state.streaks) { streak in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(streak.programTitle)
                                Spacer()
                                Text("\(streak.days) days")
                                    .font(.subheadline.weight(.bold))
                            }
                            Text(streak.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            ProgressView(value: streak.progress)
                                .tint(.pink)
                        }
                    }
                }

                Section("Milestones") {
                    ForEach(state.milestones, id: \.self) { milestone in
                        Label(milestone, systemImage: "flag.checkered")
                    }
                }
            }
            .navigationTitle("Streaks")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestylePlansView: View {
    let state: SubscriptionLifestyleWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Plans") {
                    ForEach(state.plans) { plan in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(plan.name)
                                Spacer()
                                Text(plan.price)
                                    .font(.subheadline.weight(.bold))
                            }
                            Text(plan.summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(plan.offer)
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(.pink)
                        }
                    }
                }

                Section("Paywall Tests") {
                    ForEach(state.paywallExperiments, id: \.self) { experiment in
                        Label(experiment, systemImage: "chart.xyaxis.line")
                    }
                }
            }
            .navigationTitle("Plans")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestyleProfileView: View {
    let snapshot: SubscriptionLifestyleDashboardSnapshot
    let health: SubscriptionLifestyleOperationalHealth
    let state: SubscriptionLifestyleWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Operator") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(state.operatorName)
                            .font(.headline)
                        Text(state.roleSummary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Label(state.focusWindow, systemImage: "person.3.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Membership Health") {
                    Label("Active members: \(snapshot.activeMembers)", systemImage: "person.2.fill")
                    Label("Churn watch queue: \(health.churnWatchQueue)", systemImage: "person.crop.circle.badge.xmark")
                    Label("Paywall ready: \(health.paywallReady ? "Yes" : "No")", systemImage: "creditcard.circle.fill")
                }

                Section("Metrics") {
                    ForEach(state.profileMetrics, id: \.label) { metric in
                        HStack {
                            Text(metric.label)
                            Spacer()
                            Text(metric.value)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.pink)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct SubscriptionLifestyleProgramDetailView: View {
    let program: SubscriptionLifestyleProgram

    var body: some View {
        List {
            Section("Program") {
                Text(program.title)
                    .font(.headline)
                Text(program.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Delivery") {
                Label(program.coach, systemImage: "person.fill")
                Label(program.schedule, systemImage: "calendar")
                Label(program.retentionLabel, systemImage: "arrow.triangle.2.circlepath.circle.fill")
            }

            Section("Next Step") {
                Text(program.nextStep)
                    .font(.body)
            }
        }
        .navigationTitle(program.title)
    }
}

public struct SubscriptionLifestyleQuickAction: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let systemImage: String
    public let detail: String

    public init(
        id: UUID = UUID(),
        title: String,
        systemImage: String,
        detail: String
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.detail = detail
    }

    public static let defaultActions: [SubscriptionLifestyleQuickAction] = [
        SubscriptionLifestyleQuickAction(
            title: "Review Churn Watchlist",
            systemImage: "person.crop.circle.badge.xmark",
            detail: "Prioritize members with habit drops, failed renewals and declining session depth."
        ),
        SubscriptionLifestyleQuickAction(
            title: "Open Paywall Experiments",
            systemImage: "creditcard.circle.fill",
            detail: "Inspect intro-offer conversion, annual plan pull-forward and checkout friction tests."
        ),
        SubscriptionLifestyleQuickAction(
            title: "Inspect Habit Ladder",
            systemImage: "chart.bar.doc.horizontal.fill",
            detail: "See which programs move members from day-one activation to week-four retention."
        ),
        SubscriptionLifestyleQuickAction(
            title: "Prep Save Offer",
            systemImage: "giftcard.fill",
            detail: "Launch targeted retention offers for streak members who show payment hesitation."
        )
    ]
}

struct SubscriptionLifestyleWorkspaceState: Hashable, Sendable {
    let membershipHeadline: String
    let operatorName: String
    let roleSummary: String
    let paywallTrack: String
    let focusWindow: String
    let saveOffers: String
    let winbackWindow: String
    let featuredPrograms: [SubscriptionLifestyleProgram]
    let allPrograms: [SubscriptionLifestyleProgram]
    let recoveryWatchlist: [SubscriptionLifestyleMemberRisk]
    let streaks: [SubscriptionLifestyleStreak]
    let milestones: [String]
    let plans: [SubscriptionLifestylePlan]
    let paywallExperiments: [String]
    let profileMetrics: [SubscriptionLifestyleMetric]

    static let sample = SubscriptionLifestyleWorkspaceState(
        membershipHeadline: "Retention is holding, but annual upgrade momentum depends on stronger streak continuity this week.",
        operatorName: "Avery Quinn",
        roleSummary: "Growth and retention lead for subscription lifestyle programs and premium habit journeys",
        paywallTrack: "Annual plan lift target: +9%",
        focusWindow: "7-day activation and 30-day retention review",
        saveOffers: "12 live offers",
        winbackWindow: "6h median",
        featuredPrograms: [
            SubscriptionLifestyleProgram(
                title: "Morning Reset",
                coach: "Lena Moss",
                schedule: "Daily 07:00 check-in",
                retentionLabel: "82% week-4 retention",
                summary: "A short guided reset that combines hydration, journaling and movement prompts.",
                nextStep: "Push coach recap to users who missed two sessions this week."
            ),
            SubscriptionLifestyleProgram(
                title: "Wellness Streak",
                coach: "Kai Mercer",
                schedule: "5-day momentum ladder",
                retentionLabel: "Top growth loop",
                summary: "A progressive habit sequence that nudges members from onboarding to paid consistency.",
                nextStep: "Test the updated streak recovery message against inactive day-three members."
            ),
            SubscriptionLifestyleProgram(
                title: "Premium Coaching",
                coach: "Dr. Mira Holt",
                schedule: "Weekly private review",
                retentionLabel: "High ARPU tier",
                summary: "High-touch coaching for members who need accountability and personalized plans.",
                nextStep: "Prepare upgrade path for annual members with high adherence scores."
            )
        ],
        allPrograms: [
            SubscriptionLifestyleProgram(
                title: "Morning Reset",
                coach: "Lena Moss",
                schedule: "Daily 07:00 check-in",
                retentionLabel: "82% week-4 retention",
                summary: "Guided wake-up routine built for consistency before work.",
                nextStep: "Refresh onboarding tips for new starts tomorrow."
            ),
            SubscriptionLifestyleProgram(
                title: "Wellness Streak",
                coach: "Kai Mercer",
                schedule: "5-day momentum ladder",
                retentionLabel: "Top growth loop",
                summary: "Habit reinforcement track with recoveries and milestone rewards.",
                nextStep: "Ship updated streak nudges to the at-risk cohort."
            ),
            SubscriptionLifestyleProgram(
                title: "Premium Coaching",
                coach: "Dr. Mira Holt",
                schedule: "Weekly private review",
                retentionLabel: "High ARPU tier",
                summary: "Personal coaching journey with premium accountability and weekly plans.",
                nextStep: "Lock renewal offer copy before Friday."
            )
        ],
        recoveryWatchlist: [
            SubscriptionLifestyleMemberRisk(
                name: "Nadia Torres",
                riskLevel: "High Risk",
                summary: "Missed three sessions and abandoned annual upgrade at checkout.",
                nextAction: "Offer a 14-day reset path plus paused billing option.",
                riskColorName: "red"
            ),
            SubscriptionLifestyleMemberRisk(
                name: "Owen Reed",
                riskLevel: "Watch",
                summary: "Progress stalled after day six and weekly recap open rate fell sharply.",
                nextAction: "Send coach prompt and shorten the next milestone challenge.",
                riskColorName: "orange"
            )
        ],
        streaks: [
            SubscriptionLifestyleStreak(
                programTitle: "Morning Reset",
                days: 21,
                summary: "Members who cross day 21 convert to annual at the strongest rate.",
                progress: 0.72
            ),
            SubscriptionLifestyleStreak(
                programTitle: "Wellness Streak",
                days: 14,
                summary: "Day-14 completions correlate with lower churn through month two.",
                progress: 0.58
            )
        ],
        milestones: [
            "Day 7 reflection completion rate is up 11%.",
            "Annual upsell entry screen beat the control in two cohorts.",
            "Coach-led recovery prompts now trigger within 30 minutes."
        ],
        plans: [
            SubscriptionLifestylePlan(
                name: "Monthly Momentum",
                price: "$14.99/mo",
                summary: "Access to all core routines, streak tracking and weekly recaps.",
                offer: "Best for activation cohorts"
            ),
            SubscriptionLifestylePlan(
                name: "Annual Reset",
                price: "$119/yr",
                summary: "Full plan access, retention bonuses and deeper coach touchpoints.",
                offer: "Save 34% with annual billing"
            ),
            SubscriptionLifestylePlan(
                name: "Coaching Plus",
                price: "$39.99/mo",
                summary: "Includes private coaching reviews and personalized program tuning.",
                offer: "Top-tier ARPU plan"
            )
        ],
        paywallExperiments: [
            "Annual plan hero against commitment-framed copy",
            "Coach intro video in checkout preface",
            "Pause instead of cancel save path"
        ],
        profileMetrics: [
            SubscriptionLifestyleMetric(label: "Monthly recurring revenue", value: "$92K"),
            SubscriptionLifestyleMetric(label: "Annual conversion", value: "18.4%"),
            SubscriptionLifestyleMetric(label: "30-day retention", value: "71%")
        ]
    )
}

struct SubscriptionLifestyleProgram: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let coach: String
    let schedule: String
    let retentionLabel: String
    let summary: String
    let nextStep: String

    init(
        id: UUID = UUID(),
        title: String,
        coach: String,
        schedule: String,
        retentionLabel: String,
        summary: String,
        nextStep: String
    ) {
        self.id = id
        self.title = title
        self.coach = coach
        self.schedule = schedule
        self.retentionLabel = retentionLabel
        self.summary = summary
        self.nextStep = nextStep
    }
}

struct SubscriptionLifestyleMemberRisk: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let riskLevel: String
    let summary: String
    let nextAction: String
    let riskColorName: String

    init(
        id: UUID = UUID(),
        name: String,
        riskLevel: String,
        summary: String,
        nextAction: String,
        riskColorName: String
    ) {
        self.id = id
        self.name = name
        self.riskLevel = riskLevel
        self.summary = summary
        self.nextAction = nextAction
        self.riskColorName = riskColorName
    }

    var riskColor: Color {
        switch riskColorName {
        case "red":
            return .red
        case "orange":
            return .orange
        default:
            return .green
        }
    }
}

struct SubscriptionLifestyleStreak: Identifiable, Hashable, Sendable {
    let id: UUID
    let programTitle: String
    let days: Int
    let summary: String
    let progress: Double

    init(
        id: UUID = UUID(),
        programTitle: String,
        days: Int,
        summary: String,
        progress: Double
    ) {
        self.id = id
        self.programTitle = programTitle
        self.days = days
        self.summary = summary
        self.progress = progress
    }
}

struct SubscriptionLifestylePlan: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let price: String
    let summary: String
    let offer: String

    init(
        id: UUID = UUID(),
        name: String,
        price: String,
        summary: String,
        offer: String
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.summary = summary
        self.offer = offer
    }
}

struct SubscriptionLifestyleMetric: Hashable, Sendable {
    let label: String
    let value: String
}
