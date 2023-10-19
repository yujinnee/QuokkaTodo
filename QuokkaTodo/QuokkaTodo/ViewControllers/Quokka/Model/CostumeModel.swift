//
//  CostumeModel.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/19/23.
//

import Foundation

enum ItemStatus {
    case locked
    case unselected
    case selected
}

struct CostumeModel: Hashable {
    var isSelected: Bool
    var isLocked: Bool
    var imageTitle: String

    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
