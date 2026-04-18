import SwiftUI

struct FoodDeliveryFlowExample: View {
    private let sections = ["Restaurants", "Menu", "Cart", "Live Order"]

    var body: some View {
        NavigationStack {
            List(sections, id: \.self) { section in
                Label(section, systemImage: "fork.knife")
            }
            .navigationTitle("Food Delivery")
        }
    }
}
