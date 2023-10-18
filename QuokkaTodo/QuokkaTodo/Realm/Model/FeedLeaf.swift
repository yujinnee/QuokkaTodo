//
//  FeedLeaf.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/17/23.
//

import Foundation
import RealmSwift

class FeedLeaf: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var feedLeafTime: String

    convenience init(_id: ObjectId, feedLeafTime: String) {
        self.init()
        
        self._id = _id
        self.feedLeafTime = feedLeafTime
    }
}

