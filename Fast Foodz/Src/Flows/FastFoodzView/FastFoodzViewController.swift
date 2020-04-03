//
//  FastFoodzViewController.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Anchorage
import Foundation
import RxCocoa
import RxSwift
import UIKit

final class FastFoodzViewController: UIViewController {
    let container = UIView()
    lazy var control = UISegmentedControl(items: viewModel.items)

    private let loadingView = UIActivityIndicatorView(style: .medium)

    private var isInitialLoad = true

    private let viewModel: FastFoodzViewModel
    private let disposeBag = DisposeBag()

    private lazy var mapVC = MapViewController(viewModel: viewModel.mapViewModel)
    private lazy var listVC = ListViewController(viewModel: viewModel.listViewModel)

    init(viewModel: FastFoodzViewModel) {
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
        viewModel.viewDidLoad()
    }

    private func configureBindings() {
        viewModel
            .output$
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] output in
                switch output {
                case .isLoading(let isLoading):
                    isLoading
                    ? self?.loadingView.startAnimating()
                    : self?.loadingView.stopAnimating()
                case .fetchedRestaurantsForViewType(let type):
                    self?.control.isHidden = false
                    self?.configure(for: type)
                    self?.control.selectedSegmentIndex = type.rawValue
                case .switchToViewType(let viewType):
                    self?.configure(for: viewType)
                case .didSelectRestaurant: break
                }
            })
            .disposed(by: disposeBag)

        control.rx
            .selectedSegmentIndex
            .skip(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] selectedIdx in
                self?.viewModel.input$.onNext(.selectedSegmentDidChange(selectedIdx))
            })
            .disposed(by: disposeBag)
    }

    private func configure(for viewType: FastFoodzViewModel.ViewType) {
        switch viewType {
        case .map:
            addChildAndAnimate(from: listVC, to: mapVC)
        case .list:
            addChildAndAnimate(from: mapVC, to: listVC)
        }
    }

    private func addChildAndAnimate(from fromVC: UIViewController, to toVC: UIViewController) {
        fromVC.willMove(toParent: nil)
        addChild(toVC)

        // If initial, add without animation.
        if isInitialLoad {
            isInitialLoad = false
            container.insertSubview(toVC.view, at: 0)
            toVC.didMove(toParent: self)
            return
        }

        // Otherwise, cross-dissolve animation.
        let animator = CrossDissolveAnimator(container: container)
        let context = PrivateTransitionContext(fromViewController: fromVC, toViewController: toVC)
        context.completion = { isComplete in
            if isComplete {
                fromVC.view.removeFromSuperview()
                fromVC.removeFromParent()

                toVC.didMove(toParent: self)
                self.control.isUserInteractionEnabled = true
            }
        }

        // Disable segmented control until animation is complete.
        control.isUserInteractionEnabled = false
        animator.animateTransition(using: context)
    }

    private func updateUI() {
        view.backgroundColor = .white
        control.backgroundColor = .londonSky
        control.selectedSegmentTintColor = .competitionPurple
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.deepIndigo], for: .normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
}

// MARK: - UI Config
extension FastFoodzViewController {
    private func configureUI() {
        title = viewModel.title

        configureLoadingIndicator()
        configureContainerView()
        configureSegmentedControl()
    }

    private func configureLoadingIndicator() {
        loadingView.hidesWhenStopped = true

        view.addSubview(loadingView)
        loadingView.centerAnchors == view.centerAnchors
    }

    private func configureContainerView() {
        view.addSubview(container)
        container.topAnchor == view.topAnchor
        container.horizontalAnchors == view.horizontalAnchors
        container.bottomAnchor == view.bottomAnchor
    }

    private func configureSegmentedControl() {
        control.isHidden = true // Unhidden once data is loaded.

        view.addSubview(control)
        control.topAnchor == view.safeAreaLayoutGuide.topAnchor + 24
        control.centerXAnchor == view.centerXAnchor
        control.horizontalAnchors == view.horizontalAnchors + 72
    }
}
