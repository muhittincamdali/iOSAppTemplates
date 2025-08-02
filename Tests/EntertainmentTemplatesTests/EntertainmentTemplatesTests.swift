import XCTest
@testable import EntertainmentTemplates

final class EntertainmentTemplatesTests: XCTestCase {
    
    func testEntertainmentTemplatesInitialization() {
        // Given
        let version = EntertainmentTemplates.version
        
        // Then
        XCTAssertEqual(version, "1.0.0")
    }
    
    func testGameInitialization() {
        // Given
        let game = GamingAppTemplate.Game(
            id: "game-1",
            title: "Super Mario",
            description: "Classic platformer game",
            genre: .platformer,
            platform: .ios,
            rating: .everyone,
            releaseDate: Date(),
            developer: "Nintendo",
            publisher: "Nintendo",
            price: 9.99,
            isFree: false,
            isInstalled: true,
            isFavorite: true,
            playTime: 3600,
            lastPlayed: Date(),
            achievements: [],
            tags: ["platformer", "classic"]
        )
        
        // Then
        XCTAssertEqual(game.id, "game-1")
        XCTAssertEqual(game.title, "Super Mario")
        XCTAssertEqual(game.description, "Classic platformer game")
        XCTAssertEqual(game.genre, .platformer)
        XCTAssertEqual(game.platform, .ios)
        XCTAssertEqual(game.rating, .everyone)
        XCTAssertEqual(game.developer, "Nintendo")
        XCTAssertEqual(game.price, 9.99)
        XCTAssertFalse(game.isFree)
        XCTAssertTrue(game.isInstalled)
        XCTAssertTrue(game.isFavorite)
        XCTAssertEqual(game.playTime, 3600)
    }
    
    func testAchievementInitialization() {
        // Given
        let achievement = GamingAppTemplate.Achievement(
            id: "achievement-1",
            title: "First Victory",
            description: "Win your first game",
            isUnlocked: true,
            unlockDate: Date(),
            rarity: .common,
            points: 10
        )
        
        // Then
        XCTAssertEqual(achievement.id, "achievement-1")
        XCTAssertEqual(achievement.title, "First Victory")
        XCTAssertEqual(achievement.description, "Win your first game")
        XCTAssertTrue(achievement.isUnlocked)
        XCTAssertEqual(achievement.rarity, .common)
        XCTAssertEqual(achievement.points, 10)
    }
    
    func testSystemRequirementsInitialization() {
        // Given
        let requirements = GamingAppTemplate.SystemRequirements(
            minimumOS: "iOS 12.0",
            recommendedOS: "iOS 15.0",
            minimumRAM: "2GB",
            recommendedRAM: "4GB",
            minimumStorage: "1GB",
            recommendedStorage: "2GB",
            minimumGraphics: "Metal compatible",
            recommendedGraphics: "Metal 2.0",
            minimumProcessor: "A9",
            recommendedProcessor: "A14"
        )
        
        // Then
        XCTAssertEqual(requirements.minimumOS, "iOS 12.0")
        XCTAssertEqual(requirements.recommendedOS, "iOS 15.0")
        XCTAssertEqual(requirements.minimumRAM, "2GB")
        XCTAssertEqual(requirements.recommendedRAM, "4GB")
        XCTAssertEqual(requirements.minimumStorage, "1GB")
        XCTAssertEqual(requirements.recommendedStorage, "2GB")
        XCTAssertEqual(requirements.minimumGraphics, "Metal compatible")
        XCTAssertEqual(requirements.recommendedGraphics, "Metal 2.0")
        XCTAssertEqual(requirements.minimumProcessor, "A9")
        XCTAssertEqual(requirements.recommendedProcessor, "A14")
    }
    
    func testGameSessionInitialization() {
        // Given
        let session = GamingAppTemplate.GameSession(
            id: "session-1",
            gameId: "game-1",
            startTime: Date(),
            endTime: Date().addingTimeInterval(1800),
            duration: 1800,
            achievements: [],
            score: 1000,
            level: 5,
            notes: "Great session!"
        )
        
        // Then
        XCTAssertEqual(session.id, "session-1")
        XCTAssertEqual(session.gameId, "game-1")
        XCTAssertEqual(session.duration, 1800)
        XCTAssertEqual(session.score, 1000)
        XCTAssertEqual(session.level, 5)
        XCTAssertEqual(session.notes, "Great session!")
    }
    
    func testGameCollectionInitialization() {
        // Given
        let collection = GamingAppTemplate.GameCollection(
            id: "collection-1",
            name: "RPG Games",
            description: "My favorite RPG games",
            games: [],
            isPublic: true
        )
        
        // Then
        XCTAssertEqual(collection.id, "collection-1")
        XCTAssertEqual(collection.name, "RPG Games")
        XCTAssertEqual(collection.description, "My favorite RPG games")
        XCTAssertTrue(collection.isPublic)
    }
    
    func testGameReviewInitialization() {
        // Given
        let review = GamingAppTemplate.GameReview(
            id: "review-1",
            gameId: "game-1",
            userId: "user-1",
            username: "gamer123",
            rating: 5,
            title: "Amazing Game!",
            content: "This game is absolutely fantastic!",
            isVerified: true,
            helpfulCount: 10
        )
        
        // Then
        XCTAssertEqual(review.id, "review-1")
        XCTAssertEqual(review.gameId, "game-1")
        XCTAssertEqual(review.userId, "user-1")
        XCTAssertEqual(review.username, "gamer123")
        XCTAssertEqual(review.rating, 5)
        XCTAssertEqual(review.title, "Amazing Game!")
        XCTAssertEqual(review.content, "This game is absolutely fantastic!")
        XCTAssertTrue(review.isVerified)
        XCTAssertEqual(review.helpfulCount, 10)
    }
    
    func testGameGenreProperties() {
        // Given
        let action = GamingAppTemplate.GameGenre.action
        let rpg = GamingAppTemplate.GameGenre.rpg
        let puzzle = GamingAppTemplate.GameGenre.puzzle
        
        // Then
        XCTAssertEqual(action.displayName, "Action")
        XCTAssertEqual(action.icon, "bolt.fill")
        XCTAssertEqual(rpg.displayName, "RPG")
        XCTAssertEqual(rpg.icon, "person.3.fill")
        XCTAssertEqual(puzzle.displayName, "Puzzle")
        XCTAssertEqual(puzzle.icon, "puzzlepiece.fill")
    }
    
    func testGamePlatformProperties() {
        // Given
        let ios = GamingAppTemplate.GamePlatform.ios
        let android = GamingAppTemplate.GamePlatform.android
        let pc = GamingAppTemplate.GamePlatform.pc
        
        // Then
        XCTAssertEqual(ios.displayName, "iOS")
        XCTAssertEqual(android.displayName, "Android")
        XCTAssertEqual(pc.displayName, "PC")
    }
    
    func testGameRatingProperties() {
        // Given
        let everyone = GamingAppTemplate.GameRating.everyone
        let teen = GamingAppTemplate.GameRating.teen
        let mature = GamingAppTemplate.GameRating.mature
        
        // Then
        XCTAssertEqual(everyone.displayName, "Everyone")
        XCTAssertEqual(teen.displayName, "Teen")
        XCTAssertEqual(mature.displayName, "Mature")
    }
    
    func testAchievementRarityProperties() {
        // Given
        let common = GamingAppTemplate.AchievementRarity.common
        let rare = GamingAppTemplate.AchievementRarity.rare
        let legendary = GamingAppTemplate.AchievementRarity.legendary
        
        // Then
        XCTAssertEqual(common.displayName, "Common")
        XCTAssertEqual(common.color, "gray")
        XCTAssertEqual(rare.displayName, "Rare")
        XCTAssertEqual(rare.color, "blue")
        XCTAssertEqual(legendary.displayName, "Legendary")
        XCTAssertEqual(legendary.color, "orange")
    }
    
    func testGameManagerInitialization() {
        // Given
        let manager = GamingAppTemplate.GameManager()
        
        // Then
        XCTAssertTrue(manager.games.isEmpty)
        XCTAssertTrue(manager.collections.isEmpty)
        XCTAssertTrue(manager.sessions.isEmpty)
        XCTAssertTrue(manager.reviews.isEmpty)
        XCTAssertFalse(manager.isLoading)
    }
    
    func testAudioManagerInitialization() {
        // Given
        let manager = GamingAppTemplate.AudioManager()
        
        // Then
        XCTAssertNotNil(manager)
    }
    
    func testSaveManagerInitialization() {
        // Given
        let manager = GamingAppTemplate.SaveManager()
        
        // Then
        XCTAssertNotNil(manager)
    }
    
    func testGameCardInitialization() {
        // Given
        let game = GamingAppTemplate.Game(
            id: "test",
            title: "Test Game",
            genre: .action,
            platform: .ios,
            developer: "Test Developer",
            isInstalled: true,
            isFavorite: false
        )
        
        let card = GamingAppTemplate.GameCard(
            game: game,
            onTap: {},
            onFavorite: {}
        )
        
        // Then
        XCTAssertNotNil(card)
    }
    
    func testAchievementCardInitialization() {
        // Given
        let achievement = GamingAppTemplate.Achievement(
            id: "test",
            title: "Test Achievement",
            description: "Test description",
            isUnlocked: true,
            rarity: .common,
            points: 10
        )
        
        let card = GamingAppTemplate.AchievementCard(
            achievement: achievement,
            onTap: {}
        )
        
        // Then
        XCTAssertNotNil(card)
    }
    
    func testGameErrorDescriptions() {
        // Given & When
        let gameNotFound = GamingAppTemplate.GameError.gameNotFound
        let sessionNotFound = GamingAppTemplate.GameError.sessionNotFound
        let collectionNotFound = GamingAppTemplate.GameError.collectionNotFound
        let reviewNotFound = GamingAppTemplate.GameError.reviewNotFound
        let invalidData = GamingAppTemplate.GameError.invalidData
        let networkError = GamingAppTemplate.GameError.networkError
        let saveError = GamingAppTemplate.GameError.saveError
        
        // Then
        XCTAssertEqual(gameNotFound.errorDescription, "Game not found")
        XCTAssertEqual(sessionNotFound.errorDescription, "Game session not found")
        XCTAssertEqual(collectionNotFound.errorDescription, "Game collection not found")
        XCTAssertEqual(reviewNotFound.errorDescription, "Game review not found")
        XCTAssertEqual(invalidData.errorDescription, "Invalid data")
        XCTAssertEqual(networkError.errorDescription, "Network error occurred")
        XCTAssertEqual(saveError.errorDescription, "Failed to save data")
    }
} 