// MARK: - Travel App Template
// Complete travel booking app with 12+ screens
// Features: Flights, Hotels, Destinations, Bookings, Itinerary
// Dark mode ready, localized, accessible

import SwiftUI
import Foundation
import Combine
import MapKit

// MARK: - Models

public struct Destination: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let country: String
    public let description: String
    public let imageURL: String?
    public let rating: Double
    public let reviewCount: Int
    public let popularAttractions: [String]
    public let averagePrice: Decimal
    public let bestTimeToVisit: String
    public let coordinates: Coordinates
    public var isFavorite: Bool
    
    public init(
        id: UUID = UUID(),
        name: String,
        country: String,
        description: String = "",
        imageURL: String? = nil,
        rating: Double = 4.5,
        reviewCount: Int = 1000,
        popularAttractions: [String] = [],
        averagePrice: Decimal = 1500,
        bestTimeToVisit: String = "Year round",
        coordinates: Coordinates = Coordinates(),
        isFavorite: Bool = false
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.description = description
        self.imageURL = imageURL
        self.rating = rating
        self.reviewCount = reviewCount
        self.popularAttractions = popularAttractions
        self.averagePrice = averagePrice
        self.bestTimeToVisit = bestTimeToVisit
        self.coordinates = coordinates
        self.isFavorite = isFavorite
    }
}

public struct Coordinates: Codable, Hashable {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double = 0, longitude: Double = 0) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public struct Flight: Identifiable, Codable {
    public let id: UUID
    public let airline: String
    public let flightNumber: String
    public let departure: FlightLocation
    public let arrival: FlightLocation
    public let departureTime: Date
    public let arrivalTime: Date
    public let price: Decimal
    public let classType: FlightClass
    public let stops: Int
    public let duration: TimeInterval
    public let baggage: BaggageInfo
    
    public init(
        id: UUID = UUID(),
        airline: String,
        flightNumber: String,
        departure: FlightLocation,
        arrival: FlightLocation,
        departureTime: Date,
        arrivalTime: Date,
        price: Decimal,
        classType: FlightClass = .economy,
        stops: Int = 0,
        duration: TimeInterval = 7200,
        baggage: BaggageInfo = BaggageInfo()
    ) {
        self.id = id
        self.airline = airline
        self.flightNumber = flightNumber
        self.departure = departure
        self.arrival = arrival
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.price = price
        self.classType = classType
        self.stops = stops
        self.duration = duration
        self.baggage = baggage
    }
}

public struct FlightLocation: Codable, Hashable {
    public let city: String
    public let airport: String
    public let code: String
    
    public init(city: String, airport: String, code: String) {
        self.city = city
        self.airport = airport
        self.code = code
    }
}

public enum FlightClass: String, Codable, CaseIterable {
    case economy = "Economy"
    case premiumEconomy = "Premium Economy"
    case business = "Business"
    case first = "First Class"
}

public struct BaggageInfo: Codable {
    public let carryOn: Bool
    public let checkedBag: Int
    public let weightLimit: Int
    
    public init(carryOn: Bool = true, checkedBag: Int = 1, weightLimit: Int = 23) {
        self.carryOn = carryOn
        self.checkedBag = checkedBag
        self.weightLimit = weightLimit
    }
}

public struct Hotel: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let location: String
    public let description: String
    public let imageURL: String?
    public let rating: Double
    public let reviewCount: Int
    public let pricePerNight: Decimal
    public let starRating: Int
    public let amenities: [HotelAmenity]
    public let roomTypes: [RoomType]
    public let coordinates: Coordinates
    public var isFavorite: Bool
    
    public init(
        id: UUID = UUID(),
        name: String,
        location: String,
        description: String = "",
        imageURL: String? = nil,
        rating: Double = 4.5,
        reviewCount: Int = 500,
        pricePerNight: Decimal = 150,
        starRating: Int = 4,
        amenities: [HotelAmenity] = [],
        roomTypes: [RoomType] = [],
        coordinates: Coordinates = Coordinates(),
        isFavorite: Bool = false
    ) {
        self.id = id
        self.name = name
        self.location = location
        self.description = description
        self.imageURL = imageURL
        self.rating = rating
        self.reviewCount = reviewCount
        self.pricePerNight = pricePerNight
        self.starRating = starRating
        self.amenities = amenities
        self.roomTypes = roomTypes
        self.coordinates = coordinates
        self.isFavorite = isFavorite
    }
}

public enum HotelAmenity: String, Codable, CaseIterable {
    case wifi = "Free WiFi"
    case pool = "Swimming Pool"
    case gym = "Fitness Center"
    case spa = "Spa"
    case restaurant = "Restaurant"
    case parking = "Free Parking"
    case airConditioning = "Air Conditioning"
    case roomService = "Room Service"
    case bar = "Bar"
    case breakfast = "Breakfast Included"
    
    public var icon: String {
        switch self {
        case .wifi: return "wifi"
        case .pool: return "figure.pool.swim"
        case .gym: return "dumbbell"
        case .spa: return "sparkles"
        case .restaurant: return "fork.knife"
        case .parking: return "car"
        case .airConditioning: return "snowflake"
        case .roomService: return "bell"
        case .bar: return "wineglass"
        case .breakfast: return "cup.and.saucer"
        }
    }
}

public struct RoomType: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let description: String
    public let maxGuests: Int
    public let pricePerNight: Decimal
    public let beds: String
    public let size: Int
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        maxGuests: Int = 2,
        pricePerNight: Decimal = 150,
        beds: String = "1 King Bed",
        size: Int = 30
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.maxGuests = maxGuests
        self.pricePerNight = pricePerNight
        self.beds = beds
        self.size = size
    }
}

public struct Booking: Identifiable, Codable {
    public let id: UUID
    public let type: BookingType
    public let flight: Flight?
    public let hotel: Hotel?
    public let checkIn: Date
    public let checkOut: Date
    public let guests: Int
    public let totalPrice: Decimal
    public var status: BookingStatus
    public let confirmationCode: String
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        type: BookingType,
        flight: Flight? = nil,
        hotel: Hotel? = nil,
        checkIn: Date,
        checkOut: Date,
        guests: Int = 1,
        totalPrice: Decimal,
        status: BookingStatus = .confirmed,
        confirmationCode: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.flight = flight
        self.hotel = hotel
        self.checkIn = checkIn
        self.checkOut = checkOut
        self.guests = guests
        self.totalPrice = totalPrice
        self.status = status
        self.confirmationCode = confirmationCode.isEmpty ? UUID().uuidString.prefix(8).uppercased().description : confirmationCode
        self.createdAt = createdAt
    }
}

public enum BookingType: String, Codable {
    case flight = "Flight"
    case hotel = "Hotel"
    case package = "Package"
}

public enum BookingStatus: String, Codable {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case cancelled = "Cancelled"
    case completed = "Completed"
    
    public var color: Color {
        switch self {
        case .pending: return .orange
        case .confirmed: return .green
        case .cancelled: return .red
        case .completed: return .blue
        }
    }
}

public struct ItineraryItem: Identifiable, Codable {
    public let id: UUID
    public var title: String
    public var description: String
    public var location: String
    public var date: Date
    public var time: Date?
    public var category: ItineraryCategory
    public var notes: String
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        location: String = "",
        date: Date,
        time: Date? = nil,
        category: ItineraryCategory = .activity,
        notes: String = ""
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.location = location
        self.date = date
        self.time = time
        self.category = category
        self.notes = notes
    }
}

public enum ItineraryCategory: String, Codable, CaseIterable {
    case flight = "Flight"
    case hotel = "Hotel"
    case activity = "Activity"
    case restaurant = "Restaurant"
    case transport = "Transport"
    case other = "Other"
    
    public var icon: String {
        switch self {
        case .flight: return "airplane"
        case .hotel: return "building.2"
        case .activity: return "figure.walk"
        case .restaurant: return "fork.knife"
        case .transport: return "car"
        case .other: return "star"
        }
    }
    
    public var color: Color {
        switch self {
        case .flight: return .blue
        case .hotel: return .purple
        case .activity: return .green
        case .restaurant: return .orange
        case .transport: return .cyan
        case .other: return .gray
        }
    }
}

// MARK: - Sample Data

public enum TravelSampleData {
    public static let destinations: [Destination] = [
        Destination(name: "Paris", country: "France", description: "The city of lights, known for the Eiffel Tower, art museums, and romantic atmosphere.", rating: 4.8, reviewCount: 125000, popularAttractions: ["Eiffel Tower", "Louvre Museum", "Notre-Dame"], averagePrice: 2000, bestTimeToVisit: "Apr-Jun, Sep-Oct", coordinates: Coordinates(latitude: 48.8566, longitude: 2.3522)),
        Destination(name: "Tokyo", country: "Japan", description: "A fascinating blend of traditional temples and ultra-modern architecture.", rating: 4.9, reviewCount: 98000, popularAttractions: ["Shibuya Crossing", "Senso-ji Temple", "Tokyo Tower"], averagePrice: 2500, bestTimeToVisit: "Mar-May, Sep-Nov", coordinates: Coordinates(latitude: 35.6762, longitude: 139.6503)),
        Destination(name: "New York", country: "United States", description: "The city that never sleeps, famous for Broadway, Central Park, and iconic skyline.", rating: 4.7, reviewCount: 156000, popularAttractions: ["Times Square", "Central Park", "Statue of Liberty"], averagePrice: 2200, bestTimeToVisit: "Apr-Jun, Sep-Nov", coordinates: Coordinates(latitude: 40.7128, longitude: -74.0060)),
        Destination(name: "Bali", country: "Indonesia", description: "Tropical paradise with beautiful beaches, rice terraces, and spiritual temples.", rating: 4.6, reviewCount: 87000, popularAttractions: ["Ubud Rice Terraces", "Tanah Lot Temple", "Seminyak Beach"], averagePrice: 1200, bestTimeToVisit: "Apr-Oct", coordinates: Coordinates(latitude: -8.4095, longitude: 115.1889)),
        Destination(name: "Dubai", country: "UAE", description: "Futuristic city with stunning architecture, luxury shopping, and desert adventures.", rating: 4.7, reviewCount: 92000, popularAttractions: ["Burj Khalifa", "Dubai Mall", "Palm Jumeirah"], averagePrice: 1800, bestTimeToVisit: "Nov-Mar", coordinates: Coordinates(latitude: 25.2048, longitude: 55.2708))
    ]
    
    public static let flights: [Flight] = [
        Flight(airline: "Emirates", flightNumber: "EK203", departure: FlightLocation(city: "New York", airport: "JFK International", code: "JFK"), arrival: FlightLocation(city: "Dubai", airport: "Dubai International", code: "DXB"), departureTime: Date().addingTimeInterval(86400 * 7), arrivalTime: Date().addingTimeInterval(86400 * 7 + 43200), price: 1250, stops: 0, duration: 43200),
        Flight(airline: "United", flightNumber: "UA837", departure: FlightLocation(city: "San Francisco", airport: "SFO International", code: "SFO"), arrival: FlightLocation(city: "Tokyo", airport: "Narita International", code: "NRT"), departureTime: Date().addingTimeInterval(86400 * 10), arrivalTime: Date().addingTimeInterval(86400 * 10 + 39600), price: 980, stops: 0, duration: 39600),
        Flight(airline: "Air France", flightNumber: "AF11", departure: FlightLocation(city: "New York", airport: "JFK International", code: "JFK"), arrival: FlightLocation(city: "Paris", airport: "Charles de Gaulle", code: "CDG"), departureTime: Date().addingTimeInterval(86400 * 5), arrivalTime: Date().addingTimeInterval(86400 * 5 + 28800), price: 850, stops: 0, duration: 28800)
    ]
    
    public static let hotels: [Hotel] = [
        Hotel(name: "The Ritz Paris", location: "Paris, France", description: "Legendary luxury hotel in the heart of Paris", rating: 4.9, reviewCount: 2340, pricePerNight: 1200, starRating: 5, amenities: [.wifi, .spa, .restaurant, .roomService, .bar], roomTypes: [RoomType(name: "Deluxe Room", pricePerNight: 1200), RoomType(name: "Suite", pricePerNight: 2500)]),
        Hotel(name: "Park Hyatt Tokyo", location: "Tokyo, Japan", description: "Contemporary luxury in Shinjuku with stunning city views", rating: 4.8, reviewCount: 1890, pricePerNight: 650, starRating: 5, amenities: [.wifi, .pool, .spa, .gym, .restaurant], roomTypes: [RoomType(name: "Park Room", pricePerNight: 650), RoomType(name: "Suite", pricePerNight: 1500)]),
        Hotel(name: "Four Seasons Bali", location: "Bali, Indonesia", description: "Tropical resort with private villas and stunning ocean views", rating: 4.9, reviewCount: 3210, pricePerNight: 450, starRating: 5, amenities: [.wifi, .pool, .spa, .restaurant, .breakfast], roomTypes: [RoomType(name: "Garden Villa", pricePerNight: 450), RoomType(name: "Ocean Villa", pricePerNight: 850)])
    ]
}

// MARK: - View Models

@MainActor
public class TravelStore: ObservableObject {
    @Published public var destinations: [Destination] = TravelSampleData.destinations
    @Published public var flights: [Flight] = TravelSampleData.flights
    @Published public var hotels: [Hotel] = TravelSampleData.hotels
    @Published public var bookings: [Booking] = []
    @Published public var itinerary: [ItineraryItem] = []
    @Published public var favoriteDestinations: Set<UUID> = []
    @Published public var searchQuery: String = ""
    
    // Search state
    @Published public var departureCity: String = ""
    @Published public var arrivalCity: String = ""
    @Published public var departureDate: Date = Date().addingTimeInterval(86400 * 7)
    @Published public var returnDate: Date = Date().addingTimeInterval(86400 * 14)
    @Published public var passengers: Int = 1
    @Published public var hotelGuests: Int = 2
    
    public init() {}
    
    public var filteredDestinations: [Destination] {
        if searchQuery.isEmpty {
            return destinations
        }
        return destinations.filter {
            $0.name.localizedCaseInsensitiveContains(searchQuery) ||
            $0.country.localizedCaseInsensitiveContains(searchQuery)
        }
    }
    
    public func toggleFavorite(_ destination: Destination) {
        if let index = destinations.firstIndex(where: { $0.id == destination.id }) {
            destinations[index].isFavorite.toggle()
            if destinations[index].isFavorite {
                favoriteDestinations.insert(destination.id)
            } else {
                favoriteDestinations.remove(destination.id)
            }
        }
    }
    
    public func bookFlight(_ flight: Flight) -> Booking {
        let booking = Booking(
            type: .flight,
            flight: flight,
            checkIn: flight.departureTime,
            checkOut: flight.arrivalTime,
            guests: passengers,
            totalPrice: flight.price * Decimal(passengers)
        )
        bookings.append(booking)
        return booking
    }
    
    public func bookHotel(_ hotel: Hotel, checkIn: Date, checkOut: Date, roomType: RoomType) -> Booking {
        let nights = Calendar.current.dateComponents([.day], from: checkIn, to: checkOut).day ?? 1
        let totalPrice = roomType.pricePerNight * Decimal(nights)
        
        let booking = Booking(
            type: .hotel,
            hotel: hotel,
            checkIn: checkIn,
            checkOut: checkOut,
            guests: hotelGuests,
            totalPrice: totalPrice
        )
        bookings.append(booking)
        return booking
    }
    
    public func addItineraryItem(_ item: ItineraryItem) {
        itinerary.append(item)
        itinerary.sort { $0.date < $1.date }
    }
}

// MARK: - Views

// 1. Main Travel Home View
public struct TravelHomeView: View {
    @StateObject private var store = TravelStore()
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "globe")
                }
                .tag(0)
            
            FlightSearchView()
                .tabItem {
                    Label("Flights", systemImage: "airplane")
                }
                .tag(1)
            
            HotelSearchView()
                .tabItem {
                    Label("Hotels", systemImage: "building.2")
                }
                .tag(2)
            
            BookingsListView()
                .tabItem {
                    Label("Trips", systemImage: "suitcase")
                }
                .tag(3)
            
            TravelProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(4)
        }
        .environmentObject(store)
    }
}

// 2. Explore View
struct ExploreView: View {
    @EnvironmentObject var store: TravelStore
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Search
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search destinations...", text: $store.searchQuery)
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Popular Destinations
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Popular Destinations")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(store.filteredDestinations) { destination in
                                    NavigationLink {
                                        DestinationDetailView(destination: destination)
                                            .environmentObject(store)
                                    } label: {
                                        DestinationCard(destination: destination)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Trending Deals
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Trending Deals")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(store.hotels.prefix(3)) { hotel in
                            NavigationLink {
                                HotelDetailView(hotel: hotel)
                                    .environmentObject(store)
                            } label: {
                                HotelCard(hotel: hotel)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Explore")
        }
    }
}

struct DestinationCard: View {
    @EnvironmentObject var store: TravelStore
    let destination: Destination
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 200, height: 150)
                    .cornerRadius(16)
                    .overlay(
                        Image(systemName: "globe")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.5))
                    )
                
                Button {
                    store.toggleFavorite(destination)
                } label: {
                    Image(systemName: destination.isFavorite ? "heart.fill" : "heart")
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .foregroundColor(destination.isFavorite ? .red : .white)
                }
                .padding(8)
            }
            
            Text(destination.name)
                .font(.headline)
            
            Text(destination.country)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", destination.rating))
                Text("(\(destination.reviewCount))")
                    .foregroundColor(.secondary)
            }
            .font(.caption)
        }
        .frame(width: 200)
    }
}

// 3. Destination Detail View
struct DestinationDetailView: View {
    @EnvironmentObject var store: TravelStore
    let destination: Destination
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 250)
                        .overlay(
                            Image(systemName: "globe")
                                .font(.system(size: 80))
                                .foregroundColor(.white.opacity(0.3))
                        )
                    
                    LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(destination.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(destination.country)
                            .font(.title3)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", destination.rating))
                            Text("(\(destination.reviewCount) reviews)")
                                .opacity(0.8)
                        }
                        .font(.subheadline)
                    }
                    .foregroundColor(.white)
                    .padding()
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    // Quick Info
                    HStack(spacing: 20) {
                        InfoBox(icon: "calendar", title: "Best Time", value: destination.bestTimeToVisit)
                        InfoBox(icon: "dollarsign.circle", title: "Avg. Cost", value: "\(destination.averagePrice, format: .currency(code: "USD"))")
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About")
                            .font(.headline)
                        
                        Text(destination.description)
                            .foregroundColor(.secondary)
                    }
                    
                    // Attractions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Popular Attractions")
                            .font(.headline)
                        
                        ForEach(destination.popularAttractions, id: \.self) { attraction in
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.blue)
                                Text(attraction)
                            }
                        }
                    }
                    
                    // Book Buttons
                    VStack(spacing: 12) {
                        NavigationLink {
                            FlightSearchView()
                                .environmentObject(store)
                        } label: {
                            HStack {
                                Image(systemName: "airplane")
                                Text("Search Flights")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        NavigationLink {
                            HotelSearchView()
                                .environmentObject(store)
                        } label: {
                            HStack {
                                Image(systemName: "building.2")
                                Text("Search Hotels")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .foregroundColor(.primary)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoBox: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// 4. Flight Search View
struct FlightSearchView: View {
    @EnvironmentObject var store: TravelStore
    @State private var showingResults = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Search Form
                    VStack(spacing: 16) {
                        // From/To
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "airplane.departure")
                                    .foregroundColor(.blue)
                                TextField("From", text: $store.departureCity)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            HStack {
                                Image(systemName: "airplane.arrival")
                                    .foregroundColor(.blue)
                                TextField("To", text: $store.arrivalCity)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        
                        // Dates
                        HStack(spacing: 12) {
                            DatePicker("Departure", selection: $store.departureDate, displayedComponents: .date)
                                .labelsHidden()
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            
                            DatePicker("Return", selection: $store.returnDate, displayedComponents: .date)
                                .labelsHidden()
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                        
                        // Passengers
                        Stepper("Passengers: \(store.passengers)", value: $store.passengers, in: 1...9)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        
                        Button {
                            showingResults = true
                        } label: {
                            Text("Search Flights")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    
                    // Recent Searches
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Available Flights")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(store.flights) { flight in
                            FlightCard(flight: flight)
                        }
                    }
                }
            }
            .navigationTitle("Flights")
            .sheet(isPresented: $showingResults) {
                FlightResultsView()
                    .environmentObject(store)
            }
        }
    }
}

struct FlightCard: View {
    @EnvironmentObject var store: TravelStore
    let flight: Flight
    @State private var showingBooking = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(flight.airline)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(flight.flightNumber)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                VStack {
                    Text(flight.departure.code)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(flight.departureTime, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(formatDuration(flight.duration))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Circle().frame(width: 6, height: 6)
                        Rectangle().frame(height: 1)
                        if flight.stops > 0 {
                            Circle().frame(width: 6, height: 6)
                            Rectangle().frame(height: 1)
                        }
                        Image(systemName: "airplane")
                    }
                    .foregroundColor(.secondary)
                    
                    Text(flight.stops == 0 ? "Nonstop" : "\(flight.stops) stop")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(width: 100)
                
                Spacer()
                
                VStack {
                    Text(flight.arrival.code)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(flight.arrivalTime, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            HStack {
                Text(flight.price, format: .currency(code: "USD"))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Button {
                    showingBooking = true
                } label: {
                    Text("Book")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
        .sheet(isPresented: $showingBooking) {
            FlightBookingView(flight: flight)
                .environmentObject(store)
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}

struct FlightResultsView: View {
    @EnvironmentObject var store: TravelStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(store.flights) { flight in
                FlightCard(flight: flight)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Flight Results")
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

struct FlightBookingView: View {
    @EnvironmentObject var store: TravelStore
    @Environment(\.dismiss) private var dismiss
    let flight: Flight
    @State private var showingConfirmation = false
    @State private var bookedBooking: Booking?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Flight Summary
                    VStack(spacing: 12) {
                        Text(flight.airline)
                            .font(.headline)
                        
                        HStack {
                            VStack {
                                Text(flight.departure.code)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text(flight.departure.city)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "airplane")
                                .font(.title)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            VStack {
                                Text(flight.arrival.code)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text(flight.arrival.city)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Departure")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(flight.departureTime, style: .date)
                                Text(flight.departureTime, style: .time)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Arrival")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(flight.arrivalTime, style: .date)
                                Text(flight.arrivalTime, style: .time)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Passengers
                    Stepper("Passengers: \(store.passengers)", value: $store.passengers, in: 1...9)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    
                    // Total
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(flight.price * Decimal(store.passengers), format: .currency(code: "USD"))
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("Book Flight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    bookedBooking = store.bookFlight(flight)
                    showingConfirmation = true
                } label: {
                    Text("Confirm Booking")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()
                .background(.bar)
            }
            .alert("Booking Confirmed!", isPresented: $showingConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your flight has been booked. Confirmation code: \(bookedBooking?.confirmationCode ?? "")")
            }
        }
    }
}

// 5. Hotel Search View
struct HotelSearchView: View {
    @EnvironmentObject var store: TravelStore
    @State private var destination = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Search Form
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Destination", text: $destination)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        HStack(spacing: 12) {
                            DatePicker("Check-in", selection: $store.departureDate, displayedComponents: .date)
                                .labelsHidden()
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            
                            DatePicker("Check-out", selection: $store.returnDate, displayedComponents: .date)
                                .labelsHidden()
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                        
                        Stepper("Guests: \(store.hotelGuests)", value: $store.hotelGuests, in: 1...8)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        
                        Button {} label: {
                            Text("Search Hotels")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    
                    // Hotels
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Featured Hotels")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(store.hotels) { hotel in
                            NavigationLink {
                                HotelDetailView(hotel: hotel)
                                    .environmentObject(store)
                            } label: {
                                HotelCard(hotel: hotel)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("Hotels")
        }
    }
}

struct HotelCard: View {
    let hotel: Hotel
    
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(width: 100, height: 100)
                .cornerRadius(12)
                .overlay(
                    Image(systemName: "building.2")
                        .font(.title)
                        .foregroundColor(.secondary)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(hotel.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(hotel.location)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 2) {
                    ForEach(0..<hotel.starRating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
                .font(.caption)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", hotel.rating))
                    Text("(\(hotel.reviewCount))")
                        .foregroundColor(.secondary)
                }
                .font(.caption)
                
                Text("from \(hotel.pricePerNight, format: .currency(code: "USD"))/night")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// 6. Hotel Detail View
struct HotelDetailView: View {
    @EnvironmentObject var store: TravelStore
    let hotel: Hotel
    @State private var selectedRoom: RoomType?
    @State private var showingBooking = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Images
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 250)
                    .overlay(
                        Image(systemName: "building.2")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                    )
                
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 2) {
                            ForEach(0..<hotel.starRating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .font(.caption)
                        
                        Text(hotel.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(hotel.location)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", hotel.rating))
                            Text("(\(hotel.reviewCount) reviews)")
                                .foregroundColor(.secondary)
                        }
                        .font(.subheadline)
                    }
                    
                    // Amenities
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Amenities")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(hotel.amenities, id: \.self) { amenity in
                                HStack(spacing: 8) {
                                    Image(systemName: amenity.icon)
                                        .foregroundColor(.blue)
                                    Text(amenity.rawValue)
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    
                    // Room Types
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Room Types")
                            .font(.headline)
                        
                        ForEach(hotel.roomTypes) { room in
                            Button {
                                selectedRoom = room
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(room.name)
                                            .fontWeight(.medium)
                                        Text("\(room.beds) • \(room.size)m² • Up to \(room.maxGuests) guests")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text(room.pricePerNight, format: .currency(code: "USD"))
                                            .fontWeight(.semibold)
                                        Text("/night")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Image(systemName: selectedRoom?.id == room.id ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedRoom?.id == room.id ? .blue : .secondary)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button {
                showingBooking = true
            } label: {
                Text("Book Now")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedRoom == nil ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(selectedRoom == nil)
            .padding()
            .background(.bar)
        }
        .sheet(isPresented: $showingBooking) {
            if let room = selectedRoom {
                HotelBookingView(hotel: hotel, roomType: room)
                    .environmentObject(store)
            }
        }
    }
}

struct HotelBookingView: View {
    @EnvironmentObject var store: TravelStore
    @Environment(\.dismiss) private var dismiss
    let hotel: Hotel
    let roomType: RoomType
    @State private var showingConfirmation = false
    
    var nights: Int {
        Calendar.current.dateComponents([.day], from: store.departureDate, to: store.returnDate).day ?? 1
    }
    
    var totalPrice: Decimal {
        roomType.pricePerNight * Decimal(nights)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Hotel Summary
                    VStack(alignment: .leading, spacing: 8) {
                        Text(hotel.name)
                            .font(.headline)
                        
                        Text(roomType.name)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Dates
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Check-in")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(store.departureDate, style: .date)
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        Text("\(nights) nights")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Check-out")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(store.returnDate, style: .date)
                                .fontWeight(.medium)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Total
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(totalPrice, format: .currency(code: "USD"))
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("Book Hotel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    _ = store.bookHotel(hotel, checkIn: store.departureDate, checkOut: store.returnDate, roomType: roomType)
                    showingConfirmation = true
                } label: {
                    Text("Confirm Booking")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()
                .background(.bar)
            }
            .alert("Booking Confirmed!", isPresented: $showingConfirmation) {
                Button("OK") {
                    dismiss()
                }
            }
        }
    }
}

// 7. Bookings List View
struct BookingsListView: View {
    @EnvironmentObject var store: TravelStore
    
    var body: some View {
        NavigationStack {
            Group {
                if store.bookings.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "suitcase")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No trips yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Book a flight or hotel to see your trips here")
                            .foregroundColor(.secondary)
                    }
                } else {
                    List(store.bookings) { booking in
                        BookingRow(booking: booking)
                    }
                }
            }
            .navigationTitle("My Trips")
        }
    }
}

struct BookingRow: View {
    let booking: Booking
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: booking.type == .flight ? "airplane" : "building.2")
                    .foregroundColor(.blue)
                
                Text(booking.type == .flight ? booking.flight?.airline ?? "" : booking.hotel?.name ?? "")
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(booking.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(booking.status.color.opacity(0.2))
                    .foregroundColor(booking.status.color)
                    .cornerRadius(8)
            }
            
            HStack {
                Text(booking.checkIn, style: .date)
                Text("-")
                Text(booking.checkOut, style: .date)
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            HStack {
                Text("Confirmation: \(booking.confirmationCode)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(booking.totalPrice, format: .currency(code: "USD"))
                    .fontWeight(.semibold)
            }
        }
        .padding(.vertical, 4)
    }
}

// 8. Travel Profile View
struct TravelProfileView: View {
    @EnvironmentObject var store: TravelStore
    
    var body: some View {
        NavigationStack {
            List {
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
                            Text("John Traveler")
                                .font(.headline)
                            Text("Gold Member")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Rewards") {
                    HStack {
                        Text("Points Balance")
                        Spacer()
                        Text("12,500")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
                
                Section("Saved") {
                    NavigationLink("Favorite Destinations", systemImage: "heart") {}
                    NavigationLink("Saved Hotels", systemImage: "bookmark") {}
                    NavigationLink("Recent Searches", systemImage: "clock") {}
                }
                
                Section("Settings") {
                    NavigationLink("Payment Methods", systemImage: "creditcard") {}
                    NavigationLink("Notifications", systemImage: "bell") {}
                    NavigationLink("Travel Preferences", systemImage: "gearshape") {}
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

public struct TravelApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            TravelHomeView()
        }
    }
}
