//
//  DiaryRepository.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/19/23.
//

import Foundation
import RealmSwift

protocol diaryRepositoryType: AnyObject {
    func findFileURL() -> URL?
    func fetchAll() -> Results<Diary>
    func fetchSelectedDateDiary(date: Date) -> Results<Diary>
    func createDiary(_ item: Diary)
    func updateContents(_id: ObjectId, contents: String)
    func updateDate(_id: ObjectId, date: String)
    func deleteDiary(_id : ObjectId)
}

class DiaryRepository: diaryRepositoryType{
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
    
    func fetchAll() -> Results<Diary> {
        let data = realm.objects(Diary.self).sorted(byKeyPath: "createdDate",ascending: false)
        return data
    }
    func fetchSelectedDateDiary(date:Date) -> Results<Diary>{
        let dateString = DateFormatter.convertToOnlyDateDBForm(date: date)
        let result = realm.objects(Diary.self).where {
            $0.createdDate.contains(dateString)
        }
        return result
    }
    
    func createDiary(_ item: Diary) {
        do {
            try realm.write {
                realm.add(item)
                print("Realm Add Succeed")
            }
        } catch {
            print(error)
        }
    }
    
    func updateContents(_id: RealmSwift.ObjectId, contents: String) {
        do {
            try realm.write {
                realm.create(Diary.self, value: ["_id": _id,"contents": contents], update:.modified)
            }
        } catch {
            print("error")
        }
    }
    
    func updateDate(_id: RealmSwift.ObjectId, date: String) {
        do {
            try realm.write {
                realm.create(Diary.self, value: ["_id": _id,"planDate": date], update:.modified)
            }
        } catch {
            print("error")
        }
    }
    
   
    func deleteDiary(_id: ObjectId) {
        let item = realm.object(ofType: Diary.self, forPrimaryKey: _id)!
        do {
            try realm.write {
                realm.delete(item)
                print("Realm Remove Succeed")
            }
        } catch {
            print(error)
        }
    }

  
}
