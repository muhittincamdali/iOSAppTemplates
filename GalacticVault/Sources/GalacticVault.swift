import SwiftUI
import SwiftNetwork
import MobileLogger

@main
struct GalacticVaultApp: App {
    init() {
        // Global logging setup
        #if DEBUG
        MobileLogger.shared.logLevel = .debug
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct MainView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "shield.checkerboard")
                    .font(.system(size: 100))
                    .foregroundStyle(.blue.gradient)
                
                VStack(spacing: 8) {
                    Text("GalacticVault")
                        .font(.system(size: 40, weight: .black))
                        .foregroundStyle(.white)
                    
                    Text("AI ENGINE ACTIVATED")
                        .font(.caption.bold())
                        .tracking(3)
                        .foregroundStyle(.blue)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    FeatureRow(icon: "lock.fill", text: "Auth: Biometric")
                    FeatureRow(icon: "database.fill", text: "Storage: Swiftdata")
                    FeatureRow(icon: "bolt.horizontal.circle.fill", text: "Sync: Real-time")
                }
                .applyWorldClassStyle()
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.blue)
            Text(text)
                .foregroundStyle(.white.opacity(0.9))
        }
    }
}