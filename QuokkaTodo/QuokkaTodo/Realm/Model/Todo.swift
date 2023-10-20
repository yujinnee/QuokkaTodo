//
//  Todo.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/29.
//

import Foundation
import RealmSwift

class Todo: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var contents: String
    @Persisted var planDate: String
    @Persisted var createdDate: String
    @Persisted var isCompleted = false
    @Persisted var position: Int
    @Persisted var leafNum: Int
    
    convenience init(contents: String, planDate: String,createdDate: String,position: Int,leafNum: Int) {
        self.init()
        
        self.contents = contents
        self.planDate = planDate
        self.createdDate = createdDate
        self.position = position
        self.leafNum = leafNum
    }
}

