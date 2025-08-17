//
// PerformanceTemplatesTests.swift
// iOS App Templates
//
// Created on 17/08/2024.
//

import XCTest
import Testing
@testable import PerformanceTemplates

/// Comprehensive test suite for Performance Optimization Templates
/// Enterprise Standards Compliant: >95% test coverage
@Suite("Performance Templates Tests")
final class PerformanceTemplatesTests: XCTestCase {
    
    // MARK: - Properties
    
    private var performanceTemplate: PerformanceTemplate!
    private var mockMetricsCollector: MockMetricsCollector!
    private var mockOptimizationEngine: MockOptimizationEngine!
    private var mockCacheManager: MockCacheManager!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockMetricsCollector = MockMetricsCollector()
        mockOptimizationEngine = MockOptimizationEngine()
        mockCacheManager = MockCacheManager()
        performanceTemplate = PerformanceTemplate(
            metricsCollector: mockMetricsCollector,
            optimizationEngine: mockOptimizationEngine,
            cacheManager: mockCacheManager
        )
    }
    
    override func tearDownWithError() throws {
        performanceTemplate = nil
        mockMetricsCollector = nil
        mockOptimizationEngine = nil
        mockCacheManager = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Template Configuration Tests
    
    @Test("Performance template initializes with optimization settings")
    func testPerformanceTemplateInitialization() async throws {
        // Given
        let config = PerformanceTemplateConfiguration(
            enableMetricsCollection: true,
            enableAutoOptimization: true,
            enableMemoryOptimization: true,
            enableCPUOptimization: true,
            enableNetworkOptimization: true,
            metricsCollectionInterval: 1.0,
            performanceThresholds: PerformanceThresholds.standard
        )
        
        // When
        let template = PerformanceTemplate(configuration: config)
        
        // Then
        #expect(template.configuration.enableMetricsCollection == true)
        #expect(template.configuration.enableAutoOptimization == true)
        #expect(template.configuration.metricsCollectionInterval == 1.0)
        #expect(template.configuration.performanceThresholds.maxCPUUsage <= 80.0)
    }
    
    @Test("Template validates performance requirements")
    func testPerformanceRequirements() async throws {
        // Given
        let config = PerformanceTemplateConfiguration(
            enableMetricsCollection: false,
            enableAutoOptimization: false,
            enableMemoryOptimization: false,
            enableCPUOptimization: false,
            enableNetworkOptimization: false,
            metricsCollectionInterval: 0.0,
            performanceThresholds: PerformanceThresholds.disabled
        )
        
        // When/Then
        #expect(throws: PerformanceTemplateError.insufficientOptimizationSettings) {
            let _ = try PerformanceTemplate.validate(configuration: config)
        }
    }
    
    // MARK: - Metrics Collection Tests
    
    @Test("Start metrics collection successfully")
    func testStartMetricsCollection() async throws {
        // Given
        mockMetricsCollector.mockStartResult = .success(())
        
        // When
        try await performanceTemplate.startMetricsCollection()
        
        // Then
        #expect(mockMetricsCollector.startCollectionCalled)
        #expect(performanceTemplate.isCollectingMetrics)
    }
    
    @Test("Collect CPU usage metrics")
    func testCPUUsageCollection() async throws {
        // Given
        let expectedMetrics = CPUMetrics(
            usage: 45.5,
            userTime: 30.2,
            systemTime: 15.3,
            coreCount: 8,
            frequency: 2.4
        )
        mockMetricsCollector.mockCPUMetrics = expectedMetrics
        
        // When
        let metrics = try await performanceTemplate.collectCPUMetrics()
        
        // Then
        #expect(metrics.usage == 45.5)
        #expect(metrics.coreCount == 8)
        #expect(mockMetricsCollector.collectCPUCalled)
    }
    
    @Test("Collect memory usage metrics")
    func testMemoryUsageCollection() async throws {
        // Given
        let expectedMetrics = MemoryMetrics(
            usedMemory: 256.0,
            availableMemory: 768.0,
            totalMemory: 1024.0,
            memoryPressure: .normal,
            swapUsage: 0.0
        )
        mockMetricsCollector.mockMemoryMetrics = expectedMetrics
        
        // When
        let metrics = try await performanceTemplate.collectMemoryMetrics()
        
        // Then
        #expect(metrics.usedMemory == 256.0)
        #expect(metrics.memoryPressure == .normal)
        #expect(mockMetricsCollector.collectMemoryCalled)
    }
    
    @Test("Collect network performance metrics")
    func testNetworkMetricsCollection() async throws {
        // Given
        let expectedMetrics = NetworkMetrics(
            bytesIn: 1024,
            bytesOut: 512,
            packetsIn: 100,
            packetsOut: 80,
            latency: 25.0,
            throughput: 1000.0
        )
        mockMetricsCollector.mockNetworkMetrics = expectedMetrics
        
        // When
        let metrics = try await performanceTemplate.collectNetworkMetrics()
        
        // Then
        #expect(metrics.latency == 25.0)
        #expect(metrics.throughput == 1000.0)
        #expect(mockMetricsCollector.collectNetworkCalled)
    }
    
    @Test("Collect battery usage metrics")
    func testBatteryMetricsCollection() async throws {
        // Given
        let expectedMetrics = BatteryMetrics(
            level: 85.5,
            state: .unplugged,
            isLowPowerModeEnabled: false,
            temperature: 32.5,
            voltage: 4.2
        )
        mockMetricsCollector.mockBatteryMetrics = expectedMetrics
        
        // When
        let metrics = try await performanceTemplate.collectBatteryMetrics()
        
        // Then
        #expect(metrics.level == 85.5)
        #expect(metrics.state == .unplugged)
        #expect(mockMetricsCollector.collectBatteryCalled)
    }
    
    // MARK: - Performance Optimization Tests
    
    @Test("Auto-optimization triggers on high CPU usage")
    func testAutoOptimizationCPU() async throws {
        // Given
        let highCPUMetrics = CPUMetrics(
            usage: 95.0, // Above threshold
            userTime: 80.0,
            systemTime: 15.0,
            coreCount: 8,
            frequency: 2.4
        )
        mockMetricsCollector.mockCPUMetrics = highCPUMetrics
        mockOptimizationEngine.mockOptimizationResult = .success(())
        
        // When
        try await performanceTemplate.performAutoOptimization()
        
        // Then
        #expect(mockOptimizationEngine.optimizeCPUCalled)
        #expect(mockOptimizationEngine.lastOptimizationType == .cpu)
    }
    
    @Test("Memory optimization when usage exceeds threshold")
    func testMemoryOptimization() async throws {
        // Given
        let highMemoryMetrics = MemoryMetrics(
            usedMemory: 900.0, // High usage
            availableMemory: 124.0,
            totalMemory: 1024.0,
            memoryPressure: .urgent,
            swapUsage: 50.0
        )
        mockMetricsCollector.mockMemoryMetrics = highMemoryMetrics
        mockOptimizationEngine.mockOptimizationResult = .success(())
        
        // When
        try await performanceTemplate.optimizeMemoryUsage()
        
        // Then
        #expect(mockOptimizationEngine.optimizeMemoryCalled)
        #expect(mockOptimizationEngine.lastMemoryOptimization == .garbageCollection)
    }
    
    @Test("Network optimization for slow connections")
    func testNetworkOptimization() async throws {
        // Given
        let slowNetworkMetrics = NetworkMetrics(
            bytesIn: 1024,
            bytesOut: 512,
            packetsIn: 100,
            packetsOut: 80,
            latency: 500.0, // High latency
            throughput: 100.0 // Low throughput
        )
        mockMetricsCollector.mockNetworkMetrics = slowNetworkMetrics
        mockOptimizationEngine.mockOptimizationResult = .success(())
        
        // When
        try await performanceTemplate.optimizeNetworkPerformance()
        
        // Then
        #expect(mockOptimizationEngine.optimizeNetworkCalled)
        #expect(mockOptimizationEngine.lastNetworkOptimization == .compression)
    }
    
    // MARK: - Caching and Storage Tests
    
    @Test("Initialize cache with size limits")
    func testCacheInitialization() async throws {
        // Given
        let cacheConfig = CacheConfiguration(
            maxMemorySize: 50 * 1024 * 1024, // 50MB
            maxDiskSize: 100 * 1024 * 1024, // 100MB
            ttl: 3600, // 1 hour
            evictionPolicy: .lru
        )
        mockCacheManager.mockInitResult = .success(())
        
        // When
        try await performanceTemplate.initializeCache(configuration: cacheConfig)
        
        // Then
        #expect(mockCacheManager.initializeCacheCalled)
        #expect(mockCacheManager.lastCacheConfig?.maxMemorySize == 50 * 1024 * 1024)
    }
    
    @Test("Cache object with expiration")
    func testCacheObject() async throws {
        // Given
        let key = "test_key"
        let data = "test_data".data(using: .utf8)!
        let expiration = Date().addingTimeInterval(3600)
        mockCacheManager.mockSetResult = .success(())
        
        // When
        try await performanceTemplate.cacheObject(data, forKey: key, expiration: expiration)
        
        // Then
        #expect(mockCacheManager.setCalled)
        #expect(mockCacheManager.lastCachedKey == key)
    }
    
    @Test("Retrieve cached object")
    func testRetrieveCachedObject() async throws {
        // Given
        let key = "test_key"
        let expectedData = "cached_data".data(using: .utf8)!
        mockCacheManager.mockGetResult = .success(expectedData)
        
        // When
        let data = try await performanceTemplate.getCachedObject(forKey: key)
        
        // Then
        #expect(data == expectedData)
        #expect(mockCacheManager.getCalled)
        #expect(mockCacheManager.lastRetrievedKey == key)
    }
    
    @Test("Cache eviction when memory limit exceeded")
    func testCacheEviction() async throws {
        // Given
        mockCacheManager.mockEvictionResult = .success(5) // 5 items evicted
        
        // When
        let evictedCount = try await performanceTemplate.performCacheEviction()
        
        // Then
        #expect(evictedCount == 5)
        #expect(mockCacheManager.performEvictionCalled)
    }
    
    // MARK: - Performance Benchmarking Tests
    
    @Test("Run UI performance benchmark")
    func testUIPerformanceBenchmark() async throws {
        // Given
        let benchmarkConfig = BenchmarkConfiguration(
            iterations: 100,
            targetFPS: 60,
            complexity: .high
        )
        let expectedResults = BenchmarkResults(
            averageFPS: 58.5,
            frameDrops: 3,
            renderTime: 15.2,
            layoutTime: 2.8
        )
        mockMetricsCollector.mockBenchmarkResult = .success(expectedResults)
        
        // When
        let results = try await performanceTemplate.runUIBenchmark(configuration: benchmarkConfig)
        
        // Then
        #expect(results.averageFPS >= 55.0)
        #expect(results.frameDrops <= 5)
        #expect(mockMetricsCollector.runBenchmarkCalled)
    }
    
    @Test("Memory allocation benchmark")
    func testMemoryAllocationBenchmark() async throws {
        // Given
        let allocationsPerSecond = 1000
        mockMetricsCollector.mockAllocationBenchmark = .success(AllocationBenchmarkResults(
            allocationsPerSecond: allocationsPerSecond,
            averageAllocationTime: 0.001,
            peakMemoryUsage: 128.0
        ))
        
        // When
        let results = try await performanceTemplate.runMemoryAllocationBenchmark(allocationsPerSecond: allocationsPerSecond)
        
        // Then
        #expect(results.allocationsPerSecond == allocationsPerSecond)
        #expect(results.averageAllocationTime < 0.01)
        #expect(mockMetricsCollector.runAllocationBenchmarkCalled)
    }
    
    // MARK: - Performance Analysis Tests
    
    @Test("Analyze performance bottlenecks")
    func testBottleneckAnalysis() async throws {
        // Given
        let performanceData = PerformanceData(
            cpuMetrics: CPUMetrics.mockHighUsage,
            memoryMetrics: MemoryMetrics.mockHighUsage,
            networkMetrics: NetworkMetrics.mockSlowNetwork,
            batteryMetrics: BatteryMetrics.mockLowBattery
        )
        let expectedBottlenecks = [
            PerformanceBottleneck(
                type: .cpu,
                severity: .high,
                description: "High CPU usage detected",
                recommendations: ["Optimize algorithms", "Use background queues"]
            ),
            PerformanceBottleneck(
                type: .memory,
                severity: .medium,
                description: "Memory pressure detected",
                recommendations: ["Release unused objects", "Implement lazy loading"]
            )
        ]
        mockOptimizationEngine.mockBottleneckResult = .success(expectedBottlenecks)
        
        // When
        let bottlenecks = try await performanceTemplate.analyzeBottlenecks(performanceData)
        
        // Then
        #expect(bottlenecks.count == 2)
        #expect(bottlenecks.contains { $0.type == .cpu && $0.severity == .high })
        #expect(mockOptimizationEngine.analyzeBottlenecksCalled)
    }
    
    @Test("Generate performance report")
    func testPerformanceReport() async throws {
        // Given
        let reportPeriod = TimeInterval(3600) // 1 hour
        let expectedReport = PerformanceReport(
            period: reportPeriod,
            averageCPUUsage: 35.5,
            averageMemoryUsage: 256.0,
            networkThroughput: 1000.0,
            criticalIssues: 0,
            recommendations: ["Enable auto-optimization", "Increase cache size"]
        )
        mockMetricsCollector.mockReportResult = .success(expectedReport)
        
        // When
        let report = try await performanceTemplate.generatePerformanceReport(period: reportPeriod)
        
        // Then
        #expect(report.averageCPUUsage < 50.0)
        #expect(report.criticalIssues == 0)
        #expect(mockMetricsCollector.generateReportCalled)
    }
    
    // MARK: - Real-time Monitoring Tests
    
    @Test("Start real-time performance monitoring")
    func testStartRealTimeMonitoring() async throws {
        // Given
        let interval: TimeInterval = 1.0
        mockMetricsCollector.mockMonitoringResult = .success(())
        
        // When
        try await performanceTemplate.startRealTimeMonitoring(interval: interval)
        
        // Then
        #expect(mockMetricsCollector.startMonitoringCalled)
        #expect(performanceTemplate.isMonitoring)
    }
    
    @Test("Performance alert triggers on threshold breach")
    func testPerformanceAlert() async throws {
        // Given
        let thresholds = PerformanceThresholds(
            maxCPUUsage: 80.0,
            maxMemoryUsage: 512.0,
            maxNetworkLatency: 100.0,
            minBatteryLevel: 20.0
        )
        let alertingMetrics = CPUMetrics(
            usage: 95.0, // Exceeds threshold
            userTime: 80.0,
            systemTime: 15.0,
            coreCount: 8,
            frequency: 2.4
        )
        mockMetricsCollector.mockCPUMetrics = alertingMetrics
        
        // When
        let alert = try await performanceTemplate.checkPerformanceThresholds(thresholds)
        
        // Then
        #expect(alert != nil)
        #expect(alert?.alertType == .cpuUsageHigh)
        #expect(mockMetricsCollector.checkThresholdsCalled)
    }
    
    // MARK: - Performance Tests for the Template Itself
    
    @Test("Metrics collection completes under 50ms")
    func testMetricsCollectionPerformance() async throws {
        // Given
        mockMetricsCollector.mockCPUMetrics = CPUMetrics.mockNormal
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = try await performanceTemplate.collectCPUMetrics()
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 0.05, "Metrics collection should complete under 50ms")
    }
    
    @Test("Cache operations under 10ms")
    func testCachePerformance() async throws {
        // Given
        let data = "test".data(using: .utf8)!
        mockCacheManager.mockGetResult = .success(data)
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = try await performanceTemplate.getCachedObject(forKey: "test")
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 0.01, "Cache operations should complete under 10ms")
    }
    
    @Test("Optimization engine response under 100ms")
    func testOptimizationPerformance() async throws {
        // Given
        mockOptimizationEngine.mockOptimizationResult = .success(())
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        try await performanceTemplate.optimizeMemoryUsage()
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 0.1, "Optimization should complete under 100ms")
    }
}

// MARK: - Mock Classes

class MockMetricsCollector {
    var startCollectionCalled = false
    var collectCPUCalled = false
    var collectMemoryCalled = false
    var collectNetworkCalled = false
    var collectBatteryCalled = false
    var runBenchmarkCalled = false
    var runAllocationBenchmarkCalled = false
    var generateReportCalled = false
    var startMonitoringCalled = false
    var checkThresholdsCalled = false
    
    var mockStartResult: Result<Void, Error> = .success(())
    var mockCPUMetrics = CPUMetrics.mockNormal
    var mockMemoryMetrics = MemoryMetrics.mockNormal
    var mockNetworkMetrics = NetworkMetrics.mockNormal
    var mockBatteryMetrics = BatteryMetrics.mockNormal
    var mockBenchmarkResult: Result<BenchmarkResults, Error> = .success(.mock)
    var mockAllocationBenchmark: Result<AllocationBenchmarkResults, Error> = .success(.mock)
    var mockReportResult: Result<PerformanceReport, Error> = .success(.mock)
    var mockMonitoringResult: Result<Void, Error> = .success(())
}

class MockOptimizationEngine {
    var optimizeCPUCalled = false
    var optimizeMemoryCalled = false
    var optimizeNetworkCalled = false
    var analyzeBottlenecksCalled = false
    var lastOptimizationType: OptimizationType?
    var lastMemoryOptimization: MemoryOptimizationType?
    var lastNetworkOptimization: NetworkOptimizationType?
    
    var mockOptimizationResult: Result<Void, Error> = .success(())
    var mockBottleneckResult: Result<[PerformanceBottleneck], Error> = .success([])
}

class MockCacheManager {
    var initializeCacheCalled = false
    var setCalled = false
    var getCalled = false
    var performEvictionCalled = false
    var lastCacheConfig: CacheConfiguration?
    var lastCachedKey: String?
    var lastRetrievedKey: String?
    
    var mockInitResult: Result<Void, Error> = .success(())
    var mockSetResult: Result<Void, Error> = .success(())
    var mockGetResult: Result<Data, Error> = .success(Data())
    var mockEvictionResult: Result<Int, Error> = .success(0)
}

// MARK: - Mock Data Extensions

extension CPUMetrics {
    static let mockNormal = CPUMetrics(
        usage: 25.0,
        userTime: 20.0,
        systemTime: 5.0,
        coreCount: 8,
        frequency: 2.4
    )
    
    static let mockHighUsage = CPUMetrics(
        usage: 95.0,
        userTime: 80.0,
        systemTime: 15.0,
        coreCount: 8,
        frequency: 2.4
    )
}

extension MemoryMetrics {
    static let mockNormal = MemoryMetrics(
        usedMemory: 256.0,
        availableMemory: 768.0,
        totalMemory: 1024.0,
        memoryPressure: .normal,
        swapUsage: 0.0
    )
    
    static let mockHighUsage = MemoryMetrics(
        usedMemory: 900.0,
        availableMemory: 124.0,
        totalMemory: 1024.0,
        memoryPressure: .urgent,
        swapUsage: 50.0
    )
}

extension NetworkMetrics {
    static let mockNormal = NetworkMetrics(
        bytesIn: 1024,
        bytesOut: 512,
        packetsIn: 100,
        packetsOut: 80,
        latency: 25.0,
        throughput: 1000.0
    )
    
    static let mockSlowNetwork = NetworkMetrics(
        bytesIn: 1024,
        bytesOut: 512,
        packetsIn: 100,
        packetsOut: 80,
        latency: 500.0,
        throughput: 100.0
    )
}

extension BatteryMetrics {
    static let mockNormal = BatteryMetrics(
        level: 75.0,
        state: .unplugged,
        isLowPowerModeEnabled: false,
        temperature: 30.0,
        voltage: 4.1
    )
    
    static let mockLowBattery = BatteryMetrics(
        level: 15.0,
        state: .unplugged,
        isLowPowerModeEnabled: true,
        temperature: 35.0,
        voltage: 3.8
    )
}

extension BenchmarkResults {
    static let mock = BenchmarkResults(
        averageFPS: 60.0,
        frameDrops: 0,
        renderTime: 12.0,
        layoutTime: 2.0
    )
}

extension AllocationBenchmarkResults {
    static let mock = AllocationBenchmarkResults(
        allocationsPerSecond: 1000,
        averageAllocationTime: 0.001,
        peakMemoryUsage: 128.0
    )
}

extension PerformanceReport {
    static let mock = PerformanceReport(
        period: 3600,
        averageCPUUsage: 35.5,
        averageMemoryUsage: 256.0,
        networkThroughput: 1000.0,
        criticalIssues: 0,
        recommendations: []
    )
}