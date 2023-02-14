
import UIKit
import Foundation

final class MovieQuizViewController: UIViewController,MovieQuizViewControllerProtocol, AlertDelegate {
    
    
    
    
    
    // MARK: - Lifecycle
    
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private  weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    
    @IBOutlet  weak var noButton: UIButton!
    
    @IBOutlet  weak var yesButton: UIButton!
    
    
    
    
    private var button : String = ""
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol?
    
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let viewModel = ErrorNetworkViewModel(title: "Ошибка", buttonText: "Попробовать еще раз")
        
        let alertModel = AlertModel(title: viewModel.title ,
                                    message: message,
                                    buttonText: viewModel.buttonText) { [weak self]  in
            guard let self = self else { return }
            
            
            self.presenter.restartGame()
            
        }
        
        alertPresenter?.showAlert( model: alertModel)
        
    }
    
    func viewBlackFrame() {
        imageView.layer.borderColor = UIColor(named: "ypBlack")!.cgColor
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    func show(quizresult: QuizResultsViewModel) {
        
        let alertModel = AlertModel(title: quizresult.title,
                                    message: quizresult.text,
                                    buttonText: quizresult.buttonText, completion: {
            
            [weak self]  in
            guard let self = self else {return}
            self.presenter.restartGame()
            
            
        })
        
        self.alertPresenter?.showAlert(model: alertModel)
        
    }
    
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
    
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
    
    if  button == "no" && isCorrectAnswer {
        presenter.ButtonIsDisable()
        imageView.layer.borderColor = UIColor(named: "ypGreen")!.cgColor
        
    }
    if button == "no" && isCorrectAnswer == false {imageView.layer.borderColor = UIColor(named: "ypRed")!.cgColor}
            presenter.ButtonIsDisable()
               if  button == "yes" && isCorrectAnswer {
                   presenter.ButtonIsDisable()
        imageView.layer.borderColor = UIColor(named: "ypGreen")!.cgColor
        
    }
    if  button == "yes" && isCorrectAnswer == false {imageView.layer.borderColor = UIColor(named: "ypRed")!.cgColor }
        presenter.ButtonIsDisable()
}
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    
    @IBAction private func  noButtonClicked(_ sender: UIButton) {
        button = "no"
            presenter.noButtonClicked()
    }
    
    @IBAction private func  yesButtonClicked(_ sender: UIButton) {
        button = "yes"
        presenter.yesButtonClicked()
    }
}
