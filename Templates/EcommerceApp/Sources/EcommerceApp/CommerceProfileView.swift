import Foundation
import SwiftUI

struct CommerceProfileView: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        NavigationStack {
            List {
                Section("Buyer") {
                    Label("Mina Aksoy", systemImage: "person.crop.circle.fill")
                    Label("Express delivery eligible", systemImage: "bolt.fill")
                }

                Section("Commerce Rules") {
                    Label("Same-day shipping starts before 21:00", systemImage: "clock.fill")
                    Label("Coupon `SPRINT10` unlocks a 10% cart discount", systemImage: "tag.fill")
                    Label("Post-purchase support opens from order detail", systemImage: "lifepreserver.fill")
                }

                Section("Saved Surfaces") {
                    if let address = store.selectedAddress {
                        Label(address.label, systemImage: "house.fill")
                    }
                    if let payment = store.selectedPaymentMethod {
                        Label(payment.label, systemImage: "creditcard.fill")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
