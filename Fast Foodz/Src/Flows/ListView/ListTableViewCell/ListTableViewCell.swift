//
//  ListTableViewCell.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Anchorage
import BonMot
import Foundation
import UIKit

final class ListTableViewCell: UITableViewCell, Reusable {
    private let iconImageView = UIImageView()
    private let arrowImageView = UIImageView()
    private lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    private let infoLabel = UILabel()
    private let separator = UIView()

    private lazy var contentStackView = UIStackView(axis: .vertical,
                                                    alignment: .fill,
                                                    distribution: .fill,
                                                    spacing: 6,
                                                    arrangedSubviews: [nameLabel, infoLabel])

    var viewModel: ListTableViewCellViewModel? {
        didSet {
            updateUI()
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        guard let vm = viewModel, !vm.isLast else { return }

        separator.isHidden = isHighlighted
        contentView.backgroundColor = isHighlighted ? .powderBlue : .white
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }

        nameLabel.attributedText = viewModel.styledTitle
        infoLabel.attributedText = viewModel.styledInfo

        iconImageView.image = viewModel.cuisine.iconImage.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .deepIndigo
        arrowImageView.tintColor = .deepIndigo

        separator.backgroundColor = .londonSky
        separator.isHidden = viewModel.isLast
    }
}

// MARK: - UI Config
extension ListTableViewCell {
    private func configureUI() {
        configureImageViews()
        configureContentStackView()
        configureSeparator()
    }

    private func configureImageViews() {
        iconImageView.sizeAnchors == .init(width: 32, height: 32)

        contentView.addSubview(iconImageView)
        iconImageView.centerYAnchor == contentView.centerYAnchor - 7
        iconImageView.leadingAnchor == contentView.leadingAnchor + 16

        arrowImageView.image = Image.Icon.chevron.withRenderingMode(.alwaysTemplate)
        arrowImageView.contentMode = .scaleAspectFit

        contentView.addSubview(arrowImageView)
        arrowImageView.centerYAnchor == contentView.centerYAnchor
        arrowImageView.trailingAnchor == contentView.trailingAnchor - 16
    }

    private func configureContentStackView() {
        contentView.addSubview(contentStackView)
        contentStackView.leadingAnchor == iconImageView.trailingAnchor + 12
        contentStackView.trailingAnchor == arrowImageView.leadingAnchor - 12 ~ .low
        contentStackView.verticalAnchors == contentView.verticalAnchors + 16
    }

    private func configureSeparator() {
        contentView.addSubview(separator)
        separator.heightAnchor == 2
        separator.horizontalAnchors == contentView.horizontalAnchors + 12
        separator.bottomAnchor == contentView.bottomAnchor
    }
}
