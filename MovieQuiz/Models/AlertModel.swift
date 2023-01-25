//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Andrey Nikolaev on 15.01.2023.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)
}


