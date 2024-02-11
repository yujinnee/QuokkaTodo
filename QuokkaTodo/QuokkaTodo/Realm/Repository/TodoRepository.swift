//
//  TodoRepository.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/30.
//

import Foundation
import RealmSwift

enum TodoType:Int {
    case spareTodo = 0
    case todayTodo = 1
}

protocol todoRepositoryType: AnyObject {
    func findFileURL() -> URL?
    func fetchAll() -> Results<Todo>
    func fetchSelectedDateTodayTodo(date: Date) -> Results<Todo>
    func fetchSelectedDateSpareTodo(date: Date) -> Results<Todo>
    func createTodo(_ item: Todo)
    func updateContents(_id: ObjectId, contents: String)
    func updateDate(_id: ObjectId, date: Date)
    func updateCompleted(_id: ObjectId, isCompleted: Bool)
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
    func fetchAllSpareTodo() -> Results<Todo> {
        let result = realm.objects(Todo.self).where {
            $0.todoType == TodoType.spareTodo.rawValue
        }
        return result
    }
    func fetchSelectedDateTodayTodo(date: Date) -> Results<Todo> {
        let start = Calendar.current.startOfDay(for: date)
        let end = start.addingTimeInterval(24*60*60-1)
        var result = realm.objects(Todo.self).sorted(byKeyPath:"planDate", ascending: false)
        result = result.where{
            $0.planDate >= start && $0.planDate <= end &&  $0.todoType == TodoType.todayTodo.rawValue
        }
        return result
    }
    //    func fetchSelectedDateTodayTodo(date:Date) -> Results<Todo>{
    //        let dateString = DateFormatter.convertToOnlyDateDBForm(date: date)
    //        let result = realm.objects(Todo.self).where {
    //            $0.planDate.contains(dateString)
    //        }
    //        return result
    //    }
    func fetchSelectedDateSpareTodo(date:Date) -> Results<Todo>{
        let start = Calendar.current.startOfDay(for: date)
        let end = start.addingTimeInterval(24*60*60-1)
        var result = realm.objects(Todo.self).sorted(byKeyPath:"planDate", ascending: false)
        result = result.where{
            $0.planDate >= start && $0.planDate <= end &&  $0.todoType == TodoType.spareTodo.rawValue
        }
        return result
    }
    func fetchSelectedDateUnCompletedTodayTodo(date:Date) -> Results<Todo>{        
        let start = Calendar.current.startOfDay(for: date)
        let end = start.addingTimeInterval(24*60*60-1)
        var result = realm.objects(Todo.self).sorted(byKeyPath:"planDate", ascending: false)
        result = result.where{
            $0.planDate >= start && $0.planDate <= end && $0.isCompleted == false && $0.todoType == TodoType.todayTodo.rawValue
        }
        return result
        
    }
    func fetchUnCompletedSpareTodo() -> Results<Todo>{//수정하기
        let result = realm.objects(Todo.self).where {
            $0.isCompleted == false && $0.todoType == TodoType.spareTodo.rawValue
        }
        return result
    }
    func readTodo(_id: ObjectId) -> Todo {
        let result = realm.object(ofType: Todo.self, forPrimaryKey: _id) ?? Todo()
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
    
    func updateDate(_id: RealmSwift.ObjectId, date: Date) {
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
    
    func updateTodoType(_id: RealmSwift.ObjectId, todoType: TodoType) {
        do {
            try realm.write {
                realm.create(Todo.self, value: ["_id": _id,"todoType": todoType.rawValue], update:.modified)
            }
        } catch {
            print("error")
        }
    }
    func updateLeaves(_id: ObjectId, leaf: Leaf) {
         let todoList = realm.objects(Todo.self).where{
            $0._id == _id
        }
        
        guard let todo = todoList.first else{
            return
        }
        do {
            try realm.write {
                todo.leaves.append(leaf)
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
