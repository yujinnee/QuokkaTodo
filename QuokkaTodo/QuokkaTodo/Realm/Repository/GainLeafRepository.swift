//
//  GainLeafRepository.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/18/23.
//

import Foundation
import RealmSwift


protocol gainLeafRepositoryType: AnyObject {
    func findFileURL() -> URL?
    func fetchAll() -> Results<GainLeaf>
    func fetchSelectedDateGainLeaf(date: Date) -> Results<GainLeaf>
    func createGainLeaf(_ item: GainLeaf)
}

class GainLeafRepository: gainLeafRepositoryType{
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
    
    func fetchAll() -> RealmSwift.Results<GainLeaf> {
        let data = realm.objects(GainLeaf.self).sorted(byKeyPath: "gainLeafTime",ascending: false)
        return data
    }
    
    func fetchSelectedDateGainLeaf(date: Date) -> RealmSwift.Results<GainLeaf> {
        let dateString = DateFormatter.convertToOnlyDateDBForm(date: date)
        
        let result = realm.objects(GainLeaf.self).where {
            $0.gainLeafTime.contains(dateString)
        }
        return result
    }
    
    func createGainLeaf(_ item: GainLeaf) {
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

