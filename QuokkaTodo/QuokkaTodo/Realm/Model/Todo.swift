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
    @Persisted var planDate: Date
    @Persisted var createdDate: Date
    @Persisted var isCompleted = false
    @Persisted var position: Int
    @Persisted var todoType: Int
    @Persisted var leaves: List<Leaf>
    
    
    convenience init(contents: String, planDate: Date,createdDate: Date,position: Int,todoType: Int) {
        self.init()
        
        self.contents = contents
        self.planDate = planDate
        self.createdDate = createdDate
        self.position = position
        self.todoType = todoType
        
    }
}

