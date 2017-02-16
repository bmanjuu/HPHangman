//
//  HangmanGame.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation

struct HangmanGameLogic {
    
    let store = GameDataStore.sharedInstance
    
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
    
    
    // during game
    static func isValidInput(_ input: String, for secretWord: String) -> Bool {
        
        let validLetters = CharacterSet.letters
        let userInput = input.replacingOccurrences(of: " ", with: "")
        
        //check that input only contains letters
        if (userInput.trimmingCharacters(in: validLetters) != "") {
            print("invalid characters in string")
            return false
        }
        
        //check that input is either 1 letter or a guess for whole word
        if userInput.characters.count == 1 || userInput.characters.count == secretWord.characters.count {
            return true
        } else {
            print("guess should only be 1 letter or for the whole word. please type in your guess again")
        }
        
        return false
    }
    
    static func playGame(userInput: String, secretWord: String) {
        let userGuess = userInput.uppercased()
        print("user guess modified: \(userGuess)")
        
        if userGuess == secretWord {
            // wonGame()
        } else if secretWord.contains(userGuess) {
            // correctGuess()
            var matchedLetterIndices = [Int]()
            for (index, letter) in secretWord.characters.enumerated() {
                if String(letter) == userGuess {
                    matchedLetterIndices.append(index)
                }
            }
            
            for i in matchedLetterIndices {
                //replace ___ with letters 
            }
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
    
    static func correctGuess()  {
        //update label to show letter
        //replace occurrences of letter with input
        var updatedString = ""
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
