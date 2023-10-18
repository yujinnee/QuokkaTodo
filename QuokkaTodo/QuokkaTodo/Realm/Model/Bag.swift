//
//  Bag.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/18/23.
//

import Foundation
import RealmSwift

class Bag: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var leafNum: Int
    @Persisted var nutritionNum: Int

    convenience init(leafNum: Int,nutritionNum:Int) {
        self.init()
        
        self.leafNum = leafNum
        self.nutritionNum = nutritionNum
    }
}

