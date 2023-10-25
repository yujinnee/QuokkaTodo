//
//  LeafRepository.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/25/23.
//

import Foundation
import RealmSwift


protocol leafRepositoryType: AnyObject {
    func findFileURL() -> URL?
    func fetchAll() -> Results<Leaf>
    func fetchSelectedDateFeedLeaf(date: Date) -> Results<Leaf>
    func createLeaf(_ item: Leaf)
}

class LeafRepository: leafRepositoryType{
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
    
    func fetchAll() -> RealmSwift.Results<Leaf> {
        let data = realm.objects(Leaf.self).sorted(byKeyPath: "gainLeafTime",ascending: false)
        return data
    }
    
    func fetchSelectedDateGainLeaf(date: Date) -> Results<Leaf> {
        
        let start = Calendar.current.startOfDay(for: date)
        let end = start.addingTimeInterval(24*60*60-1)
        var result = realm.objects(Leaf.self).sorted(byKeyPath:"gainLeafTime", ascending: false)
        result = result.where{
            $0.gainLeafTime >= start && $0.gainLeafTime <= end
        }
        return result
   
    }
    func fetchSelectedDateFeedLeaf(date: Date) -> Results<Leaf> {
        let start = Calendar.current.startOfDay(for: date)
        let end = start.addingTimeInterval(24*60*60-1)
        var result = realm.objects(Leaf.self).sorted(byKeyPath:"feedLeafTime", ascending: false)
        result = result.where{
            $0.feedLeafTime >= start && $0.feedLeafTime <= end
        }
        return result
    }
    
    func createLeaf(_ item: Leaf) {
        do {
            try realm.write {
                realm.add(item)
                print("Realm Add Succeed")
            }
        } catch {
            print(error)
        }
    }
    func feedLeaf() {
        let _id = realm.objects(Leaf.self).sorted(byKeyPath: "gainLeafTime",ascending: true).where {
            $0.feedLeafTime == nil
        }.first!._id
        
        do {
            try realm.write {
                realm.create(Leaf.self, value: ["_id": _id,"feedLeafTime": Date()], update:.modified)
            }
        } catch {
            print("error")
        }
         
    }
    func checkHasFeedableLeaf()->Bool{
        let result = realm.objects(Leaf.self).where {
            $0.feedLeafTime == nil
        }
        if(result.count>0){
            return true
        }else{
            return false
        }
    }
    func getNumOfLeaf()->Int {
        let result = realm.objects(Leaf.self).where {
            $0.feedLeafTime == nil
        }
        return result.count
    }
    func getNumOfEatenLeaf()->Int{
        let result = realm.objects(Leaf.self).where {
            $0.feedLeafTime != nil
        }
        return result.count
    }
  
}


