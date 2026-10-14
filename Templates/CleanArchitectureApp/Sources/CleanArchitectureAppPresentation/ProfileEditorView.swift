import CleanArchitectureAppDomain
import SwiftUI

struct ProfileEditorView: View {
    @Bindable var model: ProfileEditorModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $model.draft.name)
                        .textContentType(.name)
                    messages(for: .name)
                } header: {
                    Text("Name")
                }
                Section {
                    TextField("Email", text: $model.draft.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    messages(for: .email)
                    if model.saveError == .emailAlreadyInUse {
                        FieldMessage(text: DirectoryError.emailAlreadyInUse.message)
                    }
                } header: {
                    Text("Email")
                }
                if model.canChangeRole {
                    Section("Role") {
                        Picker("Role", selection: $model.draft.role) {
                            ForEach(UserRole.allCases, id: \.self) { role in
                                Text(role.title).tag(role)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                if let error = model.saveError, error != .emailAlreadyInUse {
                    Section {
                        FieldMessage(text: error.message)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if model.isSaving {
                        ProgressView()
                    } else {
                        Button("Save") {
                            Task {
                                if await model.save() != nil { dismiss() }
                            }
                        }
                        .disabled(!model.hasChanges)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func messages(for field: ValidationIssue.Field) -> some View {
        ForEach(model.issues(for: field), id: \.self) { issue in
            FieldMessage(text: issue.message)
        }
    }
}

private struct FieldMessage: View {
    let text: String

    var body: some View {
        Label(text, systemImage: "exclamationmark.circle")
            .font(.footnote)
            .foregroundStyle(.red)
    }
}
