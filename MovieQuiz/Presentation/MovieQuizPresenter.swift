//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Andrey Nikolaev on 12.02.2023.
//

import Foundation
import UIKit



final class MovieQuizPresenter: QuestionFactoryDelegate {
    
     weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    private var correctAnswers: Int = 0
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex: Int = 0
    let questionsAmount: Int = 10
    private var totalCorrectAnswer: Double = 0
    private var curentAccuracy: Double = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController as? MovieQuizViewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: -QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            
            let message = makeResultsMessage()
           
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: message,
                buttonText: "сыграть еще раз")
            
                viewController?.viewBlackFrame()
                viewController?.show(quizresult: viewModel)
            ButtonIsEnable()
            
        } else {
            viewController?.viewBlackFrame()
            
                switchToNextQuestion()
            
            self.questionFactory?.requestNextQuestion()
            ButtonIsEnable()
                    }
    }
 
    
    func proceedWithAnswer(isCorrect: Bool) {
       
        
            didAnswer(isCorrect: isCorrect)
        
            viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
           
            self.proceedToNextQuestionOrResults()
        }
    }
    
    func makeResultsMessage() -> String {
        
        statisticService.gamesCount += 1
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        curentAccuracy = Double(correctAnswers)/Double(questionsAmount)
        totalCorrectAnswer = (Double(statisticService.totalAccuracy) * Double(questionsAmount) * Double(statisticService.gamesCount-1)) +
        Double(correctAnswers)
        print(totalCorrectAnswer)
        if statisticService.gamesCount == 1 {
            statisticService.totalAccuracy = curentAccuracy
        } else {
            statisticService.totalAccuracy =
            Double(totalCorrectAnswer)/Double(questionsAmount*statisticService.gamesCount)}
        
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let totalPlaysCountLine = "Количество сыграных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(statisticService.bestGame.correct)/\(questionsAmount) (\(statisticService.bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f",statisticService.totalAccuracy*100 ))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")
        
        return resultMessage
    }
        
        
        
        func didRecieveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.show(quiz: viewModel)
            }
        }
        
        
        func didAnswer(isYes: Bool) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = isYes
            
            proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
        
        func yesButtonClicked() {
            didAnswer(isYes: true)
        }
        
        func noButtonClicked() {
            didAnswer(isYes: false)
        }
    
    func ButtonIsEnable() {
        viewController?.noButton.isEnabled = true
        viewController?.yesButton.isEnabled = true
    }
    
    func ButtonIsDisable() {
        viewController?.noButton.isEnabled = false
        viewController?.yesButton.isEnabled = false
    }
    
    
        
        func isLastQuestion () -> Bool {
            currentQuestionIndex == questionsAmount - 1
        }
        
        func didAnswer(isCorrect: Bool) {
            if isCorrect {
                correctAnswers += 1
            }
        }
        
        func restartGame() {
            currentQuestionIndex = 0
            correctAnswers = 0
            questionFactory?.loadData()
            questionFactory?.requestNextQuestion()
            
        }
        
        func switchToNextQuestion() {
            currentQuestionIndex += 1
        }
        
        func convert(model: QuizQuestion) -> QuizStepViewModel {
            QuizStepViewModel(
                image: UIImage(data: model.image) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        }
        
    }

    
