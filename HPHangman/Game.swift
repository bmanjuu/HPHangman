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

// MARK: - Preparing


// MARK: - Helper Computed Properties
extension Game {
    // do not need to persist this in realm b/c only calculating
    var galleonsEarned: Int {
        return (6-incorrectGuessCount) * 5
    }
    
    var sicklesEarned: Int {
        return (6-incorrectGuessCount) * 3
    }
    
    var knutsEarned: Int {
        return (6-incorrectGuessCount) * 5
    }
}

// MARK: - Preparing to Start Game 
extension Game {
    func populateWordsInStore() {
        wordListAPIClient.retrieveWords { (words, nil) in
            print("retrieved all words from API")
        }
    }
    
    func retrieveRandomWord(from words: String) -> String {
        
        let wordsArray = words.components(separatedBy: "\n")
        var randomWord = ""
        
        repeat {
            print("random word: \(randomWord), count: \(randomWord.characters.count)")
            let randomIndex = Int(arc4random_uniform(UInt32(wordsArray.count-1)))
            randomWord = wordsArray[randomIndex].uppercased()
        } while randomWord.characters.count < 3 || randomWord.characters.count > 8 || randomWord.contains(" ")
        
        return randomWord
    }
}



// MARK: - Game Logic
extension Game {
    
    func playGame(with userInput: String) {
        
        let userGuess = userInput.uppercased()
        print("user guess modified: \(userGuess)")
        
        if userGuess == chosenWord {
            gameWon()
        } else if chosenWord.contains(userGuess) {
          //  correctGuess(userGuess: userGuess)
        } else {
           // incorrectGuess(userGuess: userGuess)
        }
    }
    
    func gameWon() {
        
        let playerAccount = player!.gringottsAccount!
        
        try! Realm().write {
            wonGame = true
            concealedWord = chosenWord
            playerAccount.galleons += galleonsEarned
            playerAccount.sickles += sicklesEarned
            playerAccount.knuts += knutsEarned
        }
    }

}
