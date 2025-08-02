import XCTest
@testable import EducationTemplates

final class EducationTemplatesTests: XCTestCase {
    
    func testEducationTemplatesInitialization() {
        // Given
        let version = EducationTemplates.version
        
        // Then
        XCTAssertEqual(version, "1.0.0")
    }
    
    func testCourseInitialization() {
        // Given
        let course = LearningAppTemplate.Course(
            id: "course-1",
            title: "iOS Development",
            description: "Learn iOS app development",
            subject: .technology,
            level: .intermediate,
            instructor: "John Doe",
            duration: 3600,
            lessons: [],
            quizzes: [],
            assignments: [],
            materials: [],
            enrollmentCount: 100,
            rating: 4.5,
            reviewCount: 25,
            isEnrolled: true,
            progress: 0.3,
            certificateEligible: true,
            certificateIssued: false,
            tags: ["ios", "swift", "mobile"]
        )
        
        // Then
        XCTAssertEqual(course.id, "course-1")
        XCTAssertEqual(course.title, "iOS Development")
        XCTAssertEqual(course.description, "Learn iOS app development")
        XCTAssertEqual(course.subject, .technology)
        XCTAssertEqual(course.level, .intermediate)
        XCTAssertEqual(course.instructor, "John Doe")
        XCTAssertEqual(course.duration, 3600)
        XCTAssertEqual(course.enrollmentCount, 100)
        XCTAssertEqual(course.rating, 4.5)
        XCTAssertEqual(course.reviewCount, 25)
        XCTAssertTrue(course.isEnrolled)
        XCTAssertEqual(course.progress, 0.3)
        XCTAssertTrue(course.certificateEligible)
        XCTAssertFalse(course.certificateIssued)
        XCTAssertEqual(course.tags.count, 3)
    }
    
    func testLessonInitialization() {
        // Given
        let lesson = LearningAppTemplate.Lesson(
            id: "lesson-1",
            title: "Introduction to Swift",
            description: "Learn the basics of Swift programming",
            content: "Swift is a powerful programming language...",
            videoURL: "https://example.com/video.mp4",
            audioURL: "https://example.com/audio.mp3",
            duration: 1800,
            order: 1,
            isCompleted: false,
            notes: [],
            attachments: []
        )
        
        // Then
        XCTAssertEqual(lesson.id, "lesson-1")
        XCTAssertEqual(lesson.title, "Introduction to Swift")
        XCTAssertEqual(lesson.description, "Learn the basics of Swift programming")
        XCTAssertEqual(lesson.content, "Swift is a powerful programming language...")
        XCTAssertEqual(lesson.videoURL, "https://example.com/video.mp4")
        XCTAssertEqual(lesson.audioURL, "https://example.com/audio.mp3")
        XCTAssertEqual(lesson.duration, 1800)
        XCTAssertEqual(lesson.order, 1)
        XCTAssertFalse(lesson.isCompleted)
    }
    
    func testQuizInitialization() {
        // Given
        let quiz = LearningAppTemplate.Quiz(
            id: "quiz-1",
            title: "Swift Basics Quiz",
            description: "Test your knowledge of Swift basics",
            questions: [],
            timeLimit: 1800,
            passingScore: 70.0,
            attempts: 3,
            currentAttempt: 0,
            bestScore: nil,
            isCompleted: false
        )
        
        // Then
        XCTAssertEqual(quiz.id, "quiz-1")
        XCTAssertEqual(quiz.title, "Swift Basics Quiz")
        XCTAssertEqual(quiz.description, "Test your knowledge of Swift basics")
        XCTAssertEqual(quiz.timeLimit, 1800)
        XCTAssertEqual(quiz.passingScore, 70.0)
        XCTAssertEqual(quiz.attempts, 3)
        XCTAssertEqual(quiz.currentAttempt, 0)
        XCTAssertNil(quiz.bestScore)
        XCTAssertFalse(quiz.isCompleted)
    }
    
    func testQuestionInitialization() {
        // Given
        let question = LearningAppTemplate.Question(
            id: "question-1",
            text: "What is Swift?",
            type: .multipleChoice,
            options: ["Programming language", "Framework", "Database", "IDE"],
            correctAnswer: "Programming language",
            points: 1,
            explanation: "Swift is a programming language developed by Apple."
        )
        
        // Then
        XCTAssertEqual(question.id, "question-1")
        XCTAssertEqual(question.text, "What is Swift?")
        XCTAssertEqual(question.type, .multipleChoice)
        XCTAssertEqual(question.options?.count, 4)
        XCTAssertEqual(question.correctAnswer, "Programming language")
        XCTAssertEqual(question.points, 1)
        XCTAssertEqual(question.explanation, "Swift is a programming language developed by Apple.")
    }
    
    func testAssignmentInitialization() {
        // Given
        let assignment = LearningAppTemplate.Assignment(
            id: "assignment-1",
            title: "Build a Simple App",
            description: "Create a basic iOS app using Swift",
            dueDate: Date().addingTimeInterval(604800),
            points: 100,
            submissionType: .file,
            attachments: [],
            isSubmitted: false,
            grade: nil,
            feedback: nil
        )
        
        // Then
        XCTAssertEqual(assignment.id, "assignment-1")
        XCTAssertEqual(assignment.title, "Build a Simple App")
        XCTAssertEqual(assignment.description, "Create a basic iOS app using Swift")
        XCTAssertEqual(assignment.points, 100)
        XCTAssertEqual(assignment.submissionType, .file)
        XCTAssertFalse(assignment.isSubmitted)
        XCTAssertNil(assignment.grade)
        XCTAssertNil(assignment.feedback)
    }
    
    func testLearningMaterialInitialization() {
        // Given
        let material = LearningAppTemplate.LearningMaterial(
            id: "material-1",
            title: "Swift Programming Guide",
            description: "Official Swift programming guide",
            type: .document,
            url: "https://example.com/guide.pdf",
            size: 2048576,
            duration: nil,
            isDownloaded: false,
            downloadDate: nil
        )
        
        // Then
        XCTAssertEqual(material.id, "material-1")
        XCTAssertEqual(material.title, "Swift Programming Guide")
        XCTAssertEqual(material.description, "Official Swift programming guide")
        XCTAssertEqual(material.type, .document)
        XCTAssertEqual(material.url, "https://example.com/guide.pdf")
        XCTAssertEqual(material.size, 2048576)
        XCTAssertFalse(material.isDownloaded)
        XCTAssertNil(material.downloadDate)
    }
    
    func testNoteInitialization() {
        // Given
        let note = LearningAppTemplate.Note(
            id: "note-1",
            title: "Important Concepts",
            content: "Remember to use optionals properly",
            date: Date(),
            location: "Lesson 2",
            coordinates: nil,
            tags: ["swift", "optionals"]
        )
        
        // Then
        XCTAssertEqual(note.id, "note-1")
        XCTAssertEqual(note.title, "Important Concepts")
        XCTAssertEqual(note.content, "Remember to use optionals properly")
        XCTAssertEqual(note.location, "Lesson 2")
        XCTAssertEqual(note.tags.count, 2)
    }
    
    func testLessonAttachmentInitialization() {
        // Given
        let attachment = LearningAppTemplate.LessonAttachment(
            id: "attachment-1",
            name: "code_example.swift",
            url: "https://example.com/code.swift",
            type: .document,
            size: 1024
        )
        
        // Then
        XCTAssertEqual(attachment.id, "attachment-1")
        XCTAssertEqual(attachment.name, "code_example.swift")
        XCTAssertEqual(attachment.url, "https://example.com/code.swift")
        XCTAssertEqual(attachment.type, .document)
        XCTAssertEqual(attachment.size, 1024)
    }
    
    func testAssignmentAttachmentInitialization() {
        // Given
        let attachment = LearningAppTemplate.AssignmentAttachment(
            id: "attachment-1",
            name: "project.zip",
            url: "https://example.com/project.zip",
            type: .zip,
            size: 5120,
            uploadedAt: Date()
        )
        
        // Then
        XCTAssertEqual(attachment.id, "attachment-1")
        XCTAssertEqual(attachment.name, "project.zip")
        XCTAssertEqual(attachment.url, "https://example.com/project.zip")
        XCTAssertEqual(attachment.type, .zip)
        XCTAssertEqual(attachment.size, 5120)
    }
    
    func testSubjectProperties() {
        // Given
        let technology = LearningAppTemplate.Subject.technology
        let mathematics = LearningAppTemplate.Subject.mathematics
        let science = LearningAppTemplate.Subject.science
        
        // Then
        XCTAssertEqual(technology.displayName, "Technology")
        XCTAssertEqual(technology.icon, "laptopcomputer")
        XCTAssertEqual(mathematics.displayName, "Mathematics")
        XCTAssertEqual(mathematics.icon, "function")
        XCTAssertEqual(science.displayName, "Science")
        XCTAssertEqual(science.icon, "atom")
    }
    
    func testCourseLevelProperties() {
        // Given
        let beginner = LearningAppTemplate.CourseLevel.beginner
        let intermediate = LearningAppTemplate.CourseLevel.intermediate
        let advanced = LearningAppTemplate.CourseLevel.advanced
        
        // Then
        XCTAssertEqual(beginner.displayName, "Beginner")
        XCTAssertEqual(beginner.color, "green")
        XCTAssertEqual(intermediate.displayName, "Intermediate")
        XCTAssertEqual(intermediate.color, "blue")
        XCTAssertEqual(advanced.displayName, "Advanced")
        XCTAssertEqual(advanced.color, "orange")
    }
    
    func testQuestionTypeProperties() {
        // Given
        let multipleChoice = LearningAppTemplate.QuestionType.multipleChoice
        let trueFalse = LearningAppTemplate.QuestionType.trueFalse
        let shortAnswer = LearningAppTemplate.QuestionType.shortAnswer
        
        // Then
        XCTAssertEqual(multipleChoice.displayName, "Multiple Choice")
        XCTAssertEqual(trueFalse.displayName, "True/False")
        XCTAssertEqual(shortAnswer.displayName, "Short Answer")
    }
    
    func testSubmissionTypeProperties() {
        // Given
        let text = LearningAppTemplate.SubmissionType.text
        let file = LearningAppTemplate.SubmissionType.file
        let link = LearningAppTemplate.SubmissionType.link
        
        // Then
        XCTAssertEqual(text.displayName, "Text")
        XCTAssertEqual(file.displayName, "File")
        XCTAssertEqual(link.displayName, "Link")
    }
    
    func testMaterialTypeProperties() {
        // Given
        let video = LearningAppTemplate.MaterialType.video
        let audio = LearningAppTemplate.MaterialType.audio
        let document = LearningAppTemplate.MaterialType.document
        
        // Then
        XCTAssertEqual(video.displayName, "Video")
        XCTAssertEqual(video.icon, "play.rectangle")
        XCTAssertEqual(audio.displayName, "Audio")
        XCTAssertEqual(audio.icon, "speaker.wave.2")
        XCTAssertEqual(document.displayName, "Document")
        XCTAssertEqual(document.icon, "doc.text")
    }
    
    func testAttachmentTypeProperties() {
        // Given
        let pdf = LearningAppTemplate.AttachmentType.pdf
        let doc = LearningAppTemplate.AttachmentType.doc
        let image = LearningAppTemplate.AttachmentType.image
        
        // Then
        XCTAssertEqual(pdf.displayName, "PDF")
        XCTAssertEqual(doc.displayName, "Document")
        XCTAssertEqual(image.displayName, "Image")
    }
    
    func testLearningManagerInitialization() {
        // Given
        let manager = LearningAppTemplate.LearningManager()
        
        // Then
        XCTAssertTrue(manager.courses.isEmpty)
        XCTAssertTrue(manager.destinations.isEmpty)
        XCTAssertTrue(manager.studySessions.isEmpty)
        XCTAssertFalse(manager.isLoading)
    }
    
    func testProgressManagerInitialization() {
        // Given
        let manager = LearningAppTemplate.ProgressManager()
        
        // Then
        XCTAssertNotNil(manager)
    }
    
    func testMediaPlayerInitialization() {
        // Given
        let player = LearningAppTemplate.MediaPlayer()
        
        // Then
        XCTAssertNotNil(player)
    }
    
    func testStudySessionInitialization() {
        // Given
        let session = LearningAppTemplate.StudySession(
            id: "session-1",
            courseId: "course-1",
            lessonId: "lesson-1",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            duration: 3600
        )
        
        // Then
        XCTAssertEqual(session.id, "session-1")
        XCTAssertEqual(session.courseId, "course-1")
        XCTAssertEqual(session.lessonId, "lesson-1")
        XCTAssertEqual(session.duration, 3600)
    }
    
    func testQuizResultInitialization() {
        // Given
        let result = LearningAppTemplate.QuizResult(
            score: 85.0,
            passed: true,
            feedback: "Great job!",
            timeTaken: 1200,
            answers: ["q1": "a", "q2": "b"]
        )
        
        // Then
        XCTAssertEqual(result.score, 85.0)
        XCTAssertTrue(result.passed)
        XCTAssertEqual(result.feedback, "Great job!")
        XCTAssertEqual(result.timeTaken, 1200)
        XCTAssertEqual(result.answers.count, 2)
    }
    
    func testAssignmentSubmissionInitialization() {
        // Given
        let submission = LearningAppTemplate.AssignmentSubmission(
            assignmentId: "assignment-1",
            content: "Here is my assignment",
            fileURL: "https://example.com/file.zip",
            linkURL: nil,
            submittedAt: Date()
        )
        
        // Then
        XCTAssertEqual(submission.assignmentId, "assignment-1")
        XCTAssertEqual(submission.content, "Here is my assignment")
        XCTAssertEqual(submission.fileURL, "https://example.com/file.zip")
        XCTAssertNil(submission.linkURL)
    }
    
    func testLearningErrorDescriptions() {
        // Given & When
        let courseNotFound = LearningAppTemplate.LearningError.courseNotFound
        let lessonNotFound = LearningAppTemplate.LearningError.lessonNotFound
        let sessionNotFound = LearningAppTemplate.LearningError.sessionNotFound
        let invalidURL = LearningAppTemplate.LearningError.invalidURL
        let mediaError = LearningAppTemplate.LearningError.mediaError
        let networkError = LearningAppTemplate.LearningError.networkError
        let saveError = LearningAppTemplate.LearningError.saveError
        
        // Then
        XCTAssertEqual(courseNotFound.errorDescription, "Course not found")
        XCTAssertEqual(lessonNotFound.errorDescription, "Lesson not found")
        XCTAssertEqual(sessionNotFound.errorDescription, "Study session not found")
        XCTAssertEqual(invalidURL.errorDescription, "Invalid URL")
        XCTAssertEqual(mediaError.errorDescription, "Media playback error")
        XCTAssertEqual(networkError.errorDescription, "Network error occurred")
        XCTAssertEqual(saveError.errorDescription, "Failed to save data")
    }
} 