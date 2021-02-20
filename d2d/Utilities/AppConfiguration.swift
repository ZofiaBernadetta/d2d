//
//  AppConfiguration.swift
//  d2d
//
//  Created by Zofia Drabek on 20/02/2021.
//

import Foundation

struct AppConfiguration: Codable {
    let endpoint: URL

    static func loadFromFile() -> Self {
        guard
            let url = Bundle.main.url(forResource: "app_configuration", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let configuration = try? JSONDecoder().decode(Self.self, from: data)
        else {
            fatalError("Couldn't load app configuration.")
        }
        return configuration
    }
}
