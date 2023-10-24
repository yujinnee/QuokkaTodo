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
        let calendar = Calendar.current
        let selectedDate = calendar.startOfDay(for: date)
        let max = Calendar.current.date(byAdding: .day, value: 1,
                                        to: selectedDate)!
        var result = realm.objects(Leaf.self).sorted(byKeyPath:"gainLeafTime", ascending: false).filter(
        NSPredicate(format: "gainLeafTime >= %0 AND gainLeafTime < %0", selectedDate as NSDate, max as NSDate )
        )
        return result
   
    }
    func fetchSelectedDateFeedLeaf(date: Date) -> Results<Leaf> {
        let max = Calendar.current.date(byAdding: .day, value: 1,
                                        to: date)!
        var result = realm.objects(Leaf.self).sorted(byKeyPath:"feedLeafTime", ascending: false).filter(
        NSPredicate(format: "feedLeafTime >= %0 AND feedLeafTime < %0", date as NSDate, max as NSDate )
        )
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
        let _id = realm.objects(Leaf.self).sorted(byKeyPath: "gainLeafTime",ascending: true).first!
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


