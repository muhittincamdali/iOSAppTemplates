//
// MemoryTracker.swift
// iOS App Templates
//
// Created on 17/08/2024.
//

import Foundation
import os.log

/// Real-time memory usage tracking for performance validation
public final class MemoryTracker: @unchecked Sendable {
    
    // MARK: - Properties
    
    private let queue = DispatchQueue(label: "com.iostemplates.memorytracker", qos: .utility)
    private var observations: [MemoryObservation] = []
    private var isTracking = false
    
    // MARK: - Public Methods
    
    public init() {}
    
    /// Get current memory usage in MB
    public func currentUsage() -> Double {
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
    
    /// Start continuous memory tracking
    public func startTracking(interval: TimeInterval = 1.0) {
        queue.async { [weak self] in
            guard let self = self, !self.isTracking else { return }
            
            self.isTracking = true
            self.observations.removeAll()
            
            self.performTracking(interval: interval)
        }
    }
    
    /// Stop tracking and return observations
    public func stopTracking() -> [MemoryObservation] {
        return queue.sync { [weak self] in
            guard let self = self else { return [] }
            
            self.isTracking = false
            return self.observations
        }
    }
    
    /// Get detailed memory information
    public func detailedMemoryInfo() -> DetailedMemoryInfo {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return DetailedMemoryInfo(
                residentSize: Double(info.resident_size) / 1024 / 1024,
                virtualSize: Double(info.virtual_size) / 1024 / 1024,
                suspendCount: Int(info.suspend_count),
                timestamp: Date()
            )
        } else {
            return DetailedMemoryInfo(
                residentSize: 0,
                virtualSize: 0,
                suspendCount: 0,
                timestamp: Date()
            )
        }
    }
    
    /// Get memory statistics over a period
    public func memoryStatistics() -> MemoryStatistics {
        return queue.sync { [weak self] in
            guard let self = self, !self.observations.isEmpty else {
                return MemoryStatistics.empty
            }
            
            let memoryValues = self.observations.map { $0.memoryUsage }
            
            return MemoryStatistics(
                minimum: memoryValues.min() ?? 0,
                maximum: memoryValues.max() ?? 0,
                average: memoryValues.reduce(0, +) / Double(memoryValues.count),
                samples: memoryValues.count,
                duration: self.observations.last!.timestamp.timeIntervalSince(self.observations.first!.timestamp)
            )
        }
    }
    
    // MARK: - Private Methods
    
    private func performTracking(interval: TimeInterval) {
        guard isTracking else { return }
        
        let observation = MemoryObservation(
            memoryUsage: currentUsage(),
            timestamp: Date()
        )
        
        observations.append(observation)
        
        // Continue tracking
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + interval) { [weak self] in
            self?.performTracking(interval: interval)
        }
    }
}

// MARK: - Supporting Types

public struct MemoryObservation {
    public let memoryUsage: Double // MB
    public let timestamp: Date
    
    public init(memoryUsage: Double, timestamp: Date) {
        self.memoryUsage = memoryUsage
        self.timestamp = timestamp
    }
}

public struct DetailedMemoryInfo {
    public let residentSize: Double // MB
    public let virtualSize: Double // MB
    public let suspendCount: Int
    public let timestamp: Date
    
    public init(residentSize: Double, virtualSize: Double, suspendCount: Int, timestamp: Date) {
        self.residentSize = residentSize
        self.virtualSize = virtualSize
        self.suspendCount = suspendCount
        self.timestamp = timestamp
    }
}

public struct MemoryStatistics {
    public let minimum: Double
    public let maximum: Double
    public let average: Double
    public let samples: Int
    public let duration: TimeInterval
    
    public static let empty = MemoryStatistics(
        minimum: 0, maximum: 0, average: 0, samples: 0, duration: 0
    )
    
    public init(minimum: Double, maximum: Double, average: Double, samples: Int, duration: TimeInterval) {
        self.minimum = minimum
        self.maximum = maximum
        self.average = average
        self.samples = samples
        self.duration = duration
    }
}