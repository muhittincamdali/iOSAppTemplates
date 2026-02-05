// MARK: - Music & Podcast Template
// Complete streaming app with 14+ screens
// Features: Music Player, Playlists, Podcasts, Library, Search
// Dark mode ready, localized, accessible

import SwiftUI
import Foundation
import Combine

// MARK: - Models

public struct Song: Identifiable, Codable, Hashable {
    public let id: UUID
    public let title: String
    public let artist: Artist
    public let album: Album?
    public let duration: TimeInterval
    public let audioURL: String
    public var isLiked: Bool
    public var playCount: Int
    public let isExplicit: Bool
    
    public init(
        id: UUID = UUID(),
        title: String,
        artist: Artist,
        album: Album? = nil,
        duration: TimeInterval = 200,
        audioURL: String = "",
        isLiked: Bool = false,
        playCount: Int = 0,
        isExplicit: Bool = false
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.album = album
        self.duration = duration
        self.audioURL = audioURL
        self.isLiked = isLiked
        self.playCount = playCount
        self.isExplicit = isExplicit
    }
}

public struct Artist: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let imageURL: String?
    public let monthlyListeners: Int
    public let isVerified: Bool
    public let genres: [MusicGenre]
    
    public init(
        id: UUID = UUID(),
        name: String,
        imageURL: String? = nil,
        monthlyListeners: Int = 100000,
        isVerified: Bool = false,
        genres: [MusicGenre] = []
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.monthlyListeners = monthlyListeners
        self.isVerified = isVerified
        self.genres = genres
    }
}

public struct Album: Identifiable, Codable, Hashable {
    public let id: UUID
    public let title: String
    public let artist: Artist
    public let coverURL: String?
    public let releaseDate: Date
    public let songsCount: Int
    public let type: AlbumType
    
    public init(
        id: UUID = UUID(),
        title: String,
        artist: Artist,
        coverURL: String? = nil,
        releaseDate: Date = Date(),
        songsCount: Int = 12,
        type: AlbumType = .album
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.coverURL = coverURL
        self.releaseDate = releaseDate
        self.songsCount = songsCount
        self.type = type
    }
}

public enum AlbumType: String, Codable {
    case album = "Album"
    case ep = "EP"
    case single = "Single"
    case compilation = "Compilation"
}

public enum MusicGenre: String, Codable, CaseIterable {
    case pop = "Pop"
    case rock = "Rock"
    case hiphop = "Hip-Hop"
    case electronic = "Electronic"
    case jazz = "Jazz"
    case classical = "Classical"
    case rnb = "R&B"
    case country = "Country"
    case indie = "Indie"
    case metal = "Metal"
    
    public var color: Color {
        switch self {
        case .pop: return .pink
        case .rock: return .red
        case .hiphop: return .orange
        case .electronic: return .cyan
        case .jazz: return .purple
        case .classical: return .brown
        case .rnb: return .indigo
        case .country: return .yellow
        case .indie: return .teal
        case .metal: return .gray
        }
    }
}

public struct Playlist: Identifiable, Codable {
    public let id: UUID
    public var name: String
    public var description: String
    public var songs: [Song]
    public var coverURL: String?
    public let createdBy: String
    public var isPublic: Bool
    public var followers: Int
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        songs: [Song] = [],
        coverURL: String? = nil,
        createdBy: String = "You",
        isPublic: Bool = false,
        followers: Int = 0,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.songs = songs
        self.coverURL = coverURL
        self.createdBy = createdBy
        self.isPublic = isPublic
        self.followers = followers
        self.createdAt = createdAt
    }
    
    public var totalDuration: TimeInterval {
        songs.reduce(0) { $0 + $1.duration }
    }
}

public struct Podcast: Identifiable, Codable {
    public let id: UUID
    public let title: String
    public let author: String
    public let description: String
    public let coverURL: String?
    public let category: PodcastCategory
    public let episodes: [Episode]
    public var isSubscribed: Bool
    public let rating: Double
    public let reviewCount: Int
    
    public init(
        id: UUID = UUID(),
        title: String,
        author: String,
        description: String = "",
        coverURL: String? = nil,
        category: PodcastCategory = .technology,
        episodes: [Episode] = [],
        isSubscribed: Bool = false,
        rating: Double = 4.5,
        reviewCount: Int = 1000
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.description = description
        self.coverURL = coverURL
        self.category = category
        self.episodes = episodes
        self.isSubscribed = isSubscribed
        self.rating = rating
        self.reviewCount = reviewCount
    }
}

public enum PodcastCategory: String, Codable, CaseIterable {
    case technology = "Technology"
    case business = "Business"
    case comedy = "Comedy"
    case news = "News"
    case trueCrime = "True Crime"
    case health = "Health"
    case education = "Education"
    case sports = "Sports"
    case music = "Music"
    case society = "Society"
    
    public var icon: String {
        switch self {
        case .technology: return "cpu"
        case .business: return "briefcase"
        case .comedy: return "face.smiling"
        case .news: return "newspaper"
        case .trueCrime: return "magnifyingglass"
        case .health: return "heart"
        case .education: return "book"
        case .sports: return "sportscourt"
        case .music: return "music.note"
        case .society: return "person.3"
        }
    }
}

public struct Episode: Identifiable, Codable {
    public let id: UUID
    public let title: String
    public let description: String
    public let duration: TimeInterval
    public let audioURL: String
    public let publishedAt: Date
    public var isPlayed: Bool
    public var playbackPosition: TimeInterval
    public var isDownloaded: Bool
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        duration: TimeInterval = 3600,
        audioURL: String = "",
        publishedAt: Date = Date(),
        isPlayed: Bool = false,
        playbackPosition: TimeInterval = 0,
        isDownloaded: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.duration = duration
        self.audioURL = audioURL
        self.publishedAt = publishedAt
        self.isPlayed = isPlayed
        self.playbackPosition = playbackPosition
        self.isDownloaded = isDownloaded
    }
}

public enum RepeatMode: String, Codable {
    case off
    case all
    case one
}

// MARK: - Sample Data

public enum MusicSampleData {
    public static let artists: [Artist] = [
        Artist(name: "The Weeknd", monthlyListeners: 85000000, isVerified: true, genres: [.pop, .rnb]),
        Artist(name: "Taylor Swift", monthlyListeners: 92000000, isVerified: true, genres: [.pop, .country]),
        Artist(name: "Drake", monthlyListeners: 78000000, isVerified: true, genres: [.hiphop, .rnb]),
        Artist(name: "Dua Lipa", monthlyListeners: 65000000, isVerified: true, genres: [.pop, .electronic]),
        Artist(name: "Kendrick Lamar", monthlyListeners: 55000000, isVerified: true, genres: [.hiphop])
    ]
    
    public static let albums: [Album] = [
        Album(title: "After Hours", artist: artists[0], songsCount: 14),
        Album(title: "Midnights", artist: artists[1], songsCount: 13),
        Album(title: "Scorpion", artist: artists[2], songsCount: 25),
        Album(title: "Future Nostalgia", artist: artists[3], songsCount: 11),
        Album(title: "Mr. Morale", artist: artists[4], songsCount: 18)
    ]
    
    public static let songs: [Song] = [
        Song(title: "Blinding Lights", artist: artists[0], album: albums[0], duration: 200, playCount: 3500000000),
        Song(title: "Save Your Tears", artist: artists[0], album: albums[0], duration: 215, playCount: 2800000000),
        Song(title: "Anti-Hero", artist: artists[1], album: albums[1], duration: 200, playCount: 2100000000),
        Song(title: "Lavender Haze", artist: artists[1], album: albums[1], duration: 202, playCount: 1500000000),
        Song(title: "God's Plan", artist: artists[2], album: albums[2], duration: 198, playCount: 3200000000),
        Song(title: "Levitating", artist: artists[3], album: albums[3], duration: 203, playCount: 2500000000),
        Song(title: "Don't Start Now", artist: artists[3], album: albums[3], duration: 183, playCount: 2200000000),
        Song(title: "N95", artist: artists[4], album: albums[4], duration: 196, playCount: 800000000)
    ]
    
    public static let playlists: [Playlist] = [
        Playlist(name: "Today's Top Hits", description: "The hottest tracks right now", songs: Array(songs.prefix(5)), createdBy: "Spotify", isPublic: true, followers: 32000000),
        Playlist(name: "Chill Vibes", description: "Relax and unwind", songs: Array(songs.suffix(3)), createdBy: "You", isPublic: false),
        Playlist(name: "Workout Mix", description: "Get pumped up", songs: songs, createdBy: "You", isPublic: true, followers: 150)
    ]
    
    public static let podcasts: [Podcast] = [
        Podcast(title: "The Daily", author: "The New York Times", description: "This is what the news should sound like. The biggest stories of our time, told by the best journalists in the world.", category: .news, rating: 4.7, reviewCount: 125000),
        Podcast(title: "Lex Fridman Podcast", author: "Lex Fridman", description: "Conversations about the nature of intelligence, consciousness, love, and power.", category: .technology, rating: 4.9, reviewCount: 89000),
        Podcast(title: "Crime Junkie", author: "audiochuck", description: "If you can never get enough true crime, join hosts Ashley Flowers and Brit Prawat.", category: .trueCrime, rating: 4.8, reviewCount: 234000),
        Podcast(title: "The Tim Ferriss Show", author: "Tim Ferriss", description: "Tim Ferriss deconstructs world-class performers from eclectic areas.", category: .business, rating: 4.6, reviewCount: 78000)
    ]
    
    public static let episodes: [Episode] = [
        Episode(title: "AI and the Future of Work", description: "Deep dive into how artificial intelligence is reshaping industries", duration: 5400, publishedAt: Date().addingTimeInterval(-86400)),
        Episode(title: "The Psychology of Success", description: "Understanding what drives high achievers", duration: 4800, publishedAt: Date().addingTimeInterval(-172800)),
        Episode(title: "Breaking News Analysis", description: "Expert analysis of today's top stories", duration: 1800, publishedAt: Date().addingTimeInterval(-3600))
    ]
}

// MARK: - View Models

@MainActor
public class MusicStore: ObservableObject {
    @Published public var songs: [Song] = MusicSampleData.songs
    @Published public var artists: [Artist] = MusicSampleData.artists
    @Published public var albums: [Album] = MusicSampleData.albums
    @Published public var playlists: [Playlist] = MusicSampleData.playlists
    @Published public var podcasts: [Podcast] = MusicSampleData.podcasts
    @Published public var likedSongs: [Song] = []
    @Published public var recentlyPlayed: [Song] = []
    
    // Player state
    @Published public var currentSong: Song?
    @Published public var isPlaying: Bool = false
    @Published public var currentTime: TimeInterval = 0
    @Published public var shuffleEnabled: Bool = false
    @Published public var repeatMode: RepeatMode = .off
    @Published public var volume: Double = 0.7
    @Published public var queue: [Song] = []
    
    @Published public var searchQuery: String = ""
    
    public init() {
        likedSongs = songs.filter { $0.isLiked }
        recentlyPlayed = Array(songs.prefix(5))
    }
    
    public func playSong(_ song: Song) {
        currentSong = song
        isPlaying = true
        currentTime = 0
        
        if !recentlyPlayed.contains(where: { $0.id == song.id }) {
            recentlyPlayed.insert(song, at: 0)
            if recentlyPlayed.count > 20 {
                recentlyPlayed.removeLast()
            }
        }
    }
    
    public func togglePlayPause() {
        isPlaying.toggle()
    }
    
    public func nextSong() {
        guard let current = currentSong, let currentIndex = songs.firstIndex(where: { $0.id == current.id }) else { return }
        
        let nextIndex = shuffleEnabled ? Int.random(in: 0..<songs.count) : (currentIndex + 1) % songs.count
        playSong(songs[nextIndex])
    }
    
    public func previousSong() {
        if currentTime > 3 {
            currentTime = 0
            return
        }
        
        guard let current = currentSong, let currentIndex = songs.firstIndex(where: { $0.id == current.id }) else { return }
        
        let prevIndex = currentIndex > 0 ? currentIndex - 1 : songs.count - 1
        playSong(songs[prevIndex])
    }
    
    public func toggleLike(_ song: Song) {
        if let index = songs.firstIndex(where: { $0.id == song.id }) {
            songs[index].isLiked.toggle()
            
            if songs[index].isLiked {
                likedSongs.append(songs[index])
            } else {
                likedSongs.removeAll { $0.id == song.id }
            }
        }
    }
    
    public func toggleSubscribe(_ podcast: Podcast) {
        if let index = podcasts.firstIndex(where: { $0.id == podcast.id }) {
            podcasts[index].isSubscribed.toggle()
        }
    }
    
    public func createPlaylist(name: String) {
        let playlist = Playlist(name: name)
        playlists.append(playlist)
    }
}

// MARK: - Views

// 1. Main Music Home View
public struct MusicHomeView: View {
    @StateObject private var store = MusicStore()
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                MusicDiscoverView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                
                SearchMusicView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(1)
                
                MusicLibraryView()
                    .tabItem {
                        Label("Library", systemImage: "books.vertical")
                    }
                    .tag(2)
                
                PodcastsView()
                    .tabItem {
                        Label("Podcasts", systemImage: "mic")
                    }
                    .tag(3)
            }
            
            // Mini Player
            if store.currentSong != nil {
                MiniPlayerView()
                    .padding(.bottom, 49)
            }
        }
        .environmentObject(store)
    }
}

// 2. Music Discover View
public struct MusicDiscoverView: View {
    @EnvironmentObject var store: MusicStore
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Recently Played
                    RecentlyPlayedSection()
                    
                    // Made For You
                    MadeForYouSection()
                    
                    // Trending
                    TrendingSection()
                    
                    // New Releases
                    NewReleasesSection()
                }
                .padding(.vertical)
                .padding(.bottom, store.currentSong != nil ? 70 : 0)
            }
            .navigationTitle("Good Evening")
        }
    }
}

// 3. Recently Played Section
struct RecentlyPlayedSection: View {
    @EnvironmentObject var store: MusicStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently Played")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(store.recentlyPlayed.prefix(6)) { song in
                    Button {
                        store.playSong(song)
                    } label: {
                        HStack(spacing: 8) {
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .frame(width: 50, height: 50)
                                .cornerRadius(4)
                            
                            Text(song.title)
                                .font(.caption)
                                .fontWeight(.medium)
                                .lineLimit(2)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

// 4. Made For You Section
struct MadeForYouSection: View {
    @EnvironmentObject var store: MusicStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Made For You")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(store.playlists) { playlist in
                        NavigationLink {
                            PlaylistDetailView(playlist: playlist)
                                .environmentObject(store)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.purple, .blue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(8)
                                    .overlay(
                                        Image(systemName: "music.note.list")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                    )
                                
                                Text(playlist.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                                
                                Text(playlist.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                            .frame(width: 150)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// 5. Trending Section
struct TrendingSection: View {
    @EnvironmentObject var store: MusicStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Trending Now")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink("See All") {
                    // All trending
                }
                .font(.subheadline)
            }
            .padding(.horizontal)
            
            VStack(spacing: 8) {
                ForEach(Array(store.songs.prefix(5).enumerated()), id: \.element.id) { index, song in
                    TrendingSongRow(song: song, rank: index + 1)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct TrendingSongRow: View {
    @EnvironmentObject var store: MusicStore
    let song: Song
    let rank: Int
    
    var body: some View {
        Button {
            store.playSong(song)
        } label: {
            HStack(spacing: 12) {
                Text("\(rank)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(width: 20)
                
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: 50, height: 50)
                    .cornerRadius(4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(song.title)
                        .fontWeight(.medium)
                    
                    Text(song.artist.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button {
                    store.toggleLike(song)
                } label: {
                    Image(systemName: song.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(song.isLiked ? .green : .secondary)
                }
                
                Image(systemName: "ellipsis")
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

// 6. New Releases Section
struct NewReleasesSection: View {
    @EnvironmentObject var store: MusicStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("New Releases")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(store.albums) { album in
                        NavigationLink {
                            AlbumDetailView(album: album)
                                .environmentObject(store)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Rectangle()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(4)
                                    .overlay(
                                        Image(systemName: "music.note")
                                            .font(.system(size: 40))
                                            .foregroundColor(.secondary)
                                    )
                                
                                Text(album.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                                
                                Text(album.artist.name)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: 150)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// 7. Mini Player View
struct MiniPlayerView: View {
    @EnvironmentObject var store: MusicStore
    @State private var showingFullPlayer = false
    
    var body: some View {
        if let song = store.currentSong {
            Button {
                showingFullPlayer = true
            } label: {
                HStack(spacing: 12) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(width: 44, height: 44)
                        .cornerRadius(4)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(song.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text(song.artist.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        store.togglePlayPause()
                    } label: {
                        Image(systemName: store.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                    }
                    
                    Button {
                        store.nextSong()
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.title3)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
            }
            .buttonStyle(.plain)
            .fullScreenCover(isPresented: $showingFullPlayer) {
                FullPlayerView()
                    .environmentObject(store)
            }
        }
    }
}

// 8. Full Player View
struct FullPlayerView: View {
    @EnvironmentObject var store: MusicStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if let song = store.currentSong {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Text("Now Playing")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {} label: {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                    }
                }
                .foregroundColor(.primary)
                .padding()
                
                Spacer()
                
                // Album Art
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.purple.opacity(0.5), .blue.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 300, height: 300)
                    .cornerRadius(8)
                    .shadow(radius: 20)
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                    )
                
                Spacer()
                
                // Song Info
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(song.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(song.artist.name)
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            store.toggleLike(song)
                        } label: {
                            Image(systemName: song.isLiked ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(song.isLiked ? .green : .primary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Progress
                    VStack(spacing: 4) {
                        Slider(value: $store.currentTime, in: 0...song.duration)
                            .tint(.primary)
                        
                        HStack {
                            Text(formatTime(store.currentTime))
                            Spacer()
                            Text(formatTime(song.duration))
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
                
                // Controls
                HStack(spacing: 40) {
                    Button {
                        store.shuffleEnabled.toggle()
                    } label: {
                        Image(systemName: "shuffle")
                            .font(.title3)
                            .foregroundColor(store.shuffleEnabled ? .green : .secondary)
                    }
                    
                    Button {
                        store.previousSong()
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(.title)
                    }
                    
                    Button {
                        store.togglePlayPause()
                    } label: {
                        Image(systemName: store.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 70))
                    }
                    
                    Button {
                        store.nextSong()
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.title)
                    }
                    
                    Button {
                        switch store.repeatMode {
                        case .off: store.repeatMode = .all
                        case .all: store.repeatMode = .one
                        case .one: store.repeatMode = .off
                        }
                    } label: {
                        Image(systemName: store.repeatMode == .one ? "repeat.1" : "repeat")
                            .font(.title3)
                            .foregroundColor(store.repeatMode != .off ? .green : .secondary)
                    }
                }
                .foregroundColor(.primary)
                .padding()
                
                // Volume
                HStack {
                    Image(systemName: "speaker.fill")
                        .font(.caption)
                    
                    Slider(value: $store.volume, in: 0...1)
                        .tint(.primary)
                    
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color(.systemBackground))
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// 9. Playlist Detail View
struct PlaylistDetailView: View {
    @EnvironmentObject var store: MusicStore
    let playlist: Playlist
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 16) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 200)
                        .cornerRadius(8)
                        .shadow(radius: 10)
                    
                    Text(playlist.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(playlist.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(playlist.songs.count) songs • \(formatDuration(playlist.totalDuration))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        Button {
                            store.toggleLike(playlist.songs.first!)
                        } label: {
                            Image(systemName: "heart")
                                .font(.title2)
                        }
                        
                        Button {
                            if let first = playlist.songs.first {
                                store.playSong(first)
                            }
                        } label: {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                        }
                        
                        Button {} label: {
                            Image(systemName: "arrow.down.circle")
                                .font(.title2)
                        }
                    }
                    .foregroundColor(.primary)
                }
                .padding()
                
                // Songs
                LazyVStack(spacing: 0) {
                    ForEach(playlist.songs) { song in
                        SongRow(song: song)
                        Divider()
                            .padding(.leading, 60)
                    }
                }
            }
            .padding(.bottom, store.currentSong != nil ? 70 : 0)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes) min"
    }
}

struct SongRow: View {
    @EnvironmentObject var store: MusicStore
    let song: Song
    
    var body: some View {
        Button {
            store.playSong(song)
        } label: {
            HStack(spacing: 12) {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: 50, height: 50)
                    .cornerRadius(4)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(song.title)
                            .fontWeight(.medium)
                            .foregroundColor(store.currentSong?.id == song.id ? .green : .primary)
                        
                        if song.isExplicit {
                            Image(systemName: "e.square.fill")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text(song.artist.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if store.currentSong?.id == song.id {
                    Image(systemName: store.isPlaying ? "waveform" : "pause.fill")
                        .foregroundColor(.green)
                }
                
                Button {} label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

// 10. Album Detail View
struct AlbumDetailView: View {
    @EnvironmentObject var store: MusicStore
    let album: Album
    
    var albumSongs: [Song] {
        store.songs.filter { $0.album?.id == album.id }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 16) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(width: 200, height: 200)
                        .cornerRadius(4)
                        .shadow(radius: 10)
                    
                    Text(album.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(album.artist.name)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("\(album.type.rawValue) • \(album.releaseDate.formatted(.dateTime.year()))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button {
                        if let first = albumSongs.first {
                            store.playSong(first)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Play")
                        }
                        .fontWeight(.semibold)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                    }
                }
                .padding()
                
                // Songs
                LazyVStack(spacing: 0) {
                    ForEach(Array(albumSongs.enumerated()), id: \.element.id) { index, song in
                        AlbumSongRow(song: song, index: index + 1)
                        Divider()
                            .padding(.leading, 40)
                    }
                }
            }
            .padding(.bottom, store.currentSong != nil ? 70 : 0)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AlbumSongRow: View {
    @EnvironmentObject var store: MusicStore
    let song: Song
    let index: Int
    
    var body: some View {
        Button {
            store.playSong(song)
        } label: {
            HStack(spacing: 12) {
                Text("\(index)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(song.title)
                        .fontWeight(.medium)
                        .foregroundColor(store.currentSong?.id == song.id ? .green : .primary)
                    
                    if song.isExplicit {
                        Image(systemName: "e.square.fill")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Text(formatDuration(song.duration))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Button {} label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// 11. Search Music View
struct SearchMusicView: View {
    @EnvironmentObject var store: MusicStore
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if searchText.isEmpty {
                        // Browse Categories
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Browse All")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(MusicGenre.allCases, id: \.self) { genre in
                                    GenreCard(genre: genre)
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        // Search Results
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Songs")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(store.songs.filter { $0.title.localizedCaseInsensitiveContains(searchText) }) { song in
                                SongRow(song: song)
                            }
                            
                            Text("Artists")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(store.artists.filter { $0.name.localizedCaseInsensitiveContains(searchText) }) { artist in
                                ArtistRow(artist: artist)
                            }
                        }
                    }
                }
                .padding(.vertical)
                .padding(.bottom, store.currentSong != nil ? 70 : 0)
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Songs, artists, or podcasts")
        }
    }
}

struct GenreCard: View {
    let genre: MusicGenre
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(genre.color)
                .frame(height: 100)
                .cornerRadius(8)
            
            Text(genre.rawValue)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
        }
    }
}

struct ArtistRow: View {
    let artist: Artist
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(artist.name)
                        .fontWeight(.medium)
                    
                    if artist.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                
                Text("Artist")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

// 12. Music Library View
struct MusicLibraryView: View {
    @EnvironmentObject var store: MusicStore
    @State private var showingCreatePlaylist = false
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    LikedSongsView()
                        .environmentObject(store)
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                            Image(systemName: "heart.fill")
                                .foregroundColor(.white)
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(4)
                        
                        VStack(alignment: .leading) {
                            Text("Liked Songs")
                                .fontWeight(.medium)
                            Text("\(store.likedSongs.count) songs")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Playlists") {
                    ForEach(store.playlists.filter { $0.createdBy == "You" }) { playlist in
                        NavigationLink {
                            PlaylistDetailView(playlist: playlist)
                                .environmentObject(store)
                        } label: {
                            HStack(spacing: 12) {
                                Rectangle()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(4)
                                
                                VStack(alignment: .leading) {
                                    Text(playlist.name)
                                        .fontWeight(.medium)
                                    Text("\(playlist.songs.count) songs")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                
                Section("Artists") {
                    ForEach(store.artists) { artist in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 50, height: 50)
                            
                            Text(artist.name)
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Your Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreatePlaylist = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreatePlaylist) {
                CreatePlaylistView()
                    .environmentObject(store)
            }
        }
    }
}

struct LikedSongsView: View {
    @EnvironmentObject var store: MusicStore
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(store.likedSongs) { song in
                    SongRow(song: song)
                    Divider()
                        .padding(.leading, 60)
                }
            }
            .padding(.bottom, store.currentSong != nil ? 70 : 0)
        }
        .navigationTitle("Liked Songs")
    }
}

struct CreatePlaylistView: View {
    @EnvironmentObject var store: MusicStore
    @Environment(\.dismiss) private var dismiss
    @State private var playlistName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Playlist name", text: $playlistName)
            }
            .navigationTitle("New Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        store.createPlaylist(name: playlistName)
                        dismiss()
                    }
                    .disabled(playlistName.isEmpty)
                }
            }
        }
    }
}

// 13. Podcasts View
struct PodcastsView: View {
    @EnvironmentObject var store: MusicStore
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Subscribed
                    if !store.podcasts.filter({ $0.isSubscribed }).isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Shows")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(store.podcasts.filter { $0.isSubscribed }) { podcast in
                                        NavigationLink {
                                            PodcastDetailView(podcast: podcast)
                                                .environmentObject(store)
                                        } label: {
                                            VStack {
                                                Rectangle()
                                                    .fill(Color(.systemGray5))
                                                    .frame(width: 120, height: 120)
                                                    .cornerRadius(8)
                                                
                                                Text(podcast.title)
                                                    .font(.caption)
                                                    .lineLimit(2)
                                            }
                                            .frame(width: 120)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Categories
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Browse Categories")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(PodcastCategory.allCases, id: \.self) { category in
                                PodcastCategoryCard(category: category)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Popular Podcasts
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Popular Podcasts")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(store.podcasts) { podcast in
                            NavigationLink {
                                PodcastDetailView(podcast: podcast)
                                    .environmentObject(store)
                            } label: {
                                PodcastRow(podcast: podcast)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.vertical)
                .padding(.bottom, store.currentSong != nil ? 70 : 0)
            }
            .navigationTitle("Podcasts")
        }
    }
}

struct PodcastCategoryCard: View {
    let category: PodcastCategory
    
    var body: some View {
        HStack {
            Image(systemName: category.icon)
                .font(.title2)
            
            Text(category.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct PodcastRow: View {
    let podcast: Podcast
    
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(podcast.title)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(podcast.author)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", podcast.rating))
                }
                .font(.caption)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

// 14. Podcast Detail View
struct PodcastDetailView: View {
    @EnvironmentObject var store: MusicStore
    let podcast: Podcast
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 16) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(width: 180, height: 180)
                        .cornerRadius(8)
                        .shadow(radius: 10)
                    
                    Text(podcast.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(podcast.author)
                        .foregroundColor(.secondary)
                    
                    Text(podcast.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button {
                        store.toggleSubscribe(podcast)
                    } label: {
                        Text(podcast.isSubscribed ? "Subscribed" : "Subscribe")
                            .fontWeight(.semibold)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(podcast.isSubscribed ? Color(.systemGray5) : Color.green)
                            .foregroundColor(podcast.isSubscribed ? .primary : .white)
                            .cornerRadius(25)
                    }
                }
                .padding()
                
                // Episodes
                VStack(alignment: .leading, spacing: 12) {
                    Text("Episodes")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(MusicSampleData.episodes) { episode in
                        EpisodeRow(episode: episode)
                    }
                }
            }
            .padding(.bottom, store.currentSong != nil ? 70 : 0)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EpisodeRow: View {
    let episode: Episode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(episode.publishedAt, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(episode.title)
                .fontWeight(.semibold)
            
            Text(episode.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Button {} label: {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                }
                
                Text(formatDuration(episode.duration))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button {} label: {
                    Image(systemName: episode.isDownloaded ? "checkmark.circle.fill" : "arrow.down.circle")
                        .foregroundColor(episode.isDownloaded ? .green : .secondary)
                }
                
                Button {} label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes) min"
    }
}

// MARK: - App Entry Point

public struct MusicPodcastApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            MusicHomeView()
        }
    }
}
