//
//  RestaurantService.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Alamofire
import Foundation

protocol RestaurantServiceProtocol: NetworkService {
    func fetchRestaurants(_ cuisine: Restaurant.Cuisine,
                          latitude: CGFloat,
                          longitude: CGFloat,
                          radius: Double) -> ObservableTypedAPIResult<FastFoodRestaurantList>
}

struct RestaurantService: RestaurantServiceProtocol {
    func fetchRestaurants(_ cuisine: Restaurant.Cuisine,
                          latitude: CGFloat,
                          longitude: CGFloat,
                          radius: Double) -> ObservableTypedAPIResult<FastFoodRestaurantList> {
        let url = URL(string: "https://api.yelp.com/v3/businesses/search?")!

        return makeRequest(method: .get,
                           url: url,
                           params: ["latitude": latitude,
                                    "longitude": longitude,
                                    "radius": radius,
                                    "sort_by": "distance",
                                    "categories": cuisine.rawValue],
                           encoding: URLEncoding.default,
                           forType: FastFoodRestaurantList.self)
    }
}
