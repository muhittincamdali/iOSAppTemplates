import SwiftUI
import SwiftNetwork

@main
struct VisionEmpireApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "crown.fill")
                .font(.system(size: 80))
                .foregroundStyle(.yellow)
            
            Text("VisionEmpire")
                .font(.largeTitle.bold())
            
            Text("Powered by Visionos Template")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(40)
        .worldClassGlass()
    }
}