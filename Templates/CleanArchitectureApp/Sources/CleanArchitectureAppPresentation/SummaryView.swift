import CleanArchitectureAppDomain
import SwiftUI

/// Counts derived from the loaded directory by ``DirectorySummary``.
public struct SummaryView: View {
    private let model: DirectoryModel

    public init(model: DirectoryModel) {
        self.model = model
    }

    public var body: some View {
        let summary = model.summary
        NavigationStack {
            List {
                Section("People") {
                    LabeledContent("Total", value: summary.total, format: .number)
                    LabeledContent("Active", value: summary.active, format: .number)
                    LabeledContent("Deactivated", value: summary.inactive, format: .number)
                }
                Section("Roles") {
                    ForEach(UserRole.allCases.reversed(), id: \.self) { role in
                        LabeledContent(role.title + "s", value: summary.count(of: role), format: .number)
                    }
                }
                if let newest = summary.newestMember {
                    Section("Newest member") {
                        LabeledContent(newest.name, value: newest.joinedAt.formatted(date: .abbreviated, time: .omitted))
                    }
                }
                Section {
                    LabeledContent("Data", value: sourceDescription)
                } footer: {
                    Text("Members see active accounts only, so their counts leave out deactivated accounts.")
                }
            }
            .navigationTitle("Summary")
            .refreshable { await model.load() }
        }
    }

    private var sourceDescription: String {
        switch model.origin {
        case .server: "Server"
        case .cache(let savedAt): "Saved copy, \(savedAt.formatted(date: .abbreviated, time: .shortened))"
        case nil: "Not loaded"
        }
    }
}
