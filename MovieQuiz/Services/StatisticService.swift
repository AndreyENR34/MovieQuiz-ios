

//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Andrey Nikolaev on 21.01.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
     //userDefaults = UserDefaults.standard
    var totalAccuracy: Double { get }
    var gamesCount: Int { get set}
    var bestGame: GameRecord { get }
}

final class StatisticServiceImplementation: StatisticService {
       
    
    func store(correct count: Int, total amount: Int) {
    
        
        if count > bestGame.correct {
            bestGame = GameRecord(correct: count, total: amount, date: Date())
        }
        
        print(bestGame)
        return
    }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    var totalAccuracy: Double  {
        get{
            let data = UserDefaults.standard.double(forKey: Keys.total.rawValue)
            
            return data
            
        } set {
            guard let name = try? newValue else {
                return
            }
            UserDefaults.standard.set(name, forKey: Keys.total.rawValue)
        }
        
    }
    
    var gamesCount: Int {
           get{
             
                
                let data = UserDefaults.standard.integer(forKey: Keys.gamesCount.rawValue)
                return data
          }
          set {
                let key = Keys.gamesCount.rawValue
                guard let name = try? newValue
                 else  {
                    return
                    
                }
                UserDefaults.standard.set(name, forKey: Keys.gamesCount.rawValue)
            }
        }
        
    var bestGame: GameRecord {
            get{
                
                guard let data = UserDefaults.standard.data(forKey: Keys.bestGame.rawValue),
                      let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                    return.init(correct: 0, total: 0, date: Date())
                }
                return record
            }
            set{
                guard let data = try? JSONEncoder().encode(newValue) else {
                    print ("Невозможно сохранить результат")
                    return
                }
                UserDefaults.standard.set(data, forKey: Keys.bestGame.rawValue)
            }
            
        }
        
    
    }
    

