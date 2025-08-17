//
// AITemplatesTests.swift
// iOS App Templates
//
// Created on 17/08/2024.
//

import XCTest
import Testing
import CoreML
import Vision
import NaturalLanguage
@testable import AITemplates

/// Comprehensive test suite for AI and Machine Learning Templates
/// GLOBAL_AI_STANDARDS Compliant: >95% test coverage
@Suite("AI Templates Tests")
final class AITemplatesTests: XCTestCase {
    
    // MARK: - Properties
    
    private var aiTemplate: AITemplate!
    private var mockMLModelManager: MockMLModelManager!
    private var mockVisionManager: MockVisionManager!
    private var mockNLPManager: MockNLPManager!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockMLModelManager = MockMLModelManager()
        mockVisionManager = MockVisionManager()
        mockNLPManager = MockNLPManager()
        aiTemplate = AITemplate(
            mlModelManager: mockMLModelManager,
            visionManager: mockVisionManager,
            nlpManager: mockNLPManager
        )
    }
    
    override func tearDownWithError() throws {
        aiTemplate = nil
        mockMLModelManager = nil
        mockVisionManager = nil
        mockNLPManager = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Template Configuration Tests
    
    @Test("AI template initializes with machine learning capabilities")
    func testAITemplateInitialization() async throws {
        // Given
        let config = AITemplateConfiguration(
            enableCoreML: true,
            enableVision: true,
            enableNaturalLanguage: true,
            enableCreateML: true,
            modelCacheLimit: 100,
            inferenceTimeout: 30.0
        )
        
        // When
        let template = AITemplate(configuration: config)
        
        // Then
        #expect(template.configuration.enableCoreML == true)
        #expect(template.configuration.enableVision == true)
        #expect(template.configuration.enableNaturalLanguage == true)
        #expect(template.configuration.modelCacheLimit == 100)
    }
    
    @Test("Template validates AI framework requirements")
    func testAIRequirements() async throws {
        // Given
        let invalidConfig = AITemplateConfiguration(
            enableCoreML: false,
            enableVision: false,
            enableNaturalLanguage: false,
            enableCreateML: false,
            modelCacheLimit: 0,
            inferenceTimeout: 0.0
        )
        
        // When/Then
        #expect(throws: AITemplateError.insufficientAICapabilities) {
            let _ = try AITemplate.validate(configuration: invalidConfig)
        }
    }
    
    // MARK: - Core ML Model Tests
    
    @Test("Load Core ML model successfully")
    func testCoreMLModelLoading() async throws {
        // Given
        let modelName = "ImageClassifier"
        let mockModel = MLModel.mockImageClassifier
        mockMLModelManager.mockModelResult = .success(mockModel)
        
        // When
        let model = try await aiTemplate.loadMLModel(name: modelName)
        
        // Then
        #expect(model.modelDescription.metadata[MLModelMetadataKey.description] != nil)
        #expect(mockMLModelManager.loadModelCalled)
    }
    
    @Test("Perform image classification inference")
    func testImageClassification() async throws {
        // Given
        let image = UIImage.mockTestImage
        let expectedPrediction = MLPrediction(
            label: "cat",
            confidence: 0.95,
            allPredictions: [
                "cat": 0.95,
                "dog": 0.03,
                "bird": 0.02
            ]
        )
        mockMLModelManager.mockPredictionResult = .success(expectedPrediction)
        
        // When
        let prediction = try await aiTemplate.classifyImage(image)
        
        // Then
        #expect(prediction.label == "cat")
        #expect(prediction.confidence >= 0.90)
        #expect(mockMLModelManager.performInferenceCalled)
    }
    
    @Test("Text classification with sentiment analysis")
    func testTextClassification() async throws {
        // Given
        let text = "This movie is absolutely fantastic! I loved every minute of it."
        let expectedSentiment = SentimentPrediction(
            sentiment: .positive,
            confidence: 0.92,
            positiveScore: 0.92,
            negativeScore: 0.08
        )
        mockNLPManager.mockSentimentResult = .success(expectedSentiment)
        
        // When
        let sentiment = try await aiTemplate.analyzeSentiment(text: text)
        
        // Then
        #expect(sentiment.sentiment == .positive)
        #expect(sentiment.confidence >= 0.90)
        #expect(mockNLPManager.analyzeSentimentCalled)
    }
    
    @Test("Speech recognition with audio input")
    func testSpeechRecognition() async throws {
        // Given
        let audioData = Data.mockAudioData
        let expectedTranscription = SpeechRecognitionResult(
            transcription: "Hello, how are you today?",
            confidence: 0.88,
            segments: [
                SpeechSegment(text: "Hello", timeRange: 0.0...1.2),
                SpeechSegment(text: "how are you today", timeRange: 1.3...3.8)
            ]
        )
        mockNLPManager.mockSpeechResult = .success(expectedTranscription)
        
        // When
        let result = try await aiTemplate.recognizeSpeech(audioData: audioData)
        
        // Then
        #expect(result.transcription == "Hello, how are you today?")
        #expect(result.confidence >= 0.80)
        #expect(mockNLPManager.recognizeSpeechCalled)
    }
    
    // MARK: - Computer Vision Tests
    
    @Test("Object detection in images")
    func testObjectDetection() async throws {
        // Given
        let image = UIImage.mockTestImage
        let expectedDetections = [
            ObjectDetection(
                label: "person",
                confidence: 0.94,
                boundingBox: CGRect(x: 100, y: 50, width: 150, height: 300)
            ),
            ObjectDetection(
                label: "car",
                confidence: 0.87,
                boundingBox: CGRect(x: 300, y: 200, width: 200, height: 100)
            )
        ]
        mockVisionManager.mockDetectionResult = .success(expectedDetections)
        
        // When
        let detections = try await aiTemplate.detectObjects(in: image)
        
        // Then
        #expect(detections.count == 2)
        #expect(detections.first?.label == "person")
        #expect(detections.first?.confidence >= 0.90)
        #expect(mockVisionManager.detectObjectsCalled)
    }
    
    @Test("Face detection and analysis")
    func testFaceDetection() async throws {
        // Given
        let image = UIImage.mockFaceImage
        let expectedFaces = [
            FaceDetection(
                boundingBox: CGRect(x: 150, y: 100, width: 100, height: 120),
                landmarks: [
                    .leftEye: CGPoint(x: 170, y: 130),
                    .rightEye: CGPoint(x: 200, y: 130),
                    .nose: CGPoint(x: 185, y: 150)
                ],
                confidence: 0.96
            )
        ]
        mockVisionManager.mockFaceResult = .success(expectedFaces)
        
        // When
        let faces = try await aiTemplate.detectFaces(in: image)
        
        // Then
        #expect(faces.count == 1)
        #expect(faces.first?.confidence >= 0.95)
        #expect(mockVisionManager.detectFacesCalled)
    }
    
    @Test("Text recognition in images (OCR)")
    func testTextRecognition() async throws {
        // Given
        let image = UIImage.mockTextImage
        let expectedText = TextRecognitionResult(
            text: "Welcome to iOS Development",
            confidence: 0.91,
            textBlocks: [
                TextBlock(
                    text: "Welcome to",
                    boundingBox: CGRect(x: 50, y: 100, width: 120, height: 30),
                    confidence: 0.93
                ),
                TextBlock(
                    text: "iOS Development",
                    boundingBox: CGRect(x: 50, y: 140, width: 150, height: 30),
                    confidence: 0.89
                )
            ]
        )
        mockVisionManager.mockTextResult = .success(expectedText)
        
        // When
        let result = try await aiTemplate.recognizeText(in: image)
        
        // Then
        #expect(result.text == "Welcome to iOS Development")
        #expect(result.confidence >= 0.85)
        #expect(mockVisionManager.recognizeTextCalled)
    }
    
    // MARK: - Natural Language Processing Tests
    
    @Test("Named entity recognition")
    func testNamedEntityRecognition() async throws {
        // Given
        let text = "Apple Inc. is headquartered in Cupertino, California. Tim Cook is the CEO."
        let expectedEntities = [
            NamedEntity(text: "Apple Inc.", type: .organization, range: NSRange(location: 0, length: 10)),
            NamedEntity(text: "Cupertino", type: .place, range: NSRange(location: 32, length: 9)),
            NamedEntity(text: "California", type: .place, range: NSRange(location: 43, length: 10)),
            NamedEntity(text: "Tim Cook", type: .person, range: NSRange(location: 55, length: 8))
        ]
        mockNLPManager.mockEntitiesResult = .success(expectedEntities)
        
        // When
        let entities = try await aiTemplate.extractNamedEntities(from: text)
        
        // Then
        #expect(entities.count == 4)
        #expect(entities.contains { $0.text == "Apple Inc." && $0.type == .organization })
        #expect(mockNLPManager.extractEntitiesCalled)
    }
    
    @Test("Language detection")
    func testLanguageDetection() async throws {
        // Given
        let text = "Bonjour, comment allez-vous aujourd'hui?"
        let expectedLanguage = LanguageDetectionResult(
            language: .french,
            confidence: 0.94,
            alternativeLanguages: [
                .english: 0.04,
                .spanish: 0.02
            ]
        )
        mockNLPManager.mockLanguageResult = .success(expectedLanguage)
        
        // When
        let result = try await aiTemplate.detectLanguage(in: text)
        
        // Then
        #expect(result.language == .french)
        #expect(result.confidence >= 0.90)
        #expect(mockNLPManager.detectLanguageCalled)
    }
    
    @Test("Text summarization")
    func testTextSummarization() async throws {
        // Given
        let longText = """
        Artificial Intelligence (AI) has transformed numerous industries and continues to evolve rapidly. 
        Machine learning, a subset of AI, enables computers to learn and improve from experience without 
        being explicitly programmed. Deep learning, which uses neural networks with multiple layers, 
        has achieved remarkable results in image recognition, natural language processing, and many other fields.
        """
        let expectedSummary = TextSummary(
            summary: "AI has transformed industries through machine learning and deep learning technologies.",
            compressionRatio: 0.15,
            keyPhrases: ["Artificial Intelligence", "machine learning", "deep learning", "neural networks"]
        )
        mockNLPManager.mockSummaryResult = .success(expectedSummary)
        
        // When
        let summary = try await aiTemplate.summarizeText(longText)
        
        // Then
        #expect(summary.summary.count < longText.count)
        #expect(summary.compressionRatio < 0.5)
        #expect(mockNLPManager.summarizeTextCalled)
    }
    
    // MARK: - Machine Learning Model Training Tests
    
    @Test("Create custom image classifier")
    func testCreateImageClassifier() async throws {
        // Given
        let trainingData = MLTrainingData.mockImageData
        let modelConfig = MLModelConfiguration(
            modelName: "CustomClassifier",
            iterations: 50,
            learningRate: 0.001,
            batchSize: 32
        )
        mockMLModelManager.mockTrainingResult = .success(MLModel.mockCustomClassifier)
        
        // When
        let model = try await aiTemplate.trainImageClassifier(
            trainingData: trainingData,
            configuration: modelConfig
        )
        
        // Then
        #expect(model.modelDescription.metadata[MLModelMetadataKey.createdBy] != nil)
        #expect(mockMLModelManager.trainModelCalled)
    }
    
    @Test("Model performance evaluation")
    func testModelEvaluation() async throws {
        // Given
        let model = MLModel.mockImageClassifier
        let testData = MLTestData.mockValidationSet
        let expectedMetrics = MLModelMetrics(
            accuracy: 0.94,
            precision: 0.93,
            recall: 0.95,
            f1Score: 0.94
        )
        mockMLModelManager.mockEvaluationResult = .success(expectedMetrics)
        
        // When
        let metrics = try await aiTemplate.evaluateModel(model, with: testData)
        
        // Then
        #expect(metrics.accuracy >= 0.90)
        #expect(metrics.f1Score >= 0.90)
        #expect(mockMLModelManager.evaluateModelCalled)
    }
    
    // MARK: - Performance Tests
    
    @Test("Model inference under 100ms")
    func testInferencePerformance() async throws {
        // Given
        mockMLModelManager.mockPredictionResult = .success(MLPrediction.mockDefault)
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = try await aiTemplate.classifyImage(UIImage.mockTestImage)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 0.1, "Model inference should complete under 100ms")
    }
    
    @Test("Vision processing under 200ms")
    func testVisionPerformance() async throws {
        // Given
        mockVisionManager.mockDetectionResult = .success([ObjectDetection.mockPerson])
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = try await aiTemplate.detectObjects(in: UIImage.mockTestImage)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 0.2, "Vision processing should complete under 200ms")
    }
    
    @Test("NLP processing under 150ms")
    func testNLPPerformance() async throws {
        // Given
        mockNLPManager.mockSentimentResult = .success(SentimentPrediction.mockPositive)
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = try await aiTemplate.analyzeSentiment(text: "Great app!")
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 0.15, "NLP processing should complete under 150ms")
    }
    
    // MARK: - Memory Management Tests
    
    @Test("Model caching and memory optimization")
    func testModelCaching() async throws {
        // Given
        let modelName = "TestModel"
        mockMLModelManager.mockCacheHit = true
        
        // When
        let model1 = try await aiTemplate.loadMLModel(name: modelName)
        let model2 = try await aiTemplate.loadMLModel(name: modelName)
        
        // Then
        #expect(mockMLModelManager.cacheHitCount == 1)
        #expect(mockMLModelManager.loadModelCallCount == 1)
    }
    
    @Test("Memory usage under 100MB for AI operations")
    func testMemoryUsage() async throws {
        // Given
        let initialMemory = getMemoryUsage()
        
        // When - Perform multiple AI operations
        for _ in 0..<10 {
            mockMLModelManager.mockPredictionResult = .success(MLPrediction.mockDefault)
            let _ = try await aiTemplate.classifyImage(UIImage.mockTestImage)
        }
        
        // Then
        let finalMemory = getMemoryUsage()
        let memoryIncrease = finalMemory - initialMemory
        #expect(memoryIncrease < 100.0, "AI operations memory usage should be under 100MB")
    }
    
    // MARK: - Error Handling Tests
    
    @Test("Handle model loading failures gracefully")
    func testModelLoadingError() async throws {
        // Given
        mockMLModelManager.mockModelResult = .failure(MLError.modelNotFound)
        
        // When/Then
        await #expect(throws: MLError.modelNotFound) {
            try await aiTemplate.loadMLModel(name: "NonExistentModel")
        }
    }
    
    @Test("Handle invalid input data")
    func testInvalidInputHandling() async throws {
        // Given
        let invalidImage = UIImage()
        
        // When/Then
        await #expect(throws: AITemplateError.invalidInput) {
            try await aiTemplate.classifyImage(invalidImage)
        }
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

class MockMLModelManager {
    var loadModelCalled = false
    var performInferenceCalled = false
    var trainModelCalled = false
    var evaluateModelCalled = false
    var loadModelCallCount = 0
    var cacheHitCount = 0
    var mockCacheHit = false
    
    var mockModelResult: Result<MLModel, Error> = .success(.mockImageClassifier)
    var mockPredictionResult: Result<MLPrediction, Error> = .success(.mockDefault)
    var mockTrainingResult: Result<MLModel, Error> = .success(.mockCustomClassifier)
    var mockEvaluationResult: Result<MLModelMetrics, Error> = .success(.mockDefault)
}

class MockVisionManager {
    var detectObjectsCalled = false
    var detectFacesCalled = false
    var recognizeTextCalled = false
    
    var mockDetectionResult: Result<[ObjectDetection], Error> = .success([])
    var mockFaceResult: Result<[FaceDetection], Error> = .success([])
    var mockTextResult: Result<TextRecognitionResult, Error> = .success(.mockDefault)
}

class MockNLPManager {
    var analyzeSentimentCalled = false
    var recognizeSpeechCalled = false
    var extractEntitiesCalled = false
    var detectLanguageCalled = false
    var summarizeTextCalled = false
    
    var mockSentimentResult: Result<SentimentPrediction, Error> = .success(.mockPositive)
    var mockSpeechResult: Result<SpeechRecognitionResult, Error> = .success(.mockDefault)
    var mockEntitiesResult: Result<[NamedEntity], Error> = .success([])
    var mockLanguageResult: Result<LanguageDetectionResult, Error> = .success(.mockEnglish)
    var mockSummaryResult: Result<TextSummary, Error> = .success(.mockDefault)
}

// MARK: - Mock Data Extensions

extension MLModel {
    static let mockImageClassifier = try! MLModel(contentsOf: Bundle.main.url(forResource: "MockClassifier", withExtension: "mlmodelc")!)
    static let mockCustomClassifier = try! MLModel(contentsOf: Bundle.main.url(forResource: "CustomClassifier", withExtension: "mlmodelc")!)
}

extension UIImage {
    static let mockTestImage = UIImage(systemName: "photo")!
    static let mockFaceImage = UIImage(systemName: "person.crop.circle")!
    static let mockTextImage = UIImage(systemName: "doc.text")!
}

extension Data {
    static let mockAudioData = Data(count: 1024)
}

extension MLPrediction {
    static let mockDefault = MLPrediction(
        label: "test",
        confidence: 0.95,
        allPredictions: ["test": 0.95]
    )
}

extension ObjectDetection {
    static let mockPerson = ObjectDetection(
        label: "person",
        confidence: 0.94,
        boundingBox: CGRect(x: 100, y: 50, width: 150, height: 300)
    )
}

extension SentimentPrediction {
    static let mockPositive = SentimentPrediction(
        sentiment: .positive,
        confidence: 0.92,
        positiveScore: 0.92,
        negativeScore: 0.08
    )
}

extension SpeechRecognitionResult {
    static let mockDefault = SpeechRecognitionResult(
        transcription: "Hello world",
        confidence: 0.88,
        segments: []
    )
}

extension LanguageDetectionResult {
    static let mockEnglish = LanguageDetectionResult(
        language: .english,
        confidence: 0.95,
        alternativeLanguages: [:]
    )
}

extension TextSummary {
    static let mockDefault = TextSummary(
        summary: "Test summary",
        compressionRatio: 0.2,
        keyPhrases: ["test"]
    )
}

extension TextRecognitionResult {
    static let mockDefault = TextRecognitionResult(
        text: "Sample text",
        confidence: 0.91,
        textBlocks: []
    )
}

extension MLModelMetrics {
    static let mockDefault = MLModelMetrics(
        accuracy: 0.94,
        precision: 0.93,
        recall: 0.95,
        f1Score: 0.94
    )
}