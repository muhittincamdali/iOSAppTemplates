import Foundation
import SwiftUI

@MainActor
final class FitnessStudioStore: ObservableObject {
    @Published var plans: [FitnessPlan] = FitnessPlan.samplePlans
    @Published var activeSession: FitnessActiveSession?
    @Published var completedSessions: [FitnessCompletedSession] = FitnessCompletedSession.sampleSessions
    @Published var goals: [FitnessGoal] = FitnessGoal.sampleGoals
    @Published var recoveryTasks: [FitnessRecoveryTask] = FitnessRecoveryTask.sampleTasks
    @Published var weeklyHabits: [FitnessHabit] = FitnessHabit.sampleHabits
    @Published var readinessChecks: [FitnessReadinessCheck] = FitnessReadinessCheck.sampleChecks
    @Published var coachAlerts: [FitnessCoachAlert] = FitnessCoachAlert.sampleAlerts
    @Published var selectedPlanID: UUID?
    @Published var readinessNote = "Sleep quality improved, but lower-body soreness still needs mobility before the next sprint block."
    @Published var streakDays = 18
    @Published var bodyWeight = 78.4
    @Published var weeklyLoadScore = 82

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

    var readinessCompletionCount: Int {
        readinessChecks.filter(\.isComplete).count
    }

    var readinessScore: Double {
        guard !readinessChecks.isEmpty else { return 1 }
        return Double(readinessCompletionCount) / Double(readinessChecks.count)
    }

    var isReadyForTraining: Bool {
        readinessChecks.allSatisfy(\.isComplete)
    }

    var activeCoachAlertCount: Int {
        coachAlerts.filter { !$0.isResolved }.count
    }

    func selectPlan(_ planID: UUID) {
        selectedPlanID = planID
    }

    func startWorkout(_ workoutID: UUID) {
        guard isReadyForTraining else {
            readinessNote = "Training block is held until readiness checks are cleared. Resolve mobility and soreness gates before loading the next session."
            if !coachAlerts.contains(where: { $0.title == "Readiness gate is blocking the next workout" && !$0.isResolved }) {
                coachAlerts.insert(
                    FitnessCoachAlert(
                        title: "Readiness gate is blocking the next workout",
                        detail: "Lower-body soreness and recovery checks must clear before the next loading block starts.",
                        severity: .high,
                        nextStep: "Complete the mobility reset and mark every readiness check green."
                    ),
                    at: 0
                )
            }
            return
        }

        guard activeSession == nil,
              let plan = selectedPlan,
              let workout = plan.workouts.first(where: { $0.id == workoutID }) else {
            return
        }

        activeSession = FitnessActiveSession(
            workoutTitle: workout.title,
            trainingFocus: workout.trainingFocus,
            estimatedMinutes: workout.estimatedMinutes,
            readinessSummary: readinessHeadline,
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

    func toggleReadinessCheck(_ checkID: UUID) {
        guard let index = readinessChecks.firstIndex(where: { $0.id == checkID }) else {
            return
        }

        readinessChecks[index].isComplete.toggle()
        readinessNote = readinessHeadline
    }

    func incrementHydration() {
        guard var session = activeSession else { return }
        session.hydrationCups += 1
        activeSession = session
    }

    func advanceActiveSessionBlock() {
        guard var session = activeSession, !session.isPaused else { return }
        session.elapsedMinutes = min(session.estimatedMinutes, session.elapsedMinutes + 8)
        session.exertionHeadline = session.elapsedMinutes >= session.estimatedMinutes / 2 ? "Work block is on pace and fatigue is controlled." : "Warm-up and main set are still ramping."
        activeSession = session
    }

    func pauseActiveSession() {
        guard var session = activeSession, !session.isPaused else { return }
        session.isPaused = true
        session.exertionHeadline = "Session paused for readiness reset and breathing control."
        activeSession = session
    }

    func resumeActiveSession() {
        guard var session = activeSession, session.isPaused else { return }
        session.isPaused = false
        session.exertionHeadline = "Session resumed after readiness reset."
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

        if let workoutIndex = activeSessionIndex, var plan = selectedPlan {
            plan.workouts[workoutIndex].status = .completed
            replacePlan(plan)
        }

        completedSessions.insert(
            FitnessCompletedSession(
                title: session.workoutTitle,
                trainingFocus: session.trainingFocus,
                durationMinutes: session.estimatedMinutes,
                effort: session.hydrationCups >= 3 ? "High quality session" : "Solid session, hydration follow-up needed",
                summary: session.coachReflection.isEmpty ? "Finished every block and held technique under fatigue." : session.coachReflection,
                readinessSnapshot: session.readinessSummary,
                recoveryDirective: recoveryTasks.first(where: { !$0.isComplete })?.title ?? "Recovery lane is clear for the next heavy block."
            ),
            at: 0
        )

        streakDays += 1
        weeklyLoadScore = min(100, weeklyLoadScore + 4)
        bodyWeight = max(70, bodyWeight - 0.1)
        completeFirstOpenGoal()
        readinessChecks = readinessChecks.map { check in
            var updated = check
            if updated.autoResetsAfterSession {
                updated.isComplete = false
            }
            return updated
        }
        readinessNote = "Session closed. Recovery checks reset for the next loading day."
        activeSession = nil
    }

    func toggleRecoveryTask(_ taskID: UUID) {
        guard let taskIndex = recoveryTasks.firstIndex(where: { $0.id == taskID }) else {
            return
        }

        recoveryTasks[taskIndex].isComplete.toggle()
        if recoveryTasks[taskIndex].isComplete {
            readinessNote = "Recovery lane improved after \(recoveryTasks[taskIndex].title.lowercased())."
        }
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

    func resolveCoachAlert(_ alertID: UUID) {
        guard let index = coachAlerts.firstIndex(where: { $0.id == alertID }) else { return }
        coachAlerts[index].isResolved = true
    }

    var readinessHeadline: String {
        if isReadyForTraining {
            return "Readiness gate is green. Heavy loading can start without a coach override."
        }
        return "Readiness gate is still amber. Clear every protocol item before the next heavy block."
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
