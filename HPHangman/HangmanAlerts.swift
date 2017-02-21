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
    
    static func insufficientFundsAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Oh no!", message: "Insufficient funds to buy a letter", preferredStyle: UIAlertControllerStyle.alert)
        
        let okButtonTapped = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK button tapped")
        }
        
        alertController.addAction(okButtonTapped)
        
        return alertController
    }
    
    static func endGameAlert(gameWon: Bool) -> UIAlertController {
        
        var alertText = ""
        let chosenWord = HangmanGameLogic.retrieveCurrentGame().chosenWord
        
        if gameWon {
            alertText = "Brilliant! \n\(chosenWord) was correct!"
        } else {
            alertText = "Fiddle sticks! \nThe correct word was \(chosenWord)"
        }
        
        let alertController = UIAlertController(title: " ", message: "\(alertText)", preferredStyle: UIAlertControllerStyle.alert)
        
        return alertController

    }
    
}
