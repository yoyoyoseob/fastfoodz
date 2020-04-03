//
//  FastFoodzViewModel.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import CoreLocation
import RxSwift

class FastFoodzViewModel {
    enum ViewType: Int {
        case map
        case list
    }

    let output$ = PublishSubject<Output>()
    let input$ = PublishSubject<Input>()

    let title = "Fast Food Places"
    let items = ["Map", "List"]

    lazy var mapViewModel = MapViewModel()
    lazy var listViewModel = ListViewModel()

    private var viewType: ViewType
    private let locationManager: LocationManager
    private var restaurants = [Restaurant]()
    private let restaurantService: RestaurantServiceProtocol
    private(set) var disposeBag = DisposeBag()

    init(viewType: ViewType,
         restaurantService: RestaurantServiceProtocol = RestaurantService(),
         locationManager: LocationManager = LocationManager.shared) {
        self.viewType = viewType
        self.restaurantService = restaurantService
        self.locationManager = locationManager
        configureBindings()
    }

    func viewDidLoad() {
        output$.onNext(.isLoading(true))
        locationManager.requestAuthorizationIfNeeded()
    }

    private func configureBindings() {
        bindChildViewModels()

        input$
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { input in
                switch input {
                case .selectedSegmentDidChange(let newIdx):
                    guard let type = ViewType(rawValue: newIdx) else { return }
                    UserDefaults.standard.selectedSegment = newIdx
                    self.viewType = type
                    self.output$.onNext(.switchToViewType(type))
                }
            })
            .disposed(by: disposeBag)

        /*
         A little weird but skipping the (1) here to account for the initial `locationDidChange` event (on initialization).

         Then, only take one value (since we're making four network calls per location change, don't wanna overdo it).
         */
        locationManager
            .output$
            .skip(1)
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] output in
                switch output {
                case .locationUpdated(let location):
                    self?.loadRestaurants(at: location)
                    self?.mapViewModel.input$.onNext(.centerOnLocation(location))
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindChildViewModels() {
        listViewModel
            .output$
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] output in
                switch output {
                case .didSelectRestaurant(let restaurant):
                    self?.output$.onNext(.didSelectRestaurant(restaurant))
                }
            })
            .disposed(by: disposeBag)

        mapViewModel
            .output$
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] output in
                switch output {
                case .didSelectRestaurant(let restaurant):
                    self?.output$.onNext(.didSelectRestaurant(restaurant))
                }
            })
            .disposed(by: disposeBag)
    }

    private func loadRestaurants(at location: CLLocation) {
        /*
         Because the yelp API returns a large number of related-categories associated with the search-term, to make it
         easier to categorize, we make 4 independent network calls and blanket set the cuisine for each.

         - Disregarding restaurants that appear across multiple cuisines, letting the system decide which to keep.
         */
        var observables = [Observable<[Restaurant]>]()
        for cuisine in Restaurant.Cuisine.allCases {
            let fetchCuisineObs = restaurantService
                .fetchRestaurants(cuisine,
                                  latitude: CGFloat(location.coordinate.latitude),
                                  longitude: CGFloat(location.coordinate.longitude),
                                  radius: 1000)
                .map { result -> [Restaurant] in
                    switch result {
                    case .success(let list):
                        let categorizedList = list.restaurants.map { restaurant -> Restaurant in
                            restaurant.cuisine = cuisine
                            return restaurant
                        }

                        return categorizedList
                    case .failure(let error):
                        /*
                         If there is a problem retrieving restaurants for a specific cuisine, ignore and return empty array.
                         */
                        debugPrint(error)
                        return []
                    }
            }
            observables.append(fetchCuisineObs)
        }

        /*
         Combine all observables together and wait until they have all returned (success//error).
         Value of restaurants is [[Restaurant]], so remove duplicates and notify child view models and subscribers.
         */
        Observable
            .zip(observables)
            .subscribe(onNext: { [weak self] restaurants in
                guard let sself = self else { return }

                sself.output$.onNext(.isLoading(false))

                let uniqueRestaurants = Array(Set(restaurants.flatMap { $0 }))

                sself.restaurants = uniqueRestaurants
                sself.mapViewModel.input$.onNext(.restaurantsDidChange(uniqueRestaurants))
                sself.listViewModel.input$.onNext(.restaurantsDidChange(uniqueRestaurants))
                sself.output$.onNext(.fetchedRestaurantsForViewType(sself.viewType))
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Rx
extension FastFoodzViewModel {
    enum Output {
        case isLoading(Bool)
        case fetchedRestaurantsForViewType(ViewType)
        case switchToViewType(ViewType)
        case didSelectRestaurant(Restaurant)
    }

    enum Input {
        case selectedSegmentDidChange(Int)
    }
}
