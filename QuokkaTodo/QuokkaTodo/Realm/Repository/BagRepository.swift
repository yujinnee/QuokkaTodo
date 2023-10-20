//
//  BagRepository.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/18/23.
//

import Foundation
import RealmSwift

protocol bagRepositoryType: AnyObject {
    func findFileURL() -> URL?
    func readLeafNum() -> Int
    func readNutritionNum() -> Int
    func createBag(_ item: Todo)
    func updateLeafNum(num: Int)
    func updateNutirionNum(num: Int)
  
}

class BagRepository: bagRepositoryType{
   
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
    
    func readLeafNum() -> Int {
        let data = realm.objects(Bag.self).first?.leafNum ?? 0
        return data
    }
    
    func readNutritionNum() -> Int {
        let data = realm.objects(Bag.self).first?.nutritionNum ?? 0
        return data
    }
    
    func createBag(_ item: Todo) {
        do {
            try realm.write {
                realm.add(item)
                print("Realm Add Succeed")
            }
        } catch {
            print(error)
        }
    }
    
    func updateLeafNum(num: Int) {
        if(num<0){return}
        let _id = realm.objects(Bag.self).first?._id ?? ObjectId()
        do {
            try realm.write {
                realm.create(Bag.self, value: ["_id": _id,"leafNum": num], update:.modified)
            }
        } catch {
            print("error")
        }
    }
    
    func updateNutirionNum(num: Int) {
        if(num<0){return}
        let _id = realm.objects(Bag.self).first?._id ?? ObjectId()
        do {
            try realm.write {
                realm.create(Bag.self, value: ["_id": _id,"nutiritionNum": num], update:.modified)
            }
        } catch {
            print("error")
        }
    }
    

  
}
