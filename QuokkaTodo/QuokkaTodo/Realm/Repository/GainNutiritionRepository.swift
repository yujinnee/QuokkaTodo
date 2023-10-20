//
//  GainNutiritionRepository.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/18/23.
//

import Foundation
import RealmSwift

protocol GainNutritionRepositoryType: AnyObject {
    func findFileURL() -> URL?
    func fetchAll() -> Results<GainNutrition>
    func fetchSelectedDateGainNutrition(date: Date) -> Results<GainNutrition>
    func createGainNutrition(_ item: GainNutrition)
}

class GainNutritionRepository: GainNutritionRepositoryType{
    
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
    func fetchAll() -> RealmSwift.Results<GainNutrition> {
        let data = realm.objects(GainNutrition.self).sorted(byKeyPath: "gainNutritionTime",ascending: false)
        return data
    }
    
    func fetchSelectedDateGainNutrition(date: Date) -> RealmSwift.Results<GainNutrition> {
        let dateString = DateFormatter.convertToOnlyDateDBForm(date: date)
        
        let result = realm.objects(GainNutrition.self).where {
            $0.gainNutritionTime.contains(dateString)
        }
        return result
    }
    
    func createGainNutrition(_ item: GainNutrition) {
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
