//
//  HangmanGameResultsViewController.swift
//  HPHangman
//
//  Created by Betty Fung on 2/17/17.
//  Copyright © 2017 Betty Fung. All rights reserved.
//

import UIKit
import RealmSwift

class HangmanGameResultsViewController: UIViewController {
    
    public var gameStatus: Bool?
    
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var resultsImage: UIImageView!
    @IBOutlet weak var resultsTextLabel: UILabel!
    @IBOutlet weak var displayWinningsLabel: UILabel!
    @IBOutlet weak var wizardingDenominationsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        gameStatus = HangmanGameLogic.retrieveCurrentGame().wonGame
        
        if gameStatus! {
            BackgroundMusic.playSong("Win")
        } else {
            BackgroundMusic.playSong("Lose")
        }
 
        // self.resultsTextLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        self.playAgainButton.titleLabel?.minimumScaleFactor = 0.5
        self.playAgainButton.titleLabel?.numberOfLines = 0
        self.playAgainButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let userGringottsAccount = HangmanGameLogic.retrieveCurrentGame().player!.gringottsAccount!

        if gameStatus! {
            self.resultsImage.image = UIImage(named: "hpWonGame")
            self.resultsTextLabel.text = "HOORAY! 🎉\nYou saved Harry and the Wizarding World from the wrath of Lord Voldemort! \nThe Ministry of Magic has awarded you with:"
            self.displayWinningsLabel.text = "\(userGringottsAccount.galleons)\n\(userGringottsAccount.sickles)\n\(userGringottsAccount.knuts)"
        } else {
            self.resultsImage.image = UIImage(named: "hpLostGame")
            self.resultsTextLabel.text = "AHHHHH! 😱\nVoldemort got a hold of Harry! \nYou still have another chance to save him! \nWould you like to play again?"
            self.displayWinningsLabel.text = "\(userGringottsAccount.galleons)\n\(userGringottsAccount.sickles)\n\(userGringottsAccount.knuts)"
        }
        
    }
    
    @IBAction func playAgainButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "playAgain", sender:nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let realm = try! Realm()
        let game = HangmanGameLogic.retrieveCurrentGame()
        
        try! realm.write {
            //resetting values
            game.chosenWord = ""
            game.concealedWord = ""
            game.incorrectGuessCount = 0
            game.guessesSoFar = ""
            game.wonGame = false
        }
        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
