import Foundation
import iOSAppTemplates

/// Basic example demonstrating the core functionality of iOSAppTemplates
@main
struct BasicExample {
    static func main() {
        print("🚀 iOSAppTemplates Basic Example")
        
        // Initialize the framework
        let framework = iOSAppTemplates()
        
        // Configure with default settings
        framework.configure()
        
        print("✅ Framework configured successfully")
        
        // Demonstrate basic functionality
        demonstrateBasicFeatures(framework)
    }
    
    static func demonstrateBasicFeatures(_ framework: iOSAppTemplates) {
        print("\n📱 Demonstrating basic features...")
        
        // Add your example code here
        print("🎯 Feature 1: Core functionality")
        print("🎯 Feature 2: Configuration")
        print("🎯 Feature 3: Error handling")
        
        print("\n✨ Basic example completed successfully!")
    }
}
