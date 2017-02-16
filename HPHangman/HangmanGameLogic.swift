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
            let randomIndex = Int(arc4random_uniform(UInt32(words.count)))
            randomWord = words[randomIndex].uppercased()
        } while randomWord.characters.count < 3 && randomWord.characters.count > 8
        
        return randomWord
    }
    
    // during game 
    
    // after game ends
}
