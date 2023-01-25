
import UIKit
import Foundation

final class MovieQuizViewController: UIViewController,QuestionFactoryDelegate, AlertDelegate {
    
  
    
    
    // MARK: - Lifecycle
    
    
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    
    
    
    @IBOutlet private weak var noButton: UIButton!
    
    
    @IBOutlet private weak var yesButton: UIButton!
    
    
    private var currentQuestionIndex: Int = 0
    
    private var correctAnswers: Int = 0
    
    private var button : String = ""
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    
    private var statisticService = StatisticServiceImplementation()
    private var totalCorrectAnswer: Double = 0
    private var curentAccuracy: Double = 0
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel (
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
    }
   
    private func show(quizresult: QuizResultsViewModel) {
        // создаем модель всплывающего окна
        let alertModel = AlertModel(title: quizresult.title,
                                      message: quizresult.text,
                                    buttonText: quizresult.buttonText, completion: {
        
                  [weak self]  in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
           })
        
             self.alertPresenter?.showAlert(model: alertModel)
       
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            correctAnswers += 1
        }
        
        if  button == "no" && isCorrect {
            noButton.isEnabled = false
            yesButton.isEnabled = false
            imageView.layer.borderColor = UIColor(named: "ypGreen")!.cgColor
            
        }
        if button == "no" && isCorrect == false {imageView.layer.borderColor = UIColor(named: "ypRed")!.cgColor}
        noButton.isEnabled = false
        yesButton.isEnabled = false
        if  button == "yes" && isCorrect {
            noButton.isEnabled = false
            yesButton.isEnabled = false
            imageView.layer.borderColor = UIColor(named: "ypGreen")!.cgColor
            
        }
        if  button == "yes" && isCorrect == false {imageView.layer.borderColor = UIColor(named: "ypRed")!.cgColor }
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            
            statisticService.gamesCount += 1
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            curentAccuracy = Double(correctAnswers)/Double(questionsAmount)
             totalCorrectAnswer = (Double(statisticService.totalAccuracy)*Double(questionsAmount)*Double(statisticService.gamesCount-1)) + Double(correctAnswers)
            print(totalCorrectAnswer)
            if statisticService.gamesCount == 1 {
                statisticService.totalAccuracy = curentAccuracy
            } else {
                statisticService.totalAccuracy = Double(totalCorrectAnswer)/Double(questionsAmount*statisticService.gamesCount)}
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questionsAmount) \n Количество сыграных квизов: \(statisticService.gamesCount) \n Рекорд: \(statisticService.bestGame.correct)/\(questionsAmount) (\(statisticService.bestGame.date.dateTimeString))\n Средняя точность: \(String(format: "%.2f",statisticService.totalAccuracy*100 ))% ",
                buttonText: "сыграть еще раз")
            
            imageView.layer.borderColor = UIColor(named: "ypBlack")!.cgColor
            imageView.layer.borderColor = UIColor(named: "ypBlack")!.cgColor
            
            
          
            
            show(quizresult: viewModel)
            noButton.isEnabled = true
            yesButton.isEnabled = true
        } else {
            imageView.layer.borderColor = UIColor(named: "ypBlack")!.cgColor
            imageView.layer.borderColor = UIColor(named: "ypBlack")!.cgColor
            currentQuestionIndex += 1
            
            self.questionFactory?.requestNextQuestion()
            
            noButton.isEnabled = true
            yesButton.isEnabled = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
        let fileName = "top250MoviesIMDB.json"
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsURL)
        documentsURL.appendPathComponent(fileName)
        documentsURL.path
        let jsonString = (try? String(contentsOf: documentsURL))
        guard let data = jsonString?.data(using: .utf8) else { return }
        try? print(String(contentsOf: documentsURL))
        
        do {
            let movie = try? JSONDecoder().decode(Movie.self, from: data)
        } catch {
            print("Failed to parse: \(error.localizedDescription)")
        }
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        questionFactory?.requestNextQuestion()
    }
    
    
    @IBAction private func  noButtonClicked(_ sender: UIButton) {
        button = "no"
        let givenAnswer = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func  yesButtonClicked(_ sender: UIButton) {
        button = "yes"
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    
    // MARK: -QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
}
/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
