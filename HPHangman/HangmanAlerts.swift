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
    
    static func insufficientFundsAlert() {
        let alertController = UIAlertController(title: "Oh no!", message: "Insufficient funds to buy a letter", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
        }
        
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    static func endGameAlert(gameWon: Bool) -> UIAlertController {
        
        print("end game alert called")
        
        var alertText = ""
        let chosenWord = HangmanGameLogic.retrieveCurrentGame().chosenWord
        
        if gameWon {
            alertText = "Brilliant! \n\(chosenWord) was correct!"
        } else {
            alertText = "Fiddle sticks! \nThe correct word was \(chosenWord)"
        }
        
        let alertController = UIAlertController(title: " ", message: "\(alertText)", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (_) in
            HangmanGameVC().present(HangmanGameResultsViewController(), animated: true, completion: nil)
        }
        
        
        alertController.addAction(okAction)
        
        print("alert text: \(alertText)")
        
        // UIApplication.shared.keyWindow?.present(alertController, animated: true, completion: nil)
        print("end of alert")
        
        return alertController

    }
    
}
