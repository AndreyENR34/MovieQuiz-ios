
import UIKit

final class MovieQuizViewController: UIViewController {
    
    
    // MARK: - Lifecycle
    
 
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    
    
    
    @IBOutlet private weak var noButton: UIButton!
    
    
    @IBOutlet private weak var yesButton: UIButton!
    
        
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
  private var currentQuestionIndex: Int = 0
  
    private var correctAnswers: Int = 0
    private var button : String = ""
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer:true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    
        
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel (
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
            
    }
    
    private func show(quizresult: QuizResultsViewModel) {
        // создаем объекты всплывающего окна
        let alert = UIAlertController(title: quizresult.title,
                                      message: quizresult.text,
                                      preferredStyle: .alert)
        
        // создаем для алерта кнопки с действиями
        let action = UIAlertAction(title: "сыграть еще раз", style:  .default, handler: { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.show(quiz: self.convert(model: self.questions[self.currentQuestionIndex]))
        })
        
        // добавляем в алерт кнопки
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        //noButton.layer.masksToBounds = true
        //noButton.layer.borderWidth = 8
        
        if isCorrect == true {
            correctAnswers += 1
        }
        
        if  button == "no" && isCorrect == true {
            imageView.layer.borderColor = UIColor.green.cgColor
            
        }
        if button == "no" && isCorrect == false {imageView.layer.borderColor = UIColor.red.cgColor}
        
        if  button == "yes" && isCorrect == true {
            imageView.layer.borderColor = UIColor.green.cgColor
            
        }
        if  button == "yes" && isCorrect == false {imageView.layer.borderColor = UIColor.red.cgColor }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
  
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let viewModel = QuizResultsViewModel(
                title: "Раунд окончен",
                text: "Ваш результат: \(correctAnswers) из 10",
                buttonText: "сыграть еще раз")
            
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.borderColor = UIColor.black.cgColor
            show(quizresult: viewModel)
        } else {
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.borderColor = UIColor.black.cgColor
            currentQuestionIndex += 1
            show(quiz: convert(model: questions[currentQuestionIndex]) )
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion) )
    }
    
  
    
    @IBAction private func  noButtonClicked(_ sender: UIButton) {
        button = "no"
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == questions[currentQuestionIndex].correctAnswer)
        
    }
    
        @IBAction private func  yesButtonClicked(_ sender: UIButton) {
        button = "yes"
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == questions[currentQuestionIndex].correctAnswer)  }
    
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
