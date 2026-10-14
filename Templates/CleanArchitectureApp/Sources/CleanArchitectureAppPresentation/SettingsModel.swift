import Foundation
import Observation

/// What the Settings tab can do to the data sources. The Presentation layer defines this
/// protocol and the composition root implements it, so the screens never import the Data layer.
public protocol BackendControls: Sendable {
    func isServerReachable() async -> Bool
    func setServerReachable(_ reachable: Bool) async
    func clearSavedDirectory() async throws
}

@MainActor
@Observable
public final class SettingsModel {
    public private(set) var isServerReachable = true
    public private(set) var cacheMessage: String?

    private let controls: any BackendControls

    public init(controls: any BackendControls) {
        self.controls = controls
    }

    public func refresh() async {
        isServerReachable = await controls.isServerReachable()
    }

    public func setServerReachable(_ reachable: Bool) async {
        await controls.setServerReachable(reachable)
        isServerReachable = await controls.isServerReachable()
    }

    public func clearSavedDirectory() async {
        do {
            try await controls.clearSavedDirectory()
            cacheMessage = "The saved copy was deleted."
        } catch {
            cacheMessage = "The saved copy could not be deleted: \(error.localizedDescription)"
        }
    }
}
