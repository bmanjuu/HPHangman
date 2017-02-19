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

    @IBOutlet weak var gringottsAccountBalance: UILabel!

    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var secretWordLabel: UILabel!
    
    @IBOutlet weak var guessesLabel: UILabel!
    @IBOutlet weak var chancesLabel: UILabel!
    
    static var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        BackgroundMusic.playSong("DuringGameplay")
        
        let realm = try! Realm()
        let game = HangmanGameLogic.retrieveCurrentGame()
        let words = game.words
        let chosenWord = HangmanGameLogic.retrieveRandomWord(from: words)
        
        try! realm.write {
            game.chosenWord = chosenWord
            game.concealedWord = String(repeating: "___  ", count: game.chosenWord.characters.count)
        }
        
        print("THE CHOSEN ONE --> \(game.chosenWord)")
        
        self.secretWordLabel.text = game.concealedWord
        self.guessesLabel.text = game.guessesSoFar
        self.chancesLabel.text = "\(6-game.incorrectGuessCount)"
        self.gringottsAccountBalance.text = "galleons: \(game.player!.gringottsAccount!.galleons), sickles: \(game.player!.gringottsAccount!.sickles), knuts: \(game.player!.gringottsAccount!.knuts)"
    }
    
    @IBAction func guessButtonTapped(_ sender: Any) {
        let game = HangmanGameLogic.retrieveCurrentGame()
        
        let validInput = HangmanGameLogic.isValidInput(userInput.text!)
        
        if validInput {
            HangmanGameLogic.playGame(with: userInput.text!)
            self.guessesLabel.text = game.guessesSoFar
            self.chancesLabel.text = "\(6-game.incorrectGuessCount)"
            self.secretWordLabel.text = game.concealedWord
            
            if game.wonGame {
                self.secretWordLabel.textColor = UIColor.green
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
                    self.performSegue(withIdentifier: "presentResultsVC", sender:nil)
                }
                
            } else if game.incorrectGuessCount == 6 {
                self.secretWordLabel.textColor = UIColor.red
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
                    self.performSegue(withIdentifier: "presentResultsVC", sender:nil)
                }
            }

        } else {
            print("invalid input") //display error message
        }
        
        self.userInput.text = ""
    }

    
    @IBAction func buyALetterButtonTapped(_ sender: Any) {
        print("buy a letter button tapped")
        let game = HangmanGameLogic.retrieveCurrentGame()
        let userGringottsAccount = game.player!.gringottsAccount!
        
        if HangmanGameLogic.hasSufficientFunds() {
            print("has sufficient funds")
            HangmanGameLogic.revealRandomLetter()
            
            self.secretWordLabel.text = game.concealedWord
            self.gringottsAccountBalance.text = "galleons: \(userGringottsAccount.galleons), sickles: \(userGringottsAccount.sickles), knuts: \(userGringottsAccount.knuts)"
            
            if game.wonGame {
                self.secretWordLabel.textColor = UIColor.green
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
                    self.performSegue(withIdentifier: "presentResultsVC", sender:nil)
                }
            }
            
        } else {
            print("insufficient funds") //display error
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        BackgroundMusic.stopPlayingSong()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? HangmanGameResultsViewController
    }
    */

}
