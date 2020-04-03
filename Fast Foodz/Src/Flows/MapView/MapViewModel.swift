//
//  MapViewModel.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/2/20.
//

import CoreLocation
import Foundation
import RxCocoa
import RxSwift

class MapViewModel {
    let output$ = PublishSubject<Output>()
    let input$ = PublishSubject<Input>()

    var shouldShowUserLocation: Bool {
        return locationManager.isLocationEnabled
    }

    private(set) var initialLocation = CLLocation()
    private(set) var restaurants = [Restaurant]()

    private let disposeBag = DisposeBag()
    private let locationManager: LocationManager

    init(locationManager: LocationManager = LocationManager.shared) {
        self.locationManager = locationManager
        configureBindings()
    }

    func didSelectRestaurant(_ restaurant: Restaurant) {
        output$.onNext(.didSelectRestaurant(restaurant))
    }

    private func configureBindings() {
        input$
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] input in
                switch input {
                case .restaurantsDidChange(let restaurants):
                    self?.restaurants = restaurants
                case .centerOnLocation(let location):
                    self?.initialLocation = location
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Rx
extension MapViewModel {
    enum Output {
        case didSelectRestaurant(Restaurant)
    }

    enum Input {
        case centerOnLocation(CLLocation)
        case restaurantsDidChange([Restaurant])
    }
}
