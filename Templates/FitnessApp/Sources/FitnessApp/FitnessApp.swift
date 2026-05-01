import Foundation
import SwiftUI

private enum FitnessInteractionProofMode {
    static let isEnabled = ProcessInfo.processInfo.environment["IOSAPPTEMPLATES_INTERACTION_PROOF_MODE"] == "1"

    static func write(summary: String, steps: [String]) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let payload: [String: Any] = [
            "app": "FitnessApp",
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

@main
struct FitnessApp: App {
    var body: some Scene {
        WindowGroup {
            FitnessRuntimeRootView()
        }
    }
}

struct FitnessRuntimeRootView: View {
    @StateObject private var store = FitnessStudioStore()

    var body: some View {
        TabView {
            FitnessDashboardView(store: store)
                .tabItem {
                    Image(systemName: "figure.strengthtraining.traditional")
                    Text("Plan")
                }

            FitnessSessionWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "play.circle.fill")
                    Text("Session")
                }

            FitnessProgressWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Progress")
                }

            FitnessRecoveryWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "heart.text.square.fill")
                    Text("Recovery")
                }

            FitnessProfileView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.green)
        .onAppear {
            store.runInteractionProofIfNeeded()
        }
    }
}

@MainActor
final class FitnessStudioStore: ObservableObject {
    @Published var plans: [FitnessPlan] = FitnessPlan.samplePlans
    @Published var activeSession: FitnessActiveSession?
    @Published var completedSessions: [FitnessCompletedSession] = FitnessCompletedSession.sampleSessions
    @Published var goals: [FitnessGoal] = FitnessGoal.sampleGoals
    @Published var recoveryTasks: [FitnessRecoveryTask] = FitnessRecoveryTask.sampleTasks
    @Published var weeklyHabits: [FitnessHabit] = FitnessHabit.sampleHabits
    @Published var selectedPlanID: UUID?
    @Published var readinessNote = "Sleep quality improved, but lower-body soreness still needs mobility before the next sprint block."
    @Published var streakDays = 18
    @Published var bodyWeight = 78.4
    @Published var weeklyLoadScore = 82
    private var interactionProofScheduled = false

    init() {
        selectedPlanID = plans.first?.id
    }

    var selectedPlan: FitnessPlan? {
        plans.first(where: { $0.id == selectedPlanID }) ?? plans.first
    }

    var nextWorkout: FitnessWorkout? {
        selectedPlan?.workouts.first(where: { $0.status != .completed }) ?? selectedPlan?.workouts.first
    }

    var completedMinutesThisWeek: Int {
        completedSessions.reduce(0) { $0 + $1.durationMinutes }
    }

    var completedWorkoutCount: Int {
        completedSessions.count
    }

    var completedGoalCount: Int {
        goals.filter(\.isCompleted).count
    }

    var recoveryCompletionCount: Int {
        recoveryTasks.filter(\.isComplete).count
    }

    func selectPlan(_ planID: UUID) {
        selectedPlanID = planID
    }

    func startWorkout(_ workoutID: UUID) {
        guard activeSession == nil,
              let plan = selectedPlan,
              let workout = plan.workouts.first(where: { $0.id == workoutID }) else {
            return
        }

        activeSession = FitnessActiveSession(
            workoutTitle: workout.title,
            trainingFocus: workout.trainingFocus,
            estimatedMinutes: workout.estimatedMinutes,
            exerciseLogs: workout.exercises.map { exercise in
                FitnessExerciseLog(
                    title: exercise.title,
                    prescription: exercise.prescription,
                    coachingNote: exercise.coachingNote
                )
            }
        )
    }

    func toggleExercise(_ exerciseID: UUID) {
        guard let sessionIndex = activeSessionIndex,
              let exerciseIndex = activeSession?.exerciseLogs.firstIndex(where: { $0.id == exerciseID }) else {
            return
        }

        activeSession?.exerciseLogs[exerciseIndex].isComplete.toggle()
        if let session = activeSession {
            activeSession = session
        }

        updatePlanStatus(for: sessionIndex)
    }

    func incrementHydration() {
        guard var session = activeSession else { return }
        session.hydrationCups += 1
        activeSession = session
    }

    func logCoachingReflection(_ text: String) {
        guard var session = activeSession else { return }
        let normalized = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else { return }
        session.coachReflection = normalized
        activeSession = session
    }

    func finishActiveSession() {
        guard let session = activeSession, session.exerciseLogs.allSatisfy(\.isComplete) else {
            return
        }

        completedSessions.insert(
            FitnessCompletedSession(
                title: session.workoutTitle,
                trainingFocus: session.trainingFocus,
                durationMinutes: session.estimatedMinutes,
                effort: session.hydrationCups >= 3 ? "High quality session" : "Solid session, hydration follow-up needed",
                summary: session.coachReflection.isEmpty ? "Finished every block and held technique under fatigue." : session.coachReflection
            ),
            at: 0
        )

        streakDays += 1
        weeklyLoadScore = min(100, weeklyLoadScore + 4)
        bodyWeight = max(70, bodyWeight - 0.1)
        completeFirstOpenGoal()
        activeSession = nil
    }

    func toggleRecoveryTask(_ taskID: UUID) {
        guard let taskIndex = recoveryTasks.firstIndex(where: { $0.id == taskID }) else {
            return
        }

        recoveryTasks[taskIndex].isComplete.toggle()
    }

    func toggleHabit(_ habitID: UUID) {
        guard let habitIndex = weeklyHabits.firstIndex(where: { $0.id == habitID }) else {
            return
        }

        weeklyHabits[habitIndex].completedDays = min(7, weeklyHabits[habitIndex].completedDays + 1)
    }

    func completeGoal(_ goalID: UUID) {
        guard let goalIndex = goals.firstIndex(where: { $0.id == goalID }) else { return }
        goals[goalIndex].currentValue = goals[goalIndex].targetValue
        goals[goalIndex].isCompleted = true
    }

    func runInteractionProofIfNeeded() {
        guard FitnessInteractionProofMode.isEnabled, !interactionProofScheduled else { return }
        interactionProofScheduled = true

        DispatchQueue.main.async {
            var steps: [String] = []

            if let plan = self.plans.first {
                self.selectPlan(plan.id)
                steps.append("Selected plan")
            }

            if let workout = self.nextWorkout {
                self.startWorkout(workout.id)
                steps.append("Started next workout")
            }

            self.activeSession?.exerciseLogs.forEach { exercise in
                self.toggleExercise(exercise.id)
            }
            steps.append("Completed every exercise")

            self.incrementHydration()
            self.incrementHydration()
            steps.append("Logged hydration")

            self.logCoachingReflection("Interaction proof session completed with clean technique and stable recovery.")
            steps.append("Saved coaching reflection")

            self.finishActiveSession()
            steps.append("Finished active session")

            if let recoveryTask = self.recoveryTasks.first {
                self.toggleRecoveryTask(recoveryTask.id)
                steps.append("Completed recovery task")
            }

            if let habit = self.weeklyHabits.first {
                self.toggleHabit(habit.id)
                steps.append("Logged weekly habit")
            }

            if let goal = self.goals.first(where: { !$0.isCompleted }) {
                self.completeGoal(goal.id)
                steps.append("Completed goal")
            }

            FitnessInteractionProofMode.write(
                summary: "Fitness interaction proof completed with plan, session, hydration, recovery, habit, and goal chain.",
                steps: steps
            )
        }
    }

    private var activeSessionIndex: Int? {
        guard let activeSession,
              let plan = selectedPlan,
              let workoutIndex = plan.workouts.firstIndex(where: { $0.title == activeSession.workoutTitle }) else {
            return nil
        }

        return workoutIndex
    }

    private func updatePlanStatus(for workoutIndex: Int) {
        guard var plan = selectedPlan else { return }

        let allDone = activeSession?.exerciseLogs.allSatisfy(\.isComplete) ?? false
        plan.workouts[workoutIndex].status = allDone ? .readyToComplete : .inProgress
        replacePlan(plan)
    }

    private func completeFirstOpenGoal() {
        guard let goalIndex = goals.firstIndex(where: { !$0.isCompleted }) else { return }
        goals[goalIndex].currentValue = min(goals[goalIndex].targetValue, goals[goalIndex].currentValue + goals[goalIndex].incrementStep)
        if goals[goalIndex].currentValue >= goals[goalIndex].targetValue {
            goals[goalIndex].isCompleted = true
        }
    }

    private func replacePlan(_ updatedPlan: FitnessPlan) {
        guard let planIndex = plans.firstIndex(where: { $0.id == updatedPlan.id }) else { return }
        plans[planIndex] = updatedPlan
        if selectedPlanID == nil {
            selectedPlanID = updatedPlan.id
        }
    }
}

struct FitnessDashboardView: View {
    @ObservedObject var store: FitnessStudioStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    FitnessHeroCard(store: store)
                    FitnessPlanPickerSection(store: store)
                    FitnessNextWorkoutSection(store: store)
                    FitnessGoalSection(store: store)
                }
                .padding(16)
            }
            .navigationTitle("Training Plan")
        }
    }
}

struct FitnessHeroCard: View {
    @ObservedObject var store: FitnessStudioStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(store.activeSession == nil ? "Your next session is ready to start." : "Active session in progress. Finish every block before recovery.")
                .font(.system(size: 30, weight: .bold, design: .rounded))

            Text("Streak \(store.streakDays) days • Weekly load \(store.weeklyLoadScore)%")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                FitnessMetricChip(title: "Sessions", value: "\(store.completedWorkoutCount)")
                FitnessMetricChip(title: "Minutes", value: "\(store.completedMinutesThisWeek)")
                FitnessMetricChip(title: "Goals", value: "\(store.completedGoalCount)")
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.green.opacity(0.18), .blue.opacity(0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

struct FitnessMetricChip: View {
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

struct FitnessPlanPickerSection: View {
    @ObservedObject var store: FitnessStudioStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Program Blocks")
                .font(.title3.weight(.bold))

            ForEach(store.plans) { plan in
                Button {
                    store.selectPlan(plan.id)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(plan.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text(plan.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("\(plan.workouts.count) workouts • \(plan.durationLabel)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: store.selectedPlanID == plan.id ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(store.selectedPlanID == plan.id ? .green : .secondary)
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

struct FitnessNextWorkoutSection: View {
    @ObservedObject var store: FitnessStudioStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Next Workout")
                .font(.title3.weight(.bold))

            if let workout = store.nextWorkout {
                NavigationLink {
                    FitnessWorkoutDetailView(store: store, workoutID: workout.id)
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(workout.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(workout.status.rawValue)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(workout.status.tint)
                        }
                        Text(workout.trainingFocus)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("\(workout.estimatedMinutes) min • \(workout.exercises.count) exercises")
                            .font(.caption)
                            .foregroundStyle(.secondary)
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

struct FitnessGoalSection: View {
    @ObservedObject var store: FitnessStudioStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Goals")
                .font(.title3.weight(.bold))

            ForEach(store.goals) { goal in
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(goal.title)
                            .font(.headline)
                        Text(goal.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        ProgressView(value: goal.progressValue)
                            .tint(goal.isCompleted ? .green : .blue)
                        Text("\(goal.currentValue.formatted()) / \(goal.targetValue.formatted()) \(goal.unit)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    if goal.isCompleted {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                    } else {
                        Button("Complete") {
                            store.completeGoal(goal.id)
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

struct FitnessWorkoutDetailView: View {
    @ObservedObject var store: FitnessStudioStore
    let workoutID: UUID

    private var workout: FitnessWorkout? {
        store.selectedPlan?.workouts.first(where: { $0.id == workoutID })
    }

    var body: some View {
        Group {
            if let workout {
                List {
                    Section("Workout") {
                        Text(workout.title)
                            .font(.title3.weight(.bold))
                        Text(workout.trainingFocus)
                            .foregroundStyle(.secondary)
                        Label("\(workout.estimatedMinutes) minutes", systemImage: "clock.fill")
                    }

                    Section("Exercises") {
                        ForEach(workout.exercises) { exercise in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(exercise.title)
                                    .font(.headline)
                                Text(exercise.prescription)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(exercise.coachingNote)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    Section("Action") {
                        Button("Start Session") {
                            store.startWorkout(workout.id)
                        }
                        .disabled(store.activeSession != nil)
                    }
                }
                .navigationTitle("Workout Detail")
            } else {
                ContentUnavailableView("Workout unavailable", systemImage: "figure.run")
            }
        }
    }
}

struct FitnessSessionWorkspaceView: View {
    @ObservedObject var store: FitnessStudioStore
    @State private var reflectionDraft = ""

    var body: some View {
        NavigationStack {
            Group {
                if let session = store.activeSession {
                    List {
                        Section("Session") {
                            Text(session.workoutTitle)
                                .font(.title3.weight(.bold))
                            Text(session.trainingFocus)
                                .foregroundStyle(.secondary)
                            Label("\(session.estimatedMinutes) minutes", systemImage: "clock.fill")
                            Label("\(session.hydrationCups) hydration checks", systemImage: "drop.fill")
                        }

                        Section("Exercise Log") {
                            ForEach(session.exerciseLogs) { log in
                                Button {
                                    store.toggleExercise(log.id)
                                } label: {
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: log.isComplete ? "checkmark.circle.fill" : "circle")
                                            .foregroundStyle(log.isComplete ? .green : .secondary)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(log.title)
                                                .font(.headline)
                                                .foregroundStyle(.primary)
                                            Text(log.prescription)
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                            Text(log.coachingNote)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        Section("Coach Reflection") {
                            TextField("Write the outcome of the session", text: $reflectionDraft, axis: .vertical)
                                .lineLimit(3, reservesSpace: true)
                            Button("Save Reflection") {
                                store.logCoachingReflection(reflectionDraft)
                                reflectionDraft = ""
                            }
                            .buttonStyle(.bordered)
                        }

                        Section("Actions") {
                            Button("Log Hydration Check") {
                                store.incrementHydration()
                            }

                            Button("Finish Session") {
                                store.finishActiveSession()
                            }
                            .disabled(!session.exerciseLogs.allSatisfy(\.isComplete))
                            .foregroundStyle(.green)
                        }
                    }
                } else {
                    ContentUnavailableView(
                        "No active session",
                        systemImage: "play.circle",
                        description: Text("Start the next workout from the plan tab to open a live session log.")
                    )
                }
            }
            .navigationTitle("Session")
        }
    }
}

struct FitnessProgressWorkspaceView: View {
    @ObservedObject var store: FitnessStudioStore

    var body: some View {
        NavigationStack {
            List {
                Section("Body Metrics") {
                    Label("\(store.bodyWeight, specifier: "%.1f") kg", systemImage: "scalemass.fill")
                    Label("\(store.streakDays) day streak", systemImage: "flame.fill")
                    Label("\(store.weeklyLoadScore)% weekly load", systemImage: "gauge.with.dots.needle.50percent")
                }

                Section("Completed Sessions") {
                    ForEach(store.completedSessions) { session in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(session.title)
                                .font(.headline)
                            Text(session.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("\(session.trainingFocus) • \(session.durationMinutes) min • \(session.effort)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Habit Consistency") {
                    ForEach(store.weeklyHabits) { habit in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(habit.title)
                                Text("\(habit.completedDays)/7 days")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button("Log Day") {
                                store.toggleHabit(habit.id)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
            .navigationTitle("Progress")
        }
    }
}

struct FitnessRecoveryWorkspaceView: View {
    @ObservedObject var store: FitnessStudioStore

    var body: some View {
        NavigationStack {
            List {
                Section("Recovery Readiness") {
                    Text(store.readinessNote)
                        .foregroundStyle(.secondary)
                    Label("\(store.recoveryCompletionCount) tasks completed", systemImage: "heart.circle.fill")
                }

                Section("Today") {
                    ForEach(store.recoveryTasks) { task in
                        Button {
                            store.toggleRecoveryTask(task.id)
                        } label: {
                            HStack {
                                Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(task.isComplete ? .green : .secondary)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(task.title)
                                        .foregroundStyle(.primary)
                                    Text(task.summary)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Recovery")
        }
    }
}

struct FitnessProfileView: View {
    @ObservedObject var store: FitnessStudioStore

    var body: some View {
        NavigationStack {
            List {
                Section("Athlete") {
                    Label("Jordan Lee", systemImage: "person.crop.circle.fill")
                    Label("Hybrid performance block", systemImage: "figure.run")
                }

                Section("Connected Sources") {
                    Label("Apple Health connected", systemImage: "heart.text.square.fill")
                    Label("Coach review synced nightly", systemImage: "arrow.triangle.2.circlepath")
                }

                Section("Rules") {
                    Label("No heavy lower-body day without readiness pass", systemImage: "checkmark.shield.fill")
                    Label("Finish hydration and reflection before closing sessions", systemImage: "drop.fill")
                    Label("Progress goals close only after validated session logs", systemImage: "chart.line.uptrend.xyaxis")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct FitnessPlan: Identifiable, Hashable {
    let id: UUID
    let title: String
    let summary: String
    let durationLabel: String
    var workouts: [FitnessWorkout]

    init(id: UUID = UUID(), title: String, summary: String, durationLabel: String, workouts: [FitnessWorkout]) {
        self.id = id
        self.title = title
        self.summary = summary
        self.durationLabel = durationLabel
        self.workouts = workouts
    }

    static let samplePlans: [FitnessPlan] = [
        FitnessPlan(
            title: "Strength Base",
            summary: "Lower-body strength and controlled upper push with recovery discipline.",
            durationLabel: "4-week block",
            workouts: [
                FitnessWorkout(
                    title: "Lower Body Power",
                    trainingFocus: "Primary squat strength with hinge accessory volume.",
                    estimatedMinutes: 52,
                    status: .ready,
                    exercises: [
                        .init(title: "Back Squat", prescription: "5 x 5 @ RPE 7", coachingNote: "Keep tempo controlled on the descent."),
                        .init(title: "Romanian Deadlift", prescription: "4 x 8", coachingNote: "Full hip hinge, no spinal collapse."),
                        .init(title: "Walking Lunge", prescription: "3 x 12 steps", coachingNote: "Stay tall through every rep.")
                    ]
                ),
                FitnessWorkout(
                    title: "Upper Push Volume",
                    trainingFocus: "Bench pattern volume and shoulder integrity work.",
                    estimatedMinutes: 44,
                    status: .planned,
                    exercises: [
                        .init(title: "Bench Press", prescription: "4 x 6", coachingNote: "Pause on chest, drive clean."),
                        .init(title: "Incline Dumbbell Press", prescription: "3 x 10", coachingNote: "Keep shoulder blades stable."),
                        .init(title: "Face Pull", prescription: "3 x 15", coachingNote: "Finish with scapular control.")
                    ]
                )
            ]
        ),
        FitnessPlan(
            title: "Engine Builder",
            summary: "Run intervals, sled conditioning, and mobility to improve repeat output.",
            durationLabel: "3-week block",
            workouts: [
                FitnessWorkout(
                    title: "Sprint Ladder",
                    trainingFocus: "Short-interval repeat power with heart-rate control.",
                    estimatedMinutes: 36,
                    status: .planned,
                    exercises: [
                        .init(title: "Track Warm-Up", prescription: "8 minutes", coachingNote: "Prime ankles and hips first."),
                        .init(title: "Sprint Ladder", prescription: "6 rounds", coachingNote: "Full effort, full reset between reps."),
                        .init(title: "Cooldown Walk", prescription: "10 minutes", coachingNote: "Bring HR down before mobility.")
                    ]
                )
            ]
        )
    ]
}

struct FitnessWorkout: Identifiable, Hashable {
    let id: UUID
    let title: String
    let trainingFocus: String
    let estimatedMinutes: Int
    var status: FitnessWorkoutStatus
    let exercises: [FitnessExercise]

    init(
        id: UUID = UUID(),
        title: String,
        trainingFocus: String,
        estimatedMinutes: Int,
        status: FitnessWorkoutStatus,
        exercises: [FitnessExercise]
    ) {
        self.id = id
        self.title = title
        self.trainingFocus = trainingFocus
        self.estimatedMinutes = estimatedMinutes
        self.status = status
        self.exercises = exercises
    }
}

enum FitnessWorkoutStatus: String, Hashable {
    case planned = "Planned"
    case ready = "Ready"
    case inProgress = "In Progress"
    case readyToComplete = "Ready To Finish"
    case completed = "Completed"

    var tint: Color {
        switch self {
        case .planned:
            return .secondary
        case .ready:
            return .green
        case .inProgress:
            return .blue
        case .readyToComplete:
            return .orange
        case .completed:
            return .purple
        }
    }
}

struct FitnessExercise: Identifiable, Hashable {
    let id: UUID
    let title: String
    let prescription: String
    let coachingNote: String

    init(id: UUID = UUID(), title: String, prescription: String, coachingNote: String) {
        self.id = id
        self.title = title
        self.prescription = prescription
        self.coachingNote = coachingNote
    }
}

struct FitnessExerciseLog: Identifiable, Hashable {
    let id: UUID
    let title: String
    let prescription: String
    let coachingNote: String
    var isComplete: Bool

    init(id: UUID = UUID(), title: String, prescription: String, coachingNote: String, isComplete: Bool = false) {
        self.id = id
        self.title = title
        self.prescription = prescription
        self.coachingNote = coachingNote
        self.isComplete = isComplete
    }
}

struct FitnessActiveSession: Hashable {
    let workoutTitle: String
    let trainingFocus: String
    let estimatedMinutes: Int
    var exerciseLogs: [FitnessExerciseLog]
    var hydrationCups = 0
    var coachReflection = ""
}

struct FitnessCompletedSession: Identifiable, Hashable {
    let id: UUID
    let title: String
    let trainingFocus: String
    let durationMinutes: Int
    let effort: String
    let summary: String

    init(id: UUID = UUID(), title: String, trainingFocus: String, durationMinutes: Int, effort: String, summary: String) {
        self.id = id
        self.title = title
        self.trainingFocus = trainingFocus
        self.durationMinutes = durationMinutes
        self.effort = effort
        self.summary = summary
    }

    static let sampleSessions: [FitnessCompletedSession] = [
        .init(
            title: "Upper Pull Density",
            trainingFocus: "Row and pull-up density with grip endurance.",
            durationMinutes: 47,
            effort: "Strong technical execution",
            summary: "Held pacing under fatigue and finished every set with full range."
        ),
        .init(
            title: "Tempo Run Builder",
            trainingFocus: "Aerobic threshold run with cadence discipline.",
            durationMinutes: 34,
            effort: "Moderate, stable effort",
            summary: "Stayed inside target zone and finished with clean cooldown."
        )
    ]
}

struct FitnessGoal: Identifiable, Hashable {
    let id: UUID
    let title: String
    let summary: String
    var currentValue: Double
    let targetValue: Double
    let incrementStep: Double
    let unit: String
    var isCompleted: Bool

    var progressValue: Double {
        min(1, currentValue / targetValue)
    }

    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        currentValue: Double,
        targetValue: Double,
        incrementStep: Double,
        unit: String,
        isCompleted: Bool
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.currentValue = currentValue
        self.targetValue = targetValue
        self.incrementStep = incrementStep
        self.unit = unit
        self.isCompleted = isCompleted
    }

    static let sampleGoals: [FitnessGoal] = [
        .init(
            title: "Back squat progression",
            summary: "Reach the next clean top set without losing depth or trunk control.",
            currentValue: 132.5,
            targetValue: 140,
            incrementStep: 2.5,
            unit: "kg",
            isCompleted: false
        ),
        .init(
            title: "Weekly conditioning volume",
            summary: "Accumulate enough threshold work to sustain pace late in the week.",
            currentValue: 84,
            targetValue: 100,
            incrementStep: 8,
            unit: "minutes",
            isCompleted: false
        )
    ]
}

struct FitnessRecoveryTask: Identifiable, Hashable {
    let id: UUID
    let title: String
    let summary: String
    var isComplete: Bool

    init(id: UUID = UUID(), title: String, summary: String, isComplete: Bool) {
        self.id = id
        self.title = title
        self.summary = summary
        self.isComplete = isComplete
    }

    static let sampleTasks: [FitnessRecoveryTask] = [
        .init(title: "Mobility reset", summary: "12-minute hips and ankles flow after lower-body work.", isComplete: true),
        .init(title: "Protein target", summary: "Hit the post-session nutrition target before 21:00.", isComplete: false),
        .init(title: "Sleep protection", summary: "Start wind-down routine and reduce evening screen load.", isComplete: false)
    ]
}

struct FitnessHabit: Identifiable, Hashable {
    let id: UUID
    let title: String
    var completedDays: Int

    init(id: UUID = UUID(), title: String, completedDays: Int) {
        self.id = id
        self.title = title
        self.completedDays = completedDays
    }

    static let sampleHabits: [FitnessHabit] = [
        .init(title: "Morning walk", completedDays: 5),
        .init(title: "Protein target", completedDays: 4),
        .init(title: "Mobility cooldown", completedDays: 3)
    ]
}
