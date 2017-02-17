//
//  Game.swift
//  HPHangman
//
//  Created by Betty Fung on 2/17/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Game: Object {
    
    dynamic var player: User?
    
    dynamic var words: String = ""
    dynamic var chosenWord: String = ""
    dynamic var concealedWord: String = ""
    //keep track of old guesses, no repeats 
    
    dynamic var maxIncorrectGuesses: Int = 6
    dynamic var incorrectGuessCount: Int = 0
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    init(player: User, words: String, chosenWord: String, concealedWord: String, maxIncorrectGuesses: Int, incorrectGuessCount: Int) {
        super.init()
        self.player = player
        self.words = words
        self.chosenWord = chosenWord
        self.concealedWord = concealedWord
        self.maxIncorrectGuesses = maxIncorrectGuesses
        self.incorrectGuessCount = incorrectGuessCount
    }
    
}
