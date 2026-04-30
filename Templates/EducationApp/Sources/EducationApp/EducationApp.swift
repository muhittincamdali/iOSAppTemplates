import Foundation
import SwiftUI
import EducationAppCore

private enum EducationInteractionProofMode {
    static let isEnabled = ProcessInfo.processInfo.environment["IOSAPPTEMPLATES_INTERACTION_PROOF_MODE"] == "1"

    static func write(summary: String, steps: [String]) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let payload: [String: Any] = [
            "app": "EducationApp",
            "status": "completed",
            "summary": summary,
            "steps": steps,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]

        guard JSONSerialization.isValidJSONObject(payload),
              let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys]) else {
            return
        }

        try? data.write(to: documentsURL.appendingPathComponent("interaction-proof.json"), options: [.atomic])
    }
}

public struct EducationAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            EducationRuntimeRootView()
        }
    }
}

struct EducationRuntimeRootView: View {
    @StateObject private var store = EducationLearningStore()

    var body: some View {
        TabView {
            EducationDashboardView(store: store)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            EducationCoursesView(store: store)
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Courses")
                }

            EducationLessonsView(store: store)
                .tabItem {
                    Image(systemName: "play.rectangle.fill")
                    Text("Lessons")
                }

            EducationAssessmentView(store: store)
                .tabItem {
                    Image(systemName: "checklist.checked")
                    Text("Assessments")
                }

            EducationProgressView(store: store)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Progress")
                }
        }
        .tint(.teal)
        .onAppear {
            store.runInteractionProofIfNeeded()
        }
    }
}

@MainActor
final class EducationLearningStore: ObservableObject {
    @Published var courses: [EducationCourseRecord] = EducationCourseRecord.sampleCourses
    @Published var lessons: [EducationLessonRecord] = EducationLessonRecord.sampleLessons
    @Published var quizzes: [EducationQuizRecord] = EducationQuizRecord.sampleQuizzes
    @Published var assignments: [EducationAssignmentRecord] = EducationAssignmentRecord.sampleAssignments
    @Published var notes: [EducationNoteRecord] = EducationNoteRecord.sampleNotes
    @Published var noteDraft = ""
    @Published var selectedLessonID: UUID?
    @Published var selectedCourseID: UUID?
    @Published var studyStreakDays = 12
    @Published var completedLessonsCount = 28
    @Published var quizAverage = 91
    private var interactionProofScheduled = false

    init() {
        selectedLessonID = lessons.first?.id
        selectedCourseID = courses.first?.id
    }

    var selectedLesson: EducationLessonRecord? {
        lessons.first(where: { $0.id == selectedLessonID }) ?? lessons.first
    }

    var selectedCourse: EducationCourseRecord? {
        courses.first(where: { $0.id == selectedCourseID }) ?? courses.first
    }

    var nextLesson: EducationLessonRecord? {
        lessons.first(where: { !$0.isCompleted }) ?? lessons.first
    }

    var activeAssignments: [EducationAssignmentRecord] {
        assignments.filter { !$0.isSubmitted }
    }

    var completionRateText: String {
        let average = Int((courses.map(\.progress).reduce(0, +) / Double(max(courses.count, 1))) * 100)
        return "\(average)%"
    }

    var dashboardHeadline: String {
        if quizzes.contains(where: { $0.status == .readyToSubmit }) {
            return "One assessment is ready to submit and can unlock the next module."
        }
        if assignments.contains(where: { !$0.isSubmitted && $0.priority == .high }) {
            return "A high-priority assignment still needs submission before the deadline."
        }
        return "Learning pace is healthy and the next lesson is ready."
    }

    func selectCourse(_ id: UUID) {
        selectedCourseID = id
    }

    func selectLesson(_ id: UUID) {
        selectedLessonID = id
    }

    func completeLesson(_ lessonID: UUID) {
        guard let lessonIndex = lessons.firstIndex(where: { $0.id == lessonID }),
              !lessons[lessonIndex].isCompleted else { return }
        lessons[lessonIndex].isCompleted = true
        completedLessonsCount += 1
        studyStreakDays += 1

        if let courseIndex = courses.firstIndex(where: { $0.title == lessons[lessonIndex].course }) {
            courses[courseIndex].progress = min(1, courses[courseIndex].progress + 0.08)
            courses[courseIndex].nextStep = "Take the checkpoint quiz to lock this lesson."
        }

        if let quizIndex = quizzes.firstIndex(where: { $0.course == lessons[lessonIndex].course && $0.status == .locked }) {
            quizzes[quizIndex].status = .ready
        }
    }

    func saveLessonNote() {
        let trimmed = noteDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let lesson = selectedLesson else { return }
        notes.insert(
            EducationNoteRecord(lessonTitle: lesson.title, body: trimmed, isPinned: false),
            at: 0
        )
        noteDraft = ""
    }

    func togglePinnedNote(_ noteID: UUID) {
        guard let index = notes.firstIndex(where: { $0.id == noteID }) else { return }
        notes[index].isPinned.toggle()
    }

    func answerQuizQuestion(_ quizID: UUID) {
        guard let index = quizzes.firstIndex(where: { $0.id == quizID }),
              quizzes[index].status == .ready || quizzes[index].status == .inProgress else { return }
        quizzes[index].status = .inProgress
        quizzes[index].answeredQuestions = min(quizzes[index].questionCount, quizzes[index].answeredQuestions + 1)
        if quizzes[index].answeredQuestions == quizzes[index].questionCount {
            quizzes[index].status = .readyToSubmit
        }
    }

    func submitQuiz(_ quizID: UUID) {
        guard let index = quizzes.firstIndex(where: { $0.id == quizID }),
              quizzes[index].status == .readyToSubmit else { return }
        quizzes[index].status = .submitted
        quizzes[index].score = max(quizzes[index].score, 94)
        quizAverage = min(99, max(quizAverage, quizzes[index].score))

        if let courseIndex = courses.firstIndex(where: { $0.title == quizzes[index].course }) {
            courses[courseIndex].progress = min(1, courses[courseIndex].progress + 0.07)
            courses[courseIndex].nextStep = "Submit the assignment while the lesson context is still fresh."
        }

        if let assignmentIndex = assignments.firstIndex(where: { $0.course == quizzes[index].course && !$0.isSubmitted }) {
            assignments[assignmentIndex].status = "Ready to submit"
        }
    }

    func submitAssignment(_ assignmentID: UUID) {
        guard let index = assignments.firstIndex(where: { $0.id == assignmentID }),
              !assignments[index].isSubmitted else { return }
        assignments[index].isSubmitted = true
        assignments[index].status = "Submitted"

        if let courseIndex = courses.firstIndex(where: { $0.title == assignments[index].course }) {
            courses[courseIndex].progress = min(1, courses[courseIndex].progress + 0.1)
            courses[courseIndex].nextStep = "Great. Move into the next module and coaching review."
        }
    }

    func runInteractionProofIfNeeded() {
        guard EducationInteractionProofMode.isEnabled, !interactionProofScheduled else { return }
        interactionProofScheduled = true

        DispatchQueue.main.async {
            var steps: [String] = []

            if let courseID = self.courses.first?.id {
                self.selectCourse(courseID)
                steps.append("Selected course")
            }

            if let lessonID = self.nextLesson?.id {
                self.selectLesson(lessonID)
                self.completeLesson(lessonID)
                steps.append("Completed lesson")
            }

            self.noteDraft = "Checkpoint summary pinned for assessment follow-through."
            self.saveLessonNote()
            steps.append("Saved lesson note")

            if let noteID = self.notes.first?.id {
                self.togglePinnedNote(noteID)
                steps.append("Pinned note")
            }

            if let quiz = self.quizzes.first {
                while let current = self.quizzes.first(where: { $0.id == quiz.id }),
                      current.status == .ready || current.status == .inProgress {
                    self.answerQuizQuestion(quiz.id)
                    if current.answeredQuestions >= current.questionCount {
                        break
                    }
                }
                self.submitQuiz(quiz.id)
                steps.append("Submitted quiz")
            }

            if let assignmentID = self.assignments.first(where: { !$0.isSubmitted })?.id {
                self.submitAssignment(assignmentID)
                steps.append("Submitted assignment")
            }

            EducationInteractionProofMode.write(
                summary: "Education interaction proof completed with lesson, note, quiz, and assignment chain.",
                steps: steps
            )
        }
    }
}

struct EducationDashboardView: View {
    @ObservedObject var store: EducationLearningStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    EducationHeroCard(store: store)
                    if let lesson = store.nextLesson {
                        EducationContinueLearningCard(store: store, lesson: lesson)
                    }
                    EducationDeadlineCard(store: store)
                    EducationCourseMomentumCard(store: store)
                }
                .padding(16)
            }
            .navigationTitle("Learning")
        }
    }
}

struct EducationHeroCard: View {
    @ObservedObject var store: EducationLearningStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Student Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(store.dashboardHeadline)
                .font(.title2.weight(.bold))
            Text("Completion \(store.completionRateText) • Streak \(store.studyStreakDays) days • Quiz average \(store.quizAverage)%")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                EducationMetricChip(title: "Courses", value: "\(store.courses.count)")
                EducationMetricChip(title: "Lessons", value: "\(store.completedLessonsCount)")
                EducationMetricChip(title: "Open Work", value: "\(store.activeAssignments.count)")
            }
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

struct EducationContinueLearningCard: View {
    @ObservedObject var store: EducationLearningStore
    let lesson: EducationLessonRecord

    var body: some View {
        NavigationLink {
            EducationLessonDetailView(store: store, lessonID: lesson.id)
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

struct EducationDeadlineCard: View {
    @ObservedObject var store: EducationLearningStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Due Soon")
                .font(.title3.weight(.bold))

            ForEach(store.activeAssignments.prefix(3)) { assignment in
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

struct EducationCourseMomentumCard: View {
    @ObservedObject var store: EducationLearningStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Course Momentum")
                .font(.title3.weight(.bold))

            ForEach(store.courses) { course in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(course.title)
                            .font(.headline)
                        Spacer()
                        Text("\(Int(course.progress * 100))%")
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

struct EducationCoursesView: View {
    @ObservedObject var store: EducationLearningStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.courses) { course in
                    NavigationLink {
                        EducationCourseDetailView(store: store, courseID: course.id)
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
            .navigationTitle("Courses")
        }
    }
}

struct EducationCourseDetailView: View {
    @ObservedObject var store: EducationLearningStore
    let courseID: UUID

    var body: some View {
        if let course = store.courses.first(where: { $0.id == courseID }) {
            List {
                Section("Course") {
                    LabeledContent("Title", value: course.title)
                    LabeledContent("Progress", value: "\(Int(course.progress * 100))%")
                    LabeledContent("Next Step", value: course.nextStep)
                }

                Section("Lessons") {
                    ForEach(store.lessons.filter { $0.course == course.title }) { lesson in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(lesson.title)
                            Text(lesson.isCompleted ? "Completed" : lesson.duration)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle(course.title)
        }
    }
}

struct EducationLessonsView: View {
    @ObservedObject var store: EducationLearningStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.lessons) { lesson in
                    NavigationLink {
                        EducationLessonDetailView(store: store, lessonID: lesson.id)
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
            .navigationTitle("Lessons")
        }
    }
}

struct EducationLessonDetailView: View {
    @ObservedObject var store: EducationLearningStore
    let lessonID: UUID

    var body: some View {
        if let lesson = store.lessons.first(where: { $0.id == lessonID }) {
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

                Section("Actions") {
                    Button(lesson.isCompleted ? "Lesson Completed" : "Complete Lesson") {
                        store.completeLesson(lesson.id)
                    }
                    .disabled(lesson.isCompleted)
                }

                Section("Capture Note") {
                    TextEditor(text: $store.noteDraft)
                        .frame(minHeight: 120)
                    Button("Save Note") {
                        store.selectLesson(lesson.id)
                        store.saveLessonNote()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Lesson")
        }
    }
}

struct EducationAssessmentView: View {
    @ObservedObject var store: EducationLearningStore

    var body: some View {
        NavigationStack {
            List {
                Section("Quizzes") {
                    ForEach(store.quizzes) { quiz in
                        NavigationLink {
                            EducationQuizDetailView(store: store, quizID: quiz.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(quiz.title)
                                    Spacer()
                                    Text(quiz.status.label)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(quiz.status.color)
                                }
                                Text("\(quiz.questionCount) questions • \(quiz.dueDate)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Assignments") {
                    ForEach(store.assignments) { assignment in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(assignment.title)
                            Text("Due \(assignment.dueDate) • \(assignment.status)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            if !assignment.isSubmitted {
                                Button("Submit Assignment") {
                                    store.submitAssignment(assignment.id)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Assessments")
        }
    }
}

struct EducationQuizDetailView: View {
    @ObservedObject var store: EducationLearningStore
    let quizID: UUID

    var body: some View {
        if let quiz = store.quizzes.first(where: { $0.id == quizID }) {
            List {
                Section("Quiz") {
                    LabeledContent("Title", value: quiz.title)
                    LabeledContent("Questions", value: "\(quiz.questionCount)")
                    LabeledContent("Due", value: quiz.dueDate)
                    LabeledContent("Status", value: quiz.status.label)
                }

                Section("Progress") {
                    LabeledContent("Answered", value: "\(quiz.answeredQuestions)/\(quiz.questionCount)")
                    if quiz.score > 0 {
                        LabeledContent("Score", value: "\(quiz.score)%")
                    }
                    Text(quiz.guidance)
                }

                Section("Actions") {
                    if quiz.status == .ready || quiz.status == .inProgress {
                        Button("Answer Next Question") {
                            store.answerQuizQuestion(quiz.id)
                        }
                    }
                    if quiz.status == .readyToSubmit {
                        Button("Submit Quiz") {
                            store.submitQuiz(quiz.id)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Quiz")
        }
    }
}

struct EducationProgressView: View {
    @ObservedObject var store: EducationLearningStore

    var body: some View {
        NavigationStack {
            List {
                Section("Progress") {
                    LabeledContent("Study Streak", value: "\(store.studyStreakDays) days")
                    LabeledContent("Completed Lessons", value: "\(store.completedLessonsCount)")
                    LabeledContent("Quiz Average", value: "\(store.quizAverage)%")
                }

                Section("Pinned Notes") {
                    ForEach(store.notes) { note in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(note.lessonTitle)
                                    .font(.headline)
                                Spacer()
                                Button(note.isPinned ? "Unpin" : "Pin") {
                                    store.togglePinnedNote(note.id)
                                }
                                .buttonStyle(.borderless)
                            }
                            Text(note.body)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Progress")
        }
    }
}

struct EducationCourseRecord: Identifiable {
    let id = UUID()
    let title: String
    var progress: Double
    var nextStep: String
    let paceColor: Color

    static let sampleCourses: [EducationCourseRecord] = [
        EducationCourseRecord(title: "Design Systems", progress: 0.78, nextStep: "Ship the token exercise and pass Quiz 4.", paceColor: .green),
        EducationCourseRecord(title: "Product Analytics", progress: 0.62, nextStep: "Complete funnel instrumentation lesson.", paceColor: .blue),
        EducationCourseRecord(title: "Growth Writing", progress: 0.54, nextStep: "Submit the onboarding rewrite peer review.", paceColor: .orange)
    ]
}

struct EducationLessonRecord: Identifiable {
    let id = UUID()
    let course: String
    let title: String
    let summary: String
    let duration: String
    let resourceType: String
    var isCompleted: Bool

    static let sampleLessons: [EducationLessonRecord] = [
        EducationLessonRecord(course: "Design Systems", title: "Token orchestration across iOS surfaces", summary: "Translate typography, spacing, and motion tokens into reusable SwiftUI primitives.", duration: "18 min", resourceType: "Video + notes", isCompleted: false),
        EducationLessonRecord(course: "Product Analytics", title: "Lifecycle dashboard baselines", summary: "Build a retention and activation lens for weekly reporting.", duration: "14 min", resourceType: "Workshop", isCompleted: false),
        EducationLessonRecord(course: "Growth Writing", title: "Rewrite the first-run onboarding", summary: "Turn product value into clear learning prompts and friction removal.", duration: "11 min", resourceType: "Reading", isCompleted: false)
    ]
}

enum EducationQuizStatus {
    case locked
    case ready
    case inProgress
    case readyToSubmit
    case submitted

    var label: String {
        switch self {
        case .locked: return "Locked"
        case .ready: return "Ready"
        case .inProgress: return "In progress"
        case .readyToSubmit: return "Ready to submit"
        case .submitted: return "Submitted"
        }
    }

    var color: Color {
        switch self {
        case .locked: return .secondary
        case .ready: return .green
        case .inProgress: return .blue
        case .readyToSubmit: return .orange
        case .submitted: return .teal
        }
    }
}

struct EducationQuizRecord: Identifiable {
    let id = UUID()
    let course: String
    let title: String
    let questionCount: Int
    let dueDate: String
    let guidance: String
    var status: EducationQuizStatus
    var answeredQuestions: Int
    var score: Int

    static let sampleQuizzes: [EducationQuizRecord] = [
        EducationQuizRecord(course: "Design Systems", title: "Quiz 4: Component contracts", questionCount: 12, dueDate: "Tomorrow", guidance: "Focus on naming consistency, hierarchy decisions, and token fallback rules.", status: .ready, answeredQuestions: 0, score: 0),
        EducationQuizRecord(course: "Product Analytics", title: "Quiz 3: Funnel analysis", questionCount: 10, dueDate: "Apr 29", guidance: "Review activation metrics before attempting the scenario questions.", status: .locked, answeredQuestions: 0, score: 0)
    ]
}

enum EducationPriority {
    case high
    case medium

    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        }
    }
}

struct EducationAssignmentRecord: Identifiable {
    let id = UUID()
    let title: String
    let course: String
    let dueDate: String
    let priority: EducationPriority
    var status: String
    var isSubmitted: Bool

    static let sampleAssignments: [EducationAssignmentRecord] = [
        EducationAssignmentRecord(title: "Mobile UI case study", course: "Design Systems", dueDate: "Tomorrow", priority: .high, status: "Draft in progress", isSubmitted: false),
        EducationAssignmentRecord(title: "Instrumentation workbook", course: "Product Analytics", dueDate: "Apr 28", priority: .medium, status: "Waiting on quiz unlock", isSubmitted: false),
        EducationAssignmentRecord(title: "Peer review notes", course: "Growth Writing", dueDate: "Apr 30", priority: .medium, status: "Ready to polish", isSubmitted: false)
    ]
}

struct EducationNoteRecord: Identifiable {
    let id = UUID()
    let lessonTitle: String
    let body: String
    var isPinned: Bool

    static let sampleNotes: [EducationNoteRecord] = [
        EducationNoteRecord(lessonTitle: "Token orchestration across iOS surfaces", body: "Keep motion tokens separate from semantic animation presets.", isPinned: true),
        EducationNoteRecord(lessonTitle: "Lifecycle dashboard baselines", body: "Funnel drop-off without cohort context hides the real retention story.", isPinned: false)
    ]
}
