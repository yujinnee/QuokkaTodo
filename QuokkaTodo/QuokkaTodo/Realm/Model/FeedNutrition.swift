//
//  FeedNutrition.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/17/23.
//

import Foundation
import RealmSwift

class FeedNutrition: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var feedNutritionTime: String

    convenience init(feedNutritionTime: String) {
        self.init()
        
        self.feedNutritionTime = feedNutritionTime
    }
}



