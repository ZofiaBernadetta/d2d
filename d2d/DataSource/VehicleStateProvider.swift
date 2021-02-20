//
//  VehicleStateProvider.swift
//  d2d
//
//  Created by Zofia Drabek on 19/02/2021.
//

protocol VehicleStateProvider {
    func registerListener(stateUpdated: @escaping (Result<Event, Error>) -> Void)
}
