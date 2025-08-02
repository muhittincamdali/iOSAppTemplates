import XCTest
@testable import HealthTemplates

final class HealthTemplatesTests: XCTestCase {
    
    func testHealthTemplatesInitialization() {
        // Given
        let version = HealthTemplates.version
        
        // Then
        XCTAssertEqual(version, "1.0.0")
    }
    
    func testWorkoutInitialization() {
        // Given
        let workout = FitnessAppTemplate.Workout(
            id: "test-id",
            name: "Morning Run",
            type: .running,
            duration: 1800,
            caloriesBurned: 150,
            distance: 5000,
            averageHeartRate: 140,
            maxHeartRate: 165,
            startDate: Date(),
            endDate: Date().addingTimeInterval(1800),
            notes: "Great run!",
            isCompleted: true
        )
        
        // Then
        XCTAssertEqual(workout.id, "test-id")
        XCTAssertEqual(workout.name, "Morning Run")
        XCTAssertEqual(workout.type, .running)
        XCTAssertEqual(workout.duration, 1800)
        XCTAssertEqual(workout.caloriesBurned, 150)
        XCTAssertEqual(workout.distance, 5000)
        XCTAssertEqual(workout.averageHeartRate, 140)
        XCTAssertEqual(workout.maxHeartRate, 165)
        XCTAssertTrue(workout.isCompleted)
    }
    
    func testExerciseInitialization() {
        // Given
        let exercise = FitnessAppTemplate.Exercise(
            id: "exercise-1",
            name: "Push-ups",
            category: .strength,
            muscleGroups: [.chest, .triceps],
            equipment: [.none],
            instructions: ["Start in plank position", "Lower body", "Push back up"],
            difficulty: .beginner,
            estimatedDuration: 300,
            caloriesPerMinute: 8.0
        )
        
        // Then
        XCTAssertEqual(exercise.id, "exercise-1")
        XCTAssertEqual(exercise.name, "Push-ups")
        XCTAssertEqual(exercise.category, .strength)
        XCTAssertEqual(exercise.muscleGroups.count, 2)
        XCTAssertEqual(exercise.difficulty, .beginner)
        XCTAssertEqual(exercise.estimatedDuration, 300)
        XCTAssertEqual(exercise.caloriesPerMinute, 8.0)
    }
    
    func testWorkoutPlanInitialization() {
        // Given
        let workoutPlan = FitnessAppTemplate.WorkoutPlan(
            id: "plan-1",
            name: "Beginner Strength",
            description: "Perfect for beginners",
            difficulty: .beginner,
            duration: 4,
            workouts: [],
            goals: []
        )
        
        // Then
        XCTAssertEqual(workoutPlan.id, "plan-1")
        XCTAssertEqual(workoutPlan.name, "Beginner Strength")
        XCTAssertEqual(workoutPlan.difficulty, .beginner)
        XCTAssertEqual(workoutPlan.duration, 4)
    }
    
    func testFitnessGoalInitialization() {
        // Given
        let goal = FitnessAppTemplate.FitnessGoal(
            id: "goal-1",
            name: "Lose 10kg",
            type: .weightLoss,
            targetValue: 10.0,
            currentValue: 2.0,
            unit: "kg"
        )
        
        // Then
        XCTAssertEqual(goal.id, "goal-1")
        XCTAssertEqual(goal.name, "Lose 10kg")
        XCTAssertEqual(goal.type, .weightLoss)
        XCTAssertEqual(goal.targetValue, 10.0)
        XCTAssertEqual(goal.currentValue, 2.0)
        XCTAssertEqual(goal.unit, "kg")
        XCTAssertFalse(goal.isCompleted)
    }
    
    func testWorkoutTypeProperties() {
        // Given
        let running = FitnessAppTemplate.WorkoutType.running
        
        // Then
        XCTAssertEqual(running.displayName, "Running")
        XCTAssertEqual(running.icon, "figure.run")
    }
    
    func testExerciseCategoryProperties() {
        // Given
        let strength = FitnessAppTemplate.ExerciseCategory.strength
        
        // Then
        XCTAssertEqual(strength.displayName, "Strength Training")
    }
    
    func testMuscleGroupProperties() {
        // Given
        let chest = FitnessAppTemplate.MuscleGroup.chest
        
        // Then
        XCTAssertEqual(chest.displayName, "Chest")
    }
    
    func testEquipmentProperties() {
        // Given
        let dumbbells = FitnessAppTemplate.Equipment.dumbbells
        
        // Then
        XCTAssertEqual(dumbbells.displayName, "Dumbbells")
    }
    
    func testExerciseDifficultyProperties() {
        // Given
        let beginner = FitnessAppTemplate.ExerciseDifficulty.beginner
        
        // Then
        XCTAssertEqual(beginner.displayName, "Beginner")
        XCTAssertEqual(beginner.color, "green")
    }
    
    func testWorkoutDifficultyProperties() {
        // Given
        let intermediate = FitnessAppTemplate.WorkoutDifficulty.intermediate
        
        // Then
        XCTAssertEqual(intermediate.displayName, "Intermediate")
    }
    
    func testGoalTypeProperties() {
        // Given
        let weightLoss = FitnessAppTemplate.GoalType.weightLoss
        
        // Then
        XCTAssertEqual(weightLoss.displayName, "Weight Loss")
    }
    
    func testHealthKitManagerInitialization() {
        // Given
        let manager = FitnessAppTemplate.HealthKitManager()
        
        // Then
        XCTAssertFalse(manager.isAuthorized)
        XCTAssertFalse(manager.isLoading)
    }
    
    func testWorkoutManagerInitialization() {
        // Given
        let manager = FitnessAppTemplate.WorkoutManager()
        
        // Then
        XCTAssertTrue(manager.workouts.isEmpty)
        XCTAssertNil(manager.currentWorkout)
        XCTAssertFalse(manager.isLoading)
    }
    
    func testWorkoutCardInitialization() {
        // Given
        let workout = FitnessAppTemplate.Workout(
            id: "test",
            name: "Test Workout",
            type: .running,
            duration: 1800,
            caloriesBurned: 150,
            startDate: Date(),
            endDate: Date().addingTimeInterval(1800),
            isCompleted: true
        )
        
        let card = FitnessAppTemplate.WorkoutCard(
            workout: workout,
            onTap: {}
        )
        
        // Then
        XCTAssertNotNil(card)
    }
    
    func testExerciseCardInitialization() {
        // Given
        let exercise = FitnessAppTemplate.Exercise(
            id: "test",
            name: "Test Exercise",
            category: .strength,
            muscleGroups: [.chest],
            equipment: [.dumbbells],
            instructions: ["Test instruction"],
            difficulty: .beginner,
            estimatedDuration: 300,
            caloriesPerMinute: 5.0
        )
        
        let card = FitnessAppTemplate.ExerciseCard(
            exercise: exercise,
            onTap: {}
        )
        
        // Then
        XCTAssertNotNil(card)
    }
    
    func testHealthErrorDescriptions() {
        // Given & When
        let notAuthorized = FitnessAppTemplate.HealthError.notAuthorized
        let noActiveWorkout = FitnessAppTemplate.HealthError.noActiveWorkout
        let workoutNotFound = FitnessAppTemplate.HealthError.workoutNotFound
        let exerciseNotFound = FitnessAppTemplate.HealthError.exerciseNotFound
        let invalidData = FitnessAppTemplate.HealthError.invalidData
        let networkError = FitnessAppTemplate.HealthError.networkError
        
        // Then
        XCTAssertEqual(notAuthorized.errorDescription, "HealthKit authorization required")
        XCTAssertEqual(noActiveWorkout.errorDescription, "No active workout")
        XCTAssertEqual(workoutNotFound.errorDescription, "Workout not found")
        XCTAssertEqual(exerciseNotFound.errorDescription, "Exercise not found")
        XCTAssertEqual(invalidData.errorDescription, "Invalid data")
        XCTAssertEqual(networkError.errorDescription, "Network error occurred")
    }
} 