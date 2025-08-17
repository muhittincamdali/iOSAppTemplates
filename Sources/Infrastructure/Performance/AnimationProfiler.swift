//
// AnimationProfiler.swift
// iOS App Templates
//
// Created on 17/08/2024.
//

import Foundation
import QuartzCore
import UIKit

/// High-precision animation performance profiler for 120fps validation
public final class AnimationProfiler: @unchecked Sendable {
    
    // MARK: - Properties
    
    private var displayLink: CADisplayLink?
    private var frameTimestamps: [CFTimeInterval] = []
    private var startTime: CFTimeInterval = 0
    private var isProfileng = false
    private let queue = DispatchQueue(label: "com.iostemplates.animationprofiler", qos: .userInteractive)
    
    // MARK: - Public Methods
    
    public init() {}
    
    deinit {
        stopProfiling()
    }
    
    /// Start profiling animations
    public func startProfiling() {
        queue.async { [weak self] in
            guard let self = self, !self.isProfileng else { return }
            
            self.isProfileng = true
            self.frameTimestamps.removeAll()
            self.startTime = CACurrentMediaTime()
            
            DispatchQueue.main.async {
                self.setupDisplayLink()
            }
        }
    }
    
    /// Stop profiling and return metrics
    @discardableResult
    public func stopProfiling() -> AnimationMetric {
        return queue.sync { [weak self] in
            guard let self = self, self.isProfileng else {
                return AnimationMetric(
                    averageFPS: 0, minFPS: 0, maxFPS: 0,
                    droppedFrames: 0, duration: 0
                )
            }
            
            self.isProfileng = false
            
            DispatchQueue.main.sync {
                self.displayLink?.invalidate()
                self.displayLink = nil
            }
            
            return self.calculateMetrics()
        }
    }
    
    /// Get real-time FPS
    public func currentFPS() -> Double {
        return queue.sync { [weak self] in
            guard let self = self, self.frameTimestamps.count >= 2 else { return 0 }
            
            let recentFrames = Array(self.frameTimestamps.suffix(60)) // Last 60 frames
            guard recentFrames.count >= 2 else { return 0 }
            
            let duration = recentFrames.last! - recentFrames.first!
            return Double(recentFrames.count - 1) / duration
        }
    }
    
    // MARK: - Private Methods
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkCallback))
        
        // Configure for high refresh rate displays (120fps)
        if #available(iOS 15.0, *) {
            displayLink?.preferredFrameRateRange = CAFrameRateRange(
                minimum: 60,
                maximum: 120,
                preferred: 120
            )
        } else {
            displayLink?.preferredFramesPerSecond = 120
        }
        
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func displayLinkCallback(_ displayLink: CADisplayLink) {
        queue.async { [weak self] in
            guard let self = self, self.isProfileng else { return }
            
            let timestamp = displayLink.timestamp
            self.frameTimestamps.append(timestamp)
            
            // Keep only recent frames to prevent memory issues
            if self.frameTimestamps.count > 1000 {
                self.frameTimestamps.removeFirst(200)
            }
        }
    }
    
    private func calculateMetrics() -> AnimationMetric {
        guard frameTimestamps.count >= 2 else {
            return AnimationMetric(
                averageFPS: 0, minFPS: 0, maxFPS: 0,
                droppedFrames: 0, duration: 0
            )
        }
        
        let totalDuration = frameTimestamps.last! - frameTimestamps.first!
        
        // Calculate FPS for each second
        var fpsValues: [Double] = []
        var droppedFrames = 0
        
        for i in 1..<frameTimestamps.count {
            let frameDuration = frameTimestamps[i] - frameTimestamps[i-1]
            let fps = 1.0 / frameDuration
            
            // Detect dropped frames (assuming 120fps target)
            let expectedFrameTime = 1.0 / 120.0 // 8.33ms
            if frameDuration > expectedFrameTime * 1.5 {
                droppedFrames += Int((frameDuration / expectedFrameTime) - 1)
            }
            
            fpsValues.append(fps)
        }
        
        let averageFPS = fpsValues.reduce(0, +) / Double(fpsValues.count)
        let minFPS = fpsValues.min() ?? 0
        let maxFPS = fpsValues.max() ?? 0
        
        return AnimationMetric(
            averageFPS: averageFPS,
            minFPS: minFPS,
            maxFPS: maxFPS,
            droppedFrames: droppedFrames,
            duration: totalDuration
        )
    }
}

/// CPU usage monitor for performance validation
public final class CPUMonitor: @unchecked Sendable {
    
    // MARK: - Properties
    
    private var isMonitoring = false
    private var cpuUsageHistory: [Double] = []
    private let queue = DispatchQueue(label: "com.iostemplates.cpumonitor", qos: .utility)
    private var monitoringTimer: Timer?
    
    // MARK: - Public Methods
    
    public init() {}
    
    deinit {
        stopMonitoring()
    }
    
    /// Start CPU monitoring
    public func startMonitoring(interval: TimeInterval = 0.1) {
        queue.async { [weak self] in
            guard let self = self, !self.isMonitoring else { return }
            
            self.isMonitoring = true
            self.cpuUsageHistory.removeAll()
            
            DispatchQueue.main.async {
                self.monitoringTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                    self.recordCPUUsage()
                }
            }
        }
    }
    
    /// Stop monitoring and return metrics
    public func stopMonitoring() -> CPUMetric {
        return queue.sync { [weak self] in
            guard let self = self else {
                return CPUMetric(averageUsage: 0, peakUsage: 0, duration: 0, timestamp: Date())
            }
            
            self.isMonitoring = false
            
            DispatchQueue.main.sync {
                self.monitoringTimer?.invalidate()
                self.monitoringTimer = nil
            }
            
            let averageUsage = self.cpuUsageHistory.isEmpty ? 0 : 
                self.cpuUsageHistory.reduce(0, +) / Double(self.cpuUsageHistory.count)
            let peakUsage = self.cpuUsageHistory.max() ?? 0
            
            return CPUMetric(
                averageUsage: averageUsage,
                peakUsage: peakUsage,
                duration: Double(self.cpuUsageHistory.count) * 0.1, // Assuming 0.1s intervals
                timestamp: Date()
            )
        }
    }
    
    /// Get current CPU usage
    public func currentCPUUsage() -> Double {
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
        
        var tot_cpu: Double = 0
        
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
                    tot_cpu += (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE)) * 100.0
                }
            }
        }
        
        return tot_cpu
    }
    
    // MARK: - Private Methods
    
    private func recordCPUUsage() {
        queue.async { [weak self] in
            guard let self = self, self.isMonitoring else { return }
            
            let usage = self.currentCPUUsage()
            self.cpuUsageHistory.append(usage)
            
            // Keep only recent history
            if self.cpuUsageHistory.count > 600 { // 1 minute at 0.1s intervals
                self.cpuUsageHistory.removeFirst(100)
            }
        }
    }
    
    private func convertThreadInfoToThreadBasicInfo(_ threadInfo: [integer_t]) -> thread_basic_info {
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
}

/// Battery efficiency monitor
public final class BatteryEfficiencyMonitor: @unchecked Sendable {
    
    // MARK: - Properties
    
    private var isMonitoring = false
    private var startBatteryLevel: Float = 0
    private var startTime: Date = Date()
    private let queue = DispatchQueue(label: "com.iostemplates.batterymonitor", qos: .utility)
    
    // MARK: - Public Methods
    
    public init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    /// Start battery efficiency monitoring
    public func startMonitoring() {
        queue.async { [weak self] in
            guard let self = self, !self.isMonitoring else { return }
            
            self.isMonitoring = true
            self.startTime = Date()
            
            DispatchQueue.main.sync {
                self.startBatteryLevel = UIDevice.current.batteryLevel
            }
        }
    }
    
    /// Stop monitoring and calculate efficiency
    public func stopMonitoring() -> BatteryMetric {
        return queue.sync { [weak self] in
            guard let self = self, self.isMonitoring else {
                return BatteryMetric(efficiency: 0, powerConsumption: 0, duration: 0, timestamp: Date())
            }
            
            self.isMonitoring = false
            
            let endTime = Date()
            let duration = endTime.timeIntervalSince(self.startTime)
            
            let endBatteryLevel = UIDevice.current.batteryLevel
            let batteryDrop = self.startBatteryLevel - endBatteryLevel
            
            // Calculate efficiency (higher is better)
            let efficiency = max(0, 100 - (Double(batteryDrop) / (duration / 3600) * 100))
            
            return BatteryMetric(
                efficiency: efficiency,
                powerConsumption: Double(batteryDrop) * 100,
                duration: duration,
                timestamp: Date()
            )
        }
    }
}

/// Test network client for performance validation
public final class TestNetworkClient: @unchecked Sendable {
    
    public enum Endpoint {
        case userProfile
        case posts
        case upload
    }
    
    public init() {}
    
    public func performRequest(endpoint: Endpoint, timeout: TimeInterval) async throws -> Data {
        // Simulate network request
        let delay = Double.random(in: 0.05...0.15) // 50-150ms
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        // Return mock data
        return Data("Mock response data".utf8)
    }
}

/// Background task manager for testing
public final class BackgroundTaskManager: @unchecked Sendable {
    
    public init() {}
    
    public func performBackgroundSync() async {
        // Simulate background sync
        try? await Task.sleep(nanoseconds: 200_000_000) // 200ms
    }
    
    public func processQueuedTasks() async {
        // Simulate task processing
        try? await Task.sleep(nanoseconds: 150_000_000) // 150ms
    }
    
    public func updateCachedData() async {
        // Simulate cache updates
        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
    }
}