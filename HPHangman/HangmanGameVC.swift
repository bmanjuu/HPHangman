//
//  HangmanGameVC.swift
//  HPHangman
//
//  Created by Betty Fung on 2/16/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit
import RealmSwift

class HangmanGameVC: UIViewController {
    
    public var hangmanConcealedWord: String = ""

    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var secretWordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let realm = try! Realm()
        let game = HangmanGameLogic.retrieveCurrentGame()
        
        try! realm.write {
            game.concealedWord = String(repeating: " ___ ", count: game.chosenWord.characters.count)
        }

        self.secretWordLabel.text = game.concealedWord
    }
    
    @IBAction func guessButtonTapped(_ sender: Any) {
        //check number of guesses?
        
        if userInput.text?.characters.count == 0 {
            print("please enter a letter or word")
            return //error pop up?
        }
        
        let validInput = HangmanGameLogic.isValidInput(userInput.text!)
        
        if validInput {
            HangmanGameLogic.playGame(with: userInput.text!)
            self.secretWordLabel.text = HangmanGameLogic.retrieveCurrentGame().concealedWord
        } else {
            print("invalid input") //display error message
        }
        
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
