import Foundation
import Testing
@testable import FitnessApp

@MainActor
@Suite("FitnessStudioStore")
struct FitnessStudioStoreTests {
    private func clearReadiness(_ store: FitnessStudioStore) {
        for check in store.readinessChecks where !check.isComplete {
            store.toggleReadinessCheck(check.id)
        }
    }

    private func startNextWorkout(_ store: FitnessStudioStore) throws -> FitnessWorkout {
        clearReadiness(store)
        let workout = try #require(store.nextWorkout)
        store.startWorkout(workout.id)
        return workout
    }

    @Test func readinessScoreReflectsCompletedChecks() {
        let store = FitnessStudioStore()

        #expect(store.readinessCompletionCount == 2)
        #expect(abs(store.readinessScore - 2.0 / 3.0) < 0.0001)
        #expect(!store.isReadyForTraining)
    }

    @Test func workoutIsBlockedUntilReadinessClearsAndAlertIsNotDuplicated() throws {
        let store = FitnessStudioStore()
        let alerts = store.coachAlerts.count
        let workout = try #require(store.nextWorkout)

        store.startWorkout(workout.id)
        store.startWorkout(workout.id)

        #expect(store.activeSession == nil)
        #expect(store.coachAlerts.count == alerts + 1)
        #expect(store.coachAlerts[0].severity == .high)
    }

    @Test func startingWorkoutCreatesSessionWithEveryExercise() throws {
        let store = FitnessStudioStore()

        let workout = try startNextWorkout(store)

        #expect(store.activeSession?.workoutTitle == workout.title)
        #expect(store.activeSession?.exerciseLogs.count == workout.exercises.count)
    }

    @Test func secondWorkoutCannotStartWhileOneIsActive() throws {
        let store = FitnessStudioStore()
        let first = try startNextWorkout(store)
        let plan = try #require(store.selectedPlan)
        let other = try #require(plan.workouts.first { $0.id != first.id })

        store.startWorkout(other.id)

        #expect(store.activeSession?.workoutTitle == first.title)
    }

    @Test func sessionCannotFinishWithOpenExercises() throws {
        let store = FitnessStudioStore()
        _ = try startNextWorkout(store)
        let sessions = store.completedSessions.count

        store.finishActiveSession()

        #expect(store.activeSession != nil)
        #expect(store.completedSessions.count == sessions)
    }

    @Test func finishingSessionRecordsItAndResetsReadiness() throws {
        let store = FitnessStudioStore()
        let workout = try startNextWorkout(store)
        let sessions = store.completedSessions.count
        let streak = store.streakDays
        for log in try #require(store.activeSession).exerciseLogs {
            store.toggleExercise(log.id)
        }
        #expect(store.selectedPlan?.workouts.first { $0.id == workout.id }?.status == .readyToComplete)
        store.logCoachingReflection("  Strong last set.  ")

        store.finishActiveSession()

        #expect(store.activeSession == nil)
        #expect(store.completedSessions.count == sessions + 1)
        #expect(store.completedSessions[0].summary == "Strong last set.")
        #expect(store.streakDays == streak + 1)
        #expect(store.weeklyLoadScore <= 100)
        #expect(store.selectedPlan?.workouts.first { $0.id == workout.id }?.status == .completed)
        #expect(store.readinessCompletionCount == 0, "all sample checks reset after a session")
    }

    @Test func pausedSessionDoesNotAdvanceAndElapsedTimeIsCapped() throws {
        let store = FitnessStudioStore()
        _ = try startNextWorkout(store)

        store.pauseActiveSession()
        store.advanceActiveSessionBlock()
        #expect(store.activeSession?.elapsedMinutes == 0)

        store.resumeActiveSession()
        let estimated = try #require(store.activeSession?.estimatedMinutes)
        for _ in 0..<(estimated / 8 + 3) {
            store.advanceActiveSessionBlock()
        }
        #expect(store.activeSession?.elapsedMinutes == estimated)
    }

    @Test func blankReflectionIsIgnored() throws {
        let store = FitnessStudioStore()
        _ = try startNextWorkout(store)

        store.logCoachingReflection("   ")

        #expect(store.activeSession?.coachReflection.isEmpty == true)
    }

    @Test func habitDaysAreCappedAtSeven() {
        let store = FitnessStudioStore()
        let habit = store.weeklyHabits[0]

        for _ in 0..<10 { store.toggleHabit(habit.id) }

        #expect(store.weeklyHabits[0].completedDays == 7)
    }

    @Test func completingGoalAndResolvingAlertUpdateCounters() throws {
        let store = FitnessStudioStore()
        let goal = try #require(store.goals.first { !$0.isCompleted })
        let completedGoals = store.completedGoalCount
        let alerts = store.activeCoachAlertCount

        let alert = try #require(store.coachAlerts.first { !$0.isResolved })
        store.completeGoal(goal.id)
        store.resolveCoachAlert(alert.id)

        #expect(store.completedGoalCount == completedGoals + 1)
        #expect(store.activeCoachAlertCount == alerts - 1)
    }
}
