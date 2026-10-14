import Foundation
import SwiftUI

struct CommerceHomeView: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CommerceHeroCard(store: store)
                    CommerceCategoryStrip(store: store)
                    CommerceFeaturedSection(store: store)
                    CommerceServiceSurface(store: store)
                }
                .padding(16)
            }
            .navigationTitle("Shop")
        }
    }
}

struct CommerceHeroCard: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Commerce Pulse")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(store.cartItems.isEmpty ? "Your cart is clear. Build the next order with one fast checkout path." : "Your current cart is ready for same-day fulfillment.")
                .font(.system(size: 30, weight: .bold, design: .rounded))

            Text(store.checkoutNotice)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                CommerceMetricChip(title: "Items", value: "\(store.cartItems.count)")
                CommerceMetricChip(title: "Reviews", value: "\(store.reviewLockedOrdersCount)")
                CommerceMetricChip(title: "Support", value: "\(store.activeSupportCaseCount)")
                CommerceMetricChip(title: "Returns", value: "\(store.activeReturnCaseCount)")
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.orange.opacity(0.18), .red.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

struct CommerceMetricChip: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct CommerceCategoryStrip: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Collections")
                .font(.title3.weight(.bold))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(store.categories) { category in
                        Button {
                            store.selectCategory(category.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Image(systemName: category.icon)
                                    .font(.title3)
                                Text(category.title)
                                    .font(.subheadline.weight(.semibold))
                                Text(category.tagline)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            .frame(width: 160, alignment: .leading)
                            .padding()
                            .background(store.selectedCategoryID == category.id ? Color.orange.opacity(0.18) : Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

struct CommerceFeaturedSection: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Picks")
                .font(.title3.weight(.bold))

            ForEach(store.featuredProducts) { product in
                NavigationLink {
                    CommerceProductDetailView(store: store, productID: product.id)
                } label: {
                    CommerceProductCard(product: product, isWishlisted: store.wishlistIDs.contains(product.id))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct CommerceProductCard: View {
    let product: CommerceProduct
    let isWishlisted: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(product.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(product.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: isWishlisted ? "heart.fill" : "heart")
                    .foregroundStyle(.orange)
            }

            Text(product.heroBenefit)
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack {
                Text(product.price.currencyString)
                    .font(.headline)
                Spacer()
                Text(product.shippingETA)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.orange)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct CommerceServiceSurface: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Buyer Confidence")
                .font(.title3.weight(.bold))

            ForEach(CommerceTrustSignal.sampleSignals) { signal in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: signal.icon)
                        .foregroundStyle(signal.tint)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(signal.title)
                            .font(.headline)
                        Text(signal.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}
