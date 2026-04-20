import Foundation

struct PreviewApp {
    let id: String
    let lane: String
    let accentStart: String
    let accentEnd: String
    let focusA: String
    let focusB: String
    let focusC: String
}

let apps: [PreviewApp] = [
    .init(id: "EcommerceApp", lane: "Commerce", accentStart: "#FF7A18", accentEnd: "#FFB347", focusA: "Catalog", focusB: "Cart", focusC: "Checkout"),
    .init(id: "SocialMediaApp", lane: "Social", accentStart: "#0061FF", accentEnd: "#60EFFF", focusA: "Feed", focusB: "Community", focusC: "Profile"),
    .init(id: "FitnessApp", lane: "Health / Fitness", accentStart: "#11998E", accentEnd: "#38EF7D", focusA: "Progress", focusB: "Workout", focusC: "Recovery"),
    .init(id: "ProductivityApp", lane: "Productivity", accentStart: "#3A1C71", accentEnd: "#D76D77", focusA: "Inbox", focusB: "Projects", focusC: "Focus"),
    .init(id: "FinanceApp", lane: "Finance", accentStart: "#134E5E", accentEnd: "#71B280", focusA: "Accounts", focusB: "Budget", focusC: "Cashflow"),
    .init(id: "EducationApp", lane: "Education", accentStart: "#4E54C8", accentEnd: "#8F94FB", focusA: "Courses", focusB: "Lessons", focusC: "Quiz"),
    .init(id: "FoodDeliveryApp", lane: "Food Delivery", accentStart: "#CB2D3E", accentEnd: "#EF473A", focusA: "Discovery", focusB: "Cart", focusC: "Tracking"),
    .init(id: "TravelPlannerApp", lane: "Travel", accentStart: "#2BC0E4", accentEnd: "#EAECC6", focusA: "Trips", focusB: "Itinerary", focusC: "Bookings"),
    .init(id: "AIAssistantApp", lane: "AI", accentStart: "#141E30", accentEnd: "#243B55", focusA: "Workspace", focusB: "Suggestions", focusC: "Trust"),
    .init(id: "NewsBlogApp", lane: "News", accentStart: "#355C7D", accentEnd: "#C06C84", focusA: "Briefing", focusB: "Sections", focusC: "Reader"),
    .init(id: "MusicPodcastApp", lane: "Music / Podcast", accentStart: "#DA4453", accentEnd: "#89216B", focusA: "Player", focusB: "Queue", focusC: "Offline"),
    .init(id: "MarketplaceApp", lane: "Marketplace", accentStart: "#283048", accentEnd: "#859398", focusA: "Listings", focusB: "Sellers", focusC: "Trust"),
    .init(id: "MessagingApp", lane: "Messaging / Community", accentStart: "#1D976C", accentEnd: "#93F9B9", focusA: "Inbox", focusB: "Rooms", focusC: "Moderation"),
    .init(id: "BookingReservationsApp", lane: "Booking / Reservations", accentStart: "#4B79A1", accentEnd: "#283E51", focusA: "Reservations", focusB: "Guests", focusC: "Support"),
    .init(id: "NotesKnowledgeApp", lane: "Notes / Knowledge", accentStart: "#F7971E", accentEnd: "#FFD200", focusA: "Notes", focusB: "Collections", focusC: "Links"),
    .init(id: "CreatorShortVideoApp", lane: "Creator / Short Video", accentStart: "#654EA3", accentEnd: "#EAafc8", focusA: "Studio", focusB: "Clips", focusC: "Publish"),
    .init(id: "TeamCollaborationApp", lane: "Team Collaboration", accentStart: "#0F2027", accentEnd: "#2C5364", focusA: "Workspace", focusB: "Projects", focusC: "Handoffs"),
    .init(id: "CRMAdminApp", lane: "CRM / Admin", accentStart: "#7F00FF", accentEnd: "#E100FF", focusA: "Accounts", focusB: "Renewals", focusC: "SLA"),
    .init(id: "SubscriptionLifestyleApp", lane: "Subscription Lifestyle", accentStart: "#F953C6", accentEnd: "#B91D73", focusA: "Retention", focusB: "Programs", focusC: "Paywall"),
    .init(id: "PrivacyVaultApp", lane: "Privacy / Secure Vault", accentStart: "#232526", accentEnd: "#414345", focusA: "Vault", focusB: "Access", focusC: "Recovery")
]

let fileManager = FileManager.default
let outputDirectory = URL(fileURLWithPath: "Documentation/Assets/AppPreviews", isDirectory: true)
try fileManager.createDirectory(at: outputDirectory, withIntermediateDirectories: true)

func escape(_ value: String) -> String {
    value
        .replacingOccurrences(of: "&", with: "&amp;")
        .replacingOccurrences(of: "<", with: "&lt;")
        .replacingOccurrences(of: ">", with: "&gt;")
}

for app in apps {
    let svg = """
    <svg width="1600" height="1000" viewBox="0 0 1600 1000" fill="none" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="bg" x1="110" y1="70" x2="1490" y2="930" gradientUnits="userSpaceOnUse">
          <stop stop-color="\(app.accentStart)"/>
          <stop offset="1" stop-color="\(app.accentEnd)"/>
        </linearGradient>
        <linearGradient id="panel" x1="130" y1="104" x2="1460" y2="908" gradientUnits="userSpaceOnUse">
          <stop stop-color="#020617" stop-opacity="0.95"/>
          <stop offset="1" stop-color="#111827" stop-opacity="0.88"/>
        </linearGradient>
      </defs>
      <rect width="1600" height="1000" fill="#020617"/>
      <rect x="36" y="36" width="1528" height="928" rx="40" fill="url(#bg)"/>
      <rect x="92" y="92" width="1416" height="816" rx="34" fill="url(#panel)"/>
      <rect x="138" y="132" width="250" height="44" rx="22" fill="white" fill-opacity="0.12"/>
      <text x="170" y="161" fill="#E5E7EB" font-size="24" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">preview board</text>
      <text x="138" y="274" fill="white" font-size="72" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="800">\(escape(app.id))</text>
      <text x="138" y="330" fill="#D1D5DB" font-size="34" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="600">\(escape(app.lane))</text>
      <text x="138" y="412" fill="#F8FAFC" font-size="28" font-family="SF Pro Display, Helvetica, Arial, sans-serif">Visual product board published.</text>
      <text x="138" y="454" fill="#E5E7EB" font-size="26" font-family="SF Pro Display, Helvetica, Arial, sans-serif">Runtime screenshots and demo clips still pending.</text>
      <rect x="138" y="518" width="182" height="64" rx="20" fill="white" fill-opacity="0.10"/>
      <text x="172" y="558" fill="white" font-size="28" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">\(escape(app.focusA))</text>
      <rect x="336" y="518" width="182" height="64" rx="20" fill="white" fill-opacity="0.10"/>
      <text x="370" y="558" fill="white" font-size="28" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">\(escape(app.focusB))</text>
      <rect x="534" y="518" width="182" height="64" rx="20" fill="white" fill-opacity="0.10"/>
      <text x="568" y="558" fill="white" font-size="28" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">\(escape(app.focusC))</text>

      <rect x="840" y="144" width="524" height="680" rx="44" fill="white" fill-opacity="0.08"/>
      <rect x="876" y="184" width="452" height="78" rx="24" fill="white" fill-opacity="0.10"/>
      <rect x="876" y="286" width="274" height="208" rx="28" fill="white" fill-opacity="0.11"/>
      <rect x="1170" y="286" width="158" height="98" rx="24" fill="white" fill-opacity="0.09"/>
      <rect x="1170" y="396" width="158" height="98" rx="24" fill="white" fill-opacity="0.09"/>
      <rect x="876" y="526" width="452" height="112" rx="28" fill="white" fill-opacity="0.10"/>
      <rect x="876" y="662" width="214" height="110" rx="28" fill="white" fill-opacity="0.10"/>
      <rect x="1114" y="662" width="214" height="110" rx="28" fill="white" fill-opacity="0.10"/>
      <text x="904" y="232" fill="#F8FAFC" font-size="30" font-family="SF Pro Display, Helvetica, Arial, sans-serif" font-weight="700">dashboard shell</text>
      <text x="904" y="588" fill="#E5E7EB" font-size="24" font-family="SF Pro Display, Helvetica, Arial, sans-serif">app proof route</text>
      <text x="904" y="724" fill="#E5E7EB" font-size="24" font-family="SF Pro Display, Helvetica, Arial, sans-serif">media route</text>
      <text x="1142" y="724" fill="#E5E7EB" font-size="24" font-family="SF Pro Display, Helvetica, Arial, sans-serif">gallery card</text>
    </svg>
    """

    let outputURL = outputDirectory.appendingPathComponent("\(app.id).svg")
    try svg.write(to: outputURL, atomically: true, encoding: .utf8)
}

print("Generated \(apps.count) preview boards in \(outputDirectory.path)")
