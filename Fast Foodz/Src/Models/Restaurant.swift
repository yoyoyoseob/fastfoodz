//
//  Restaurant.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Foundation
import UIKit

class Restaurant: Codable {
    enum Cuisine: String, CaseIterable, Codable {
        case mexican
        case pizza
        case burgers
        case chinese

        var iconImage: UIImage {
            switch self {
            case .mexican:
                return Image.Icon.mexican
            case .pizza:
                return Image.Icon.pizza
            case .burgers:
                return Image.Icon.burgers
            case .chinese:
                return Image.Icon.chinese
            }
        }
    }

    let name: String
    let imageURLString: String
    let businessURLString: String
    let coordinates: Coordinates
    var price: String?
    let phone: String
    let displayPhone: String
    // Represents distance in meters
    let distance: Double

    var distanceInMiles: Double {
        return distance * Conversion.milesToMeters
    }
    var imageURL: URL? {
        return URL(string: imageURLString)
    }
    var businessURL: URL? {
        return URL(string: businessURLString)
    }
    var cuisine: Cuisine = .mexican

    enum CodingKeys: String, CodingKey {
        case name
        case imageURLString = "image_url"
        case businessURLString = "url"
        case coordinates
        case price
        case phone
        case displayPhone = "display_phone"
        case distance
    }
}

// MARK: - Equatable
extension Restaurant: Equatable {
    static func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.name == rhs.name
            && lhs.price == rhs.price
            && lhs.distance == rhs.distance
    }
}

// MARK: - Hashable
extension Restaurant: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(price)
        hasher.combine(distance)
    }
}
