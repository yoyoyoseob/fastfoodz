//
//  UserDefaults+FastFoodz.swift
//  Fast Foodz
//
//  Created by Yoseob Lee on 4/1/20.
//

import Foundation

extension UserDefaults {
    var selectedSegment: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKey.selectedSegment.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.selectedSegment.rawValue)
        }
    }
}

enum UserDefaultsKey: String {
    case selectedSegment = "selected_segment"
}
