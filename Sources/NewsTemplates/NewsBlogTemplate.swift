// MARK: - News/Blog Template
// Complete news and blog app with 12+ screens
// Features: Articles, Categories, Bookmarks, Search, Reader Mode
// Dark mode ready, localized, accessible

import SwiftUI
import Foundation
import Combine

// MARK: - Models

public struct Article: Identifiable, Codable, Hashable {
    public let id: UUID
    public let title: String
    public let subtitle: String
    public let content: String
    public let author: Author
    public let category: NewsCategory
    public let coverImage: String
    public let readTime: Int
    public let publishedAt: Date
    public var likesCount: Int
    public var commentsCount: Int
    public var isBookmarked: Bool
    public var isLiked: Bool
    public let tags: [String]
    public let isPremium: Bool
    
    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String = "",
        content: String,
        author: Author,
        category: NewsCategory = .technology,
        coverImage: String = "",
        readTime: Int = 5,
        publishedAt: Date = Date(),
        likesCount: Int = 0,
        commentsCount: Int = 0,
        isBookmarked: Bool = false,
        isLiked: Bool = false,
        tags: [String] = [],
        isPremium: Bool = false
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.author = author
        self.category = category
        self.coverImage = coverImage
        self.readTime = readTime
        self.publishedAt = publishedAt
        self.likesCount = likesCount
        self.commentsCount = commentsCount
        self.isBookmarked = isBookmarked
        self.isLiked = isLiked
        self.tags = tags
        self.isPremium = isPremium
    }
}

public struct Author: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let avatar: String?
    public let bio: String
    public let isVerified: Bool
    public let articlesCount: Int
    public let followersCount: Int
    
    public init(
        id: UUID = UUID(),
        name: String,
        avatar: String? = nil,
        bio: String = "",
        isVerified: Bool = false,
        articlesCount: Int = 0,
        followersCount: Int = 0
    ) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.bio = bio
        self.isVerified = isVerified
        self.articlesCount = articlesCount
        self.followersCount = followersCount
    }
}

public enum NewsCategory: String, Codable, CaseIterable {
    case technology = "Technology"
    case business = "Business"
    case science = "Science"
    case health = "Health"
    case entertainment = "Entertainment"
    case sports = "Sports"
    case politics = "Politics"
    case world = "World"
    case lifestyle = "Lifestyle"
    case opinion = "Opinion"
    
    public var icon: String {
        switch self {
        case .technology: return "cpu"
        case .business: return "chart.line.uptrend.xyaxis"
        case .science: return "atom"
        case .health: return "heart"
        case .entertainment: return "film"
        case .sports: return "sportscourt"
        case .politics: return "building.columns"
        case .world: return "globe"
        case .lifestyle: return "sparkles"
        case .opinion: return "quote.bubble"
        }
    }
    
    public var color: Color {
        switch self {
        case .technology: return .blue
        case .business: return .green
        case .science: return .purple
        case .health: return .red
        case .entertainment: return .pink
        case .sports: return .orange
        case .politics: return .indigo
        case .world: return .cyan
        case .lifestyle: return .yellow
        case .opinion: return .gray
        }
    }
}

public struct ArticleComment: Identifiable, Codable {
    public let id: UUID
    public let author: Author
    public let content: String
    public var likesCount: Int
    public var isLiked: Bool
    public let createdAt: Date
    public var replies: [ArticleComment]
    
    public init(
        id: UUID = UUID(),
        author: Author,
        content: String,
        likesCount: Int = 0,
        isLiked: Bool = false,
        createdAt: Date = Date(),
        replies: [ArticleComment] = []
    ) {
        self.id = id
        self.author = author
        self.content = content
        self.likesCount = likesCount
        self.isLiked = isLiked
        self.createdAt = createdAt
        self.replies = replies
    }
}

// MARK: - Sample Data

public enum NewsSampleData {
    public static let authors: [Author] = [
        Author(name: "Sarah Chen", bio: "Tech journalist covering AI and startups", isVerified: true, articlesCount: 234, followersCount: 45000),
        Author(name: "Michael Roberts", bio: "Business editor at Tech Daily", isVerified: true, articlesCount: 567, followersCount: 89000),
        Author(name: "Emma Wilson", bio: "Science correspondent", isVerified: true, articlesCount: 189, followersCount: 34000),
        Author(name: "David Park", bio: "Sports analyst and columnist", isVerified: false, articlesCount: 456, followersCount: 67000),
        Author(name: "Lisa Anderson", bio: "Health and wellness writer", isVerified: false, articlesCount: 123, followersCount: 23000)
    ]
    
    public static let articles: [Article] = [
        Article(
            title: "Apple Unveils Revolutionary AI Features in iOS 18",
            subtitle: "New on-device intelligence promises to transform how we use our phones",
            content: """
            Apple announced today a sweeping set of artificial intelligence features coming to iPhone, iPad, and Mac this fall. The new "Apple Intelligence" system represents the company's most significant software advancement in years.

            The features include an enhanced Siri that can understand context across apps, generate images and text, and perform complex multi-step tasks. Unlike competing AI systems, Apple's approach emphasizes on-device processing for privacy.

            "We've built a system that's deeply integrated into the Apple experience while keeping your data private," said Apple's SVP of Software Engineering. "This is AI designed around you, not around your data."

            Key features include:
            - **Smart Summaries**: Automatically condense long emails, articles, and documents
            - **Writing Tools**: Rewrite, proofread, and adjust tone across all apps
            - **Image Playground**: Generate images from text descriptions
            - **Enhanced Siri**: Natural conversations with awareness of your personal context

            The update will be available as a free software update in September, with iPhone 15 Pro models required for the full feature set due to their advanced neural engines.

            Industry analysts predict this move could accelerate AI adoption among mainstream consumers who have been hesitant about cloud-based AI systems.
            """,
            author: authors[0],
            category: .technology,
            readTime: 6,
            publishedAt: Date().addingTimeInterval(-3600),
            likesCount: 2340,
            commentsCount: 189,
            tags: ["Apple", "AI", "iOS", "Technology"]
        ),
        Article(
            title: "Markets Rally as Fed Signals Rate Cuts Ahead",
            subtitle: "Investors cheer dovish tone from Federal Reserve chairman",
            content: """
            Stock markets surged to record highs today as Federal Reserve Chairman indicated the central bank is prepared to begin cutting interest rates as early as September.

            The S&P 500 gained 1.8%, while the Nasdaq Composite jumped 2.3%, with tech stocks leading the advance. The Dow Jones Industrial Average added 450 points.

            "The time has come for policy to adjust," the Fed Chair said in remarks that were more dovish than many investors expected. "We now have greater confidence that inflation is moving sustainably toward our 2% target."

            The comments sent bond yields tumbling, with the 10-year Treasury yield falling to its lowest level since February. Lower rates typically benefit growth stocks and reduce borrowing costs for companies and consumers.

            Analysts say the shift in Fed policy could extend the bull market that began in late 2022, though some warn of potential volatility ahead of the November elections.
            """,
            author: authors[1],
            category: .business,
            readTime: 4,
            publishedAt: Date().addingTimeInterval(-7200),
            likesCount: 1567,
            commentsCount: 234,
            tags: ["Markets", "Federal Reserve", "Economy", "Stocks"]
        ),
        Article(
            title: "Breakthrough in Fusion Energy: Scientists Achieve Net Energy Gain",
            subtitle: "Historic milestone brings clean, limitless energy one step closer to reality",
            content: """
            Scientists at the National Ignition Facility have achieved a major breakthrough in fusion energy, producing more energy from a fusion reaction than was used to initiate it for the second time in history.

            The experiment produced 5.2 megajoules of energy from 2.05 megajoules of laser input—a gain of more than 2.5x and significantly better than the facility's first net-positive result in December 2022.

            "This is a watershed moment for fusion research," said the facility's director. "We've demonstrated that ignition is repeatable and can be improved. The path to fusion energy is now clear."

            Fusion power, which mimics the process that powers the sun, has long been considered the holy grail of clean energy. Unlike nuclear fission, fusion produces no long-lived radioactive waste and carries no risk of meltdown.

            While commercial fusion power plants remain decades away, today's result has energized researchers and attracted billions in private investment to the field.
            """,
            author: authors[2],
            category: .science,
            readTime: 5,
            publishedAt: Date().addingTimeInterval(-14400),
            likesCount: 4567,
            commentsCount: 456,
            tags: ["Science", "Fusion", "Energy", "Climate"],
            isPremium: true
        ),
        Article(
            title: "New Study Links Gut Health to Mental Wellness",
            subtitle: "Research reveals strong connection between microbiome and mood",
            content: """
            A groundbreaking study published in Nature Medicine has found compelling evidence that the bacteria living in our digestive system play a crucial role in regulating mood and mental health.

            Researchers analyzed the gut microbiomes of over 10,000 participants and found that people with depression and anxiety had significantly different bacterial compositions than those without mental health conditions.

            More remarkably, when researchers transferred gut bacteria from healthy individuals to those with depression, many experienced measurable improvements in their symptoms within weeks.

            "This opens up entirely new avenues for treating mental health conditions," said the study's lead author. "We may be able to develop targeted probiotics that can help regulate mood."

            The findings build on years of research into the "gut-brain axis" and could eventually lead to new treatments that work alongside traditional therapies like medication and counseling.
            """,
            author: authors[4],
            category: .health,
            readTime: 4,
            publishedAt: Date().addingTimeInterval(-28800),
            likesCount: 3456,
            commentsCount: 312,
            tags: ["Health", "Mental Health", "Science", "Microbiome"]
        ),
        Article(
            title: "Summer Olympics 2024: Complete Preview and Medal Predictions",
            subtitle: "Everything you need to know about the Paris Games",
            content: """
            The 2024 Summer Olympics in Paris promise to be a spectacular celebration of athletic excellence, with over 10,000 athletes from 206 countries competing for glory.

            The Games will feature 32 sports and 329 events, including new additions like breaking (breakdancing) and the return of several Olympic classics.

            **Key storylines to watch:**

            - Simone Biles returns to Olympic competition seeking redemption after Tokyo
            - Swimming powerhouses USA and Australia battle for pool supremacy  
            - Track and field showcases new generation of sprinting talent
            - Host nation France aims for best home Games performance ever

            **Medal predictions:**

            1. United States - 120 medals (45 gold)
            2. China - 95 medals (38 gold)
            3. Great Britain - 70 medals (25 gold)
            4. France - 55 medals (20 gold)
            5. Australia - 50 medals (18 gold)

            The opening ceremony will take place on the Seine River in a unprecedented outdoor celebration.
            """,
            author: authors[3],
            category: .sports,
            readTime: 7,
            publishedAt: Date().addingTimeInterval(-43200),
            likesCount: 2890,
            commentsCount: 567,
            tags: ["Olympics", "Sports", "Paris 2024", "Athletics"]
        )
    ]
}

// MARK: - View Models

@MainActor
public class NewsStore: ObservableObject {
    @Published public var articles: [Article] = NewsSampleData.articles
    @Published public var bookmarkedArticles: Set<UUID> = []
    @Published public var readArticles: Set<UUID> = []
    @Published public var selectedCategory: NewsCategory? = nil
    @Published public var searchQuery: String = ""
    @Published public var isLoading = false
    @Published public var readerMode = false
    @Published public var fontSize: CGFloat = 17
    
    public init() {}
    
    public var filteredArticles: [Article] {
        var result = articles
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        if !searchQuery.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchQuery) ||
                $0.content.localizedCaseInsensitiveContains(searchQuery) ||
                $0.author.name.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        
        return result
    }
    
    public var trendingArticles: [Article] {
        articles.sorted { $0.likesCount > $1.likesCount }.prefix(5).map { $0 }
    }
    
    public var bookmarked: [Article] {
        articles.filter { bookmarkedArticles.contains($0.id) }
    }
    
    public func toggleBookmark(_ article: Article) {
        if bookmarkedArticles.contains(article.id) {
            bookmarkedArticles.remove(article.id)
        } else {
            bookmarkedArticles.insert(article.id)
        }
    }
    
    public func toggleLike(_ article: Article) {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index].isLiked.toggle()
            articles[index].likesCount += articles[index].isLiked ? 1 : -1
        }
    }
    
    public func markAsRead(_ article: Article) {
        readArticles.insert(article.id)
    }
}

// MARK: - Views

// 1. Main News Home View
public struct NewsHomeView: View {
    @StateObject private var store = NewsStore()
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            NewsFeedView()
                .tabItem {
                    Label("Home", systemImage: "newspaper")
                }
                .tag(0)
            
            ExploreNewsView()
                .tabItem {
                    Label("Explore", systemImage: "safari")
                }
                .tag(1)
            
            BookmarksView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
                .tag(2)
            
            NewsProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
        }
        .environmentObject(store)
    }
}

// 2. News Feed View
public struct NewsFeedView: View {
    @EnvironmentObject var store: NewsStore
    @State private var showingSearch = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Featured Article
                    if let featured = store.articles.first {
                        FeaturedArticleCard(article: featured)
                    }
                    
                    // Categories
                    CategoriesScrollView()
                    
                    // Trending Section
                    TrendingSectionView()
                    
                    // Latest Articles
                    LatestArticlesSectionView()
                }
                .padding(.vertical)
            }
            .navigationTitle("News")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {} label: {
                        Image(systemName: "bell")
                    }
                }
            }
            .sheet(isPresented: $showingSearch) {
                SearchArticlesView()
                    .environmentObject(store)
            }
        }
    }
}

// 3. Featured Article Card
struct FeaturedArticleCard: View {
    @EnvironmentObject var store: NewsStore
    let article: Article
    
    var body: some View {
        NavigationLink {
            ArticleDetailView(article: article)
                .environmentObject(store)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .aspectRatio(16/9, contentMode: .fit)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .foregroundColor(.secondary)
                        )
                        .cornerRadius(16)
                    
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .cornerRadius(16)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(article.category.rawValue.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(article.category.color)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        
                        Text(article.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(3)
                        
                        HStack {
                            Text(article.author.name)
                            Text("•")
                            Text("\(article.readTime) min read")
                        }
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                }
            }
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }
}

// 4. Categories Scroll View
struct CategoriesScrollView: View {
    @EnvironmentObject var store: NewsStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    CategoryChipNews(
                        title: "All",
                        icon: "square.grid.2x2",
                        color: .blue,
                        isSelected: store.selectedCategory == nil
                    ) {
                        store.selectedCategory = nil
                    }
                    
                    ForEach(NewsCategory.allCases, id: \.self) { category in
                        CategoryChipNews(
                            title: category.rawValue,
                            icon: category.icon,
                            color: category.color,
                            isSelected: store.selectedCategory == category
                        ) {
                            store.selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct CategoryChipNews: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? color : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

// 5. Trending Section
struct TrendingSectionView: View {
    @EnvironmentObject var store: NewsStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("🔥 Trending")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink("See All") {
                    AllArticlesView(title: "Trending", articles: store.trendingArticles)
                        .environmentObject(store)
                }
                .font(.subheadline)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(store.trendingArticles.enumerated()), id: \.element.id) { index, article in
                        TrendingArticleCard(article: article, rank: index + 1)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct TrendingArticleCard: View {
    @EnvironmentObject var store: NewsStore
    let article: Article
    let rank: Int
    
    var body: some View {
        NavigationLink {
            ArticleDetailView(article: article)
                .environmentObject(store)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(width: 200, height: 120)
                        .cornerRadius(12)
                    
                    Text("\(rank)")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Circle().fill(Color.black.opacity(0.5)))
                        .padding(8)
                }
                
                Text(article.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(article.author.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 200)
        }
        .buttonStyle(.plain)
    }
}

// 6. Latest Articles Section
struct LatestArticlesSectionView: View {
    @EnvironmentObject var store: NewsStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Latest")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink("See All") {
                    AllArticlesView(title: "Latest", articles: store.filteredArticles)
                        .environmentObject(store)
                }
                .font(.subheadline)
            }
            .padding(.horizontal)
            
            LazyVStack(spacing: 16) {
                ForEach(store.filteredArticles) { article in
                    ArticleRowView(article: article)
                }
            }
            .padding(.horizontal)
        }
    }
}

// 7. Article Row View
struct ArticleRowView: View {
    @EnvironmentObject var store: NewsStore
    let article: Article
    
    var body: some View {
        NavigationLink {
            ArticleDetailView(article: article)
                .environmentObject(store)
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(article.category.rawValue)
                            .font(.caption)
                            .foregroundColor(article.category.color)
                        
                        if article.isPremium {
                            Image(systemName: "crown.fill")
                                .font(.caption2)
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    Text(article.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(article.author.name)
                        Text("•")
                        Text("\(article.readTime) min")
                        Text("•")
                        Text(article.publishedAt, style: .relative)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

// 8. Article Detail View
public struct ArticleDetailView: View {
    @EnvironmentObject var store: NewsStore
    @Environment(\.dismiss) private var dismiss
    let article: Article
    @State private var showingComments = false
    @State private var showingShare = false
    
    public init(article: Article) {
        self.article = article
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Cover Image
                Rectangle()
                    .fill(Color(.systemGray5))
                    .aspectRatio(16/9, contentMode: .fit)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                    )
                
                VStack(alignment: .leading, spacing: 16) {
                    // Category & Premium badge
                    HStack {
                        Text(article.category.rawValue.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(article.category.color)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        
                        if article.isPremium {
                            HStack(spacing: 4) {
                                Image(systemName: "crown.fill")
                                Text("PREMIUM")
                            }
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(4)
                        }
                    }
                    
                    // Title
                    Text(article.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Subtitle
                    if !article.subtitle.isEmpty {
                        Text(article.subtitle)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    
                    // Author
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Text(article.author.name.prefix(1))
                                    .fontWeight(.semibold)
                            )
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(article.author.name)
                                    .fontWeight(.semibold)
                                
                                if article.author.isVerified {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                }
                            }
                            
                            Text(article.publishedAt, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Follow") {}
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    
                    // Meta info
                    HStack {
                        Label("\(article.readTime) min read", systemImage: "clock")
                        Spacer()
                        Label("\(article.likesCount)", systemImage: "heart")
                        Spacer()
                        Label("\(article.commentsCount)", systemImage: "bubble.right")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    
                    Divider()
                    
                    // Content
                    Text(article.content)
                        .font(.system(size: store.fontSize))
                        .lineSpacing(8)
                    
                    // Tags
                    if !article.tags.isEmpty {
                        FlowLayout(spacing: 8) {
                            ForEach(article.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(16)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    store.toggleBookmark(article)
                } label: {
                    Image(systemName: store.bookmarkedArticles.contains(article.id) ? "bookmark.fill" : "bookmark")
                }
                
                Button {
                    showingShare = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                
                Menu {
                    Button("Reader Mode", systemImage: "doc.plaintext") {
                        store.readerMode.toggle()
                    }
                    
                    Menu("Text Size") {
                        Button("Small") { store.fontSize = 14 }
                        Button("Medium") { store.fontSize = 17 }
                        Button("Large") { store.fontSize = 20 }
                        Button("Extra Large") { store.fontSize = 24 }
                    }
                    
                    Button("Report", systemImage: "flag") {}
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 24) {
                Button {
                    store.toggleLike(article)
                } label: {
                    HStack {
                        Image(systemName: article.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(article.isLiked ? .red : .primary)
                        Text("\(article.likesCount)")
                    }
                }
                
                Button {
                    showingComments = true
                } label: {
                    HStack {
                        Image(systemName: "bubble.right")
                        Text("\(article.commentsCount)")
                    }
                }
                
                Spacer()
                
                Button {} label: {
                    Image(systemName: "textformat.size")
                }
            }
            .font(.subheadline)
            .padding()
            .background(.bar)
        }
        .sheet(isPresented: $showingComments) {
            ArticleCommentsView(article: article)
        }
        .onAppear {
            store.markAsRead(article)
        }
    }
}

// Flow Layout for tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
            
            size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

// 9. Article Comments View
struct ArticleCommentsView: View {
    @Environment(\.dismiss) private var dismiss
    let article: Article
    @State private var newComment = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(NewsSampleData.authors) { author in
                            CommentRowNews(author: author, content: "Great article! Very informative and well-written.")
                        }
                    }
                    .padding()
                }
                
                Divider()
                
                HStack(spacing: 12) {
                    TextField("Add a comment...", text: $newComment)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                    
                    Button {
                        newComment = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.accentColor)
                    }
                    .disabled(newComment.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CommentRowNews: View {
    let author: Author
    let content: String
    @State private var isLiked = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 36, height: 36)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(author.name)
                        .fontWeight(.semibold)
                    Text("2h ago")
                        .foregroundColor(.secondary)
                }
                .font(.caption)
                
                Text(content)
                    .font(.subheadline)
                
                HStack(spacing: 16) {
                    Button {} label: {
                        Text("Reply")
                    }
                    
                    Button {
                        isLiked.toggle()
                    } label: {
                        HStack {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                            Text("12")
                        }
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
    }
}

// 10. Explore View
struct ExploreNewsView: View {
    @EnvironmentObject var store: NewsStore
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Search
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search articles, topics, authors", text: $store.searchQuery)
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Topics
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Browse Topics")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(NewsCategory.allCases, id: \.self) { category in
                                NavigationLink {
                                    AllArticlesView(
                                        title: category.rawValue,
                                        articles: store.articles.filter { $0.category == category }
                                    )
                                    .environmentObject(store)
                                } label: {
                                    HStack {
                                        Image(systemName: category.icon)
                                            .font(.title2)
                                            .foregroundColor(category.color)
                                        
                                        Text(category.rawValue)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Popular Authors
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Popular Authors")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(NewsSampleData.authors) { author in
                                    AuthorCard(author: author)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Explore")
        }
    }
}

struct AuthorCard: View {
    let author: Author
    
    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 60, height: 60)
            
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Text(author.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    if author.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                }
                
                Text("\(author.followersCount) followers")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Button("Follow") {}
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(16)
        }
        .frame(width: 130)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

// 11. All Articles View
struct AllArticlesView: View {
    @EnvironmentObject var store: NewsStore
    let title: String
    let articles: [Article]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(articles) { article in
                    ArticleRowView(article: article)
                }
            }
            .padding()
        }
        .navigationTitle(title)
    }
}

// 12. Bookmarks View
struct BookmarksView: View {
    @EnvironmentObject var store: NewsStore
    
    var body: some View {
        NavigationStack {
            Group {
                if store.bookmarked.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No saved articles")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Articles you save will appear here")
                            .foregroundColor(.secondary)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(store.bookmarked) { article in
                                ArticleRowView(article: article)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Saved")
        }
    }
}

// 13. Search Articles View
struct SearchArticlesView: View {
    @EnvironmentObject var store: NewsStore
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    var searchResults: [Article] {
        if searchText.isEmpty {
            return []
        }
        return store.articles.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if searchText.isEmpty {
                    // Recent Searches
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Searches")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(["AI Technology", "Stock Market", "Climate Change", "Olympics 2024"], id: \.self) { term in
                            Button {
                                searchText = term
                            } label: {
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(.secondary)
                                    Text(term)
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            .foregroundColor(.primary)
                        }
                        
                        Spacer()
                    }
                    .padding(.top)
                } else {
                    List(searchResults) { article in
                        NavigationLink {
                            ArticleDetailView(article: article)
                                .environmentObject(store)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(article.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text(article.author.name)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search articles")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// 14. News Profile View
struct NewsProfileView: View {
    @EnvironmentObject var store: NewsStore
    
    var body: some View {
        NavigationStack {
            List {
                // User Info
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("John Doe")
                                .font(.headline)
                            Text("Premium Member")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Reading Stats
                Section("Reading Stats") {
                    HStack {
                        Text("Articles Read")
                        Spacer()
                        Text("\(store.readArticles.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Reading Time")
                        Spacer()
                        Text("2h 34m")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Articles Saved")
                        Spacer()
                        Text("\(store.bookmarkedArticles.count)")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Settings
                Section("Settings") {
                    NavigationLink("Reading Preferences", systemImage: "textformat.size") {}
                    NavigationLink("Notifications", systemImage: "bell") {}
                    NavigationLink("Dark Mode", systemImage: "moon") {}
                    NavigationLink("Downloads", systemImage: "arrow.down.circle") {}
                }
                
                // Account
                Section("Account") {
                    NavigationLink("Manage Subscription", systemImage: "creditcard") {}
                    NavigationLink("Privacy", systemImage: "lock") {}
                    NavigationLink("Help & Support", systemImage: "questionmark.circle") {}
                }
                
                Section {
                    Button("Sign Out", role: .destructive) {}
                }
            }
            .navigationTitle("Profile")
        }
    }
}

// MARK: - App Entry Point

public struct NewsBlogApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            NewsHomeView()
        }
    }
}
