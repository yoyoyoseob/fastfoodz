//
//  ListViewModel.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Foundation
import RxCocoa
import RxSwift

class ListViewModel {
    let output$ = PublishSubject<Output>()
    let input$ = PublishSubject<Input>()

    private(set) var restaurants = [Restaurant]()
    private let disposeBag = DisposeBag()

    init() {
        configureBindings()
    }

    func model(for indexPath: IndexPath) -> Restaurant? {
        guard restaurants.indices.contains(indexPath.row) else { return nil }
        return restaurants[indexPath.row]
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard restaurants.indices.contains(indexPath.row) else { return }

        output$.onNext(.didSelectRestaurant(restaurants[indexPath.row]))
    }

    private func configureBindings() {
        input$
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] input in
                switch input {
                case .restaurantsDidChange(let restaurants):
                    self?.restaurants = restaurants.sorted(by: { $0.distance < $1.distance })
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Rx
extension ListViewModel {
    enum Output {
        case didSelectRestaurant(Restaurant)
    }

    enum Input {
        case restaurantsDidChange([Restaurant])
    }
}
