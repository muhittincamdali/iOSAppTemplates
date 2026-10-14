import Foundation
import SwiftUI

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
                        NavigationLink {
                            FitnessCompletedSessionDetailView(session: session)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(session.title)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
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
                    Label("\(store.readinessCompletionCount)/\(store.readinessChecks.count) readiness checks cleared", systemImage: "checkmark.shield.fill")
                }

                Section("Readiness Checklist") {
                    ForEach(store.readinessChecks) { check in
                        Button {
                            store.toggleReadinessCheck(check.id)
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: check.isComplete ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(check.isComplete ? .green : .orange)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(check.title)
                                        .foregroundStyle(.primary)
                                    Text(check.summary)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)
                    }
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

                if !store.coachAlerts.isEmpty {
                    Section("Coach Alerts") {
                        ForEach(store.coachAlerts) { alert in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(alert.title)
                                        .font(.headline)
                                    Spacer()
                                    Text(alert.severity.label)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(alert.severity.tint)
                                }
                                Text(alert.detail)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(alert.nextStep)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                if !alert.isResolved {
                                    Button("Resolve Alert") {
                                        store.resolveCoachAlert(alert.id)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                            .padding(.vertical, 4)
                        }
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

                Section("Operating Pulse") {
                    Label("\(store.activeCoachAlertCount) active coach alerts", systemImage: "exclamationmark.bubble.fill")
                    Label("\(store.readinessCompletionCount)/\(store.readinessChecks.count) readiness checks green", systemImage: "waveform.path.ecg")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct FitnessCompletedSessionDetailView: View {
    let session: FitnessCompletedSession

    var body: some View {
        List {
            Section("Session") {
                Text(session.title)
                    .font(.title3.weight(.bold))
                Text(session.summary)
                    .foregroundStyle(.secondary)
                Label("\(session.durationMinutes) minutes", systemImage: "clock.fill")
                Label(session.effort, systemImage: "bolt.heart.fill")
            }

            Section("Readiness Snapshot") {
                Text(session.readinessSnapshot)
                    .foregroundStyle(.secondary)
            }

            Section("Recovery Directive") {
                Text(session.recoveryDirective)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Session Detail")
    }
}
