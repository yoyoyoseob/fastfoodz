//
//  LocationManager.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/2/20.
//

import CoreLocation
import Foundation
import RxCocoa
import RxSwift

class LocationManager: NSObject {
    static let shared = LocationManager()

    var output$: Observable<Output> {
        return _userLocation$.map { location -> Output in .locationUpdated(location) }
    }
    var isLocationEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    var currentLocation: CLLocation {
        return _userLocation$.value
    }

    private let _userLocation$ = BehaviorRelay<CLLocation>(value: LocationManager.defaultLocation)
    private let manager = CLLocationManager()
    private static let defaultLocation = CLLocation(latitude: 40.758896,
                                                    longitude: -73.985130)

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest

        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }

    func requestAuthorizationIfNeeded() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            break
        case .authorizedWhenInUse, .authorizedAlways:
            break
        default: break
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            _userLocation$.accept(LocationManager.defaultLocation)
        default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue = manager.location else { return }
        manager.stopUpdatingLocation()
        _userLocation$.accept(locationValue)
    }
}

// MARK: - Rx
extension LocationManager {
    enum Output {
        case locationUpdated(CLLocation)
    }
}
