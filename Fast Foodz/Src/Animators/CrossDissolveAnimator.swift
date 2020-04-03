//
//  CrossDissolveAnimator.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/2/20.
//

import Foundation
import UIKit

final class CrossDissolveAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private var container: UIView?

    init(container: UIView? = nil) {
        self.container = container
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else {
                return
        }

        if let container = container {
            container.insertSubview(toView, at: 0)
        } else {
            transitionContext.containerView.addSubview(toView)
        }
        toView.alpha = 0.0

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.alpha = 0.0
            toView.alpha = 1.0
        }) { complete in
            if complete {
                transitionContext.completeTransition(true)
            }
        }
    }
}
