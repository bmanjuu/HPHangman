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
    dynamic var wonGameStatus: Bool = false
    
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
    
    init(player: User, wonGameStatus: Bool, words: String, chosenWord: String, concealedWord: String, guessesSoFar: String, maxIncorrectGuesses: Int, incorrectGuessCount: Int) {
        super.init()
        self.player = player
        self.wonGameStatus = wonGameStatus
        self.words = words
        self.chosenWord = chosenWord
        self.concealedWord = concealedWord
        self.guessesSoFar = guessesSoFar
        self.maxIncorrectGuesses = maxIncorrectGuesses
        self.incorrectGuessCount = incorrectGuessCount
    }
    
}

// MARK: - Preparing to Start Game
extension Game {
    func populateWordsInStore() {
        wordListAPIClient.retrieveWords { (responseWords, nil) in
            print("retrieved all words from API")
            DispatchQueue.main.async {
                try! Realm().write {
                    self.words = responseWords
                }
            }
            
        }
    }
    
    func retrieveRandomWord() {
        
        let wordsArray = words.components(separatedBy: "\n")
        var randomWord = ""
        
        repeat {
            print("random word: \(randomWord), count: \(randomWord.characters.count)")
            let randomIndex = Int(arc4random_uniform(UInt32(wordsArray.count-1)))
            randomWord = wordsArray[randomIndex].uppercased()
        } while randomWord.characters.count < 3 || randomWord.characters.count > 8 || randomWord.contains(" ")
        
        try! Realm().write {
            chosenWord = randomWord
            concealedWord = String(repeating: "___  ", count: chosenWord.characters.count)
        }
        
    }
}



// MARK: - Helper Computed Properties
extension Game {
    
    var galleonsEarned: Int {
        return (6-incorrectGuessCount) * 3
    }
    
    var sicklesEarned: Int {
        return (6-incorrectGuessCount) * 5
    }
    
    var knutsEarned: Int {
        return (6-incorrectGuessCount) * 7
    }

}

// MARK: - Game Logic Helper Functions 
extension Game {
    
    func isValidInput(_ input: String, from viewController: UIViewController) -> Bool {
        
        let validLetters = CharacterSet.letters
        let userInput = input.replacingOccurrences(of: " ", with: "").uppercased()
        
        if input.characters.count == 0 || (userInput.trimmingCharacters(in: validLetters) != "") {
            viewController.present(HangmanAlerts.invalidGuess(), animated: true, completion: nil)
            return false
        }
        
        //check that input is only 1 letter or a guess for the whole word
        if userInput.characters.count == 1 || userInput.characters.count == chosenWord.characters.count {
            if guessesSoFar.contains(userInput) || concealedWord.contains(userInput) {
                print("guessed \(userInput) already")
                viewController.present(HangmanAlerts.duplicateGuess(), animated: true, completion: nil)
                return false
            } else {
                return true
            }
        } else {
            print("guess should only be 1 letter or for the whole word. please type in your guess again")
            viewController.present(HangmanAlerts.invalidGuess(), animated: true, completion: nil)
            return false
        }
        return false
    }
    
    func hasSufficientFunds() -> Bool {
        print("checking for sufficient funds")
        
        let price = ["galleons": 10,
                     "sickles": 20,
                     "knuts": 30]
        
        let userGringottsAccount = player!.gringottsAccount!
        var currentUserBalance = ["galleons" : userGringottsAccount.galleons,
                                  "sickles" : userGringottsAccount.sickles,
                                  "knuts" : userGringottsAccount.knuts]
        
        if currentUserBalance["galleons"]! >= price["galleons"]! &&
            currentUserBalance["sickles"]! >= price["sickles"]! &&
            currentUserBalance["knuts"]! >= price["knuts"]! {
            
            try! Realm().write {
                userGringottsAccount.galleons -= price["galleons"]!
                userGringottsAccount.sickles -= price["sickles"]!
                userGringottsAccount.knuts -= price["knuts"]!
            }
            return true
        }
        return false
    }

    
    func revealRandomLetter() {
        print("called reveal random letter")
        
        let chosenWordArray = Array(chosenWord.characters)
        var concealedWordArray = concealedWord.components(separatedBy: "  ")
        
        let numberOfLettersLeft = concealedWordArray.filter({ $0.contains("___") }).count
        print("\(numberOfLettersLeft) letters left to reveal")
        
        if numberOfLettersLeft == 1 {
            print("revealing last letter")
            let remainingIndexOfLetter = Int(concealedWordArray.index(of: "___")!)
            concealedWordArray[remainingIndexOfLetter] = "\(chosenWordArray[remainingIndexOfLetter])"
            
            wonGame()
            return
            
        } else {
            var randomIndex = Int(arc4random_uniform(UInt32(chosenWordArray.count-1)))
            
            while concealedWordArray[randomIndex] != ("___") {
                randomIndex = Int(arc4random_uniform(UInt32(chosenWordArray.count-1)))
            }
            // need account for when chosen letter has multiple occurrences
            
            concealedWordArray[randomIndex] = "\(chosenWordArray[randomIndex])"
            print("concealed word array will be updated to: \(concealedWordArray.joined(separator: "  "))")
            updateConcealedWord(to: concealedWordArray.joined(separator: "  "))
        }
    }

    
    func updateConcealedWord(to word: String)  {
        try! Realm().write {
            concealedWord = word
        }
    }
    
}



// MARK: - Game Logic
extension Game {
    
    func playGame(with userInput: String) {
        
        let userGuess = userInput.uppercased()
        print("user guess modified: \(userGuess)")
        
        if userGuess == chosenWord {
            wonGame()
        } else if chosenWord.contains(userGuess) {
          correctGuess(userGuess: userGuess)
        } else {
           incorrectGuess(userGuess: userGuess)
        }
    }
    
    func correctGuess(userGuess: String) {
        var concealedWordArray = concealedWord.components(separatedBy: "  ") //there are 2 spaces between each underscore
        
        // check if input letter matches letters in secretWord
        for (index, letter) in chosenWord.characters.enumerated() {
            if String(letter) == userGuess {
                concealedWordArray[index] = "\(letter)"
            }
        }
        
        updateConcealedWord(to: concealedWordArray.joined(separator: "  "))
        
        //check to see if there are any underscores left
        if !concealedWordArray.contains("___") {
            wonGame()
        }
        
    }

    
    func incorrectGuess(userGuess: String) {
        
        try! Realm().write {
            incorrectGuessCount += 1
            guessesSoFar.append("\(userGuess) ")
        }
        
        if incorrectGuessCount == 6 {
            lostGame()
        }
        
    }
    
    func wonGame() {
        
        let playerAccount = player!.gringottsAccount!
        
        try! Realm().write {
            wonGameStatus = true
            concealedWord = chosenWord
            playerAccount.galleons += galleonsEarned
            playerAccount.sickles += sicklesEarned
            playerAccount.knuts += knutsEarned
        }
    }
    
    func lostGame() {
        
        try! Realm().write {
            concealedWord = chosenWord
        }
        
    }

}
