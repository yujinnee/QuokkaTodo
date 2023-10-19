//
//  Costume.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/19/23.
//

import Foundation

enum Costume: Int,CaseIterable {
    case none
    case glasses
    case sunglasses
    case birthDayHat
    
    var imageName: String {
        switch self {
        case .none:
            return "icon_empty"
        case .glasses:
            return "icon_glasses"
        case .sunglasses:
            return "icon_sunglasses"
        case .birthDayHat:
            return "icon_birthday_hat"
        }
    }
}
