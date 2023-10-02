//
//  TodoRepository.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/30.
//

import Foundation
import RealmSwift

protocol todoRepositoryType: AnyObject {
    func findFileURL() -> URL?
    func fetchAll() -> Results<Todo>
    func fetchSelectedDateTodo(date: Date) -> Results<Todo>
    func createTodo(_ item: Todo)
    func updateContents(_id: ObjectId, contents: String)
    func updateDate(_id: ObjectId, date: String)
    func updateCompleted(_id: ObjectId, isCompleted: Bool)
    func updateLeafNum(_id: ObjectId, leafNum: Int)
    func deleteTodo(_id : ObjectId)
}

class TodoRepository: todoRepositoryType{
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
    
    func fetchAll() -> Results<Todo> {
        let data = realm.objects(Todo.self).sorted(byKeyPath: "createdDate",ascending: false)
        return data
    }
    func fetchSelectedDateTodo(date:Date) -> Results<Todo>{
        let dateString = DateFormatter.convertToOnlyDateDBForm(date: date)
        let result = realm.objects(Todo.self).where {
            $0.planDate.contains(dateString)
        }
        return result
    }

    
    func createTodo(_ item: Todo) {
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
                realm.create(Todo.self, value: ["_id": _id,"contents": contents], update:.modified)
            }
        } catch {
            print("error")
        }
    }
    
    func updateDate(_id: RealmSwift.ObjectId, date: String) {
        do {
            try realm.write {
                realm.create(Todo.self, value: ["_id": _id,"planDate": date], update:.modified)
            }
        } catch {
            print("error")
        }
    }
    
    func updateCompleted(_id: RealmSwift.ObjectId, isCompleted: Bool) {
        do {
            try realm.write {
                realm.create(Todo.self, value: ["_id": _id,"isCompleted": isCompleted], update:.modified)
            }
        } catch {
            print("error")
        }
    }
    
    func updateLeafNum(_id: RealmSwift.ObjectId, leafNum: Int) {
        do {
            try realm.write {
                realm.create(Todo.self, value: ["_id": _id,"leafNum": leafNum], update:.modified)
            }
        } catch {
            print("error")
        }
    }
    
    func deleteTodo(_id: ObjectId) {
        let item = realm.object(ofType: Todo.self, forPrimaryKey: _id)!
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
