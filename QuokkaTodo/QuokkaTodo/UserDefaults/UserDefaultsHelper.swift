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
        case selectedTodo = "selectredTodo"
        case leftTimeInterval = "leftTimeInterval"
        case timerStatus = "timerStatus"
        case isPause = "isPause"
    }
    
    var selectedCostume: Int {
        get {
            return userDefaults.integer(forKey: Key.selectedCostume.rawValue) 
        }
        set {
            userDefaults.set(newValue,forKey: Key.selectedCostume.rawValue)
        }
    }
    var endTime: String? {
        get{
            return userDefaults.string(forKey: Key.endTime.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue,forKey: Key.endTime.rawValue)
        }
    }

    var selectedTodo: String {
        get{
            return userDefaults.string(forKey: Key.selectedTodo.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue,forKey: Key.selectedTodo.rawValue)
        }
    }
    var leftTimeInterval: Double {
        get{
            return userDefaults.double(forKey: Key.leftTimeInterval.rawValue)
        }
        set {
            userDefaults.set(newValue,forKey: Key.leftTimeInterval.rawValue)
        }
    }
    var timerStatus: Int {
        get{
            return userDefaults.integer(forKey: Key.timerStatus.rawValue)
        }
        set {
            userDefaults.set(newValue,forKey: Key.timerStatus.rawValue)
        }
    }
    var isPause: Bool {
        get{
            return userDefaults.bool(forKey: Key.isPause.rawValue)
        }
        set {
            userDefaults.set(newValue,forKey: Key.isPause.rawValue)
        }
    }
   
}
