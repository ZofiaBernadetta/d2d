//
//  SceneDelegate.swift
//  d2d
//
//  Created by Zofia Drabek on 13/02/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let urlRequest = URLRequest(
            url: AppConfiguration.loadFromFile().endpoint,
            timeoutInterval: 5.0)

        if let vehicleMapVC = window?.rootViewController as? VehicleMapViewController {
            vehicleMapVC.viewModel = VehicleMapViewModel(
                vehicleStateProvider: SocketVehicleStateProvider(
                    urlRequest: urlRequest))
        }
    }
}

