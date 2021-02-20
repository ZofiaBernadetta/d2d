//
//  BookingEventData.swift
//  d2d
//
//  Created by Zofia Drabek on 20/02/2021.
//

import Foundation

struct BookingEventData: Codable {
    var status: VehicleStatus
    var vehicleLocation: Location
    var pickupLocation: Location
    var dropoffLocation: Location
    var intermediateStopLocations: [Location]
}
