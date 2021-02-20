//
//  ViewState.swift
//  d2d
//
//  Created by Zofia Drabek on 19/02/2021.
//

struct ViewState: Equatable {
    var vehicleStatus: VehicleStatus
    var vehicleLocation: Location
    var pickupLocation: Location
    var dropoffLocation: Location
    var intermediateStopLocations: [Location]

    init(bookingData: BookingEventData) {
        self.vehicleStatus = bookingData.status
        self.vehicleLocation = bookingData.vehicleLocation
        self.pickupLocation = bookingData.pickupLocation
        self.dropoffLocation = bookingData.dropoffLocation
        self.intermediateStopLocations = bookingData.intermediateStopLocations
    }

    mutating func updateVehicleLocation(location: Location) {
        vehicleLocation = location
    }

    mutating func changeIntermediateStopLocations(locations: [Location]) {
        intermediateStopLocations = locations
    }

    mutating func updateStatus(status: VehicleStatus) {
        self.vehicleStatus = status
    }
}
