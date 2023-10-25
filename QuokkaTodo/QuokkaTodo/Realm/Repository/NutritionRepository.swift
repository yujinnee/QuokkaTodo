//
//  NutritionRepository.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/25/23.
//

import Foundation
import RealmSwift


protocol nutritionRepositoryType: AnyObject {
    func findFileURL() -> URL?
    func fetchAll() -> Results<Nutrition>
    func fetchSelectedDateNutrition(date: Date) -> Results<Nutrition>
    func createNutrition(_ item: Nutrition)
}

class NutritionRepository: nutritionRepositoryType{
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
    
    func fetchAll() -> RealmSwift.Results<Nutrition> {
        let data = realm.objects(Nutrition.self).sorted(byKeyPath: "feedNutritionTime",ascending: false)
        return data
    }
    
    func fetchSelectedDateNutrition(date: Date) -> RealmSwift.Results<Nutrition> {
        let start = Calendar.current.startOfDay(for: date)
        let end = start.addingTimeInterval(24*60*60-1)
        var result = realm.objects(Nutrition.self).sorted(byKeyPath:"feedNutritionTime", ascending: false)
        result = result.where{
            $0.feedNutritionTime >= start && $0.feedNutritionTime <= end
        }
        return result
    }
    
    func createNutrition(_ item: Nutrition) {
        do {
            try realm.write {
                realm.add(item)
                print("Realm Add Succeed")
            }
        } catch {
            print(error)
        }
    }
    
    func getNumOfNutrition()->Int{
        let data = realm.objects(Nutrition.self).sorted(byKeyPath: "feedNutritionTime",ascending: false)
        return data.count
    }
  
}



