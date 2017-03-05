//
//  WordListAPIDataParser.swift
//  HPHangman
//
//  Created by Betty Fung on 3/2/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation
import RealmSwift

struct WordListAPIDataParser {
    
    static func parseWordResponseFrom(_ wordResponseArray: [[String:Any]], _ level: Int) -> String {
        var wordsAtThisLevel = ""
        var wordsAtThisLevelArray = [String]()
        
        for wordResponse in wordResponseArray {
            guard let words = wordResponse["option"] as? [String] else {
                print("invalid JSON cast to extract words from 'option'")
                return ""}
            wordsAtThisLevelArray.append(contentsOf: words)
        }
        
        wordsAtThisLevel = wordsAtThisLevelArray.joined(separator: "\n")
        return wordsAtThisLevel
    }
    
    static func useBackupWords() -> String {
        var backupWords = ""
        
        let path = Bundle.main.path(forResource: "HPHangman_Words", ofType: "txt")
        do {
            backupWords = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        } catch {
            print("ERROR: could not use backup words file")
        }
        
        print("backup words: \(backupWords)")
        return backupWords
    }
}
