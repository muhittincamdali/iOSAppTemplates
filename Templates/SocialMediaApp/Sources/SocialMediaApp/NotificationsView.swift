import Foundation
import SwiftUI

struct NotificationsView: View {
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some View {
        NavigationView {
            List {
                Section("Unread") {
                    ForEach(notificationManager.notifications.filter(\.isUnread)) { notification in
                        NotificationRow(notification: notification)
                    }
                }
                
                Section("Earlier") {
                    ForEach(notificationManager.notifications.filter { !$0.isUnread }) { notification in
                        NotificationRow(notification: notification)
                    }
                }
            }
            .navigationTitle("Notifications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Mark All Read") {
                        notificationManager.markAllRead()
                    }
                    .disabled(notificationManager.notifications.allSatisfy { !$0.isUnread })
                }
            }
        }
    }
}

struct NotificationRow: View {
    let notification: SocialNotificationItem
    @StateObject private var notificationManager = NotificationManager.shared
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: notification.systemImage)
                .foregroundColor(notification.isUnread ? .blue : .secondary)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.actorName)
                    .font(.subheadline.weight(.semibold))
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(notification.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if notification.isUnread {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
                    .padding(.top, 8)
            }
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture {
            notificationManager.markRead(notification.id)
        }
    }
}
