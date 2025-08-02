import XCTest
@testable import iOSAppTemplates

final class iOSAppTemplatesTests: XCTestCase {
    
    var templateManager: TemplateManager!
    
    override func setUp() {
        super.setUp()
        templateManager = TemplateManager.shared
    }
    
    override func tearDown() {
        templateManager = nil
        super.tearDown()
    }
    
    // MARK: - Template Manager Tests
    
    func testTemplateManagerInitialization() {
        XCTAssertNotNil(templateManager)
        XCTAssertFalse(templateManager.availableTemplates.isEmpty)
    }
    
    func testLoadTemplates() {
        // Given
        let initialCount = templateManager.availableTemplates.count
        
        // When
        templateManager.loadTemplates()
        
        // Then
        XCTAssertGreaterThan(templateManager.availableTemplates.count, 0)
        XCTAssertEqual(templateManager.availableTemplates.count, initialCount)
    }
    
    func testGetTemplateById() {
        // Given
        let templateId = "social-media"
        
        // When
        let template = templateManager.getTemplate(id: templateId)
        
        // Then
        XCTAssertNotNil(template)
        XCTAssertEqual(template?.id, templateId)
        XCTAssertEqual(template?.name, "Social Media App")
    }
    
    func testGetTemplateByInvalidId() {
        // Given
        let invalidTemplateId = "invalid-template"
        
        // When
        let template = templateManager.getTemplate(id: invalidTemplateId)
        
        // Then
        XCTAssertNil(template)
    }
    
    func testGetTemplatesByCategory() {
        // Given
        let category: TemplateCategory = .social
        
        // When
        let templates = templateManager.getTemplates(category: category)
        
        // Then
        XCTAssertFalse(templates.isEmpty)
        XCTAssertTrue(templates.allSatisfy { $0.category == category })
    }
    
    func testGetTemplatesByComplexity() {
        // Given
        let complexity: TemplateComplexity = .intermediate
        
        // When
        let templates = templateManager.getTemplates(complexity: complexity)
        
        // Then
        XCTAssertFalse(templates.isEmpty)
        XCTAssertTrue(templates.allSatisfy { $0.complexity == complexity })
    }
    
    func testSearchTemplates() {
        // Given
        let query = "social"
        
        // When
        let templates = templateManager.searchTemplates(query: query)
        
        // Then
        XCTAssertFalse(templates.isEmpty)
        XCTAssertTrue(templates.contains { $0.name.lowercased().contains(query) })
    }
    
    func testSearchTemplatesWithEmptyQuery() {
        // Given
        let query = ""
        
        // When
        let templates = templateManager.searchTemplates(query: query)
        
        // Then
        XCTAssertEqual(templates.count, templateManager.availableTemplates.count)
    }
    
    func testSelectTemplate() {
        // Given
        let template = templateManager.availableTemplates.first!
        
        // When
        templateManager.selectTemplate(template)
        
        // Then
        XCTAssertNotNil(templateManager.selectedTemplate)
        XCTAssertEqual(templateManager.selectedTemplate?.id, template.id)
    }
    
    func testClearSelection() {
        // Given
        let template = templateManager.availableTemplates.first!
        templateManager.selectTemplate(template)
        XCTAssertNotNil(templateManager.selectedTemplate)
        
        // When
        templateManager.clearSelection()
        
        // Then
        XCTAssertNil(templateManager.selectedTemplate)
    }
    
    // MARK: - App Template Tests
    
    func testAppTemplateInitialization() {
        // Given
        let id = "test-template"
        let name = "Test Template"
        let description = "Test description"
        let category: TemplateCategory = .social
        let features = ["Feature 1", "Feature 2"]
        let technologies = ["SwiftUI", "Firebase"]
        let complexity: TemplateComplexity = .intermediate
        let estimatedTime = "2-3 weeks"
        
        // When
        let template = AppTemplate(
            id: id,
            name: name,
            description: description,
            category: category,
            features: features,
            technologies: technologies,
            complexity: complexity,
            estimatedTime: estimatedTime
        )
        
        // Then
        XCTAssertEqual(template.id, id)
        XCTAssertEqual(template.name, name)
        XCTAssertEqual(template.description, description)
        XCTAssertEqual(template.category, category)
        XCTAssertEqual(template.features, features)
        XCTAssertEqual(template.technologies, technologies)
        XCTAssertEqual(template.complexity, complexity)
        XCTAssertEqual(template.estimatedTime, estimatedTime)
    }
    
    // MARK: - Template Category Tests
    
    func testTemplateCategoryCases() {
        // Given & When & Then
        XCTAssertEqual(TemplateCategory.allCases.count, 8)
        XCTAssertTrue(TemplateCategory.allCases.contains(.social))
        XCTAssertTrue(TemplateCategory.allCases.contains(.commerce))
        XCTAssertTrue(TemplateCategory.allCases.contains(.health))
        XCTAssertTrue(TemplateCategory.allCases.contains(.productivity))
        XCTAssertTrue(TemplateCategory.allCases.contains(.entertainment))
        XCTAssertTrue(TemplateCategory.allCases.contains(.education))
        XCTAssertTrue(TemplateCategory.allCases.contains(.finance))
        XCTAssertTrue(TemplateCategory.allCases.contains(.travel))
    }
    
    func testTemplateCategoryIcons() {
        // Given & When & Then
        XCTAssertEqual(TemplateCategory.social.icon, "person.2.fill")
        XCTAssertEqual(TemplateCategory.commerce.icon, "cart.fill")
        XCTAssertEqual(TemplateCategory.health.icon, "heart.fill")
        XCTAssertEqual(TemplateCategory.productivity.icon, "briefcase.fill")
        XCTAssertEqual(TemplateCategory.entertainment.icon, "play.fill")
        XCTAssertEqual(TemplateCategory.education.icon, "book.fill")
        XCTAssertEqual(TemplateCategory.finance.icon, "dollarsign.circle.fill")
        XCTAssertEqual(TemplateCategory.travel.icon, "airplane")
    }
    
    func testTemplateCategoryColors() {
        // Given & When & Then
        XCTAssertEqual(TemplateCategory.social.color, "blue")
        XCTAssertEqual(TemplateCategory.commerce.color, "green")
        XCTAssertEqual(TemplateCategory.health.color, "red")
        XCTAssertEqual(TemplateCategory.productivity.color, "orange")
        XCTAssertEqual(TemplateCategory.entertainment.color, "purple")
        XCTAssertEqual(TemplateCategory.education.color, "yellow")
        XCTAssertEqual(TemplateCategory.finance.color, "mint")
        XCTAssertEqual(TemplateCategory.travel.color, "cyan")
    }
    
    // MARK: - Template Complexity Tests
    
    func testTemplateComplexityCases() {
        // Given & When & Then
        XCTAssertEqual(TemplateComplexity.allCases.count, 4)
        XCTAssertTrue(TemplateComplexity.allCases.contains(.beginner))
        XCTAssertTrue(TemplateComplexity.allCases.contains(.intermediate))
        XCTAssertTrue(TemplateComplexity.allCases.contains(.advanced))
        XCTAssertTrue(TemplateComplexity.allCases.contains(.expert))
    }
    
    func testTemplateComplexityDescriptions() {
        // Given & When & Then
        XCTAssertFalse(TemplateComplexity.beginner.description.isEmpty)
        XCTAssertFalse(TemplateComplexity.intermediate.description.isEmpty)
        XCTAssertFalse(TemplateComplexity.advanced.description.isEmpty)
        XCTAssertFalse(TemplateComplexity.expert.description.isEmpty)
    }
    
    func testTemplateComplexityExperience() {
        // Given & When & Then
        XCTAssertEqual(TemplateComplexity.beginner.estimatedExperience, "0-1 years")
        XCTAssertEqual(TemplateComplexity.intermediate.estimatedExperience, "1-3 years")
        XCTAssertEqual(TemplateComplexity.advanced.estimatedExperience, "3-5 years")
        XCTAssertEqual(TemplateComplexity.expert.estimatedExperience, "5+ years")
    }
    
    // MARK: - Template Error Tests
    
    func testTemplateErrorDescriptions() {
        // Given & When & Then
        let templateNotFoundError = TemplateError.templateNotFound("test-id")
        XCTAssertNotNil(templateNotFoundError.errorDescription)
        XCTAssertTrue(templateNotFoundError.errorDescription!.contains("test-id"))
        
        let invalidTemplateError = TemplateError.invalidTemplate("test reason")
        XCTAssertNotNil(invalidTemplateError.errorDescription)
        XCTAssertTrue(invalidTemplateError.errorDescription!.contains("test reason"))
        
        let generationFailedError = TemplateError.generationFailed("test reason")
        XCTAssertNotNil(generationFailedError.errorDescription)
        XCTAssertTrue(generationFailedError.errorDescription!.contains("test reason"))
        
        let configurationError = TemplateError.configurationError("test reason")
        XCTAssertNotNil(configurationError.errorDescription)
        XCTAssertTrue(configurationError.errorDescription!.contains("test reason"))
    }
    
    // MARK: - iOS App Templates Tests
    
    func testiOSAppTemplatesVersion() {
        // Given & When & Then
        XCTAssertEqual(iOSAppTemplates.version, "1.0.0")
    }
    
    func testiOSAppTemplatesInitialization() {
        // Given & When & Then
        // This test verifies that initialization doesn't crash
        iOSAppTemplates.initialize()
    }
    
    func testiOSAppTemplatesConfiguration() {
        // Given & When & Then
        // This test verifies that configuration doesn't crash
        iOSAppTemplates.configure(
            templatesEnabled: true,
            documentationEnabled: true,
            examplesEnabled: true
        )
    }
} 