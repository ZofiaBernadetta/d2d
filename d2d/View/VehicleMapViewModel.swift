//
//  VehicleMapViewModel.swift
//  d2d
//
//  Created by Zofia Drabek on 19/02/2021.
//

import Foundation

protocol VehicleMapViewModelProtocol {
    var viewState: ViewState? { get }
    var viewStateUpdated: ((Event) -> Void)? { get set }
    var errorOccurred: ((Error) -> Void)? { get set }
}

class VehicleMapViewModel: VehicleMapViewModelProtocol {
    var viewState: ViewState?
    var viewStateUpdated: ((Event) -> Void)?
    var errorOccurred: ((Error) -> Void)?

    var vehicleStateProvider: VehicleStateProvider

    init(vehicleStateProvider: VehicleStateProvider) {
        self.vehicleStateProvider = vehicleStateProvider
        self.vehicleStateProvider.registerListener { [weak self] result in
            switch result {
            case .success(let eventItem):
                self?.eventReceived(event: eventItem)
            case .failure(let error):
                self?.errorOccurred?(error)
            }
        }
    }

    func eventReceived(event: Event) {
        switch event {
        case .bookingOpened(let data):
            viewState = ViewState(bookingData: data)
        case .vehicleLocationUpdated(let location):
            viewState?.updateVehicleLocation(location: location)
        case .intermediateStopLocationsChanged(let locations):
            viewState?.changeIntermediateStopLocations(locations: locations)
        case .statusUpdated(let vehicleStatus):
            viewState?.updateStatus(status: vehicleStatus)
        case .bookingClosed:
            viewState = nil
        }
        viewStateUpdated?(event)
    }
}
