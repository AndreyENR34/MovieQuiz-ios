//
//  File.swift
//  MovieQuiz
//
//  Created by Andrey Nikolaev on 16.01.2023.
//

import Foundation
import UIKit

protocol AlertDelegate: AnyObject {
    func present( _ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? )
}
