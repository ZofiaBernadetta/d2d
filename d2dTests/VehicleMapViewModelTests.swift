//
//  VehicleMapViewModelTests.swift
//  d2dTests
//
//  Created by Zofia Drabek on 20/02/2021.
//

import XCTest
@testable import d2d

class VehicleMapViewModelTests: XCTestCase {
    func testUpdatingViewStatus() {
        let vehicleStateProvider = MockVehicleStateProvider()
        let viewModel = VehicleMapViewModel(vehicleStateProvider: vehicleStateProvider)

        vehicleStateProvider.events = [
            Result<Event, Error>.success(.bookingOpened(bookingOpened)),
            Result<Event, Error>.success(.vehicleLocationUpdated(locationUpdated1)),
            Result<Event, Error>.failure(TestError.foo),
            Result<Event, Error>.success(.vehicleLocationUpdated(locationUpdated2)),
            Result<Event, Error>.success(.statusUpdated(.inVehicle)),
            Result<Event, Error>.success(.vehicleLocationUpdated(locationUpdated3)),
            Result<Event, Error>.success(.intermediateStopLocationsChanged(intermediateStopLocationsChanged)),
            Result<Event, Error>.success(.vehicleLocationUpdated(locationUpdated4)),
            Result<Event, Error>.success(.statusUpdated(.droppedOff)),
            Result<Event, Error>.success(.bookingClosed),
        ]

        XCTAssertEqual(viewModel.viewState, nil)

        vehicleStateProvider.sendNextEvent() // bookingOpened
        XCTAssertEqual(viewModel.viewState?.vehicleStatus, bookingOpened.status)
        XCTAssertEqual(viewModel.viewState?.vehicleLocation, bookingOpened.vehicleLocation)
        XCTAssertEqual(viewModel.viewState?.pickupLocation, bookingOpened.pickupLocation)
        XCTAssertEqual(viewModel.viewState?.dropoffLocation, bookingOpened.dropoffLocation)
        XCTAssertEqual(viewModel.viewState?.intermediateStopLocations, bookingOpened.intermediateStopLocations)

        vehicleStateProvider.sendNextEvent() // locationUpdated1
        XCTAssertEqual(viewModel.viewState?.vehicleLocation, locationUpdated1)
        // Unchanged
        XCTAssertEqual(viewModel.viewState?.vehicleStatus, bookingOpened.status)
        XCTAssertEqual(viewModel.viewState?.pickupLocation, bookingOpened.pickupLocation)
        XCTAssertEqual(viewModel.viewState?.dropoffLocation, bookingOpened.dropoffLocation)
        XCTAssertEqual(viewModel.viewState?.intermediateStopLocations, bookingOpened.intermediateStopLocations)

        vehicleStateProvider.sendNextEvent() // failure
        // On a failure, the view state is preserved, allowing the
        // app to resume functioning normally if the failure is temporary.
        // Unchanged
        XCTAssertEqual(viewModel.viewState?.vehicleLocation, locationUpdated1)
        XCTAssertEqual(viewModel.viewState?.vehicleStatus, bookingOpened.status)
        XCTAssertEqual(viewModel.viewState?.pickupLocation, bookingOpened.pickupLocation)
        XCTAssertEqual(viewModel.viewState?.dropoffLocation, bookingOpened.dropoffLocation)
        XCTAssertEqual(viewModel.viewState?.intermediateStopLocations, bookingOpened.intermediateStopLocations)

        vehicleStateProvider.sendNextEvent() // locationUpdated2
        XCTAssertEqual(viewModel.viewState?.vehicleLocation, locationUpdated2)
        // Unchanged
        XCTAssertEqual(viewModel.viewState?.vehicleStatus, bookingOpened.status)
        XCTAssertEqual(viewModel.viewState?.pickupLocation, bookingOpened.pickupLocation)
        XCTAssertEqual(viewModel.viewState?.dropoffLocation, bookingOpened.dropoffLocation)
        XCTAssertEqual(viewModel.viewState?.intermediateStopLocations, bookingOpened.intermediateStopLocations)

        vehicleStateProvider.sendNextEvent() // pickedUp
        XCTAssertEqual(viewModel.viewState?.vehicleStatus, .inVehicle)
        // Unchanged
        XCTAssertEqual(viewModel.viewState?.vehicleLocation, locationUpdated2)
        XCTAssertEqual(viewModel.viewState?.pickupLocation, bookingOpened.pickupLocation)
        XCTAssertEqual(viewModel.viewState?.dropoffLocation, bookingOpened.dropoffLocation)
        XCTAssertEqual(viewModel.viewState?.intermediateStopLocations, bookingOpened.intermediateStopLocations)

        vehicleStateProvider.sendNextEvent() // locationUpdated3
        XCTAssertEqual(viewModel.viewState?.vehicleLocation, locationUpdated3)
        // Unchanged
        XCTAssertEqual(viewModel.viewState?.vehicleStatus, .inVehicle)
        XCTAssertEqual(viewModel.viewState?.pickupLocation, bookingOpened.pickupLocation)
        XCTAssertEqual(viewModel.viewState?.dropoffLocation, bookingOpened.dropoffLocation)
        XCTAssertEqual(viewModel.viewState?.intermediateStopLocations, bookingOpened.intermediateStopLocations)

        vehicleStateProvider.sendNextEvent() // intermediateStopLocationsChanged
        XCTAssertEqual(viewModel.viewState?.intermediateStopLocations, intermediateStopLocationsChanged)
        // Unchanged
        XCTAssertEqual(viewModel.viewState?.vehicleStatus, .inVehicle)
        XCTAssertEqual(viewModel.viewState?.vehicleLocation, locationUpdated3)
        XCTAssertEqual(viewModel.viewState?.pickupLocation, bookingOpened.pickupLocation)
        XCTAssertEqual(viewModel.viewState?.dropoffLocation, bookingOpened.dropoffLocation)

        vehicleStateProvider.sendNextEvent() // locationUpdated4
        XCTAssertEqual(viewModel.viewState?.vehicleLocation, locationUpdated4)
        // Unchanged
        XCTAssertEqual(viewModel.viewState?.vehicleStatus, .inVehicle)
        XCTAssertEqual(viewModel.viewState?.pickupLocation, bookingOpened.pickupLocation)
        XCTAssertEqual(viewModel.viewState?.dropoffLocation, bookingOpened.dropoffLocation)
        XCTAssertEqual(viewModel.viewState?.intermediateStopLocations, intermediateStopLocationsChanged)

        vehicleStateProvider.sendNextEvent() // droppedOff
        XCTAssertEqual(viewModel.viewState?.vehicleStatus, .droppedOff)
        // Unchanged
        XCTAssertEqual(viewModel.viewState?.vehicleLocation, locationUpdated4)
        XCTAssertEqual(viewModel.viewState?.pickupLocation, bookingOpened.pickupLocation)
        XCTAssertEqual(viewModel.viewState?.dropoffLocation, bookingOpened.dropoffLocation)
        XCTAssertEqual(viewModel.viewState?.intermediateStopLocations, intermediateStopLocationsChanged)

        vehicleStateProvider.sendNextEvent() // bookingClosed
        XCTAssertEqual(viewModel.viewState, nil)
    }

    let bookingOpened = BookingEventData(
            status: .waitingForPickup,
            vehicleLocation: Location(address: "Berlin", lng: 10.3, lat: 9.3),
            pickupLocation: Location(address: "Hamburg", lng: 3.21, lat: 23.4),
            dropoffLocation: Location(address: "Stuttgard", lng: 62.4, lat: 82.6),
            intermediateStopLocations: [Location(address: "Katie's house", lng: 23.6, lat: 12.4)])
    let locationUpdated1 = Location(address: nil, lng: 10.5, lat: 9.0)
    let locationUpdated2 = Location(address: nil, lng: 3.21, lat: 23.4)
    let locationUpdated3 = Location(address: nil, lng: 23.6, lat: 12.4)
    let intermediateStopLocationsChanged = [Location]()
    let locationUpdated4 = Location(address: nil, lng: 62.4, lat: 82.6)
}

enum TestError: Error {
    case foo
}
