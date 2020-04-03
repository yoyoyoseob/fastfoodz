//
//  RestaurantAnnotation.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/2/20.
//

import Foundation
import MapKit

final class RestaurantAnnotation: NSObject, MKAnnotation, Reusable {
    var coordinate: CLLocationCoordinate2D {
        return .init(latitude: restaurant.coordinates.latitude,
                     longitude: restaurant.coordinates.longitude)
    }

    private(set) var restaurant: Restaurant

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        super.init()
    }
}
