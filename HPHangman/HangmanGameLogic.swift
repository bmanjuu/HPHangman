//
//  HangmanGame.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation

class HangmanGameLogic {
    // let player: User
    // let maxGuesses: Int = 6
    
    static func retrieveRandomWord() {
        print("called function to retrieve word")
        let session = URLSession(configuration: .default)
        
        let baseURL = URL(string: "http://linkedin-reach.hagbpyjegb.us-west-2.elasticbeanstalk.com/words")
        
        let dataTask = session.dataTask(with: baseURL!, completionHandler: { (data, response, error) in
            
            if let data = data {
                do {
                    let responseData = try NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    let words = responseData!.components(separatedBy: "\n")
                } catch {
                    print("error: could not get words from word dictionary API")
                }
            }
            
        })
        
        dataTask.resume()
    }
}
