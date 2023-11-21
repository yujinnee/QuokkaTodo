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
        
        let start = Calendar.current.startOfDay(for: date)
        let end = start.addingTimeInterval(24*60*60-1)
        var result = realm.objects(Diary.self).sorted(byKeyPath:"createdDate", ascending: false)
        result = result.where{
            $0.createdDate >= start && $0.createdDate <= end
        }
        return result
        
    }
    func fetchAnnuallyDiary(year:Int) -> Results<Diary>{
        let startOfYearDate = DateFormatter.getStartOfYear(year: year)
        let startOfNextYearDate = DateFormatter.getStartOfYear(year: year+1)

        var result = realm.objects(Diary.self).sorted(byKeyPath:"createdDate", ascending: true)
        result = result.where{
            $0.createdDate >= startOfYearDate && $0.createdDate <= startOfNextYearDate
        }
        return result
    }
    func hasPreviousDiary() -> Bool{
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let thisYear = format.string(from: Date())
        let startOfYearDate = DateFormatter.getStartOfYear(year: Int(thisYear) ?? 2010)
        
        var result = realm.objects(Diary.self).sorted(byKeyPath:"createdDate", ascending: false)
        result = result.where{
            $0.createdDate < startOfYearDate
        }
        
        if result.count > 0 {
            return true
        }else {
            return false
        }
   
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
    func checkHasTodayDiary(date:Date)->Bool {
        let start = Calendar.current.startOfDay(for: date)
        let end = start.addingTimeInterval(24*60*60-1)
        var result = realm.objects(Diary.self).sorted(byKeyPath:"createdDate", ascending: false)
        result = result.where{
            $0.createdDate >= start && $0.createdDate <= end
        }
        if(result.count>0){
            return true
        }else {
            return false
        }
    }

  
}
