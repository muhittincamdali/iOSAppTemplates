import Foundation
import SwiftUI
import HealthKit
import Charts

// MARK: - Health Templates
public struct HealthTemplates {
    
    // MARK: - Version
    public static let version = "1.0.0"
    
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
        public let duration: TimeInterval
        public let caloriesBurned: Double
        public let distance: Double?
        public let averageHeartRate: Double?
        public let maxHeartRate: Double?
        public let startDate: Date
        public let endDate: Date
        public let notes: String?
        public let isCompleted: Bool
        
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
    
    public struct Exercise: Identifiable, Codable {
        public let id: String
        public let name: String
        public let category: ExerciseCategory
        public let muscleGroups: [MuscleGroup]
        public let equipment: [Equipment]
        public let instructions: [String]
        public let videoURL: String?
        public let imageURL: String?
        public let difficulty: ExerciseDifficulty
        public let estimatedDuration: TimeInterval
        public let caloriesPerMinute: Double
        
        public init(
            id: String,
            name: String,
            category: ExerciseCategory,
            muscleGroups: [MuscleGroup],
            equipment: [Equipment],
            instructions: [String],
            videoURL: String? = nil,
            imageURL: String? = nil,
            difficulty: ExerciseDifficulty,
            estimatedDuration: TimeInterval,
            caloriesPerMinute: Double
        ) {
            self.id = id
            self.name = name
            self.category = category
            self.muscleGroups = muscleGroups
            self.equipment = equipment
            self.instructions = instructions
            self.videoURL = videoURL
            self.imageURL = imageURL
            self.difficulty = difficulty
            self.estimatedDuration = estimatedDuration
            self.caloriesPerMinute = caloriesPerMinute
        }
    }
    
    public struct WorkoutPlan: Identifiable, Codable {
        public let id: String
        public let name: String
        public let description: String
        public let difficulty: WorkoutDifficulty
        public let duration: Int // weeks
        public let workouts: [PlannedWorkout]
        public let goals: [FitnessGoal]
        public let isActive: Bool
        public let startDate: Date?
        public let endDate: Date?
        
        public init(
            id: String,
            name: String,
            description: String,
            difficulty: WorkoutDifficulty,
            duration: Int,
            workouts: [PlannedWorkout],
            goals: [FitnessGoal],
            isActive: Bool = false,
            startDate: Date? = nil,
            endDate: Date? = nil
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.difficulty = difficulty
            self.duration = duration
            self.workouts = workouts
            self.goals = goals
            self.isActive = isActive
            self.startDate = startDate
            self.endDate = endDate
        }
    }
    
    public struct PlannedWorkout: Identifiable, Codable {
        public let id: String
        public let name: String
        public let exercises: [PlannedExercise]
        public let estimatedDuration: TimeInterval
        public let dayOfWeek: Int? // 1-7, nil for flexible
        public let weekNumber: Int?
        
        public init(
            id: String,
            name: String,
            exercises: [PlannedExercise],
            estimatedDuration: TimeInterval,
            dayOfWeek: Int? = nil,
            weekNumber: Int? = nil
        ) {
            self.id = id
            self.name = name
            self.exercises = exercises
            self.estimatedDuration = estimatedDuration
            self.dayOfWeek = dayOfWeek
            self.weekNumber = weekNumber
        }
    }
    
    public struct PlannedExercise: Identifiable, Codable {
        public let id: String
        public let exerciseId: String
        public let sets: Int
        public let reps: Int?
        public let duration: TimeInterval?
        public let weight: Double?
        public let restTime: TimeInterval
        
        public init(
            id: String,
            exerciseId: String,
            sets: Int,
            reps: Int? = nil,
            duration: TimeInterval? = nil,
            weight: Double? = nil,
            restTime: TimeInterval = 60
        ) {
            self.id = id
            self.exerciseId = exerciseId
            self.sets = sets
            self.reps = reps
            self.duration = duration
            self.weight = weight
            self.restTime = restTime
        }
    }
    
    public struct FitnessGoal: Identifiable, Codable {
        public let id: String
        public let name: String
        public let type: GoalType
        public let targetValue: Double
        public let currentValue: Double
        public let unit: String
        public let deadline: Date?
        public let isCompleted: Bool
        
        public init(
            id: String,
            name: String,
            type: GoalType,
            targetValue: Double,
            currentValue: Double = 0,
            unit: String,
            deadline: Date? = nil,
            isCompleted: Bool = false
        ) {
            self.id = id
            self.name = name
            self.type = type
            self.targetValue = targetValue
            self.currentValue = currentValue
            self.unit = unit
            self.deadline = deadline
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
    
    public enum ExerciseCategory: String, CaseIterable, Codable {
        case strength = "strength"
        case cardio = "cardio"
        case flexibility = "flexibility"
        case balance = "balance"
        case sports = "sports"
        case yoga = "yoga"
        case pilates = "pilates"
        case hiit = "hiit"
        
        public var displayName: String {
            switch self {
            case .strength: return "Strength Training"
            case .cardio: return "Cardio"
            case .flexibility: return "Flexibility"
            case .balance: return "Balance"
            case .sports: return "Sports"
            case .yoga: return "Yoga"
            case .pilates: return "Pilates"
            case .hiit: return "HIIT"
            }
        }
    }
    
    public enum MuscleGroup: String, CaseIterable, Codable {
        case chest = "chest"
        case back = "back"
        case shoulders = "shoulders"
        case biceps = "biceps"
        case triceps = "triceps"
        case forearms = "forearms"
        case abs = "abs"
        case obliques = "obliques"
        case glutes = "glutes"
        case quadriceps = "quadriceps"
        case hamstrings = "hamstrings"
        case calves = "calves"
        case fullBody = "full_body"
        
        public var displayName: String {
            switch self {
            case .chest: return "Chest"
            case .back: return "Back"
            case .shoulders: return "Shoulders"
            case .biceps: return "Biceps"
            case .triceps: return "Triceps"
            case .forearms: return "Forearms"
            case .abs: return "Abs"
            case .obliques: return "Obliques"
            case .glutes: return "Glutes"
            case .quadriceps: return "Quadriceps"
            case .hamstrings: return "Hamstrings"
            case .calves: return "Calves"
            case .fullBody: return "Full Body"
            }
        }
    }
    
    public enum Equipment: String, CaseIterable, Codable {
        case none = "none"
        case dumbbells = "dumbbells"
        case barbell = "barbell"
        case kettlebell = "kettlebell"
        case resistanceBand = "resistance_band"
        case pullUpBar = "pull_up_bar"
        case bench = "bench"
        case machine = "machine"
        case cable = "cable"
        case medicineBall = "medicine_ball"
        case stabilityBall = "stability_ball"
        case foamRoller = "foam_roller"
        case yogaMat = "yoga_mat"
        
        public var displayName: String {
            switch self {
            case .none: return "No Equipment"
            case .dumbbells: return "Dumbbells"
            case .barbell: return "Barbell"
            case .kettlebell: return "Kettlebell"
            case .resistanceBand: return "Resistance Band"
            case .pullUpBar: return "Pull-up Bar"
            case .bench: return "Bench"
            case .machine: return "Machine"
            case .cable: return "Cable"
            case .medicineBall: return "Medicine Ball"
            case .stabilityBall: return "Stability Ball"
            case .foamRoller: return "Foam Roller"
            case .yogaMat: return "Yoga Mat"
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
        
        public var color: String {
            switch self {
            case .beginner: return "green"
            case .intermediate: return "orange"
            case .advanced: return "red"
            }
        }
    }
    
    public enum WorkoutDifficulty: String, CaseIterable, Codable {
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
    
    public enum GoalType: String, CaseIterable, Codable {
        case weightLoss = "weight_loss"
        case weightGain = "weight_gain"
        case muscleGain = "muscle_gain"
        case endurance = "endurance"
        case strength = "strength"
        case flexibility = "flexibility"
        case runningDistance = "running_distance"
        case cyclingDistance = "cycling_distance"
        case workoutFrequency = "workout_frequency"
        case calorieBurn = "calorie_burn"
        
        public var displayName: String {
            switch self {
            case .weightLoss: return "Weight Loss"
            case .weightGain: return "Weight Gain"
            case .muscleGain: return "Muscle Gain"
            case .endurance: return "Endurance"
            case .strength: return "Strength"
            case .flexibility: return "Flexibility"
            case .runningDistance: return "Running Distance"
            case .cyclingDistance: return "Cycling Distance"
            case .workoutFrequency: return "Workout Frequency"
            case .calorieBurn: return "Calorie Burn"
            }
        }
    }
    
    // MARK: - Managers
    public class HealthKitManager: ObservableObject {
        
        @Published public var isAuthorized = false
        @Published public var isLoading = false
        
        private let healthStore = HKHealthStore()
        
        public init() {}
        
        // MARK: - Authorization
        
        public func requestAuthorization() async throws {
            isLoading = true
            defer { isLoading = false }
            
            let typesToRead: Set<HKObjectType> = [
                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                HKObjectType.workoutType()
            ]
            
            let typesToWrite: Set<HKSampleType> = [
                HKObjectType.workoutType(),
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
            ]
            
            try await healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead)
            isAuthorized = true
        }
        
        // MARK: - Data Methods
        
        public func saveWorkout(_ workout: Workout) async throws {
            guard isAuthorized else {
                throw HealthError.notAuthorized
            }
            
            let workoutType = HKWorkoutActivityType.running // Default, should be mapped from WorkoutType
            
            let workout = HKWorkout(
                activityType: workoutType,
                start: workout.startDate,
                end: workout.endDate,
                duration: workout.duration,
                totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: workout.caloriesBurned),
                totalDistance: workout.distance.map { HKQuantity(unit: .meter(), doubleValue: $0) },
                metadata: [
                    HKMetadataKeyWorkoutBrandName: "FitnessApp",
                    "workout_id": workout.id
                ]
            )
            
            try await healthStore.save(workout)
        }
        
        public func fetchWorkouts(from startDate: Date, to endDate: Date) async throws -> [HKWorkout] {
            guard isAuthorized else {
                throw HealthError.notAuthorized
            }
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            
            let query = HKSampleQuery(
                sampleType: .workoutType(),
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error = error {
                    print("Error fetching workouts: \(error)")
                }
            }
            
            return try await withCheckedThrowingContinuation { continuation in
                query.completionHandler = { _, samples, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        let workouts = samples as? [HKWorkout] ?? []
                        continuation.resume(returning: workouts)
                    }
                }
                healthStore.execute(query)
            }
        }
        
        public func fetchStepCount(for date: Date) async throws -> Int {
            guard isAuthorized else {
                throw HealthError.notAuthorized
            }
            
            let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            let startOfDay = Calendar.current.startOfDay(for: date)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
            
            let query = HKStatisticsQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, statistics, error in
                if let error = error {
                    print("Error fetching step count: \(error)")
                }
            }
            
            return try await withCheckedThrowingContinuation { continuation in
                query.completionHandler = { _, statistics, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        let steps = statistics?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                        continuation.resume(returning: Int(steps))
                    }
                }
                healthStore.execute(query)
            }
        }
    }
    
    public class WorkoutManager: ObservableObject {
        
        @Published public var workouts: [Workout] = []
        @Published public var currentWorkout: Workout?
        @Published public var isLoading = false
        
        private let healthKitManager = HealthKitManager()
        
        public init() {}
        
        // MARK: - Workout Methods
        
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
        
        public func endWorkout() async throws {
            guard var workout = currentWorkout else {
                throw HealthError.noActiveWorkout
            }
            
            workout.endDate = Date()
            workout.duration = workout.endDate.timeIntervalSince(workout.startDate)
            workout.isCompleted = true
            
            try await healthKitManager.saveWorkout(workout)
            workouts.insert(workout, at: 0)
            currentWorkout = nil
        }
        
        public func fetchWorkouts(from startDate: Date, to endDate: Date) async throws {
            isLoading = true
            defer { isLoading = false }
            
            let healthKitWorkouts = try await healthKitManager.fetchWorkouts(from: startDate, to: endDate)
            
            workouts = healthKitWorkouts.map { hkWorkout in
                Workout(
                    id: hkWorkout.uuid.uuidString,
                    name: hkWorkout.workoutActivityType.name,
                    type: WorkoutType.running, // Map from HKWorkoutActivityType
                    duration: hkWorkout.duration,
                    caloriesBurned: hkWorkout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
                    distance: hkWorkout.totalDistance?.doubleValue(for: .meter()),
                    startDate: hkWorkout.startDate,
                    endDate: hkWorkout.endDate,
                    isCompleted: true
                )
            }
        }
    }
    
    // MARK: - UI Components
    
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
                
                // Stats
                HStack(spacing: 20) {
                    VStack {
                        Text("\(Int(workout.duration / 60))")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Minutes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Text("\(Int(workout.caloriesBurned))")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Calories")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let distance = workout.distance {
                        VStack {
                            Text(String(format: "%.1f", distance / 1000))
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("km")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                
                // Progress indicator
                if !workout.isCompleted {
                    ProgressView()
                        .progressViewStyle(LinearProgressViewStyle())
                        .scaleEffect(x: 1, y: 0.5, anchor: .center)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            .onTapGesture {
                onTap()
            }
        }
    }
    
    public struct ExerciseCard: View {
        let exercise: Exercise
        let onTap: () -> Void
        
        public init(exercise: Exercise, onTap: @escaping () -> Void) {
            self.exercise = exercise
            self.onTap = onTap
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                // Exercise Image
                if let imageURL = exercise.imageURL {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    }
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 120)
                        .cornerRadius(8)
                        .overlay(
                            Image(systemName: "dumbbell.fill")
                                .foregroundColor(.gray)
                                .font(.title)
                        )
                }
                
                // Exercise Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(exercise.category.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(exercise.difficulty.displayName)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(exercise.difficulty.color).opacity(0.2))
                            .foregroundColor(Color(exercise.difficulty.color))
                            .cornerRadius(4)
                        
                        Spacer()
                        
                        Text("\(Int(exercise.estimatedDuration / 60)) min")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            .onTapGesture {
                onTap()
            }
        }
    }
    
    // MARK: - Errors
    
    public enum HealthError: LocalizedError {
        case notAuthorized
        case noActiveWorkout
        case workoutNotFound
        case exerciseNotFound
        case invalidData
        case networkError
        
        public var errorDescription: String? {
            switch self {
            case .notAuthorized:
                return "HealthKit authorization required"
            case .noActiveWorkout:
                return "No active workout"
            case .workoutNotFound:
                return "Workout not found"
            case .exerciseNotFound:
                return "Exercise not found"
            case .invalidData:
                return "Invalid data"
            case .networkError:
                return "Network error occurred"
            }
        }
    }
} 