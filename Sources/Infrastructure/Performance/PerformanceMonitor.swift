//
// PerformanceMonitor.swift
// iOS App Templates
//
// Created on 17/08/2024.
//

import Foundation
import UIKit
import QuartzCore

/// Enterprise Standards Performance Monitor
/// Enterprise-grade performance monitoring and validation system
public final class PerformanceMonitor: @unchecked Sendable {
    
    // MARK: - Properties
    
    private let queue = DispatchQueue(label: "com.iostemplates.performance", qos: .utility)
    private var launchMetrics: [LaunchMetric] = []
    private var animationMetrics: [AnimationMetric] = []
    private var memoryMetrics: [MemoryMetric] = []
    private var cpuMetrics: [CPUMetric] = []
    private var networkMetrics: [NetworkMetric] = []
    private var diskIOMetrics: [DiskIOMetric] = []
    private var batteryMetrics: [BatteryMetric] = []
    
    private var startTime: CFAbsoluteTime = 0
    private var isMonitoring = false
    
    // MARK: - Initialization
    
    public init() {
        resetBaseline()
    }
    
    // MARK: - Public Methods
    
    public func resetBaseline() {
        queue.async { [weak self] in
            self?.launchMetrics.removeAll()
            self?.animationMetrics.removeAll()
            self?.memoryMetrics.removeAll()
            self?.cpuMetrics.removeAll()
            self?.networkMetrics.removeAll()
            self?.diskIOMetrics.removeAll()
            self?.batteryMetrics.removeAll()
            self?.startTime = CFAbsoluteTimeGetCurrent()
        }
    }
    
    public func recordLaunchMetrics(type: LaunchType, duration: TimeInterval, memoryUsage: Double) async {
        return await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                let metric = LaunchMetric(
                    type: type,
                    duration: duration,
                    memoryUsage: memoryUsage,
                    timestamp: Date()
                )
                self?.launchMetrics.append(metric)
                continuation.resume()
            }
        }
    }
    
    public func recordAnimationMetrics(_ metrics: AnimationMetric) async {
        return await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                self?.animationMetrics.append(metrics)
                continuation.resume()
            }
        }
    }
    
    public func recordScrollMetrics(_ metrics: AnimationMetric) async {
        return await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                var scrollMetric = metrics
                scrollMetric.type = .scroll
                self?.animationMetrics.append(scrollMetric)
                continuation.resume()
            }
        }
    }
    
    public func recordMemoryMetrics(initial: Double, final: Double, increase: Double) async {
        return await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                let metric = MemoryMetric(
                    initial: initial,
                    final: final,
                    increase: increase,
                    timestamp: Date()
                )
                self?.memoryMetrics.append(metric)
                continuation.resume()
            }
        }
    }
    
    public func recordMemoryStressTest(initial: Double, peak: Double, final: Double) async {
        return await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                let metric = MemoryMetric(
                    initial: initial,
                    final: final,
                    increase: peak - initial,
                    peak: peak,
                    type: .stressTest,
                    timestamp: Date()
                )
                self?.memoryMetrics.append(metric)
                continuation.resume()
            }
        }
    }
    
    public func recordMemoryLeakTest(initialMemory: Double, finalMemory: Double, growth: Double) async {
        return await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                let metric = MemoryMetric(
                    initial: initialMemory,
                    final: finalMemory,
                    increase: growth,
                    type: .leakTest,
                    timestamp: Date()
                )
                self?.memoryMetrics.append(metric)
                continuation.resume()
            }
        }
    }
    
    public func recordCPUMetrics(_ metrics: CPUMetric) async {
        return await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                self?.cpuMetrics.append(metrics)
                continuation.resume()
            }
        }
    }
    
    public func recordBatteryMetrics(_ metrics: BatteryMetric) async {
        return await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                self?.batteryMetrics.append(metrics)
                continuation.resume()
            }
        }
    }
    
    public func recordNetworkMetrics(latencies: [TimeInterval], averageLatency: TimeInterval) async {
        return await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                let metric = NetworkMetric(
                    latencies: latencies,
                    averageLatency: averageLatency,
                    minLatency: latencies.min() ?? 0,
                    maxLatency: latencies.max() ?? 0,
                    timestamp: Date()
                )
                self?.networkMetrics.append(metric)
                continuation.resume()
            }
        }
    }
    
    public func recordDiskIOMetrics(operations: [TimeInterval], averageTime: TimeInterval) async {
        return await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                let metric = DiskIOMetric(
                    operations: operations,
                    averageTime: averageTime,
                    minTime: operations.min() ?? 0,
                    maxTime: operations.max() ?? 0,
                    timestamp: Date()
                )
                self?.diskIOMetrics.append(metric)
                continuation.resume()
            }
        }
    }
    
    public func generateComprehensiveReport() async -> PerformanceReport {
        return await withCheckedContinuation { continuation in
            queue.async { [weak self] in
                guard let self = self else {
                    continuation.resume(returning: PerformanceReport.empty)
                    return
                }
                
                let report = PerformanceReport(
                    launchScore: self.calculateLaunchScore(),
                    animationScore: self.calculateAnimationScore(),
                    memoryScore: self.calculateMemoryScore(),
                    cpuScore: self.calculateCPUScore(),
                    networkScore: self.calculateNetworkScore(),
                    diskIOScore: self.calculateDiskIOScore(),
                    batteryScore: self.calculateBatteryScore(),
                    overallScore: 0, // Will be calculated
                    criticalIssues: self.identifyCriticalIssues(),
                    recommendations: self.generateRecommendations(),
                    timestamp: Date()
                )
                
                // Calculate overall score
                let scores = [
                    report.launchScore,
                    report.animationScore,
                    report.memoryScore,
                    report.cpuScore,
                    report.networkScore,
                    report.diskIOScore,
                    report.batteryScore
                ]
                let overallScore = scores.reduce(0, +) / Double(scores.count)
                
                let finalReport = PerformanceReport(
                    launchScore: report.launchScore,
                    animationScore: report.animationScore,
                    memoryScore: report.memoryScore,
                    cpuScore: report.cpuScore,
                    networkScore: report.networkScore,
                    diskIOScore: report.diskIOScore,
                    batteryScore: report.batteryScore,
                    overallScore: overallScore,
                    criticalIssues: report.criticalIssues,
                    recommendations: report.recommendations,
                    timestamp: report.timestamp
                )
                
                continuation.resume(returning: finalReport)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func calculateLaunchScore() -> Double {
        guard !launchMetrics.isEmpty else { return 0 }
        
        let coldLaunches = launchMetrics.filter { $0.type == .cold }
        let hotLaunches = launchMetrics.filter { $0.type == .hot }
        
        var score: Double = 100
        
        // Cold launch scoring (target: <1s)
        for launch in coldLaunches {
            if launch.duration > 1.0 {
                score -= min(50, (launch.duration - 1.0) * 50)
            }
        }
        
        // Hot launch scoring (target: <0.3s)
        for launch in hotLaunches {
            if launch.duration > 0.3 {
                score -= min(30, (launch.duration - 0.3) * 100)
            }
        }
        
        return max(0, score)
    }
    
    private func calculateAnimationScore() -> Double {
        guard !animationMetrics.isEmpty else { return 0 }
        
        var score: Double = 100
        
        for animation in animationMetrics {
            // Target: 120fps
            if animation.averageFPS < 120 {
                score -= min(40, (120 - animation.averageFPS) / 120 * 40)
            }
            
            // Penalize dropped frames
            score -= min(30, Double(animation.droppedFrames) * 5)
        }
        
        return max(0, score / Double(animationMetrics.count))
    }
    
    private func calculateMemoryScore() -> Double {
        guard !memoryMetrics.isEmpty else { return 0 }
        
        var score: Double = 100
        
        for memory in memoryMetrics {
            // Target: <100MB
            if memory.final > 100 {
                score -= min(50, (memory.final - 100) / 100 * 50)
            }
            
            // Check for memory leaks
            if memory.type == .leakTest && memory.increase > 5 {
                score -= min(40, memory.increase * 8)
            }
        }
        
        return max(0, score / Double(memoryMetrics.count))
    }
    
    private func calculateCPUScore() -> Double {
        guard !cpuMetrics.isEmpty else { return 0 }
        
        var score: Double = 100
        
        for cpu in cpuMetrics {
            // Target: <30% average
            if cpu.averageUsage > 30 {
                score -= min(60, (cpu.averageUsage - 30) / 30 * 60)
            }
            
            // Check peak usage
            if cpu.peakUsage > 80 {
                score -= min(30, (cpu.peakUsage - 80) / 20 * 30)
            }
        }
        
        return max(0, score / Double(cpuMetrics.count))
    }
    
    private func calculateNetworkScore() -> Double {
        guard !networkMetrics.isEmpty else { return 0 }
        
        var score: Double = 100
        
        for network in networkMetrics {
            // Target: <100ms average latency
            if network.averageLatency > 100 {
                score -= min(50, (network.averageLatency - 100) / 100 * 50)
            }
        }
        
        return max(0, score / Double(networkMetrics.count))
    }
    
    private func calculateDiskIOScore() -> Double {
        guard !diskIOMetrics.isEmpty else { return 0 }
        
        var score: Double = 100
        
        for diskIO in diskIOMetrics {
            // Target: <50ms average
            if diskIO.averageTime > 50 {
                score -= min(60, (diskIO.averageTime - 50) / 50 * 60)
            }
        }
        
        return max(0, score / Double(diskIOMetrics.count))
    }
    
    private func calculateBatteryScore() -> Double {
        guard !batteryMetrics.isEmpty else { return 0 }
        
        var score: Double = 100
        
        for battery in batteryMetrics {
            // Target: >95% efficiency
            if battery.efficiency < 95 {
                score -= min(40, (95 - battery.efficiency) / 95 * 40)
            }
        }
        
        return max(0, score / Double(batteryMetrics.count))
    }
    
    private func identifyCriticalIssues() -> [String] {
        var issues: [String] = []
        
        // Check launch times
        for launch in launchMetrics {
            if launch.type == .cold && launch.duration > 2.0 {
                issues.append("Critical: Cold launch time exceeds 2 seconds (\(String(format: "%.2f", launch.duration))s)")
            }
        }
        
        // Check memory usage
        for memory in memoryMetrics {
            if memory.final > 200 {
                issues.append("Critical: Memory usage exceeds 200MB (\(String(format: "%.1f", memory.final))MB)")
            }
            if memory.type == .leakTest && memory.increase > 20 {
                issues.append("Critical: Significant memory leak detected (\(String(format: "%.1f", memory.increase))MB)")
            }
        }
        
        // Check CPU usage
        for cpu in cpuMetrics {
            if cpu.averageUsage > 70 {
                issues.append("Critical: CPU usage consistently high (\(String(format: "%.1f", cpu.averageUsage))%)")
            }
        }
        
        return issues
    }
    
    private func generateRecommendations() -> [String] {
        var recommendations: [String] = []
        
        // Launch recommendations
        if let avgColdLaunch = launchMetrics.filter({ $0.type == .cold }).first?.duration, avgColdLaunch > 1.0 {
            recommendations.append("Optimize app launch by reducing synchronous operations")
            recommendations.append("Implement lazy loading for non-critical components")
        }
        
        // Animation recommendations
        if let avgFPS = animationMetrics.first?.averageFPS, avgFPS < 120 {
            recommendations.append("Optimize animations for 120fps display")
            recommendations.append("Use CADisplayLink for smoother animations")
        }
        
        // Memory recommendations
        if let maxMemory = memoryMetrics.map({ $0.final }).max(), maxMemory > 100 {
            recommendations.append("Implement memory optimization strategies")
            recommendations.append("Use memory warnings to free up resources")
        }
        
        return recommendations
    }
}

// MARK: - Supporting Types

public enum LaunchType {
    case cold
    case hot
}

public struct LaunchMetric {
    let type: LaunchType
    let duration: TimeInterval
    let memoryUsage: Double
    let timestamp: Date
}

public struct AnimationMetric {
    let averageFPS: Double
    let minFPS: Double
    let maxFPS: Double
    let droppedFrames: Int
    let duration: TimeInterval
    var type: AnimationType = .general
    let timestamp: Date
    
    public init(averageFPS: Double, minFPS: Double, maxFPS: Double, droppedFrames: Int, duration: TimeInterval, type: AnimationType = .general, timestamp: Date = Date()) {
        self.averageFPS = averageFPS
        self.minFPS = minFPS
        self.maxFPS = maxFPS
        self.droppedFrames = droppedFrames
        self.duration = duration
        self.type = type
        self.timestamp = timestamp
    }
}

public enum AnimationType {
    case general
    case scroll
    case transition
}

public struct MemoryMetric {
    let initial: Double
    let final: Double
    let increase: Double
    let peak: Double?
    let type: MemoryTestType
    let timestamp: Date
    
    public init(initial: Double, final: Double, increase: Double, peak: Double? = nil, type: MemoryTestType = .general, timestamp: Date = Date()) {
        self.initial = initial
        self.final = final
        self.increase = increase
        self.peak = peak
        self.type = type
        self.timestamp = timestamp
    }
}

public enum MemoryTestType {
    case general
    case stressTest
    case leakTest
}

public struct CPUMetric {
    let averageUsage: Double
    let peakUsage: Double
    let duration: TimeInterval
    let timestamp: Date
}

public struct BatteryMetric {
    let efficiency: Double
    let powerConsumption: Double
    let duration: TimeInterval
    let timestamp: Date
}

public struct NetworkMetric {
    let latencies: [TimeInterval]
    let averageLatency: TimeInterval
    let minLatency: TimeInterval
    let maxLatency: TimeInterval
    let timestamp: Date
}

public struct DiskIOMetric {
    let operations: [TimeInterval]
    let averageTime: TimeInterval
    let minTime: TimeInterval
    let maxTime: TimeInterval
    let timestamp: Date
}

public struct PerformanceReport {
    let launchScore: Double
    let animationScore: Double
    let memoryScore: Double
    let cpuScore: Double
    let networkScore: Double
    let diskIOScore: Double
    let batteryScore: Double
    let overallScore: Double
    let criticalIssues: [String]
    let recommendations: [String]
    let timestamp: Date
    
    static let empty = PerformanceReport(
        launchScore: 0, animationScore: 0, memoryScore: 0, cpuScore: 0,
        networkScore: 0, diskIOScore: 0, batteryScore: 0, overallScore: 0,
        criticalIssues: [], recommendations: [], timestamp: Date()
    )
}