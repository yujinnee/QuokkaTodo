//
//  Nutrition.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/25/23.
//

import Foundation
import RealmSwift

class Nutrition: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var feedNutritionTime: Date?

    convenience init(feedNutritionTime: Date) {
        self.init()
        
        self.feedNutritionTime = feedNutritionTime
    }
}

