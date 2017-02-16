//
//  HangmanGame.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation

struct HangmanGameLogic {
    
    static func retrieveRandomWord(from words: [String]) -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(words.count)))
        return words[randomIndex]
    }
    
    
    //set up views for letters ... label with "_" repeating for number of words
    //work on counting guesses
    //MONIES
    //levels 
    //images and make it perdy
}
