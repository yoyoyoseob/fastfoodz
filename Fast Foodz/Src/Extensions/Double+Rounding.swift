//
//  Double+Rounding.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/2/20.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let factor = pow(10.0, Double(places))
        return (self * factor).rounded() / factor
    }
}
