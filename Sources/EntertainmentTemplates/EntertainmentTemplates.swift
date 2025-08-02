import Foundation
import SwiftUI
import AVFoundation
import MediaPlayer

// MARK: - Entertainment Templates
public struct EntertainmentTemplates {
    
    // MARK: - Version
    public static let version = "1.0.0"
    
    // MARK: - Initialization
    public static func initialize() {
        print("🎮 Entertainment Templates v\(version) initialized")
    }
}

// MARK: - Gaming App Template
public struct GamingAppTemplate {
    
    // MARK: - Models
    public struct Game: Identifiable, Codable {
        public let id: String
        public let title: String
        public let description: String?
        public let genre: GameGenre
        public let platform: GamePlatform
        public let rating: GameRating
        public let releaseDate: Date?
        public let developer: String
        public let publisher: String?
        public let price: Double?
        public let isFree: Bool
        public let imageURL: String?
        public let videoURL: String?
        public let screenshots: [String]
        public let systemRequirements: SystemRequirements?
        public let userRating: Double?
        public let reviewCount: Int
        public let isInstalled: Bool
        public let isFavorite: Bool
        public let playTime: TimeInterval
        public let lastPlayed: Date?
        public let achievements: [Achievement]
        public let tags: [String]
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            description: String? = nil,
            genre: GameGenre,
            platform: GamePlatform,
            rating: GameRating = .everyone,
            releaseDate: Date? = nil,
            developer: String,
            publisher: String? = nil,
            price: Double? = nil,
            isFree: Bool = false,
            imageURL: String? = nil,
            videoURL: String? = nil,
            screenshots: [String] = [],
            systemRequirements: SystemRequirements? = nil,
            userRating: Double? = nil,
            reviewCount: Int = 0,
            isInstalled: Bool = false,
            isFavorite: Bool = false,
            playTime: TimeInterval = 0,
            lastPlayed: Date? = nil,
            achievements: [Achievement] = [],
            tags: [String] = [],
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.genre = genre
            self.platform = platform
            self.rating = rating
            self.releaseDate = releaseDate
            self.developer = developer
            self.publisher = publisher
            self.price = price
            self.isFree = isFree
            self.imageURL = imageURL
            self.videoURL = videoURL
            self.screenshots = screenshots
            self.systemRequirements = systemRequirements
            self.userRating = userRating
            self.reviewCount = reviewCount
            self.isInstalled = isInstalled
            self.isFavorite = isFavorite
            self.playTime = playTime
            self.lastPlayed = lastPlayed
            self.achievements = achievements
            self.tags = tags
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
    
    public struct Achievement: Identifiable, Codable {
        public let id: String
        public let title: String
        public let description: String
        public let iconURL: String?
        public let isUnlocked: Bool
        public let unlockDate: Date?
        public let rarity: AchievementRarity
        public let points: Int
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            description: String,
            iconURL: String? = nil,
            isUnlocked: Bool = false,
            unlockDate: Date? = nil,
            rarity: AchievementRarity = .common,
            points: Int = 0
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.iconURL = iconURL
            self.isUnlocked = isUnlocked
            self.unlockDate = unlockDate
            self.rarity = rarity
            self.points = points
        }
    }
    
    public struct SystemRequirements: Codable {
        public let minimumOS: String
        public let recommendedOS: String?
        public let minimumRAM: String
        public let recommendedRAM: String?
        public let minimumStorage: String
        public let recommendedStorage: String?
        public let minimumGraphics: String?
        public let recommendedGraphics: String?
        public let minimumProcessor: String?
        public let recommendedProcessor: String?
        
        public init(
            minimumOS: String,
            recommendedOS: String? = nil,
            minimumRAM: String,
            recommendedRAM: String? = nil,
            minimumStorage: String,
            recommendedStorage: String? = nil,
            minimumGraphics: String? = nil,
            recommendedGraphics: String? = nil,
            minimumProcessor: String? = nil,
            recommendedProcessor: String? = nil
        ) {
            self.minimumOS = minimumOS
            self.recommendedOS = recommendedOS
            self.minimumRAM = minimumRAM
            self.recommendedRAM = recommendedRAM
            self.minimumStorage = minimumStorage
            self.recommendedStorage = recommendedStorage
            self.minimumGraphics = minimumGraphics
            self.recommendedGraphics = recommendedGraphics
            self.minimumProcessor = minimumProcessor
            self.recommendedProcessor = recommendedProcessor
        }
    }
    
    public struct GameSession: Identifiable, Codable {
        public let id: String
        public let gameId: String
        public let startTime: Date
        public let endTime: Date?
        public let duration: TimeInterval
        public let achievements: [Achievement]
        public let score: Int?
        public let level: Int?
        public let notes: String?
        
        public init(
            id: String = UUID().uuidString,
            gameId: String,
            startTime: Date,
            endTime: Date? = nil,
            duration: TimeInterval = 0,
            achievements: [Achievement] = [],
            score: Int? = nil,
            level: Int? = nil,
            notes: String? = nil
        ) {
            self.id = id
            self.gameId = gameId
            self.startTime = startTime
            self.endTime = endTime
            self.duration = duration
            self.achievements = achievements
            self.score = score
            self.level = level
            self.notes = notes
        }
    }
    
    public struct GameCollection: Identifiable, Codable {
        public let id: String
        public let name: String
        public let description: String?
        public let games: [Game]
        public let isPublic: Bool
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            description: String? = nil,
            games: [Game] = [],
            isPublic: Bool = false,
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.games = games
            self.isPublic = isPublic
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
    
    public struct GameReview: Identifiable, Codable {
        public let id: String
        public let gameId: String
        public let userId: String
        public let username: String
        public let rating: Int
        public let title: String
        public let content: String
        public let isVerified: Bool
        public let helpfulCount: Int
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            gameId: String,
            userId: String,
            username: String,
            rating: Int,
            title: String,
            content: String,
            isVerified: Bool = false,
            helpfulCount: Int = 0,
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.gameId = gameId
            self.userId = userId
            self.username = username
            self.rating = rating
            self.title = title
            self.content = content
            self.isVerified = isVerified
            self.helpfulCount = helpfulCount
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
    
    // MARK: - Enums
    public enum GameGenre: String, CaseIterable, Codable {
        case action = "action"
        case adventure = "adventure"
        case rpg = "rpg"
        case strategy = "strategy"
        case simulation = "simulation"
        case sports = "sports"
        case racing = "racing"
        case puzzle = "puzzle"
        case platformer = "platformer"
        case shooter = "shooter"
        case fighting = "fighting"
        case horror = "horror"
        case indie = "indie"
        case casual = "casual"
        case educational = "educational"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .action: return "Action"
            case .adventure: return "Adventure"
            case .rpg: return "RPG"
            case .strategy: return "Strategy"
            case .simulation: return "Simulation"
            case .sports: return "Sports"
            case .racing: return "Racing"
            case .puzzle: return "Puzzle"
            case .platformer: return "Platformer"
            case .shooter: return "Shooter"
            case .fighting: return "Fighting"
            case .horror: return "Horror"
            case .indie: return "Indie"
            case .casual: return "Casual"
            case .educational: return "Educational"
            case .other: return "Other"
            }
        }
        
        public var icon: String {
            switch self {
            case .action: return "bolt.fill"
            case .adventure: return "map.fill"
            case .rpg: return "person.3.fill"
            case .strategy: return "brain.head.profile"
            case .simulation: return "car.fill"
            case .sports: return "sportscourt.fill"
            case .racing: return "flag.checkered"
            case .puzzle: return "puzzlepiece.fill"
            case .platformer: return "arrow.up.circle.fill"
            case .shooter: return "target"
            case .fighting: return "hand.raised.fill"
            case .horror: return "eye.trianglebadge.exclamationmark"
            case .indie: return "star.fill"
            case .casual: return "gamecontroller"
            case .educational: return "book.fill"
            case .other: return "ellipsis.circle"
            }
        }
    }
    
    public enum GamePlatform: String, CaseIterable, Codable {
        case ios = "ios"
        case android = "android"
        case windows = "windows"
        case mac = "mac"
        case linux = "linux"
        case ps4 = "ps4"
        case ps5 = "ps5"
        case xboxOne = "xbox_one"
        case xboxSeries = "xbox_series"
        case nintendoSwitch = "nintendo_switch"
        case pc = "pc"
        case web = "web"
        
        public var displayName: String {
            switch self {
            case .ios: return "iOS"
            case .android: return "Android"
            case .windows: return "Windows"
            case .mac: return "macOS"
            case .linux: return "Linux"
            case .ps4: return "PlayStation 4"
            case .ps5: return "PlayStation 5"
            case .xboxOne: return "Xbox One"
            case .xboxSeries: return "Xbox Series"
            case .nintendoSwitch: return "Nintendo Switch"
            case .pc: return "PC"
            case .web: return "Web"
            }
        }
    }
    
    public enum GameRating: String, CaseIterable, Codable {
        case everyone = "everyone"
        case everyone10 = "everyone_10"
        case teen = "teen"
        case mature = "mature"
        case adultsOnly = "adults_only"
        case ratingPending = "rating_pending"
        
        public var displayName: String {
            switch self {
            case .everyone: return "Everyone"
            case .everyone10: return "Everyone 10+"
            case .teen: return "Teen"
            case .mature: return "Mature"
            case .adultsOnly: return "Adults Only"
            case .ratingPending: return "Rating Pending"
            }
        }
    }
    
    public enum AchievementRarity: String, CaseIterable, Codable {
        case common = "common"
        case uncommon = "uncommon"
        case rare = "rare"
        case epic = "epic"
        case legendary = "legendary"
        
        public var displayName: String {
            switch self {
            case .common: return "Common"
            case .uncommon: return "Uncommon"
            case .rare: return "Rare"
            case .epic: return "Epic"
            case .legendary: return "Legendary"
            }
        }
        
        public var color: String {
            switch self {
            case .common: return "gray"
            case .uncommon: return "green"
            case .rare: return "blue"
            case .epic: return "purple"
            case .legendary: return "orange"
            }
        }
    }
    
    // MARK: - Managers
    public class GameManager: ObservableObject {
        
        @Published public var games: [Game] = []
        @Published public var collections: [GameCollection] = []
        @Published public var sessions: [GameSession] = []
        @Published public var reviews: [GameReview] = []
        @Published public var isLoading = false
        
        private let audioManager = AudioManager()
        private let saveManager = SaveManager()
        
        public init() {}
        
        // MARK: - Game Methods
        
        public func addGame(_ game: Game) async throws {
            isLoading = true
            defer { isLoading = false }
            
            games.append(game)
            try await saveManager.saveGames(games)
        }
        
        public func updateGame(_ game: Game) async throws {
            guard let index = games.firstIndex(where: { $0.id == game.id }) else {
                throw GameError.gameNotFound
            }
            
            isLoading = true
            defer { isLoading = false }
            
            games[index] = game
            try await saveManager.saveGames(games)
        }
        
        public func removeGame(_ gameId: String) async throws {
            guard let index = games.firstIndex(where: { $0.id == gameId }) else {
                throw GameError.gameNotFound
            }
            
            isLoading = true
            defer { isLoading = false }
            
            games.remove(at: index)
            try await saveManager.saveGames(games)
        }
        
        public func toggleFavorite(_ gameId: String) async throws {
            guard let index = games.firstIndex(where: { $0.id == gameId }) else {
                throw GameError.gameNotFound
            }
            
            var game = games[index]
            game.isFavorite.toggle()
            try await updateGame(game)
        }
        
        public func getGamesByGenre(_ genre: GameGenre) -> [Game] {
            return games.filter { $0.genre == genre }
        }
        
        public func getGamesByPlatform(_ platform: GamePlatform) -> [Game] {
            return games.filter { $0.platform == platform }
        }
        
        public func getFavoriteGames() -> [Game] {
            return games.filter { $0.isFavorite }
        }
        
        public func getInstalledGames() -> [Game] {
            return games.filter { $0.isInstalled }
        }
        
        public func searchGames(query: String) -> [Game] {
            let lowercasedQuery = query.lowercased()
            return games.filter { game in
                game.title.lowercased().contains(lowercasedQuery) ||
                game.description?.lowercased().contains(lowercasedQuery) == true ||
                game.developer.lowercased().contains(lowercasedQuery) ||
                game.tags.contains { $0.lowercased().contains(lowercasedQuery) }
            }
        }
        
        // MARK: - Session Methods
        
        public func startGameSession(gameId: String) async throws {
            let session = GameSession(
                gameId: gameId,
                startTime: Date()
            )
            
            sessions.append(session)
            try await saveManager.saveSessions(sessions)
        }
        
        public func endGameSession(sessionId: String) async throws {
            guard let index = sessions.firstIndex(where: { $0.id == sessionId }) else {
                throw GameError.sessionNotFound
            }
            
            var session = sessions[index]
            session.endTime = Date()
            session.duration = session.endTime!.timeIntervalSince(session.startTime)
            
            sessions[index] = session
            try await saveManager.saveSessions(sessions)
            
            // Update game play time
            if let gameIndex = games.firstIndex(where: { $0.id == session.gameId }) {
                var game = games[gameIndex]
                game.playTime += session.duration
                game.lastPlayed = Date()
                try await updateGame(game)
            }
        }
        
        public func getGameSessions(gameId: String) -> [GameSession] {
            return sessions.filter { $0.gameId == gameId }
        }
        
        public func getTotalPlayTime(gameId: String) -> TimeInterval {
            return sessions
                .filter { $0.gameId == gameId }
                .reduce(0) { $0 + $1.duration }
        }
        
        // MARK: - Collection Methods
        
        public func createCollection(_ collection: GameCollection) async throws {
            collections.append(collection)
            try await saveManager.saveCollections(collections)
        }
        
        public func updateCollection(_ collection: GameCollection) async throws {
            guard let index = collections.firstIndex(where: { $0.id == collection.id }) else {
                throw GameError.collectionNotFound
            }
            
            collections[index] = collection
            try await saveManager.saveCollections(collections)
        }
        
        public func deleteCollection(_ collectionId: String) async throws {
            guard let index = collections.firstIndex(where: { $0.id == collectionId }) else {
                throw GameError.collectionNotFound
            }
            
            collections.remove(at: index)
            try await saveManager.saveCollections(collections)
        }
        
        // MARK: - Review Methods
        
        public func addReview(_ review: GameReview) async throws {
            reviews.append(review)
            try await saveManager.saveReviews(reviews)
        }
        
        public func getGameReviews(gameId: String) -> [GameReview] {
            return reviews.filter { $0.gameId == gameId }
        }
        
        public func getAverageRating(gameId: String) -> Double {
            let gameReviews = getGameReviews(gameId: gameId)
            guard !gameReviews.isEmpty else { return 0 }
            
            let totalRating = gameReviews.reduce(0) { $0 + $1.rating }
            return Double(totalRating) / Double(gameReviews.count)
        }
    }
    
    public class AudioManager {
        
        private var audioPlayer: AVAudioPlayer?
        
        public init() {}
        
        public func playSound(named soundName: String) {
            guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
                print("Sound file not found: \(soundName)")
                return
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        }
        
        public func stopSound() {
            audioPlayer?.stop()
        }
    }
    
    public class SaveManager {
        
        private let userDefaults = UserDefaults.standard
        
        public init() {}
        
        public func saveGames(_ games: [Game]) async throws {
            let data = try JSONEncoder().encode(games)
            userDefaults.set(data, forKey: "saved_games")
        }
        
        public func loadGames() async throws -> [Game] {
            guard let data = userDefaults.data(forKey: "saved_games") else {
                return []
            }
            
            return try JSONDecoder().decode([Game].self, from: data)
        }
        
        public func saveSessions(_ sessions: [GameSession]) async throws {
            let data = try JSONEncoder().encode(sessions)
            userDefaults.set(data, forKey: "game_sessions")
        }
        
        public func loadSessions() async throws -> [GameSession] {
            guard let data = userDefaults.data(forKey: "game_sessions") else {
                return []
            }
            
            return try JSONDecoder().decode([GameSession].self, from: data)
        }
        
        public func saveCollections(_ collections: [GameCollection]) async throws {
            let data = try JSONEncoder().encode(collections)
            userDefaults.set(data, forKey: "game_collections")
        }
        
        public func loadCollections() async throws -> [GameCollection] {
            guard let data = userDefaults.data(forKey: "game_collections") else {
                return []
            }
            
            return try JSONDecoder().decode([GameCollection].self, from: data)
        }
        
        public func saveReviews(_ reviews: [GameReview]) async throws {
            let data = try JSONEncoder().encode(reviews)
            userDefaults.set(data, forKey: "game_reviews")
        }
        
        public func loadReviews() async throws -> [GameReview] {
            guard let data = userDefaults.data(forKey: "game_reviews") else {
                return []
            }
            
            return try JSONDecoder().decode([GameReview].self, from: data)
        }
    }
    
    // MARK: - UI Components
    
    public struct GameCard: View {
        let game: Game
        let onTap: () -> Void
        let onFavorite: () -> Void
        
        public init(game: Game, onTap: @escaping () -> Void, onFavorite: @escaping () -> Void) {
            self.game = game
            self.onTap = onTap
            self.onFavorite = onFavorite
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                // Game Image
                if let imageURL = game.imageURL {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "gamecontroller")
                                    .foregroundColor(.gray)
                            )
                    }
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 120)
                        .cornerRadius(8)
                        .overlay(
                            Image(systemName: "gamecontroller")
                                .foregroundColor(.gray)
                                .font(.title)
                        )
                }
                
                // Game Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(game.title)
                            .font(.headline)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        Button(action: onFavorite) {
                            Image(systemName: game.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(game.isFavorite ? .red : .gray)
                        }
                    }
                    
                    Text(game.genre.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(game.platform.displayName)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(4)
                        
                        if let userRating = game.userRating {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                Text(String(format: "%.1f", userRating))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        if game.isFree {
                            Text("FREE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        } else if let price = game.price {
                            Text("$\(String(format: "%.2f", price))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            .onTapGesture {
                onTap()
            }
        }
    }
    
    public struct AchievementCard: View {
        let achievement: Achievement
        let onTap: () -> Void
        
        public init(achievement: Achievement, onTap: @escaping () -> Void) {
            self.achievement = achievement
            self.onTap = onTap
        }
        
        public var body: some View {
            HStack(spacing: 12) {
                // Achievement Icon
                if let iconURL = achievement.iconURL {
                    AsyncImage(url: URL(string: iconURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Image(systemName: achievement.isUnlocked ? "trophy.fill" : "trophy")
                            .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                    }
                    .frame(width: 40, height: 40)
                } else {
                    Image(systemName: achievement.isUnlocked ? "trophy.fill" : "trophy")
                        .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                        .font(.title2)
                        .frame(width: 40, height: 40)
                }
                
                // Achievement Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(achievement.title)
                        .font(.headline)
                        .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                    
                    Text(achievement.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack {
                        Text(achievement.rarity.displayName)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(achievement.rarity.color).opacity(0.2))
                            .foregroundColor(Color(achievement.rarity.color))
                            .cornerRadius(4)
                        
                        if achievement.isUnlocked {
                            Text("\(achievement.points) pts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if achievement.isUnlocked, let unlockDate = achievement.unlockDate {
                            Text(unlockDate, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .opacity(achievement.isUnlocked ? 1.0 : 0.6)
            .onTapGesture {
                onTap()
            }
        }
    }
    
    // MARK: - Errors
    
    public enum GameError: LocalizedError {
        case gameNotFound
        case sessionNotFound
        case collectionNotFound
        case reviewNotFound
        case invalidData
        case networkError
        case saveError
        
        public var errorDescription: String? {
            switch self {
            case .gameNotFound:
                return "Game not found"
            case .sessionNotFound:
                return "Game session not found"
            case .collectionNotFound:
                return "Game collection not found"
            case .reviewNotFound:
                return "Game review not found"
            case .invalidData:
                return "Invalid data"
            case .networkError:
                return "Network error occurred"
            case .saveError:
                return "Failed to save data"
            }
        }
    }
} 