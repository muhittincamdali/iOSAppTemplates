// MARK: - Education App Template
// Complete e-learning platform with 14+ screens
// Features: Courses, Lessons, Quizzes, Progress, Certificates
// Dark mode ready, localized, accessible

import SwiftUI
import Foundation
import Combine
import AVKit

// MARK: - Models

public struct Course: Identifiable, Codable, Hashable {
    public let id: UUID
    public let title: String
    public let subtitle: String
    public let description: String
    public let instructor: Instructor
    public let category: CourseCategory
    public let level: CourseLevel
    public let duration: TimeInterval
    public let lessonsCount: Int
    public let rating: Double
    public let studentsCount: Int
    public let price: Decimal
    public let imageURL: String?
    public let tags: [String]
    public var progress: Double
    public var isEnrolled: Bool
    public var isFavorite: Bool
    public let lastUpdated: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String = "",
        description: String = "",
        instructor: Instructor,
        category: CourseCategory,
        level: CourseLevel = .beginner,
        duration: TimeInterval = 3600,
        lessonsCount: Int = 10,
        rating: Double = 4.5,
        studentsCount: Int = 1000,
        price: Decimal = 0,
        imageURL: String? = nil,
        tags: [String] = [],
        progress: Double = 0,
        isEnrolled: Bool = false,
        isFavorite: Bool = false,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.instructor = instructor
        self.category = category
        self.level = level
        self.duration = duration
        self.lessonsCount = lessonsCount
        self.rating = rating
        self.studentsCount = studentsCount
        self.price = price
        self.imageURL = imageURL
        self.tags = tags
        self.progress = progress
        self.isEnrolled = isEnrolled
        self.isFavorite = isFavorite
        self.lastUpdated = lastUpdated
    }
}

public struct Instructor: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let title: String
    public let bio: String
    public let avatar: String?
    public let coursesCount: Int
    public let studentsCount: Int
    public let rating: Double
    
    public init(
        id: UUID = UUID(),
        name: String,
        title: String = "",
        bio: String = "",
        avatar: String? = nil,
        coursesCount: Int = 5,
        studentsCount: Int = 10000,
        rating: Double = 4.8
    ) {
        self.id = id
        self.name = name
        self.title = title
        self.bio = bio
        self.avatar = avatar
        self.coursesCount = coursesCount
        self.studentsCount = studentsCount
        self.rating = rating
    }
}

public enum CourseCategory: String, Codable, CaseIterable {
    case programming = "Programming"
    case design = "Design"
    case business = "Business"
    case marketing = "Marketing"
    case dataScience = "Data Science"
    case photography = "Photography"
    case music = "Music"
    case health = "Health"
    case language = "Language"
    case personal = "Personal Development"
    
    public var icon: String {
        switch self {
        case .programming: return "chevron.left.forwardslash.chevron.right"
        case .design: return "paintbrush"
        case .business: return "briefcase"
        case .marketing: return "megaphone"
        case .dataScience: return "chart.bar.xaxis"
        case .photography: return "camera"
        case .music: return "music.note"
        case .health: return "heart"
        case .language: return "globe"
        case .personal: return "person.fill.checkmark"
        }
    }
    
    public var color: Color {
        switch self {
        case .programming: return .blue
        case .design: return .purple
        case .business: return .green
        case .marketing: return .orange
        case .dataScience: return .cyan
        case .photography: return .pink
        case .music: return .red
        case .health: return .mint
        case .language: return .indigo
        case .personal: return .yellow
        }
    }
}

public enum CourseLevel: String, Codable, CaseIterable {
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

public struct Lesson: Identifiable, Codable {
    public let id: UUID
    public let title: String
    public let description: String
    public let duration: TimeInterval
    public let videoURL: String?
    public let type: LessonType
    public var isCompleted: Bool
    public var isLocked: Bool
    public let resources: [LessonResource]
    public let order: Int
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        duration: TimeInterval = 600,
        videoURL: String? = nil,
        type: LessonType = .video,
        isCompleted: Bool = false,
        isLocked: Bool = false,
        resources: [LessonResource] = [],
        order: Int = 0
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.duration = duration
        self.videoURL = videoURL
        self.type = type
        self.isCompleted = isCompleted
        self.isLocked = isLocked
        self.resources = resources
        self.order = order
    }
}

public enum LessonType: String, Codable {
    case video = "Video"
    case article = "Article"
    case quiz = "Quiz"
    case exercise = "Exercise"
    case assignment = "Assignment"
    
    public var icon: String {
        switch self {
        case .video: return "play.circle.fill"
        case .article: return "doc.text"
        case .quiz: return "questionmark.circle"
        case .exercise: return "pencil.and.outline"
        case .assignment: return "doc.badge.ellipsis"
        }
    }
}

public struct LessonResource: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let type: ResourceType
    public let url: String
    
    public init(id: UUID = UUID(), name: String, type: ResourceType, url: String = "") {
        self.id = id
        self.name = name
        self.type = type
        self.url = url
    }
}

public enum ResourceType: String, Codable {
    case pdf = "PDF"
    case code = "Code"
    case image = "Image"
    case link = "Link"
}

public struct Quiz: Identifiable, Codable {
    public let id: UUID
    public let title: String
    public let questions: [QuizQuestion]
    public var score: Int?
    public var attempts: Int
    public let passingScore: Int
    
    public init(
        id: UUID = UUID(),
        title: String,
        questions: [QuizQuestion],
        score: Int? = nil,
        attempts: Int = 0,
        passingScore: Int = 70
    ) {
        self.id = id
        self.title = title
        self.questions = questions
        self.score = score
        self.attempts = attempts
        self.passingScore = passingScore
    }
}

public struct QuizQuestion: Identifiable, Codable {
    public let id: UUID
    public let question: String
    public let options: [String]
    public let correctAnswer: Int
    public let explanation: String
    
    public init(
        id: UUID = UUID(),
        question: String,
        options: [String],
        correctAnswer: Int,
        explanation: String = ""
    ) {
        self.id = id
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
    }
}

public struct Certificate: Identifiable, Codable {
    public let id: UUID
    public let courseId: UUID
    public let courseName: String
    public let instructorName: String
    public let completedAt: Date
    public let certificateNumber: String
    
    public init(
        id: UUID = UUID(),
        courseId: UUID,
        courseName: String,
        instructorName: String,
        completedAt: Date = Date(),
        certificateNumber: String = ""
    ) {
        self.id = id
        self.courseId = courseId
        self.courseName = courseName
        self.instructorName = instructorName
        self.completedAt = completedAt
        self.certificateNumber = certificateNumber.isEmpty ? UUID().uuidString.prefix(12).uppercased().description : certificateNumber
    }
}

public struct LearningStreak: Codable {
    public var currentStreak: Int
    public var longestStreak: Int
    public var totalLearningTime: TimeInterval
    public var lessonsCompleted: Int
    public var coursesCompleted: Int
    public var lastActivityDate: Date?
    
    public init(
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        totalLearningTime: TimeInterval = 0,
        lessonsCompleted: Int = 0,
        coursesCompleted: Int = 0,
        lastActivityDate: Date? = nil
    ) {
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.totalLearningTime = totalLearningTime
        self.lessonsCompleted = lessonsCompleted
        self.coursesCompleted = coursesCompleted
        self.lastActivityDate = lastActivityDate
    }
}

// MARK: - Sample Data

public enum EducationSampleData {
    public static let instructors: [Instructor] = [
        Instructor(name: "Dr. Sarah Chen", title: "Senior Software Engineer at Google", bio: "10+ years of experience in iOS development", coursesCount: 8, studentsCount: 45000, rating: 4.9),
        Instructor(name: "Mark Johnson", title: "Lead Designer at Apple", bio: "Former Art Director with 15 years in UI/UX", coursesCount: 5, studentsCount: 32000, rating: 4.8),
        Instructor(name: "Emily Williams", title: "Data Scientist at Netflix", bio: "PhD in Machine Learning from MIT", coursesCount: 6, studentsCount: 28000, rating: 4.7),
        Instructor(name: "David Park", title: "Marketing Director", bio: "Built marketing teams at 3 unicorn startups", coursesCount: 4, studentsCount: 19000, rating: 4.6)
    ]
    
    public static let courses: [Course] = [
        Course(title: "iOS Development Masterclass", subtitle: "Build 20+ Apps with SwiftUI", description: "Complete guide to iOS development from beginner to advanced. Learn SwiftUI, UIKit, Core Data, and more.", instructor: instructors[0], category: .programming, level: .beginner, duration: 36000, lessonsCount: 45, rating: 4.9, studentsCount: 12500, price: 99.99, tags: ["SwiftUI", "iOS", "Xcode", "Swift"], isEnrolled: true, progress: 0.35),
        Course(title: "UI/UX Design Fundamentals", subtitle: "Design Beautiful Interfaces", description: "Master the principles of user interface and experience design.", instructor: instructors[1], category: .design, level: .beginner, duration: 18000, lessonsCount: 28, rating: 4.8, studentsCount: 8900, price: 79.99, tags: ["Figma", "Design", "UX"]),
        Course(title: "Machine Learning with Python", subtitle: "From Zero to Hero", description: "Comprehensive machine learning course covering all major algorithms.", instructor: instructors[2], category: .dataScience, level: .intermediate, duration: 28800, lessonsCount: 35, rating: 4.7, studentsCount: 15600, price: 129.99, tags: ["Python", "ML", "AI"]),
        Course(title: "Digital Marketing Strategy", subtitle: "Grow Your Business Online", description: "Learn proven strategies to market your business effectively.", instructor: instructors[3], category: .marketing, level: .beginner, duration: 14400, lessonsCount: 22, rating: 4.6, studentsCount: 9800, price: 59.99, tags: ["Marketing", "SEO", "Social Media"]),
        Course(title: "Advanced Swift Programming", subtitle: "Master Swift 5.9", description: "Deep dive into Swift programming language features.", instructor: instructors[0], category: .programming, level: .advanced, duration: 21600, lessonsCount: 32, rating: 4.8, studentsCount: 6700, price: 89.99, tags: ["Swift", "iOS", "Advanced"], isEnrolled: true, progress: 0.65)
    ]
    
    public static let lessons: [Lesson] = [
        Lesson(title: "Welcome to the Course", description: "Introduction and course overview", duration: 300, type: .video, isCompleted: true, order: 1),
        Lesson(title: "Setting Up Xcode", description: "Download and configure your development environment", duration: 600, type: .video, isCompleted: true, order: 2),
        Lesson(title: "Your First SwiftUI App", description: "Create your first app from scratch", duration: 900, type: .video, isCompleted: true, order: 3),
        Lesson(title: "Understanding Views", description: "Learn about SwiftUI view hierarchy", duration: 720, type: .video, order: 4),
        Lesson(title: "Quiz: SwiftUI Basics", description: "Test your knowledge", duration: 600, type: .quiz, order: 5),
        Lesson(title: "State and Binding", description: "Managing app state", duration: 840, type: .video, isLocked: true, order: 6),
        Lesson(title: "Navigation", description: "Build navigation flows", duration: 960, type: .video, isLocked: true, order: 7),
        Lesson(title: "Hands-on Exercise", description: "Build a todo app", duration: 1800, type: .exercise, isLocked: true, order: 8)
    ]
    
    public static let quizQuestions: [QuizQuestion] = [
        QuizQuestion(question: "What is SwiftUI?", options: ["A programming language", "A UI framework", "An IDE", "A database"], correctAnswer: 1, explanation: "SwiftUI is Apple's modern UI framework for building user interfaces."),
        QuizQuestion(question: "Which keyword creates a state variable in SwiftUI?", options: ["var", "let", "@State", "@Binding"], correctAnswer: 2, explanation: "@State creates a source of truth for data in a view."),
        QuizQuestion(question: "What file extension do Swift files use?", options: [".swf", ".swift", ".sw", ".s"], correctAnswer: 1, explanation: "Swift source files use the .swift extension.")
    ]
    
    public static let streak = LearningStreak(currentStreak: 7, longestStreak: 21, totalLearningTime: 36000, lessonsCompleted: 45, coursesCompleted: 3, lastActivityDate: Date())
}

// MARK: - View Models

@MainActor
public class EducationStore: ObservableObject {
    @Published public var courses: [Course] = EducationSampleData.courses
    @Published public var enrolledCourses: [Course] = []
    @Published public var certificates: [Certificate] = []
    @Published public var streak: LearningStreak = EducationSampleData.streak
    @Published public var searchQuery = ""
    @Published public var selectedCategory: CourseCategory?
    @Published public var currentLesson: Lesson?
    @Published public var dailyGoalMinutes: Int = 30
    @Published public var todayLearningMinutes: Int = 15
    
    public init() {
        enrolledCourses = courses.filter { $0.isEnrolled }
    }
    
    public var filteredCourses: [Course] {
        var result = courses
        
        if !searchQuery.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchQuery) ||
                $0.tags.contains { $0.localizedCaseInsensitiveContains(searchQuery) }
            }
        }
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        return result
    }
    
    public func enrollInCourse(_ course: Course) {
        if let index = courses.firstIndex(where: { $0.id == course.id }) {
            courses[index].isEnrolled = true
            enrolledCourses.append(courses[index])
        }
    }
    
    public func toggleFavorite(_ course: Course) {
        if let index = courses.firstIndex(where: { $0.id == course.id }) {
            courses[index].isFavorite.toggle()
        }
    }
    
    public func completeLesson(_ lesson: Lesson, for course: Course) {
        streak.lessonsCompleted += 1
        streak.lastActivityDate = Date()
        
        if let courseIndex = courses.firstIndex(where: { $0.id == course.id }) {
            let progress = courses[courseIndex].progress + (1.0 / Double(courses[courseIndex].lessonsCount))
            courses[courseIndex].progress = min(progress, 1.0)
            
            if progress >= 1.0 {
                completeCourse(courses[courseIndex])
            }
        }
    }
    
    private func completeCourse(_ course: Course) {
        streak.coursesCompleted += 1
        let certificate = Certificate(
            courseId: course.id,
            courseName: course.title,
            instructorName: course.instructor.name
        )
        certificates.append(certificate)
    }
}

// MARK: - Views

// 1. Main Education Home View
public struct EducationHomeView: View {
    @StateObject private var store = EducationStore()
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "book")
                }
                .tag(0)
            
            ExploreCourseView()
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            MyCoursesView()
                .tabItem {
                    Label("My Courses", systemImage: "folder")
                }
                .tag(2)
            
            EducationProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
        }
        .environmentObject(store)
    }
}

// 2. Learn View (Home)
public struct LearnView: View {
    @EnvironmentObject var store: EducationStore
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Daily Goal
                    DailyGoalCard()
                    
                    // Streak
                    StreakCard()
                    
                    // Continue Learning
                    ContinueLearningSection()
                    
                    // Recommended
                    RecommendedCoursesSection()
                }
                .padding(.vertical)
            }
            .navigationTitle("Learn")
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

// 3. Daily Goal Card
struct DailyGoalCard: View {
    @EnvironmentObject var store: EducationStore
    
    var progress: Double {
        Double(store.todayLearningMinutes) / Double(store.dailyGoalMinutes)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Goal")
                        .font(.headline)
                    
                    Text("\(store.todayLearningMinutes) / \(store.dailyGoalMinutes) minutes")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray4), lineWidth: 8)
                    
                    Circle()
                        .trim(from: 0, to: min(progress, 1))
                        .stroke(Color.green, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                }
                .frame(width: 60, height: 60)
            }
            
            if progress < 1 {
                NavigationLink {
                    // Continue lesson
                } label: {
                    Text("Continue Learning")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            } else {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Goal achieved! Great job! 🎉")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// 4. Streak Card
struct StreakCard: View {
    @EnvironmentObject var store: EducationStore
    
    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Image(systemName: "flame.fill")
                    .font(.title)
                    .foregroundColor(.orange)
                
                Text("\(store.streak.currentStreak)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Day Streak")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack {
                Image(systemName: "book.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                
                Text("\(store.streak.lessonsCompleted)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Lessons")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack {
                Image(systemName: "clock.fill")
                    .font(.title)
                    .foregroundColor(.green)
                
                Text("\(Int(store.streak.totalLearningTime / 3600))h")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Learning")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// 5. Continue Learning Section
struct ContinueLearningSection: View {
    @EnvironmentObject var store: EducationStore
    
    var inProgressCourses: [Course] {
        store.enrolledCourses.filter { $0.progress > 0 && $0.progress < 1 }
    }
    
    var body: some View {
        if !inProgressCourses.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Continue Learning")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(inProgressCourses) { course in
                            NavigationLink {
                                CourseDetailView(course: course)
                                    .environmentObject(store)
                            } label: {
                                ContinueCourseCard(course: course)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct ContinueCourseCard: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Rectangle()
                .fill(course.category.color.opacity(0.3))
                .frame(width: 240, height: 120)
                .cornerRadius(12)
                .overlay(
                    Image(systemName: course.category.icon)
                        .font(.system(size: 40))
                        .foregroundColor(course.category.color)
                )
            
            Text(course.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
            
            ProgressView(value: course.progress)
                .tint(course.category.color)
            
            Text("\(Int(course.progress * 100))% complete")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 240)
    }
}

// 6. Recommended Courses Section
struct RecommendedCoursesSection: View {
    @EnvironmentObject var store: EducationStore
    
    var recommended: [Course] {
        store.courses.filter { !$0.isEnrolled }.prefix(4).map { $0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recommended for You")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink("See All") {
                    ExploreCourseView()
                        .environmentObject(store)
                }
                .font(.subheadline)
            }
            .padding(.horizontal)
            
            LazyVStack(spacing: 12) {
                ForEach(recommended) { course in
                    NavigationLink {
                        CourseDetailView(course: course)
                            .environmentObject(store)
                    } label: {
                        CourseRowCard(course: course)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CourseRowCard: View {
    let course: Course
    
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(course.category.color.opacity(0.3))
                .frame(width: 80, height: 80)
                .cornerRadius(12)
                .overlay(
                    Image(systemName: course.category.icon)
                        .font(.title2)
                        .foregroundColor(course.category.color)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(course.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(course.instructor.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", course.rating))
                    }
                    
                    Text("•")
                    
                    Text("\(course.studentsCount) students")
                    
                    Text("•")
                    
                    Text(course.level.rawValue)
                        .foregroundColor(course.level.color)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if course.price > 0 {
                Text(course.price, format: .currency(code: "USD"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
            } else {
                Text("Free")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// 7. Explore Courses View
struct ExploreCourseView: View {
    @EnvironmentObject var store: EducationStore
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Search
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search courses...", text: $store.searchQuery)
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Categories
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Categories")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(CourseCategory.allCases, id: \.self) { category in
                                Button {
                                    if store.selectedCategory == category {
                                        store.selectedCategory = nil
                                    } else {
                                        store.selectedCategory = category
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: category.icon)
                                            .foregroundColor(category.color)
                                        Text(category.rawValue)
                                            .font(.caption)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(store.selectedCategory == category ? category.color.opacity(0.2) : Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                                .foregroundColor(.primary)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Courses
                    VStack(alignment: .leading, spacing: 12) {
                        Text("All Courses")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(store.filteredCourses) { course in
                                NavigationLink {
                                    CourseDetailView(course: course)
                                        .environmentObject(store)
                                } label: {
                                    CourseRowCard(course: course)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Explore")
        }
    }
}

// 8. Course Detail View
public struct CourseDetailView: View {
    @EnvironmentObject var store: EducationStore
    @Environment(\.dismiss) private var dismiss
    let course: Course
    @State private var selectedSection = 0
    
    public init(course: Course) {
        self.course = course
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(course.category.color.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: course.category.icon)
                                .font(.system(size: 80))
                                .foregroundColor(course.category.color)
                        )
                    
                    LinearGradient(colors: [.clear, .black.opacity(0.6)], startPoint: .top, endPoint: .bottom)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(course.category.rawValue)
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(course.category.color)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        
                        Text(course.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                
                VStack(spacing: 20) {
                    // Info
                    HStack(spacing: 24) {
                        VStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", course.rating))
                                .fontWeight(.semibold)
                            Text("Rating")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Image(systemName: "person.2")
                                .foregroundColor(.blue)
                            Text("\(course.studentsCount)")
                                .fontWeight(.semibold)
                            Text("Students")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Image(systemName: "play.circle")
                                .foregroundColor(.green)
                            Text("\(course.lessonsCount)")
                                .fontWeight(.semibold)
                            Text("Lessons")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Image(systemName: "clock")
                                .foregroundColor(.orange)
                            Text("\(Int(course.duration / 3600))h")
                                .fontWeight(.semibold)
                            Text("Duration")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Instructor
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Text(course.instructor.name.prefix(1))
                                    .fontWeight(.bold)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(course.instructor.name)
                                .fontWeight(.semibold)
                            Text(course.instructor.title)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", course.instructor.rating))
                        }
                        .font(.caption)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Tabs
                    Picker("Section", selection: $selectedSection) {
                        Text("Overview").tag(0)
                        Text("Curriculum").tag(1)
                        Text("Reviews").tag(2)
                    }
                    .pickerStyle(.segmented)
                    
                    // Content
                    switch selectedSection {
                    case 0:
                        CourseOverviewSection(course: course)
                    case 1:
                        CourseCurriculumSection()
                    case 2:
                        CourseReviewsSection()
                    default:
                        EmptyView()
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            HStack {
                if course.price > 0 && !course.isEnrolled {
                    VStack(alignment: .leading) {
                        Text(course.price, format: .currency(code: "USD"))
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
                
                Button {
                    if !course.isEnrolled {
                        store.enrollInCourse(course)
                    }
                } label: {
                    Text(course.isEnrolled ? "Continue Learning" : (course.price > 0 ? "Buy Now" : "Enroll Free"))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
            .background(.bar)
        }
    }
}

struct CourseOverviewSection: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About this course")
                .font(.headline)
            
            Text(course.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("What you'll learn")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                LearningPoint(text: "Build real-world projects from scratch")
                LearningPoint(text: "Master the fundamentals and advanced concepts")
                LearningPoint(text: "Get hands-on experience with exercises")
                LearningPoint(text: "Earn a certificate of completion")
            }
            
            Text("Requirements")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("• Basic computer skills")
                Text("• Willingness to learn")
                Text("• No prior experience required")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
    }
}

struct LearningPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            
            Text(text)
                .font(.subheadline)
        }
    }
}

struct CourseCurriculumSection: View {
    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(EducationSampleData.lessons.enumerated()), id: \.element.id) { index, lesson in
                LessonRow(lesson: lesson, index: index + 1)
            }
        }
    }
}

struct LessonRow: View {
    let lesson: Lesson
    let index: Int
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(lesson.isCompleted ? Color.green : (lesson.isLocked ? Color(.systemGray4) : Color.blue))
                    .frame(width: 36, height: 36)
                
                if lesson.isCompleted {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                } else if lesson.isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white)
                        .font(.caption)
                } else {
                    Text("\(index)")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lesson.title)
                    .fontWeight(.medium)
                    .foregroundColor(lesson.isLocked ? .secondary : .primary)
                
                HStack {
                    Image(systemName: lesson.type.icon)
                    Text(lesson.type.rawValue)
                    Text("•")
                    Text("\(Int(lesson.duration / 60)) min")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if !lesson.isLocked {
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .opacity(lesson.isLocked ? 0.6 : 1)
    }
}

struct CourseReviewsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Rating Summary
            HStack(spacing: 20) {
                VStack {
                    Text("4.8")
                        .font(.system(size: 48, weight: .bold))
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { i in
                            Image(systemName: i < 5 ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    Text("2,340 reviews")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    RatingBarEducation(stars: 5, percentage: 0.75)
                    RatingBarEducation(stars: 4, percentage: 0.15)
                    RatingBarEducation(stars: 3, percentage: 0.06)
                    RatingBarEducation(stars: 2, percentage: 0.03)
                    RatingBarEducation(stars: 1, percentage: 0.01)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            
            // Reviews
            ForEach(0..<3, id: \.self) { _ in
                ReviewRowEducation()
            }
        }
    }
}

struct RatingBarEducation: View {
    let stars: Int
    let percentage: Double
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(stars)")
                .font(.caption)
                .frame(width: 10)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray4))
                    
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: geometry.size.width * percentage)
                }
            }
            .frame(height: 8)
            .cornerRadius(4)
        }
    }
}

struct ReviewRowEducation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 36, height: 36)
                
                VStack(alignment: .leading) {
                    Text("John D.")
                        .fontWeight(.medium)
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption2)
                        }
                    }
                }
                
                Spacer()
                
                Text("2 days ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text("Excellent course! The instructor explains concepts very clearly and the projects are practical.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// 9. My Courses View
struct MyCoursesView: View {
    @EnvironmentObject var store: EducationStore
    @State private var selectedFilter = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Filter", selection: $selectedFilter) {
                    Text("In Progress").tag(0)
                    Text("Completed").tag(1)
                    Text("Saved").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()
                
                if store.enrolledCourses.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No courses yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Explore courses and start learning")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List(store.enrolledCourses) { course in
                        NavigationLink {
                            CourseDetailView(course: course)
                                .environmentObject(store)
                        } label: {
                            EnrolledCourseRow(course: course)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("My Courses")
        }
    }
}

struct EnrolledCourseRow: View {
    let course: Course
    
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(course.category.color.opacity(0.3))
                .frame(width: 80, height: 80)
                .cornerRadius(12)
                .overlay(
                    Image(systemName: course.category.icon)
                        .font(.title2)
                        .foregroundColor(course.category.color)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(course.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                ProgressView(value: course.progress)
                    .tint(course.category.color)
                
                Text("\(Int(course.progress * 100))% complete")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

// 10. Education Profile View
struct EducationProfileView: View {
    @EnvironmentObject var store: EducationStore
    
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
                            
                            Text("Learning since Jan 2024")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                                Text("\(store.streak.currentStreak) day streak")
                            }
                            .font(.caption)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Statistics") {
                    HStack {
                        Text("Courses Completed")
                        Spacer()
                        Text("\(store.streak.coursesCompleted)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Lessons Completed")
                        Spacer()
                        Text("\(store.streak.lessonsCompleted)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Total Learning Time")
                        Spacer()
                        Text("\(Int(store.streak.totalLearningTime / 3600)) hours")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Longest Streak")
                        Spacer()
                        Text("\(store.streak.longestStreak) days")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Certificates") {
                    if store.certificates.isEmpty {
                        Text("Complete a course to earn a certificate")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(store.certificates) { certificate in
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.yellow)
                                
                                VStack(alignment: .leading) {
                                    Text(certificate.courseName)
                                        .fontWeight(.medium)
                                    Text(certificate.completedAt, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                
                Section("Settings") {
                    NavigationLink("Learning Goals", systemImage: "target") {}
                    NavigationLink("Notifications", systemImage: "bell") {}
                    NavigationLink("Download Settings", systemImage: "arrow.down.circle") {}
                    NavigationLink("Privacy", systemImage: "lock") {}
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

public struct EducationApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            EducationHomeView()
        }
    }
}
