//
//  SocketVehicleStateProvider.swift
//  d2d
//
//  Created by Zofia Drabek on 19/02/2021.
//

import Foundation
import Starscream

class SocketVehicleStateProvider: VehicleStateProvider {
    private let socket: WebSocket
    private var stateUpdated: ((Result<Event, Error>) -> Void)?

    init(urlRequest: URLRequest) {
        socket = WebSocket(request: urlRequest)
        socket.callbackQueue = .main
        socket.onEvent = { [weak self] event in
            switch event {
            case .error(let error):
                self?.stateUpdated?(.failure(error ?? SocketVehicleStateProviderError.unknown))
            case .text(let text):
                do {
                    let event = try JSONDecoder().decode(Event.self, from: Data(text.utf8))
                    self?.stateUpdated?(.success(event))
                } catch {
                    self?.stateUpdated?(.failure(error))
                }
            default:
                break
            }
        }
    }

    func registerListener(stateUpdated: @escaping (Result<Event, Error>) -> Void) {
        self.stateUpdated = stateUpdated
        socket.connect()
    }

    enum SocketVehicleStateProviderError: LocalizedError {
        case unknown

        var errorDescription: String? {
            switch self {
            case .unknown: return "An unknown error occurred."
            }
        }
    }
}
