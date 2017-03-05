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
    
    dynamic var words: String = "" //words of varying difficulty levels are being stored in the computed property, wordsByLevel, listed in extension below
    
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
        
        wordsFromAPI: for i in 1...10 {
            
            if wordsByLevel.count == 11 {
                //if words by level already contains 11 elements (an empty string for the first element, and the remaining 10 for each level of words), then we are using backup words and do not need to go through the remaining loops
                print("breaking out of loop b/c using backup words")
                break wordsFromAPI
            }
            
            WordListAPIClient.retrieveWords(level: i) { (words, nil) in
                DispatchQueue.main.async {
                    if words.contains("LEVEL ") {
                        //if words already contains 'LEVEL ', then we are using the backup words
                        try! Realm().write {
                            self.words.append(words)
                        }
                    } else {
                        try! Realm().write {
                            self.words.append("LEVEL \(i): \(words)") //persist all words onto realm as one large string, as before but with something indicating that the words belong to a certain difficulty level. So upon retrieving words, maybe one can search for "LEVEL __"
                            print("words for difficulty \(i)")
                        }
                    }
                }
            }
        }
        self.finishedPopulatingWordsForGame = true //this is not persisted in realm so it does not need to be in the write statement. it can also only be true after calling the API 10 times, so it needs to be outside the for loop
    }
    
    func retrieveRandomWord(currentLevel: Int) {
        print("wordsByLevel: \(self.wordsByLevel)")
        
        var wordsAtCurrentLevel = self.wordsByLevel[currentLevel]
        //since the first object of this array is an empty string, can just index the array by currentLevel and not currentLevel-1
        
        //still need to remove the level number. determine offset by length of currentLevel string (1 or 2 characters) + length of colon and space after (2 characters)
        let offsetLength = String(currentLevel).characters.count + 2
        let stringRange = wordsAtCurrentLevel.index(wordsAtCurrentLevel.startIndex, offsetBy: offsetLength)..<wordsAtCurrentLevel.index(before: wordsAtCurrentLevel.endIndex)
        wordsAtCurrentLevel = wordsAtCurrentLevel.substring(with: stringRange)

        
        let wordsArray = wordsAtCurrentLevel.components(separatedBy: "\n")
        var randomWord = ""
        
        repeat {
            print("random word: \(randomWord), count: \(randomWord.characters.count)")
            let randomIndex = Int(arc4random_uniform(UInt32(wordsArray.count-1)))
            randomWord = wordsArray[randomIndex].uppercased()
        } while randomWord.characters.count < 3 || randomWord.characters.count > (self.currentLevel + 5) || randomWord.contains(" ")
        
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
    
    var wordsByLevel: [String] {
        let levels = words.components(separatedBy: "LEVEL ")
        return levels.sorted {
            $0.compare($1, options: .numeric) == .orderedAscending
        }

        //made a computed property that returns an array of strings separated based on difficulty level. since words are being retrieved and populated in this array asynchronously, need to sort it first!! since the numerical indications of each level are still present, the elements of the array will be sorted in this way. 
        //the first object of this array will always be an empty string b/c words starts with 'LEVEL '
    }
    
    var priceOfLetter: [String:Int] {
        let price = ["galleons": (currentLevel*10),
                     "sickles": (currentLevel*20),
                     "knuts": (currentLevel*30)]
        
        return price
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
        
        let userGringottsAccount = player!.gringottsAccount!
        var currentUserBalance = ["galleons" : userGringottsAccount.galleons,
                                  "sickles" : userGringottsAccount.sickles,
                                  "knuts" : userGringottsAccount.knuts]
        
        if currentUserBalance["galleons"]! >= priceOfLetter["galleons"]! &&
            currentUserBalance["sickles"]! >= priceOfLetter["sickles"]! &&
            currentUserBalance["knuts"]! >= priceOfLetter["knuts"]! {
            
            try! Realm().write {
                userGringottsAccount.galleons -= priceOfLetter["galleons"]!
                userGringottsAccount.sickles -= priceOfLetter["sickles"]!
                userGringottsAccount.knuts -= priceOfLetter["knuts"]!
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
            if currentLevel > 1 {
                currentLevel -= 1
            }
        }
        
    }

}
