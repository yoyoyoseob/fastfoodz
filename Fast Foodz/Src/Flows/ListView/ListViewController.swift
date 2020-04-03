//
//  ListViewController.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Anchorage
import RxSwift
import UIKit

final class ListViewController: UIViewController {
    private let tableView = UITableView()

    private let viewModel: ListViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: ListViewModel) {
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
        view.backgroundColor = .green
    }
}

// MARK: - UI Config
extension ListViewController {
    private func configureUI() {
        configureTableView()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset.top = 75
        tableView.contentOffset = .init(x: 0, y: -75)
        tableView.separatorStyle = .none

        ListTableViewCell.register(with: tableView)

        view.addSubview(tableView)
        tableView.edgeAnchors == view.edgeAnchors
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let restaurant = viewModel.model(for: indexPath) else { return UITableViewCell() }

        let isLast = indexPath.row == viewModel.restaurants.count - 1

        let cell = ListTableViewCell.dequeueCell(from: tableView, atIndexPath: indexPath)
        let cellVM = ListTableViewCellViewModel(restaurant: restaurant,
                                                isLast: isLast)
        cell.viewModel = cellVM

        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}
