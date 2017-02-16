//
//  HangmanGameVC.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit

class HangmanGameVC: UIViewController {
    
    let store = GameDataStore.sharedInstance
    public var hangmanConcealedWord: String = ""

    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var secretWordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let secretWord = self.store.selectedWord
        self.hangmanConcealedWord = String(repeating: " ___ ", count: secretWord.characters.count)
        print("secret word is: \(secretWord)")
        self.secretWordLabel.text = self.hangmanConcealedWord
    }
    
    @IBAction func guessButtonTapped(_ sender: Any) {
        
        //check number of guesses?
        
        if userInput.text?.characters.count == 0 {
            print("please enter a letter or word")
            return //error pop up?
        }
        
        let validInput = HangmanGameLogic.isValidInput(userInput.text!, for: self.store.selectedWord)
        
        if validInput {
            HangmanGameLogic.playGame(userInput: userInput.text!, secretWord: self.store.selectedWord)
        } else {
            print("invalid input") //display error message
        }
        
    }
    
    static func updateWord() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
