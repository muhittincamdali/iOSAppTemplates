import CleanArchitectureAppDomain
import SwiftUI

/// One person: contact details, what their role allows, and the actions the acting user may take.
struct UserDetailView: View {
    let model: DirectoryModel
    let userID: User.ID
    @State private var editor: ProfileEditorModel?

    var body: some View {
        if let user = model.user(withID: userID) {
            details(for: user)
        } else {
            ContentUnavailableView("Not in the directory", systemImage: "person.crop.circle.badge.questionmark")
        }
    }

    private func details(for user: User) -> some View {
        List {
            Section {
                VStack(spacing: 8) {
                    Avatar(name: user.name, isActive: user.isActive, size: 72)
                    Text(user.name).font(.title2.bold())
                    RoleBadge(role: user.role, isActive: user.isActive)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
            }
            Section("Contact") {
                LabeledContent("Email", value: user.email)
                LabeledContent("Joined", value: user.joinedAt.formatted(date: .long, time: .omitted))
            }
            Section("Permissions") {
                ForEach(Permission.allCases, id: \.self) { permission in
                    Label(permission.title, systemImage: user.can(permission) ? "checkmark.circle.fill" : "minus.circle")
                        .foregroundStyle(user.can(permission) ? AnyShapeStyle(.primary) : AnyShapeStyle(.secondary))
                }
            }
            actions(for: user)
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $editor) { editor in
            ProfileEditorView(model: editor)
        }
        .alert(
            "Could not update the account",
            isPresented: Binding(get: { model.actionError != nil }, set: { if !$0 { model.actionError = nil } }),
            presenting: model.actionError
        ) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            Text(error.message)
        }
    }

    @ViewBuilder
    private func actions(for user: User) -> some View {
        let canEdit = model.actingUser?.canEditProfile(of: user) ?? false
        let canToggle = model.canChangeActiveState(of: user)
        if canEdit || canToggle {
            Section {
                if canEdit {
                    Button("Edit Profile") { editor = model.makeEditor(for: user) }
                }
                if canToggle {
                    Button(user.isActive ? "Deactivate Account" : "Reactivate Account", role: user.isActive ? .destructive : nil) {
                        Task { await model.setActive(!user.isActive, for: user) }
                    }
                }
            }
        }
    }
}

extension ProfileEditorModel: Identifiable {
    public nonisolated var id: User.ID { original.id }
}
