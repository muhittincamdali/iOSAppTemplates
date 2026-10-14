import Foundation
import SwiftUI

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
                        .disabled(store.activeSession != nil || !store.isReadyForTraining)

                        if !store.isReadyForTraining {
                            Label("Recovery tab must clear readiness before the session can start.", systemImage: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }
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
                            Label("\(session.elapsedMinutes) minutes completed", systemImage: "stopwatch.fill")
                            Label("\(session.hydrationCups) hydration checks", systemImage: "drop.fill")
                            Label(session.readinessSummary, systemImage: "shield.checkered")
                            Label(session.exertionHeadline, systemImage: session.isPaused ? "pause.circle.fill" : "figure.run")
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
                            Button(session.isPaused ? "Resume Session" : "Pause Session") {
                                session.isPaused ? store.resumeActiveSession() : store.pauseActiveSession()
                            }

                            Button("Advance Work Block") {
                                store.advanceActiveSessionBlock()
                            }
                            .disabled(session.isPaused)

                            Button("Log Hydration Check") {
                                store.incrementHydration()
                            }

                            Button("Finish Session") {
                                store.finishActiveSession()
                            }
                            .disabled(!session.exerciseLogs.allSatisfy(\.isComplete) || session.isPaused)
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
