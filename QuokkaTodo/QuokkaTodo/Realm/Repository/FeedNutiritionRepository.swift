//
//  FeedNutiritionRepository.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/18/23.
//

import Foundation
import RealmSwift

protocol FeedNutritionRepositoryType: AnyObject {
    func findFileURL() -> URL?
    func fetchAll() -> Results<FeedNutrition>
    func fetchSelectedDateFeedNutrition(date: Date) -> Results<FeedNutrition>
    func createFeedNutrition(_ item: FeedNutrition)
}

class FeedNutritionRepository: FeedNutritionRepositoryType{
    
    private let realm = try! Realm()
    func checkSchemaVersion() {
        do{
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version: \(version)")
        } catch {
            print(error)
        }
    }
    func findFileURL() -> URL? {
        let fileURL = realm.configuration.fileURL
        return fileURL
    }
    func fetchAll() -> RealmSwift.Results<FeedNutrition> {
        let data = realm.objects(FeedNutrition.self).sorted(byKeyPath: "feedNutritionTime",ascending: false)
        return data
    }
    
    func fetchSelectedDateFeedNutrition(date: Date) -> RealmSwift.Results<FeedNutrition> {
        let dateString = DateFormatter.convertToOnlyDateDBForm(date: date)
        
        let result = realm.objects(FeedNutrition.self).where {
            $0.feedNutritionTime.contains(dateString)
        }
        return result
    }
    
    func createFeedNutrition(_ item: FeedNutrition) {
        do {
            try realm.write {
                realm.add(item)
                print("Realm Add Succeed")
            }
        } catch {
            print(error)
        }
    }
    
    
}
