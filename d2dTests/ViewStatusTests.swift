//
//  ViewStatusTests.swift
//  d2dTests
//
//  Created by Zofia Drabek on 19/02/2021.
//

import XCTest
@testable import d2d

class ViewStatusTests: XCTestCase {

    func testInit() {
        let bookingEventData = BookingEventData(
                status: .inVehicle,
                vehicleLocation: Location(
                    address: nil,
                    lng: 10.1,
                    lat: 20.2),
                pickupLocation: Location(
                    address: "Alexander Strasse",
                    lng: 30.3,
                    lat: 40.4),
                dropoffLocation: Location(
                    address: "Adenauer Strasse",
                    lng: 50.5,
                    lat: 60.6),
                intermediateStopLocations: [
                    Location(address: "Tom's house", lng: 70.7, lat: 80.8)
                ])

        let viewStatus = ViewState(bookingData: bookingEventData)

        XCTAssertEqual(viewStatus.vehicleStatus, .inVehicle)
        XCTAssertEqual(viewStatus.vehicleLocation, Location(address: nil, lng: 10.1, lat: 20.2))
        XCTAssertEqual(viewStatus.pickupLocation, Location(address: "Alexander Strasse", lng: 30.3, lat: 40.4))
        XCTAssertEqual(viewStatus.dropoffLocation, Location(address: "Adenauer Strasse", lng: 50.5, lat: 60.6))
        XCTAssertEqual(viewStatus.intermediateStopLocations, [Location(address: "Tom's house", lng: 70.7, lat: 80.8)])
    }

    func testUpdateVehicleLocation() {
        var viewStatus = mockViewStatus()
        let location = Location(address: "Wilhelminenhofstrasse", lng: 25.1, lat: 35.2)
        viewStatus.updateVehicleLocation(location: location)

        XCTAssertEqual(viewStatus.vehicleLocation, location)

        XCTAssertEqual(viewStatus.vehicleStatus, .inVehicle)
        XCTAssertEqual(viewStatus.pickupLocation, Location(address: "Alexander Strasse", lng: 30.3, lat: 40.4))
        XCTAssertEqual(viewStatus.dropoffLocation, Location(address: "Adenauer Strasse", lng: 50.5, lat: 60.6))
        XCTAssertEqual(viewStatus.intermediateStopLocations, [Location(address: "Tom's house", lng: 70.7, lat: 80.8)])
    }

    func testChangeIntermediateStopLocations() {
        var viewStatus = mockViewStatus()
        let locations = [
            Location(address: "Wilhelminenhofstrasse", lng: 25.1, lat: 35.2),
            Location(address: "Karl-Marx Strasse", lng: 41.2, lat: 63.1)
        ]

        viewStatus.changeIntermediateStopLocations(locations: locations)
        
        XCTAssertEqual(viewStatus.intermediateStopLocations, locations)

        XCTAssertEqual(viewStatus.vehicleStatus, .inVehicle)
        XCTAssertEqual(viewStatus.vehicleLocation, Location(address: nil, lng: 10.1, lat: 20.2))
        XCTAssertEqual(viewStatus.pickupLocation, Location(address: "Alexander Strasse", lng: 30.3, lat: 40.4))
        XCTAssertEqual(viewStatus.dropoffLocation, Location(address: "Adenauer Strasse", lng: 50.5, lat: 60.6))
    }

    func testUpdateStatus() {
        var viewStatus = mockViewStatus()

        viewStatus.updateStatus(status: .waitingForPickup)

        XCTAssertEqual(viewStatus.vehicleStatus, .waitingForPickup)

        XCTAssertEqual(viewStatus.vehicleLocation, Location(address: nil, lng: 10.1, lat: 20.2))
        XCTAssertEqual(viewStatus.pickupLocation, Location(address: "Alexander Strasse", lng: 30.3, lat: 40.4))
        XCTAssertEqual(viewStatus.dropoffLocation, Location(address: "Adenauer Strasse", lng: 50.5, lat: 60.6))
        XCTAssertEqual(viewStatus.intermediateStopLocations, [Location(address: "Tom's house", lng: 70.7, lat: 80.8)])
    }

    func mockViewStatus() -> ViewState {
        let bookingEventData = BookingEventData(
            status: .inVehicle,
            vehicleLocation: Location(
                address: nil,
                lng: 10.1,
                lat: 20.2),
            pickupLocation: Location(
                address: "Alexander Strasse",
                lng: 30.3,
                lat: 40.4),
            dropoffLocation: Location(
                address: "Adenauer Strasse",
                lng: 50.5,
                lat: 60.6),
            intermediateStopLocations: [
                Location(address: "Tom's house", lng: 70.7, lat: 80.8)
            ])

        return ViewState(bookingData: bookingEventData)
    }
}
