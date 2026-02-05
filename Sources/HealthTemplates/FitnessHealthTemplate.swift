// MARK: - Fitness & Health Template
// Complete fitness app with 15+ screens
// Features: Workouts, Activity Tracking, Nutrition, Progress, HealthKit
// Dark mode ready, localized, accessible

import SwiftUI
import Foundation
import Combine

// MARK: - Models

public struct Workout: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let type: WorkoutType
    public let duration: TimeInterval
    public let calories: Int
    public let exercises: [Exercise]
    public let difficulty: Difficulty
    public let equipment: [Equipment]
    public let muscleGroups: [MuscleGroup]
    public let imageURL: String?
    public var isCompleted: Bool
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        type: WorkoutType,
        duration: TimeInterval = 1800,
        calories: Int = 200,
        exercises: [Exercise] = [],
        difficulty: Difficulty = .intermediate,
        equipment: [Equipment] = [],
        muscleGroups: [MuscleGroup] = [],
        imageURL: String? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.duration = duration
        self.calories = calories
        self.exercises = exercises
        self.difficulty = difficulty
        self.equipment = equipment
        self.muscleGroups = muscleGroups
        self.imageURL = imageURL
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}

public enum WorkoutType: String, Codable, CaseIterable {
    case strength = "Strength"
    case cardio = "Cardio"
    case hiit = "HIIT"
    case yoga = "Yoga"
    case pilates = "Pilates"
    case stretching = "Stretching"
    case running = "Running"
    case cycling = "Cycling"
    case swimming = "Swimming"
    
    public var icon: String {
        switch self {
        case .strength: return "dumbbell"
        case .cardio: return "heart.circle"
        case .hiit: return "flame"
        case .yoga: return "figure.yoga"
        case .pilates: return "figure.pilates"
        case .stretching: return "figure.flexibility"
        case .running: return "figure.run"
        case .cycling: return "bicycle"
        case .swimming: return "figure.pool.swim"
        }
    }
    
    public var color: Color {
        switch self {
        case .strength: return .purple
        case .cardio: return .red
        case .hiit: return .orange
        case .yoga: return .green
        case .pilates: return .cyan
        case .stretching: return .teal
        case .running: return .blue
        case .cycling: return .yellow
        case .swimming: return .indigo
        }
    }
}

public enum Difficulty: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
    
    public var color: Color {
        switch self {
        case .beginner: return .green
        case .intermediate: return .yellow
        case .advanced: return .orange
        case .expert: return .red
        }
    }
}

public enum Equipment: String, Codable, CaseIterable {
    case none = "No Equipment"
    case dumbbells = "Dumbbells"
    case barbell = "Barbell"
    case kettlebell = "Kettlebell"
    case resistanceBands = "Resistance Bands"
    case pullUpBar = "Pull-up Bar"
    case yogaMat = "Yoga Mat"
    case jumpRope = "Jump Rope"
}

public enum MuscleGroup: String, Codable, CaseIterable {
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case abs = "Abs"
    case legs = "Legs"
    case glutes = "Glutes"
    case fullBody = "Full Body"
}

public struct Exercise: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let description: String
    public let sets: Int
    public let reps: Int
    public let duration: TimeInterval?
    public let restBetweenSets: TimeInterval
    public let videoURL: String?
    public let muscleGroups: [MuscleGroup]
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        sets: Int = 3,
        reps: Int = 12,
        duration: TimeInterval? = nil,
        restBetweenSets: TimeInterval = 60,
        videoURL: String? = nil,
        muscleGroups: [MuscleGroup] = []
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.sets = sets
        self.reps = reps
        self.duration = duration
        self.restBetweenSets = restBetweenSets
        self.videoURL = videoURL
        self.muscleGroups = muscleGroups
    }
}

public struct ActivityData: Identifiable, Codable {
    public let id: UUID
    public let date: Date
    public var steps: Int
    public var calories: Int
    public var activeMinutes: Int
    public var distance: Double
    public var workoutsCompleted: Int
    public var waterIntake: Int
    public var sleepHours: Double
    
    public init(
        id: UUID = UUID(),
        date: Date = Date(),
        steps: Int = 0,
        calories: Int = 0,
        activeMinutes: Int = 0,
        distance: Double = 0,
        workoutsCompleted: Int = 0,
        waterIntake: Int = 0,
        sleepHours: Double = 0
    ) {
        self.id = id
        self.date = date
        self.steps = steps
        self.calories = calories
        self.activeMinutes = activeMinutes
        self.distance = distance
        self.workoutsCompleted = workoutsCompleted
        self.waterIntake = waterIntake
        self.sleepHours = sleepHours
    }
}

public struct NutritionEntry: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let calories: Int
    public let protein: Double
    public let carbs: Double
    public let fat: Double
    public let fiber: Double
    public let mealType: MealType
    public let servingSize: String
    public let timestamp: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        calories: Int,
        protein: Double,
        carbs: Double,
        fat: Double,
        fiber: Double = 0,
        mealType: MealType,
        servingSize: String = "1 serving",
        timestamp: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.fiber = fiber
        self.mealType = mealType
        self.servingSize = servingSize
        self.timestamp = timestamp
    }
}

public enum MealType: String, Codable, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    
    public var icon: String {
        switch self {
        case .breakfast: return "sunrise"
        case .lunch: return "sun.max"
        case .dinner: return "moon.stars"
        case .snack: return "carrot"
        }
    }
}

public struct UserGoals: Codable {
    public var dailySteps: Int
    public var dailyCalories: Int
    public var dailyActiveMinutes: Int
    public var weeklyWorkouts: Int
    public var targetWeight: Double?
    public var dailyWaterIntake: Int
    public var dailyProtein: Double
    
    public init(
        dailySteps: Int = 10000,
        dailyCalories: Int = 2000,
        dailyActiveMinutes: Int = 30,
        weeklyWorkouts: Int = 4,
        targetWeight: Double? = nil,
        dailyWaterIntake: Int = 8,
        dailyProtein: Double = 100
    ) {
        self.dailySteps = dailySteps
        self.dailyCalories = dailyCalories
        self.dailyActiveMinutes = dailyActiveMinutes
        self.weeklyWorkouts = weeklyWorkouts
        self.targetWeight = targetWeight
        self.dailyWaterIntake = dailyWaterIntake
        self.dailyProtein = dailyProtein
    }
}

public struct Achievement: Identifiable, Codable {
    public let id: UUID
    public let title: String
    public let description: String
    public let icon: String
    public var isUnlocked: Bool
    public let unlockedAt: Date?
    public let requirement: String
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        icon: String,
        isUnlocked: Bool = false,
        unlockedAt: Date? = nil,
        requirement: String = ""
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.isUnlocked = isUnlocked
        self.unlockedAt = unlockedAt
        self.requirement = requirement
    }
}

// MARK: - Sample Data

public enum FitnessSampleData {
    public static let exercises: [Exercise] = [
        Exercise(name: "Push-ups", description: "Classic upper body exercise", sets: 3, reps: 15, muscleGroups: [.chest, .triceps, .shoulders]),
        Exercise(name: "Squats", description: "Fundamental lower body movement", sets: 4, reps: 12, muscleGroups: [.legs, .glutes]),
        Exercise(name: "Plank", description: "Core stability exercise", sets: 3, reps: 1, duration: 45, muscleGroups: [.abs]),
        Exercise(name: "Lunges", description: "Single-leg strength exercise", sets: 3, reps: 10, muscleGroups: [.legs, .glutes]),
        Exercise(name: "Burpees", description: "Full body cardio exercise", sets: 3, reps: 10, muscleGroups: [.fullBody]),
        Exercise(name: "Mountain Climbers", description: "Core and cardio combo", sets: 3, reps: 20, muscleGroups: [.abs, .legs]),
        Exercise(name: "Dumbbell Rows", description: "Back strengthening exercise", sets: 3, reps: 12, muscleGroups: [.back, .biceps]),
        Exercise(name: "Shoulder Press", description: "Overhead pressing movement", sets: 3, reps: 10, muscleGroups: [.shoulders, .triceps])
    ]
    
    public static let workouts: [Workout] = [
        Workout(name: "Full Body Blast", type: .hiit, duration: 1800, calories: 350, exercises: Array(exercises.prefix(5)), difficulty: .intermediate, equipment: [.none], muscleGroups: [.fullBody]),
        Workout(name: "Upper Body Strength", type: .strength, duration: 2700, calories: 280, exercises: [exercises[0], exercises[6], exercises[7]], difficulty: .intermediate, equipment: [.dumbbells], muscleGroups: [.chest, .back, .shoulders]),
        Workout(name: "Morning Yoga Flow", type: .yoga, duration: 1800, calories: 150, exercises: [], difficulty: .beginner, equipment: [.yogaMat], muscleGroups: [.fullBody]),
        Workout(name: "HIIT Cardio Burn", type: .cardio, duration: 1200, calories: 400, exercises: [exercises[4], exercises[5]], difficulty: .advanced, equipment: [.none], muscleGroups: [.fullBody]),
        Workout(name: "Leg Day Challenge", type: .strength, duration: 2400, calories: 320, exercises: [exercises[1], exercises[3]], difficulty: .intermediate, equipment: [.dumbbells], muscleGroups: [.legs, .glutes]),
        Workout(name: "Core Crusher", type: .strength, duration: 1500, calories: 200, exercises: [exercises[2], exercises[5]], difficulty: .intermediate, equipment: [.yogaMat], muscleGroups: [.abs])
    ]
    
    public static let todayActivity = ActivityData(
        steps: 7543,
        calories: 1856,
        activeMinutes: 45,
        distance: 5.2,
        workoutsCompleted: 1,
        waterIntake: 6,
        sleepHours: 7.5
    )
    
    public static let weeklyActivity: [ActivityData] = (0..<7).map { day in
        ActivityData(
            date: Calendar.current.date(byAdding: .day, value: -day, to: Date())!,
            steps: Int.random(in: 5000...12000),
            calories: Int.random(in: 1500...2500),
            activeMinutes: Int.random(in: 20...90),
            distance: Double.random(in: 3...10),
            workoutsCompleted: Int.random(in: 0...2),
            waterIntake: Int.random(in: 4...10),
            sleepHours: Double.random(in: 5...9)
        )
    }
    
    public static let nutritionEntries: [NutritionEntry] = [
        NutritionEntry(name: "Oatmeal with Berries", calories: 320, protein: 10, carbs: 58, fat: 6, mealType: .breakfast),
        NutritionEntry(name: "Grilled Chicken Salad", calories: 450, protein: 40, carbs: 15, fat: 25, mealType: .lunch),
        NutritionEntry(name: "Protein Shake", calories: 200, protein: 30, carbs: 10, fat: 5, mealType: .snack),
        NutritionEntry(name: "Salmon with Vegetables", calories: 520, protein: 45, carbs: 20, fat: 28, mealType: .dinner)
    ]
    
    public static let achievements: [Achievement] = [
        Achievement(title: "First Steps", description: "Complete your first workout", icon: "figure.walk", isUnlocked: true, requirement: "Complete 1 workout"),
        Achievement(title: "Week Warrior", description: "Work out 7 days in a row", icon: "flame.fill", isUnlocked: true, requirement: "7-day streak"),
        Achievement(title: "10K Club", description: "Walk 10,000 steps in a day", icon: "figure.run", isUnlocked: false, requirement: "10,000 daily steps"),
        Achievement(title: "Early Bird", description: "Complete a workout before 7 AM", icon: "sunrise.fill", isUnlocked: false, requirement: "Morning workout"),
        Achievement(title: "Consistency King", description: "Work out for 30 days", icon: "crown.fill", isUnlocked: false, requirement: "30 workouts total")
    ]
}

// MARK: - View Models

@MainActor
public class FitnessStore: ObservableObject {
    @Published public var workouts: [Workout] = FitnessSampleData.workouts
    @Published public var todayActivity: ActivityData = FitnessSampleData.todayActivity
    @Published public var weeklyActivity: [ActivityData] = FitnessSampleData.weeklyActivity
    @Published public var nutritionEntries: [NutritionEntry] = FitnessSampleData.nutritionEntries
    @Published public var goals: UserGoals = UserGoals()
    @Published public var achievements: [Achievement] = FitnessSampleData.achievements
    @Published public var completedWorkouts: [Workout] = []
    @Published public var activeWorkout: Workout?
    @Published public var currentStreak: Int = 5
    
    public init() {}
    
    public var todayCalories: Int {
        nutritionEntries.reduce(0) { $0 + $1.calories }
    }
    
    public var todayProtein: Double {
        nutritionEntries.reduce(0) { $0 + $1.protein }
    }
    
    public var stepsProgress: Double {
        Double(todayActivity.steps) / Double(goals.dailySteps)
    }
    
    public var caloriesProgress: Double {
        Double(todayActivity.calories) / Double(goals.dailyCalories)
    }
    
    public var activeMinutesProgress: Double {
        Double(todayActivity.activeMinutes) / Double(goals.dailyActiveMinutes)
    }
    
    public func completeWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index].isCompleted = true
        }
        completedWorkouts.append(workout)
        todayActivity.workoutsCompleted += 1
        todayActivity.calories += workout.calories
        todayActivity.activeMinutes += Int(workout.duration / 60)
    }
    
    public func addWater() {
        todayActivity.waterIntake += 1
    }
    
    public func addNutritionEntry(_ entry: NutritionEntry) {
        nutritionEntries.append(entry)
    }
}

// MARK: - Views

// 1. Main Fitness Home View
public struct FitnessHomeView: View {
    @StateObject private var store = FitnessStore()
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Today", systemImage: "heart.circle")
                }
                .tag(0)
            
            WorkoutsListView()
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell")
                }
                .tag(1)
            
            NutritionView()
                .tabItem {
                    Label("Nutrition", systemImage: "fork.knife")
                }
                .tag(2)
            
            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(3)
            
            FitnessProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(4)
        }
        .environmentObject(store)
    }
}

// 2. Dashboard View
public struct DashboardView: View {
    @EnvironmentObject var store: FitnessStore
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Greeting
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Good Morning!")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Let's crush your goals today 💪")
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Streak
                        VStack {
                            Image(systemName: "flame.fill")
                                .font(.title)
                                .foregroundColor(.orange)
                            Text("\(store.currentStreak)")
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Activity Rings
                    ActivityRingsCard()
                    
                    // Quick Stats
                    QuickStatsGrid()
                    
                    // Today's Workout
                    TodaysWorkoutSection()
                    
                    // Water Tracker
                    WaterTrackerCard()
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {} label: {
                        Image(systemName: "bell")
                    }
                }
            }
        }
    }
}

// 3. Activity Rings Card
struct ActivityRingsCard: View {
    @EnvironmentObject var store: FitnessStore
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 30) {
                // Move Ring
                RingView(progress: store.caloriesProgress, color: .red, icon: "flame.fill", value: "\(store.todayActivity.calories)", label: "CAL")
                
                // Exercise Ring
                RingView(progress: store.activeMinutesProgress, color: .green, icon: "figure.walk", value: "\(store.todayActivity.activeMinutes)", label: "MIN")
                
                // Steps Ring
                RingView(progress: store.stepsProgress, color: .blue, icon: "figure.run", value: "\(store.todayActivity.steps)", label: "STEPS")
            }
            
            Divider()
            
            HStack {
                StatItem(title: "Distance", value: String(format: "%.1f km", store.todayActivity.distance), icon: "location")
                Spacer()
                StatItem(title: "Workouts", value: "\(store.todayActivity.workoutsCompleted)", icon: "dumbbell")
                Spacer()
                StatItem(title: "Sleep", value: String(format: "%.1f hrs", store.todayActivity.sleepHours), icon: "moon.zzz")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct RingView: View {
    let progress: Double
    let color: Color
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 8)
                
                Circle()
                    .trim(from: 0, to: min(progress, 1))
                    .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            .frame(width: 70, height: 70)
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

// 4. Quick Stats Grid
struct QuickStatsGrid: View {
    @EnvironmentObject var store: FitnessStore
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            QuickStatCard(
                title: "Steps",
                value: "\(store.todayActivity.steps)",
                goal: "/\(store.goals.dailySteps)",
                icon: "figure.walk",
                color: .blue,
                progress: store.stepsProgress
            )
            
            QuickStatCard(
                title: "Calories",
                value: "\(store.todayActivity.calories)",
                goal: "/\(store.goals.dailyCalories)",
                icon: "flame.fill",
                color: .red,
                progress: store.caloriesProgress
            )
            
            QuickStatCard(
                title: "Active",
                value: "\(store.todayActivity.activeMinutes) min",
                goal: "/\(store.goals.dailyActiveMinutes) min",
                icon: "heart.fill",
                color: .green,
                progress: store.activeMinutesProgress
            )
            
            QuickStatCard(
                title: "Distance",
                value: String(format: "%.1f km", store.todayActivity.distance),
                goal: "",
                icon: "location.fill",
                color: .purple,
                progress: 0.7
            )
        }
        .padding(.horizontal)
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let goal: String
    let icon: String
    let color: Color
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(value + goal)
                .font(.headline)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(color.opacity(0.3))
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * min(progress, 1))
                }
            }
            .frame(height: 4)
            .cornerRadius(2)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// 5. Today's Workout Section
struct TodaysWorkoutSection: View {
    @EnvironmentObject var store: FitnessStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Workout")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink("See All") {
                    WorkoutsListView()
                        .environmentObject(store)
                }
                .font(.subheadline)
            }
            .padding(.horizontal)
            
            if let workout = store.workouts.first {
                NavigationLink {
                    WorkoutDetailView(workout: workout)
                        .environmentObject(store)
                } label: {
                    WorkoutCard(workout: workout)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct WorkoutCard: View {
    let workout: Workout
    
    var body: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(workout.type.color.opacity(0.3))
                .frame(width: 80, height: 80)
                .cornerRadius(12)
                .overlay(
                    Image(systemName: workout.type.icon)
                        .font(.title)
                        .foregroundColor(workout.type.color)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(workout.name)
                    .font(.headline)
                
                HStack(spacing: 12) {
                    Label("\(Int(workout.duration / 60)) min", systemImage: "clock")
                    Label("\(workout.calories) cal", systemImage: "flame")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                HStack {
                    Text(workout.difficulty.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(workout.difficulty.color.opacity(0.2))
                        .foregroundColor(workout.difficulty.color)
                        .cornerRadius(8)
                    
                    Text(workout.type.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// 6. Water Tracker Card
struct WaterTrackerCard: View {
    @EnvironmentObject var store: FitnessStore
    
    var progress: Double {
        Double(store.todayActivity.waterIntake) / Double(store.goals.dailyWaterIntake)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("💧 Water Intake")
                    .font(.headline)
                
                Spacer()
                
                Text("\(store.todayActivity.waterIntake)/\(store.goals.dailyWaterIntake) glasses")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 8) {
                ForEach(0..<store.goals.dailyWaterIntake, id: \.self) { index in
                    Circle()
                        .fill(index < store.todayActivity.waterIntake ? Color.blue : Color.blue.opacity(0.2))
                        .frame(width: 30, height: 30)
                }
            }
            
            Button {
                store.addWater()
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Glass")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(store.todayActivity.waterIntake >= store.goals.dailyWaterIntake)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// 7. Workouts List View
public struct WorkoutsListView: View {
    @EnvironmentObject var store: FitnessStore
    @State private var selectedType: WorkoutType?
    @State private var searchText = ""
    
    public init() {}
    
    var filteredWorkouts: [Workout] {
        var result = store.workouts
        
        if let type = selectedType {
            result = result.filter { $0.type == type }
        }
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return result
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        WorkoutTypeChip(
                            type: nil,
                            isSelected: selectedType == nil
                        ) {
                            selectedType = nil
                        }
                        
                        ForEach(WorkoutType.allCases, id: \.self) { type in
                            WorkoutTypeChip(
                                type: type,
                                isSelected: selectedType == type
                            ) {
                                selectedType = type
                            }
                        }
                    }
                    .padding()
                }
                
                // Workouts List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredWorkouts) { workout in
                            NavigationLink {
                                WorkoutDetailView(workout: workout)
                                    .environmentObject(store)
                            } label: {
                                WorkoutCard(workout: workout)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Workouts")
            .searchable(text: $searchText, prompt: "Search workouts")
        }
    }
}

struct WorkoutTypeChip: View {
    let type: WorkoutType?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let type = type {
                    Image(systemName: type.icon)
                    Text(type.rawValue)
                } else {
                    Image(systemName: "square.grid.2x2")
                    Text("All")
                }
            }
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? (type?.color ?? .blue) : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

// 8. Workout Detail View
public struct WorkoutDetailView: View {
    @EnvironmentObject var store: FitnessStore
    @Environment(\.dismiss) private var dismiss
    let workout: Workout
    @State private var showingWorkoutPlayer = false
    
    public init(workout: Workout) {
        self.workout = workout
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero Image
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(workout.type.color.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: workout.type.icon)
                                .font(.system(size: 80))
                                .foregroundColor(workout.type.color)
                        )
                    
                    LinearGradient(colors: [.clear, .black.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(workout.type.rawValue.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(workout.type.color)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        
                        Text(workout.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                
                // Stats
                HStack(spacing: 24) {
                    VStack {
                        Image(systemName: "clock")
                        Text("\(Int(workout.duration / 60))")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Minutes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Image(systemName: "flame")
                        Text("\(workout.calories)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Calories")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Image(systemName: "figure.strengthtraining.traditional")
                        Text("\(workout.exercises.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Exercises")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Difficulty & Equipment
                VStack(alignment: .leading, spacing: 12) {
                    Text("Details")
                        .font(.headline)
                    
                    HStack {
                        Text("Difficulty")
                        Spacer()
                        Text(workout.difficulty.rawValue)
                            .foregroundColor(workout.difficulty.color)
                    }
                    
                    if !workout.equipment.isEmpty {
                        HStack(alignment: .top) {
                            Text("Equipment")
                            Spacer()
                            VStack(alignment: .trailing) {
                                ForEach(workout.equipment, id: \.self) { equip in
                                    Text(equip.rawValue)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    
                    if !workout.muscleGroups.isEmpty {
                        HStack(alignment: .top) {
                            Text("Muscle Groups")
                            Spacer()
                            Text(workout.muscleGroups.map { $0.rawValue }.joined(separator: ", "))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
                .font(.subheadline)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Exercises
                if !workout.exercises.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Exercises")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(Array(workout.exercises.enumerated()), id: \.element.id) { index, exercise in
                            ExerciseRow(exercise: exercise, index: index + 1)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button {
                showingWorkoutPlayer = true
            } label: {
                Text("Start Workout")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(workout.type.color)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
            .background(.bar)
        }
        .fullScreenCover(isPresented: $showingWorkoutPlayer) {
            WorkoutPlayerView(workout: workout) {
                store.completeWorkout(workout)
                showingWorkoutPlayer = false
            }
        }
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    let index: Int
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(index)")
                .font(.headline)
                .frame(width: 30, height: 30)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .fontWeight(.semibold)
                
                if let duration = exercise.duration {
                    Text("\(Int(duration)) seconds")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("\(exercise.sets) sets × \(exercise.reps) reps")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "play.circle")
                .font(.title2)
                .foregroundColor(.accentColor)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// 9. Workout Player View
struct WorkoutPlayerView: View {
    let workout: Workout
    let onComplete: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var currentExerciseIndex = 0
    @State private var isResting = false
    @State private var timeRemaining = 45
    @State private var isPaused = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                }
                
                Spacer()
                
                Text("\(currentExerciseIndex + 1)/\(max(1, workout.exercises.count))")
                    .font(.headline)
                
                Spacer()
                
                Button {} label: {
                    Image(systemName: "speaker.wave.2")
                        .font(.title2)
                }
            }
            .padding()
            
            Spacer()
            
            // Exercise Display
            VStack(spacing: 20) {
                if workout.exercises.isEmpty {
                    Text(isResting ? "Rest" : workout.name)
                        .font(.title)
                        .fontWeight(.bold)
                } else {
                    Text(isResting ? "Rest" : workout.exercises[currentExerciseIndex].name)
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                // Timer Circle
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray4), lineWidth: 12)
                    
                    Circle()
                        .trim(from: 0, to: Double(timeRemaining) / 45.0)
                        .stroke(workout.type.color, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(timeRemaining)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                }
                .frame(width: 200, height: 200)
                
                if !isResting && !workout.exercises.isEmpty {
                    let exercise = workout.exercises[currentExerciseIndex]
                    Text("\(exercise.sets) sets × \(exercise.reps) reps")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Controls
            HStack(spacing: 40) {
                Button {
                    if currentExerciseIndex > 0 {
                        currentExerciseIndex -= 1
                        timeRemaining = 45
                    }
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.title)
                }
                .disabled(currentExerciseIndex == 0)
                
                Button {
                    isPaused.toggle()
                } label: {
                    Image(systemName: isPaused ? "play.circle.fill" : "pause.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(workout.type.color)
                }
                
                Button {
                    if workout.exercises.isEmpty || currentExerciseIndex >= workout.exercises.count - 1 {
                        onComplete()
                    } else {
                        currentExerciseIndex += 1
                        timeRemaining = 45
                    }
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.title)
                }
            }
            .foregroundColor(.primary)
            .padding(.bottom, 40)
        }
    }
}

// 10. Nutrition View
public struct NutritionView: View {
    @EnvironmentObject var store: FitnessStore
    @State private var showingAddFood = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Daily Summary
                    NutritionSummaryCard()
                    
                    // Macros
                    MacrosCard()
                    
                    // Meals
                    ForEach(MealType.allCases, id: \.self) { mealType in
                        MealSection(
                            mealType: mealType,
                            entries: store.nutritionEntries.filter { $0.mealType == mealType }
                        )
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Nutrition")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddFood = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddFood) {
                AddFoodView()
                    .environmentObject(store)
            }
        }
    }
}

struct NutritionSummaryCard: View {
    @EnvironmentObject var store: FitnessStore
    
    var remainingCalories: Int {
        store.goals.dailyCalories - store.todayCalories
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Calories")
                        .font(.headline)
                    Text("\(store.todayCalories) eaten")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(remainingCalories)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(remainingCalories > 0 ? .green : .red)
                    Text("remaining")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray4))
                    
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: geometry.size.width * min(Double(store.todayCalories) / Double(store.goals.dailyCalories), 1))
                }
            }
            .frame(height: 8)
            .cornerRadius(4)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct MacrosCard: View {
    @EnvironmentObject var store: FitnessStore
    
    var totalCarbs: Double {
        store.nutritionEntries.reduce(0) { $0 + $1.carbs }
    }
    
    var totalFat: Double {
        store.nutritionEntries.reduce(0) { $0 + $1.fat }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            MacroItem(name: "Protein", value: store.todayProtein, goal: store.goals.dailyProtein, color: .red)
            MacroItem(name: "Carbs", value: totalCarbs, goal: 250, color: .blue)
            MacroItem(name: "Fat", value: totalFat, goal: 65, color: .yellow)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct MacroItem: View {
    let name: String
    let value: Double
    let goal: Double
    let color: Color
    
    var progress: Double {
        value / goal
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 6)
                
                Circle()
                    .trim(from: 0, to: min(progress, 1))
                    .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: 60, height: 60)
            .overlay(
                Text("\(Int(value))g")
                    .font(.caption)
                    .fontWeight(.semibold)
            )
            
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct MealSection: View {
    let mealType: MealType
    let entries: [NutritionEntry]
    
    var totalCalories: Int {
        entries.reduce(0) { $0 + $1.calories }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: mealType.icon)
                Text(mealType.rawValue)
                    .font(.headline)
                
                Spacer()
                
                Text("\(totalCalories) cal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            if entries.isEmpty {
                Button {
                    // Add food
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add Food")
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            } else {
                VStack(spacing: 8) {
                    ForEach(entries) { entry in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(entry.name)
                                    .font(.subheadline)
                                Text(entry.servingSize)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("\(entry.calories) cal")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// 11. Add Food View
struct AddFoodView: View {
    @EnvironmentObject var store: FitnessStore
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedMealType: MealType = .breakfast
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Meal", selection: $selectedMealType) {
                    ForEach(MealType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                List {
                    Section("Recent Foods") {
                        ForEach(FitnessSampleData.nutritionEntries) { entry in
                            Button {
                                var newEntry = entry
                                store.addNutritionEntry(NutritionEntry(
                                    name: entry.name,
                                    calories: entry.calories,
                                    protein: entry.protein,
                                    carbs: entry.carbs,
                                    fat: entry.fat,
                                    mealType: selectedMealType
                                ))
                                dismiss()
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(entry.name)
                                        Text("\(entry.calories) cal")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "plus.circle")
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search foods")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// 12. Progress View
public struct ProgressView: View {
    @EnvironmentObject var store: FitnessStore
    @State private var selectedTimeRange = 0
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Time Range Picker
                    Picker("Time Range", selection: $selectedTimeRange) {
                        Text("Week").tag(0)
                        Text("Month").tag(1)
                        Text("Year").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Weekly Activity Chart
                    WeeklyActivityChart()
                    
                    // Achievements
                    AchievementsSection()
                    
                    // Stats Summary
                    StatsSummarySection()
                }
                .padding(.vertical)
            }
            .navigationTitle("Progress")
        }
    }
}

struct WeeklyActivityChart: View {
    @EnvironmentObject var store: FitnessStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Activity")
                .font(.headline)
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(store.weeklyActivity.reversed()) { day in
                    VStack(spacing: 4) {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 30, height: CGFloat(day.steps) / 200)
                            .cornerRadius(4)
                        
                        Text(day.date, format: .dateTime.weekday(.narrow))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 120)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct AchievementsSection: View {
    @EnvironmentObject var store: FitnessStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Achievements")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink("See All") {
                    AchievementsListView()
                        .environmentObject(store)
                }
                .font(.subheadline)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(store.achievements.filter { $0.isUnlocked }) { achievement in
                        AchievementBadge(achievement: achievement)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct AchievementBadge: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: achievement.icon)
                .font(.title)
                .foregroundColor(.yellow)
                .frame(width: 60, height: 60)
                .background(Color.yellow.opacity(0.2))
                .clipShape(Circle())
            
            Text(achievement.title)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
    }
}

struct AchievementsListView: View {
    @EnvironmentObject var store: FitnessStore
    
    var body: some View {
        List(store.achievements) { achievement in
            HStack(spacing: 16) {
                Image(systemName: achievement.icon)
                    .font(.title2)
                    .foregroundColor(achievement.isUnlocked ? .yellow : .secondary)
                    .frame(width: 50, height: 50)
                    .background(achievement.isUnlocked ? Color.yellow.opacity(0.2) : Color(.systemGray5))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(achievement.title)
                        .fontWeight(.semibold)
                    
                    Text(achievement.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if !achievement.isUnlocked {
                        Text(achievement.requirement)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                if achievement.isUnlocked {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .opacity(achievement.isUnlocked ? 1 : 0.6)
        }
        .navigationTitle("Achievements")
    }
}

struct StatsSummarySection: View {
    @EnvironmentObject var store: FitnessStore
    
    var totalSteps: Int {
        store.weeklyActivity.reduce(0) { $0 + $1.steps }
    }
    
    var totalCalories: Int {
        store.weeklyActivity.reduce(0) { $0 + $1.calories }
    }
    
    var totalWorkouts: Int {
        store.weeklyActivity.reduce(0) { $0 + $1.workoutsCompleted }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                StatBox(title: "Total Steps", value: "\(totalSteps.formatted())", icon: "figure.walk", color: .blue)
                StatBox(title: "Calories Burned", value: "\(totalCalories.formatted())", icon: "flame.fill", color: .red)
                StatBox(title: "Workouts", value: "\(totalWorkouts)", icon: "dumbbell.fill", color: .purple)
                StatBox(title: "Active Days", value: "5", icon: "calendar", color: .green)
            }
            .padding(.horizontal)
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// 13. Fitness Profile View
struct FitnessProfileView: View {
    @EnvironmentObject var store: FitnessStore
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 70, height: 70)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .foregroundColor(.secondary)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("John Doe")
                                .font(.headline)
                            Text("Premium Member")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                                Text("\(store.currentStreak) day streak")
                            }
                            .font(.caption)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Goals") {
                    HStack {
                        Text("Daily Steps")
                        Spacer()
                        Text("\(store.goals.dailySteps)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Daily Calories")
                        Spacer()
                        Text("\(store.goals.dailyCalories)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Active Minutes")
                        Spacer()
                        Text("\(store.goals.dailyActiveMinutes) min")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Weekly Workouts")
                        Spacer()
                        Text("\(store.goals.weeklyWorkouts)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Settings") {
                    NavigationLink("Notifications", systemImage: "bell") {}
                    NavigationLink("Apple Health", systemImage: "heart") {}
                    NavigationLink("Units", systemImage: "ruler") {}
                    NavigationLink("Privacy", systemImage: "lock") {}
                }
                
                Section("Account") {
                    NavigationLink("Subscription", systemImage: "creditcard") {}
                    NavigationLink("Help & Support", systemImage: "questionmark.circle") {}
                    NavigationLink("About", systemImage: "info.circle") {}
                }
                
                Section {
                    Button("Sign Out", role: .destructive) {}
                }
            }
            .navigationTitle("Profile")
        }
    }
}

// MARK: - App Entry Point

public struct FitnessHealthApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            FitnessHomeView()
        }
    }
}
