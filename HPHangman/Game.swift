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
    
    dynamic var aurorMode: Bool = false
    
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
            WordListAPIClient.retrieveWords(level: i) { (responseWords, nil) in
                if responseWords.isEmpty && i == 1 {
                    //if responseWords is empty, then the user is not connected to the internet and we will be using backup words instead
                    DispatchQueue.main.async {
                        try! Realm().write {
                            self.words.append(self.backupWords)
                            //backup words need to be appended instead of being assigned to the words property because it overwrites the addition of auror words, which occurs first due to the asynchronous nature of the API call
                        }
                    }
                } else if !responseWords.isEmpty {
                    //instead of just an else statement, we need a condition to confirm that responseWords is not empty because when we are using backup words and i>1, responseWords will still be empty but it will not satisfy the conditions of the if statement above
                    DispatchQueue.main.async {
                        try! Realm().write {
                            self.words.append("LEVEL \(i): \(responseWords)") //persist all words onto realm as one large string, as before but with something indicating that the words belong to a certain difficulty level. So upon retrieving words, maybe one can search for "LEVEL __"
                            print("words for difficulty \(i)")
                        }
                    }
                }
            }
        }
        try! Realm().write {
            words.append(aurorModeWords)
        }
        self.finishedPopulatingWordsForGame = true //this is not persisted in realm so it does not need to be in the write statement. it can also only be true after calling the API 10 times, so it needs to be outside the for loop
    }
    
    func retrieveRandomWord(currentLevel: Int) {
        print("words at level \(currentLevel): \(self.wordsByLevel[currentLevel])")
        
        var wordsAtCurrentLevel = self.wordsByLevel[currentLevel]
        //since the first object of this array is an empty string, we can just index the array by currentLevel and not currentLevel-1
        
        //still need to remove the level number. determine offset by length of currentLevel string (1 or 2 characters) + length of colon and space after (2 characters)
        let offsetLength = String(currentLevel).characters.count + 2
        let stringRange = wordsAtCurrentLevel.index(wordsAtCurrentLevel.startIndex, offsetBy: offsetLength)..<wordsAtCurrentLevel.endIndex
        wordsAtCurrentLevel = wordsAtCurrentLevel.substring(with: stringRange)
        print("WORDS AT CURRENT LEVEL: \(wordsAtCurrentLevel)")
        
        let wordsArray = wordsAtCurrentLevel.components(separatedBy: "\n")
        print("WORDS ARRAY: \(wordsArray)")
        var randomWord = ""
        var randomPhrase = [String]()
        
        repeat {
            print("random word: \(randomWord), count: \(randomWord.characters.count)")
            let randomIndex = Int(arc4random_uniform(UInt32(wordsArray.count-1)))
            randomWord = wordsArray[randomIndex].uppercased()
        } while randomWord.characters.count < 3 || randomWord.characters.count > (self.currentLevel + 7)
        
        
        //if randomWord is a phrase (it contains a " "), separate the word based on this space first, then format it to look like a concealedWord, then join them again with " " before writing it to Realm
        print("RANDOM WORD: \(randomWord)")
        if randomWord.contains(" ") {
            let randomWordArray = randomWord.components(separatedBy: " ")
            print("WORD PHRASE ARRAY: \(randomWordArray)")
            for word in randomWordArray {
                randomPhrase.append(String(repeating: "___  ", count: word.characters.count))
            }
        }
        
        print("PHRASE: \(randomPhrase)")
        try! Realm().write {
            chosenWord = randomWord.uppercased()
            if randomPhrase.isEmpty {
                concealedWord = String(repeating: "___  ", count: chosenWord.characters.count)
            } else {
                concealedWord = randomPhrase.joined(separator: "    ")
            }
        }
        print("CONCEALED WORD: \(concealedWord)")
        print("THE CHOSEN ONE --> \(chosenWord) for level: \(currentLevel)")
        
    }
}



// MARK: - Helper Computed Properties
extension Game {
    
    var galleonsEarned: Int {
        if currentLevel > 10 {
            return 50 // 20 + max potential earnings
        }
        return (6-incorrectGuessCount) * 5
    }
    
    var sicklesEarned: Int {
        if currentLevel > 10 {
            return 80
        }
        return (6-incorrectGuessCount) * 10
    }
    
    var knutsEarned: Int {
        if currentLevel > 10 {
            return 110
        }
        return (6-incorrectGuessCount) * 15
    }
    
    var aurorModeWords: String {
        //here, I am preserving the format of words similar to how they would have been if they were returned from the API
        return "LEVEL 11: expecto patronumLEVEL 12: arresto momentum\nimpedimenta\nvipera evanesca\nvulnera sanentur\nconfringoLEVEL 13: expelliarmus\nprotego\nstupefy\nreducto\nrelashio\nexpulso\nsectumsempra"
    }
    
    var wordsByLevel: [String] {
        
        let levels = words.components(separatedBy: "LEVEL ")
        return levels.sorted {
            $0.compare($1, options: .numeric) == .orderedAscending
        }

        //made a computed property that returns an array of strings separated based on difficulty level. since words are being retrieved and populated in this array asynchronously, need to sort it first!! since the numerical indications of each level are still present, the elements of the array will be sorted in this way. 
        //the first object of this array will always be an empty string b/c words starts with 'LEVEL'
    }
    
    var backupWords: String {
        return WordListAPIClient.useBackupWords()
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
        //let userInput = input.replacingOccurrences(of: " ", with: "").uppercased()
        
        if input.isEmpty || (input.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: validLetters) != "") {
            viewController.present(HangmanAlerts.invalidGuess(), animated: true, completion: nil)
            return false
        }
        
        //check that input is only 1 letter or a guess for the whole word
        if input.characters.count == 1 || input.characters.count == chosenWord.characters.count {
            if guessesSoFar.contains(input) || concealedWord.contains(input) {
                print("guessed \(input) already")
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
            concealedWord = word.replacingOccurrences(of: "+", with: "    ")
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
        var phrase = ""
        var concealedWordArray = [String]()
        
        if concealedWord.contains("    ") {
            phrase = concealedWord.replacingOccurrences(of: "    ", with: "+")
            concealedWordArray = phrase.components(separatedBy: "  ")
        } else {
            concealedWordArray = concealedWord.components(separatedBy: "  ")
        }
        //there are 2 spaces between each underscore
        
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
            if currentLevel < 14 { // the 14th level is to account for when a user wins a level 13 game
                currentLevel += 1
            }
            
            if currentLevel > 10 {
                aurorMode = true
            } else {
                aurorMode = false
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
