//
//  MapView+Center.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/2/20.
//

import Foundation
import MapKit

extension MKMapView {
    func centerToLocation(_ location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: radius,
                                                  longitudinalMeters: radius)
        setRegion(coordinateRegion, animated: true)
    }
}
