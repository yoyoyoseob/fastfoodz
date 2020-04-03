//
//  FastFoodRestaurantList.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Foundation

struct FastFoodRestaurantList: Codable {
    let restaurants: [Restaurant]

    enum CodingKeys: String, CodingKey {
        case restaurants = "businesses"
    }
}
