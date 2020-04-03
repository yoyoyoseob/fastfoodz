//
//  ListTableViewCellViewModel.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/2/20.
//

import BonMot
import Foundation

struct ListTableViewCellViewModel {
    var styledTitle: NSAttributedString {
        return restaurant.name.styled(with: nameStyle)
    }

    var styledInfo: NSAttributedString {
        if let price = restaurant.price {
            let dollarSignFiller = String.init(repeating: "$", count: minPriceIconCount - price.count)

            return RestaurantInfoStyleFormatter.styled(price: price, info: "\(dollarSignFiller) • \(distanceString)")
        } else {
            return distanceString.styled(with: RestaurantInfoStyleFormatter.defaultStyle)
        }
    }

    var cuisine: Restaurant.Cuisine {
        return restaurant.cuisine
    }

    private let minPriceIconCount = 4
    private var distanceString: String {
        return String(restaurant.distanceInMiles.round(to: 2)) + " miles"
    }

    private(set) var isLast: Bool
    private let restaurant: Restaurant

    init(restaurant: Restaurant, isLast: Bool) {
        self.restaurant = restaurant
        self.isLast = isLast
    }
}

// MARK: - Styling
extension ListTableViewCellViewModel {
    private var nameStyle: StringStyle {
        return StringStyle(.color(.deepIndigo))
    }
}
