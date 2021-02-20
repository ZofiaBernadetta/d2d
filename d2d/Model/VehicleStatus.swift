//
//  VehicleStatus.swift
//  d2d
//
//  Created by Zofia Drabek on 20/02/2021.
//

import Foundation

public enum VehicleStatus: String, Codable, CustomStringConvertible {
    case waitingForPickup
    case inVehicle
    case droppedOff

    public var description: String {
        switch self {
        case .waitingForPickup:
            return "Waiting for pickup"
        case .inVehicle:
            return "In vehicle"
        case .droppedOff:
            return "Dropped off"
        }
    }
}
