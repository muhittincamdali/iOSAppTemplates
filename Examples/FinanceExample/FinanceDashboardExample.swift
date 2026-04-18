import SwiftUI

struct FinanceDashboardExample: View {
    private let sections = ["Accounts", "Budgets", "Transactions", "Cash Flow"]

    var body: some View {
        NavigationStack {
            List(sections, id: \.self) { section in
                Label(section, systemImage: "chart.bar.doc.horizontal")
            }
            .navigationTitle("Finance")
        }
    }
}
