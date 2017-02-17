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
        
        let chosenWord = retrieveCurrentGame().chosenWord
        
        let validLetters = CharacterSet.letters
        let userInput = input.replacingOccurrences(of: " ", with: "") //perhaps just replace one at the end
        
        //check that input only contains letters
        if (userInput.trimmingCharacters(in: validLetters) != "") {
            print("invalid characters in string")
            return false
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
            // incorrectGuess()
        }
    }
    
    static func buyALetter() {
        //cost: 2 sickles
    }
    
    static func incorrectGuess() {
        //update label about incorrect guesses
        //add letter to incorrect guess array
    }
    
    static func correctGuess(userGuess: String) {
        //check if guess is a letter or word?
        let chosenWord = retrieveCurrentGame().chosenWord
        let concealedWord = retrieveCurrentGame().concealedWord
        
        var concealedWordArray = concealedWord.components(separatedBy: "  ") //there are 2 spaces between each underscore
        
        // check if input letter matches letters in secretWord
        for (index, letter) in chosenWord.characters.enumerated() {
            if String(letter) == userGuess {
                concealedWordArray[index] = "  \(letter)  "
            }
        }
        
        //check to see if there are any underscores left
        if !concealedWordArray.contains("___") {
            wonGame()
        }
        
        updateConcealedWord(to: concealedWordArray.joined(separator: "  "))
        
        // instead of returning, should it just call the update view function?
    }
    
    static func updateConcealedWord(to word: String)  {
        
        let previousConcealedWord = HangmanGameLogic.retrieveCurrentGame().concealedWord
        let realm = try! Realm()
        let currentGame = HangmanGameLogic.retrieveCurrentGame()
        
        try! realm.write {
            currentGame.concealedWord = word
        }
        
        print("concealed word has been updated from: \(previousConcealedWord)")
    }
    
    // after game ends
    static func wonGame() {
        //money earned based on number of guesses used to win game
        //1 guess: 10 galleons, 20 sickles, and 50 knuts
        //2: 5 galleons, 20 sickles, 30 knuts
        //3:
        //4:
        //5:
        //6:
    }
    
    static func lostGame() {
        
    }
}
