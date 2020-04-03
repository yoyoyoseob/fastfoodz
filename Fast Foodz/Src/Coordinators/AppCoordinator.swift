//
//  AppCoordinator.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 3/31/20.
//

import Foundation
import RxSwift
import UIKit

final class AppCoordinator: NSObject, Coordinator {
    var childCoordinators = [Coordinator]()

    var rootViewController: UIViewController
    var navController: UINavigationController?

    private let disposeBag = DisposeBag()

    init(rootViewController: UIViewController, navController: UINavigationController?) {
        self.rootViewController = rootViewController
        self.navController = navController
    }

    /// Special convenience init for AppCoordinator so that AppDelegate doesn't have to worry about initializing.
    /// The AppCoordinator's root controller is it's navigation controller instance.
    convenience override init() {
        let navVC = UINavigationController()
        self.init(rootViewController: navVC, navController: navVC)
    }

    func start(_ initialIndex: Int) {
        guard let viewType = FastFoodzViewModel.ViewType(rawValue: initialIndex) else { return }

        let vm = FastFoodzViewModel(viewType: viewType)
        let vc = FastFoodzViewController(viewModel: vm)
        startWithViewController(vc, animated: true)
        bindViewModel(vm)
    }

    private func bindViewModel(_ viewModel: FastFoodzViewModel) {
        viewModel
            .output$
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] output in
                switch output {
                case .didSelectRestaurant(let restaurant):
                    self?.startDetailFlow(restaurant)
                default: break
                }
            })
            .disposed(by: viewModel.disposeBag)
    }

    private func startDetailFlow(_ restaurant: Restaurant) {
        let vm = RestaurantDetailViewModel(restaurant: restaurant)
        let vc = RestaurantDetailViewController(viewModel: vm)
        navController?.pushViewController(vc, animated: true)
    }
}
