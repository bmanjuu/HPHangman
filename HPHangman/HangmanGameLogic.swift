//
//  HangmanGame.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation

struct HangmanGameLogic {
    
    static let selectedWord = GameDataStore.sharedInstance.selectedWord
    static var concealedWord = GameDataStore.sharedInstance.concealedWord
    
    // before the game starts
    static func retrieveRandomWord(from words: [String]) -> String {
        var randomWord = ""
        
        repeat {
            print("random word: \(randomWord), count: \(randomWord.characters.count)")
            let randomIndex = Int(arc4random_uniform(UInt32(words.count-1)))
            randomWord = words[randomIndex].uppercased()
        } while randomWord.characters.count < 3 || randomWord.characters.count > 8 || randomWord.contains(" ")
        
        return randomWord
    }
    
    //initialize User and Gringotts account
    
    
    // during game
    static func isValidInput(_ input: String) -> Bool {
        
        let validLetters = CharacterSet.letters
        let userInput = input.replacingOccurrences(of: " ", with: "") //in case they have extra spaces? perhaps just replace one at the end
        
        //check that input only contains letters
        if (userInput.trimmingCharacters(in: validLetters) != "") {
            print("invalid characters in string")
            return false
        }
        
        //check that input is either 1 letter or a guess for whole word
        if userInput.characters.count == 1 || userInput.characters.count == GameDataStore.sharedInstance.selectedWord.characters.count {
            return true
        } else {
            print("guess should only be 1 letter or for the whole word. please type in your guess again")
        }
        
        return false
    }
    
    static func playGame(with userInput: String) {
        
        let userGuess = userInput.uppercased()
//        let selectedWord = GameDataStore.sharedInstance.selectedWord
//        let concealedWord = GameDataStore.sharedInstance.concealedWord
        print("user guess modified: \(userGuess)")
        
        if userGuess == self.selectedWord {
            // wonGame()
        } else if self.selectedWord.contains(userGuess) {
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
        
        var concealedWordArray = self.concealedWord.components(separatedBy: "  ") //there are 2 spaces between each underscore
        
        //check if input letter matches letters in secretWord
        for (index, letter) in self.selectedWord.characters.enumerated() {
            if String(letter) == userGuess {
                concealedWordArray[index] = "  \(letter)  "
            }
        }
        
        //check to see if there are any underscores left
        if !concealedWordArray.contains("___") {
            wonGame()
        }
        
        let updatedString = concealedWordArray.joined()
        // return updatedString
        //instead of returning, should it just call the update view function?
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
