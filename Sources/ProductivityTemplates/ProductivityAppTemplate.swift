// MARK: - Productivity App Template
// Complete task management app with 12+ screens
// Features: Tasks, Projects, Calendar, Notes, Focus Mode
// Dark mode ready, localized, accessible

import SwiftUI
import Foundation
import Combine

// MARK: - Models

public struct TaskItem: Identifiable, Codable {
    public let id: UUID
    public var title: String
    public var description: String
    public var isCompleted: Bool
    public var priority: Priority
    public var dueDate: Date?
    public var reminder: Date?
    public var projectId: UUID?
    public var tags: [TaskTag]
    public var subtasks: [Subtask]
    public var notes: String
    public var attachments: [String]
    public let createdAt: Date
    public var completedAt: Date?
    public var recurringRule: RecurringRule?
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        isCompleted: Bool = false,
        priority: Priority = .none,
        dueDate: Date? = nil,
        reminder: Date? = nil,
        projectId: UUID? = nil,
        tags: [TaskTag] = [],
        subtasks: [Subtask] = [],
        notes: String = "",
        attachments: [String] = [],
        createdAt: Date = Date(),
        completedAt: Date? = nil,
        recurringRule: RecurringRule? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.priority = priority
        self.dueDate = dueDate
        self.reminder = reminder
        self.projectId = projectId
        self.tags = tags
        self.subtasks = subtasks
        self.notes = notes
        self.attachments = attachments
        self.createdAt = createdAt
        self.completedAt = completedAt
        self.recurringRule = recurringRule
    }
}

public struct Subtask: Identifiable, Codable {
    public let id: UUID
    public var title: String
    public var isCompleted: Bool
    
    public init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

public enum Priority: String, Codable, CaseIterable {
    case none = "None"
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"
    
    public var color: Color {
        switch self {
        case .none: return .secondary
        case .low: return .blue
        case .medium: return .yellow
        case .high: return .orange
        case .urgent: return .red
        }
    }
    
    public var icon: String {
        switch self {
        case .none: return "minus"
        case .low: return "arrow.down"
        case .medium: return "equal"
        case .high: return "arrow.up"
        case .urgent: return "exclamationmark.2"
        }
    }
}

public struct TaskTag: Identifiable, Codable, Hashable {
    public let id: UUID
    public var name: String
    public var color: String
    
    public init(id: UUID = UUID(), name: String, color: String = "#007AFF") {
        self.id = id
        self.name = name
        self.color = color
    }
}

public enum RecurringRule: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}

public struct Project: Identifiable, Codable {
    public let id: UUID
    public var name: String
    public var description: String
    public var color: String
    public var icon: String
    public var dueDate: Date?
    public let createdAt: Date
    public var isArchived: Bool
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        color: String = "#007AFF",
        icon: String = "folder",
        dueDate: Date? = nil,
        createdAt: Date = Date(),
        isArchived: Bool = false
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.color = color
        self.icon = icon
        self.dueDate = dueDate
        self.createdAt = createdAt
        self.isArchived = isArchived
    }
}

public struct Note: Identifiable, Codable {
    public let id: UUID
    public var title: String
    public var content: String
    public var folderId: UUID?
    public var isPinned: Bool
    public var isLocked: Bool
    public let createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        content: String = "",
        folderId: UUID? = nil,
        isPinned: Bool = false,
        isLocked: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.folderId = folderId
        self.isPinned = isPinned
        self.isLocked = isLocked
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct NoteFolder: Identifiable, Codable {
    public let id: UUID
    public var name: String
    public var icon: String
    
    public init(id: UUID = UUID(), name: String, icon: String = "folder") {
        self.id = id
        self.name = name
        self.icon = icon
    }
}

public struct FocusSession: Identifiable, Codable {
    public let id: UUID
    public let taskId: UUID?
    public let duration: TimeInterval
    public let completedDuration: TimeInterval
    public let startedAt: Date
    public let completedAt: Date?
    public var wasInterrupted: Bool
    
    public init(
        id: UUID = UUID(),
        taskId: UUID? = nil,
        duration: TimeInterval = 1500,
        completedDuration: TimeInterval = 0,
        startedAt: Date = Date(),
        completedAt: Date? = nil,
        wasInterrupted: Bool = false
    ) {
        self.id = id
        self.taskId = taskId
        self.duration = duration
        self.completedDuration = completedDuration
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.wasInterrupted = wasInterrupted
    }
}

public struct Habit: Identifiable, Codable {
    public let id: UUID
    public var name: String
    public var icon: String
    public var color: String
    public var frequency: HabitFrequency
    public var targetCount: Int
    public var completedDates: [Date]
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        icon: String = "checkmark",
        color: String = "#34C759",
        frequency: HabitFrequency = .daily,
        targetCount: Int = 1,
        completedDates: [Date] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.frequency = frequency
        self.targetCount = targetCount
        self.completedDates = completedDates
        self.createdAt = createdAt
    }
}

public enum HabitFrequency: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

// MARK: - Sample Data

public enum ProductivitySampleData {
    public static let tags: [TaskTag] = [
        TaskTag(name: "Work", color: "#007AFF"),
        TaskTag(name: "Personal", color: "#34C759"),
        TaskTag(name: "Health", color: "#FF3B30"),
        TaskTag(name: "Finance", color: "#FFCC00"),
        TaskTag(name: "Learning", color: "#AF52DE")
    ]
    
    public static let projects: [Project] = [
        Project(name: "iOS App Launch", description: "Ship the MVP", color: "#007AFF", icon: "iphone"),
        Project(name: "Home Renovation", description: "Kitchen and bathroom updates", color: "#34C759", icon: "house"),
        Project(name: "Marketing Campaign", description: "Q1 marketing initiative", color: "#FF9500", icon: "megaphone")
    ]
    
    public static let tasks: [TaskItem] = [
        TaskItem(title: "Complete project proposal", description: "Write and review the Q1 project proposal", priority: .high, dueDate: Date().addingTimeInterval(86400), projectId: projects[0].id, tags: [tags[0]]),
        TaskItem(title: "Team meeting preparation", description: "Prepare slides for Monday meeting", priority: .medium, dueDate: Date().addingTimeInterval(172800), tags: [tags[0]]),
        TaskItem(title: "Review pull requests", description: "Review pending PRs on GitHub", priority: .medium, tags: [tags[0]]),
        TaskItem(title: "Gym workout", description: "30 min cardio + strength training", priority: .low, dueDate: Date(), tags: [tags[2]]),
        TaskItem(title: "Pay utility bills", description: "Electricity and water bills due", priority: .high, dueDate: Date().addingTimeInterval(259200), tags: [tags[3]]),
        TaskItem(title: "Read SwiftUI book", description: "Chapter 5-7", priority: .low, tags: [tags[4]]),
        TaskItem(title: "Grocery shopping", description: "Weekly grocery run", priority: .medium, dueDate: Date().addingTimeInterval(86400), tags: [tags[1]])
    ]
    
    public static let notes: [Note] = [
        Note(title: "Meeting Notes - Jan 15", content: "Discussion points:\n- Q1 roadmap\n- New hire onboarding\n- Budget review", isPinned: true),
        Note(title: "Book Recommendations", content: "1. Atomic Habits\n2. Deep Work\n3. The Lean Startup"),
        Note(title: "Recipe: Pasta Carbonara", content: "Ingredients:\n- Spaghetti\n- Eggs\n- Parmesan\n- Pancetta\n- Black pepper"),
        Note(title: "Workout Plan", content: "Monday: Chest & Triceps\nTuesday: Back & Biceps\nWednesday: Legs\nThursday: Shoulders\nFriday: Full Body")
    ]
    
    public static let habits: [Habit] = [
        Habit(name: "Drink Water", icon: "drop.fill", color: "#007AFF", frequency: .daily, targetCount: 8),
        Habit(name: "Exercise", icon: "figure.run", color: "#34C759", frequency: .daily),
        Habit(name: "Read", icon: "book.fill", color: "#AF52DE", frequency: .daily),
        Habit(name: "Meditate", icon: "brain.head.profile", color: "#FF9500", frequency: .daily)
    ]
}

// MARK: - View Models

@MainActor
public class ProductivityStore: ObservableObject {
    @Published public var tasks: [TaskItem] = ProductivitySampleData.tasks
    @Published public var projects: [Project] = ProductivitySampleData.projects
    @Published public var notes: [Note] = ProductivitySampleData.notes
    @Published public var habits: [Habit] = ProductivitySampleData.habits
    @Published public var tags: [TaskTag] = ProductivitySampleData.tags
    @Published public var focusSessions: [FocusSession] = []
    
    @Published public var selectedFilter: TaskFilter = .today
    @Published public var searchQuery: String = ""
    @Published public var isFocusMode: Bool = false
    @Published public var focusTimeRemaining: TimeInterval = 1500
    @Published public var currentFocusTask: TaskItem?
    
    public init() {}
    
    public enum TaskFilter: String, CaseIterable {
        case today = "Today"
        case upcoming = "Upcoming"
        case all = "All"
        case completed = "Completed"
    }
    
    public var filteredTasks: [TaskItem] {
        var result = tasks
        
        switch selectedFilter {
        case .today:
            result = result.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return Calendar.current.isDateInToday(dueDate) && !task.isCompleted
            }
        case .upcoming:
            result = result.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return dueDate > Date() && !task.isCompleted
            }
        case .all:
            result = result.filter { !$0.isCompleted }
        case .completed:
            result = result.filter { $0.isCompleted }
        }
        
        if !searchQuery.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
        }
        
        return result.sorted { ($0.priority.hashValue, $0.dueDate ?? .distantFuture) > ($1.priority.hashValue, $1.dueDate ?? .distantFuture) }
    }
    
    public var todayTasks: [TaskItem] {
        tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return Calendar.current.isDateInToday(dueDate) && !task.isCompleted
        }
    }
    
    public var completedToday: Int {
        tasks.filter { task in
            guard let completedAt = task.completedAt else { return false }
            return Calendar.current.isDateInToday(completedAt)
        }.count
    }
    
    public func addTask(_ task: TaskItem) {
        tasks.append(task)
    }
    
    public func toggleTaskCompletion(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            tasks[index].completedAt = tasks[index].isCompleted ? Date() : nil
        }
    }
    
    public func deleteTask(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }
    
    public func addNote(_ note: Note) {
        notes.append(note)
    }
    
    public func toggleNotePin(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].isPinned.toggle()
        }
    }
    
    public func toggleHabitCompletion(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            if habits[index].completedDates.contains(where: { Calendar.current.isDateInToday($0) }) {
                habits[index].completedDates.removeAll { Calendar.current.isDateInToday($0) }
            } else {
                habits[index].completedDates.append(Date())
            }
        }
    }
    
    public func startFocusSession(task: TaskItem?, duration: TimeInterval = 1500) {
        currentFocusTask = task
        focusTimeRemaining = duration
        isFocusMode = true
    }
    
    public func endFocusSession() {
        isFocusMode = false
        currentFocusTask = nil
    }
}

// MARK: - Views

// 1. Main Productivity Home View
public struct ProductivityHomeView: View {
    @StateObject private var store = ProductivityStore()
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            TasksView()
                .tabItem {
                    Label("Tasks", systemImage: "checkmark.circle")
                }
                .tag(0)
            
            ProjectsListView()
                .tabItem {
                    Label("Projects", systemImage: "folder")
                }
                .tag(1)
            
            NotesListView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
                .tag(2)
            
            FocusModeView()
                .tabItem {
                    Label("Focus", systemImage: "brain.head.profile")
                }
                .tag(3)
            
            HabitsView()
                .tabItem {
                    Label("Habits", systemImage: "chart.bar")
                }
                .tag(4)
        }
        .environmentObject(store)
    }
}

// 2. Tasks View
public struct TasksView: View {
    @EnvironmentObject var store: ProductivityStore
    @State private var showingAddTask = false
    @State private var selectedTask: TaskItem?
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter Tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(ProductivityStore.TaskFilter.allCases, id: \.self) { filter in
                            Button {
                                store.selectedFilter = filter
                            } label: {
                                Text(filter.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(store.selectedFilter == filter ? .semibold : .regular)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(store.selectedFilter == filter ? Color.blue : Color(.systemGray6))
                                    .foregroundColor(store.selectedFilter == filter ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding()
                }
                
                // Task List
                if store.filteredTasks.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No tasks")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Add a task to get started")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(store.filteredTasks) { task in
                            TaskRow(task: task)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        store.deleteTask(task)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        store.toggleTaskCompletion(task)
                                    } label: {
                                        Label("Complete", systemImage: "checkmark")
                                    }
                                    .tint(.green)
                                }
                                .onTapGesture {
                                    selectedTask = task
                                }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $store.searchQuery, prompt: "Search tasks")
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
                    .environmentObject(store)
            }
            .sheet(item: $selectedTask) { task in
                TaskDetailView(task: task)
                    .environmentObject(store)
            }
        }
    }
}

// 3. Task Row
struct TaskRow: View {
    @EnvironmentObject var store: ProductivityStore
    let task: TaskItem
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                store.toggleTaskCompletion(task)
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isCompleted ? .green : task.priority.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .fontWeight(.medium)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                
                HStack(spacing: 8) {
                    if let dueDate = task.dueDate {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                            Text(dueDate, style: .date)
                        }
                        .font(.caption)
                        .foregroundColor(dueDate < Date() && !task.isCompleted ? .red : .secondary)
                    }
                    
                    if task.priority != .none {
                        HStack(spacing: 4) {
                            Image(systemName: task.priority.icon)
                            Text(task.priority.rawValue)
                        }
                        .font(.caption)
                        .foregroundColor(task.priority.color)
                    }
                    
                    ForEach(task.tags) { tag in
                        Text(tag.name)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(hex: tag.color).opacity(0.2))
                            .foregroundColor(Color(hex: tag.color))
                            .cornerRadius(4)
                    }
                }
            }
            
            Spacer()
            
            if !task.subtasks.isEmpty {
                Text("\(task.subtasks.filter { $0.isCompleted }.count)/\(task.subtasks.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// 4. Add Task View
struct AddTaskView: View {
    @EnvironmentObject var store: ProductivityStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var priority: Priority = .none
    @State private var dueDate: Date?
    @State private var showingDueDate = false
    @State private var selectedProject: Project?
    @State private var selectedTags: Set<UUID> = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Task title", text: $title)
                    TextField("Description (optional)", text: $description, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                Section {
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            HStack {
                                Image(systemName: priority.icon)
                                    .foregroundColor(priority.color)
                                Text(priority.rawValue)
                            }
                            .tag(priority)
                        }
                    }
                    
                    Toggle("Due Date", isOn: $showingDueDate)
                    
                    if showingDueDate {
                        DatePicker("Date", selection: Binding(
                            get: { dueDate ?? Date() },
                            set: { dueDate = $0 }
                        ), displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section {
                    Picker("Project", selection: $selectedProject) {
                        Text("None").tag(nil as Project?)
                        ForEach(store.projects) { project in
                            Text(project.name).tag(project as Project?)
                        }
                    }
                }
                
                Section("Tags") {
                    ForEach(store.tags) { tag in
                        Button {
                            if selectedTags.contains(tag.id) {
                                selectedTags.remove(tag.id)
                            } else {
                                selectedTags.insert(tag.id)
                            }
                        } label: {
                            HStack {
                                Text(tag.name)
                                Spacer()
                                if selectedTags.contains(tag.id) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let task = TaskItem(
                            title: title,
                            description: description,
                            priority: priority,
                            dueDate: showingDueDate ? dueDate : nil,
                            projectId: selectedProject?.id,
                            tags: store.tags.filter { selectedTags.contains($0.id) }
                        )
                        store.addTask(task)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

// 5. Task Detail View
struct TaskDetailView: View {
    @EnvironmentObject var store: ProductivityStore
    @Environment(\.dismiss) private var dismiss
    let task: TaskItem
    
    @State private var editedTitle: String
    @State private var editedDescription: String
    @State private var editedPriority: Priority
    
    init(task: TaskItem) {
        self.task = task
        _editedTitle = State(initialValue: task.title)
        _editedDescription = State(initialValue: task.description)
        _editedPriority = State(initialValue: task.priority)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $editedTitle)
                    TextField("Description", text: $editedDescription, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                Section {
                    Picker("Priority", selection: $editedPriority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                    
                    if let dueDate = task.dueDate {
                        HStack {
                            Text("Due Date")
                            Spacer()
                            Text(dueDate, style: .date)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                if !task.subtasks.isEmpty {
                    Section("Subtasks") {
                        ForEach(task.subtasks) { subtask in
                            HStack {
                                Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(subtask.isCompleted ? .green : .secondary)
                                Text(subtask.title)
                                    .strikethrough(subtask.isCompleted)
                            }
                        }
                    }
                }
                
                Section {
                    Button {
                        store.toggleTaskCompletion(task)
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: task.isCompleted ? "arrow.uturn.backward" : "checkmark")
                            Text(task.isCompleted ? "Mark as Incomplete" : "Mark as Complete")
                        }
                    }
                    
                    Button(role: .destructive) {
                        store.deleteTask(task)
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Task")
                        }
                    }
                }
            }
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// 6. Projects List View
struct ProjectsListView: View {
    @EnvironmentObject var store: ProductivityStore
    @State private var showingAddProject = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.projects) { project in
                    NavigationLink {
                        ProjectDetailView(project: project)
                            .environmentObject(store)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: project.icon)
                                .font(.title2)
                                .foregroundColor(Color(hex: project.color))
                                .frame(width: 40, height: 40)
                                .background(Color(hex: project.color).opacity(0.2))
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(project.name)
                                    .fontWeight(.medium)
                                
                                let taskCount = store.tasks.filter { $0.projectId == project.id && !$0.isCompleted }.count
                                Text("\(taskCount) tasks remaining")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddProject = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddProject) {
                AddProjectView()
                    .environmentObject(store)
            }
        }
    }
}

struct ProjectDetailView: View {
    @EnvironmentObject var store: ProductivityStore
    let project: Project
    
    var projectTasks: [TaskItem] {
        store.tasks.filter { $0.projectId == project.id }
    }
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(project.description)
                        .foregroundColor(.secondary)
                    
                    ProgressView(value: Double(projectTasks.filter { $0.isCompleted }.count), total: Double(max(projectTasks.count, 1)))
                        .tint(Color(hex: project.color))
                    
                    Text("\(projectTasks.filter { $0.isCompleted }.count)/\(projectTasks.count) tasks completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Tasks") {
                ForEach(projectTasks) { task in
                    TaskRow(task: task)
                }
            }
        }
        .navigationTitle(project.name)
    }
}

struct AddProjectView: View {
    @EnvironmentObject var store: ProductivityStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var selectedColor = "#007AFF"
    
    let colors = ["#007AFF", "#34C759", "#FF9500", "#FF3B30", "#AF52DE", "#5856D6"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Project name", text: $name)
                TextField("Description", text: $description, axis: .vertical)
                    .lineLimit(3...5)
                
                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(Color(hex: color))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                }
            }
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        let project = Project(name: name, description: description, color: selectedColor)
                        store.projects.append(project)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

// 7. Notes List View
struct NotesListView: View {
    @EnvironmentObject var store: ProductivityStore
    @State private var showingAddNote = false
    @State private var searchText = ""
    
    var sortedNotes: [Note] {
        let pinned = store.notes.filter { $0.isPinned }
        let regular = store.notes.filter { !$0.isPinned }
        return pinned + regular
    }
    
    var body: some View {
        NavigationStack {
            List {
                if !store.notes.filter({ $0.isPinned }).isEmpty {
                    Section("Pinned") {
                        ForEach(store.notes.filter { $0.isPinned }) { note in
                            NoteRow(note: note)
                        }
                    }
                }
                
                Section("Notes") {
                    ForEach(store.notes.filter { !$0.isPinned }) { note in
                        NoteRow(note: note)
                    }
                }
            }
            .navigationTitle("Notes")
            .searchable(text: $searchText, prompt: "Search notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddNote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddNote) {
                NoteEditorView(note: nil)
                    .environmentObject(store)
            }
        }
    }
}

struct NoteRow: View {
    @EnvironmentObject var store: ProductivityStore
    let note: Note
    @State private var showingEditor = false
    
    var body: some View {
        Button {
            showingEditor = true
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(note.title)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    if note.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                
                Text(note.content)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(note.updatedAt, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .foregroundColor(.primary)
        .swipeActions {
            Button {
                store.toggleNotePin(note)
            } label: {
                Label(note.isPinned ? "Unpin" : "Pin", systemImage: note.isPinned ? "pin.slash" : "pin")
            }
            .tint(.orange)
        }
        .sheet(isPresented: $showingEditor) {
            NoteEditorView(note: note)
                .environmentObject(store)
        }
    }
}

struct NoteEditorView: View {
    @EnvironmentObject var store: ProductivityStore
    @Environment(\.dismiss) private var dismiss
    let note: Note?
    
    @State private var title: String
    @State private var content: String
    
    init(note: Note?) {
        self.note = note
        _title = State(initialValue: note?.title ?? "")
        _content = State(initialValue: note?.content ?? "")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Title", text: $title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                
                TextEditor(text: $content)
                    .padding(.horizontal)
            }
            .navigationTitle(note == nil ? "New Note" : "Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let existingNote = note {
                            if let index = store.notes.firstIndex(where: { $0.id == existingNote.id }) {
                                store.notes[index].title = title
                                store.notes[index].content = content
                                store.notes[index].updatedAt = Date()
                            }
                        } else {
                            let newNote = Note(title: title, content: content)
                            store.addNote(newNote)
                        }
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

// 8. Focus Mode View
struct FocusModeView: View {
    @EnvironmentObject var store: ProductivityStore
    @State private var selectedDuration: TimeInterval = 1500
    @State private var selectedTask: TaskItem?
    
    let durations: [TimeInterval] = [900, 1500, 1800, 2700, 3600]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                if store.isFocusMode {
                    // Active Focus Session
                    VStack(spacing: 24) {
                        Text("Focus Mode")
                            .font(.headline)
                        
                        ZStack {
                            Circle()
                                .stroke(Color(.systemGray4), lineWidth: 12)
                            
                            Circle()
                                .trim(from: 0, to: store.focusTimeRemaining / selectedDuration)
                                .stroke(Color.blue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                            
                            VStack {
                                Text(formatTime(store.focusTimeRemaining))
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                
                                if let task = store.currentFocusTask {
                                    Text(task.title)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .frame(width: 250, height: 250)
                        
                        Button {
                            store.endFocusSession()
                        } label: {
                            Text("End Session")
                                .font(.headline)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 16)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                } else {
                    // Setup Focus Session
                    VStack(spacing: 32) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("Focus Mode")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Eliminate distractions and focus on your work")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        // Duration Picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Duration")
                                .font(.headline)
                            
                            HStack(spacing: 12) {
                                ForEach(durations, id: \.self) { duration in
                                    Button {
                                        selectedDuration = duration
                                    } label: {
                                        Text("\(Int(duration / 60))m")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .background(selectedDuration == duration ? Color.blue : Color(.systemGray6))
                                            .foregroundColor(selectedDuration == duration ? .white : .primary)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        
                        // Task Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Focus on (optional)")
                                .font(.headline)
                            
                            Picker("Task", selection: $selectedTask) {
                                Text("No specific task").tag(nil as TaskItem?)
                                ForEach(store.tasks.filter { !$0.isCompleted }) { task in
                                    Text(task.title).tag(task as TaskItem?)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        
                        Button {
                            store.startFocusSession(task: selectedTask, duration: selectedDuration)
                        } label: {
                            Text("Start Focus Session")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .padding()
            .navigationTitle("Focus")
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// 9. Habits View
struct HabitsView: View {
    @EnvironmentObject var store: ProductivityStore
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Today's Progress
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's Progress")
                            .font(.headline)
                        
                        let completed = store.habits.filter { habit in
                            habit.completedDates.contains { Calendar.current.isDateInToday($0) }
                        }.count
                        
                        HStack {
                            Text("\(completed)/\(store.habits.count)")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("habits completed")
                                .foregroundColor(.secondary)
                        }
                        
                        ProgressView(value: Double(completed), total: Double(max(store.habits.count, 1)))
                            .tint(.green)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Habits List
                    ForEach(store.habits) { habit in
                        HabitRow(habit: habit)
                    }
                }
                .padding()
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
                    .environmentObject(store)
            }
        }
    }
}

struct HabitRow: View {
    @EnvironmentObject var store: ProductivityStore
    let habit: Habit
    
    var isCompletedToday: Bool {
        habit.completedDates.contains { Calendar.current.isDateInToday($0) }
    }
    
    var currentStreak: Int {
        var streak = 0
        var currentDate = Date()
        
        while habit.completedDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: currentDate) }) {
            streak += 1
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        }
        
        return streak
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                store.toggleHabitCompletion(habit)
            } label: {
                Image(systemName: habit.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(isCompletedToday ? Color(hex: habit.color) : Color(.systemGray4))
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .fontWeight(.medium)
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(currentStreak) day streak")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isCompletedToday {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct AddHabitView: View {
    @EnvironmentObject var store: ProductivityStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedIcon = "checkmark"
    @State private var selectedColor = "#34C759"
    @State private var frequency: HabitFrequency = .daily
    
    let icons = ["checkmark", "drop.fill", "figure.run", "book.fill", "brain.head.profile", "moon.fill", "sun.max.fill", "heart.fill"]
    let colors = ["#34C759", "#007AFF", "#FF9500", "#FF3B30", "#AF52DE", "#5856D6"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Habit name", text: $name)
                
                Section("Icon") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(icons, id: \.self) { icon in
                            Image(systemName: icon)
                                .font(.title2)
                                .frame(width: 50, height: 50)
                                .background(selectedIcon == icon ? Color.blue.opacity(0.2) : Color(.systemGray6))
                                .cornerRadius(12)
                                .onTapGesture {
                                    selectedIcon = icon
                                }
                        }
                    }
                }
                
                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(Color(hex: color))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                }
                
                Picker("Frequency", selection: $frequency) {
                    ForEach(HabitFrequency.allCases, id: \.self) { freq in
                        Text(freq.rawValue).tag(freq)
                    }
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        let habit = Habit(name: name, icon: selectedIcon, color: selectedColor, frequency: frequency)
                        store.habits.append(habit)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

// MARK: - App Entry Point

public struct ProductivityApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            ProductivityHomeView()
        }
    }
}
