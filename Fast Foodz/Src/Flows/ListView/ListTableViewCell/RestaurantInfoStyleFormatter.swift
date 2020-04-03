//
//  RestaurantInfoStyleFormatter.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/2/20.
//

import BonMot
import Foundation

struct RestaurantInfoStyleFormatter {
    static var activePriceStyle: StringStyle {
        return StringStyle(.color(.pickleGreen))
    }

    static var defaultStyle: StringStyle {
        return StringStyle(.color(.lilacGrey))
    }

    static var infoStyle: StringStyle {
        return StringStyle(
            .xmlRules([
                .style("activePrice", RestaurantInfoStyleFormatter.activePriceStyle),
                .style("default", RestaurantInfoStyleFormatter.defaultStyle)
            ])
        )
    }

    static func styled(price: String, info: String) -> NSAttributedString {
        return "<activePrice>\(price)</activePrice><default>\(info)</default>"
            .styled(with: RestaurantInfoStyleFormatter.infoStyle)
    }
}
