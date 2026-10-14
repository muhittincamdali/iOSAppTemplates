import Foundation
import Testing
@testable import EducationApp

@MainActor
@Suite("EducationLearningStore")
struct EducationLearningStoreTests {
    private func course(_ title: String, in store: EducationLearningStore) throws -> EducationCourseRecord {
        try #require(store.courses.first { $0.title == title })
    }

    private func quiz(for course: String, in store: EducationLearningStore) throws -> EducationQuizRecord {
        try #require(store.quizzes.first { $0.course == course })
    }

    @Test func completionRateAveragesCourseProgress() {
        let store = EducationLearningStore()

        // (0.78 + 0.62 + 0.54) / 3 = 0.6467, shown to the nearest whole percent.
        #expect(store.completionRateText == "65%")
    }

    @Test(arguments: [
        (0.0, "0%"), (0.004, "0%"), (0.005, "1%"), (0.69, "69%"), (1.0, "100%"),
        (-0.2, "0%"), (1.7, "100%"), (.nan, "0%"), (.infinity, "0%"), (-.infinity, "0%")
    ])
    func percentTextClampsAndNeverTraps(fraction: Double, expected: String) {
        #expect(EducationCourseRecord.percentText(fraction) == expected)
    }

    @Test func completionRateSurvivesNonFiniteProgress() {
        let store = EducationLearningStore()
        store.courses[0].progress = .nan

        #expect(store.completionRateText == "0%")
    }

    @Test func completingLessonUnlocksCourseQuizOnce() throws {
        let store = EducationLearningStore()
        let lesson = try #require(store.lessons.first { $0.course == "Product Analytics" })
        let progress = try course("Product Analytics", in: store).progress

        store.completeLesson(lesson.id)
        store.completeLesson(lesson.id)

        #expect(try quiz(for: "Product Analytics", in: store).status == .ready)
        #expect(abs(try course("Product Analytics", in: store).progress - (progress + 0.08)) < 0.0001)
        #expect(store.completedLessonsCount == 29)
        #expect(store.studyStreakDays == 13)
    }

    @Test func nextLessonSkipsCompletedLessons() {
        let store = EducationLearningStore()
        let first = store.lessons[0]

        store.completeLesson(first.id)

        #expect(store.nextLesson?.id == store.lessons[1].id)
    }

    @Test func lockedQuizCannotBeAnswered() throws {
        let store = EducationLearningStore()
        let locked = try quiz(for: "Product Analytics", in: store)

        store.answerQuizQuestion(locked.id)

        #expect(try quiz(for: "Product Analytics", in: store).answeredQuestions == 0)
        #expect(try quiz(for: "Product Analytics", in: store).status == .locked)
    }

    @Test func answeringEveryQuestionMakesQuizSubmittable() throws {
        let store = EducationLearningStore()
        let ready = try quiz(for: "Design Systems", in: store)

        store.answerQuizQuestion(ready.id)
        #expect(try quiz(for: "Design Systems", in: store).status == .inProgress)

        for _ in 0..<(ready.questionCount + 3) {
            store.answerQuizQuestion(ready.id)
        }

        let finished = try quiz(for: "Design Systems", in: store)
        #expect(finished.answeredQuestions == finished.questionCount)
        #expect(finished.status == .readyToSubmit)
        #expect(store.dashboardHeadline.contains("ready to submit"))
    }

    @Test func submittingRequiresAFinishedQuiz() throws {
        let store = EducationLearningStore()
        let ready = try quiz(for: "Design Systems", in: store)

        store.submitQuiz(ready.id)

        #expect(try quiz(for: "Design Systems", in: store).status == .ready)
    }

    @Test func submittedQuizRaisesScoreAndPreparesAssignment() throws {
        let store = EducationLearningStore()
        let ready = try quiz(for: "Design Systems", in: store)
        for _ in 0..<ready.questionCount { store.answerQuizQuestion(ready.id) }

        store.submitQuiz(ready.id)

        #expect(try quiz(for: "Design Systems", in: store).status == .submitted)
        #expect(try quiz(for: "Design Systems", in: store).score >= 94)
        #expect(store.quizAverage >= 94 && store.quizAverage <= 99)
        #expect(store.assignments.first { $0.course == "Design Systems" }?.status == "Ready to submit")
    }

    @Test func assignmentSubmissionIsIdempotentAndProgressIsCapped() throws {
        let store = EducationLearningStore()
        let assignment = try #require(store.assignments.first { $0.course == "Design Systems" })
        let index = try #require(store.courses.firstIndex { $0.title == "Design Systems" })
        store.courses[index].progress = 0.95

        store.submitAssignment(assignment.id)
        store.submitAssignment(assignment.id)

        #expect(store.courses[index].progress == 1)
        #expect(!store.activeAssignments.contains { $0.id == assignment.id })
        #expect(!store.dashboardHeadline.contains("high-priority"))
    }

    @Test func notesAreTrimmedAndBlankNotesIgnored() {
        let store = EducationLearningStore()
        let notes = store.notes.count

        store.noteDraft = "   "
        store.saveLessonNote()
        #expect(store.notes.count == notes)

        store.noteDraft = "  Tokens before components.  "
        store.saveLessonNote()
        #expect(store.notes.count == notes + 1)
        #expect(store.notes[0].body == "Tokens before components.")
        #expect(store.noteDraft.isEmpty)
    }

    @Test func unknownSelectionFallsBackToFirstItems() {
        let store = EducationLearningStore()

        store.selectLesson(UUID())
        store.selectCourse(UUID())

        #expect(store.selectedLesson?.id == store.lessons.first?.id)
        #expect(store.selectedCourse?.id == store.courses.first?.id)
    }
}
