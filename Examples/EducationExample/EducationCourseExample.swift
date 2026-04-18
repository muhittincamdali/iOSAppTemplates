import SwiftUI

struct EducationCourseExample: View {
    private let sections = ["Continue Learning", "My Courses", "Quiz Queue", "Progress"]

    var body: some View {
        NavigationStack {
            List(sections, id: \.self) { section in
                Label(section, systemImage: "book.closed.fill")
            }
            .navigationTitle("Education")
        }
    }
}
