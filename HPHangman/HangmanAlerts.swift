//
//  HangmanAlerts.swift
//  HPHangman
//
//  Created by Betty Fung on 2/19/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

struct HangmanAlerts {
    
    static func enterName() -> UIAlertController {
        let alertController = UIAlertController(title: "Whoops!", message: "Please enter your name", preferredStyle: UIAlertControllerStyle.alert)
        
        let okButtonTapped = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK button tapped")
        }
        
        alertController.addAction(okButtonTapped)
        
        return alertController
    }

    static func invalidGuess() -> UIAlertController {
        let alertController = UIAlertController(title: "Whoops!", message: "Please enter a letter or a word", preferredStyle: UIAlertControllerStyle.alert)
        
        let okButtonTapped = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK button tapped")
        }
        
        alertController.addAction(okButtonTapped)
        
        return alertController
    }

    
    static func duplicateGuess() -> UIAlertController {
        let alertController = UIAlertController(title: "Whoops!", message: "You've guessed that already! Try again", preferredStyle: UIAlertControllerStyle.alert)
        
        let okButtonTapped = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK button tapped")
        }
        
        alertController.addAction(okButtonTapped)
        
        return alertController
        
    }
    
    
    static func insufficientFundsAlert(price: [String: Int]) -> UIAlertController {
        
        let alertController = UIAlertController(title: "Uh oh", message: "Purchasing a letter at this level requires at least \(price["galleons"]!) galleons, \(price["sickles"]!) sickles, and \(price["knuts"]!) knuts :(", preferredStyle: UIAlertControllerStyle.alert)
        
        let okButtonTapped = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK button tapped")
        }
        
        alertController.addAction(okButtonTapped)
        
        return alertController
    }
    
//    static func aurorAlert(playerName: String) -> UIAlertController {
//        let alertController = UIAlertController(title: "BONUS ROUND", message: "You are now entering", preferredStyle: UIAlertControllerStyle.alert)
//        
//        let okButtonTapped = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//            (result : UIAlertAction) -> Void in
//            print("OK button tapped")
//        }
//        
//        alertController.addAction(okButtonTapped)
//        
//        return alertController
//    }
    
    static func endGameAlert(wonGameStatus: Bool, chosenWord: String) -> UIAlertController {
        
        var alertTitle = ""
        var alertText = ""
        
        if wonGameStatus {
            alertTitle = "Brilliant!"
            alertText = "\(chosenWord) was correct!"
        } else {
            alertTitle = "Fiddle sticks!"
            alertText = "The correct word was \(chosenWord)"
        }
        
        let alertController = UIAlertController(title: "\(alertTitle)", message: "\(alertText)", preferredStyle: UIAlertControllerStyle.alert)
        
        return alertController

    }
    
}
