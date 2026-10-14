import Foundation
import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = DataManager.shared
    @State private var caption = ""
    @State private var selectedAudience = "Public"
    @State private var attachedMedia = ["launch-plan.png", "workspace-shot.mov"]
    @State private var isPublishing = false
    @State private var publishMessage: String?
    
    private let audienceOptions = ["Public", "Close Friends", "Team"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Caption") {
                    TextEditor(text: $caption)
                        .frame(minHeight: 140)
                    Text("\(caption.count)/280")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section("Audience") {
                    Picker("Audience", selection: $selectedAudience) {
                        ForEach(audienceOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Attached Media") {
                    ForEach(attachedMedia, id: \.self) { asset in
                        Label(asset, systemImage: asset.hasSuffix(".mov") ? "video" : "photo")
                    }
                    Button("Add another attachment") {
                        attachedMedia.append("idea-board-\(attachedMedia.count + 1).png")
                    }
                }
                
                Section("Publishing Checklist") {
                    ChecklistRow(title: "Hook in first line", isDone: !caption.isEmpty)
                    ChecklistRow(title: "At least one attachment", isDone: !attachedMedia.isEmpty)
                    ChecklistRow(title: "Clear audience selected", isDone: !selectedAudience.isEmpty)
                }
                
                if let publishMessage {
                    Section {
                        Text(publishMessage)
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("Create Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isPublishing ? "Publishing..." : "Publish") {
                        publishPost()
                    }
                    .disabled(caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isPublishing)
                }
            }
            .onAppear {
                if caption.isEmpty {
                    caption = "Shipped a shorter onboarding flow today: three screens instead of five, and clearer copy."
                }
            }
        }
    }
    
    private func publishPost() {
        isPublishing = true
        let trimmedCaption = caption.trimmingCharacters(in: .whitespacesAndNewlines)
        Task {
            try? await Task.sleep(for: .milliseconds(250))
            await MainActor.run {
                dataManager.publishPost(
                    content: trimmedCaption,
                    author: PostAuthor(name: "Preview User", username: "preview", isVerified: true),
                    audience: selectedAudience,
                    attachmentCount: attachedMedia.count
                )
                publishMessage = "Post published to the feed."
                isPublishing = false
            }
        }
    }
}
