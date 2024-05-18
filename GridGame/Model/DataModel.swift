//
//  DataModel.swift
//  GridGame
//
//  Created by Kuru on 2024-05-17.
//

import Foundation

import Foundation
import Realm
import RealmSwift

class DataModel: Object, Codable {
    
    @objc dynamic var cells: Int = 0
    @objc dynamic var moves: Int = 0
    @objc dynamic var timeDifference: Double = 0.0
    @objc dynamic var endTime: String = ""
    
    required override init() {
        super.init()
    }
    
}
