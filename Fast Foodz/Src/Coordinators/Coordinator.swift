//
//  Coordinator.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 3/31/20.
//

import Foundation
import UIKit

protocol Coordinator: NSObject {
    var childCoordinators: [Coordinator] { get set }

    var rootViewController: UIViewController { get set }
    var navController: UINavigationController? { get set }
}

extension Coordinator {
    /// Add a child coordinator to the parent
    func addChildCoordinator(childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
    }

    /// Remove a child coordinator from the parent
    func removeChildCoordinator(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
}

extension Coordinator {
    func startWithViewController(_ viewController: UIViewController, animated: Bool) {
        if let navVC = navController {
            navVC.setViewControllers([viewController], animated: animated)
        }
    }
}
