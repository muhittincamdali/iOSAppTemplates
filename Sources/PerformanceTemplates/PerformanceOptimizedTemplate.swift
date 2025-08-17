import SwiftUI
import Collections
import AsyncAlgorithms
import Foundation

// MARK: - Performance Optimized Template

/// High-performance app template with advanced optimization techniques
/// Features: Lazy loading, memory management, async operations, caching
public struct PerformanceOptimizedTemplate {
    public init() {}
}

// MARK: - Performance Monitoring

@Observable
public class PerformanceMonitor {
    public var metrics: PerformanceMetrics = PerformanceMetrics()
    public var isMonitoring = false
    
    private var startTime: Date?
    private let queue = DispatchQueue(label: "performance.monitoring", qos: .utility)
    
    public init() {}
    
    public func startMonitoring() {
        isMonitoring = true
        startTime = Date()
        
        // Start memory monitoring
        Task {
            await monitorMemoryUsage()
        }
    }
    
    public func stopMonitoring() {
        isMonitoring = false
        if let start = startTime {
            metrics.sessionDuration = Date().timeIntervalSince(start)
        }
    }
    
    @MainActor
    private func monitorMemoryUsage() async {
        while isMonitoring {
            let memoryInfo = mach_task_basic_info()
            var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
            
            let result = withUnsafeMutablePointer(to: &memoryInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                    task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
                }
            }
            
            if result == KERN_SUCCESS {
                let memoryUsage = Double(memoryInfo.resident_size) / 1024 / 1024 // MB
                metrics.memoryUsage = memoryUsage
                metrics.maxMemoryUsage = max(metrics.maxMemoryUsage, memoryUsage)
            }
            
            try? await Task.sleep(for: .milliseconds(500))
        }
    }
    
    public func recordLaunchTime(_ time: TimeInterval) {
        metrics.launchTime = time
    }
    
    public func recordFrameRate(_ fps: Double) {
        metrics.frameRate = fps
    }
}

// MARK: - Performance Metrics

public struct PerformanceMetrics: Equatable {
    public var launchTime: TimeInterval = 0
    public var memoryUsage: Double = 0
    public var maxMemoryUsage: Double = 0
    public var frameRate: Double = 60
    public var sessionDuration: TimeInterval = 0
    
    public init() {}
    
    public var formattedLaunchTime: String {
        String(format: "%.2fs", launchTime)
    }
    
    public var formattedMemoryUsage: String {
        String(format: "%.1f MB", memoryUsage)
    }
    
    public var formattedMaxMemoryUsage: String {
        String(format: "%.1f MB", maxMemoryUsage)
    }
    
    public var formattedFrameRate: String {
        String(format: "%.1f fps", frameRate)
    }
}

// MARK: - High Performance List

public struct HighPerformanceListView<Item: Identifiable & Hashable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content
    
    @State private var visibleRange: Range<Int> = 0..<10
    @State private var scrollPosition: ScrollPosition = ScrollPosition()
    
    private let batchSize = 20
    
    public init(
        items: [Item],
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.content = content
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(visibleItems, id: \.id) { item in
                    content(item)
                        .onAppear {
                            if item.id == visibleItems.last?.id {
                                loadMoreIfNeeded()
                            }
                        }
                }
            }
            .padding()
        }
        .onAppear {
            loadInitialBatch()
        }
    }
    
    private var visibleItems: ArraySlice<Item> {
        let endIndex = min(visibleRange.upperBound, items.count)
        return items[visibleRange.lowerBound..<endIndex]
    }
    
    private func loadInitialBatch() {
        visibleRange = 0..<min(batchSize, items.count)
    }
    
    private func loadMoreIfNeeded() {
        guard visibleRange.upperBound < items.count else { return }
        
        let newUpperBound = min(visibleRange.upperBound + batchSize, items.count)
        visibleRange = visibleRange.lowerBound..<newUpperBound
    }
}

// MARK: - Optimized Image Loader

@Observable
public class OptimizedImageLoader {
    public var image: UIImage?
    public var isLoading = false
    public var error: Error?
    
    private static let cache = NSCache<NSString, UIImage>()
    private static let downloadQueue = DispatchQueue(label: "image.download", qos: .utility)
    
    public init() {
        Self.cache.countLimit = 100
        Self.cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    @MainActor
    public func load(from url: URL) async {
        let cacheKey = url.absoluteString as NSString
        
        // Check cache first
        if let cachedImage = Self.cache.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode image on background queue
            let decodedImage = await withCheckedContinuation { continuation in
                Self.downloadQueue.async {
                    let image = UIImage(data: data)
                    continuation.resume(returning: image)
                }
            }
            
            if let decodedImage = decodedImage {
                // Cache the image
                Self.cache.setObject(decodedImage, forKey: cacheKey)
                self.image = decodedImage
            }
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}

// MARK: - Optimized Image View

public struct OptimizedAsyncImage: View {
    let url: URL?
    let placeholder: () -> AnyView
    
    @State private var loader = OptimizedImageLoader()
    
    public init(
        url: URL?,
        @ViewBuilder placeholder: @escaping () -> some View = { ProgressView() }
    ) {
        self.url = url
        self.placeholder = { AnyView(placeholder()) }
    }
    
    public var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if loader.isLoading {
                placeholder()
            } else if loader.error != nil {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            guard let url = url else { return }
            await loader.load(from: url)
        }
    }
}

// MARK: - Memory Efficient Data Store

public actor MemoryEfficientDataStore<T: Codable> {
    private var cache: DequeModule.Deque<CacheItem<T>> = []
    private let maxCacheSize: Int
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    public init(maxCacheSize: Int = 100) {
        self.maxCacheSize = maxCacheSize
        
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.cacheDirectory = cachesDirectory.appendingPathComponent("MemoryEfficientCache")
        
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    public func store(_ item: T, for key: String) async throws {
        // Add to memory cache
        let cacheItem = CacheItem(key: key, value: item, timestamp: Date())
        cache.append(cacheItem)
        
        // Evict old items if cache is full
        if cache.count > maxCacheSize {
            cache.removeFirst()
        }
        
        // Persist to disk
        let fileURL = cacheDirectory.appendingPathComponent("\(key).json")
        let data = try JSONEncoder().encode(item)
        try data.write(to: fileURL)
    }
    
    public func retrieve(for key: String) async throws -> T? {
        // Check memory cache first
        if let cached = cache.first(where: { $0.key == key }) {
            return cached.value
        }
        
        // Check disk cache
        let fileURL = cacheDirectory.appendingPathComponent("\(key).json")
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        
        let data = try Data(contentsOf: fileURL)
        let item = try JSONDecoder().decode(T.self, from: data)
        
        // Add back to memory cache
        let cacheItem = CacheItem(key: key, value: item, timestamp: Date())
        cache.append(cacheItem)
        
        return item
    }
    
    public func clear() async {
        cache.removeAll()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}

private struct CacheItem<T> {
    let key: String
    let value: T
    let timestamp: Date
}

// MARK: - Async Data Pipeline

public struct AsyncDataPipeline {
    public static func processItems<T>(_ items: [T]) -> AsyncChannel<T> {
        let (stream, continuation) = AsyncChannel<T>.makeStream()
        
        Task {
            for item in items {
                // Simulate processing delay
                try? await Task.sleep(for: .milliseconds(10))
                continuation.yield(item)
            }
            continuation.finish()
        }
        
        return stream
    }
    
    public static func batchProcess<T, U>(
        _ items: [T],
        batchSize: Int = 10,
        transform: @escaping (T) async -> U
    ) -> AsyncChannel<[U]> {
        let (stream, continuation) = AsyncChannel<[U]>.makeStream()
        
        Task {
            for batch in items.chunked(into: batchSize) {
                let results = await withTaskGroup(of: U.self) { group in
                    for item in batch {
                        group.addTask {
                            await transform(item)
                        }
                    }
                    
                    var results: [U] = []
                    for await result in group {
                        results.append(result)
                    }
                    return results
                }
                
                continuation.yield(results)
            }
            continuation.finish()
        }
        
        return stream
    }
}

// MARK: - Performance Demo View

public struct PerformanceDemoView: View {
    @State private var performanceMonitor = PerformanceMonitor()
    @State private var items: [DemoItem] = []
    @State private var isLoading = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Performance Metrics
                PerformanceMetricsView(monitor: performanceMonitor)
                
                // High Performance List
                HighPerformanceListView(items: items) { item in
                    DemoItemRow(item: item)
                }
            }
            .navigationTitle("Performance Demo")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isLoading ? "Loading..." : "Load Data") {
                        loadData()
                    }
                    .disabled(isLoading)
                }
            }
        }
        .onAppear {
            performanceMonitor.startMonitoring()
            loadData()
        }
        .onDisappear {
            performanceMonitor.stopMonitoring()
        }
    }
    
    private func loadData() {
        isLoading = true
        
        Task {
            // Simulate loading large dataset
            let newItems = (1...1000).map { index in
                DemoItem(
                    id: "\(index)",
                    title: "Item \(index)",
                    subtitle: "Description for item \(index)",
                    imageURL: URL(string: "https://picsum.photos/100/100?random=\(index)")
                )
            }
            
            await MainActor.run {
                self.items = newItems
                self.isLoading = false
            }
        }
    }
}

// MARK: - Performance Metrics View

public struct PerformanceMetricsView: View {
    let monitor: PerformanceMonitor
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Performance Metrics")
                .font(.headline)
            
            HStack {
                MetricCard(
                    title: "Memory",
                    value: monitor.metrics.formattedMemoryUsage,
                    subtitle: "Max: \(monitor.metrics.formattedMaxMemoryUsage)"
                )
                
                MetricCard(
                    title: "Frame Rate",
                    value: monitor.metrics.formattedFrameRate,
                    subtitle: "Target: 60 fps"
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Demo Item

public struct DemoItem: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let imageURL: URL?
    
    public init(id: String, title: String, subtitle: String, imageURL: URL?) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

public struct DemoItemRow: View {
    let item: DemoItem
    
    public var body: some View {
        HStack(spacing: 12) {
            OptimizedAsyncImage(url: item.imageURL) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Array Extensions

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}