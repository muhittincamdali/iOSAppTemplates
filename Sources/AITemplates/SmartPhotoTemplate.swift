import SwiftUI
import CoreML
import Vision
import Photos
import AVFoundation
import ComposableArchitecture

// MARK: - Smart Photo AI Template

/// Advanced AI-powered photo analysis and enhancement template
/// Features: Core ML, Vision framework, on-device processing, Apple Intelligence ready
public struct SmartPhotoTemplate {
    public init() {}
}

// MARK: - Smart Photo App

@Reducer
public struct SmartPhotoApp {
    @ObservableState
    public struct State: Equatable {
        var photos: [SmartPhoto] = []
        var selectedPhoto: SmartPhoto?
        var analysisResults: [PhotoAnalysis] = []
        var isProcessing = false
        var currentMode: Mode = .gallery
        var aiEnhancements: [AIEnhancement] = []
        var searchQuery = ""
        var filteredPhotos: [SmartPhoto] = []
        
        public enum Mode: String, CaseIterable {
            case gallery = "Gallery"
            case analysis = "AI Analysis"
            case enhancement = "Enhancement"
            case search = "Smart Search"
            
            var icon: String {
                switch self {
                case .gallery: return "photo.on.rectangle"
                case .analysis: return "brain.head.profile"
                case .enhancement: return "wand.and.stars"
                case .search: return "magnifyingglass.circle"
                }
            }
        }
    }
    
    public enum Action: Equatable {
        case loadPhotos
        case photosLoaded([SmartPhoto])
        case selectPhoto(SmartPhoto)
        case changeModeForDemo(State.Mode)
        case analyzePhoto(SmartPhoto)
        case analysisCompleted(PhotoAnalysis)
        case enhancePhoto(SmartPhoto, AIEnhancement)
        case enhancementCompleted(SmartPhoto)
        case searchPhotos(String)
        case searchCompleted([SmartPhoto])
        case generateCaption(SmartPhoto)
        case captionGenerated(SmartPhoto, String)
        case classifyImage(SmartPhoto)
        case classificationCompleted(SmartPhoto, [ImageClassification])
    }
    
    @Dependency(\.photoAnalysisClient) var photoAnalysisClient
    @Dependency(\.photoEnhancementClient) var photoEnhancementClient
    @Dependency(\.photoSearchClient) var photoSearchClient
    @Dependency(\.aiCaptionClient) var aiCaptionClient
    @Dependency(\.imageClassificationClient) var imageClassificationClient
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadPhotos:
                state.isProcessing = true
                return .run { send in
                    let photos = try await photoAnalysisClient.loadPhotos()
                    await send(.photosLoaded(photos))
                }
                
            case .photosLoaded(let photos):
                state.isProcessing = false
                state.photos = photos
                state.filteredPhotos = photos
                return .none
                
            case .selectPhoto(let photo):
                state.selectedPhoto = photo
                return .none
                
            case .changeModeForDemo(let mode):
                state.currentMode = mode
                return .none
                
            case .analyzePhoto(let photo):
                state.isProcessing = true
                return .run { send in
                    let analysis = try await photoAnalysisClient.analyzePhoto(photo)
                    await send(.analysisCompleted(analysis))
                }
                
            case .analysisCompleted(let analysis):
                state.isProcessing = false
                state.analysisResults.append(analysis)
                return .none
                
            case .enhancePhoto(let photo, let enhancement):
                state.isProcessing = true
                return .run { send in
                    let enhancedPhoto = try await photoEnhancementClient.enhancePhoto(photo, enhancement)
                    await send(.enhancementCompleted(enhancedPhoto))
                }
                
            case .enhancementCompleted(let enhancedPhoto):
                state.isProcessing = false
                if let index = state.photos.firstIndex(where: { $0.id == enhancedPhoto.id }) {
                    state.photos[index] = enhancedPhoto
                }
                return .none
                
            case .searchPhotos(let query):
                state.searchQuery = query
                if query.isEmpty {
                    state.filteredPhotos = state.photos
                    return .none
                } else {
                    return .run { send in
                        let results = try await photoSearchClient.searchPhotos(query)
                        await send(.searchCompleted(results))
                    }
                }
                
            case .searchCompleted(let results):
                state.filteredPhotos = results
                return .none
                
            case .generateCaption(let photo):
                return .run { send in
                    let caption = try await aiCaptionClient.generateCaption(photo)
                    await send(.captionGenerated(photo, caption))
                }
                
            case .captionGenerated(let photo, let caption):
                if let index = state.photos.firstIndex(where: { $0.id == photo.id }) {
                    state.photos[index].aiGeneratedCaption = caption
                }
                return .none
                
            case .classifyImage(let photo):
                return .run { send in
                    let classifications = try await imageClassificationClient.classifyImage(photo)
                    await send(.classificationCompleted(photo, classifications))
                }
                
            case .classificationCompleted(let photo, let classifications):
                if let index = state.photos.firstIndex(where: { $0.id == photo.id }) {
                    state.photos[index].classifications = classifications
                }
                return .none
            }
        }
    }
}

// MARK: - Smart Photo App View

public struct SmartPhotoAppView: View {
    @Bindable var store: StoreOf<SmartPhotoApp>
    
    public var body: some View {
        NavigationSplitView {
            // Sidebar
            List {
                Section("AI Features") {
                    ForEach(SmartPhotoApp.State.Mode.allCases, id: \.self) { mode in
                        Button(action: { store.send(.changeModeForDemo(mode)) }) {
                            Label(mode.rawValue, systemImage: mode.icon)
                        }
                        .foregroundStyle(store.currentMode == mode ? .blue : .primary)
                    }
                }
                
                Section("Quick Actions") {
                    Button("Load Photos") {
                        store.send(.loadPhotos)
                    }
                    .disabled(store.isProcessing)
                    
                    if let selectedPhoto = store.selectedPhoto {
                        Button("Analyze Selected") {
                            store.send(.analyzePhoto(selectedPhoto))
                        }
                        .disabled(store.isProcessing)
                        
                        Button("Generate Caption") {
                            store.send(.generateCaption(selectedPhoto))
                        }
                        .disabled(store.isProcessing)
                        
                        Button("Classify Image") {
                            store.send(.classifyImage(selectedPhoto))
                        }
                        .disabled(store.isProcessing)
                    }
                }
                
                if store.isProcessing {
                    Section {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Processing...")
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Smart Photos")
        } detail: {
            // Main content
            Group {
                switch store.currentMode {
                case .gallery:
                    PhotoGalleryView(store: store)
                case .analysis:
                    AIAnalysisView(store: store)
                case .enhancement:
                    PhotoEnhancementView(store: store)
                case .search:
                    SmartSearchView(store: store)
                }
            }
        }
        .onAppear {
            if store.photos.isEmpty {
                store.send(.loadPhotos)
            }
        }
    }
}

// MARK: - Photo Gallery View

public struct PhotoGalleryView: View {
    @Bindable var store: StoreOf<SmartPhotoApp>
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(store.photos) { photo in
                    PhotoGridItem(
                        photo: photo,
                        isSelected: store.selectedPhoto?.id == photo.id,
                        onSelect: { store.send(.selectPhoto(photo)) }
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Photo Gallery")
        .overlay {
            if store.photos.isEmpty && store.isProcessing {
                ProgressView("Loading photos...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
            }
        }
    }
}

// MARK: - Photo Grid Item

public struct PhotoGridItem: View {
    let photo: SmartPhoto
    let isSelected: Bool
    let onSelect: () -> Void
    
    public var body: some View {
        VStack(spacing: 4) {
            AsyncImage(url: photo.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        ProgressView()
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? .blue : .clear, lineWidth: 2)
            }
            .overlay(alignment: .topTrailing) {
                if photo.hasAIAnalysis {
                    Image(systemName: "brain.head.profile.fill")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(4)
                        .background(.blue, in: Circle())
                        .padding(4)
                }
            }
            
            if let caption = photo.aiGeneratedCaption {
                Text(caption)
                    .font(.caption2)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
        .onTapGesture {
            onSelect()
        }
    }
}

// MARK: - AI Analysis View

public struct AIAnalysisView: View {
    @Bindable var store: StoreOf<SmartPhotoApp>
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let selectedPhoto = store.selectedPhoto {
                    SelectedPhotoAnalysisView(photo: selectedPhoto, store: store)
                } else {
                    ContentUnavailableView(
                        "No Photo Selected",
                        systemImage: "photo",
                        description: Text("Select a photo to see AI analysis")
                    )
                }
                
                if !store.analysisResults.isEmpty {
                    AnalysisResultsView(results: store.analysisResults)
                }
            }
            .padding()
        }
        .navigationTitle("AI Analysis")
    }
}

// MARK: - Selected Photo Analysis

public struct SelectedPhotoAnalysisView: View {
    let photo: SmartPhoto
    @Bindable var store: StoreOf<SmartPhotoApp>
    
    public var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: photo.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .frame(height: 300)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 12) {
                Text("AI Analysis")
                    .font(.headline)
                
                if let caption = photo.aiGeneratedCaption {
                    AnalysisRow(title: "Generated Caption", value: caption)
                }
                
                if !photo.classifications.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Classifications")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ForEach(photo.classifications.prefix(5), id: \.label) { classification in
                            HStack {
                                Text(classification.label)
                                Spacer()
                                Text("\(Int(classification.confidence * 100))%")
                                    .foregroundStyle(.secondary)
                            }
                            .font(.caption)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                if let analysis = store.analysisResults.first(where: { $0.photoId == photo.id }) {
                    AnalysisDetailView(analysis: analysis)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Analysis Row

public struct AnalysisRow: View {
    let title: String
    let value: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            Text(value)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Analysis Detail View

public struct AnalysisDetailView: View {
    let analysis: PhotoAnalysis
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Detailed Analysis")
                .font(.subheadline)
                .fontWeight(.medium)
            
            if !analysis.detectedObjects.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Detected Objects")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    ForEach(analysis.detectedObjects, id: \.id) { object in
                        HStack {
                            Text(object.label)
                            Spacer()
                            Text("\(Int(object.confidence * 100))%")
                                .foregroundStyle(.secondary)
                        }
                        .font(.caption2)
                    }
                }
            }
            
            if !analysis.detectedText.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Detected Text")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    ForEach(analysis.detectedText, id: \.self) { text in
                        Text(text)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
            }
            
            if let dominantColors = analysis.dominantColors, !dominantColors.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dominant Colors")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    HStack {
                        ForEach(dominantColors.prefix(5), id: \.self) { color in
                            Rectangle()
                                .fill(Color(color))
                                .frame(width: 30, height: 20)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Analysis Results View

public struct AnalysisResultsView: View {
    let results: [PhotoAnalysis]
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Analysis Results")
                .font(.headline)
            
            ForEach(results.suffix(3), id: \.id) { result in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Photo Analysis")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("Objects: \(result.detectedObjects.count)")
                        .font(.caption)
                    
                    Text("Text elements: \(result.detectedText.count)")
                        .font(.caption)
                    
                    Text("Processing time: \(result.processingTime, specifier: "%.2f")s")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Photo Enhancement View

public struct PhotoEnhancementView: View {
    @Bindable var store: StoreOf<SmartPhotoApp>
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let selectedPhoto = store.selectedPhoto {
                    PhotoEnhancementControlsView(photo: selectedPhoto, store: store)
                } else {
                    ContentUnavailableView(
                        "No Photo Selected",
                        systemImage: "wand.and.stars",
                        description: Text("Select a photo to apply AI enhancements")
                    )
                }
            }
            .padding()
        }
        .navigationTitle("AI Enhancement")
    }
}

// MARK: - Photo Enhancement Controls

public struct PhotoEnhancementControlsView: View {
    let photo: SmartPhoto
    @Bindable var store: StoreOf<SmartPhotoApp>
    
    private let enhancements: [AIEnhancement] = AIEnhancement.allCases
    
    public var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: photo.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .frame(height: 300)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 16) {
                Text("AI Enhancements")
                    .font(.headline)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(enhancements, id: \.self) { enhancement in
                        EnhancementButton(
                            enhancement: enhancement,
                            isProcessing: store.isProcessing,
                            onTap: {
                                store.send(.enhancePhoto(photo, enhancement))
                            }
                        )
                    }
                }
                
                if !photo.appliedEnhancements.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Applied Enhancements")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ForEach(photo.appliedEnhancements, id: \.self) { enhancement in
                            HStack {
                                Image(systemName: enhancement.icon)
                                Text(enhancement.displayName)
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.green.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Enhancement Button

public struct EnhancementButton: View {
    let enhancement: AIEnhancement
    let isProcessing: Bool
    let onTap: () -> Void
    
    public var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: enhancement.icon)
                    .font(.title2)
                
                Text(enhancement.displayName)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(isProcessing)
        .opacity(isProcessing ? 0.6 : 1.0)
    }
}

// MARK: - Smart Search View

public struct SmartSearchView: View {
    @Bindable var store: StoreOf<SmartPhotoApp>
    @State private var searchText = ""
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    public var body: some View {
        VStack(spacing: 16) {
            SearchBar(text: $searchText) { query in
                store.send(.searchPhotos(query))
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(store.filteredPhotos) { photo in
                        PhotoGridItem(
                            photo: photo,
                            isSelected: store.selectedPhoto?.id == photo.id,
                            onSelect: { store.send(.selectPhoto(photo)) }
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Smart Search")
    }
}

// MARK: - Search Bar

public struct SearchBar: View {
    @Binding var text: String
    let onSubmit: (String) -> Void
    
    public var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("Search photos by content, objects, or text...", text: $text)
                .textFieldStyle(.plain)
                .onSubmit {
                    onSubmit(text)
                }
            
            if !text.isEmpty {
                Button("Clear") {
                    text = ""
                    onSubmit("")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
}

// MARK: - Models

public struct SmartPhoto: Identifiable, Equatable, Codable {
    public let id: String
    public let imageURL: URL
    public let createdAt: Date
    public var aiGeneratedCaption: String?
    public var classifications: [ImageClassification]
    public var hasAIAnalysis: Bool
    public var appliedEnhancements: [AIEnhancement]
    public var metadata: PhotoMetadata?
    
    public init(
        id: String = UUID().uuidString,
        imageURL: URL,
        createdAt: Date = Date(),
        aiGeneratedCaption: String? = nil,
        classifications: [ImageClassification] = [],
        hasAIAnalysis: Bool = false,
        appliedEnhancements: [AIEnhancement] = [],
        metadata: PhotoMetadata? = nil
    ) {
        self.id = id
        self.imageURL = imageURL
        self.createdAt = createdAt
        self.aiGeneratedCaption = aiGeneratedCaption
        self.classifications = classifications
        self.hasAIAnalysis = hasAIAnalysis
        self.appliedEnhancements = appliedEnhancements
        self.metadata = metadata
    }
}

public struct ImageClassification: Equatable, Codable {
    public let label: String
    public let confidence: Float
    
    public init(label: String, confidence: Float) {
        self.label = label
        self.confidence = confidence
    }
}

public struct PhotoAnalysis: Identifiable, Equatable, Codable {
    public let id: String
    public let photoId: String
    public let detectedObjects: [DetectedObject]
    public let detectedText: [String]
    public let dominantColors: [PhotoColor]?
    public let processingTime: Double
    public let createdAt: Date
    
    public init(
        id: String = UUID().uuidString,
        photoId: String,
        detectedObjects: [DetectedObject] = [],
        detectedText: [String] = [],
        dominantColors: [PhotoColor]? = nil,
        processingTime: Double,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.photoId = photoId
        self.detectedObjects = detectedObjects
        self.detectedText = detectedText
        self.dominantColors = dominantColors
        self.processingTime = processingTime
        self.createdAt = createdAt
    }
}

public struct DetectedObject: Identifiable, Equatable, Codable {
    public let id: String
    public let label: String
    public let confidence: Float
    public let boundingBox: BoundingBox
    
    public init(
        id: String = UUID().uuidString,
        label: String,
        confidence: Float,
        boundingBox: BoundingBox
    ) {
        self.id = id
        self.label = label
        self.confidence = confidence
        self.boundingBox = boundingBox
    }
}

public struct BoundingBox: Equatable, Codable {
    public let x: Float
    public let y: Float
    public let width: Float
    public let height: Float
    
    public init(x: Float, y: Float, width: Float, height: Float) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
}

public struct PhotoColor: Equatable, Codable, Hashable {
    public let red: Float
    public let green: Float
    public let blue: Float
    public let alpha: Float
    
    public init(red: Float, green: Float, blue: Float, alpha: Float = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}

extension Color {
    init(_ photoColor: PhotoColor) {
        self.init(
            red: Double(photoColor.red),
            green: Double(photoColor.green),
            blue: Double(photoColor.blue),
            opacity: Double(photoColor.alpha)
        )
    }
}

public struct PhotoMetadata: Equatable, Codable {
    public let camera: String?
    public let location: String?
    public let dimensions: PhotoDimensions
    public let fileSize: Int64
    
    public init(
        camera: String? = nil,
        location: String? = nil,
        dimensions: PhotoDimensions,
        fileSize: Int64
    ) {
        self.camera = camera
        self.location = location
        self.dimensions = dimensions
        self.fileSize = fileSize
    }
}

public struct PhotoDimensions: Equatable, Codable {
    public let width: Int
    public let height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

public enum AIEnhancement: String, CaseIterable, Codable {
    case autoEnhance = "autoEnhance"
    case denoise = "denoise"
    case sharpen = "sharpen"
    case colorCorrection = "colorCorrection"
    case exposureCorrection = "exposureCorrection"
    case backgroundRemoval = "backgroundRemoval"
    case faceEnhancement = "faceEnhancement"
    case artisticFilter = "artisticFilter"
    
    public var displayName: String {
        switch self {
        case .autoEnhance: return "Auto Enhance"
        case .denoise: return "Denoise"
        case .sharpen: return "Sharpen"
        case .colorCorrection: return "Color Correct"
        case .exposureCorrection: return "Fix Exposure"
        case .backgroundRemoval: return "Remove Background"
        case .faceEnhancement: return "Enhance Faces"
        case .artisticFilter: return "Artistic Filter"
        }
    }
    
    public var icon: String {
        switch self {
        case .autoEnhance: return "wand.and.stars"
        case .denoise: return "noise.reduction"
        case .sharpen: return "focus"
        case .colorCorrection: return "paintpalette"
        case .exposureCorrection: return "sun.max"
        case .backgroundRemoval: return "person.crop.rectangle"
        case .faceEnhancement: return "face.smiling"
        case .artisticFilter: return "camera.filters"
        }
    }
}

// MARK: - Dependencies

extension DependencyValues {
    public var photoAnalysisClient: PhotoAnalysisClient {
        get { self[PhotoAnalysisClientKey.self] }
        set { self[PhotoAnalysisClientKey.self] = newValue }
    }
    
    public var photoEnhancementClient: PhotoEnhancementClient {
        get { self[PhotoEnhancementClientKey.self] }
        set { self[PhotoEnhancementClientKey.self] = newValue }
    }
    
    public var photoSearchClient: PhotoSearchClient {
        get { self[PhotoSearchClientKey.self] }
        set { self[PhotoSearchClientKey.self] = newValue }
    }
    
    public var aiCaptionClient: AICaptionClient {
        get { self[AICaptionClientKey.self] }
        set { self[AICaptionClientKey.self] = newValue }
    }
    
    public var imageClassificationClient: ImageClassificationClient {
        get { self[ImageClassificationClientKey.self] }
        set { self[ImageClassificationClientKey.self] = newValue }
    }
}

private enum PhotoAnalysisClientKey: DependencyKey {
    static let liveValue = PhotoAnalysisClient.live
}

private enum PhotoEnhancementClientKey: DependencyKey {
    static let liveValue = PhotoEnhancementClient.live
}

private enum PhotoSearchClientKey: DependencyKey {
    static let liveValue = PhotoSearchClient.live
}

private enum AICaptionClientKey: DependencyKey {
    static let liveValue = AICaptionClient.live
}

private enum ImageClassificationClientKey: DependencyKey {
    static let liveValue = ImageClassificationClient.live
}

// MARK: - Clients

public struct PhotoAnalysisClient {
    public var loadPhotos: @Sendable () async throws -> [SmartPhoto]
    public var analyzePhoto: @Sendable (SmartPhoto) async throws -> PhotoAnalysis
    
    public static let live = PhotoAnalysisClient(
        loadPhotos: {
            try await Task.sleep(for: .seconds(1))
            return mockSmartPhotos
        },
        analyzePhoto: { photo in
            try await Task.sleep(for: .seconds(2))
            return PhotoAnalysis(
                photoId: photo.id,
                detectedObjects: [
                    DetectedObject(label: "Person", confidence: 0.95, boundingBox: BoundingBox(x: 0.2, y: 0.1, width: 0.6, height: 0.8)),
                    DetectedObject(label: "Tree", confidence: 0.87, boundingBox: BoundingBox(x: 0.7, y: 0.0, width: 0.3, height: 0.5))
                ],
                detectedText: ["Welcome", "2024"],
                dominantColors: [
                    PhotoColor(red: 0.2, green: 0.6, blue: 0.8),
                    PhotoColor(red: 0.9, green: 0.7, blue: 0.3),
                    PhotoColor(red: 0.1, green: 0.8, blue: 0.2)
                ],
                processingTime: 1.23
            )
        }
    )
}

public struct PhotoEnhancementClient {
    public var enhancePhoto: @Sendable (SmartPhoto, AIEnhancement) async throws -> SmartPhoto
    
    public static let live = PhotoEnhancementClient(
        enhancePhoto: { photo, enhancement in
            try await Task.sleep(for: .seconds(1.5))
            var enhancedPhoto = photo
            enhancedPhoto.appliedEnhancements.append(enhancement)
            return enhancedPhoto
        }
    )
}

public struct PhotoSearchClient {
    public var searchPhotos: @Sendable (String) async throws -> [SmartPhoto]
    
    public static let live = PhotoSearchClient(
        searchPhotos: { query in
            try await Task.sleep(for: .milliseconds(500))
            return mockSmartPhotos.filter { photo in
                photo.aiGeneratedCaption?.localizedCaseInsensitiveContains(query) == true ||
                photo.classifications.contains { $0.label.localizedCaseInsensitiveContains(query) }
            }
        }
    )
}

public struct AICaptionClient {
    public var generateCaption: @Sendable (SmartPhoto) async throws -> String
    
    public static let live = AICaptionClient(
        generateCaption: { _ in
            try await Task.sleep(for: .seconds(1))
            let captions = [
                "A beautiful landscape with mountains in the background",
                "A person walking through a forest path",
                "City skyline at sunset with vibrant colors",
                "Close-up of flowers in a garden",
                "Beach scene with waves and clear blue sky"
            ]
            return captions.randomElement()!
        }
    )
}

public struct ImageClassificationClient {
    public var classifyImage: @Sendable (SmartPhoto) async throws -> [ImageClassification]
    
    public static let live = ImageClassificationClient(
        classifyImage: { _ in
            try await Task.sleep(for: .seconds(1))
            return [
                ImageClassification(label: "Nature", confidence: 0.92),
                ImageClassification(label: "Landscape", confidence: 0.88),
                ImageClassification(label: "Outdoor", confidence: 0.85),
                ImageClassification(label: "Scenic", confidence: 0.79),
                ImageClassification(label: "Photography", confidence: 0.73)
            ]
        }
    )
}

// MARK: - Mock Data

private let mockSmartPhotos = [
    SmartPhoto(
        imageURL: URL(string: "https://picsum.photos/800/600?random=1")!,
        aiGeneratedCaption: "A serene mountain landscape with pine trees",
        classifications: [
            ImageClassification(label: "Mountain", confidence: 0.95),
            ImageClassification(label: "Nature", confidence: 0.89),
            ImageClassification(label: "Landscape", confidence: 0.87)
        ],
        hasAIAnalysis: true,
        metadata: PhotoMetadata(
            camera: "iPhone 15 Pro",
            location: "Rocky Mountains, CO",
            dimensions: PhotoDimensions(width: 4032, height: 3024),
            fileSize: 3247892
        )
    ),
    SmartPhoto(
        imageURL: URL(string: "https://picsum.photos/800/600?random=2")!,
        aiGeneratedCaption: "Urban architecture with modern buildings",
        classifications: [
            ImageClassification(label: "Architecture", confidence: 0.93),
            ImageClassification(label: "Building", confidence: 0.91),
            ImageClassification(label: "Urban", confidence: 0.85)
        ],
        hasAIAnalysis: true,
        appliedEnhancements: [.autoEnhance, .colorCorrection],
        metadata: PhotoMetadata(
            camera: "iPhone 15 Pro Max",
            location: "San Francisco, CA",
            dimensions: PhotoDimensions(width: 4032, height: 3024),
            fileSize: 2856743
        )
    ),
    SmartPhoto(
        imageURL: URL(string: "https://picsum.photos/800/600?random=3")!,
        aiGeneratedCaption: "Tropical beach with crystal clear water",
        classifications: [
            ImageClassification(label: "Beach", confidence: 0.97),
            ImageClassification(label: "Water", confidence: 0.94),
            ImageClassification(label: "Tropical", confidence: 0.88)
        ],
        hasAIAnalysis: true,
        appliedEnhancements: [.exposureCorrection],
        metadata: PhotoMetadata(
            camera: "iPhone 15",
            location: "Maui, HI",
            dimensions: PhotoDimensions(width: 3024, height: 4032),
            fileSize: 4123567
        )
    ),
    SmartPhoto(
        imageURL: URL(string: "https://picsum.photos/800/600?random=4")!,
        classifications: [
            ImageClassification(label: "Portrait", confidence: 0.89),
            ImageClassification(label: "Person", confidence: 0.94)
        ],
        metadata: PhotoMetadata(
            dimensions: PhotoDimensions(width: 2316, height: 3088),
            fileSize: 1892345
        )
    ),
    SmartPhoto(
        imageURL: URL(string: "https://picsum.photos/800/600?random=5")!,
        aiGeneratedCaption: "Colorful flower garden in full bloom",
        classifications: [
            ImageClassification(label: "Flower", confidence: 0.96),
            ImageClassification(label: "Garden", confidence: 0.91),
            ImageClassification(label: "Nature", confidence: 0.89)
        ],
        hasAIAnalysis: true,
        appliedEnhancements: [.colorCorrection, .sharpen],
        metadata: PhotoMetadata(
            camera: "iPhone 15 Pro",
            dimensions: PhotoDimensions(width: 4032, height: 3024),
            fileSize: 3456789
        )
    )
]