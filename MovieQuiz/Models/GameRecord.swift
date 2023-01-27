//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Andrey Nikolaev on 22.01.2023.
//

import Foundation

struct GameRecord: Codable {
    
    let correct: Int
    let total: Int
    let date: Date
    
}
