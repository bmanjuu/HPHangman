//
//  HangmanGameVC.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit
import RealmSwift

class HangmanGameVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var duelLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var secretWordLabel: UILabel!
    @IBOutlet weak var guessesLabel: UILabel!
    @IBOutlet weak var chancesLabel: UILabel!
    @IBOutlet weak var knutsBalance: UILabel!
    @IBOutlet weak var sicklesBalance: UILabel!
    @IBOutlet weak var galleonsBalance: UILabel!
    @IBOutlet weak var stormyBackgroundImage: UIImageView!
    
    var game: Game!
    var displayAlert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.autoresizesSubviews = false 
        self.hideKeyboardWhenTappedAround()
        userInput.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        BackgroundMusic.playSong("DuringGameplay")
        self.startNewGame()
        self.setupViewForNewGame()
        
    }
    
    
    @IBAction func guessButtonTapped(_ sender: Any) {
        self.userInput.resignFirstResponder()
        let incorrectGuessCountBeforeTurn = game.incorrectGuessCount
        
        let validInput = game.isValidInput(userInput.text!, from: self)
        
        guard validInput else { userInput.text = ""; return }
        
        game.playGame(with: userInput.text!)
        self.guessesLabel.text = game.guessesSoFar
        self.chancesLabel.text = "\(6-game.incorrectGuessCount)"
        self.secretWordLabel.text = game.concealedWord
        
        if game.incorrectGuessCount > incorrectGuessCountBeforeTurn {
            self.hangmanImage.alpha -= 0.18
        }
        
        if game.wonGameStatus {
            self.secretWordLabel.textColor = UIColor.green
            displayAlert = HangmanAlerts.endGameAlert(wonGameStatus: true, chosenWord: game.chosenWord)
        } else if game.incorrectGuessCount == 6 {
            self.secretWordLabel.textColor = UIColor.red
            displayAlert = HangmanAlerts.endGameAlert(wonGameStatus: false, chosenWord: game.chosenWord)
        }
        
        if displayAlert != nil {
            let okButtonTapped = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("ok tapped")
                self.performSegue(withIdentifier: "presentResultsVC", sender: nil)
            }
            
            displayAlert!.addAction(okButtonTapped)
            self.present(displayAlert!, animated: true, completion: nil)
        }
        
        userInput.text = ""
    }
    
    
    @IBAction func buyALetterButtonTapped(_ sender: Any) {
        print("buy a letter button tapped")
        let userGringottsAccount = game.player!.gringottsAccount!
        
        if game.hasSufficientFunds() {
            print("has sufficient funds")
            game.revealRandomLetter()
            
            self.secretWordLabel.text = game.concealedWord
            self.galleonsBalance.text = "\(userGringottsAccount.galleons)"
            self.sicklesBalance.text = "\(userGringottsAccount.sickles)"
            self.knutsBalance.text = "\(userGringottsAccount.knuts)"
            
            //if buying/revealing the last letter, user wins game
            guard game.wonGameStatus else { return }
            
            self.secretWordLabel.textColor = UIColor.green
            displayAlert = HangmanAlerts.endGameAlert(wonGameStatus: true, chosenWord: game.chosenWord)
            if displayAlert != nil {
                let okButtonTapped = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("ok tapped")
                    self.performSegue(withIdentifier: "presentResultsVC", sender: nil)
                }
                
                displayAlert!.addAction(okButtonTapped)
                self.present(displayAlert!, animated: true, completion: nil)
            }
            
        } else {
            self.present(HangmanAlerts.insufficientFundsAlert(), animated: true, completion: nil)
        }
    }

    
    func startNewGame() {
        game.retrieveRandomWord(currentLevel: game.currentLevel)
    }
    
    func setupViewForNewGame() {
        
        self.scrollView.alwaysBounceVertical = false
        
        self.duelLabel.text = "Oh no... it's Deatheaters! Time to duel!"
        self.duelLabel.adjustsFontSizeToFitWidth = true
        
        self.userInput.layer.borderWidth = 1.0
        self.userInput.layer.borderColor = UIColor.blue.cgColor
        
        self.secretWordLabel.text = game.concealedWord
        self.guessesLabel.text = game.guessesSoFar
        self.chancesLabel.text = "\(6-game.incorrectGuessCount)"
        self.galleonsBalance.text = "\(game.player!.gringottsAccount!.galleons)"
        self.sicklesBalance.text = "\(game.player!.gringottsAccount!.sickles)"
        self.knutsBalance.text = "\(game.player!.gringottsAccount!.knuts)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        BackgroundMusic.stopPlayingSong()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//MARK: - Textfield Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.guessButtonTapped(textField)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let inputTextLength = textField.text!.characters.count + string.characters.count
        
        if inputTextLength > game.chosenWord.characters.count {
            return false
        } else {
            return true
        }
    }
    
    
    
// MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? HangmanGameResultsViewController
        destinationVC?.finishedGame = game
     }
    
    
}
