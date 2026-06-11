import SwiftUI

/// Visual Signature of the World-Class Portfolio
/// Provides the canonical "Liquid Glass" effect used across flagships.
public struct LiquidGlassModifier: ViewModifier {
    var intensity: Double
    
    public init(intensity: Double = 1.0) {
        self.intensity = intensity
    }
    
    public func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.2 * intensity), lineWidth: 0.5)
            }
            .shadow(color: .black.opacity(0.1 * intensity), radius: 10, x: 0, y: 5)
            .mask {
                RoundedRectangle(cornerRadius: 16)
            }
    }
}

public extension View {
    func liquidGlass(intensity: Double = 1.0) -> some View {
        self.modifier(LiquidGlassModifier(intensity: intensity))
    }
}

/// A flagship demo view for visual proof
public struct VisualProofShowcase: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .purple, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Technical Excellence")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 12) {
                    Image(systemName: "cpu.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                    
                    Text("Swift 6 Native • Zero Bloat")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .frame(width: 300, height: 200)
                .liquidGlass()
                
                Text("This template is officially arındırıldı (purged) from all legacy dependencies like Alamofire and Firebase.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
    }
}
