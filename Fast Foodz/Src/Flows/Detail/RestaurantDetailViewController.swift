//
//  RestaurantDetailViewController.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Anchorage
import MapKit
import RxSwift
import SDWebImage
import UIKit

final class RestaurantDetailViewController: UIViewController {
    private let contentStackView = UIStackView(axis: .vertical,
                                               alignment: .center,
                                               distribution: .fill,
                                               spacing: 0)

    private let restaurantImageView = UIImageView()
    private let nameContainer = UIView()
    private let nameLabel = UILabel()

    private let mapContainer = UIView()
    private let mapView = MKMapView()

    private let callButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)

    private let viewModel: RestaurantDetailViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: RestaurantDetailViewModel) {
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
        configureBindings()
    }

    private func updateUI() {
        view.backgroundColor = .white
        restaurantImageView.sd_setImage(with: viewModel.imageURL)
        nameLabel.attributedText = viewModel.styledName
        nameContainer.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        callButton.backgroundColor = .competitionPurple
        callButton.isEnabled = viewModel.hasPhone
        callButton.setAttributedTitle(viewModel.styledCTA, for: .normal)
    }

    private func configureBindings() {
        callButton.rx
            .tap
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let phoneURL = self?.viewModel.phoneNumberPromptURL else { return }

                if UIApplication.shared.canOpenURL(phoneURL) {
                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - MKMapViewDelegate
extension RestaurantDetailViewController: MKMapViewDelegate {
    func setupDirectionsOverlay() {
        let srcPlacemark = MKPlacemark(coordinate: viewModel.userLocation)
        let dstPlacemark = MKPlacemark(coordinate: viewModel.restaurantLocation)

        let request = MKDirections.Request()
        request.source = .init(placemark: srcPlacemark)
        request.destination = .init(placemark: dstPlacemark)
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let response = response else { return }

            if response.routes.count > 0 {
                guard let sself = self else { return }
                sself.mapContainer.addSubview(sself.mapView)
                sself.mapView.topAnchor == sself.mapContainer.topAnchor + 16
                sself.mapView.horizontalAnchors == sself.mapContainer.horizontalAnchors + 16
                sself.mapView.bottomAnchor == sself.mapContainer.bottomAnchor - 24

                self?.mapView.addOverlay(response.routes[0].polyline)
                self?.mapView.setRegion(.init(response.routes[0].polyline.boundingMapRect), animated: false)
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .bluCepheus
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
}

// MARK: - UI Config
extension RestaurantDetailViewController {
    private func configureUI() {
        title = viewModel.title

        configureContentStackView()
        configureHeaderSection()
        configureMapSection()
        configureCTASection()
        configureShareButton()
    }

    private func configureContentStackView() {
        view.addSubview(contentStackView)
        contentStackView.topAnchor == view.safeAreaLayoutGuide.topAnchor
        contentStackView.horizontalAnchors == view.horizontalAnchors
        contentStackView.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor
    }

    private func configureHeaderSection() {
        restaurantImageView.contentMode = .scaleAspectFill
        restaurantImageView.clipsToBounds = true

        contentStackView.addArrangedSubview(restaurantImageView)
        restaurantImageView.widthAnchor == view.widthAnchor
        restaurantImageView.heightAnchor == 9 * view.widthAnchor / 16
        restaurantImageView.horizontalAnchors == contentStackView.horizontalAnchors

        restaurantImageView.addSubview(nameContainer)
        nameContainer.horizontalAnchors == restaurantImageView.horizontalAnchors
        nameContainer.bottomAnchor == restaurantImageView.bottomAnchor

        nameContainer.addSubview(nameLabel)
        nameLabel.horizontalAnchors == nameContainer.horizontalAnchors + 16
        nameLabel.verticalAnchors == nameContainer.verticalAnchors + 12
    }

    private func configureMapSection() {
        mapView.layer.cornerRadius = 12
        mapView.clipsToBounds = true
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        mapView.delegate = self
        mapView.isScrollEnabled = false

        contentStackView.addArrangedSubview(mapContainer)
        mapContainer.horizontalAnchors == contentStackView.horizontalAnchors

        setupDirectionsOverlay()
    }

    private func configureCTASection() {
        contentStackView.addArrangedSubview(callButton)
        callButton.heightAnchor == 48
        callButton.horizontalAnchors == contentStackView.horizontalAnchors + 16
        callButton.layer.cornerRadius = 6
        callButton.clipsToBounds = true
    }

    private func configureShareButton() {
        let shareBtn = UIBarButtonItem(image: Image.Icon.share, style: .plain, target: self, action: #selector(didTapShare))
        navigationItem.rightBarButtonItem = shareBtn
    }

    @objc private func didTapShare() {
        guard let businessURL = viewModel.businessURL else { return }

        let activityVC = UIActivityViewController(activityItems: [businessURL], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        present(activityVC, animated: true, completion: nil)
    }
}
