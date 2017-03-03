//
//  wordListAPIClient.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation
import RealmSwift

struct WordListAPIClient {
    
    private enum wordListAPIError: Error {
        case invalidAPICall
        case noDataAvailable
        case invalidAPIResponse
    }
    
    typealias wordCompletion = (String, Error?) -> ()
    
    static func retrieveWords(forLevel: Int, _ completion: @escaping wordCompletion) {
        print("in function to retrieve words! WHEEE")
        
        let session = URLSession(configuration: .default)
        let baseURL = URL(string: "https://twinword-word-association-quiz.p.mashape.com/type1/?area=sat&level=\(forLevel)")
        var request = URLRequest(url: baseURL!)
        request.setValue(Secrets.key, forHTTPHeaderField: "X-Mashape-Key")
        
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                print("\(wordListAPIError.invalidAPICall): error calling word dictionary API")
                return
            }
            // IF THIS ERROR OCCURS, NEED TO CHECK INTERNET CONNECTION 
            
            guard let responseData = data else {
                print("\(wordListAPIError.noDataAvailable): no words/data from API call")
                return
            }
            print("DATA: \(responseData)")
            
            guard let response = response else {
                print("\(wordListAPIError.invalidAPIResponse): no words/response from API call")
                return
            }
            
            print("REPONSE: \(response)")
            
            
//            do {
//                guard let responseWords = try NSString(data: responseData, encoding: String.Encoding.utf8.rawValue) else {
//                    print("\(wordListAPIError.invalidDataConversion): could not convert reponse into a string")
//                    return
//                }
//                
//                completion(String(responseWords), nil)
//                
//            } catch {
//                print("\(wordListAPIError.invalidAPICall): could not get words from word dictionary API")
//                completion(String(), wordListAPIError.invalidAPICall)
//            }
        })
        dataTask.resume()
    }

}

//MARK: - from previous API
//let baseURL = URL(string: "http://linkedin-reach.hagbpyjegb.us-west-2.elasticbeanstalk.com/words?&difficulty=\(forLevel)")
//
//let dataTask = session.dataTask(with: baseURL!, completionHandler: { (data, response, error) in
//    
//    guard error == nil else {
//        print("\(wordListAPIError.invalidAPICall): error calling word dictionary API")
//        return
//    }
//    // IF THIS ERROR OCCURS, NEED TO CHECK INTERNET CONNECTION
//    
//    guard let responseData = data else {
//        print("\(wordListAPIError.noDataAvailable): no words/data from API call")
//        return
//    }
//    
//    do {
//        guard let responseWords = try NSString(data: responseData, encoding: String.Encoding.utf8.rawValue) else {
//            print("\(wordListAPIError.invalidDataConversion): could not convert reponse into a string")
//            return
//        }
//        
//        completion(String(responseWords), nil)
//        
//    } catch {
//        print("\(wordListAPIError.invalidAPICall): could not get words from word dictionary API")
//        completion(String(), wordListAPIError.invalidAPICall)
//    }
//})
//dataTask.resume()

