//
//  MockVehicleStateProvider.swift
//  d2dTests
//
//  Created by Zofia Drabek on 20/02/2021.
//

import Foundation
@testable import d2d

class MockVehicleStateProvider: VehicleStateProvider {
    private var stateUpdated: ((Result<Event, Error>) -> Void)?

    var events = [Result<Event, Error>]()
    var index = 0

    func registerListener(stateUpdated: @escaping (Result<Event, Error>) -> Void) {
        self.stateUpdated = stateUpdated
    }

    func sendNextEvent() {
        if index < events.count {
            stateUpdated?(events[index])
            index += 1
        }
    }
}
