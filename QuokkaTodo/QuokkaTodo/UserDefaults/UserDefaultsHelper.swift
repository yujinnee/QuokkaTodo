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
        case endTime = "endTime"
    }
    
    var selectedCostume: Int {
        get {
            return userDefaults.integer(forKey: Key.selectedCostume.rawValue) ?? 0
        }
        set {
            userDefaults.set(newValue,forKey: Key.selectedCostume.rawValue)
        }
    }
    var endTime: String {
        get{
            return userDefaults.string(forKey: Key.endTime.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue,forKey: Key.endTime.rawValue)
        }
    }
   
}
