//
// PerformanceTestUtilities.swift
// iOS App Templates
//
// Created on 17/08/2024.
//

import Foundation
import XCTest
import UIKit

/// Shared utilities for performance testing across all test suites
public final class PerformanceTestUtilities: @unchecked Sendable {
    
    // MARK: - Enterprise Standards Performance Thresholds
    
    public static let globalStandards = GlobalPerformanceStandards(
        coldLaunchThreshold: 1.0,      // 1 second
        hotLaunchThreshold: 0.3,       // 300ms
        animationFPSTarget: 120.0,     // 120fps
        memoryFootprintLimit: 100.0,   // 100MB
        cpuUsageLimit: 30.0,           // 30%
        networkLatencyLimit: 100.0,    // 100ms
        diskIOLimit: 50.0,             // 50ms
        batteryEfficiencyTarget: 95.0  // 95%
    )
    
    // MARK: - Performance Measurement
    
    /// Measure execution time with high precision
    public static func measureExecutionTime<T>(
        operation: () async throws -> T
    ) async throws -> (result: T, duration: TimeInterval) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try await operation()
        let endTime = CFAbsoluteTimeGetCurrent()
        let duration = endTime - startTime
        
        return (result: result, duration: duration)
    }
    
    /// Measure execution time with synchronous operation
    public static func measureExecutionTime<T>(
        operation: () throws -> T
    ) throws -> (result: T, duration: TimeInterval) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try operation()
        let endTime = CFAbsoluteTimeGetCurrent()
        let duration = endTime - startTime
        
        return (result: result, duration: duration)
    }
    
    /// Measure multiple iterations and return statistics
    public static func measureMultipleIterations(
        iterations: Int = 10,
        operation: () async throws -> Void
    ) async throws -> PerformanceStatistics {
        var durations: [TimeInterval] = []
        
        for _ in 0..<iterations {
            let (_, duration) = try await measureExecutionTime {
                try await operation()
            }
            durations.append(duration)
        }
        
        return PerformanceStatistics(durations: durations)
    }
    
    // MARK: - Memory Monitoring
    
    /// Get current memory usage in MB
    public static func getCurrentMemoryUsage() -> Double {
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
    
    /// Monitor memory usage during operation
    public static func monitorMemoryUsage<T>(
        during operation: () async throws -> T
    ) async throws -> (result: T, memoryDelta: Double, peakUsage: Double) {
        let initialMemory = getCurrentMemoryUsage()
        var peakMemory = initialMemory
        
        // Start memory monitoring
        let monitoringTask = Task {
            while !Task.isCancelled {
                let currentMemory = getCurrentMemoryUsage()
                peakMemory = max(peakMemory, currentMemory)
                try await Task.sleep(nanoseconds: 10_000_000) // 10ms intervals
            }
        }
        
        // Execute operation
        let result = try await operation()
        
        // Stop monitoring
        monitoringTask.cancel()
        
        let finalMemory = getCurrentMemoryUsage()
        let memoryDelta = finalMemory - initialMemory
        
        return (result: result, memoryDelta: memoryDelta, peakUsage: peakMemory)
    }
    
    // MARK: - CPU Monitoring
    
    /// Get current CPU usage percentage
    public static func getCurrentCPUUsage() -> Double {
        var kr: kern_return_t
        var task_info_count: mach_msg_type_number_t
        
        task_info_count = mach_msg_type_number_t(TASK_INFO_MAX)
        var tinfo = [integer_t](repeating: 0, count: Int(task_info_count))
        
        kr = task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), &tinfo, &task_info_count)
        if kr != KERN_SUCCESS {
            return 0
        }
        
        var thread_list: thread_act_array_t? = UnsafeMutablePointer(mutating: [thread_act_t]())
        var thread_count: mach_msg_type_number_t = 0
        defer {
            if let thread_list = thread_list {
                vm_deallocate(mach_task_self_, vm_address_t(UnsafePointer(thread_list).pointee), vm_size_t(thread_count))
            }
        }
        
        kr = task_threads(mach_task_self_, &thread_list, &thread_count)
        if kr != KERN_SUCCESS {
            return 0
        }
        
        var totalCPU: Double = 0
        
        if let thread_list = thread_list {
            for j in 0..<Int(thread_count) {
                var thread_info_count = mach_msg_type_number_t(THREAD_INFO_MAX)
                var thinfo = [integer_t](repeating: 0, count: Int(thread_info_count))
                kr = thread_info(thread_list[j], thread_flavor_t(THREAD_BASIC_INFO),
                               &thinfo, &thread_info_count)
                if kr != KERN_SUCCESS {
                    continue
                }
                
                let threadBasicInfo = convertThreadInfoToThreadBasicInfo(thinfo)
                
                if threadBasicInfo.flags != TH_FLAGS_IDLE {
                    totalCPU += (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE)) * 100.0
                }
            }
        }
        
        return totalCPU
    }
    
    // MARK: - Test Data Generation
    
    /// Generate test data for performance testing
    public static func generateTestData(count: Int) -> [TestDataItem] {
        return (0..<count).map { index in
            TestDataItem(
                id: index,
                title: "Test Item \(index)",
                content: String(repeating: "Content ", count: 50),
                timestamp: Date(),
                metadata: generateRandomMetadata()
            )
        }
    }
    
    /// Generate test images for memory testing
    public static func generateTestImages(count: Int, size: CGSize = CGSize(width: 100, height: 100)) -> [UIImage] {
        return (0..<count).map { _ in
            UIGraphicsImageRenderer(size: size).image { context in
                UIColor.random.setFill()
                context.fill(CGRect(origin: .zero, size: size))
            }
        }
    }
    
    /// Create complex view hierarchy for UI performance testing
    public static func createComplexViewHierarchy(depth: Int = 5, breadth: Int = 10) -> UIView {
        let rootView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        
        func addSubviews(to parent: UIView, currentDepth: Int) {
            guard currentDepth > 0 else { return }
            
            for i in 0..<breadth {
                let subview = UIView()
                subview.backgroundColor = UIColor.random
                subview.tag = i
                parent.addSubview(subview)
                
                // Add nested views
                addSubviews(to: subview, currentDepth: currentDepth - 1)
            }
        }
        
        addSubviews(to: rootView, currentDepth: depth)
        return rootView
    }
    
    // MARK: - Validation Helpers
    
    /// Validate performance against Enterprise Standards
    public static func validatePerformance(
        duration: TimeInterval,
        against threshold: TimeInterval,
        metric: String
    ) -> PerformanceValidationResult {
        let passed = duration <= threshold
        let percentage = (duration / threshold) * 100
        
        return PerformanceValidationResult(
            metric: metric,
            measured: duration,
            threshold: threshold,
            passed: passed,
            percentage: percentage
        )
    }
    
    /// Validate memory usage against standards
    public static func validateMemoryUsage(
        usage: Double,
        against limit: Double
    ) -> PerformanceValidationResult {
        let passed = usage <= limit
        let percentage = (usage / limit) * 100
        
        return PerformanceValidationResult(
            metric: "Memory Usage",
            measured: usage,
            threshold: limit,
            passed: passed,
            percentage: percentage
        )
    }
    
    // MARK: - Reporting
    
    /// Generate performance summary report
    public static func generatePerformanceSummary(
        results: [PerformanceValidationResult]
    ) -> PerformanceSummaryReport {
        let passedCount = results.filter { $0.passed }.count
        let totalCount = results.count
        let overallScore = Double(passedCount) / Double(totalCount) * 100
        
        let criticalFailures = results.filter { !$0.passed && $0.percentage > 150 }
        let warnings = results.filter { !$0.passed && $0.percentage <= 150 }
        
        return PerformanceSummaryReport(
            overallScore: overallScore,
            passedTests: passedCount,
            totalTests: totalCount,
            criticalFailures: criticalFailures,
            warnings: warnings,
            recommendations: generateRecommendations(from: results)
        )
    }
    
    // MARK: - Private Helpers
    
    private static func convertThreadInfoToThreadBasicInfo(_ threadInfo: [integer_t]) -> thread_basic_info {
        var result = thread_basic_info()
        
        result.user_time = time_value_t(seconds: threadInfo[0], microseconds: threadInfo[1])
        result.system_time = time_value_t(seconds: threadInfo[2], microseconds: threadInfo[3])
        result.cpu_usage = threadInfo[4]
        result.policy = threadInfo[5]
        result.run_state = threadInfo[6]
        result.flags = threadInfo[7]
        result.suspend_count = threadInfo[8]
        result.sleep_time = threadInfo[9]
        
        return result
    }
    
    private static func generateRandomMetadata() -> [String: Any] {
        return [
            "category": ["important", "normal", "low"].randomElement()!,
            "priority": Int.random(in: 1...10),
            "tags": Array(0..<Int.random(in: 1...5)).map { "tag\($0)" },
            "size": Double.random(in: 1...100)
        ]
    }
    
    private static func generateRecommendations(from results: [PerformanceValidationResult]) -> [String] {
        var recommendations: [String] = []
        
        for result in results where !result.passed {
            switch result.metric {
            case "Cold Launch":
                recommendations.append("Optimize app launch by reducing synchronous operations")
            case "Memory Usage":
                recommendations.append("Implement memory optimization and reduce object retention")
            case "Animation FPS":
                recommendations.append("Optimize rendering pipeline for 120fps displays")
            case "CPU Usage":
                recommendations.append("Reduce computational complexity and use background queues")
            default:
                recommendations.append("Review and optimize \(result.metric) implementation")
            }
        }
        
        return Array(Set(recommendations)) // Remove duplicates
    }
}

// MARK: - Supporting Types

public struct GlobalPerformanceStandards {
    public let coldLaunchThreshold: TimeInterval
    public let hotLaunchThreshold: TimeInterval
    public let animationFPSTarget: Double
    public let memoryFootprintLimit: Double
    public let cpuUsageLimit: Double
    public let networkLatencyLimit: TimeInterval
    public let diskIOLimit: TimeInterval
    public let batteryEfficiencyTarget: Double
    
    public init(coldLaunchThreshold: TimeInterval, hotLaunchThreshold: TimeInterval, animationFPSTarget: Double, memoryFootprintLimit: Double, cpuUsageLimit: Double, networkLatencyLimit: TimeInterval, diskIOLimit: TimeInterval, batteryEfficiencyTarget: Double) {
        self.coldLaunchThreshold = coldLaunchThreshold
        self.hotLaunchThreshold = hotLaunchThreshold
        self.animationFPSTarget = animationFPSTarget
        self.memoryFootprintLimit = memoryFootprintLimit
        self.cpuUsageLimit = cpuUsageLimit
        self.networkLatencyLimit = networkLatencyLimit
        self.diskIOLimit = diskIOLimit
        self.batteryEfficiencyTarget = batteryEfficiencyTarget
    }
}

public struct PerformanceStatistics {
    public let durations: [TimeInterval]
    public let minimum: TimeInterval
    public let maximum: TimeInterval
    public let average: TimeInterval
    public let median: TimeInterval
    public let standardDeviation: TimeInterval
    
    public init(durations: [TimeInterval]) {
        self.durations = durations
        self.minimum = durations.min() ?? 0
        self.maximum = durations.max() ?? 0
        self.average = durations.reduce(0, +) / Double(durations.count)
        
        let sorted = durations.sorted()
        let count = sorted.count
        self.median = count % 2 == 0 ? 
            (sorted[count/2 - 1] + sorted[count/2]) / 2 : 
            sorted[count/2]
        
        let variance = durations.map { pow($0 - average, 2) }.reduce(0, +) / Double(durations.count)
        self.standardDeviation = sqrt(variance)
    }
}

public struct TestDataItem {
    public let id: Int
    public let title: String
    public let content: String
    public let timestamp: Date
    public let metadata: [String: Any]
    
    public init(id: Int, title: String, content: String, timestamp: Date, metadata: [String: Any]) {
        self.id = id
        self.title = title
        self.content = content
        self.timestamp = timestamp
        self.metadata = metadata
    }
}

public struct PerformanceValidationResult {
    public let metric: String
    public let measured: Double
    public let threshold: Double
    public let passed: Bool
    public let percentage: Double
    
    public init(metric: String, measured: Double, threshold: Double, passed: Bool, percentage: Double) {
        self.metric = metric
        self.measured = measured
        self.threshold = threshold
        self.passed = passed
        self.percentage = percentage
    }
}

public struct PerformanceSummaryReport {
    public let overallScore: Double
    public let passedTests: Int
    public let totalTests: Int
    public let criticalFailures: [PerformanceValidationResult]
    public let warnings: [PerformanceValidationResult]
    public let recommendations: [String]
    
    public init(overallScore: Double, passedTests: Int, totalTests: Int, criticalFailures: [PerformanceValidationResult], warnings: [PerformanceValidationResult], recommendations: [String]) {
        self.overallScore = overallScore
        self.passedTests = passedTests
        self.totalTests = totalTests
        self.criticalFailures = criticalFailures
        self.warnings = warnings
        self.recommendations = recommendations
    }
}

private extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}