import Foundation
import SwiftUI

struct CommerceCatalogView: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.visibleProducts) { product in
                    NavigationLink {
                        CommerceProductDetailView(store: store, productID: product.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(product.title)
                                    .font(.headline)
                                Spacer()
                                Text(product.price.currencyString)
                                    .font(.subheadline.weight(.semibold))
                            }
                            Text(product.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("\(product.rating, specifier: "%.1f")★ • \(product.reviewCount) reviews • \(product.shippingETA)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle(store.selectedCategory?.title ?? "Browse")
        }
    }
}

struct CommerceProductDetailView: View {
    @ObservedObject var store: CommerceStore
    let productID: UUID

    private var product: CommerceProduct? {
        store.products.first(where: { $0.id == productID })
    }

    var body: some View {
        Group {
            if let product {
                List {
                    Section("Product") {
                        Text(product.title)
                            .font(.title3.weight(.bold))
                        Text(product.subtitle)
                            .foregroundStyle(.secondary)
                        Text(product.heroBenefit)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Label(product.price.currencyString, systemImage: "creditcard.fill")
                        Label(product.shippingETA, systemImage: "truck.box.fill")
                        Label("\(product.stockStatus)", systemImage: "shippingbox.fill")
                    }

                    Section("Variants") {
                        ForEach(product.variants, id: \.self) { variant in
                            Label(variant, systemImage: "circle.grid.2x2.fill")
                        }
                    }

                    Section("Proof") {
                        Label("\(product.rating, specifier: "%.1f") average rating", systemImage: "star.fill")
                        Label("\(product.reviewCount) customer reviews", systemImage: "bubble.left.and.bubble.right.fill")
                        Label(product.returnPolicy, systemImage: "arrow.uturn.backward.circle.fill")
                    }

                    Section("Actions") {
                        Button(store.wishlistIDs.contains(product.id) ? "Remove From Wishlist" : "Save To Wishlist") {
                            store.toggleWishlist(product.id)
                        }
                        Button("Add To Cart") {
                            store.addToCart(product.id)
                        }
                        .foregroundStyle(.orange)
                    }
                }
                .navigationTitle("Product Detail")
            } else {
                ContentUnavailableView("Product unavailable", systemImage: "bag")
            }
        }
    }
}
