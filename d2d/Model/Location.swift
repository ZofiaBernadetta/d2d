//
//  Location.swift
//  d2d
//
//  Created by Zofia Drabek on 20/02/2021.
//

import Foundation
import MapKit

struct Location: Codable, Equatable {
    var address: String?
    var lng: Double
    var lat: Double
}

extension Location {
    var locationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
