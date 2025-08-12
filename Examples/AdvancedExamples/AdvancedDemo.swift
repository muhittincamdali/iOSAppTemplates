import SwiftUI

@available(iOS 15.0, *)
struct AdvancedDemo: View {
    @State private var isActive: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Advanced Example")
                .font(.title)
            Toggle("Enable Feature", isOn: $isActive)
            RoundedRectangle(cornerRadius: 16)
                .fill(isActive ? .green : .gray)
                .frame(width: 240, height: 140)
                .overlay(Text(isActive ? "ENABLED" : "DISABLED").foregroundColor(.white))
                .animation(.easeInOut, value: isActive)
        }
        .padding(24)
    }
}
