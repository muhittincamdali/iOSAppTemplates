import SwiftUI

public extension View {
    func applyWorldClassStyle() -> some View {
        self.padding()
            .background(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.white.opacity(0.2), lineWidth: 0.5)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.15), radius: 15)
    }
}