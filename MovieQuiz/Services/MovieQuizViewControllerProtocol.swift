//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Andrey Nikolaev on 14.02.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quizresult: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func viewBlackFrame()
    
    func showNetworkError(message: String)
}
