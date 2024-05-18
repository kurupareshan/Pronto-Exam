//
//  GameModel.swift
//  GridGame
//
//  Created by Kuru on 2024-05-18.
//

import Foundation

struct GameModel {
    var cells = Int()
    var moves = Int()
    var timeDifference = Double()
    var endTime = String()
}

extension GameModel {
    var movesPerCell: Double {
        return Double(moves) / Double(cells)
    }
    
    var timePerCell: Double {
        return timeDifference / Double(cells)
    }
    
    var weightedScore: Double {
        let moveWeight = 0.5
        let timeWeight = 0.5
        return (movesPerCell * moveWeight) + (timePerCell * timeWeight)
    }
}
