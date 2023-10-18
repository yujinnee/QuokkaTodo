//
//  GainNutrition.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/18/23.
//

import Foundation
import RealmSwift

class GainNutrition: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var gainNutritionTime: String

    convenience init(gainNutritionTime: String) {
        self.init()
        
        self.gainNutritionTime = gainNutritionTime
    }
}


