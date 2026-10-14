import Foundation
import SwiftUI

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var notifications: [SocialNotificationItem] = []
    
    init() {}
    
    func requestPermission() async {
        if notifications.isEmpty {
            seedPreviewState()
        }
    }
    
    func seedPreviewState() {
        notifications = [
            SocialNotificationItem(id: "n1", actorName: "Amber Design", message: "liked your release update.", systemImage: "heart.fill", isUnread: true, createdAt: Date().addingTimeInterval(-900)),
            SocialNotificationItem(id: "n2", actorName: "Swift Foundry", message: "mentioned you in a thread about app templates.", systemImage: "at", isUnread: true, createdAt: Date().addingTimeInterval(-2400)),
            SocialNotificationItem(id: "n3", actorName: "Ops For Apps", message: "shared your post with their release engineering circle.", systemImage: "arrowshape.turn.up.right.fill", isUnread: false, createdAt: Date().addingTimeInterval(-7200)),
            SocialNotificationItem(id: "n4", actorName: "Maya Studio", message: "started following you.", systemImage: "person.badge.plus", isUnread: false, createdAt: Date().addingTimeInterval(-14400))
        ]
    }
    
    func markRead(_ notificationID: String) {
        guard let index = notifications.firstIndex(where: { $0.id == notificationID }) else { return }
        notifications[index].isUnread = false
    }
    
    func markAllRead() {
        for index in notifications.indices {
            notifications[index].isUnread = false
        }
    }
}
