import Foundation
import SwiftUI

struct CommerceCartView: View {
    @ObservedObject var store: CommerceStore
    @State private var couponDraft = ""

    var body: some View {
        NavigationStack {
            List {
                if store.cartItems.isEmpty {
                    ContentUnavailableView(
                        "Cart is empty",
                        systemImage: "cart",
                        description: Text("Add products from the catalog to open the checkout path.")
                    )
                } else {
                    Section("Items") {
                        ForEach(store.cartItems) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(item.product.title)
                                        .font(.headline)
                                    Spacer()
                                    Text(item.product.price.currencyString)
                                        .font(.subheadline.weight(.semibold))
                                }
                                Text(item.product.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                HStack {
                                    Button {
                                        store.decrementCartItem(item.id)
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                    }

                                    Text("Qty \(item.quantity)")
                                        .font(.subheadline.weight(.semibold))

                                    Button {
                                        store.incrementCartItem(item.id)
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                    }

                                    Spacer()
                                    Text((item.product.price * Double(item.quantity)).currencyString)
                                        .font(.subheadline.weight(.semibold))
                                }
                                .foregroundStyle(.orange)
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    Section("Coupon") {
                        TextField("Enter code", text: $couponDraft)
                        Button("Apply Coupon") {
                            store.applyCoupon(couponDraft)
                            couponDraft = ""
                        }
                        .buttonStyle(.bordered)
                        if !store.appliedCouponCode.isEmpty {
                            Label("\(store.appliedCouponCode) applied", systemImage: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                        }
                    }

                    Section("Checkout") {
                        NavigationLink {
                            CommerceCheckoutView(store: store)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Open checkout")
                                    .font(.headline)
                                Text("Review address, payment, savings, and shipping before placing the order.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Cart")
        }
    }
}

struct CommerceCheckoutView: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        List {
            Section("Shipping Address") {
                ForEach(store.savedAddresses) { address in
                    Button {
                        store.selectAddress(address.id)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(address.label)
                                    .foregroundStyle(.primary)
                                Text(address.summary)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: store.selectedAddressID == address.id ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(store.selectedAddressID == address.id ? .orange : .secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("Payment") {
                ForEach(store.paymentMethods) { method in
                    Button {
                        store.selectPaymentMethod(method.id)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(method.label)
                                    .foregroundStyle(.primary)
                                Text(method.detail)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: store.selectedPaymentID == method.id ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(store.selectedPaymentID == method.id ? .orange : .secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("Summary") {
                Picker("Delivery Window", selection: $store.selectedDeliveryWindow) {
                    ForEach(store.deliveryWindows, id: \.self) { window in
                        Text(window).tag(window)
                    }
                }
                .onChange(of: store.selectedDeliveryWindow) { _, newValue in
                    store.selectDeliveryWindow(newValue)
                }
                CommerceSummaryRow(title: "Subtotal", value: store.subtotal.currencyString)
                CommerceSummaryRow(title: "Savings", value: "-\(store.savings.currencyString)")
                CommerceSummaryRow(title: "Shipping", value: store.shippingFee == 0 ? "Free" : store.shippingFee.currencyString)
                CommerceSummaryRow(title: "Taxes", value: store.taxes.currencyString)
                CommerceSummaryRow(title: "Total", value: store.total.currencyString, isPrimary: true)
            }

            Section("Action") {
                Text(store.checkoutNotice)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Button("Place Order") {
                    store.placeOrder()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }
        }
        .navigationTitle("Checkout")
    }
}

struct CommerceSummaryRow: View {
    let title: String
    let value: String
    var isPrimary = false

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .font(isPrimary ? .headline : .body)
                .foregroundStyle(isPrimary ? .orange : .primary)
        }
    }
}
