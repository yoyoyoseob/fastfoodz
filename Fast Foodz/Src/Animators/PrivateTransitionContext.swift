//
//  PrivateTransitionContext.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/2/20.
//

import Foundation
import UIKit

/// Adapted from https://www.objc.io/issues/12-animations/custom-container-view-controller-transitions/
final class PrivateTransitionContext: NSObject, UIViewControllerContextTransitioning {

    var completion: ((Bool) -> Void)?

    var containerView: UIView
    var isAnimated: Bool
    var isInteractive: Bool
    var transitionWasCancelled: Bool
    var presentationStyle: UIModalPresentationStyle
    var targetTransform: CGAffineTransform

    private let viewControllers: [UITransitionContextViewControllerKey: UIViewController]
    private let views: [UITransitionContextViewKey: UIView]

    init(fromViewController: UIViewController, toViewController: UIViewController) {
        assert(fromViewController.isViewLoaded
            && fromViewController.view.superview != nil,
               "fromVC must have a superview when initializing transition context.")

        isAnimated = true
        isInteractive = false
        transitionWasCancelled = false
        targetTransform = .identity

        presentationStyle = .custom
        containerView = fromViewController.view.superview!
        viewControllers = [.from: fromViewController, .to: toViewController]
        views = [.from: fromViewController.view, .to: toViewController.view]
        super.init()
    }

    /*
     Empty implementations because the transition is not interactive.
     */
    func updateInteractiveTransition(_ percentComplete: CGFloat) {}
    func finishInteractiveTransition() {}
    func cancelInteractiveTransition() {}
    func pauseInteractiveTransition() {}

    func completeTransition(_ didComplete: Bool) {
        completion?(true)
    }

    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return viewControllers[key]
    }

    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return views[key]
    }

    func initialFrame(for vc: UIViewController) -> CGRect {
        return containerView.frame
    }

    func finalFrame(for vc: UIViewController) -> CGRect {
        return containerView.frame
    }
}
