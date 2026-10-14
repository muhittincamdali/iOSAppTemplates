import Foundation
import SwiftUI

struct CommerceOrdersView: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.placedOrders) { order in
                    NavigationLink {
                        CommerceOrderDetailView(store: store, orderID: order.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(order.title)
                                .font(.headline)
                            Text(order.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("\(order.total.currencyString) • ETA \(order.shipmentETA)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Orders")
        }
    }
}

struct CommerceOrderDetailView: View {
    @ObservedObject var store: CommerceStore
    let orderID: UUID

    private var order: CommerceOrder? {
        store.placedOrders.first(where: { $0.id == orderID })
    }

    var body: some View {
        Group {
            if let order {
                List {
                    Section("Order") {
                        Text(order.title)
                            .font(.title3.weight(.bold))
                        Text(order.summary)
                            .foregroundStyle(.secondary)
                        Label(order.statusHeadline, systemImage: "shippingbox.fill")
                        Label(order.total.currencyString, systemImage: "creditcard.fill")
                        Label(order.shipmentETA, systemImage: "clock.badge.checkmark.fill")
                        Label(order.supportStatus, systemImage: "lifepreserver.fill")
                        Label(order.fulfillmentLane.label, systemImage: "shippingbox.and.arrow.backward.fill")
                        Label(order.returnStatus.label, systemImage: "arrow.uturn.backward.circle.fill")
                    }

                    Section("Timeline") {
                        ForEach(order.timeline) { event in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: event.state.icon)
                                    .foregroundStyle(event.state.tint)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(event.title)
                                        .font(.headline)
                                    Text(event.detail)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    Section("Items") {
                        ForEach(order.items) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.product.title)
                                    Text("Qty \(item.quantity)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text((item.product.price * Double(item.quantity)).currencyString)
                            }
                        }
                    }

                    Section("Actions") {
                        Button(order.fulfillmentLane == .reviewLocked ? "Clear Fulfillment Review" : "Open Fulfillment Review") {
                            if order.fulfillmentLane == .reviewLocked {
                                store.clearFulfillmentReview(order.id)
                            } else {
                                store.lockFulfillmentReview(order.id)
                            }
                        }
                        .disabled(order.statusHeadline == "Delivered" || order.returnStatus != .locked)

                        Button("Advance Fulfillment") {
                            store.advanceOrder(order.id)
                        }
                        .disabled(order.statusHeadline == "Delivered" || order.fulfillmentLane == .reviewLocked)

                        Button("Confirm Delivery") {
                            store.confirmDelivery(order.id)
                        }
                        .disabled(order.statusHeadline == "Delivered")

                        Button(order.supportAction) {
                            if order.supportAction == "Open courier issue" {
                                store.openSupportIssue(order.id)
                            } else if order.supportAction == "Resolve courier issue" {
                                store.resolveSupportIssue(order.id)
                            } else {
                                store.reorder(order.id)
                            }
                        }
                        .foregroundStyle(.orange)

                        Button("Open Return Inspection") {
                            store.openReturnInspection(order.id)
                        }
                        .disabled(order.returnStatus != .reviewEligible)

                        Button("Approve Exchange") {
                            store.approveExchange(order.id)
                        }
                        .disabled(order.returnStatus != .inspectionPending)

                        Button("Close Return Case") {
                            store.closeReturnCase(order.id)
                        }
                        .disabled(order.returnStatus != .exchangeApproved)
                    }
                }
                .navigationTitle("Order Detail")
            } else {
                ContentUnavailableView("Order unavailable", systemImage: "shippingbox")
            }
        }
    }
}
