import SwiftUI

public extension View {
    func worldClassGlass() -> some View {
        self.background(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.2), lineWidth: 0.5)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.1), radius: 10)
    }
}