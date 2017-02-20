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
    
    static func invalidInputAlert() {
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.duration = 0.07
//        animation.repeatCount = 4
//        animation.autoreverses = true
//        animation.fromValue = NSValue(CGPoint: CGPointMake(txtField.center.x - 10, txtField.center.y))
//        animation.toValue = NSValue(CGPoint: CGPointMake(txtField.center.x + 10, txtField.center.y))
    }
    
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
        
        print("end game alert called")
        
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
    
    static func internetConnectionAlert() {
        
    }
    
}
