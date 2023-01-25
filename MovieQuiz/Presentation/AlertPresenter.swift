//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Andrey Nikolaev on 15.01.2023.
//

import Foundation
import UIKit



class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertDelegate?
    init( delegate: AlertDelegate? ) {
        self.delegate = delegate
    }
    func showAlert(model: AlertModel) {
        // создаем объекты всплывающего окна
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        // создаем для алерта кнопки с действиями
        let action = UIAlertAction(title: model.buttonText, style:  .default){_ in model.completion()
        }
        
        // добавляем в алерт кнопки
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
  }
