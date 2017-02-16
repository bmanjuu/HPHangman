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
        let randomIndex = Int(arc4random_uniform(UInt32(words.count)))
        return words[randomIndex]
    }
    
    // during game 
    
    // after game ends
}
