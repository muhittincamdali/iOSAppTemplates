import Foundation
import SwiftUI

@available(iOS 18.0, macOS 15.0, *)
public struct EcommerceAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            EcommerceRootView()
        }
    }
}

struct EcommerceRootView: View {
    @StateObject private var store = CommerceStore()

    var body: some View {
        TabView {
            CommerceHomeView(store: store)
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Shop")
                }

            CommerceCatalogView(store: store)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Browse")
                }

            CommerceCartView(store: store)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Cart")
                }

            CommerceOrdersView(store: store)
                .tabItem {
                    Image(systemName: "shippingbox.fill")
                    Text("Orders")
                }

            CommerceProfileView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.orange)
    }
}
