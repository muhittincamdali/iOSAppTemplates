import Foundation
import SwiftUI

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
    let readinessSummary: String
    var exerciseLogs: [FitnessExerciseLog]
    var elapsedMinutes = 0
    var isPaused = false
    var hydrationCups = 0
    var coachReflection = ""
    var exertionHeadline = "Warm-up lane is open. Progress through the block before closing the session."
}

struct FitnessCompletedSession: Identifiable, Hashable {
    let id: UUID
    let title: String
    let trainingFocus: String
    let durationMinutes: Int
    let effort: String
    let summary: String
    let readinessSnapshot: String
    let recoveryDirective: String

    init(
        id: UUID = UUID(),
        title: String,
        trainingFocus: String,
        durationMinutes: Int,
        effort: String,
        summary: String,
        readinessSnapshot: String,
        recoveryDirective: String
    ) {
        self.id = id
        self.title = title
        self.trainingFocus = trainingFocus
        self.durationMinutes = durationMinutes
        self.effort = effort
        self.summary = summary
        self.readinessSnapshot = readinessSnapshot
        self.recoveryDirective = recoveryDirective
    }

    static let sampleSessions: [FitnessCompletedSession] = [
        .init(
            title: "Upper Pull Density",
            trainingFocus: "Row and pull-up density with grip endurance.",
            durationMinutes: 47,
            effort: "Strong technical execution",
            summary: "Held pacing under fatigue and finished every set with full range.",
            readinessSnapshot: "Sleep, hydration, and soreness checks were green before the session opened.",
            recoveryDirective: "Keep grip and thoracic mobility in the next recovery window."
        ),
        .init(
            title: "Tempo Run Builder",
            trainingFocus: "Aerobic threshold run with cadence discipline.",
            durationMinutes: 34,
            effort: "Moderate, stable effort",
            summary: "Stayed inside target zone and finished with clean cooldown.",
            readinessSnapshot: "Aerobic block cleared after mobility and hydration checks.",
            recoveryDirective: "Protect sleep and hold the next day’s lower-body load."
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

struct FitnessReadinessCheck: Identifiable, Hashable {
    let id: UUID
    let title: String
    let summary: String
    let autoResetsAfterSession: Bool
    var isComplete: Bool

    init(id: UUID = UUID(), title: String, summary: String, autoResetsAfterSession: Bool, isComplete: Bool) {
        self.id = id
        self.title = title
        self.summary = summary
        self.autoResetsAfterSession = autoResetsAfterSession
        self.isComplete = isComplete
    }

    static let sampleChecks: [FitnessReadinessCheck] = [
        .init(title: "Sleep score cleared", summary: "Protect the heavy day only if sleep debt is under the threshold.", autoResetsAfterSession: true, isComplete: true),
        .init(title: "Lower-body soreness cleared", summary: "Finish mobility and soreness check before loading the next squat block.", autoResetsAfterSession: true, isComplete: false),
        .init(title: "Hydration plan confirmed", summary: "Carry the hydration target into the live session before the first main set.", autoResetsAfterSession: true, isComplete: true)
    ]
}

struct FitnessCoachAlert: Identifiable, Hashable {
    let id: UUID
    let title: String
    let detail: String
    let severity: FitnessCoachAlertSeverity
    let nextStep: String
    var isResolved: Bool

    init(
        id: UUID = UUID(),
        title: String,
        detail: String,
        severity: FitnessCoachAlertSeverity,
        nextStep: String,
        isResolved: Bool = false
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.severity = severity
        self.nextStep = nextStep
        self.isResolved = isResolved
    }

    static let sampleAlerts: [FitnessCoachAlert] = [
        .init(
            title: "Recovery debt is building for the next lower-body block",
            detail: "Mobility cooldown completion dropped below target and the next heavy slot is at risk.",
            severity: .medium,
            nextStep: "Close the mobility task and keep the next loading block under review."
        )
    ]
}

enum FitnessCoachAlertSeverity: Hashable {
    case low
    case medium
    case high

    var label: String {
        switch self {
        case .low:
            return "Watch"
        case .medium:
            return "Review"
        case .high:
            return "Blocker"
        }
    }

    var tint: Color {
        switch self {
        case .low:
            return .yellow
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
}
