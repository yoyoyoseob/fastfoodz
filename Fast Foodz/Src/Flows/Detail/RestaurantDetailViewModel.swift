//
//  RestaurantDetailViewModel.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/2/20.
//

import BonMot
import Foundation
import CoreLocation

struct RestaurantDetailViewModel {
    let title = "Details"

    var imageURL: URL? {
        return restaurant.imageURL
    }
    var businessURL: URL? {
        return restaurant.businessURL
    }
    var styledName: NSAttributedString {
        return restaurant.name.styled(with: nameStyle)
    }
    var styledCTA: NSAttributedString {
        return "Call Business".styled(with: ctaStyle)
    }
    var hasPhone: Bool {
        return !restaurant.phone.isEmpty
    }
    var phoneNumberPromptURL: URL? {
        return URL(string: "telprompt:\(restaurant.phone))")
    }
    var restaurantLocation: CLLocationCoordinate2D {
        return .init(latitude: restaurant.coordinates.latitude,
                     longitude: restaurant.coordinates.longitude)
    }
    var userLocation: CLLocationCoordinate2D {
        return .init(latitude: locationManager.currentLocation.coordinate.latitude,
                     longitude: locationManager.currentLocation.coordinate.longitude)
    }

    private let restaurant: Restaurant
    private let locationManager: LocationManager

    init(restaurant: Restaurant,
         locationManager: LocationManager = LocationManager()) {
        self.restaurant = restaurant
        self.locationManager = locationManager
    }
}

// MARK: - Styling
extension RestaurantDetailViewModel {
    private var nameStyle: StringStyle {
        return StringStyle(.color(.white),
                           .alignment(.center),
                           .transform(.capitalized))
    }

    private var ctaStyle: StringStyle {
        return StringStyle(.color(.white))
    }
}
