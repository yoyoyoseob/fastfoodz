//
//  RestaurantAnnotationView.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/2/20.
//

import Foundation
import MapKit

final class RestaurantAnnotationView: MKAnnotationView, Reusable {
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue else { return }

            switch annotation {
            case is RestaurantAnnotation:
                canShowCallout = false
                image = Image.Icon.pin
                centerOffset = .init(x: 0, y: -image!.size.height / 2)
            default: return
            }
        }
    }
}
