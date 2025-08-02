import Foundation
import SwiftUI
import MapKit
import CoreLocation

// MARK: - Travel Templates
public struct TravelTemplates {
    
    // MARK: - Version
    public static let version = "1.0.0"
    
    // MARK: - Initialization
    public static func initialize() {
        print("🧳 Travel Templates v\(version) initialized")
    }
}

// MARK: - Travel App Template
public struct TravelAppTemplate {
    
    // MARK: - Models
    public struct Trip: Identifiable, Codable {
        public let id: String
        public let title: String
        public let description: String?
        public let destination: Destination
        public let startDate: Date
        public let endDate: Date
        public let status: TripStatus
        public let budget: Budget?
        public let itinerary: [ItineraryItem]
        public let bookings: [Booking]
        public let expenses: [Expense]
        public let photos: [Photo]
        public let notes: [Note]
        public let travelers: [Traveler]
        public let tags: [String]
        public let isPublic: Bool
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            description: String? = nil,
            destination: Destination,
            startDate: Date,
            endDate: Date,
            status: TripStatus = .planning,
            budget: Budget? = nil,
            itinerary: [ItineraryItem] = [],
            bookings: [Booking] = [],
            expenses: [Expense] = [],
            photos: [Photo] = [],
            notes: [Note] = [],
            travelers: [Traveler] = [],
            tags: [String] = [],
            isPublic: Bool = false,
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.destination = destination
            self.startDate = startDate
            self.endDate = endDate
            self.status = status
            self.budget = budget
            self.itinerary = itinerary
            self.bookings = bookings
            self.expenses = expenses
            self.photos = photos
            self.notes = notes
            self.travelers = travelers
            self.tags = tags
            self.isPublic = isPublic
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
        
        public var duration: Int {
            return Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        }
        
        public var isActive: Bool {
            let now = Date()
            return startDate <= now && endDate >= now
        }
        
        public var isUpcoming: Bool {
            return startDate > Date()
        }
        
        public var isCompleted: Bool {
            return endDate < Date()
        }
    }
    
    public struct Destination: Identifiable, Codable {
        public let id: String
        public let name: String
        public let country: String
        public let city: String?
        public let description: String?
        public let coordinates: Coordinates?
        public let timezone: String?
        public let currency: String?
        public let language: String?
        public let weather: Weather?
        public let attractions: [Attraction]
        public let photos: [String]
        public let rating: Double?
        public let reviewCount: Int
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            country: String,
            city: String? = nil,
            description: String? = nil,
            coordinates: Coordinates? = nil,
            timezone: String? = nil,
            currency: String? = nil,
            language: String? = nil,
            weather: Weather? = nil,
            attractions: [Attraction] = [],
            photos: [String] = [],
            rating: Double? = nil,
            reviewCount: Int = 0
        ) {
            self.id = id
            self.name = name
            self.country = country
            self.city = city
            self.description = description
            self.coordinates = coordinates
            self.timezone = timezone
            self.currency = currency
            self.language = language
            self.weather = weather
            self.attractions = attractions
            self.photos = photos
            self.rating = rating
            self.reviewCount = reviewCount
        }
    }
    
    public struct Coordinates: Codable {
        public let latitude: Double
        public let longitude: Double
        
        public init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    public struct Weather: Codable {
        public let temperature: Double
        public let condition: WeatherCondition
        public let humidity: Int
        public let windSpeed: Double
        public let forecast: [WeatherForecast]
        
        public init(
            temperature: Double,
            condition: WeatherCondition,
            humidity: Int,
            windSpeed: Double,
            forecast: [WeatherForecast] = []
        ) {
            self.temperature = temperature
            self.condition = condition
            self.humidity = humidity
            self.windSpeed = windSpeed
            self.forecast = forecast
        }
    }
    
    public struct WeatherForecast: Codable {
        public let date: Date
        public let temperature: Double
        public let condition: WeatherCondition
        public let precipitation: Double
        
        public init(
            date: Date,
            temperature: Double,
            condition: WeatherCondition,
            precipitation: Double
        ) {
            self.date = date
            self.temperature = temperature
            self.condition = condition
            self.precipitation = precipitation
        }
    }
    
    public struct Attraction: Identifiable, Codable {
        public let id: String
        public let name: String
        public let description: String?
        public let type: AttractionType
        public let coordinates: Coordinates?
        public let address: String?
        public let rating: Double?
        public let reviewCount: Int
        public let photos: [String]
        public let openingHours: [OpeningHours]
        public let price: Price?
        public let website: String?
        public let phone: String?
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            description: String? = nil,
            type: AttractionType,
            coordinates: Coordinates? = nil,
            address: String? = nil,
            rating: Double? = nil,
            reviewCount: Int = 0,
            photos: [String] = [],
            openingHours: [OpeningHours] = [],
            price: Price? = nil,
            website: String? = nil,
            phone: String? = nil
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.type = type
            self.coordinates = coordinates
            self.address = address
            self.rating = rating
            self.reviewCount = reviewCount
            self.photos = photos
            self.openingHours = openingHours
            self.price = price
            self.website = website
            self.phone = phone
        }
    }
    
    public struct OpeningHours: Codable {
        public let dayOfWeek: Int
        public let openTime: String
        public let closeTime: String
        public let isClosed: Bool
        
        public init(
            dayOfWeek: Int,
            openTime: String,
            closeTime: String,
            isClosed: Bool = false
        ) {
            self.dayOfWeek = dayOfWeek
            self.openTime = openTime
            self.closeTime = closeTime
            self.isClosed = isClosed
        }
    }
    
    public struct Price: Codable {
        public let amount: Double
        public let currency: String
        public let type: PriceType
        
        public init(amount: Double, currency: String, type: PriceType) {
            self.amount = amount
            self.currency = currency
            self.type = type
        }
    }
    
    public struct ItineraryItem: Identifiable, Codable {
        public let id: String
        public let title: String
        public let description: String?
        public let type: ItineraryItemType
        public let date: Date
        public let startTime: Date?
        public let endTime: Date?
        public let location: String?
        public let coordinates: Coordinates?
        public let attraction: Attraction?
        public let booking: Booking?
        public let notes: String?
        public let isCompleted: Bool
        public let order: Int
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            description: String? = nil,
            type: ItineraryItemType,
            date: Date,
            startTime: Date? = nil,
            endTime: Date? = nil,
            location: String? = nil,
            coordinates: Coordinates? = nil,
            attraction: Attraction? = nil,
            booking: Booking? = nil,
            notes: String? = nil,
            isCompleted: Bool = false,
            order: Int
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.type = type
            self.date = date
            self.startTime = startTime
            self.endTime = endTime
            self.location = location
            self.coordinates = coordinates
            self.attraction = attraction
            self.booking = booking
            self.notes = notes
            self.isCompleted = isCompleted
            self.order = order
        }
    }
    
    public struct Booking: Identifiable, Codable {
        public let id: String
        public let type: BookingType
        public let title: String
        public let description: String?
        public let provider: String
        public let confirmationNumber: String?
        public let bookingDate: Date
        public let checkInDate: Date?
        public let checkOutDate: Date?
        public let price: Price
        public let status: BookingStatus
        public let notes: String?
        public let attachments: [BookingAttachment]
        
        public init(
            id: String = UUID().uuidString,
            type: BookingType,
            title: String,
            description: String? = nil,
            provider: String,
            confirmationNumber: String? = nil,
            bookingDate: Date,
            checkInDate: Date? = nil,
            checkOutDate: Date? = nil,
            price: Price,
            status: BookingStatus = .confirmed,
            notes: String? = nil,
            attachments: [BookingAttachment] = []
        ) {
            self.id = id
            self.type = type
            self.title = title
            self.description = description
            self.provider = provider
            self.confirmationNumber = confirmationNumber
            self.bookingDate = bookingDate
            self.checkInDate = checkInDate
            self.checkOutDate = checkOutDate
            self.price = price
            self.status = status
            self.notes = notes
            self.attachments = attachments
        }
    }
    
    public struct BookingAttachment: Identifiable, Codable {
        public let id: String
        public let name: String
        public let url: String
        public let type: AttachmentType
        public let size: Int64
        public let uploadedAt: Date
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            url: String,
            type: AttachmentType,
            size: Int64,
            uploadedAt: Date = Date()
        ) {
            self.id = id
            self.name = name
            self.url = url
            self.type = type
            self.size = size
            self.uploadedAt = uploadedAt
        }
    }
    
    public struct Expense: Identifiable, Codable {
        public let id: String
        public let title: String
        public let amount: Double
        public let currency: String
        public let category: ExpenseCategory
        public let date: Date
        public let description: String?
        public let receipt: String?
        public let isShared: Bool
        public let sharedWith: [String]
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            amount: Double,
            currency: String,
            category: ExpenseCategory,
            date: Date,
            description: String? = nil,
            receipt: String? = nil,
            isShared: Bool = false,
            sharedWith: [String] = []
        ) {
            self.id = id
            self.title = title
            self.amount = amount
            self.currency = currency
            self.category = category
            self.date = date
            self.description = description
            self.receipt = receipt
            self.isShared = isShared
            self.sharedWith = sharedWith
        }
    }
    
    public struct Photo: Identifiable, Codable {
        public let id: String
        public let url: String
        public let caption: String?
        public let location: String?
        public let coordinates: Coordinates?
        public let date: Date
        public let tags: [String]
        
        public init(
            id: String = UUID().uuidString,
            url: String,
            caption: String? = nil,
            location: String? = nil,
            coordinates: Coordinates? = nil,
            date: Date = Date(),
            tags: [String] = []
        ) {
            self.id = id
            self.url = url
            self.caption = caption
            self.location = location
            self.coordinates = coordinates
            self.date = date
            self.tags = tags
        }
    }
    
    public struct Note: Identifiable, Codable {
        public let id: String
        public let title: String
        public let content: String
        public let date: Date
        public let location: String?
        public let coordinates: Coordinates?
        public let tags: [String]
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            content: String,
            date: Date = Date(),
            location: String? = nil,
            coordinates: Coordinates? = nil,
            tags: [String] = []
        ) {
            self.id = id
            self.title = title
            self.content = content
            self.date = date
            self.location = location
            self.coordinates = coordinates
            self.tags = tags
        }
    }
    
    public struct Traveler: Identifiable, Codable {
        public let id: String
        public let name: String
        public let email: String?
        public let phone: String?
        public let avatarURL: String?
        public let role: TravelerRole
        public let isActive: Bool
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            email: String? = nil,
            phone: String? = nil,
            avatarURL: String? = nil,
            role: TravelerRole = .traveler,
            isActive: Bool = true
        ) {
            self.id = id
            self.name = name
            self.email = email
            self.phone = phone
            self.avatarURL = avatarURL
            self.role = role
            self.isActive = isActive
        }
    }
    
    public struct Budget: Codable {
        public let total: Double
        public let currency: String
        public let categories: [BudgetCategory]
        public let spent: Double
        public let remaining: Double
        
        public init(
            total: Double,
            currency: String,
            categories: [BudgetCategory] = [],
            spent: Double = 0.0
        ) {
            self.total = total
            self.currency = currency
            self.categories = categories
            self.spent = spent
            self.remaining = total - spent
        }
        
        public var percentageSpent: Double {
            return total > 0 ? (spent / total) * 100 : 0
        }
    }
    
    public struct BudgetCategory: Identifiable, Codable {
        public let id: String
        public let name: String
        public let allocated: Double
        public let spent: Double
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            allocated: Double,
            spent: Double = 0.0
        ) {
            self.id = id
            self.name = name
            self.allocated = allocated
            self.spent = spent
        }
        
        public var remaining: Double {
            return allocated - spent
        }
        
        public var percentageSpent: Double {
            return allocated > 0 ? (spent / allocated) * 100 : 0
        }
    }
    
    // MARK: - Enums
    public enum TripStatus: String, CaseIterable, Codable {
        case planning = "planning"
        case booked = "booked"
        case active = "active"
        case completed = "completed"
        case cancelled = "cancelled"
        
        public var displayName: String {
            switch self {
            case .planning: return "Planning"
            case .booked: return "Booked"
            case .active: return "Active"
            case .completed: return "Completed"
            case .cancelled: return "Cancelled"
            }
        }
        
        public var color: String {
            switch self {
            case .planning: return "blue"
            case .booked: return "orange"
            case .active: return "green"
            case .completed: return "gray"
            case .cancelled: return "red"
            }
        }
    }
    
    public enum WeatherCondition: String, CaseIterable, Codable {
        case sunny = "sunny"
        case cloudy = "cloudy"
        case rainy = "rainy"
        case snowy = "snowy"
        case stormy = "stormy"
        case foggy = "foggy"
        case windy = "windy"
        
        public var displayName: String {
            switch self {
            case .sunny: return "Sunny"
            case .cloudy: return "Cloudy"
            case .rainy: return "Rainy"
            case .snowy: return "Snowy"
            case .stormy: return "Stormy"
            case .foggy: return "Foggy"
            case .windy: return "Windy"
            }
        }
        
        public var icon: String {
            switch self {
            case .sunny: return "sun.max.fill"
            case .cloudy: return "cloud.fill"
            case .rainy: return "cloud.rain.fill"
            case .snowy: return "cloud.snow.fill"
            case .stormy: return "cloud.bolt.rain.fill"
            case .foggy: return "cloud.fog.fill"
            case .windy: return "wind"
            }
        }
    }
    
    public enum AttractionType: String, CaseIterable, Codable {
        case museum = "museum"
        case park = "park"
        case restaurant = "restaurant"
        case hotel = "hotel"
        case shopping = "shopping"
        case entertainment = "entertainment"
        case historical = "historical"
        case natural = "natural"
        case sports = "sports"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .museum: return "Museum"
            case .park: return "Park"
            case .restaurant: return "Restaurant"
            case .hotel: return "Hotel"
            case .shopping: return "Shopping"
            case .entertainment: return "Entertainment"
            case .historical: return "Historical"
            case .natural: return "Natural"
            case .sports: return "Sports"
            case .other: return "Other"
            }
        }
        
        public var icon: String {
            switch self {
            case .museum: return "building.columns"
            case .park: return "leaf.fill"
            case .restaurant: return "fork.knife"
            case .hotel: return "bed.double.fill"
            case .shopping: return "bag.fill"
            case .entertainment: return "gamecontroller.fill"
            case .historical: return "building.2"
            case .natural: return "mountain.2"
            case .sports: return "sportscourt.fill"
            case .other: return "ellipsis.circle"
            }
        }
    }
    
    public enum PriceType: String, CaseIterable, Codable {
        case perPerson = "per_person"
        case perNight = "per_night"
        case perDay = "per_day"
        case total = "total"
        
        public var displayName: String {
            switch self {
            case .perPerson: return "Per Person"
            case .perNight: return "Per Night"
            case .perDay: return "Per Day"
            case .total: return "Total"
            }
        }
    }
    
    public enum ItineraryItemType: String, CaseIterable, Codable {
        case flight = "flight"
        case hotel = "hotel"
        case activity = "activity"
        case meal = "meal"
        case transportation = "transportation"
        case sightseeing = "sightseeing"
        case rest = "rest"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .flight: return "Flight"
            case .hotel: return "Hotel"
            case .activity: return "Activity"
            case .meal: return "Meal"
            case .transportation: return "Transportation"
            case .sightseeing: return "Sightseeing"
            case .rest: return "Rest"
            case .other: return "Other"
            }
        }
        
        public var icon: String {
            switch self {
            case .flight: return "airplane"
            case .hotel: return "bed.double.fill"
            case .activity: return "figure.hiking"
            case .meal: return "fork.knife"
            case .transportation: return "car.fill"
            case .sightseeing: return "camera.fill"
            case .rest: return "moon.fill"
            case .other: return "ellipsis.circle"
            }
        }
    }
    
    public enum BookingType: String, CaseIterable, Codable {
        case flight = "flight"
        case hotel = "hotel"
        case car = "car"
        case activity = "activity"
        case restaurant = "restaurant"
        case event = "event"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .flight: return "Flight"
            case .hotel: return "Hotel"
            case .car: return "Car"
            case .activity: return "Activity"
            case .restaurant: return "Restaurant"
            case .event: return "Event"
            case .other: return "Other"
            }
        }
    }
    
    public enum BookingStatus: String, CaseIterable, Codable {
        case pending = "pending"
        case confirmed = "confirmed"
        case cancelled = "cancelled"
        case completed = "completed"
        
        public var displayName: String {
            switch self {
            case .pending: return "Pending"
            case .confirmed: return "Confirmed"
            case .cancelled: return "Cancelled"
            case .completed: return "Completed"
            }
        }
        
        public var color: String {
            switch self {
            case .pending: return "orange"
            case .confirmed: return "green"
            case .cancelled: return "red"
            case .completed: return "blue"
            }
        }
    }
    
    public enum ExpenseCategory: String, CaseIterable, Codable {
        case accommodation = "accommodation"
        case transportation = "transportation"
        case food = "food"
        case activities = "activities"
        case shopping = "shopping"
        case entertainment = "entertainment"
        case insurance = "insurance"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .accommodation: return "Accommodation"
            case .transportation: return "Transportation"
            case .food: return "Food"
            case .activities: return "Activities"
            case .shopping: return "Shopping"
            case .entertainment: return "Entertainment"
            case .insurance: return "Insurance"
            case .other: return "Other"
            }
        }
        
        public var icon: String {
            switch self {
            case .accommodation: return "bed.double.fill"
            case .transportation: return "car.fill"
            case .food: return "fork.knife"
            case .activities: return "figure.hiking"
            case .shopping: return "bag.fill"
            case .entertainment: return "gamecontroller.fill"
            case .insurance: return "shield.fill"
            case .other: return "ellipsis.circle"
            }
        }
    }
    
    public enum TravelerRole: String, CaseIterable, Codable {
        case organizer = "organizer"
        case traveler = "traveler"
        case guest = "guest"
        
        public var displayName: String {
            switch self {
            case .organizer: return "Organizer"
            case .traveler: return "Traveler"
            case .guest: return "Guest"
            }
        }
    }
    
    public enum AttachmentType: String, CaseIterable, Codable {
        case receipt = "receipt"
        case ticket = "ticket"
        case confirmation = "confirmation"
        case other = "other"
        
        public var displayName: String {
            switch self {
            case .receipt: return "Receipt"
            case .ticket: return "Ticket"
            case .confirmation: return "Confirmation"
            case .other: return "Other"
            }
        }
    }
    
    // MARK: - Managers
    public class TravelManager: ObservableObject {
        
        @Published public var trips: [Trip] = []
        @Published public var destinations: [Destination] = []
        @Published public var isLoading = false
        
        private let locationManager = LocationManager()
        private let weatherManager = WeatherManager()
        private let dataManager = DataManager()
        
        public init() {}
        
        // MARK: - Trip Methods
        
        public func createTrip(_ trip: Trip) async throws {
            isLoading = true
            defer { isLoading = false }
            
            trips.append(trip)
            try await dataManager.saveTrips(trips)
        }
        
        public func updateTrip(_ trip: Trip) async throws {
            guard let index = trips.firstIndex(where: { $0.id == trip.id }) else {
                throw TravelError.tripNotFound
            }
            
            isLoading = true
            defer { isLoading = false }
            
            trips[index] = trip
            try await dataManager.saveTrips(trips)
        }
        
        public func deleteTrip(_ tripId: String) async throws {
            guard let index = trips.firstIndex(where: { $0.id == tripId }) else {
                throw TravelError.tripNotFound
            }
            
            isLoading = true
            defer { isLoading = false }
            
            trips.remove(at: index)
            try await dataManager.saveTrips(trips)
        }
        
        public func getActiveTrips() -> [Trip] {
            return trips.filter { $0.isActive }
        }
        
        public func getUpcomingTrips() -> [Trip] {
            return trips.filter { $0.isUpcoming }
        }
        
        public func getCompletedTrips() -> [Trip] {
            return trips.filter { $0.isCompleted }
        }
        
        public func getTripsByStatus(_ status: TripStatus) -> [Trip] {
            return trips.filter { $0.status == status }
        }
        
        // MARK: - Destination Methods
        
        public func searchDestinations(query: String) async throws -> [Destination] {
            isLoading = true
            defer { isLoading = false }
            
            // Implementation for searching destinations
            return []
        }
        
        public func getDestinationWeather(_ destination: Destination) async throws -> Weather? {
            guard let coordinates = destination.coordinates else {
                return nil
            }
            
            return try await weatherManager.getWeather(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude
            )
        }
        
        // MARK: - Itinerary Methods
        
        public func addItineraryItem(_ item: ItineraryItem, to tripId: String) async throws {
            guard let tripIndex = trips.firstIndex(where: { $0.id == tripId }) else {
                throw TravelError.tripNotFound
            }
            
            var trip = trips[tripIndex]
            trip.itinerary.append(item)
            trip.itinerary.sort { $0.order < $1.order }
            
            trips[tripIndex] = trip
            try await dataManager.saveTrips(trips)
        }
        
        public func updateItineraryItem(_ item: ItineraryItem, in tripId: String) async throws {
            guard let tripIndex = trips.firstIndex(where: { $0.id == tripId }),
                  let itemIndex = trips[tripIndex].itinerary.firstIndex(where: { $0.id == item.id }) else {
                throw TravelError.itemNotFound
            }
            
            var trip = trips[tripIndex]
            trip.itinerary[itemIndex] = item
            
            trips[tripIndex] = trip
            try await dataManager.saveTrips(trips)
        }
        
        public func deleteItineraryItem(_ itemId: String, from tripId: String) async throws {
            guard let tripIndex = trips.firstIndex(where: { $0.id == tripId }) else {
                throw TravelError.tripNotFound
            }
            
            var trip = trips[tripIndex]
            trip.itinerary.removeAll { $0.id == itemId }
            
            trips[tripIndex] = trip
            try await dataManager.saveTrips(trips)
        }
        
        // MARK: - Booking Methods
        
        public func addBooking(_ booking: Booking, to tripId: String) async throws {
            guard let tripIndex = trips.firstIndex(where: { $0.id == tripId }) else {
                throw TravelError.tripNotFound
            }
            
            var trip = trips[tripIndex]
            trip.bookings.append(booking)
            
            trips[tripIndex] = trip
            try await dataManager.saveTrips(trips)
        }
        
        public func updateBooking(_ booking: Booking, in tripId: String) async throws {
            guard let tripIndex = trips.firstIndex(where: { $0.id == tripId }),
                  let bookingIndex = trips[tripIndex].bookings.firstIndex(where: { $0.id == booking.id }) else {
                throw TravelError.bookingNotFound
            }
            
            var trip = trips[tripIndex]
            trip.bookings[bookingIndex] = booking
            
            trips[tripIndex] = trip
            try await dataManager.saveTrips(trips)
        }
        
        // MARK: - Expense Methods
        
        public func addExpense(_ expense: Expense, to tripId: String) async throws {
            guard let tripIndex = trips.firstIndex(where: { $0.id == tripId }) else {
                throw TravelError.tripNotFound
            }
            
            var trip = trips[tripIndex]
            trip.expenses.append(expense)
            
            trips[tripIndex] = trip
            try await dataManager.saveTrips(trips)
        }
        
        public func getTotalExpenses(for tripId: String) -> Double {
            guard let trip = trips.first(where: { $0.id == tripId }) else {
                return 0
            }
            
            return trip.expenses.reduce(0) { $0 + $1.amount }
        }
        
        public func getExpensesByCategory(for tripId: String) -> [ExpenseCategory: Double] {
            guard let trip = trips.first(where: { $0.id == tripId }) else {
                return [:]
            }
            
            var result: [ExpenseCategory: Double] = [:]
            for expense in trip.expenses {
                result[expense.category, default: 0] += expense.amount
            }
            
            return result
        }
    }
    
    public class LocationManager {
        
        private let locationManager = CLLocationManager()
        
        public init() {}
        
        public func requestLocationPermission() async -> Bool {
            // Implementation for requesting location permission
            return true
        }
        
        public func getCurrentLocation() async throws -> Coordinates? {
            // Implementation for getting current location
            return nil
        }
        
        public func getDistance(from: Coordinates, to: Coordinates) -> Double {
            let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
            let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
            
            return fromLocation.distance(from: toLocation)
        }
    }
    
    public class WeatherManager {
        
        public init() {}
        
        public func getWeather(latitude: Double, longitude: Double) async throws -> Weather? {
            // Implementation for getting weather data
            return nil
        }
        
        public func getWeatherForecast(latitude: Double, longitude: Double) async throws -> [WeatherForecast] {
            // Implementation for getting weather forecast
            return []
        }
    }
    
    public class DataManager {
        
        private let userDefaults = UserDefaults.standard
        
        public init() {}
        
        public func saveTrips(_ trips: [Trip]) async throws {
            let data = try JSONEncoder().encode(trips)
            userDefaults.set(data, forKey: "saved_trips")
        }
        
        public func loadTrips() async throws -> [Trip] {
            guard let data = userDefaults.data(forKey: "saved_trips") else {
                return []
            }
            
            return try JSONDecoder().decode([Trip].self, from: data)
        }
        
        public func saveDestinations(_ destinations: [Destination]) async throws {
            let data = try JSONEncoder().encode(destinations)
            userDefaults.set(data, forKey: "saved_destinations")
        }
        
        public func loadDestinations() async throws -> [Destination] {
            guard let data = userDefaults.data(forKey: "saved_destinations") else {
                return []
            }
            
            return try JSONDecoder().decode([Destination].self, from: data)
        }
    }
    
    // MARK: - UI Components
    
    public struct TripCard: View {
        let trip: Trip
        let onTap: () -> Void
        
        public init(trip: Trip, onTap: @escaping () -> Void) {
            self.trip = trip
            self.onTap = onTap
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(trip.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(trip.destination.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(trip.status.displayName)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(trip.status.color).opacity(0.2))
                            .foregroundColor(Color(trip.status.color))
                            .cornerRadius(4)
                        
                        Text("\(trip.duration) days")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Date range
                HStack {
                    VStack(alignment: .leading) {
                        Text("From")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(trip.startDate, style: .date)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("To")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(trip.endDate, style: .date)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
                
                // Stats
                HStack(spacing: 20) {
                    VStack {
                        Text("\(trip.itinerary.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Items")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Text("\(trip.bookings.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Bookings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Text("\(trip.travelers.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Travelers")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                // Progress
                if trip.status == .active {
                    let completedItems = trip.itinerary.filter { $0.isCompleted }.count
                    let totalItems = trip.itinerary.count
                    
                    if totalItems > 0 {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Progress")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("\(completedItems)/\(totalItems)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            ProgressView(value: Double(completedItems), total: Double(totalItems))
                                .progressViewStyle(LinearProgressViewStyle())
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
    
    public struct DestinationCard: View {
        let destination: Destination
        let onTap: () -> Void
        
        public init(destination: Destination, onTap: @escaping () -> Void) {
            self.destination = destination
            self.onTap = onTap
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                // Destination Image
                if !destination.photos.isEmpty {
                    AsyncImage(url: URL(string: destination.photos[0])) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "photo")
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
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.gray)
                                .font(.title)
                        )
                }
                
                // Destination Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(destination.name)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(destination.country)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        if let rating = destination.rating {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                Text(String(format: "%.1f", rating))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Text("\(destination.attractions.count) attractions")
                            .font(.caption)
                            .foregroundColor(.secondary)
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
    
    // MARK: - Errors
    
    public enum TravelError: LocalizedError {
        case tripNotFound
        case destinationNotFound
        case itemNotFound
        case bookingNotFound
        case expenseNotFound
        case invalidData
        case networkError
        case locationError
        case weatherError
        case saveError
        
        public var errorDescription: String? {
            switch self {
            case .tripNotFound:
                return "Trip not found"
            case .destinationNotFound:
                return "Destination not found"
            case .itemNotFound:
                return "Itinerary item not found"
            case .bookingNotFound:
                return "Booking not found"
            case .expenseNotFound:
                return "Expense not found"
            case .invalidData:
                return "Invalid data"
            case .networkError:
                return "Network error occurred"
            case .locationError:
                return "Location error occurred"
            case .weatherError:
                return "Weather error occurred"
            case .saveError:
                return "Failed to save data"
            }
        }
    }
} 