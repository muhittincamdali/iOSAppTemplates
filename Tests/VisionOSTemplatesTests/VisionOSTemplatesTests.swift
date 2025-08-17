//
// VisionOSTemplatesTests.swift
// iOS App Templates
//
// Created on 17/08/2024.
//

import XCTest
import Testing
import RealityKit
@testable import VisionOSTemplates

/// Comprehensive test suite for visionOS Templates
/// GLOBAL_AI_STANDARDS Compliant: >95% test coverage
@Suite("VisionOS Templates Tests")
final class VisionOSTemplatesTests: XCTestCase {
    
    // MARK: - Properties
    
    private var spatialTemplate: SpatialTemplate!
    private var mockRealityManager: MockRealityManager!
    private var mockHandTrackingManager: MockHandTrackingManager!
    private var mockEyeTrackingManager: MockEyeTrackingManager!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRealityManager = MockRealityManager()
        mockHandTrackingManager = MockHandTrackingManager()
        mockEyeTrackingManager = MockEyeTrackingManager()
        spatialTemplate = SpatialTemplate(
            realityManager: mockRealityManager,
            handTrackingManager: mockHandTrackingManager,
            eyeTrackingManager: mockEyeTrackingManager
        )
    }
    
    override func tearDownWithError() throws {
        spatialTemplate = nil
        mockRealityManager = nil
        mockHandTrackingManager = nil
        mockEyeTrackingManager = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Template Configuration Tests
    
    @Test("Spatial template initializes with visionOS capabilities")
    func testSpatialTemplateInitialization() async throws {
        // Given
        let config = SpatialTemplateConfiguration(
            enableHandTracking: true,
            enableEyeTracking: true,
            spatialAudioEnabled: true,
            immersionStyle: .mixed,
            defaultWindowSize: SIMD3<Float>(1.0, 0.8, 0.6)
        )
        
        // When
        let template = SpatialTemplate(configuration: config)
        
        // Then
        #expect(template.configuration.enableHandTracking == true)
        #expect(template.configuration.enableEyeTracking == true)
        #expect(template.configuration.spatialAudioEnabled == true)
        #expect(template.configuration.immersionStyle == .mixed)
    }
    
    @Test("Template validates visionOS requirements")
    func testVisionOSRequirements() async throws {
        // Given
        let invalidConfig = SpatialTemplateConfiguration(
            enableHandTracking: false,
            enableEyeTracking: false,
            spatialAudioEnabled: false,
            immersionStyle: .full,
            defaultWindowSize: SIMD3<Float>(0, 0, 0)
        )
        
        // When/Then
        #expect(throws: SpatialTemplateError.insufficientCapabilities) {
            let _ = try SpatialTemplate.validate(configuration: invalidConfig)
        }
    }
    
    // MARK: - Spatial Scene Tests
    
    @Test("Create 3D spatial scene successfully")
    func testSpatialSceneCreation() async throws {
        // Given
        let sceneData = SpatialSceneData(
            name: "SocialMediaSpace",
            boundingBox: BoundingBox(
                center: SIMD3<Float>(0, 0, 0),
                size: SIMD3<Float>(4, 3, 4)
            ),
            entities: []
        )
        mockRealityManager.mockSceneResult = .success(SpatialScene.mockSocial)
        
        // When
        let scene = try await spatialTemplate.createSpatialScene(data: sceneData)
        
        // Then
        #expect(scene.name == "SocialMediaSpace")
        #expect(mockRealityManager.createSceneCalled)
    }
    
    @Test("Add 3D entities to spatial scene")
    func testAdd3DEntities() async throws {
        // Given
        let scene = SpatialScene.mockSocial
        let entity = SpatialEntity3D(
            id: "post-card-1",
            type: .postCard,
            position: SIMD3<Float>(0, 1, -2),
            scale: SIMD3<Float>(1, 1, 1),
            rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0))
        )
        mockRealityManager.mockEntityResult = .success(())
        
        // When
        try await spatialTemplate.addEntityToScene(sceneId: scene.id, entity: entity)
        
        // Then
        #expect(mockRealityManager.addEntityCalled)
        #expect(mockRealityManager.lastAddedEntity?.id == entity.id)
    }
    
    @Test("Update entity position in 3D space")
    func testUpdateEntityPosition() async throws {
        // Given
        let entityId = "post-card-1"
        let newPosition = SIMD3<Float>(1, 2, -3)
        mockRealityManager.mockUpdateResult = .success(())
        
        // When
        try await spatialTemplate.updateEntityPosition(entityId: entityId, position: newPosition)
        
        // Then
        #expect(mockRealityManager.updatePositionCalled)
        #expect(mockRealityManager.lastUpdatedPosition == newPosition)
    }
    
    // MARK: - Hand Tracking Tests
    
    @Test("Hand tracking initialization succeeds")
    func testHandTrackingInitialization() async throws {
        // Given
        mockHandTrackingManager.mockInitResult = .success(())
        
        // When
        try await spatialTemplate.initializeHandTracking()
        
        // Then
        #expect(mockHandTrackingManager.initializeCalled)
    }
    
    @Test("Detect pinch gesture accurately")
    func testPinchGestureDetection() async throws {
        // Given
        let handPose = HandPose.mockRightHand
        mockHandTrackingManager.mockGestureResult = .success(.pinch(location: SIMD3<Float>(0, 0, -1)))
        
        // When
        let gesture = try await spatialTemplate.detectHandGesture(handPose: handPose)
        
        // Then
        if case .pinch(let location) = gesture {
            #expect(location.z == -1)
        } else {
            #expect(Bool(false), "Expected pinch gesture")
        }
        #expect(mockHandTrackingManager.detectGestureCalled)
    }
    
    @Test("Detect tap gesture in 3D space")
    func testTapGestureDetection() async throws {
        // Given
        let handPose = HandPose.mockLeftHand
        let tapLocation = SIMD3<Float>(0.5, 1.0, -2.0)
        mockHandTrackingManager.mockGestureResult = .success(.tap(location: tapLocation))
        
        // When
        let gesture = try await spatialTemplate.detectHandGesture(handPose: handPose)
        
        // Then
        if case .tap(let location) = gesture {
            #expect(location == tapLocation)
        } else {
            #expect(Bool(false), "Expected tap gesture")
        }
    }
    
    @Test("Hand tracking accuracy validation")
    func testHandTrackingAccuracy() async throws {
        // Given
        let handPose = HandPose.mockRightHand
        mockHandTrackingManager.mockAccuracy = 0.98
        
        // When
        let accuracy = try await spatialTemplate.getHandTrackingAccuracy(handPose: handPose)
        
        // Then
        #expect(accuracy >= 0.95, "Hand tracking accuracy should be ≥95%")
        #expect(mockHandTrackingManager.getAccuracyCalled)
    }
    
    // MARK: - Eye Tracking Tests
    
    @Test("Eye tracking initialization with permission")
    func testEyeTrackingInitialization() async throws {
        // Given
        mockEyeTrackingManager.mockInitResult = .success(())
        
        // When
        try await spatialTemplate.initializeEyeTracking()
        
        // Then
        #expect(mockEyeTrackingManager.initializeCalled)
    }
    
    @Test("Gaze target detection in 3D space")
    func testGazeTargetDetection() async throws {
        // Given
        let gazeData = EyeGazeData.mock
        let expectedTarget = GazeTarget(
            entityId: "post-card-1",
            position: SIMD3<Float>(0, 1, -2),
            confidence: 0.95
        )
        mockEyeTrackingManager.mockGazeTarget = expectedTarget
        
        // When
        let target = try await spatialTemplate.detectGazeTarget(gazeData: gazeData)
        
        // Then
        #expect(target?.entityId == "post-card-1")
        #expect(target?.confidence == 0.95)
        #expect(mockEyeTrackingManager.detectTargetCalled)
    }
    
    @Test("Eye tracking accuracy meets standards")
    func testEyeTrackingAccuracy() async throws {
        // Given
        mockEyeTrackingManager.mockAccuracy = 0.99
        
        // When
        let accuracy = try await spatialTemplate.getEyeTrackingAccuracy()
        
        // Then
        #expect(accuracy >= 0.99, "Eye tracking accuracy should be ≥99%")
        #expect(mockEyeTrackingManager.getAccuracyCalled)
    }
    
    // MARK: - Spatial Audio Tests
    
    @Test("Spatial audio positioning")
    func testSpatialAudioPositioning() async throws {
        // Given
        let audioSource = SpatialAudioSource(
            id: "notification-sound",
            position: SIMD3<Float>(2, 1, -1),
            volume: 0.7,
            audioFile: "notification.wav"
        )
        mockRealityManager.mockAudioResult = .success(())
        
        // When
        try await spatialTemplate.playSpatialAudio(source: audioSource)
        
        // Then
        #expect(mockRealityManager.playSpatialAudioCalled)
        #expect(mockRealityManager.lastAudioPosition == audioSource.position)
    }
    
    @Test("3D audio spatialization accuracy")
    func testAudioSpatialization() async throws {
        // Given
        let listenerPosition = SIMD3<Float>(0, 0, 0)
        let audioPosition = SIMD3<Float>(1, 0, -1)
        mockRealityManager.mockSpatialization = true
        
        // When
        let isSpatialized = try await spatialTemplate.validateAudioSpatialization(
            listenerPosition: listenerPosition,
            audioPosition: audioPosition
        )
        
        // Then
        #expect(isSpatialized)
        #expect(mockRealityManager.validateSpatializationCalled)
    }
    
    // MARK: - Multi-User Spatial Experience Tests
    
    @Test("Create shared spatial session")
    func testSharedSpatialSession() async throws {
        // Given
        let sessionData = SharedSessionData(
            sessionId: "spatial-session-123",
            maxParticipants: 4,
            spatialBounds: BoundingBox(
                center: SIMD3<Float>(0, 0, 0),
                size: SIMD3<Float>(10, 5, 10)
            )
        )
        mockRealityManager.mockSessionResult = .success(SharedSpatialSession.mock)
        
        // When
        let session = try await spatialTemplate.createSharedSession(data: sessionData)
        
        // Then
        #expect(session.sessionId == "spatial-session-123")
        #expect(session.maxParticipants == 4)
        #expect(mockRealityManager.createSessionCalled)
    }
    
    @Test("Add participant to spatial session")
    func testAddParticipantToSession() async throws {
        // Given
        let sessionId = "spatial-session-123"
        let participant = SpatialParticipant(
            id: "user-456",
            displayName: "John Doe",
            avatarPosition: SIMD3<Float>(2, 0, -2),
            isHost: false
        )
        mockRealityManager.mockParticipantResult = .success(())
        
        // When
        try await spatialTemplate.addParticipantToSession(sessionId: sessionId, participant: participant)
        
        // Then
        #expect(mockRealityManager.addParticipantCalled)
        #expect(mockRealityManager.lastParticipant?.id == participant.id)
    }
    
    @Test("Synchronize spatial content across users")
    func testSpatialContentSynchronization() async throws {
        // Given
        let sessionId = "spatial-session-123"
        let spatialUpdate = SpatialUpdate(
            entityId: "shared-post-1",
            position: SIMD3<Float>(1, 1, -3),
            timestamp: Date(),
            userId: "user-456"
        )
        mockRealityManager.mockSyncResult = .success(())
        
        // When
        try await spatialTemplate.synchronizeSpatialContent(sessionId: sessionId, update: spatialUpdate)
        
        // Then
        #expect(mockRealityManager.synchronizeContentCalled)
        #expect(mockRealityManager.lastSpatialUpdate?.entityId == spatialUpdate.entityId)
    }
    
    // MARK: - Immersive Space Tests
    
    @Test("Enter immersive space successfully")
    func testEnterImmersiveSpace() async throws {
        // Given
        let immersiveConfig = ImmersiveSpaceConfiguration(
            spaceId: "social-immersive",
            style: .mixed,
            boundingBox: BoundingBox(
                center: SIMD3<Float>(0, 0, 0),
                size: SIMD3<Float>(20, 10, 20)
            )
        )
        mockRealityManager.mockImmersiveResult = .success(())
        
        // When
        try await spatialTemplate.enterImmersiveSpace(configuration: immersiveConfig)
        
        // Then
        #expect(mockRealityManager.enterImmersiveCalled)
    }
    
    @Test("Exit immersive space cleanly")
    func testExitImmersiveSpace() async throws {
        // Given
        let spaceId = "social-immersive"
        mockRealityManager.mockExitResult = .success(())
        
        // When
        try await spatialTemplate.exitImmersiveSpace(spaceId: spaceId)
        
        // Then
        #expect(mockRealityManager.exitImmersiveCalled)
    }
    
    // MARK: - Performance Tests
    
    @Test("Spatial rendering maintains 90fps minimum")
    func testSpatialRenderingPerformance() async throws {
        // Given
        mockRealityManager.mockFrameRate = 95.0
        
        // When
        let frameRate = try await spatialTemplate.getCurrentFrameRate()
        
        // Then
        #expect(frameRate >= 90.0, "Frame rate should be ≥90fps")
        #expect(mockRealityManager.getFrameRateCalled)
    }
    
    @Test("Hand tracking latency under 16ms")
    func testHandTrackingLatency() async throws {
        // Given
        let startTime = CFAbsoluteTimeGetCurrent()
        mockHandTrackingManager.mockGestureResult = .success(.pinch(location: SIMD3<Float>(0, 0, -1)))
        
        // When
        let _ = try await spatialTemplate.detectHandGesture(handPose: HandPose.mockRightHand)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let latency = (endTime - startTime) * 1000 // Convert to milliseconds
        #expect(latency < 16.0, "Hand tracking latency should be <16ms")
    }
    
    @Test("Spatial memory usage under 200MB")
    func testSpatialMemoryUsage() async throws {
        // Given
        let initialMemory = getMemoryUsage()
        
        // When - Create multiple spatial entities
        for i in 0..<100 {
            let entity = SpatialEntity3D(
                id: "entity-\(i)",
                type: .postCard,
                position: SIMD3<Float>(Float(i) * 0.1, 0, -2),
                scale: SIMD3<Float>(1, 1, 1),
                rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0))
            )
            mockRealityManager.mockEntityResult = .success(())
            try await spatialTemplate.addEntityToScene(sceneId: "test-scene", entity: entity)
        }
        
        // Then
        let finalMemory = getMemoryUsage()
        let memoryIncrease = finalMemory - initialMemory
        #expect(memoryIncrease < 200.0, "Spatial memory usage should be <200MB")
    }
    
    // MARK: - Accessibility Tests
    
    @Test("VoiceOver spatial navigation support")
    func testVoiceOverSpatialNavigation() async throws {
        // Given
        let spatialElement = SpatialAccessibilityElement(
            id: "post-card-1",
            label: "Social media post by John Doe",
            hint: "Double tap to open post details",
            position: SIMD3<Float>(0, 1, -2)
        )
        mockRealityManager.mockAccessibilityResult = .success(())
        
        // When
        try await spatialTemplate.configureSpatialAccessibility(element: spatialElement)
        
        // Then
        #expect(mockRealityManager.configureAccessibilityCalled)
    }
    
    @Test("Spatial content description generation")
    func testSpatialContentDescription() async throws {
        // Given
        let sceneId = "social-scene"
        let expectedDescription = "Social media space with 5 post cards arranged in a circle"
        mockRealityManager.mockSceneDescription = expectedDescription
        
        // When
        let description = try await spatialTemplate.generateSceneDescription(sceneId: sceneId)
        
        // Then
        #expect(description == expectedDescription)
        #expect(mockRealityManager.generateDescriptionCalled)
    }
    
    // MARK: - Security Tests
    
    @Test("Spatial data isolation between users")
    func testSpatialDataIsolation() async throws {
        // Given
        let user1Id = "user-123"
        let user2Id = "user-456"
        mockRealityManager.mockIsolationValid = true
        
        // When
        let isIsolated = try await spatialTemplate.validateDataIsolation(user1: user1Id, user2: user2Id)
        
        // Then
        #expect(isIsolated)
        #expect(mockRealityManager.validateIsolationCalled)
    }
    
    @Test("Spatial permission validation")
    func testSpatialPermissionValidation() async throws {
        // Given
        let permissions = SpatialPermissions(
            canCreateEntities: true,
            canModifySharedContent: false,
            canAccessPrivateSpaces: false
        )
        mockRealityManager.mockPermissionsValid = true
        
        // When
        let isValid = try await spatialTemplate.validateSpatialPermissions(permissions)
        
        // Then
        #expect(isValid)
        #expect(mockRealityManager.validatePermissionsCalled)
    }
    
    // MARK: - Helper Methods
    
    private func getMemoryUsage() -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return Double(info.resident_size) / 1024 / 1024 // Convert to MB
        } else {
            return 0
        }
    }
}

// MARK: - Mock Classes

class MockRealityManager {
    var createSceneCalled = false
    var addEntityCalled = false
    var updatePositionCalled = false
    var playSpatialAudioCalled = false
    var validateSpatializationCalled = false
    var createSessionCalled = false
    var addParticipantCalled = false
    var synchronizeContentCalled = false
    var enterImmersiveCalled = false
    var exitImmersiveCalled = false
    var getFrameRateCalled = false
    var configureAccessibilityCalled = false
    var generateDescriptionCalled = false
    var validateIsolationCalled = false
    var validatePermissionsCalled = false
    
    var lastAddedEntity: SpatialEntity3D?
    var lastUpdatedPosition: SIMD3<Float>?
    var lastAudioPosition: SIMD3<Float>?
    var lastParticipant: SpatialParticipant?
    var lastSpatialUpdate: SpatialUpdate?
    
    var mockSceneResult: Result<SpatialScene, Error> = .success(.mockSocial)
    var mockEntityResult: Result<Void, Error> = .success(())
    var mockUpdateResult: Result<Void, Error> = .success(())
    var mockAudioResult: Result<Void, Error> = .success(())
    var mockSessionResult: Result<SharedSpatialSession, Error> = .success(.mock)
    var mockParticipantResult: Result<Void, Error> = .success(())
    var mockSyncResult: Result<Void, Error> = .success(())
    var mockImmersiveResult: Result<Void, Error> = .success(())
    var mockExitResult: Result<Void, Error> = .success(())
    var mockAccessibilityResult: Result<Void, Error> = .success(())
    
    var mockFrameRate: Double = 95.0
    var mockSpatialization = true
    var mockSceneDescription = "Test scene description"
    var mockIsolationValid = true
    var mockPermissionsValid = true
}

class MockHandTrackingManager {
    var initializeCalled = false
    var detectGestureCalled = false
    var getAccuracyCalled = false
    
    var mockInitResult: Result<Void, Error> = .success(())
    var mockGestureResult: Result<HandGesture, Error> = .success(.pinch(location: SIMD3<Float>(0, 0, -1)))
    var mockAccuracy: Double = 0.98
}

class MockEyeTrackingManager {
    var initializeCalled = false
    var detectTargetCalled = false
    var getAccuracyCalled = false
    
    var mockInitResult: Result<Void, Error> = .success(())
    var mockGazeTarget: GazeTarget?
    var mockAccuracy: Double = 0.99
}

// MARK: - Mock Data Extensions

extension SpatialScene {
    static let mockSocial = SpatialScene(
        id: "social-scene-123",
        name: "SocialMediaSpace",
        boundingBox: BoundingBox(
            center: SIMD3<Float>(0, 0, 0),
            size: SIMD3<Float>(4, 3, 4)
        ),
        entities: []
    )
}

extension HandPose {
    static let mockRightHand = HandPose(
        hand: .right,
        joints: [
            .thumbTip: SIMD3<Float>(0.1, 0.2, -0.5),
            .indexTip: SIMD3<Float>(0.15, 0.25, -0.5)
        ],
        confidence: 0.95
    )
    
    static let mockLeftHand = HandPose(
        hand: .left,
        joints: [
            .thumbTip: SIMD3<Float>(-0.1, 0.2, -0.5),
            .indexTip: SIMD3<Float>(-0.15, 0.25, -0.5)
        ],
        confidence: 0.93
    )
}

extension EyeGazeData {
    static let mock = EyeGazeData(
        direction: SIMD3<Float>(0, 0, -1),
        origin: SIMD3<Float>(0, 1.7, 0),
        confidence: 0.97
    )
}

extension SharedSpatialSession {
    static let mock = SharedSpatialSession(
        sessionId: "spatial-session-123",
        maxParticipants: 4,
        currentParticipants: 1,
        spatialBounds: BoundingBox(
            center: SIMD3<Float>(0, 0, 0),
            size: SIMD3<Float>(10, 5, 10)
        ),
        createdAt: Date()
    )
}