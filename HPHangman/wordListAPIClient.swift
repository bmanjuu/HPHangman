//
//  wordListAPIClient.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation

struct wordListAPIClient {
    
    let store = GameDataStore.sharedInstance
    
    private enum wordListAPIError: Error {
        case invalidResponse
        case noDataAvailable
        case invalidDataConversion
    }
    
    typealias wordCompletion = ([String], Error?) -> ()
    
    static func retrieveWords(_ completion: @escaping wordCompletion) {
        
        let session = URLSession(configuration: .default)
        let baseURL = URL(string: "http://linkedin-reach.hagbpyjegb.us-west-2.elasticbeanstalk.com/words")
        
        let dataTask = session.dataTask(with: baseURL!, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                print("\(wordListAPIError.invalidResponse): could not get words from word dictionary API")
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
                let words = responseWords.components(separatedBy: "\n")
                //self.store.words = responseWords.components(separatedBy: "\n")
                completion(words, nil)
            } catch {
                print("\(wordListAPIError.invalidResponse): could not get words from word dictionary API")
                completion([String](), wordListAPIError.invalidResponse)
            }
        })
        dataTask.resume()
    }
    
    
}
