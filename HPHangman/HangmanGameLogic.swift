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
        
        if guessesSoFar.contains(userInput) {
            print("guessed \(userInput) already")
            return false
        } else {
            try! realm.write {
                currentGame.guessesSoFar.append(userInput)
            }
            print(currentGame.guessesSoFar)
        }
        
        //check that input is either 1 letter or a guess for whole word
        if userInput.characters.count == 1 || userInput.characters.count == chosenWord.characters.count {
            return true
        } else {
            print("guess should only be 1 letter or for the whole word. please type in your guess again")
        }
        
        return false
    }
    
    static func playGame(with userInput: String) {
        
        let userGuess = userInput.uppercased()
        let chosenWord = retrieveCurrentGame().chosenWord
        print("user guess modified: \(userGuess)")
        
        if userGuess == chosenWord {
            // wonGame()
        } else if chosenWord.contains(userGuess) {
            correctGuess(userGuess: userGuess)
        } else {
            incorrectGuess()
        }
    }
    
    static func buyALetter() {
        //cost: 2 sickles
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
        
        //check to see if there are any underscores left
        if !concealedWordArray.contains("___") {
            print("won game!")
            wonGame()
        }
        
        updateConcealedWord(to: concealedWordArray.joined(separator: "  "))
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
        
        let numberOfIncorrectGuesses = retrieveCurrentGame().incorrectGuessCount
        let playerAccount = retrieveCurrentGame().player!.gringottsAccount!
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
            playerAccount.galleons += winningsEarned["galleons"]!
            playerAccount.sickles += winningsEarned["sickles"]!
            playerAccount.knuts += winningsEarned["knuts"]!
        }
        
        print("galleons: \(playerAccount.galleons), sickles: \(playerAccount.sickles), knuts: \(playerAccount.knuts)")
        //notification for congratulations and to play again
        //add sounds here?
    }
    
    static func lostGame() {
        print("Oh no! Harry was discovered by Voldemort!")
        //notification to try again
        //add sounds here?
    }
    
    static func startNewGame() {
        // new button should pop up? 
        // animation while everything clears / reloads
//        clear chosenWord, concealedWord, guessesSoFar, incorrectGuessCount
    }
}
