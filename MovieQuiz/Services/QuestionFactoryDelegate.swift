//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Andrey Nikolaev on 15.01.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}

