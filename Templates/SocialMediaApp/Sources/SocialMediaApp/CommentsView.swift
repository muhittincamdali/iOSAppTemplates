import Foundation
import SwiftUI

struct CommentsView: View {
    let post: Post
    @StateObject private var dataManager = DataManager.shared
    @State private var commentDraft = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    Section("Thread") {
                        ForEach(dataManager.comments(for: post.id)) { comment in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(comment.authorName)
                                        .font(.headline)
                                    Text("@\(comment.authorUsername)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(comment.createdAt, style: .relative)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Text(comment.body)
                                    .font(.subheadline)
                                Label("\(comment.likesCount)", systemImage: "heart")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                HStack(spacing: 12) {
                    TextField("Add a comment", text: $commentDraft)
                        .textFieldStyle(.roundedBorder)
                    Button("Send") {
                        dataManager.addComment(body: commentDraft, to: post.id)
                        commentDraft = ""
                    }
                    .disabled(commentDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .navigationTitle("Comments")
        }
    }
}
