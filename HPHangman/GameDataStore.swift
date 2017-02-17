//
//  DataStore.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation

final class GameDataStore {
    static let sharedInstance = GameDataStore()
    private init() {}
    
    // let user: User = User(name: "", gringottsAccount: GringottsAccount(owner: User(name: "")))
    
    var words: [String] = []
    var selectedWord = ""
    var concealedWord = ""
    
    let maxIncorrectGuesses: Int = 6
    var incorrectGuessCount: Int = 0 
    
    func populateWordsInStore() {
        wordListAPIClient.retrieveWords { (words, error) in
            self.words = words
            print("inside completion: \(self.words.count)")
        }
    }
}
