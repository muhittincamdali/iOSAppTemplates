import Foundation
import SwiftUI
import UserNotifications
import EventKit

// MARK: - Productivity Templates
public struct ProductivityTemplates {
    
    // MARK: - Version
    public static let version = "1.0.0"
    
    // MARK: - Initialization
    public static func initialize() {
        print("📊 Productivity Templates v\(version) initialized")
    }
}

// MARK: - Task Management App Template
public struct TaskManagementAppTemplate {
    
    // MARK: - Models
    public struct Task: Identifiable, Codable {
        public let id: String
        public let title: String
        public let description: String?
        public let priority: TaskPriority
        public let status: TaskStatus
        public let category: TaskCategory
        public let dueDate: Date?
        public let completedDate: Date?
        public let estimatedTime: TimeInterval?
        public let actualTime: TimeInterval?
        public let tags: [String]
        public let subtasks: [Subtask]
        public let attachments: [TaskAttachment]
        public let notes: String?
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            description: String? = nil,
            priority: TaskPriority = .medium,
            status: TaskStatus = .pending,
            category: TaskCategory = .personal,
            dueDate: Date? = nil,
            completedDate: Date? = nil,
            estimatedTime: TimeInterval? = nil,
            actualTime: TimeInterval? = nil,
            tags: [String] = [],
            subtasks: [Subtask] = [],
            attachments: [TaskAttachment] = [],
            notes: String? = nil,
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.priority = priority
            self.status = status
            self.category = category
            self.dueDate = dueDate
            self.completedDate = completedDate
            self.estimatedTime = estimatedTime
            self.actualTime = actualTime
            self.tags = tags
            self.subtasks = subtasks
            self.attachments = attachments
            self.notes = notes
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
    
    public struct Subtask: Identifiable, Codable {
        public let id: String
        public let title: String
        public let isCompleted: Bool
        public let completedAt: Date?
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            isCompleted: Bool = false,
            completedAt: Date? = nil
        ) {
            self.id = id
            self.title = title
            self.isCompleted = isCompleted
            self.completedAt = completedAt
        }
    }
    
    public struct TaskAttachment: Identifiable, Codable {
        public let id: String
        public let name: String
        public let url: String
        public let type: AttachmentType
        public let size: Int64
        public let createdAt: Date
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            url: String,
            type: AttachmentType,
            size: Int64,
            createdAt: Date = Date()
        ) {
            self.id = id
            self.name = name
            self.url = url
            self.type = type
            self.size = size
            self.createdAt = createdAt
        }
    }
    
    public struct Project: Identifiable, Codable {
        public let id: String
        public let name: String
        public let description: String?
        public let status: ProjectStatus
        public let priority: ProjectPriority
        public let startDate: Date?
        public let endDate: Date?
        public let progress: Double
        public let tasks: [Task]
        public let team: [TeamMember]
        public let budget: Budget?
        public let tags: [String]
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            description: String? = nil,
            status: ProjectStatus = .planning,
            priority: ProjectPriority = .medium,
            startDate: Date? = nil,
            endDate: Date? = nil,
            progress: Double = 0.0,
            tasks: [Task] = [],
            team: [TeamMember] = [],
            budget: Budget? = nil,
            tags: [String] = [],
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.status = status
            self.priority = priority
            self.startDate = startDate
            self.endDate = endDate
            self.progress = progress
            self.tasks = tasks
            self.team = team
            self.budget = budget
            self.tags = tags
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
    
    public struct TeamMember: Identifiable, Codable {
        public let id: String
        public let name: String
        public let email: String
        public let role: TeamRole
        public let avatarURL: String?
        public let isActive: Bool
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            email: String,
            role: TeamRole,
            avatarURL: String? = nil,
            isActive: Bool = true
        ) {
            self.id = id
            self.name = name
            self.email = email
            self.role = role
            self.avatarURL = avatarURL
            self.isActive = isActive
        }
    }
    
    public struct Budget: Codable {
        public let total: Double
        public let spent: Double
        public let currency: String
        public let categories: [BudgetCategory]
        
        public init(
            total: Double,
            spent: Double = 0.0,
            currency: String = "USD",
            categories: [BudgetCategory] = []
        ) {
            self.total = total
            self.spent = spent
            self.currency = currency
            self.categories = categories
        }
        
        public var remaining: Double {
            return total - spent
        }
        
        public var percentageSpent: Double {
            return total > 0 ? (spent / total) * 100 : 0
        }
    }
    
    public struct BudgetCategory: Identifiable, Codable {
        public let id: String
        public let name: String
        public let allocated: Double
        public let spent: Double
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            allocated: Double,
            spent: Double = 0.0
        ) {
            self.id = id
            self.name = name
            self.allocated = allocated
            self.spent = spent
        }
        
        public var remaining: Double {
            return allocated - spent
        }
    }
    
    public struct TimeEntry: Identifiable, Codable {
        public let id: String
        public let taskId: String
        public let startTime: Date
        public let endTime: Date?
        public let duration: TimeInterval
        public let description: String?
        public let isBillable: Bool
        public let rate: Double?
        
        public init(
            id: String = UUID().uuidString,
            taskId: String,
            startTime: Date,
            endTime: Date? = nil,
            duration: TimeInterval = 0,
            description: String? = nil,
            isBillable: Bool = false,
            rate: Double? = nil
        ) {
            self.id = id
            self.taskId = taskId
            self.startTime = startTime
            self.endTime = endTime
            self.duration = duration
            self.description = description
            self.isBillable = isBillable
            self.rate = rate
        }
    }
    
    // MARK: - Enums
    public enum TaskPriority: String, CaseIterable, Codable {
        case low = "low"
        case medium = "medium"
        case high = "high"
        case urgent = "urgent"
        
        public var displayName: String {
            switch self {
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            case .urgent: return "Urgent"
            }
        }
        
        public var color: String {
            switch self {
            case .low: return "green"
            case .medium: return "blue"
            case .high: return "orange"
            case .urgent: return "red"
            }
        }
    }
    
    public enum TaskStatus: String, CaseIterable, Codable {
        case pending = "pending"
        case inProgress = "in_progress"
        case completed = "completed"
        case cancelled = "cancelled"
        case onHold = "on_hold"
        
        public var displayName: String {
            switch self {
            case .pending: return "Pending"
            case .inProgress: return "In Progress"
            case .completed: return "Completed"
            case .cancelled: return "Cancelled"
            case .onHold: return "On Hold"
            }
        }
    }
    
    public enum TaskCategory: String, CaseIterable, Codable {
        case personal = "personal"
        case work = "work"
        case health = "health"
        case finance = "finance"
        case education = "education"
        case shopping = "shopping"
        case travel = "travel"
        case entertainment = "entertainment"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .personal: return "Personal"
            case .work: return "Work"
            case .health: return "Health"
            case .finance: return "Finance"
            case .education: return "Education"
            case .shopping: return "Shopping"
            case .travel: return "Travel"
            case .entertainment: return "Entertainment"
            case .other: return "Other"
            }
        }
        
        public var icon: String {
            switch self {
            case .personal: return "person.fill"
            case .work: return "briefcase.fill"
            case .health: return "heart.fill"
            case .finance: return "dollarsign.circle.fill"
            case .education: return "book.fill"
            case .shopping: return "cart.fill"
            case .travel: return "airplane"
            case .entertainment: return "gamecontroller.fill"
            case .other: return "ellipsis.circle"
            }
        }
    }
    
    public enum AttachmentType: String, CaseIterable, Codable {
        case image = "image"
        case document = "document"
        case video = "video"
        case audio = "audio"
        case link = "link"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .image: return "Image"
            case .document: return "Document"
            case .video: return "Video"
            case .audio: return "Audio"
            case .link: return "Link"
            case .other: return "Other"
            }
        }
    }
    
    public enum ProjectStatus: String, CaseIterable, Codable {
        case planning = "planning"
        case active = "active"
        case onHold = "on_hold"
        case completed = "completed"
        case cancelled = "cancelled"
        
        public var displayName: String {
            switch self {
            case .planning: return "Planning"
            case .active: return "Active"
            case .onHold: return "On Hold"
            case .completed: return "Completed"
            case .cancelled: return "Cancelled"
            }
        }
    }
    
    public enum ProjectPriority: String, CaseIterable, Codable {
        case low = "low"
        case medium = "medium"
        case high = "high"
        case critical = "critical"
        
        public var displayName: String {
            switch self {
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            case .critical: return "Critical"
            }
        }
    }
    
    public enum TeamRole: String, CaseIterable, Codable {
        case owner = "owner"
        case manager = "manager"
        case member = "member"
        case viewer = "viewer"
        
        public var displayName: String {
            switch self {
            case .owner: return "Owner"
            case .manager: return "Manager"
            case .member: return "Member"
            case .viewer: return "Viewer"
            }
        }
    }
    
    // MARK: - Managers
    public class TaskManager: ObservableObject {
        
        @Published public var tasks: [Task] = []
        @Published public var projects: [Project] = []
        @Published public var timeEntries: [TimeEntry] = []
        @Published public var isLoading = false
        
        private let notificationManager = NotificationManager()
        private let calendarManager = CalendarManager()
        
        public init() {}
        
        // MARK: - Task Methods
        
        public func createTask(_ task: Task) async throws {
            isLoading = true
            defer { isLoading = false }
            
            // Add to local storage
            tasks.append(task)
            
            // Schedule notification if due date is set
            if let dueDate = task.dueDate {
                try await notificationManager.scheduleTaskReminder(
                    taskId: task.id,
                    title: task.title,
                    body: task.description ?? "Task due",
                    date: dueDate
                )
            }
            
            // Add to calendar if needed
            if task.category == .work || task.category == .personal {
                try await calendarManager.addTaskToCalendar(task)
            }
        }
        
        public func updateTask(_ task: Task) async throws {
            guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
                throw TaskError.taskNotFound
            }
            
            isLoading = true
            defer { isLoading = false }
            
            tasks[index] = task
            
            // Update notification
            if let dueDate = task.dueDate {
                try await notificationManager.updateTaskReminder(
                    taskId: task.id,
                    title: task.title,
                    body: task.description ?? "Task due",
                    date: dueDate
                )
            }
        }
        
        public func deleteTask(_ taskId: String) async throws {
            guard let index = tasks.firstIndex(where: { $0.id == taskId }) else {
                throw TaskError.taskNotFound
            }
            
            isLoading = true
            defer { isLoading = false }
            
            tasks.remove(at: index)
            
            // Cancel notification
            try await notificationManager.cancelTaskReminder(taskId: taskId)
        }
        
        public func completeTask(_ taskId: String) async throws {
            guard let index = tasks.firstIndex(where: { $0.id == taskId }) else {
                throw TaskError.taskNotFound
            }
            
            var task = tasks[index]
            task.status = .completed
            task.completedDate = Date()
            
            try await updateTask(task)
        }
        
        public func getTasksByStatus(_ status: TaskStatus) -> [Task] {
            return tasks.filter { $0.status == status }
        }
        
        public func getTasksByPriority(_ priority: TaskPriority) -> [Task] {
            return tasks.filter { $0.priority == priority }
        }
        
        public func getTasksByCategory(_ category: TaskCategory) -> [Task] {
            return tasks.filter { $0.category == category }
        }
        
        public func getOverdueTasks() -> [Task] {
            let now = Date()
            return tasks.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return task.status != .completed && dueDate < now
            }
        }
        
        public func getTodayTasks() -> [Task] {
            let today = Calendar.current.startOfDay(for: Date())
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            
            return tasks.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return dueDate >= today && dueDate < tomorrow
            }
        }
        
        // MARK: - Project Methods
        
        public func createProject(_ project: Project) async throws {
            isLoading = true
            defer { isLoading = false }
            
            projects.append(project)
        }
        
        public func updateProject(_ project: Project) async throws {
            guard let index = projects.firstIndex(where: { $0.id == project.id }) else {
                throw TaskError.projectNotFound
            }
            
            isLoading = true
            defer { isLoading = false }
            
            projects[index] = project
        }
        
        public func deleteProject(_ projectId: String) async throws {
            guard let index = projects.firstIndex(where: { $0.id == projectId }) else {
                throw TaskError.projectNotFound
            }
            
            isLoading = true
            defer { isLoading = false }
            
            projects.remove(at: index)
        }
        
        // MARK: - Time Tracking Methods
        
        public func startTimeTracking(for taskId: String) async throws {
            let timeEntry = TimeEntry(
                taskId: taskId,
                startTime: Date()
            )
            
            timeEntries.append(timeEntry)
        }
        
        public func stopTimeTracking(for taskId: String) async throws {
            guard let index = timeEntries.firstIndex(where: { $0.taskId == taskId && $0.endTime == nil }) else {
                throw TaskError.noActiveTimeEntry
            }
            
            var timeEntry = timeEntries[index]
            timeEntry.endTime = Date()
            timeEntry.duration = timeEntry.endTime!.timeIntervalSince(timeEntry.startTime)
            
            timeEntries[index] = timeEntry
            
            // Update task with actual time
            if let taskIndex = tasks.firstIndex(where: { $0.id == taskId }) {
                var task = tasks[taskIndex]
                task.actualTime = (task.actualTime ?? 0) + timeEntry.duration
                try await updateTask(task)
            }
        }
        
        public func getTimeEntries(for taskId: String) -> [TimeEntry] {
            return timeEntries.filter { $0.taskId == taskId }
        }
        
        public func getTotalTime(for taskId: String) -> TimeInterval {
            return timeEntries
                .filter { $0.taskId == taskId }
                .reduce(0) { $0 + $1.duration }
        }
    }
    
    public class NotificationManager {
        
        public init() {}
        
        public func requestPermission() async throws -> Bool {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            if settings.authorizationStatus == .notDetermined {
                return try await center.requestAuthorization(options: [.alert, .badge, .sound])
            }
            
            return settings.authorizationStatus == .authorized
        }
        
        public func scheduleTaskReminder(taskId: String, title: String, body: String, date: Date) async throws {
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date),
                repeats: false
            )
            
            let request = UNNotificationRequest(
                identifier: "task_\(taskId)",
                content: content,
                trigger: trigger
            )
            
            try await center.add(request)
        }
        
        public func updateTaskReminder(taskId: String, title: String, body: String, date: Date) async throws {
            try await cancelTaskReminder(taskId: taskId)
            try await scheduleTaskReminder(taskId: taskId, title: title, body: body, date: date)
        }
        
        public func cancelTaskReminder(taskId: String) async throws {
            let center = UNUserNotificationCenter.current()
            await center.removePendingNotificationRequests(withIdentifiers: ["task_\(taskId)"])
        }
    }
    
    public class CalendarManager {
        
        private let eventStore = EKEventStore()
        
        public init() {}
        
        public func requestAccess() async throws -> Bool {
            if #available(iOS 17.0, *) {
                return try await eventStore.requestFullAccessToEvents()
            } else {
                return await withCheckedContinuation { continuation in
                    eventStore.requestAccess(to: .event) { granted, error in
                        continuation.resume(returning: granted)
                    }
                }
            }
        }
        
        public func addTaskToCalendar(_ task: Task) async throws {
            guard let dueDate = task.dueDate else { return }
            
            let event = EKEvent(eventStore: eventStore)
            event.title = task.title
            event.notes = task.description
            event.startDate = dueDate
            event.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: dueDate) ?? dueDate
            event.calendar = eventStore.defaultCalendarForNewEvents
            
            try eventStore.save(event, span: .thisEvent)
        }
    }
    
    // MARK: - UI Components
    
    public struct TaskCard: View {
        let task: Task
        let onTap: () -> Void
        let onComplete: () -> Void
        
        public init(task: Task, onTap: @escaping () -> Void, onComplete: @escaping () -> Void) {
            self.task = task
            self.onTap = onTap
            self.onComplete = onComplete
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    Button(action: onComplete) {
                        Image(systemName: task.status == .completed ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.status == .completed ? .green : .gray)
                            .font(.title2)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(task.title)
                            .font(.headline)
                            .strikethrough(task.status == .completed)
                            .foregroundColor(task.status == .completed ? .secondary : .primary)
                        
                        if let description = task.description {
                            Text(description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(task.priority.displayName)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(task.priority.color).opacity(0.2))
                            .foregroundColor(Color(task.priority.color))
                            .cornerRadius(4)
                        
                        if let dueDate = task.dueDate {
                            Text(dueDate, style: .date)
                                .font(.caption)
                                .foregroundColor(isOverdue ? .red : .secondary)
                        }
                    }
                }
                
                // Tags
                if !task.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(task.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
                
                // Progress
                if !task.subtasks.isEmpty {
                    let completedCount = task.subtasks.filter { $0.isCompleted }.count
                    let totalCount = task.subtasks.count
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Subtasks")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(completedCount)/\(totalCount)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        ProgressView(value: Double(completedCount), total: Double(totalCount))
                            .progressViewStyle(LinearProgressViewStyle())
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            .onTapGesture {
                onTap()
            }
        }
        
        private var isOverdue: Bool {
            guard let dueDate = task.dueDate else { return false }
            return task.status != .completed && dueDate < Date()
        }
    }
    
    public struct ProjectCard: View {
        let project: Project
        let onTap: () -> Void
        
        public init(project: Project, onTap: @escaping () -> Void) {
            self.project = project
            self.onTap = onTap
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(project.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        if let description = project.description {
                            Text(description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(project.status.displayName)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(4)
                        
                        Text(project.priority.displayName)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(project.priority.color).opacity(0.2))
                            .foregroundColor(Color(project.priority.color))
                            .cornerRadius(4)
                    }
                }
                
                // Progress
                VStack(alignment: .leading) {
                    HStack {
                        Text("Progress")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(Int(project.progress * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    ProgressView(value: project.progress)
                        .progressViewStyle(LinearProgressViewStyle())
                }
                
                // Stats
                HStack(spacing: 20) {
                    VStack {
                        Text("\(project.tasks.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Tasks")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Text("\(project.team.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Members")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let budget = project.budget {
                        VStack {
                            Text("\(Int(budget.percentageSpent))%")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Budget")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            .onTapGesture {
                onTap()
            }
        }
    }
    
    // MARK: - Errors
    
    public enum TaskError: LocalizedError {
        case taskNotFound
        case projectNotFound
        case noActiveTimeEntry
        case invalidData
        case permissionDenied
        case networkError
        
        public var errorDescription: String? {
            switch self {
            case .taskNotFound:
                return "Task not found"
            case .projectNotFound:
                return "Project not found"
            case .noActiveTimeEntry:
                return "No active time entry"
            case .invalidData:
                return "Invalid data"
            case .permissionDenied:
                return "Permission denied"
            case .networkError:
                return "Network error occurred"
            }
        }
    }
} 