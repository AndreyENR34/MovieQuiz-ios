//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Andrey Nikolaev on 10.02.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // Это специальная настройка для тестов: если один тест не прошел,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
        
    }
    
    func testYesButton() {
        
        sleep(5)
        
        let indexLabel = app.staticTexts["Index"]
        
        
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertEqual(indexLabel.label, "1/10")
       // XCTAssertTrue(firstPoster.exists) // проверяем, появился ли первый постер
        
        app.buttons["Yes"].tap() // находим кнопку "Да"  и нажимаем ей
        
        sleep(3)
        
        let secondPoster = app.images["Poster"] // еще наход постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
       // XCTAssertTrue(secondPoster.exists) // проверяем,  появился ли второй постер
        
        XCTAssertEqual(indexLabel.label, "2/10")
        //  XCTAssertFalse(firstPosterData == secondPosterData) // проверяем, что постеры разные
        XCTAssertNotEqual(firstPosterData, secondPosterData)  // проверяем, что постеры разные
    }
   
    func testNoButton() {
        
        sleep(5)
        
        let indexLabel = app.staticTexts["Index"]
        
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertEqual(indexLabel.label, "1/10")
       // XCTAssertTrue(firstPoster.exists) // проверяем, появился ли первый постер
        
        app.buttons["No"].tap() // находим кнопку "Нет"  и нажимаем ей
        
        sleep(3)
        
        let secondPoster = app.images["Poster"] // еще наход постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
       // XCTAssertTrue(secondPoster.exists) // проверяем,  появился ли второй постер
        
        XCTAssertEqual(indexLabel.label, "2/10")
        //  XCTAssertFalse(firstPosterData == secondPosterData) // проверяем, что постеры разные
        XCTAssertNotEqual(firstPosterData, secondPosterData)  // проверяем, что постеры разные
    }
   
    func testShowAlert() {
        var countGame = 1
        //let indexLabel = app.staticTexts["Index"]
        let alert = app.alerts["Этот раунд окончен!"]
        
        sleep(5)
        
        
        for i in 1...10 {
            app.buttons["No"].tap()
            countGame += i
            sleep(1)
        }

        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "сыграть еще раз")
            
        
    }
    
    

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
