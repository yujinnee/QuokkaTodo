////
////  FeedLeafRepository.swift
////  QuokkaTodo
////
////  Created by 이유진 on 10/18/23.
////
//
//import Foundation
//import RealmSwift
//
//
//protocol feedLeafRepositoryType: AnyObject {
//    func findFileURL() -> URL?
//    func fetchAll() -> Results<FeedLeaf>
//    func fetchSelectedDateFeedLeaf(date: Date) -> Results<FeedLeaf>
//    func createFeedLeaf(_ item: FeedLeaf)
//}
//
//class FeedLeafRepository: feedLeafRepositoryType{
//    private let realm = try! Realm()
//    func checkSchemaVersion() {
//        do{
//            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
//            print("Schema Version: \(version)")
//        } catch {
//            print(error)
//        }
//    }
//    
//    func findFileURL() -> URL? {
//        let fileURL = realm.configuration.fileURL
//        return fileURL
//    }
//    
//    func fetchAll() -> RealmSwift.Results<FeedLeaf> {
//        let data = realm.objects(FeedLeaf.self).sorted(byKeyPath: "feedLeafTime",ascending: false)
//        return data
//    }
//    
//    func fetchSelectedDateFeedLeaf(date: Date) -> RealmSwift.Results<FeedLeaf> {
//        let dateString = DateFormatter.convertToOnlyDateDBForm(date: date)
//        
//        let result = realm.objects(FeedLeaf.self).where {
//            $0.feedLeafTime.contains(dateString)
//        }
//        return result
//    }
//    
//    func createFeedLeaf(_ item: FeedLeaf) {
//        do {
//            try realm.write {
//                realm.add(item)
//                print("Realm Add Succeed")
//            }
//        } catch {
//            print(error)
//        }
//    }
//  
//}
//
