//
//  HangmanGame.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation

struct HangmanGameLogic {
    
    // before the game starts
    static func retrieveRandomWord(from words: [String]) -> String {
        var randomWord = ""
        
        repeat {
            print("random word: \(randomWord), count: \(randomWord.characters.count)")
            let randomIndex = Int(arc4random_uniform(UInt32(words.count-1)))
            randomWord = words[randomIndex].uppercased()
        } while randomWord.characters.count < 3 || randomWord.characters.count > 8
        
        return randomWord
    }
    
    // during game
    static func isValidInput(_ input: String) -> Bool {
        let validLetters = CharacterSet.letters
        print(validLetters)
        
//        switch input.characters.count {
//        case 1:
//            if validLetters.contains(input) {
//                return true
//            }
//        case >1:
//            print("hi")
//            
//        }
        return false
    }
    
    static func playGame(secretWord: String, userInput: String) {
        //when assessing user guess, must take out all spaces
        //no invalid characters, must be alphabet 
        //make uppercase 
        //assess length -- if letter or attempt to guess word 
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
