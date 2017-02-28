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
    dynamic var currentLevel: Int = 1
    
    dynamic var words: String = ""
    dynamic var wordsLvl1: String = ""
    dynamic var wordsLvl2: String = ""
    dynamic var wordsLvl3: String = ""
    dynamic var wordsLvl4: String = ""
    dynamic var wordsLvl5: String = ""
    dynamic var wordsLvl6: String = ""
    dynamic var wordsLvl7: String = ""
    dynamic var wordsLvl8: String = ""
    dynamic var wordsLvl9: String = ""
    dynamic var wordsLvl10: String = ""
    
    var wordsByLevel = [String]()
    //plan: each element of this array will hold a collection of strings that represent words of each difficulty level. as words are being populated in this array, they will also be persisted into realm by appending it to the words property. the array itself will not be persisted b/c realm does not save arrays
    
    dynamic var chosenWord: String = ""
    dynamic var concealedWord: String = ""
    dynamic var guessesSoFar: String = ""
    dynamic var maxIncorrectGuesses: Int = 6
    dynamic var incorrectGuessCount: Int = 0
    
    var finishedPopulatingWordsForGame: Bool = false //does not need to be persisted in realm
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    init(player: User, wonGameStatus: Bool, words: String, chosenWord: String, concealedWord: String, guessesSoFar: String, maxIncorrectGuesses: Int, incorrectGuessCount: Int, currentLevel: Int) {
        super.init()
        self.player = player
        self.wonGameStatus = wonGameStatus
        self.words = words
        self.chosenWord = chosenWord
        self.concealedWord = concealedWord
        self.guessesSoFar = guessesSoFar
        self.maxIncorrectGuesses = maxIncorrectGuesses
        self.incorrectGuessCount = incorrectGuessCount
        self.currentLevel = currentLevel
    }
    
}

// MARK: - Preparing to Start Game
extension Game {
    
    func populateWordsInStore() {
        
        for i in 1...10 {
            WordListAPIClient.retrieveWords(currentLevel: i) { (words, nil) in
                self.wordsByLevel.append(words)
                //each group of words will correspond with each difficulty level 
                
                DispatchQueue.main.async {
                    try! Realm().write {
                        self.words.append(words) //persist all words onto realm as one large string, as before
                        
                        //switch statement here
//                        switch i {
//                        case 1:
//                            self.wordsLvl1 = words
//                        case 2:
//                            self.wordsLvl2 = words
//                        case 3:
//                            self.wordsLvl3 = words
//                        case 4:
//                            self.wordsLvl4 = words
//                        case 5:
//                            self.wordsLvl5 = words
//                        case 6:
//                            self.wordsLvl6 = words
//                        case 7:
//                            self.wordsLvl7 = words
//                        case 8:
//                            self.wordsLvl8 = words
//                        case 9:
//                            self.wordsLvl9 = words
//                        case 10:
//                            self.wordsLvl10 = words
//                        default:
//                            self.words = words
//                            
//                        }
                        print("words for difficulty \(i)")
                        self.finishedPopulatingWordsForGame = true
        
                    }
                }
            }
            
        }
        
//        WordListAPIClient.retrieveWords { (responseWords, nil) in
//            print("retrieved all words from API")
//            DispatchQueue.main.async {
//                //need to be on the main thread to write
//                try! Realm().write {
//                    self.words = responseWords
//                    self.finishedPopulatingWordsForGame = true
//                }
//            }
//        }
    }
    
    func retrieveRandomWord(currentLevel: Int) {
        
        let wordsAtCurrentLevel = wordsByLevel[currentLevel+1]
        
//        switch self.currentLevel {
//        case 1:
//            tempWords = self.wordsLvl1
//        case 2:
//            tempWords = self.wordsLvl2
//        case 3:
//            tempWords = self.wordsLvl3
//        case 4:
//            tempWords = self.wordsLvl4
//        case 5:
//            tempWords = self.wordsLvl5
//        case 6:
//            tempWords = self.wordsLvl6
//        case 7:
//            tempWords = self.wordsLvl7
//        case 8:
//            tempWords = self.wordsLvl8
//        case 9:
//            tempWords = self.wordsLvl9
//        case 10:
//            tempWords = self.wordsLvl10
//        default:
//            print(" blah ")
//            
//        }

        
        let wordsArray = wordsAtCurrentLevel.components(separatedBy: "\n")
        var randomWord = ""
        
        repeat {
            print("random word: \(randomWord), count: \(randomWord.characters.count)")
            let randomIndex = Int(arc4random_uniform(UInt32(wordsArray.count-1)))
            randomWord = wordsArray[randomIndex].uppercased()
        } while randomWord.characters.count < 3 || randomWord.characters.count > 8 || randomWord.contains(" ")
        
        try! Realm().write {
            chosenWord = randomWord.uppercased()
            concealedWord = String(repeating: "___  ", count: chosenWord.characters.count)
        }
        
        print("THE CHOSEN ONE --> \(chosenWord) for level: \(currentLevel)")
        
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
            if String(letter) == userGuess.uppercased() {
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
            if currentLevel < 10 {
                currentLevel += 1
            }
        }
    }
    
    func lostGame() {
        
        try! Realm().write {
            concealedWord = chosenWord
            if currentLevel >= 2 {
                currentLevel -= 1
            }
        }
        
    }

}
