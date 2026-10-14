import Foundation
import SwiftUI

struct FitnessDashboardView: View {
    @ObservedObject var store: FitnessStudioStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    FitnessHeroCard(store: store)
                    FitnessReadinessSection(store: store)
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

struct FitnessReadinessSection: View {
    @ObservedObject var store: FitnessStudioStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Readiness Gate")
                .font(.title3.weight(.bold))

            VStack(alignment: .leading, spacing: 10) {
                Text(store.readinessHeadline)
                    .font(.headline)
                ProgressView(value: store.readinessScore)
                    .tint(store.isReadyForTraining ? .green : .orange)
                Text("\(store.readinessCompletionCount)/\(store.readinessChecks.count) checks passed")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
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
