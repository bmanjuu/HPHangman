//
//  HangmanGame.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

struct HangmanGameLogic {
    
    static var game: Results<Game>!
    
    static func retrieveCurrentGame() -> Game {
        let realm = try! Realm()
        let gameResults = realm.objects(Game.self)
        return gameResults[0]
    }
    
    // before game starts 
    static func populateWordsInStore() {
        print("calling API to populate words")
        wordListAPIClient.retrieveWords { (words, nil) in
            print("retrieved all words from API")
        }
    }
    
    static func retrieveRandomWord(from words: String) -> String {
        
        let wordsArray = words.components(separatedBy: "\n")
        var randomWord = ""
        
        repeat {
            print("random word: \(randomWord), count: \(randomWord.characters.count)")
            let randomIndex = Int(arc4random_uniform(UInt32(wordsArray.count-1)))
            randomWord = wordsArray[randomIndex].uppercased()
        } while randomWord.characters.count < 3 || randomWord.characters.count > 8 || randomWord.contains(" ")
        
        return randomWord
    }
    
    
    // during game
    static func isValidInput(_ input: String) -> Bool {
        
        let realm = try! Realm()
        let currentGame = retrieveCurrentGame()
        let chosenWord = currentGame.chosenWord
        let guessesSoFar = currentGame.guessesSoFar
        
        let validLetters = CharacterSet.letters
        let userInput = input.replacingOccurrences(of: " ", with: "") //perhaps just replace one at the end
        
        //check that input only contains letters
        if (userInput.trimmingCharacters(in: validLetters) != "") {
            print("invalid characters in string")
            return false
        }
        
        if userInput.characters.count == 1 || userInput.characters.count == chosenWord.characters.count {
            
            if guessesSoFar.contains(userInput) {
                print("guessed \(userInput) already")
                return false
            } else {
                try! realm.write {
                    currentGame.guessesSoFar.append("\(userInput) ")
                }
                print(currentGame.guessesSoFar)
                return true
            }
            
        } else {
            print("guess should only be 1 letter or for the whole word. please type in your guess again")
            return false
        }
        
    }
    
    static func playGame(with userInput: String) {
        
        let userGuess = userInput.uppercased()
        let chosenWord = retrieveCurrentGame().chosenWord
        print("user guess modified: \(userGuess)")
        
        if userGuess == chosenWord {
            wonGame()
        } else if chosenWord.contains(userGuess) {
            correctGuess(userGuess: userGuess)
        } else {
            incorrectGuess()
        }
    }
    
    static func buyALetter() {
        //cost: 10 sickles
    }
    
    static func incorrectGuess() {
        //update label about incorrect guesses
        let realm = try! Realm()
        let currentGame = retrieveCurrentGame()
        
        try! realm.write {
            currentGame.incorrectGuessCount += 1
        }
        
        if currentGame.incorrectGuessCount == 6 {
            lostGame()
        }
        
    }
    
    static func correctGuess(userGuess: String) {
        //check if guess is a letter or word?
        let chosenWord = retrieveCurrentGame().chosenWord
        let concealedWord = retrieveCurrentGame().concealedWord
        
        var concealedWordArray = concealedWord.components(separatedBy: "  ") //there are 2 spaces between each underscore
        
        // check if input letter matches letters in secretWord
        for (index, letter) in chosenWord.characters.enumerated() {
            if String(letter) == userGuess {
                print("before: \(concealedWordArray)")
                concealedWordArray[index] = "\(letter)"
                print("after: \(concealedWordArray)")
            }
        }
        
        updateConcealedWord(to: concealedWordArray.joined(separator: "  "))
        
        //check to see if there are any underscores left
        if !concealedWordArray.contains("___") {
            print("won game!")
            wonGame()
        }
        
    }
    
    static func updateConcealedWord(to word: String)  {
        
        let realm = try! Realm()
        let currentGame = HangmanGameLogic.retrieveCurrentGame()
        
        try! realm.write {
            currentGame.concealedWord = word
        }
    }
    
    // after game ends
    static func wonGame() {
        print("You've helped Harry defeat Voldemort!")
        
        let realm = try! Realm()
        
        let game = retrieveCurrentGame()
        let numberOfIncorrectGuesses = game.incorrectGuessCount
        let playerAccount = game.player!.gringottsAccount!
        var winningsEarned = ["galleons": 0, "sickles": 0, "knuts": 0]
        //enum for denominations?
        
        switch numberOfIncorrectGuesses {
        case 0:
            winningsEarned["galleons"] = 30
            winningsEarned["sickles"] = 25
            winningsEarned["knuts"] = 50
        case 1:
            winningsEarned["galleons"] = 25
            winningsEarned["sickles"] = 20
            winningsEarned["knuts"] = 45
        case 2:
            winningsEarned["galleons"] = 20
            winningsEarned["sickles"] = 15
            winningsEarned["knuts"] = 40
        case 3:
            winningsEarned["galleons"] = 15
            winningsEarned["sickles"] = 10
            winningsEarned["knuts"] = 35
        case 4:
            winningsEarned["galleons"] = 10
            winningsEarned["sickles"] = 5
            winningsEarned["knuts"] = 30
        case 5:
            winningsEarned["galleons"] = 5
            winningsEarned["sickles"] = 5
            winningsEarned["knuts"] = 25
        default:
            print("error with distributing winnings")
        }
        
        try! realm.write {
            game.wonGame = true
            game.concealedWord = game.chosenWord
            
            playerAccount.galleons += winningsEarned["galleons"]!
            playerAccount.sickles += winningsEarned["sickles"]!
            playerAccount.knuts += winningsEarned["knuts"]!
        }
        print("galleons: \(playerAccount.galleons), sickles: \(playerAccount.sickles), knuts: \(playerAccount.knuts)")
        
        print("going to new vc here?")
        //go to new vc
        //notification for congratulations and to play again
        //add sounds here?  
        
    }
    
    static func lostGame() {
        print("Oh no! Harry was discovered by Voldemort!")
        let realm = try! Realm()
        let game = retrieveCurrentGame()
        
        try! realm.write {
            game.concealedWord = game.chosenWord
        }
        
        //go to new vc 
        //notification to try again
        //add sounds here?
    }
    
    static func getNewWord() {
        // new button should pop up? 
        // animation while everything clears / reloads
        let realm = try! Realm()
        let game = retrieveCurrentGame()
        
        let newWord = retrieveRandomWord(from: game.words)
        
        //reset appropriate game properties
        try! realm.write {
            game.chosenWord = newWord
            game.concealedWord = String(repeating: "___  ", count: newWord.characters.count)
            game.guessesSoFar = ""
            game.incorrectGuessCount = 0
        }
       //new word will be retrieved when
    }
    
    static func hasSufficientFunds() -> Bool {
        
        let price = ["galleons": 1,
                     "sickles": 2,
                     "knuts": 3]
        
        //grab current user balance
        let realm = try! Realm()
        let game = HangmanGameLogic.retrieveCurrentGame()
        let userGringottsAccount = game.player!.gringottsAccount!
        var currentUserBalance = ["galleons" : userGringottsAccount.galleons,
                                  "sickles" : userGringottsAccount.sickles,
                                  "knuts" : userGringottsAccount.knuts]
        
        if currentUserBalance["galleons"]! >= price["galleons"]! && currentUserBalance["sickles"]! >= price["sickles"]! && currentUserBalance["knuts"]! >= price["knuts"]! {
            
            // if check user balance is true then
            try! realm.write {
                userGringottsAccount.galleons -= price["galleons"]!
                userGringottsAccount.sickles -= price["sickles"]!
                userGringottsAccount.knuts -= price["knuts"]!
                
                game.incorrectGuessCount -= 1
                
                //change concealedWord
            }
            return true
        } else {
            return false
        }
    }
    
    static func revealRandomLetterIn(_ word: String) -> String {
        let realm = try! Realm()
        let game = HangmanGameLogic.retrieveCurrentGame()
        let chosenWord = game.chosenWord
        var updatedConcealedWord = ""
        
        
        
        
        return updatedConcealedWord
    }
    
    
}
