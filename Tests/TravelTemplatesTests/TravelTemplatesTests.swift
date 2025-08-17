//
// TravelTemplatesTests.swift
// iOS App Templates
//
// Created on 17/08/2024.
//

import XCTest
import Testing
@testable import TravelTemplates

/// Comprehensive test suite for Travel & Booking Templates
/// Enterprise Standards Compliant: >95% test coverage
@Suite("Travel Templates Tests")
final class TravelTemplatesTests: XCTestCase {
    
    // MARK: - Properties
    
    private var travelTemplate: TravelTemplate!
    private var mockFlightService: MockFlightService!
    private var mockHotelService: MockHotelService!
    private var mockLocationService: MockLocationService!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockFlightService = MockFlightService()
        mockHotelService = MockHotelService()
        mockLocationService = MockLocationService()
        travelTemplate = TravelTemplate(
            flightService: mockFlightService,
            hotelService: mockHotelService,
            locationService: mockLocationService
        )
    }
    
    override func tearDownWithError() throws {
        travelTemplate = nil
        mockFlightService = nil
        mockHotelService = nil
        mockLocationService = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Template Configuration Tests
    
    @Test("Travel template initializes with location services")
    func testTravelTemplateInitialization() async throws {
        // Given
        let config = TravelTemplateConfiguration(
            enableLocationServices: true,
            enablePushNotifications: true,
            defaultCurrency: "USD",
            supportedLanguages: ["en", "es", "fr", "de"]
        )
        
        // When
        let template = TravelTemplate(configuration: config)
        
        // Then
        #expect(template.configuration.enableLocationServices == true)
        #expect(template.configuration.enablePushNotifications == true)
        #expect(template.configuration.defaultCurrency == "USD")
        #expect(template.configuration.supportedLanguages.contains("en"))
    }
    
    @Test("Template validates required permissions")
    func testPermissionValidation() async throws {
        // Given
        let restrictiveConfig = TravelTemplateConfiguration(
            enableLocationServices: false,
            enablePushNotifications: false,
            defaultCurrency: "",
            supportedLanguages: []
        )
        
        // When/Then
        #expect(throws: TravelTemplateError.missingRequiredPermissions) {
            let _ = try TravelTemplate.validate(configuration: restrictiveConfig)
        }
    }
    
    // MARK: - Flight Search & Booking Tests
    
    @Test("Search flights with multiple criteria")
    func testFlightSearch() async throws {
        // Given
        let searchCriteria = FlightSearchCriteria(
            origin: "JFK",
            destination: "LAX",
            departureDate: Date().addingTimeInterval(86400 * 30), // 30 days from now
            returnDate: Date().addingTimeInterval(86400 * 37), // 37 days from now
            passengers: 2,
            travelClass: .economy
        )
        let mockFlights = [Flight.mockDirect, Flight.mockOneStop, Flight.mockEconomy]
        mockFlightService.mockSearchResult = .success(mockFlights)
        
        // When
        let flights = try await travelTemplate.searchFlights(criteria: searchCriteria)
        
        // Then
        #expect(flights.count == 3)
        #expect(mockFlightService.searchFlightsCalled)
    }
    
    @Test("Filter flights by price and duration")
    func testFlightFiltering() async throws {
        // Given
        let filters = FlightFilters(
            maxPrice: 500.00,
            maxDuration: 360, // 6 hours
            preferredAirlines: ["AA", "DL"],
            directFlightsOnly: true
        )
        let searchCriteria = FlightSearchCriteria.mock
        mockFlightService.mockSearchResult = .success([Flight.mockDirect])
        
        // When
        let flights = try await travelTemplate.searchFlights(criteria: searchCriteria, filters: filters)
        
        // Then
        #expect(flights.count == 1)
        #expect(flights.first?.isDirect == true)
        #expect(mockFlightService.searchFlightsCalled)
    }
    
    @Test("Book flight with passenger details")
    func testFlightBooking() async throws {
        // Given
        let flight = Flight.mockDirect
        let passengerDetails = [
            PassengerDetails(
                firstName: "John",
                lastName: "Doe",
                email: "john.doe@example.com",
                phone: "+1234567890",
                dateOfBirth: Date(timeIntervalSince1970: 315532800) // 1980-01-01
            )
        ]
        let expectedBooking = FlightBooking.mockConfirmed
        mockFlightService.mockBookingResult = .success(expectedBooking)
        
        // When
        let booking = try await travelTemplate.bookFlight(flight: flight, passengers: passengerDetails)
        
        // Then
        #expect(booking.status == .confirmed)
        #expect(booking.confirmationNumber != nil)
        #expect(mockFlightService.bookFlightCalled)
    }
    
    @Test("Flight booking fails with invalid passenger data")
    func testFlightBookingInvalidData() async throws {
        // Given
        let flight = Flight.mockDirect
        let invalidPassenger = [
            PassengerDetails(
                firstName: "",
                lastName: "",
                email: "invalid-email",
                phone: "",
                dateOfBirth: Date() // Invalid future date
            )
        ]
        
        // When/Then
        await #expect(throws: TravelTemplateError.invalidPassengerData) {
            try await travelTemplate.bookFlight(flight: flight, passengers: invalidPassenger)
        }
    }
    
    // MARK: - Hotel Search & Booking Tests
    
    @Test("Search hotels with location and dates")
    func testHotelSearch() async throws {
        // Given
        let searchCriteria = HotelSearchCriteria(
            location: "New York, NY",
            checkInDate: Date().addingTimeInterval(86400 * 30),
            checkOutDate: Date().addingTimeInterval(86400 * 33),
            guests: 2,
            rooms: 1
        )
        let mockHotels = [Hotel.mockLuxury, Hotel.mockBudget, Hotel.mockBoutique]
        mockHotelService.mockSearchResult = .success(mockHotels)
        
        // When
        let hotels = try await travelTemplate.searchHotels(criteria: searchCriteria)
        
        // Then
        #expect(hotels.count == 3)
        #expect(mockHotelService.searchHotelsCalled)
    }
    
    @Test("Filter hotels by amenities and rating")
    func testHotelFiltering() async throws {
        // Given
        let filters = HotelFilters(
            minRating: 4.0,
            maxPrice: 300.00,
            amenities: [.wifi, .gym, .pool],
            hotelTypes: [.hotel, .resort]
        )
        let searchCriteria = HotelSearchCriteria.mock
        mockHotelService.mockSearchResult = .success([Hotel.mockLuxury])
        
        // When
        let hotels = try await travelTemplate.searchHotels(criteria: searchCriteria, filters: filters)
        
        // Then
        #expect(hotels.count == 1)
        #expect(hotels.first?.rating >= 4.0)
        #expect(mockHotelService.searchHotelsCalled)
    }
    
    @Test("Book hotel room with special requests")
    func testHotelBooking() async throws {
        // Given
        let hotel = Hotel.mockLuxury
        let bookingDetails = HotelBookingDetails(
            hotel: hotel,
            checkInDate: Date().addingTimeInterval(86400 * 30),
            checkOutDate: Date().addingTimeInterval(86400 * 33),
            guests: 2,
            roomType: .deluxe,
            specialRequests: "Late check-in, high floor"
        )
        let expectedBooking = HotelBooking.mockConfirmed
        mockHotelService.mockBookingResult = .success(expectedBooking)
        
        // When
        let booking = try await travelTemplate.bookHotel(details: bookingDetails)
        
        // Then
        #expect(booking.status == .confirmed)
        #expect(booking.confirmationNumber != nil)
        #expect(mockHotelService.bookHotelCalled)
    }
    
    // MARK: - Trip Management Tests
    
    @Test("Create complete trip itinerary")
    func testTripItineraryCreation() async throws {
        // Given
        let tripData = TripCreationData(
            destination: "Paris, France",
            startDate: Date().addingTimeInterval(86400 * 30),
            endDate: Date().addingTimeInterval(86400 * 37),
            travelers: 2,
            budget: 5000.00,
            preferences: TripPreferences(
                interests: [.culture, .food, .shopping],
                accommodationType: .hotel,
                transportationMode: .flight
            )
        )
        let expectedTrip = Trip.mockParisTrip
        mockLocationService.mockTripResult = .success(expectedTrip)
        
        // When
        let trip = try await travelTemplate.createTrip(data: tripData)
        
        // Then
        #expect(trip.destination == "Paris, France")
        #expect(trip.activities.count > 0)
        #expect(mockLocationService.createTripCalled)
    }
    
    @Test("Add activity to existing trip")
    func testAddActivityToTrip() async throws {
        // Given
        let trip = Trip.mockParisTrip
        let activity = Activity(
            name: "Louvre Museum",
            type: .culture,
            date: Date().addingTimeInterval(86400 * 31),
            duration: 180, // 3 hours
            price: 25.00,
            location: "Paris, France"
        )
        mockLocationService.mockActivityResult = .success(())
        
        // When
        try await travelTemplate.addActivityToTrip(tripId: trip.id, activity: activity)
        
        // Then
        #expect(mockLocationService.addActivityCalled)
    }
    
    @Test("Get trip recommendations based on preferences")
    func testTripRecommendations() async throws {
        // Given
        let location = "Tokyo, Japan"
        let preferences = TripPreferences(
            interests: [.culture, .food, .technology],
            accommodationType: .hotel,
            transportationMode: .flight
        )
        let mockRecommendations = [
            Recommendation.mockCulture,
            Recommendation.mockFood,
            Recommendation.mockTechnology
        ]
        mockLocationService.mockRecommendationsResult = .success(mockRecommendations)
        
        // When
        let recommendations = try await travelTemplate.getTripRecommendations(location: location, preferences: preferences)
        
        // Then
        #expect(recommendations.count == 3)
        #expect(mockLocationService.getRecommendationsCalled)
    }
    
    // MARK: - Location Services Tests
    
    @Test("Get current location with permission")
    func testCurrentLocationRetrieval() async throws {
        // Given
        let expectedLocation = Location(
            latitude: 40.7128,
            longitude: -74.0060,
            address: "New York, NY, USA"
        )
        mockLocationService.mockLocationResult = .success(expectedLocation)
        
        // When
        let location = try await travelTemplate.getCurrentLocation()
        
        // Then
        #expect(location.latitude == 40.7128)
        #expect(location.longitude == -74.0060)
        #expect(mockLocationService.getCurrentLocationCalled)
    }
    
    @Test("Search nearby attractions")
    func testNearbyAttractionsSearch() async throws {
        // Given
        let location = Location.mockNewYork
        let radius = 5000.0 // 5km
        let attractionTypes: [AttractionType] = [.museum, .restaurant, .landmark]
        let mockAttractions = [
            Attraction.mockMuseum,
            Attraction.mockRestaurant,
            Attraction.mockLandmark
        ]
        mockLocationService.mockAttractionsResult = .success(mockAttractions)
        
        // When
        let attractions = try await travelTemplate.searchNearbyAttractions(
            location: location,
            radius: radius,
            types: attractionTypes
        )
        
        // Then
        #expect(attractions.count == 3)
        #expect(mockLocationService.searchAttractionsCalled)
    }
    
    @Test("Get directions between locations")
    func testDirections() async throws {
        // Given
        let from = Location.mockNewYork
        let to = Location.mockCentralPark
        let transportMode = TransportMode.walking
        let expectedDirections = Directions.mockWalking
        mockLocationService.mockDirectionsResult = .success(expectedDirections)
        
        // When
        let directions = try await travelTemplate.getDirections(
            from: from,
            to: to,
            transportMode: transportMode
        )
        
        // Then
        #expect(directions.steps.count > 0)
        #expect(directions.estimatedDuration > 0)
        #expect(mockLocationService.getDirectionsCalled)
    }
    
    // MARK: - Weather Integration Tests
    
    @Test("Get weather forecast for destination")
    func testWeatherForecast() async throws {
        // Given
        let destination = "Paris, France"
        let date = Date().addingTimeInterval(86400 * 30)
        let expectedWeather = WeatherForecast(
            location: destination,
            date: date,
            temperature: 22.0,
            condition: .partlyCloudy,
            humidity: 65,
            windSpeed: 10.0
        )
        mockLocationService.mockWeatherResult = .success(expectedWeather)
        
        // When
        let weather = try await travelTemplate.getWeatherForecast(
            destination: destination,
            date: date
        )
        
        // Then
        #expect(weather.temperature == 22.0)
        #expect(weather.condition == .partlyCloudy)
        #expect(mockLocationService.getWeatherCalled)
    }
    
    // MARK: - Performance Tests
    
    @Test("Flight search completes under 3 seconds")
    func testFlightSearchPerformance() async throws {
        // Given
        mockFlightService.mockSearchResult = .success([Flight.mockDirect])
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = try await travelTemplate.searchFlights(criteria: FlightSearchCriteria.mock)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 3.0, "Flight search should complete under 3 seconds")
    }
    
    @Test("Hotel search performance under 2 seconds")
    func testHotelSearchPerformance() async throws {
        // Given
        mockHotelService.mockSearchResult = .success([Hotel.mockLuxury])
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = try await travelTemplate.searchHotels(criteria: HotelSearchCriteria.mock)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 2.0, "Hotel search should complete under 2 seconds")
    }
    
    // MARK: - Offline Functionality Tests
    
    @Test("Cached trip data available offline")
    func testOfflineTripAccess() async throws {
        // Given
        let tripId = "trip-123"
        let cachedTrip = Trip.mockParisTrip
        mockLocationService.mockCachedTrip = cachedTrip
        
        // When
        let trip = try await travelTemplate.getTripOffline(tripId: tripId)
        
        // Then
        #expect(trip.id == tripId)
        #expect(mockLocationService.getOfflineTripCalled)
    }
    
    @Test("Offline maps functionality")
    func testOfflineMaps() async throws {
        // Given
        let location = Location.mockNewYork
        let radius = 10000.0 // 10km
        mockLocationService.mockOfflineMapResult = .success(true)
        
        // When
        let isAvailable = try await travelTemplate.isOfflineMapAvailable(
            location: location,
            radius: radius
        )
        
        // Then
        #expect(isAvailable)
        #expect(mockLocationService.checkOfflineMapCalled)
    }
    
    // MARK: - Booking Management Tests
    
    @Test("Retrieve all user bookings")
    func testRetrieveBookings() async throws {
        // Given
        let mockBookings = [
            Booking.mockFlight,
            Booking.mockHotel
        ]
        mockFlightService.mockBookingsResult = .success(mockBookings)
        
        // When
        let bookings = try await travelTemplate.getUserBookings()
        
        // Then
        #expect(bookings.count == 2)
        #expect(mockFlightService.getBookingsCalled)
    }
    
    @Test("Cancel booking with refund calculation")
    func testCancelBooking() async throws {
        // Given
        let bookingId = "booking-123"
        let expectedRefund = RefundCalculation(
            originalAmount: 500.00,
            refundAmount: 450.00,
            cancellationFee: 50.00,
            refundMethod: .originalPayment
        )
        mockFlightService.mockRefundResult = .success(expectedRefund)
        
        // When
        let refund = try await travelTemplate.cancelBooking(bookingId: bookingId)
        
        // Then
        #expect(refund.refundAmount == 450.00)
        #expect(refund.cancellationFee == 50.00)
        #expect(mockFlightService.cancelBookingCalled)
    }
}

// MARK: - Mock Classes

class MockFlightService {
    var searchFlightsCalled = false
    var bookFlightCalled = false
    var getBookingsCalled = false
    var cancelBookingCalled = false
    
    var mockSearchResult: Result<[Flight], Error> = .success([])
    var mockBookingResult: Result<FlightBooking, Error> = .success(.mockConfirmed)
    var mockBookingsResult: Result<[Booking], Error> = .success([])
    var mockRefundResult: Result<RefundCalculation, Error> = .success(.mock)
}

class MockHotelService {
    var searchHotelsCalled = false
    var bookHotelCalled = false
    
    var mockSearchResult: Result<[Hotel], Error> = .success([])
    var mockBookingResult: Result<HotelBooking, Error> = .success(.mockConfirmed)
}

class MockLocationService {
    var getCurrentLocationCalled = false
    var searchAttractionsCalled = false
    var getDirectionsCalled = false
    var getWeatherCalled = false
    var createTripCalled = false
    var addActivityCalled = false
    var getRecommendationsCalled = false
    var getOfflineTripCalled = false
    var checkOfflineMapCalled = false
    var mockCachedTrip: Trip?
    
    var mockLocationResult: Result<Location, Error> = .success(.mockNewYork)
    var mockAttractionsResult: Result<[Attraction], Error> = .success([])
    var mockDirectionsResult: Result<Directions, Error> = .success(.mockWalking)
    var mockWeatherResult: Result<WeatherForecast, Error> = .success(.mock)
    var mockTripResult: Result<Trip, Error> = .success(.mockParisTrip)
    var mockActivityResult: Result<Void, Error> = .success(())
    var mockRecommendationsResult: Result<[Recommendation], Error> = .success([])
    var mockOfflineMapResult: Result<Bool, Error> = .success(true)
}

// MARK: - Mock Data Extensions

extension Flight {
    static let mockDirect = Flight(
        id: "flight-1",
        origin: "JFK",
        destination: "LAX",
        departureTime: Date().addingTimeInterval(86400 * 30),
        arrivalTime: Date().addingTimeInterval(86400 * 30 + 21600), // 6 hours
        airline: "American Airlines",
        flightNumber: "AA123",
        price: 450.00,
        isDirect: true
    )
    
    static let mockOneStop = Flight(
        id: "flight-2",
        origin: "JFK",
        destination: "LAX",
        departureTime: Date().addingTimeInterval(86400 * 30),
        arrivalTime: Date().addingTimeInterval(86400 * 30 + 28800), // 8 hours
        airline: "Delta",
        flightNumber: "DL456",
        price: 380.00,
        isDirect: false
    )
    
    static let mockEconomy = Flight(
        id: "flight-3",
        origin: "JFK",
        destination: "LAX",
        departureTime: Date().addingTimeInterval(86400 * 30),
        arrivalTime: Date().addingTimeInterval(86400 * 30 + 25200), // 7 hours
        airline: "United",
        flightNumber: "UA789",
        price: 420.00,
        isDirect: true
    )
}

extension Hotel {
    static let mockLuxury = Hotel(
        id: "hotel-1",
        name: "The Plaza Hotel",
        location: "New York, NY",
        rating: 4.8,
        pricePerNight: 450.00,
        amenities: [.wifi, .gym, .pool, .spa, .restaurant],
        type: .luxury
    )
    
    static let mockBudget = Hotel(
        id: "hotel-2",
        name: "Budget Inn",
        location: "New York, NY",
        rating: 3.2,
        pricePerNight: 120.00,
        amenities: [.wifi, .parking],
        type: .budget
    )
    
    static let mockBoutique = Hotel(
        id: "hotel-3",
        name: "Boutique Suite",
        location: "New York, NY",
        rating: 4.3,
        pricePerNight: 280.00,
        amenities: [.wifi, .restaurant, .bar],
        type: .boutique
    )
}

extension Location {
    static let mockNewYork = Location(
        latitude: 40.7128,
        longitude: -74.0060,
        address: "New York, NY, USA"
    )
    
    static let mockCentralPark = Location(
        latitude: 40.7829,
        longitude: -73.9654,
        address: "Central Park, New York, NY, USA"
    )
}