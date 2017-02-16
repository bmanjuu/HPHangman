//
//  HangmanGame.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation

struct HangmanGameLogic {
    // let player: User
    // let maxGuesses: Int = 6
    let store = GameDataStore.sharedInstance
    var words: [String]
    
    func retrieveRandomWord() -> String {
        var word = ""
        
        wordListAPIClient.retrieveWords({ (words, error) in
            print("called api client")
            self.store.words = words
            print(self.store.words.count)
        })
        
        
        
        return word
    }
}
