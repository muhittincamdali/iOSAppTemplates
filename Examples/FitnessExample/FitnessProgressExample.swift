import SwiftUI

struct FitnessProgressExample: View {
    private let sections = ["Dashboard", "Workouts", "Goals", "Recovery"]

    var body: some View {
        NavigationStack {
            List(sections, id: \.self) { section in
                Label(section, systemImage: "figure.run")
            }
            .navigationTitle("Fitness")
        }
    }
}
