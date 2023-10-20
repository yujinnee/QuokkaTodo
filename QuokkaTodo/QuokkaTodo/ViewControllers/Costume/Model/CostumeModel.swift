//
//  CostumeModel.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/19/23.
//

import Foundation


struct CostumeModel: Hashable {
    var isLocked: Bool
    var imageTitle: String

    let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
