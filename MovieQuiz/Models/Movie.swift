//
//  Movie.swift
//  MovieQuiz
//
//  Created by Andrey Nikolaev on 20.01.2023.
//

import Foundation



 struct Movie: Codable {
    let id: String
    let rank: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let crew: String
    let runtimeMins: Int
    let imDbRating: String
    let imDbRatingCount: String
}

