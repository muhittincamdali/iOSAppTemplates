import Foundation
import SwiftUI
import AVFoundation
import PDFKit

// MARK: - Education Templates
public struct EducationTemplates {
    
    // MARK: - Version
    public static let version = "1.0.0"
    
    // MARK: - Initialization
    public static func initialize() {
        print("📚 Education Templates v\(version) initialized")
    }
}

// MARK: - Learning App Template
public struct LearningAppTemplate {
    
    // MARK: - Models
    public struct Course: Identifiable, Codable {
        public let id: String
        public let title: String
        public let description: String?
        public let subject: Subject
        public let level: CourseLevel
        public let instructor: String
        public let duration: TimeInterval
        public let lessons: [Lesson]
        public let quizzes: [Quiz]
        public let assignments: [Assignment]
        public let materials: [LearningMaterial]
        public let enrollmentCount: Int
        public let rating: Double?
        public let reviewCount: Int
        public let isEnrolled: Bool
        public let progress: Double
        public let certificateEligible: Bool
        public let certificateIssued: Bool
        public let certificateURL: String?
        public let tags: [String]
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            description: String? = nil,
            subject: Subject,
            level: CourseLevel,
            instructor: String,
            duration: TimeInterval,
            lessons: [Lesson] = [],
            quizzes: [Quiz] = [],
            assignments: [Assignment] = [],
            materials: [LearningMaterial] = [],
            enrollmentCount: Int = 0,
            rating: Double? = nil,
            reviewCount: Int = 0,
            isEnrolled: Bool = false,
            progress: Double = 0.0,
            certificateEligible: Bool = false,
            certificateIssued: Bool = false,
            certificateURL: String? = nil,
            tags: [String] = [],
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.subject = subject
            self.level = level
            self.instructor = instructor
            self.duration = duration
            self.lessons = lessons
            self.quizzes = quizzes
            self.assignments = assignments
            self.materials = materials
            self.enrollmentCount = enrollmentCount
            self.rating = rating
            self.reviewCount = reviewCount
            self.isEnrolled = isEnrolled
            self.progress = progress
            self.certificateEligible = certificateEligible
            self.certificateIssued = certificateIssued
            self.certificateURL = certificateURL
            self.tags = tags
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
    
    public struct Lesson: Identifiable, Codable {
        public let id: String
        public let title: String
        public let description: String?
        public let content: String
        public let videoURL: String?
        public let audioURL: String?
        public let duration: TimeInterval
        public let order: Int
        public let isCompleted: Bool
        public let completedAt: Date?
        public let notes: [Note]
        public let attachments: [LessonAttachment]
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            description: String? = nil,
            content: String,
            videoURL: String? = nil,
            audioURL: String? = nil,
            duration: TimeInterval,
            order: Int,
            isCompleted: Bool = false,
            completedAt: Date? = nil,
            notes: [Note] = [],
            attachments: [LessonAttachment] = []
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.content = content
            self.videoURL = videoURL
            self.audioURL = audioURL
            self.duration = duration
            self.order = order
            self.isCompleted = isCompleted
            self.completedAt = completedAt
            self.notes = notes
            self.attachments = attachments
        }
    }
    
    public struct Quiz: Identifiable, Codable {
        public let id: String
        public let title: String
        public let description: String?
        public let questions: [Question]
        public let timeLimit: TimeInterval?
        public let passingScore: Double
        public let attempts: Int
        public let currentAttempt: Int
        public let bestScore: Double?
        public let isCompleted: Bool
        public let completedAt: Date?
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            description: String? = nil,
            questions: [Question],
            timeLimit: TimeInterval? = nil,
            passingScore: Double = 70.0,
            attempts: Int = 3,
            currentAttempt: Int = 0,
            bestScore: Double? = nil,
            isCompleted: Bool = false,
            completedAt: Date? = nil
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.questions = questions
            self.timeLimit = timeLimit
            self.passingScore = passingScore
            self.attempts = attempts
            self.currentAttempt = currentAttempt
            self.bestScore = bestScore
            self.isCompleted = isCompleted
            self.completedAt = completedAt
        }
    }
    
    public struct Question: Identifiable, Codable {
        public let id: String
        public let text: String
        public let type: QuestionType
        public let options: [String]?
        public let correctAnswer: String?
        public let correctAnswers: [String]?
        public let points: Int
        public let explanation: String?
        
        public init(
            id: String = UUID().uuidString,
            text: String,
            type: QuestionType,
            options: [String]? = nil,
            correctAnswer: String? = nil,
            correctAnswers: [String]? = nil,
            points: Int = 1,
            explanation: String? = nil
        ) {
            self.id = id
            self.text = text
            self.type = type
            self.options = options
            self.correctAnswer = correctAnswer
            self.correctAnswers = correctAnswers
            self.points = points
            self.explanation = explanation
        }
    }
    
    public struct Assignment: Identifiable, Codable {
        public let id: String
        public let title: String
        public let description: String
        public let dueDate: Date
        public let points: Int
        public let submissionType: SubmissionType
        public let attachments: [AssignmentAttachment]
        public let isSubmitted: Bool
        public let submittedAt: Date?
        public let grade: Double?
        public let feedback: String?
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            description: String,
            dueDate: Date,
            points: Int,
            submissionType: SubmissionType,
            attachments: [AssignmentAttachment] = [],
            isSubmitted: Bool = false,
            submittedAt: Date? = nil,
            grade: Double? = nil,
            feedback: String? = nil
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.dueDate = dueDate
            self.points = points
            self.submissionType = submissionType
            self.attachments = attachments
            self.isSubmitted = isSubmitted
            self.submittedAt = submittedAt
            self.grade = grade
            self.feedback = feedback
        }
    }
    
    public struct LearningMaterial: Identifiable, Codable {
        public let id: String
        public let title: String
        public let description: String?
        public let type: MaterialType
        public let url: String
        public let size: Int64?
        public let duration: TimeInterval?
        public let isDownloaded: Bool
        public let downloadDate: Date?
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            description: String? = nil,
            type: MaterialType,
            url: String,
            size: Int64? = nil,
            duration: TimeInterval? = nil,
            isDownloaded: Bool = false,
            downloadDate: Date? = nil
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.type = type
            self.url = url
            self.size = size
            self.duration = duration
            self.isDownloaded = isDownloaded
            self.downloadDate = downloadDate
        }
    }
    
    public struct Note: Identifiable, Codable {
        public let id: String
        public let content: String
        public let timestamp: TimeInterval
        public let createdAt: Date
        
        public init(
            id: String = UUID().uuidString,
            content: String,
            timestamp: TimeInterval,
            createdAt: Date = Date()
        ) {
            self.id = id
            self.content = content
            self.timestamp = timestamp
            self.createdAt = createdAt
        }
    }
    
    public struct LessonAttachment: Identifiable, Codable {
        public let id: String
        public let name: String
        public let url: String
        public let type: AttachmentType
        public let size: Int64
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            url: String,
            type: AttachmentType,
            size: Int64
        ) {
            self.id = id
            self.name = name
            self.url = url
            self.type = type
            self.size = size
        }
    }
    
    public struct AssignmentAttachment: Identifiable, Codable {
        public let id: String
        public let name: String
        public let url: String
        public let type: AttachmentType
        public let size: Int64
        public let uploadedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            url: String,
            type: AttachmentType,
            size: Int64,
            uploadedAt: Date = Date()
        ) {
            self.id = id
            self.name = name
            self.url = url
            self.type = type
            self.size = size
            self.uploadedAt = uploadedAt
        }
    }
    
    // MARK: - Enums
    public enum Subject: String, CaseIterable, Codable {
        case mathematics = "mathematics"
        case science = "science"
        case history = "history"
        case literature = "literature"
        case language = "language"
        case art = "art"
        case music = "music"
        case technology = "technology"
        case business = "business"
        case health = "health"
        case psychology = "psychology"
        case philosophy = "philosophy"
        case economics = "economics"
        case politics = "politics"
        case geography = "geography"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .mathematics: return "Mathematics"
            case .science: return "Science"
            case .history: return "History"
            case .literature: return "Literature"
            case .language: return "Language"
            case .art: return "Art"
            case .music: return "Music"
            case .technology: return "Technology"
            case .business: return "Business"
            case .health: return "Health"
            case .psychology: return "Psychology"
            case .philosophy: return "Philosophy"
            case .economics: return "Economics"
            case .politics: return "Politics"
            case .geography: return "Geography"
            case .other: return "Other"
            }
        }
        
        public var icon: String {
            switch self {
            case .mathematics: return "function"
            case .science: return "atom"
            case .history: return "book.closed"
            case .literature: return "text.book"
            case .language: return "character.bubble"
            case .art: return "paintbrush"
            case .music: return "music.note"
            case .technology: return "laptopcomputer"
            case .business: return "building.2"
            case .health: return "heart"
            case .psychology: return "brain.head.profile"
            case .philosophy: return "lightbulb"
            case .economics: return "chart.line.uptrend.xyaxis"
            case .politics: return "flag"
            case .geography: return "globe"
            case .other: return "ellipsis.circle"
            }
        }
    }
    
    public enum CourseLevel: String, CaseIterable, Codable {
        case beginner = "beginner"
        case intermediate = "intermediate"
        case advanced = "advanced"
        case expert = "expert"
        
        public var displayName: String {
            switch self {
            case .beginner: return "Beginner"
            case .intermediate: return "Intermediate"
            case .advanced: return "Advanced"
            case .expert: return "Expert"
            }
        }
        
        public var color: String {
            switch self {
            case .beginner: return "green"
            case .intermediate: return "blue"
            case .advanced: return "orange"
            case .expert: return "red"
            }
        }
    }
    
    public enum QuestionType: String, CaseIterable, Codable {
        case multipleChoice = "multiple_choice"
        case trueFalse = "true_false"
        case shortAnswer = "short_answer"
        case essay = "essay"
        case matching = "matching"
        case fillInBlank = "fill_in_blank"
        
        public var displayName: String {
            switch self {
            case .multipleChoice: return "Multiple Choice"
            case .trueFalse: return "True/False"
            case .shortAnswer: return "Short Answer"
            case .essay: return "Essay"
            case .matching: return "Matching"
            case .fillInBlank: return "Fill in the Blank"
            }
        }
    }
    
    public enum SubmissionType: String, CaseIterable, Codable {
        case text = "text"
        case file = "file"
        case link = "link"
        case video = "video"
        case audio = "audio"
        
        public var displayName: String {
            switch self {
            case .text: return "Text"
            case .file: return "File"
            case .link: return "Link"
            case .video: return "Video"
            case .audio: return "Audio"
            }
        }
    }
    
    public enum MaterialType: String, CaseIterable, Codable {
        case video = "video"
        case audio = "audio"
        case document = "document"
        case presentation = "presentation"
        case image = "image"
        case link = "link"
        
        public var displayName: String {
            switch self {
            case .video: return "Video"
            case .audio: return "Audio"
            case .document: return "Document"
            case .presentation: return "Presentation"
            case .image: return "Image"
            case .link: return "Link"
            }
        }
        
        public var icon: String {
            switch self {
            case .video: return "play.rectangle"
            case .audio: return "speaker.wave.2"
            case .document: return "doc.text"
            case .presentation: return "rectangle.stack"
            case .image: return "photo"
            case .link: return "link"
            }
        }
    }
    
    public enum AttachmentType: String, CaseIterable, Codable {
        case pdf = "pdf"
        case doc = "doc"
        case image = "image"
        case video = "video"
        case audio = "audio"
        case zip = "zip"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .pdf: return "PDF"
            case .doc: return "Document"
            case .image: return "Image"
            case .video: return "Video"
            case .audio: return "Audio"
            case .zip: return "Archive"
            case .other: return "Other"
            }
        }
    }
    
    // MARK: - Managers
    public class LearningManager: ObservableObject {
        
        @Published public var courses: [Course] = []
        @Published public var currentCourse: Course?
        @Published public var currentLesson: Lesson?
        @Published public var studySessions: [StudySession] = []
        @Published public var isLoading = false
        
        private let progressManager = ProgressManager()
        private let mediaPlayer = MediaPlayer()
        
        public init() {}
        
        // MARK: - Course Methods
        
        public func enrollInCourse(_ course: Course) async throws {
            guard let index = courses.firstIndex(where: { $0.id == course.id }) else {
                throw LearningError.courseNotFound
            }
            
            var updatedCourse = course
            updatedCourse.isEnrolled = true
            
            courses[index] = updatedCourse
            try await progressManager.saveCourseProgress(updatedCourse)
        }
        
        public func unenrollFromCourse(_ courseId: String) async throws {
            guard let index = courses.firstIndex(where: { $0.id == courseId }) else {
                throw LearningError.courseNotFound
            }
            
            var course = courses[index]
            course.isEnrolled = false
            course.progress = 0
            
            courses[index] = course
            try await progressManager.saveCourseProgress(course)
        }
        
        public func getEnrolledCourses() -> [Course] {
            return courses.filter { $0.isEnrolled }
        }
        
        public func getCoursesBySubject(_ subject: Subject) -> [Course] {
            return courses.filter { $0.subject == subject }
        }
        
        public func getCoursesByLevel(_ level: CourseLevel) -> [Course] {
            return courses.filter { $0.level == level }
        }
        
        public func searchCourses(query: String) -> [Course] {
            let lowercasedQuery = query.lowercased()
            return courses.filter { course in
                course.title.lowercased().contains(lowercasedQuery) ||
                course.description?.lowercased().contains(lowercasedQuery) == true ||
                course.instructor.lowercased().contains(lowercasedQuery) ||
                course.tags.contains { $0.lowercased().contains(lowercasedQuery) }
            }
        }
        
        // MARK: - Lesson Methods
        
        public func startLesson(_ lesson: Lesson) async throws {
            currentLesson = lesson
            try await mediaPlayer.prepareForLesson(lesson)
        }
        
        public func completeLesson(_ lessonId: String) async throws {
            guard let courseIndex = courses.firstIndex(where: { $0.id == currentCourse?.id }),
                  let lessonIndex = courses[courseIndex].lessons.firstIndex(where: { $0.id == lessonId }) else {
                throw LearningError.lessonNotFound
            }
            
            var course = courses[courseIndex]
            var lesson = course.lessons[lessonIndex]
            lesson.isCompleted = true
            lesson.completedAt = Date()
            
            course.lessons[lessonIndex] = lesson
            
            // Update course progress
            let completedLessons = course.lessons.filter { $0.isCompleted }.count
            course.progress = Double(completedLessons) / Double(course.lessons.count)
            
            courses[courseIndex] = course
            try await progressManager.saveCourseProgress(course)
        }
        
        public func addNoteToLesson(_ note: Note, lessonId: String) async throws {
            guard let courseIndex = courses.firstIndex(where: { $0.id == currentCourse?.id }),
                  let lessonIndex = courses[courseIndex].lessons.firstIndex(where: { $0.id == lessonId }) else {
                throw LearningError.lessonNotFound
            }
            
            var course = courses[courseIndex]
            var lesson = course.lessons[lessonIndex]
            lesson.notes.append(note)
            
            course.lessons[lessonIndex] = lesson
            courses[courseIndex] = course
            try await progressManager.saveCourseProgress(course)
        }
        
        // MARK: - Quiz Methods
        
        public func startQuiz(_ quiz: Quiz) async throws {
            // Implementation for starting a quiz
        }
        
        public func submitQuiz(_ quiz: Quiz, answers: [String: String]) async throws -> QuizResult {
            // Implementation for submitting quiz answers
            return QuizResult(score: 0, passed: false, feedback: "")
        }
        
        // MARK: - Assignment Methods
        
        public func submitAssignment(_ assignment: Assignment, submission: AssignmentSubmission) async throws {
            // Implementation for submitting assignments
        }
        
        // MARK: - Study Session Methods
        
        public func startStudySession(courseId: String, lessonId: String) async throws {
            let session = StudySession(
                courseId: courseId,
                lessonId: lessonId,
                startTime: Date()
            )
            
            studySessions.append(session)
            try await progressManager.saveStudySessions(studySessions)
        }
        
        public func endStudySession(sessionId: String) async throws {
            guard let index = studySessions.firstIndex(where: { $0.id == sessionId }) else {
                throw LearningError.sessionNotFound
            }
            
            var session = studySessions[index]
            session.endTime = Date()
            session.duration = session.endTime!.timeIntervalSince(session.startTime)
            
            studySessions[index] = session
            try await progressManager.saveStudySessions(studySessions)
        }
    }
    
    public class ProgressManager {
        
        private let userDefaults = UserDefaults.standard
        
        public init() {}
        
        public func saveCourseProgress(_ course: Course) async throws {
            let data = try JSONEncoder().encode(course)
            userDefaults.set(data, forKey: "course_progress_\(course.id)")
        }
        
        public func loadCourseProgress(courseId: String) async throws -> Course? {
            guard let data = userDefaults.data(forKey: "course_progress_\(courseId)") else {
                return nil
            }
            
            return try JSONDecoder().decode(Course.self, from: data)
        }
        
        public func saveStudySessions(_ sessions: [StudySession]) async throws {
            let data = try JSONEncoder().encode(sessions)
            userDefaults.set(data, forKey: "study_sessions")
        }
        
        public func loadStudySessions() async throws -> [StudySession] {
            guard let data = userDefaults.data(forKey: "study_sessions") else {
                return []
            }
            
            return try JSONDecoder().decode([StudySession].self, from: data)
        }
    }
    
    public class MediaPlayer {
        
        private var audioPlayer: AVAudioPlayer?
        private var videoPlayer: AVPlayer?
        
        public init() {}
        
        public func prepareForLesson(_ lesson: Lesson) async throws {
            if let audioURL = lesson.audioURL {
                try await prepareAudio(url: audioURL)
            }
            
            if let videoURL = lesson.videoURL {
                try await prepareVideo(url: videoURL)
            }
        }
        
        public func playAudio() {
            audioPlayer?.play()
        }
        
        public func pauseAudio() {
            audioPlayer?.pause()
        }
        
        public func stopAudio() {
            audioPlayer?.stop()
        }
        
        public func playVideo() {
            videoPlayer?.play()
        }
        
        public func pauseVideo() {
            videoPlayer?.pause()
        }
        
        private func prepareAudio(url: String) async throws {
            guard let audioURL = URL(string: url) else {
                throw LearningError.invalidURL
            }
            
            let data = try await URLSession.shared.data(from: audioURL).0
            audioPlayer = try AVAudioPlayer(data: data)
        }
        
        private func prepareVideo(url: String) async throws {
            guard let videoURL = URL(string: url) else {
                throw LearningError.invalidURL
            }
            
            videoPlayer = AVPlayer(url: videoURL)
        }
    }
    
    // MARK: - Supporting Models
    public struct StudySession: Identifiable, Codable {
        public let id: String
        public let courseId: String
        public let lessonId: String
        public let startTime: Date
        public let endTime: Date?
        public let duration: TimeInterval
        
        public init(
            id: String = UUID().uuidString,
            courseId: String,
            lessonId: String,
            startTime: Date,
            endTime: Date? = nil,
            duration: TimeInterval = 0
        ) {
            self.id = id
            self.courseId = courseId
            self.lessonId = lessonId
            self.startTime = startTime
            self.endTime = endTime
            self.duration = duration
        }
    }
    
    public struct QuizResult: Codable {
        public let score: Double
        public let passed: Bool
        public let feedback: String
        public let timeTaken: TimeInterval?
        public let answers: [String: String]
        
        public init(
            score: Double,
            passed: Bool,
            feedback: String,
            timeTaken: TimeInterval? = nil,
            answers: [String: String] = [:]
        ) {
            self.score = score
            self.passed = passed
            self.feedback = feedback
            self.timeTaken = timeTaken
            self.answers = answers
        }
    }
    
    public struct AssignmentSubmission: Codable {
        public let assignmentId: String
        public let content: String?
        public let fileURL: String?
        public let linkURL: String?
        public let submittedAt: Date
        
        public init(
            assignmentId: String,
            content: String? = nil,
            fileURL: String? = nil,
            linkURL: String? = nil,
            submittedAt: Date = Date()
        ) {
            self.assignmentId = assignmentId
            self.content = content
            self.fileURL = fileURL
            self.linkURL = linkURL
            self.submittedAt = submittedAt
        }
    }
    
    // MARK: - UI Components
    
    public struct CourseCard: View {
        let course: Course
        let onTap: () -> Void
        let onEnroll: () -> Void
        
        public init(course: Course, onTap: @escaping () -> Void, onEnroll: @escaping () -> Void) {
            self.course = course
            self.onTap = onTap
            self.onEnroll = onEnroll
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Course Image/Icon
                HStack {
                    Image(systemName: course.subject.icon)
                        .font(.title)
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text(course.title)
                            .font(.headline)
                            .lineLimit(2)
                        
                        Text(course.subject.displayName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(course.level.displayName)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(course.level.color).opacity(0.2))
                            .foregroundColor(Color(course.level.color))
                            .cornerRadius(4)
                        
                        if course.isEnrolled {
                            Text("\(Int(course.progress * 100))%")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                }
                
                if let description = course.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                
                // Stats
                HStack(spacing: 20) {
                    VStack {
                        Text("\(course.lessons.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Lessons")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Text("\(course.enrollmentCount)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Students")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let rating = course.rating {
                        VStack {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                Text(String(format: "%.1f", rating))
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            Text("Rating")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                
                // Progress bar for enrolled courses
                if course.isEnrolled {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Progress")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(Int(course.progress * 100))%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        ProgressView(value: course.progress)
                            .progressViewStyle(LinearProgressViewStyle())
                    }
                }
                
                // Action button
                Button(action: course.isEnrolled ? onTap : onEnroll) {
                    Text(course.isEnrolled ? "Continue" : "Enroll")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(course.isEnrolled ? Color.blue : Color.green)
                        .cornerRadius(8)
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
    
    public struct LessonCard: View {
        let lesson: Lesson
        let onTap: () -> Void
        
        public init(lesson: Lesson, onTap: @escaping () -> Void) {
            self.lesson = lesson
            self.onTap = onTap
        }
        
        public var body: some View {
            HStack(spacing: 12) {
                // Lesson status icon
                Image(systemName: lesson.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(lesson.isCompleted ? .green : .gray)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .font(.headline)
                        .strikethrough(lesson.isCompleted)
                        .foregroundColor(lesson.isCompleted ? .secondary : .primary)
                    
                    if let description = lesson.description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    HStack {
                        Text("\(Int(lesson.duration / 60)) min")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if lesson.videoURL != nil {
                            Image(systemName: "play.rectangle")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        
                        if lesson.audioURL != nil {
                            Image(systemName: "speaker.wave.2")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        Text("\(lesson.order)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 1)
            .onTapGesture {
                onTap()
            }
        }
    }
    
    // MARK: - Errors
    
    public enum LearningError: LocalizedError {
        case courseNotFound
        case lessonNotFound
        case sessionNotFound
        case invalidURL
        case mediaError
        case networkError
        case saveError
        
        public var errorDescription: String? {
            switch self {
            case .courseNotFound:
                return "Course not found"
            case .lessonNotFound:
                return "Lesson not found"
            case .sessionNotFound:
                return "Study session not found"
            case .invalidURL:
                return "Invalid URL"
            case .mediaError:
                return "Media playback error"
            case .networkError:
                return "Network error occurred"
            case .saveError:
                return "Failed to save data"
            }
        }
    }
} 