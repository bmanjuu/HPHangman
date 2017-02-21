//
//  Game.swift
//  HPHangman
//
//  Created by Betty Fung on 2/17/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Game: Object {
    
    dynamic var player: User?
    dynamic var wonGame: Bool = false
    
    dynamic var words: String = ""
    dynamic var chosenWord: String = ""
    dynamic var concealedWord: String = ""
    dynamic var guessesSoFar: String = ""
    dynamic var maxIncorrectGuesses: Int = 6
    dynamic var incorrectGuessCount: Int = 0
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    init(player: User, wonGame: Bool, words: String, chosenWord: String, concealedWord: String, guessesSoFar: String, maxIncorrectGuesses: Int, incorrectGuessCount: Int) {
        super.init()
        self.player = player
        self.wonGame = wonGame
        self.words = words
        self.chosenWord = chosenWord
        self.concealedWord = concealedWord
        self.guessesSoFar = guessesSoFar
        self.maxIncorrectGuesses = maxIncorrectGuesses
        self.incorrectGuessCount = incorrectGuessCount
    }
    
}

// MARK: - Helper Computed Properties
//extension Game {
//    
//    dynamic var galleonsEarned: Int {
//        
//        return (incorrectGuessCount + 5) * 5
//        
//        switch incorrectGuessCount {
//        case 0:
//            return 30
//        case 1:
//            return 25
//        case 2:
//            return 20
//        case 3:
//            return 15
//        case 4:
//            return 10
//        case 5:
//            return 5
//        default:
//            return 100
//        }
//    }
//    
//}

//// MARK: - Game Logic
//extension Game {
//    
//    func playGame(with userInput: String) {
//        
//        let userGuess = userInput.uppercased()
//        print("user guess modified: \(userGuess)")
//        
//        if userGuess == chosenWord {
//            gameWon()
//        } else if chosenWord.contains(userGuess) {
//          //  correctGuess(userGuess: userGuess)
//        } else {
//           // incorrectGuess(userGuess: userGuess)
//        }
//    }
//    
//    func gameWon() {
//        let playerAccount = player!.gringottsAccount!
//        var winningsEarned: [String : Int] = [:]
//        
//        switch incorrectGuessCount {
//        case 0:
//            winningsEarned["galleons"] = 30
//            winningsEarned["sickles"] = 25
//            winningsEarned["knuts"] = 50
//        case 1:
//            winningsEarned["galleons"] = 25
//            winningsEarned["sickles"] = 20
//            winningsEarned["knuts"] = 45
//        case 2:
//            winningsEarned["galleons"] = 20
//            winningsEarned["sickles"] = 15
//            winningsEarned["knuts"] = 40
//        case 3:
//            winningsEarned["galleons"] = 15
//            winningsEarned["sickles"] = 10
//            winningsEarned["knuts"] = 35
//        case 4:
//            winningsEarned["galleons"] = 10
//            winningsEarned["sickles"] = 5
//            winningsEarned["knuts"] = 30
//        case 5:
//            winningsEarned["galleons"] = 5
//            winningsEarned["sickles"] = 5
//            winningsEarned["knuts"] = 25
//        default:
//            print("error with distributing winnings")
//        }
//        
//        try! Realm().write {
//            
//            wonGame = true
//            concealedWord = chosenWord
//            playerAccount.galleons += galleonsEarned
//            
//        }
//        
////        //try! realm.write {
////            
////            playerAccount.galleons += winningsEarned["galleons"]!
////            playerAccount.sickles += winningsEarned["sickles"]!
////            playerAccount.knuts += winningsEarned["knuts"]!
////        // }
//    }

//}
