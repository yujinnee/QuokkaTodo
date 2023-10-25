//
//  Leaf.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/17/23.
//

import Foundation
import RealmSwift

class Leaf: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var gainLeafTime: Date
    @Persisted var feedLeafTime: Date?

    convenience init(gainLeafTime: Date) {
        self.init()
        
        self.gainLeafTime = gainLeafTime
    }
}

