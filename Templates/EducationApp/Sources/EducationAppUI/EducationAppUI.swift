import SwiftUI

@available(iOS 18.0, macOS 15.0, *)
public struct EducationProgressCard: View {
    let title: String
    let value: String
    let systemImage: String

    public init(
        title: String,
        value: String,
        systemImage: String
    ) {
        self.title = title
        self.value = value
        self.systemImage = systemImage
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: systemImage)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
