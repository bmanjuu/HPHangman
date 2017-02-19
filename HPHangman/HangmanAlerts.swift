//
//  HangmanAlerts.swift
//  HPHangman
//
//  Created by Betty Fung on 2/19/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import Foundation
import UIKit

struct HangmanAlerts {
    
    static func internetConnectionAlert() {
        
    }
    
    static func insufficientFunds() -> UIAlertController {
        let alertController = UIAlertController(title: "Oh no!", message: "Insufficient funds to buy a letter", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
        }
        
        alertController.addAction(okAction)
        
        return alertController
    }
    
    static func endGameAlert(_ gameStatus: Bool) -> UIAlertController {
        
        var alertText = ""
        let chosenWord = HangmanGameLogic.retrieveCurrentGame().chosenWord
        
        if gameStatus {
            alertText = "Cheers! You guessed \(chosenWord) correctly!"
        } else {
            alertText = "Fiddle sticks! The correct word was \(chosenWord)"
        }
        
        let alertController = UIAlertController(title: " ", message: "\(alertText)", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
        }
        
        alertController.addAction(okAction)
        
        return alertController

    }
    
}
