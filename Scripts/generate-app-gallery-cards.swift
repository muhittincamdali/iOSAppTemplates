import Foundation

struct AppCard {
    let id: String
    let lane: String
    let accentStart: String
    let accentEnd: String
}

let cards: [AppCard] = [
    AppCard(id: "EcommerceApp", lane: "Commerce", accentStart: "#FF7A18", accentEnd: "#FFB347"),
    AppCard(id: "SocialMediaApp", lane: "Social", accentStart: "#0061FF", accentEnd: "#60EFFF"),
    AppCard(id: "FitnessApp", lane: "Health / Fitness", accentStart: "#11998E", accentEnd: "#38EF7D"),
    AppCard(id: "ProductivityApp", lane: "Productivity", accentStart: "#3A1C71", accentEnd: "#D76D77"),
    AppCard(id: "FinanceApp", lane: "Finance", accentStart: "#134E5E", accentEnd: "#71B280"),
    AppCard(id: "EducationApp", lane: "Education", accentStart: "#4E54C8", accentEnd: "#8F94FB"),
    AppCard(id: "FoodDeliveryApp", lane: "Food Delivery", accentStart: "#CB2D3E", accentEnd: "#EF473A"),
    AppCard(id: "TravelPlannerApp", lane: "Travel", accentStart: "#2BC0E4", accentEnd: "#EAECC6"),
    AppCard(id: "AIAssistantApp", lane: "AI", accentStart: "#141E30", accentEnd: "#243B55"),
    AppCard(id: "NewsBlogApp", lane: "News", accentStart: "#355C7D", accentEnd: "#C06C84"),
    AppCard(id: "MusicPodcastApp", lane: "Music / Podcast", accentStart: "#DA4453", accentEnd: "#89216B"),
    AppCard(id: "MarketplaceApp", lane: "Marketplace", accentStart: "#283048", accentEnd: "#859398"),
    AppCard(id: "MessagingApp", lane: "Messaging / Community", accentStart: "#1D976C", accentEnd: "#93F9B9"),
    AppCard(id: "BookingReservationsApp", lane: "Booking / Reservations", accentStart: "#4B79A1", accentEnd: "#283E51"),
    AppCard(id: "NotesKnowledgeApp", lane: "Notes / Knowledge", accentStart: "#F7971E", accentEnd: "#FFD200"),
    AppCard(id: "CreatorShortVideoApp", lane: "Creator / Short Video", accentStart: "#654EA3", accentEnd: "#EAafc8"),
    AppCard(id: "TeamCollaborationApp", lane: "Team Collaboration", accentStart: "#0F2027", accentEnd: "#2C5364"),
    AppCard(id: "CRMAdminApp", lane: "CRM / Admin", accentStart: "#7F00FF", accentEnd: "#E100FF"),
    AppCard(id: "SubscriptionLifestyleApp", lane: "Subscription Lifestyle", accentStart: "#F953C6", accentEnd: "#B91D73"),
    AppCard(id: "PrivacyVaultApp", lane: "Privacy / Secure Vault", accentStart: "#232526", accentEnd: "#414345")
]

let fileManager = FileManager.default
let outputDirectory = URL(fileURLWithPath: "Documentation/Assets/AppCards", isDirectory: true)

try fileManager.createDirectory(at: outputDirectory, withIntermediateDirectories: true)

func escaped(_ value: String) -> String {
    value
        .replacingOccurrences(of: "&", with: "&amp;")
        .replacingOccurrences(of: "\"", with: "&quot;")
        .replacingOccurrences(of: "<", with: "&lt;")
        .replacingOccurrences(of: ">", with: "&gt;")
}

for card in cards {
    let asset = """
    <svg width="1600" height="900" viewBox="0 0 1600 900" fill="none" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="bg" x1="140" y1="80" x2="1460" y2="820" gradientUnits="userSpaceOnUse">
          <stop stop-color="\(card.accentStart)"/>
          <stop offset="1" stop-color="\(card.accentEnd)"/>
        </linearGradient>
        <linearGradient id="panel" x1="280" y1="150" x2="1300" y2="720" gradientUnits="userSpaceOnUse">
          <stop stop-color="#0F172A" stop-opacity="0.92"/>
          <stop offset="1" stop-color="#111827" stop-opacity="0.82"/>
        </linearGradient>
      </defs>
      <rect width="1600" height="900" fill="#09111F"/>
      <rect x="48" y="48" width="1504" height="804" rx="36" fill="url(#bg)" opacity="0.95"/>
      <circle cx="1320" cy="160" r="180" fill="white" fill-opacity="0.08"/>
      <circle cx="240" cy="760" r="220" fill="white" fill-opacity="0.06"/>
      <rect x="120" y="112" width="1360" height="676" rx="34" fill="url(#panel)"/>
      <rect x="170" y="164" width="210" height="44" rx="22" fill="white" fill-opacity="0.13"/>
      <text x="196" y="193" fill="#E5E7EB" font-size="24" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">iOSAppTemplates</text>
      <text x="170" y="308" fill="white" font-size="78" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="800">\(escaped(card.id))</text>
      <text x="170" y="366" fill="#D1D5DB" font-size="34" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="600">\(escaped(card.lane))</text>
      <text x="170" y="456" fill="#E5E7EB" font-size="30" font-family="SF Pro Display, Helvetica, Arial, sans-serif">Standalone root</text>
      <text x="170" y="504" fill="#E5E7EB" font-size="30" font-family="SF Pro Display, Helvetica, Arial, sans-serif">Generic iOS build proof</text>
      <text x="170" y="552" fill="#E5E7EB" font-size="30" font-family="SF Pro Display, Helvetica, Arial, sans-serif">Per-app proof and media surface</text>
      <rect x="170" y="636" width="420" height="88" rx="24" fill="white" fill-opacity="0.12"/>
      <text x="208" y="692" fill="white" font-size="32" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">world-class lane card</text>
      <rect x="1026" y="208" width="304" height="304" rx="34" fill="white" fill-opacity="0.10"/>
      <rect x="892" y="368" width="364" height="214" rx="30" fill="white" fill-opacity="0.08"/>
      <rect x="1120" y="420" width="208" height="208" rx="30" fill="white" fill-opacity="0.10"/>
      <text x="1028" y="690" fill="#F9FAFB" font-size="28" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">Card published</text>
      <text x="1028" y="730" fill="#D1D5DB" font-size="24" font-family="SF Pro Display, Helvetica, Arial, sans-serif">Screenshots and demo clips pending</text>
    </svg>
    """

    let outputURL = outputDirectory.appendingPathComponent("\(card.id).svg")
    try asset.write(to: outputURL, atomically: true, encoding: .utf8)
}

print("Generated \(cards.count) gallery cards in \(outputDirectory.path)")
