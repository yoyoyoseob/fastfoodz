//
//  UIStackView+Init.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Foundation
import UIKit

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis = .vertical,
                     alignment: UIStackView.Alignment = .fill,
                     distribution: UIStackView.Distribution = .fill,
                     spacing: CGFloat = 0,
                     arrangedSubviews: [UIView] = []) {
        self.init()
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing

        arrangedSubviews.forEach { self.addArrangedSubview($0) }
    }
}
