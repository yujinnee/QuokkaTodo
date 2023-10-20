//
//  GainLeaf.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/18/23.
//

import Foundation
import RealmSwift

class GainLeaf: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var gainLeafTime: String

    convenience init(gainLeafTime: String) {
        self.init()
        
        self.gainLeafTime = gainLeafTime
    }
}

