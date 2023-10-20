//
//  Diary.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/19/23.
//

import Foundation
import RealmSwift

class Diary: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var contents: String
    @Persisted var createdDate: String
    
    convenience init(contents: String, createdDate: String) {
        self.init()
        
        self.contents = contents
        self.createdDate = createdDate
    }
}

