//
//  Reusable.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Foundation
import MapKit
import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension Reusable where Self: UITableViewCell {
    static func register(with tableView: UITableView) {
        tableView.register(Self.self, forCellReuseIdentifier: self.reuseIdentifier)
    }

    static func dequeueCell(from tableView: UITableView, atIndexPath indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! Self
    }
}

extension Reusable where Self: MKAnnotationView {
    static func register(with mapView: MKMapView) {
        mapView.register(Self.self, forAnnotationViewWithReuseIdentifier: self.reuseIdentifier)
    }

    static func dequeueAnnotationView(from mapView: MKMapView) -> Self {
        return mapView.dequeueReusableAnnotationView(withIdentifier: self.reuseIdentifier) as! Self
    }
}
