import Foundation
import SwiftUI
import HealthKit
import Charts

// MARK: - Health Templates
public struct HealthTemplates {
    
    // MARK: - Version
    public static let version = "2.1.0"
    
    // MARK: - Initialization
    public static func initialize() {
        print("🏥 Health Templates v\(version) initialized")
    }
}

// MARK: - Fitness App Template
public struct FitnessAppTemplate {
    
    // MARK: - Models
    public struct Workout: Identifiable, Codable {
        public let id: String
        public let name: String
        public let type: WorkoutType
        public var duration: TimeInterval
        public let caloriesBurned: Double
        public let distance: Double?
        public let averageHeartRate: Double?
        public let maxHeartRate: Double?
        public let startDate: Date
        public var endDate: Date
        public let notes: String?
        public var isCompleted: Bool
        
        public init(
            id: String,
            name: String,
            type: WorkoutType,
            duration: TimeInterval,
            caloriesBurned: Double,
            distance: Double? = nil,
            averageHeartRate: Double? = nil,
            maxHeartRate: Double? = nil,
            startDate: Date,
            endDate: Date,
            notes: String? = nil,
            isCompleted: Bool = true
        ) {
            self.id = id
            self.name = name
            self.type = type
            self.duration = duration
            self.caloriesBurned = caloriesBurned
            self.distance = distance
            self.averageHeartRate = averageHeartRate
            self.maxHeartRate = maxHeartRate
            self.startDate = startDate
            self.endDate = endDate
            self.notes = notes
            self.isCompleted = isCompleted
        }
    }
    
    // MARK: - Enums
    public enum WorkoutType: String, CaseIterable, Codable {
        case running = "running"
        case cycling = "cycling"
        case swimming = "swimming"
        case walking = "walking"
        case strength = "strength"
        case yoga = "yoga"
        case pilates = "pilates"
        case hiit = "hiit"
        case cardio = "cardio"
        case flexibility = "flexibility"
        case sports = "sports"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .running: return "Running"
            case .cycling: return "Cycling"
            case .swimming: return "Swimming"
            case .walking: return "Walking"
            case .strength: return "Strength Training"
            case .yoga: return "Yoga"
            case .pilates: return "Pilates"
            case .hiit: return "HIIT"
            case .cardio: return "Cardio"
            case .flexibility: return "Flexibility"
            case .sports: return "Sports"
            case .other: return "Other"
            }
        }
        
        public var icon: String {
            switch self {
            case .running: return "figure.run"
            case .cycling: return "bicycle"
            case .swimming: return "figure.pool.swim"
            case .walking: return "figure.walk"
            case .strength: return "dumbbell.fill"
            case .yoga: return "figure.mind.and.body"
            case .pilates: return "figure.core.training"
            case .hiit: return "timer"
            case .cardio: return "heart.fill"
            case .flexibility: return "figure.flexibility"
            case .sports: return "sportscourt.fill"
            case .other: return "ellipsis.circle"
            }
        }
    }

    public enum ExerciseDifficulty: String, CaseIterable, Codable {
        case beginner = "beginner"
        case intermediate = "intermediate"
        case advanced = "advanced"
        
        public var displayName: String {
            switch self {
            case .beginner: return "Beginner"
            case .intermediate: return "Intermediate"
            case .advanced: return "Advanced"
            }
        }
    }
    
    // MARK: - Managers
    @MainActor
    public class HealthKitManager: ObservableObject {
        
        @Published public var isAuthorized = false
        @Published public var isLoading = false
        
        public init() {}
        
        public func requestAuthorization() async throws {
            isAuthorized = true
        }
    }
    
    @MainActor
    public class WorkoutManager: ObservableObject {
        
        @Published public var workouts: [Workout] = []
        @Published public var currentWorkout: Workout?
        @Published public var isLoading = false
        
        public init() {}
        
        public func startWorkout(name: String, type: WorkoutType) {
            let workout = Workout(
                id: UUID().uuidString,
                name: name,
                type: type,
                duration: 0,
                caloriesBurned: 0,
                startDate: Date(),
                endDate: Date(),
                isCompleted: false
            )
            currentWorkout = workout
        }
    }
    
    // MARK: - UI Components
    
    public struct WorkoutChartView: View {
        let workouts: [Workout]
        
        public init(workouts: [Workout]) {
            self.workouts = workouts
        }
        
        public var body: some View {
            Chart {
                ForEach(workouts) { workout in
                    BarMark(
                        x: .value("Date", workout.startDate, unit: .day),
                        y: .value("Calories", workout.caloriesBurned)
                    )
                    .foregroundStyle(by: .value("Type", workout.type.displayName))
                }
            }
            .frame(height: 200)
        }
    }

    public struct WorkoutCard: View {
        let workout: Workout
        let onTap: () -> Void
        
        public init(workout: Workout, onTap: @escaping () -> Void) {
            self.workout = workout
            self.onTap = onTap
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    Image(systemName: workout.type.icon)
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text(workout.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(workout.type.displayName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(workout.startDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)
            .shadow(radius: 2)
            .onTapGesture {
                onTap()
            }
        }
    }
}
