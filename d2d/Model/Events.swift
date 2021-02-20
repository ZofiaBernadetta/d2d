//
//  Events.swift
//  d2d
//
//  Created by Zofia Drabek on 14/02/2021.
//

import Foundation

enum Event: Decodable {
    case bookingOpened(BookingEventData)
    case vehicleLocationUpdated(Location)
    case intermediateStopLocationsChanged([Location])
    case bookingClosed
    case statusUpdated(VehicleStatus)

    enum CodingKeys: String, CodingKey {
        case event
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let eventType = try container.decode(String.self, forKey: .event)

        switch eventType {
        case "bookingOpened":
            self = .bookingOpened(try container.decode(BookingEventData.self, forKey: .data))
        case "vehicleLocationUpdated":
            self = .vehicleLocationUpdated(try container.decode(Location.self, forKey: .data))
        case "intermediateStopLocationsChanged":
            self = .intermediateStopLocationsChanged(try container.decode([Location].self, forKey: .data))
        case "bookingClosed":
            self = .bookingClosed
        case "statusUpdated":
            self = .statusUpdated(try container.decode(VehicleStatus.self, forKey: .data))
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [CodingKeys.data],
                    debugDescription: "Unexpected event type"))
        }
    }
}
