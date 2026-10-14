import CleanArchitectureAppDomain
import SwiftUI

/// Initials on a blue circle; grey for a deactivated account.
struct Avatar: View {
    let name: String
    let isActive: Bool
    let size: CGFloat

    var body: some View {
        Text(initials)
            .font(.system(size: size * 0.38, weight: .semibold, design: .rounded))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(
                Circle().fill(isActive ? AnyShapeStyle(Color.accentColor.gradient) : AnyShapeStyle(Color.gray.gradient))
            )
            .accessibilityHidden(true)
    }

    private var initials: String {
        name.split(separator: " ").prefix(2).compactMap(\.first).map(String.init).joined().uppercased()
    }
}

struct RoleBadge: View {
    let role: UserRole
    let isActive: Bool

    var body: some View {
        Text(isActive ? role.title : "Deactivated")
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            // Primary text on a tinted capsule: tinted caption text on a tinted fill is hard to
            // read. The fill carries the colour.
            .foregroundStyle(.primary)
            .background(Capsule().fill(isActive ? AnyShapeStyle(.tint.opacity(0.18)) : AnyShapeStyle(.quaternary)))
    }
}

struct StatusBanner: View {
    let systemImage: String
    let text: String

    var body: some View {
        Label(text, systemImage: systemImage)
            .font(.subheadline)
            .foregroundStyle(.tint)
            .listRowBackground(Color.accentColor.opacity(0.12))
    }
}
