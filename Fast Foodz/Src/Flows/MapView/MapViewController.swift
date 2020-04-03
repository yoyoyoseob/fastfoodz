//
//  MapViewController.swift
//  Fast Foodz
//

import Anchorage
import MapKit
import RxSwift
import UIKit

class MapViewController: UIViewController {
    private let mapView = MKMapView()

    private let viewModel: MapViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateUI()
    }

    private func updateUI() {
        view.backgroundColor = .deepIndigo
    }
}

// MARK: - UI Config
extension MapViewController {
    private func configureUI() {
        configureMapView()
        configureMapAnnotations()
    }

    private func configureMapView() {
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll

        RestaurantAnnotationView.register(with: mapView)

        if viewModel.shouldShowUserLocation {
            mapView.showsUserLocation = true
        }

        view.addSubview(mapView)
        mapView.edgeAnchors == view.edgeAnchors
        mapView.centerToLocation(viewModel.initialLocation, radius: 1000)
    }

    private func configureMapAnnotations() {
        let annotations = viewModel.restaurants.map { RestaurantAnnotation(restaurant: $0) }
        mapView.addAnnotations(annotations)
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }

        let annotationView = RestaurantAnnotationView.dequeueAnnotationView(from: mapView)
        annotationView.annotation = annotation
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        guard let restaurantAnnotationView = view as? RestaurantAnnotationView,
            let restaurantAnnotation = restaurantAnnotationView.annotation as? RestaurantAnnotation else {
                return
        }
        viewModel.didSelectRestaurant(restaurantAnnotation.restaurant)
    }
}
