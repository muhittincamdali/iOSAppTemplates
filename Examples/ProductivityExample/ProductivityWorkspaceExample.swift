import SwiftUI

struct ProductivityWorkspaceExample: View {
    private let sections = ["Inbox", "Today", "Deep Work", "Projects"]

    var body: some View {
        NavigationStack {
            List(sections, id: \.self) { section in
                Label(section, systemImage: "checklist")
            }
            .navigationTitle("Productivity")
        }
    }
}
