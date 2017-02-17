//
//  wordListAPIClient.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation
import RealmSwift

struct wordListAPIClient {
    
    private enum wordListAPIError: Error {
        case invalidAPICall
        case noDataAvailable
        case invalidDataConversion
    }
    
    typealias wordCompletion = (String, Error?) -> ()
    
    static func retrieveWords(_ completion: @escaping wordCompletion) {
        print("in function to retrieve words! WHEEE")
        
        let session = URLSession(configuration: .default)
        let baseURL = URL(string: "http://linkedin-reach.hagbpyjegb.us-west-2.elasticbeanstalk.com/words")
        
        let dataTask = session.dataTask(with: baseURL!, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                print("\(wordListAPIError.invalidAPICall): error calling word dictionary API")
                return
            }
            
            guard let responseData = data else {
                print("\(wordListAPIError.noDataAvailable): no words/data from API call")
                return
            }
            
            do {
                guard let responseWords = try NSString(data: responseData, encoding: String.Encoding.utf8.rawValue) else {
                    print("\(wordListAPIError.invalidDataConversion): could not convert reponse into a string")
                    return
                }
                
                if let realm = try? Realm() {
                    let gameResults = realm.objects(Game.self)
                    let game = gameResults[0]
                    
                    try! realm.write {
                        game.words = String(responseWords)
                        print("\(game.words.components(separatedBy: "\n").count)")
                        print("added words from API response")
                    }
                }
                completion(String(responseWords), nil)
                
            } catch {
                print("\(wordListAPIError.invalidAPICall): could not get words from word dictionary API")
                completion(String(), wordListAPIError.invalidAPICall)
            }
        })
        dataTask.resume()
    }
    
    
}
