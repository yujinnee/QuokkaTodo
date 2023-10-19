//
//  UserDefaultsHelper.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/19/23.
//

import Foundation

class UserDefaultsHelper {
    static let standard = UserDefaultsHelper()
        
        private init() { }
        
    let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case selectedCostume = "selectedCostume"
    }
    
    var selectedCostume: String {
        get {
            return userDefaults.string(forKey: Key.selectedCostume.rawValue) ?? "icon_empty"
        }
        set {
            userDefaults.set(newValue,forKey: Key.selectedCostume.rawValue)
        }
    }
   
}
