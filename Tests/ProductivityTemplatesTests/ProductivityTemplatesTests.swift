import XCTest
@testable import ProductivityTemplates

final class ProductivityTemplatesTests: XCTestCase {
    
    func testProductivityTemplatesInitialization() {
        // Given
        let version = ProductivityTemplates.version
        
        // Then
        XCTAssertEqual(version, "1.0.0")
    }
    
    func testTaskInitialization() {
        // Given
        let task = TaskManagementAppTemplate.Task(
            id: "task-1",
            title: "Complete project",
            description: "Finish the iOS app project",
            priority: .high,
            status: .pending,
            category: .work,
            dueDate: Date().addingTimeInterval(86400),
            accountId: "account-1"
        )
        
        // Then
        XCTAssertEqual(task.id, "task-1")
        XCTAssertEqual(task.title, "Complete project")
        XCTAssertEqual(task.description, "Finish the iOS app project")
        XCTAssertEqual(task.priority, .high)
        XCTAssertEqual(task.status, .pending)
        XCTAssertEqual(task.category, .work)
        XCTAssertEqual(task.accountId, "account-1")
    }
    
    func testSubtaskInitialization() {
        // Given
        let subtask = TaskManagementAppTemplate.Subtask(
            id: "subtask-1",
            title: "Design UI",
            isCompleted: false
        )
        
        // Then
        XCTAssertEqual(subtask.id, "subtask-1")
        XCTAssertEqual(subtask.title, "Design UI")
        XCTAssertFalse(subtask.isCompleted)
    }
    
    func testTaskAttachmentInitialization() {
        // Given
        let attachment = TaskManagementAppTemplate.TaskAttachment(
            id: "attachment-1",
            name: "document.pdf",
            url: "https://example.com/document.pdf",
            type: .document,
            size: 1024
        )
        
        // Then
        XCTAssertEqual(attachment.id, "attachment-1")
        XCTAssertEqual(attachment.name, "document.pdf")
        XCTAssertEqual(attachment.url, "https://example.com/document.pdf")
        XCTAssertEqual(attachment.type, .document)
        XCTAssertEqual(attachment.size, 1024)
    }
    
    func testProjectInitialization() {
        // Given
        let project = TaskManagementAppTemplate.Project(
            id: "project-1",
            name: "Mobile App Development",
            description: "Create a new mobile app",
            status: .active,
            priority: .high,
            startDate: Date(),
            endDate: Date().addingTimeInterval(2592000),
            progress: 0.5,
            tasks: [],
            team: [],
            budget: nil,
            tags: ["mobile", "ios"]
        )
        
        // Then
        XCTAssertEqual(project.id, "project-1")
        XCTAssertEqual(project.name, "Mobile App Development")
        XCTAssertEqual(project.status, .active)
        XCTAssertEqual(project.priority, .high)
        XCTAssertEqual(project.progress, 0.5)
        XCTAssertEqual(project.tags.count, 2)
    }
    
    func testTeamMemberInitialization() {
        // Given
        let member = TaskManagementAppTemplate.TeamMember(
            id: "member-1",
            name: "John Doe",
            email: "john@example.com",
            role: .manager
        )
        
        // Then
        XCTAssertEqual(member.id, "member-1")
        XCTAssertEqual(member.name, "John Doe")
        XCTAssertEqual(member.email, "john@example.com")
        XCTAssertEqual(member.role, .manager)
        XCTAssertTrue(member.isActive)
    }
    
    func testBudgetInitialization() {
        // Given
        let budget = TaskManagementAppTemplate.Budget(
            total: 10000.0,
            spent: 5000.0,
            currency: "USD",
            categories: []
        )
        
        // Then
        XCTAssertEqual(budget.total, 10000.0)
        XCTAssertEqual(budget.spent, 5000.0)
        XCTAssertEqual(budget.currency, "USD")
        XCTAssertEqual(budget.remaining, 5000.0)
        XCTAssertEqual(budget.percentageSpent, 50.0)
    }
    
    func testBudgetCategoryInitialization() {
        // Given
        let category = TaskManagementAppTemplate.BudgetCategory(
            id: "category-1",
            name: "Development",
            allocated: 5000.0,
            spent: 2500.0,
            category: .work
        )
        
        // Then
        XCTAssertEqual(category.id, "category-1")
        XCTAssertEqual(category.name, "Development")
        XCTAssertEqual(category.allocated, 5000.0)
        XCTAssertEqual(category.spent, 2500.0)
        XCTAssertEqual(category.remaining, 2500.0)
        XCTAssertEqual(category.percentageSpent, 50.0)
    }
    
    func testTimeEntryInitialization() {
        // Given
        let timeEntry = TaskManagementAppTemplate.TimeEntry(
            id: "entry-1",
            taskId: "task-1",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            duration: 3600,
            description: "Coding session",
            isBillable: true,
            rate: 50.0
        )
        
        // Then
        XCTAssertEqual(timeEntry.id, "entry-1")
        XCTAssertEqual(timeEntry.taskId, "task-1")
        XCTAssertEqual(timeEntry.duration, 3600)
        XCTAssertEqual(timeEntry.description, "Coding session")
        XCTAssertTrue(timeEntry.isBillable)
        XCTAssertEqual(timeEntry.rate, 50.0)
    }
    
    func testTransactionTypeProperties() {
        // Given
        let income = TaskManagementAppTemplate.TransactionType.income
        let expense = TaskManagementAppTemplate.TransactionType.expense
        let transfer = TaskManagementAppTemplate.TransactionType.transfer
        
        // Then
        XCTAssertEqual(income.displayName, "Income")
        XCTAssertEqual(income.color, "green")
        XCTAssertEqual(expense.displayName, "Expense")
        XCTAssertEqual(expense.color, "red")
        XCTAssertEqual(transfer.displayName, "Transfer")
        XCTAssertEqual(transfer.color, "blue")
    }
    
    func testTaskStatusProperties() {
        // Given
        let pending = TaskManagementAppTemplate.TaskStatus.pending
        let inProgress = TaskManagementAppTemplate.TaskStatus.inProgress
        let completed = TaskManagementAppTemplate.TaskStatus.completed
        
        // Then
        XCTAssertEqual(pending.displayName, "Pending")
        XCTAssertEqual(inProgress.displayName, "In Progress")
        XCTAssertEqual(completed.displayName, "Completed")
    }
    
    func testTaskCategoryProperties() {
        // Given
        let work = TaskManagementAppTemplate.TaskCategory.work
        let personal = TaskManagementAppTemplate.TaskCategory.personal
        let health = TaskManagementAppTemplate.TaskCategory.health
        
        // Then
        XCTAssertEqual(work.displayName, "Work")
        XCTAssertEqual(work.icon, "briefcase.fill")
        XCTAssertEqual(personal.displayName, "Personal")
        XCTAssertEqual(personal.icon, "person.fill")
        XCTAssertEqual(health.displayName, "Health")
        XCTAssertEqual(health.icon, "heart.fill")
    }
    
    func testAttachmentTypeProperties() {
        // Given
        let image = TaskManagementAppTemplate.AttachmentType.image
        let document = TaskManagementAppTemplate.AttachmentType.document
        let video = TaskManagementAppTemplate.AttachmentType.video
        
        // Then
        XCTAssertEqual(image.displayName, "Image")
        XCTAssertEqual(document.displayName, "Document")
        XCTAssertEqual(video.displayName, "Video")
    }
    
    func testProjectStatusProperties() {
        // Given
        let planning = TaskManagementAppTemplate.ProjectStatus.planning
        let active = TaskManagementAppTemplate.ProjectStatus.active
        let completed = TaskManagementAppTemplate.ProjectStatus.completed
        
        // Then
        XCTAssertEqual(planning.displayName, "Planning")
        XCTAssertEqual(active.displayName, "Active")
        XCTAssertEqual(completed.displayName, "Completed")
    }
    
    func testProjectPriorityProperties() {
        // Given
        let low = TaskManagementAppTemplate.ProjectPriority.low
        let medium = TaskManagementAppTemplate.ProjectPriority.medium
        let high = TaskManagementAppTemplate.ProjectPriority.high
        
        // Then
        XCTAssertEqual(low.displayName, "Low")
        XCTAssertEqual(medium.displayName, "Medium")
        XCTAssertEqual(high.displayName, "High")
    }
    
    func testTeamRoleProperties() {
        // Given
        let owner = TaskManagementAppTemplate.TeamRole.owner
        let manager = TaskManagementAppTemplate.TeamRole.manager
        let member = TaskManagementAppTemplate.TeamRole.member
        
        // Then
        XCTAssertEqual(owner.displayName, "Owner")
        XCTAssertEqual(manager.displayName, "Manager")
        XCTAssertEqual(member.displayName, "Member")
    }
    
    func testTaskManagerInitialization() {
        // Given
        let manager = TaskManagementAppTemplate.TaskManager()
        
        // Then
        XCTAssertTrue(manager.tasks.isEmpty)
        XCTAssertTrue(manager.projects.isEmpty)
        XCTAssertTrue(manager.timeEntries.isEmpty)
        XCTAssertFalse(manager.isLoading)
    }
    
    func testNotificationManagerInitialization() {
        // Given
        let manager = TaskManagementAppTemplate.NotificationManager()
        
        // Then
        XCTAssertNotNil(manager)
    }
    
    func testCalendarManagerInitialization() {
        // Given
        let manager = TaskManagementAppTemplate.CalendarManager()
        
        // Then
        XCTAssertNotNil(manager)
    }
    
    func testTaskCardInitialization() {
        // Given
        let task = TaskManagementAppTemplate.Task(
            id: "test",
            title: "Test Task",
            priority: .medium,
            status: .pending,
            category: .work,
            accountId: "account-1"
        )
        
        let card = TaskManagementAppTemplate.TaskCard(
            task: task,
            onTap: {},
            onComplete: {}
        )
        
        // Then
        XCTAssertNotNil(card)
    }
    
    func testProjectCardInitialization() {
        // Given
        let project = TaskManagementAppTemplate.Project(
            id: "test",
            name: "Test Project",
            status: .active,
            priority: .medium,
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400),
            progress: 0.5,
            tasks: [],
            team: []
        )
        
        let card = TaskManagementAppTemplate.ProjectCard(
            project: project,
            onTap: {}
        )
        
        // Then
        XCTAssertNotNil(card)
    }
    
    func testTaskErrorDescriptions() {
        // Given & When
        let taskNotFound = TaskManagementAppTemplate.TaskError.taskNotFound
        let projectNotFound = TaskManagementAppTemplate.TaskError.projectNotFound
        let noActiveTimeEntry = TaskManagementAppTemplate.TaskError.noActiveTimeEntry
        let invalidData = TaskManagementAppTemplate.TaskError.invalidData
        let permissionDenied = TaskManagementAppTemplate.TaskError.permissionDenied
        let networkError = TaskManagementAppTemplate.TaskError.networkError
        
        // Then
        XCTAssertEqual(taskNotFound.errorDescription, "Task not found")
        XCTAssertEqual(projectNotFound.errorDescription, "Project not found")
        XCTAssertEqual(noActiveTimeEntry.errorDescription, "No active time entry")
        XCTAssertEqual(invalidData.errorDescription, "Invalid data")
        XCTAssertEqual(permissionDenied.errorDescription, "Permission denied")
        XCTAssertEqual(networkError.errorDescription, "Network error occurred")
    }
} 