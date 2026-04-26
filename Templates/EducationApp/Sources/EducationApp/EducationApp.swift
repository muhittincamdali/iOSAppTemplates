import SwiftUI
import EducationAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct EducationAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            EducationWorkspaceRootView(
                snapshot: .sample,
                actions: EducationQuickAction.defaultActions,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationWorkspaceRootView: View {
    let snapshot: EducationDashboardSnapshot
    let actions: [EducationQuickAction]
    let state: EducationWorkspaceState

    var body: some View {
        TabView {
            EducationDashboardView(snapshot: snapshot, actions: actions, state: state)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            EducationCoursesView(state: state)
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Courses")
                }

            EducationLessonsView(state: state)
                .tabItem {
                    Image(systemName: "play.rectangle")
                    Text("Lessons")
                }

            EducationQuizHubView(state: state)
                .tabItem {
                    Image(systemName: "checklist.checked")
                    Text("Quizzes")
                }

            EducationProgressView(state: state)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Progress")
                }
        }
        .tint(.teal)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationDashboardView: View {
    let snapshot: EducationDashboardSnapshot
    let actions: [EducationQuickAction]
    let state: EducationWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    EducationHeroCard(snapshot: snapshot, state: state)
                    EducationQuickActionGrid(actions: actions)
                    EducationContinueLearningCard(lesson: state.nextLesson)
                    EducationDeadlineCard(assignments: state.assignments)
                    EducationCourseMomentumCard(courses: state.courses)
                }
                .padding(16)
            }
            .navigationTitle("Learning")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationHeroCard: View {
    let snapshot: EducationDashboardSnapshot
    let state: EducationWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Student Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(snapshot.nextMilestone)
                .font(.title2.weight(.bold))
            Text(snapshot.coachMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                EducationMetricChip(title: "Active Courses", value: "\(snapshot.activeCourses)")
                EducationMetricChip(title: "Completion", value: snapshot.completionRate)
                EducationMetricChip(title: "Study Streak", value: state.studyStreak)
            }

            HStack {
                Label(state.weeklyGoal, systemImage: "flag.checkered")
                Spacer()
                Text(state.coachStatus)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline.weight(.semibold))
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.teal.opacity(0.16), .cyan.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationMetricChip: View {
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

@available(iOS 18.0, macOS 15.0, *)
struct EducationQuickActionGrid: View {
    let actions: [EducationQuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions) { action in
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: action.systemImage)
                            .font(.title3)
                            .foregroundStyle(.teal)
                        Text(action.title)
                            .font(.subheadline.weight(.semibold))
                        Text(action.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationContinueLearningCard: View {
    let lesson: EducationLesson

    var body: some View {
        NavigationLink {
            EducationLessonDetailView(lesson: lesson)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                Text("Continue Learning")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                Text(lesson.title)
                    .font(.headline)
                Text(lesson.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack {
                    Label(lesson.course, systemImage: "book")
                    Spacer()
                    Text(lesson.duration)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationDeadlineCard: View {
    let assignments: [EducationAssignment]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Due Soon")
                .font(.title3.weight(.bold))

            ForEach(assignments.prefix(3)) { assignment in
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(assignment.priority.color)
                        .frame(width: 10, height: 10)
                        .padding(.top, 6)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(assignment.title)
                            .font(.headline)
                        Text(assignment.course)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Due \(assignment.dueDate)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationCourseMomentumCard: View {
    let courses: [EducationCourse]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Course Momentum")
                .font(.title3.weight(.bold))

            ForEach(courses) { course in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(course.title)
                            .font(.headline)
                        Spacer()
                        Text(course.pace)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(course.paceColor)
                    }
                    ProgressView(value: course.progress)
                        .tint(course.paceColor)
                    Text(course.nextStep)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationCoursesView: View {
    let state: EducationWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Courses") {
                    ForEach(state.courses) { course in
                        NavigationLink {
                            EducationCourseDetailView(course: course, lessons: state.lessons.filter { $0.course == course.title })
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(course.title)
                                    Spacer()
                                    Text("\(Int(course.progress * 100))%")
                                        .font(.subheadline.weight(.bold))
                                }
                                ProgressView(value: course.progress)
                                    .tint(course.paceColor)
                                Text(course.nextStep)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Courses")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationLessonsView: View {
    let state: EducationWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Today") {
                    ForEach(state.lessons.prefix(3)) { lesson in
                        NavigationLink {
                            EducationLessonDetailView(lesson: lesson)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(lesson.title)
                                Text("\(lesson.course) • \(lesson.duration)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Saved Notes") {
                    ForEach(state.lessonNotes, id: \.self) { note in
                        Label(note, systemImage: "note.text")
                    }
                }
            }
            .navigationTitle("Lessons")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationQuizHubView: View {
    let state: EducationWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Quizzes") {
                    ForEach(state.quizzes) { quiz in
                        NavigationLink {
                            EducationQuizDetailView(quiz: quiz)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(quiz.title)
                                    Spacer()
                                    Text(quiz.status)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(quiz.statusColor)
                                }
                                Text("\(quiz.questionCount) questions • \(quiz.dueDate)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Assignments") {
                    ForEach(state.assignments) { assignment in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(assignment.title)
                            Text("Due \(assignment.dueDate)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Assessments")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationProgressView: View {
    let state: EducationWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Progress") {
                    LabeledContent("Study Streak", value: state.studyStreak)
                    LabeledContent("Completed Lessons", value: state.completedLessons)
                    LabeledContent("Quiz Average", value: state.quizAverage)
                }

                Section("Wins") {
                    ForEach(state.progressWins, id: \.self) { win in
                        Label(win, systemImage: "sparkles")
                    }
                }

                Section("Next Coaching Moves") {
                    ForEach(state.coachingMoves, id: \.self) { move in
                        Label(move, systemImage: "arrow.right.circle")
                    }
                }
            }
            .navigationTitle("Progress")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationCourseDetailView: View {
    let course: EducationCourse
    let lessons: [EducationLesson]

    var body: some View {
        List {
            Section("Course") {
                LabeledContent("Title", value: course.title)
                LabeledContent("Progress", value: "\(Int(course.progress * 100))%")
                LabeledContent("Next Step", value: course.nextStep)
            }

            Section("Lessons") {
                ForEach(lessons) { lesson in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(lesson.title)
                        Text(lesson.duration)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle(course.title)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationLessonDetailView: View {
    let lesson: EducationLesson

    var body: some View {
        List {
            Section("Lesson") {
                Text(lesson.title)
                    .font(.headline)
                Text(lesson.summary)
                    .foregroundStyle(.secondary)
            }

            Section("Session") {
                LabeledContent("Course", value: lesson.course)
                LabeledContent("Duration", value: lesson.duration)
                LabeledContent("Resource", value: lesson.resourceType)
            }
        }
        .navigationTitle("Lesson")
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct EducationQuizDetailView: View {
    let quiz: EducationQuiz

    var body: some View {
        List {
            Section("Quiz") {
                LabeledContent("Title", value: quiz.title)
                LabeledContent("Questions", value: "\(quiz.questionCount)")
                LabeledContent("Due", value: quiz.dueDate)
                LabeledContent("Status", value: quiz.status)
            }

            Section("Guidance") {
                Text(quiz.guidance)
            }
        }
        .navigationTitle("Quiz")
    }
}

public struct EducationQuickAction: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let detail: String
    public let systemImage: String

    public init(
        id: UUID = UUID(),
        title: String,
        detail: String,
        systemImage: String
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.systemImage = systemImage
    }

    public static let defaultActions: [EducationQuickAction] = [
        EducationQuickAction(title: "Continue Course", detail: "Resume the next lesson in the design systems path.", systemImage: "play.circle.fill"),
        EducationQuickAction(title: "Open Quiz", detail: "Review the highest-risk assessment before tomorrow's deadline.", systemImage: "questionmark.circle.fill"),
        EducationQuickAction(title: "Review Progress", detail: "Compare current completion pace against the weekly coaching goal.", systemImage: "chart.bar.fill"),
        EducationQuickAction(title: "Capture Notes", detail: "Save takeaways from the latest workshop and apply them to the next assignment.", systemImage: "square.and.pencil")
    ]
}

struct EducationWorkspaceState: Hashable, Sendable {
    let weeklyGoal: String
    let coachStatus: String
    let studyStreak: String
    let completedLessons: String
    let quizAverage: String
    let nextLesson: EducationLesson
    let courses: [EducationCourse]
    let lessons: [EducationLesson]
    let quizzes: [EducationQuiz]
    let assignments: [EducationAssignment]
    let progressWins: [String]
    let coachingMoves: [String]
    let lessonNotes: [String]

    static let sample = EducationWorkspaceState(
        weeklyGoal: "Finish two lessons and submit the mobile UI case study.",
        coachStatus: "On pace",
        studyStreak: "12 days",
        completedLessons: "28",
        quizAverage: "91%",
        nextLesson: EducationLesson(course: "Design Systems", title: "Token orchestration across iOS surfaces", summary: "Translate typography, spacing, and motion tokens into reusable SwiftUI primitives.", duration: "18 min", resourceType: "Video + notes"),
        courses: [
            EducationCourse(title: "Design Systems", progress: 0.78, nextStep: "Ship the token exercise and pass Quiz 4.", pace: "Ahead", paceColor: .green),
            EducationCourse(title: "Product Analytics", progress: 0.62, nextStep: "Complete funnel instrumentation lesson.", pace: "On track", paceColor: .blue),
            EducationCourse(title: "Growth Writing", progress: 0.54, nextStep: "Submit the onboarding rewrite peer review.", pace: "Needs focus", paceColor: .orange)
        ],
        lessons: [
            EducationLesson(course: "Design Systems", title: "Token orchestration across iOS surfaces", summary: "Translate typography, spacing, and motion tokens into reusable SwiftUI primitives.", duration: "18 min", resourceType: "Video + notes"),
            EducationLesson(course: "Product Analytics", title: "Lifecycle dashboard baselines", summary: "Build a retention and activation lens for weekly reporting.", duration: "14 min", resourceType: "Workshop"),
            EducationLesson(course: "Growth Writing", title: "Rewrite the first-run onboarding", summary: "Turn product value into clear learning prompts and friction removal.", duration: "11 min", resourceType: "Reading")
        ],
        quizzes: [
            EducationQuiz(title: "Quiz 4: Component contracts", questionCount: 12, dueDate: "Tomorrow", status: "Ready", statusColor: .green, guidance: "Focus on naming consistency, hierarchy decisions, and token fallback rules."),
            EducationQuiz(title: "Quiz 3: Funnel analysis", questionCount: 10, dueDate: "Apr 29", status: "Needs review", statusColor: .orange, guidance: "Review activation metrics before attempting the scenario questions.")
        ],
        assignments: [
            EducationAssignment(title: "Mobile UI case study", course: "Design Systems", dueDate: "Tomorrow", priority: .high),
            EducationAssignment(title: "Instrumentation workbook", course: "Product Analytics", dueDate: "Apr 28", priority: .medium),
            EducationAssignment(title: "Peer review notes", course: "Growth Writing", dueDate: "Apr 30", priority: .medium)
        ],
        progressWins: [
            "Finished the full lesson sequence for analytics cohort week 3.",
            "Raised quiz performance from 84% to 91% over the last two sprints.",
            "Closed the backlog on missed annotations for the design systems course."
        ],
        coachingMoves: [
            "Block a 45-minute deep work slot for the case study before noon.",
            "Review last quiz mistakes before starting the next assessment.",
            "Convert workshop notes into flashcards while the context is still fresh."
        ],
        lessonNotes: [
            "Keep motion tokens separate from semantic animation presets.",
            "Funnel drop-off without cohort context hides the real retention story.",
            "Learning copy should explain the payoff before the instruction."
        ]
    )
}

struct EducationCourse: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let progress: Double
    let nextStep: String
    let pace: String
    let paceColor: Color
}

struct EducationLesson: Identifiable, Hashable, Sendable {
    let id = UUID()
    let course: String
    let title: String
    let summary: String
    let duration: String
    let resourceType: String
}

struct EducationQuiz: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let questionCount: Int
    let dueDate: String
    let status: String
    let statusColor: Color
    let guidance: String
}

struct EducationAssignment: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let course: String
    let dueDate: String
    let priority: EducationPriority
}

enum EducationPriority: Hashable, Sendable {
    case high
    case medium

    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        }
    }
}
