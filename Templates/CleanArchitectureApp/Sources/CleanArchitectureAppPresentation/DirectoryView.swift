import CleanArchitectureAppDomain
import SwiftUI

/// The searchable list of people, with filter and sort menus and a notice when the list
/// comes from the saved copy.
public struct DirectoryView: View {
    @Bindable private var model: DirectoryModel

    public init(model: DirectoryModel) {
        self.model = model
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("Directory")
                .searchable(text: $model.query.searchText, prompt: "Name or email")
                .toolbar { queryMenu }
                .refreshable { await model.load() }
                .navigationDestination(for: User.ID.self) { id in
                    UserDetailView(model: model, userID: id)
                }
        }
        .task {
            if model.phase == .idle { await model.load() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch (model.phase, model.users.isEmpty) {
        case (.idle, true), (.loading, true):
            ProgressView("Loading the directory…")
        case (.failed(let error), true):
            ContentUnavailableView {
                Label("Directory unavailable", systemImage: "wifi.exclamationmark")
            } description: {
                Text(error.message)
            } actions: {
                Button("Try Again") { Task { await model.load() } }
                    .buttonStyle(.borderedProminent)
            }
        default:
            list
        }
    }

    private var list: some View {
        List {
            if case .cache(let savedAt) = model.origin {
                StatusBanner(
                    systemImage: "icloud.slash",
                    text: "Offline. Showing the copy saved \(savedAt.formatted(date: .abbreviated, time: .shortened))."
                )
            }
            if case .failed(let error) = model.phase, model.origin == .server {
                StatusBanner(systemImage: "exclamationmark.triangle", text: error.message)
            }
            Section {
                ForEach(model.visibleUsers) { user in
                    NavigationLink(value: user.id) {
                        UserRow(user: user, isActingUser: user.id == model.actingUserID)
                    }
                }
            } header: {
                Text(countLabel)
            }
        }
        .overlay {
            if model.visibleUsers.isEmpty {
                ContentUnavailableView.search(text: model.query.searchText)
            }
        }
    }

    private var countLabel: String {
        let count = model.visibleUsers.count
        return count == 1 ? "1 person" : "\(count) people"
    }

    private var queryMenu: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker("Show", selection: $model.query.filter) {
                    ForEach(UserFilter.allCases, id: \.self) { filter in
                        Text(filter.title).tag(filter)
                    }
                }
                Picker("Sort by", selection: $model.query.sortOrder) {
                    ForEach(UserSortOrder.allCases, id: \.self) { order in
                        Text(order.title).tag(order)
                    }
                }
            } label: {
                Label("Filter and sort", systemImage: "line.3.horizontal.decrease.circle")
            }
        }
    }
}

struct UserRow: View {
    let user: User
    let isActingUser: Bool

    var body: some View {
        HStack(spacing: 12) {
            Avatar(name: user.name, isActive: user.isActive, size: 44)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(user.name).font(.headline)
                    if isActingUser {
                        Text("You").font(.caption.weight(.bold)).foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 8)
                    RoleBadge(role: user.role, isActive: user.isActive)
                }
                // The badge sits next to the name so the address gets the full width; one
                // line, because addresses would otherwise wrap with a hyphen after a dot.
                Text(user.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }
}
