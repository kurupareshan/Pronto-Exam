//
//  DataManager.swift
//  GridGame
//
//  Created by Kuru on 2024-05-17.
//

import Foundation
import Realm
import RealmSwift

class DataManager {
    
    static let shared = DataManager()
    private let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }
    
    // MARK: - Tasks
    
    func saveData(cells: Int, moves: Int, timeInterval: Double, endTime: String) {
        let newUser = DataModel()
        newUser.cells = cells
        newUser.moves = moves
        newUser.endTime = endTime
        newUser.timeDifference = timeInterval
        do {
            try realm.write {
                realm.add(newUser)
            }
        } catch {
            print("Error saving task: \(error)")
        }
    }
    
    func fetchData() -> Results<DataModel> {
        return realm.objects(DataModel.self)
    }
    
}
