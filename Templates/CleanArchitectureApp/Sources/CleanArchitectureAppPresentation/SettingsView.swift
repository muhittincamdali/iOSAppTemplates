import CleanArchitectureAppDomain
import SwiftUI

/// Pick who is signed in, switch the sample server off to see the offline fallback, and
/// delete the saved copy.
public struct SettingsView: View {
    private let directory: DirectoryModel
    private let settings: SettingsModel

    public init(directory: DirectoryModel, settings: SettingsModel) {
        self.directory = directory
        self.settings = settings
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Signed in as", selection: actingUser) {
                        ForEach(directory.users.filter(\.isActive)) { user in
                            Text("\(user.name) (\(user.role.title))").tag(Optional(user.id))
                        }
                    }
                } footer: {
                    Text("Admins can edit anyone and change roles. Moderators also see deactivated accounts. Members can edit their own profile.")
                }
                Section {
                    Toggle("Server reachable", isOn: serverReachable)
                    Button("Delete Saved Copy", role: .destructive) {
                        Task { await settings.clearSavedDirectory() }
                    }
                } header: {
                    Text("Sample server")
                } footer: {
                    Text(settings.cacheMessage ?? "Turn the server off and the directory falls back to the copy saved on this device.")
                }
                Section("Layers") {
                    LabeledContent("Domain", value: "Entities, rules, use cases")
                    LabeledContent("Data", value: "HTTP client, cache, repository")
                    LabeledContent("Presentation", value: "Models and SwiftUI views")
                }
            }
            .navigationTitle("Settings")
            .task { await settings.refresh() }
        }
    }

    private var actingUser: Binding<User.ID?> {
        Binding(
            get: { directory.actingUserID },
            set: { id in
                guard let id else { return }
                Task { await directory.signIn(as: id) }
            }
        )
    }

    private var serverReachable: Binding<Bool> {
        Binding(
            get: { settings.isServerReachable },
            set: { reachable in
                Task {
                    await settings.setServerReachable(reachable)
                    await directory.load()
                }
            }
        )
    }
}
